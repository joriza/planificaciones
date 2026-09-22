# Anexo docente — Evaluación de la Unidad 2 — Encuentro 15 — Versión B

> Documento docente formal. Solución completa, salidas de referencia y criterios de corrección.

## 1. Solución completa (`taller.py`)

```python
# taller.py — Gestion de herramientas de un taller escolar
# Evaluacion U2 — Version B
# Permite listar herramientas, registrar deposito, agregar y ver estadisticas

# Lista de herramientas del taller
# Cada herramienta es un dict con toolName, toolCondition, depositPaid (bool)
tool_list = [
    {"toolName": "Martillo",      "toolCondition": "Buena", "depositPaid": True},
    {"toolName": "Llave inglesa", "toolCondition": "Buena", "depositPaid": False},
    {"toolName": "Destornillador","toolCondition": "Regular", "depositPaid": True},
    {"toolName": "Sierra",         "toolCondition": "Buena", "depositPaid": False}
]


def list_tools():
    # Muestra todas las herramientas con su estado de deposito
    print()
    print("=== LISTA DE HERRAMIENTAS ===")
    print(f"{'Nombre':<20} {'Estado':<12} {'Deposito':<10}")
    print("-" * 45)
    for tool in tool_list:
        status = "Pagado" if tool["depositPaid"] else "Pendiente"
        print(f"{tool['toolName']:<20} {tool['toolCondition']:<12} {status:<10}")


def find_tool(name):
    # Busca una herramienta por nombre (insensible a mayusculas)
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
    # Pide un numero entero con validacion
    while True:
        try:
            return int(input(message))
        except ValueError:
            print("Eso no es un numero entero; intenta de nuevo.")


def pay_deposit():
    # Marca el deposito como pagado para una herramienta
    print()
    print("=== PAGAR DEPOSITO ===")
    name = read_str("Nombre de la herramienta: ")
    tool = find_tool(name)
    if tool is None:
        print("Herramienta no encontrada.")
        return
    if tool["depositPaid"]:
        print("La herramienta ya tiene el deposito al dia.")
    else:
        tool["depositPaid"] = True
        print(f"Deposito registrado como pagado para {tool['toolName']}.")


def add_tool():
    # Agrega una nueva herramienta a la lista
    print()
    print("=== AGREGAR HERRAMIENTA ===")
    name = read_str("Nombre de la herramienta: ")
    if find_tool(name) is not None:
        print("Ya existe una herramienta con ese nombre.")
        return
    condition = read_str("Estado (Buena/Regular/Mala): ")
    tool_list.append({
        "toolName": name,
        "toolCondition": condition,
        "depositPaid": False
    })
    print(f"Herramienta {name} agregada correctamente.")


def show_stats():
    # Muestra estadisticas de depositos del taller
    print()
    print("=== ESTADISTICAS DEL TALLER ===")
    total = len(tool_list)
    paid = sum(1 for t in tool_list if t["depositPaid"])
    pending = total - paid
    print(f"Total de herramientas: {total}")
    print(f"Deposito pagado: {paid}")
    print(f"Herramientas pendientes: {pending}")


def available_tools():
    # Muestra solo las herramientas con deposito al dia
    print()
    print("=== HERRAMIENTAS DISPONIBLES ===")
    available = [t for t in tool_list if t["depositPaid"]]
    if not available:
        print("No hay herramientas disponibles.")
        return
    print(f"{'Nombre':<20} {'Estado':<12}")
    print("-" * 35)
    for t in available:
        print(f"{t['toolName']:<20} {t['toolCondition']:<12}")


if __name__ == "__main__":
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
            list_tools()
        elif option == "2":
            pay_deposit()
        elif option == "3":
            add_tool()
        elif option == "4":
            show_stats()
            available_tools()
        elif option == "5":
            running = False
            print("Saludos!")
        else:
            print("Opcion invalida.")
```

## 2. Salidas de referencia

| Prueba | Entrada | Salida esperada |
| --- | --- | --- |
| Listar | `1` | Tabla con 4 herramientas, estado y depósito |
| Pagar depósito (Llave inglesa) | `2`, `Llave inglesa` | "Depósito registrado como pagado..." |
| Pagar otra vez | `2`, `Llave inglesa` | "La herramienta ya tiene el depósito al día." |
| Agregar herramienta | `3`, `Taladro`, `Buena` | "Herramienta Taladro agregada correctamente." |
| Estadísticas | `4` | "Total: 5, Depósito pagado: 3, Pendientes: 2" |

## 3. Criterios de corrección

Idénticos a la versión A (ver `evaluacion-u2-version-a-anexo-docente.md`), con ajustes de dominio:

| Ítem | Ajuste |
| --- | --- |
| Parte 1 | toolList/toolName/toolCondition en lugar de memberList/memberName/memberAge; herramientas en lugar de socios |
| Parte 2 | toolDeposit/depósito en lugar de clubFee/cuota; taller en lugar de club |
| Parte 3 | availableTools en lugar de activeMembers; findTool en lugar de findMember |

## 4. Devolución

Idéntica a versión A.