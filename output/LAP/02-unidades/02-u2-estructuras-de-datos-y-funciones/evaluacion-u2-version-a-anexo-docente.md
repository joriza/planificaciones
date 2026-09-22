# Anexo docente — Evaluación de la Unidad 2 — Encuentro 15 — Versión A

> Documento docente formal. Solución completa, salidas de referencia y criterios de corrección.

## 1. Solución completa (`club.py`)

```python
# club.py — Gestion de socios de un club de barrio
# Evaluacion U2 — Version A
# Permite listar socios, registrar pago de cuota, agregar socios y ver estadisticas

# Lista de socios del club
# Cada socio es un dict con memberName, memberAge, feePaid (bool)
member_list = [
    {"memberName": "Ana Lopez",   "memberAge": 17, "feePaid": True},
    {"memberName": "Luis Perez",  "memberAge": 16, "feePaid": False},
    {"memberName": "Sofia Ruiz",  "memberAge": 15, "feePaid": True},
    {"memberName": "Carlos Diaz", "memberAge": 18, "feePaid": False}
]


def list_members():
    # Muestra todos los socios con su estado de cuota
    print()
    print("=== LISTA DE SOCIOS ===")
    print(f"{'Nombre':<20} {'Edad':<6} {'Cuota':<10}")
    print("-" * 40)
    for member in member_list:
        status = "Al dia" if member["feePaid"] else "Debe"
        print(f"{member['memberName']:<20} {member['memberAge']:<6} {status:<10}")


def find_member(name):
    # Busca un socio por nombre (insensible a mayusculas)
    # Devuelve el diccionario del socio o None si no existe
    name_lower = name.strip().lower()
    for member in member_list:
        if member["memberName"].strip().lower() == name_lower:
            return member
    return None


def read_str(message):
    # Pide un texto no vacio
    while True:
        value = input(message).strip()
        if value:
            return value
        print("El texto no puede estar vacio.")


def read_int(message):
    # Pide un numero entero con validacion (spike 9.1)
    while True:
        try:
            return int(input(message))
        except ValueError:
            print("Eso no es un numero entero; intenta de nuevo.")


def pay_fee():
    # Marca la cuota como pagada para un socio
    print()
    print("=== PAGAR CUOTA ===")
    name = read_str("Nombre del socio: ")
    member = find_member(name)
    if member is None:
        print("Socio no encontrado.")
        return
    if member["feePaid"]:
        print("El socio ya tiene la cuota al dia.")
    else:
        member["feePaid"] = True
        print(f"Cuota registrada como pagada para {member['memberName']}.")


def add_member():
    # Agrega un nuevo socio a la lista
    print()
    print("=== AGREGAR SOCIO ===")
    name = read_str("Nombre del socio: ")
    if find_member(name) is not None:
        print("Ya existe un socio con ese nombre.")
        return
    age = read_int("Edad del socio: ")
    member_list.append({
        "memberName": name,
        "memberAge": age,
        "feePaid": False
    })
    print(f"Socio {name} agregado correctamente.")


def show_stats():
    # Muestra estadisticas de cuotas del club
    print()
    print("=== ESTADISTICAS DEL CLUB ===")
    total = len(member_list)
    paid = sum(1 for m in member_list if m["feePaid"])
    pending = total - paid
    print(f"Total de socios: {total}")
    print(f"Pagaron la cuota: {paid}")
    print(f"Socios que deben: {pending}")


def active_members():
    # Muestra solo los socios con cuota al dia
    print()
    print("=== SOCIOS CON CUOTA AL DIA ===")
    active = [m for m in member_list if m["feePaid"]]
    if not active:
        print("No hay socios con cuota al dia.")
        return
    print(f"{'Nombre':<20} {'Edad':<6}")
    print("-" * 30)
    for m in active:
        print(f"{m['memberName']:<20} {m['memberAge']:<6}")


if __name__ == "__main__":
    # Bloque de ejecucion principal (spike 9.10)
    print("=== SISTEMA DE GESTION DEL CLUB ===")
    running = True

    while running:
        print()
        print("1. Listar socios")
        print("2. Pagar cuota")
        print("3. Agregar socio")
        print("4. Mostrar estadisticas")
        print("5. Salir")
        option = input("Elegi una opcion: ")

        if option == "1":
            list_members()
        elif option == "2":
            pay_fee()
        elif option == "3":
            add_member()
        elif option == "4":
            show_stats()
            active_members()
        elif option == "5":
            running = False
            print("Saludos!")
        else:
            print("Opcion invalida.")
```

**Aceptaciones válidas menores:**
- La lista `memberList` puede llamarse `members`.
- Función `active_members` puede integrarse en `show_stats`.
- La comprobación de socio existente en `add_member` puede hacerse con un bucle manual en lugar de reusar `find_member`.
- El menú puede usar `== "1"` sin espacios; el `while True` con `break` es aceptable (aunque se prefiere la bandera `running`).

## 2. Salidas de referencia

| Prueba | Entrada | Salida esperada |
| --- | --- | --- |
| Listar | `1` | Tabla con 4 socios, sus edades y estado de cuota |
| Pagar cuota (Luis Perez) | `2`, `Luis Perez` | "Cuota registrada como pagada para Luis Perez." |
| Pagar cuota (Luis otra vez) | `2`, `Luis Perez` | "El socio ya tiene la cuota al dia." |
| Pagar (inexistente) | `2`, `Juan` | "Socio no encontrado." |
| Agregar socio | `3`, `Maria`, `16` | "Socio Maria agregado correctamente." |
| Agregar repetido | `3`, `Maria`, `17` | "Ya existe un socio con ese nombre." |
| Estadísticas | `4` | "Total de socios: 5, Pagaron: 3, Deben: 2" + activos |

## 3. Criterios de corrección

| Ítem | Pts | Puntúa | No puntúa | Error previsto |
| --- | --- | --- | --- | --- |
| 1a — memberList | 10 | 4+ socios como dicts | Datos específicos | Listas paralelas sin dict → descontar 3 pts |
| 1b — list_members | 10 | Itera y muestra todos | Formato exacto | No muestra cuota → descontar 5 pts |
| 1c — find_member | 10 | Parámetro name, return dict o None | Nombre exacto de la función | Devuelve índice en lugar de dict → descontar 5 pts |
| 2a — Menú | 5 | 5 opciones, while | Diseño exacto | Menos de 5 opciones → descontar 2 pts |
| 2b — pay_fee | 15 | Busca, verifica, actualiza feePaid | Nombres | No verifica si ya pagó → descontar 5 pts |
| 2c — add_member | 15 | Valida duplicado, agrega | validación exacta | No valida duplicado → descontar 5 pts |
| 2d — Opción inválida | 5 | Mensaje y retorno | Mensaje exacto | Crashing → 0 pts |
| 3a — show_stats | 10 | Cuenta total, pagaron, deben | Cálculo exacto | No separa pagados/deudores → descontar 5 pts |
| 3b — active_members | 10 | Filtra feePaid=True | | Filtra incorrectamente → descontar 5 pts |
| 4a — Ventaja dict | 5 | Menciona legibilidad o acceso por clave | Explicación extensa | Dice "ninguna" → 0 pts |
| 4b — return implícito | 5 | "None" | Explicación | Dice "error" → 0 pts |

## 4. Devolución

Encuentro 16. Menos de 60 pts → recuperación al inicio del encuentro 17.