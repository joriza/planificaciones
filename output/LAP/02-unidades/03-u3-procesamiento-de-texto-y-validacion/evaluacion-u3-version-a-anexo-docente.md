# Anexo docente — Evaluación de la Unidad 3 — Encuentro 26 — Versión A

> Documento docente formal. Solución completa, salidas de referencia y criterios de corrección.

## 1. Solución completa (`pizzeria.py`)

```python
# pizzeria.py — Gestion de pedidos de una pizzeria
# Evaluacion U3 — Version A
# Permite registrar pedidos con parseo de texto y validacion

import random

# Lista de pedidos en memoria
order_list = []


def parse_order(order_text):
    # Recibe un texto con formato "nombre, precio, cantidad"
    # Devuelve un dict con customerName, orderPrice (float), quantity (int)
    # o lanza ValueError si los datos numericos no son validos
    parts = order_text.split(",")
    if len(parts) != 3:
        print("Formato invalido. Usa: nombre, precio, cantidad.")
        return None

    customer_name = parts[0].strip()
    price_text = parts[1].strip()
    qty_text = parts[2].strip()

    # Validar que los campos no esten vacios
    if not customer_name or not price_text or not qty_text:
        print("Formato invalido. Usa: nombre, precio, cantidad.")
        return None

    # Convertir precio y cantidad (lanza ValueError si no son numericos)
    order_price = float(price_text)
    quantity = int(qty_text)

    # Validar valores positivos
    if order_price <= 0 or quantity <= 0:
        print("Precio y cantidad deben ser valores positivos.")
        return None

    return {
        "customerName": customer_name,
        "orderPrice": order_price,
        "quantity": quantity
    }


def valid_phone(phone):
    # Limpia espacios y guiones, verifica al menos 7 digitos
    clean = phone.strip().replace(" ", "").replace("-", "")
    return clean.isdigit() and len(clean) >= 7


def add_order():
    # Pide una linea de texto, la parsea y agrega el pedido a la lista
    print()
    print("=== AGREGAR PEDIDO ===")
    line = input("Ingresa: nombre, precio, cantidad: ")

    try:
        order = parse_order(line)
    except ValueError:
        print("Error: precio o cantidad no son numeros validos.")
        return

    if order is None:
        return

    # Pedir y validar telefono
    while True:
        phone = input("Telefono del comprador: ")
        if valid_phone(phone):
            break
        print("Telefono invalido. Debe tener al menos 7 digitos.")

    order["phone"] = phone.strip()
    ticket = random.randint(1000, 9999)
    order["ticket"] = ticket

    order_list.append(order)
    print(f"Pedido registrado correctamente. Ticket: {ticket}")


def list_orders():
    # Muestra todos los pedidos registrados
    print()
    print("=== LISTA DE PEDIDOS ===")
    if not order_list:
        print("No hay pedidos registrados.")
        return
    print(f"{'Nombre':<20} {'Telefono':<15} {'Precio':<8} {'Cant':<6} {'Ticket':<6}")
    print("-" * 60)
    for o in order_list:
        print(f"{o['customerName']:<20} {o.get('phone', '-'):<15} "
              f"{o['orderPrice']:<8.2f} {o['quantity']:<6} {o['ticket']:<6}")


if __name__ == "__main__":
    # Bloque de ejecucion principal (spike 9.10)
    print("=== SISTEMA DE PEDIDOS DE LA PIZZERIA ===")
    running = True

    while running:
        print()
        print("1. Agregar pedido")
        print("2. Listar pedidos")
        print("3. Salir")
        option = input("Elegi una opcion: ")

        if option == "1":
            add_order()
        elif option == "2":
            list_orders()
        elif option == "3":
            running = False
            print("Saludos!")
        else:
            print("Opcion invalida.")
```

**Aceptaciones válidas menores:**
- `order_list` puede llamarse `orders`.
- `parse_order` puede retornar una tupla en lugar de dict.
- La validación del teléfono puede usar `len([c for c in clean if c.isdigit()])`.
- El menú puede tener opción 0 para salir en lugar de 3.

## 2. Salidas de referencia

| Prueba | Entrada | Salida esperada |
| --- | --- | --- |
| Opción 1 + "Ana, 12.5, 3" + tel "1234567" | `1`, `Ana, 12.5, 3`, `1234567` | "Pedido registrado. Ticket: (4 dígitos)" |
| Opción 1 + "Ana, 12.5" | `1`, `Ana, 12.5` | "Formato inválido. Usá: nombre, precio, cantidad." |
| Opción 1 + "Ana, doce, 3" | `1`, `Ana, doce, 3` | "Error: precio o cantidad no son números válidos." |
| Opción 2 | `2` con 1 pedido | Tabla con nombre, teléfono, precio, cantidad, ticket |
| Opción 3 | `3` | "Saludos!" |

## 3. Criterios de corrección

| Ítem | Pts | Puntúa | Error previsto |
| --- | --- | --- | --- |
| 1a — parse_order | 15 | split, strip, return dict | Sin split ni strip → 0 pts; no devuelve dict → descontar 5 pts |
| 1b — Validar 3 campos | 10 | len(parts) != 3 | No valida cantidad de campos → 0 pts |
| 1c — ValueError | 5 | Captura excepción | Sin try/except → 0 pts |
| 2a — add_order | 15 | Llama parse, try/except, agrega | No agrega a la lista → 0 pts |
| 2b — valid_phone | 10 | replace + strip + isdigit | Sin limpieza → descontar 5 pts |
| 2c — Validar teléfono | 10 | Reintento while True | Sin reintento → descontar 5 pts |
| 2d — Ticket aleatorio | 5 | random.randint | Sin import random → 2 pts |
| 3a — Menú | 5 | 3 opciones, while | Menos opciones → descontar 2 pts |
| 3b — Listar | 10 | Itera order_list, formato precio | Sin formato 2 decimales → descontar 3 pts |
| 3c — Opción inválida | 5 | Mensaje y retorno | Crashing → 0 pts |
| 4a — split sin coma | 5 | "Devuelve lista de 1 elemento" | Respuesta incorrecta → 0 pts |
| 4b — try mejor que if | 5 | "Maneja cualquier caracter no numérico" | Sin justificación → descontar 3 pts |

## 4. Devolución

Encuentro 27. Recuperación al inicio del encuentro 28.