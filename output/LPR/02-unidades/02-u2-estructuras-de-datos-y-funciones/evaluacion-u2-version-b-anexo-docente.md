# Anexo docente — Evaluación de la Unidad 2 — Encuentro 15 — Versión B

> Documento docente formal. Solución completa, salidas de referencia y criterios de corrección para la versión B (taller de escuela).

## 1. Solución completa (`taller.py`)

```python
# taller.py — Gestion de herramientas de un taller de escuela
# Evaluacion U2 — Version B
# Permite listar herramientas, registrar pago de deposito, agregar herramientas y ver estadisticas

# Lista de herramientas del taller
# Cada herramienta es un dict con toolName, toolCondition, feePaid (bool)
tool_list = [
    {"toolName": "Martillo",   "toolCondition": "Bueno",   "feePaid": True},
    {"toolName": "Destornillador", "toolCondition": "Regular", "feePaid": False},
    {"toolName": "Alicate",    "toolCondition": "Bueno",   "feePaid": True},
    {"toolName": "Sierra",     "toolCondition": "Malo",    "feePaid": False}
]


def list_members():
    # Muestra todas las herramientas con su estado de deposito
    print()
    print("=== LISTA DE HERRAMIENTAS ===")
    print(f"{'Nombre':<20} {'Estado':<12} {'Deposito':<10}")
    print("-" * 45)
    for tool in tool_list:
        status = "Al dia" if tool["feePaid"] else "Debe"
        print(f"{tool['toolName']:<20} {tool['toolCondition']:<12} {status:<10}")


def find_member(name):
    # Busca una herramienta por nombre (insensible a mayusculas)
    # Devuelve el diccionario de la herramienta o None si no existe
    name_lower = name.strip().lower()
    for tool in tool_list:
        if tool["toolName"].strip().lower() == name_lower:
            return tool
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
    # Marca el deposito como pagado para una herramienta
    print()
    print("=== PAGAR DEPOSITO ===")
    name = read_str("Nombre de la herramienta: ")
    tool = find_member(name)
    if tool is None:
        print("Herramienta no encontrada.")
        return
    if tool["feePaid"]:
        print("La herramienta ya tiene el deposito al dia.")
    else:
        tool["feePaid"] = True
        print(f"Deposito registrado como pagado para {tool['toolName']}.")


def add_member():
    # Agrega una nueva herramienta a la lista
    print()
    print("=== AGREGAR HERRAMIENTA ===")
    name = read_str("Nombre de la herramienta: ")
    if find_member(name) is not None:
        print("Ya existe una herramienta con ese nombre.")
        return
    condition = read_str("Estado de la herramienta (Bueno/Regular/Malo): ")
    tool_list.append({
        "toolName": name,
        "toolCondition": condition,
        "feePaid": False
    })
    print(f"Herrramienta {name} agregada correctamente.")


def show_stats():
    # Muestra estadisticas de depositos del taller
    print()
    print("=== ESTADISTICAS DEL TALLER ===")
    total = len(tool_list)
    paid = sum(1 for t in tool_list if t["feePaid"])
    pending = total - paid
    print(f"Total de herramientas: {total}")
    print(f"Pagaron el deposito: {paid}")
    print(f"Herrramientas que deben: {pending}")


def active_members():
    # Muestra solo las herramientas con deposito al dia
    print()
    print("=== HERRAMIENTAS CON DEPOSITO AL DIA ===")
    active = [t for t in tool_list if t["feePaid"]]
    if not active:
        print("No hay herramientas con deposito al dia.")
        return
    print(f"{'Nombre':<20} {'Estado':<12}")
    print("-" * 35)
    for t in active:
        print(f"{t['toolName']:<20} {t['toolCondition']:<12}")


if __name__ == "__main__":
    # Bloque de ejecucion principal (spike 9.10)
    print("=== SISTEMA DE GESTION DEL TALLER ===")
    running = True

    while running:
        print()
        print("1. Listar herramientas")
        print("2. Pagar deposito")
        print("3. Agregar herramienta")
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
- La lista `toolList` puede llamarse `tools`.
- Función `active_members` puede integrarse en `show_stats`.
- La comprobación de herramienta existente en `add_member` puede hacerse con un bucle manual en lugar de reusar `find_member`.
- El menú puede usar `== "1"` sin espacios; el `while True` con `break` es aceptable (aunque se prefiere la bandera `running`).

## 2. Salidas de referencia

| Prueba | Entrada | Salida esperada |
| --- | --- | --- |
| Listar | `1` | Tabla con 4 herramientas, su estado y depósito |
| Pagar depósito (Martillo) | `2`, `Martillo` | "Deposito registrado como pagado para Martillo." |
| Pagar depósito (Martillo otra vez) | `2`, `Martillo` | "La herramienta ya tiene el depósito al día." |
| Pagar (inexistente) | `2`, `Pinza` | "Herramienta no encontrada." |
| Agregar herramienta | `3`, `Llave Inglesa`, `Bueno` | "Herramienta Llave Inglesa agregada correctamente." |
| Agregar repetido | `3`, `Llave Inglesa`, `Regular` | "Ya existe una herramienta con ese nombre." |
| Estadísticas | `4` | "Total de herramientas: 5, Pagaron: 3, Deben: 2" + activos |

## 3. Criterios de corrección

| Ítem | Pts | Puntúa | No puntúa | Error previsto |
| --- | --- | --- | --- | --- |
| 1a — toolList | 10 | 4+ herramientas como dicts | Datos específicos | Listas paralelas sin dict → descontar 3 pts |
| 1b — list_members | 10 | Itera y muestra todas | Formato exacto | No muestra depósito → descontar 5 pts |
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
