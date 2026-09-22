# Encuentro 24 — Integración: menú del TP

> Procesamiento de texto y validación

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 24 de 36 |
| Unidad | 3 — Procesamiento de texto y validación |
| Eje temático | 3 — Procesamiento de texto y validación |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 120 minutos (2 horas reloj) |
| Concepto nuevo | Integración: menú del TP |
| Requisitos previos | Encuentro 23: menú de consola en memoria con `import`, funciones y validación |
| Uso de celular | No permitido |
| Organización del trabajo | Grupos de 2 personas. Hoy arrancamos el TP-U3: cada grupo arma su propio programa. |

### Reparto de tiempos

| Momento | Tiempo |
| --- | --- |
| Apertura y puente | 10 min |
| Teoría mínima | 20 min |
| Práctica guiada | 35 min |
| Ejercicio independiente | 25 min |
| Extensión y consolidación | 20 min |
| Cierre | 10 min |
| **Total** | **120 min** |

## 2. Objetivos de aprendizaje

1. Diseñar un programa completo en un solo archivo `.py` que integre funciones, colecciones, validación y procesamiento de texto.
2. Implementar un menú de pizzería con registro de pedidos, cálculo de totales y consultas.
3. Aplicar el patrón `try/except` para validar cada entrada del usuario.
4. Organizar el código con funciones arriba y ejecución en `if __name__ == "__main__":` como dicta la convención del curso.

## 3. Teoría mínima (20 min)

### Charla rápida: el cuaderno de pedidos

Imaginate que la pizzería tiene un cuaderno donde anota los pedidos. Cada pedido tiene: nombre del comprador, teléfono, lista de pizzas y total. El menú de la clase 23 era un ejemplo simple. Ahora vamos a hacer un programa que reemplace ese cuaderno: registrar pedidos, consultarlos y calcular todo automáticamente. Es el mismo esqueleto, pero más completo.

### Lo mínimo indispensable

**Estructura del TP-U3 — lo que hay que incluir:**

```
tp-u3/
  pedidos.py        ← un solo archivo
```

**Funciones mínimas del TP-U3 (dominio pizzería):**

| Función | Qué hace | ¿Usa validación? |
| --- | --- | --- |
| `read_int(msg, min, max)` | Pide entero validado | Sí — `try/except ValueError` + rango |
| `read_float(msg)` | Pide decimal validado | Sí — `try/except ValueError` |
| `parse_order_line(line)` | Procesa "cant nombre" → tupla | Sí — `try` + `split`/`strip` |
| `add_order(order_list)` | Agrega pedido con datos | Sí — todo validado |
| `list_orders(order_list)` | Muestra todos los pedidos | No — solo recorre |
| `search_by_phone(order_list, phone)` | Busca pedido por teléfono | Sí — limpia teléfono con `replace` |
| `show_total_sales(order_list)` | Suma y muestra ventas totales | No — solo suma |
| `show_menu()` | Muestra opciones | No |

**Import permitidos:** `import random` (para número de pedido), `import math` (opcional).

**Sin persistencia:** toda la información vive en una lista de diccionarios (o de tuplas) en memoria. Al cerrar el programa, los datos se pierden.

**Esquema de un pedido (en memoria):**

```python
# Cada pedido es un diccionario:
pedido = {
    "customer": "María",
    "phone": "1123456789",
    "items": [("muzza", 2, 2400.0), ("napo", 1, 1400.0)],
    "total": 3800.0,
    "ticket": 457
}
```

## 4. Práctica guiada (35 min)

**Escenario:** empezamos a construir el programa base del TP-U3 con las funciones de gestión de pedidos.

**Código completo (`pedidos.py`):**

```python
import random


def read_int(message, min_val=None, max_val=None):
    """Pide un entero validado con rango opcional."""
    while True:
        try:
            value = int(input(message))
            if min_val is not None and value < min_val:
                print(f"❌ El mínimo es {min_val}; intentá de nuevo.")
                continue
            if max_val is not None and value > max_val:
                print(f"❌ El máximo es {max_val}; intentá de nuevo.")
                continue
            return value
        except ValueError:
            print("❌ Eso no es un número entero; intentá de nuevo.")


def read_float(message):
    """Pide un decimal validado."""
    while True:
        try:
            return float(input(message))
        except ValueError:
            print("❌ Usá punto decimal (ej: 12.50); intentá de nuevo.")


def clean_phone(phone_text):
    """Saca espacios y guiones del teléfono, deja solo dígitos."""
    return phone_text.replace(" ", "").replace("-", "")


def parse_order_line(line):
    """Procesa '2 muzza' y devuelve (cantidad, nombre)."""
    parts = line.strip().split()
    if len(parts) < 2:
        print("❌ Formato: cantidad nombre (ej: 2 muzza).")
        return None
    try:
        quantity = int(parts[0])
        name = " ".join(parts[1:])
        return (quantity, name)
    except ValueError:
        print("❌ La cantidad debe ser un número entero.")
        return None


def add_order(order_list):
    """Agrega un pedido completo al sistema."""
    print("\n--- Nuevo pedido ---")
    customer = input("Nombre del comprador: ").strip()
    phone_raw = input("Teléfono: ").strip()
    phone = clean_phone(phone_raw)

    # Pide las pizzas del pedido
    items = []
    while True:
        line = input("Pizza (cant nombre) o ENTER para terminar: ").strip()
        if line == "":
            break
        parsed = parse_order_line(line)
        if parsed:
            qty, name = parsed
            # Precio base
            price = read_float(f"  Precio de {name}: $")
            subtotal = qty * price
            items.append((name, qty, price, subtotal))
            print(f"  ✓ {qty}x {name} agregada.")

    if not items:
        print("❌ El pedido debe tener al menos una pizza.")
        return

    # Calcula total
    total = sum(sub for _, _, _, sub in items)
    ticket = random.randint(1000, 9999)
    order_list.append({
        "customer": customer,
        "phone": phone,
        "items": items,
        "total": total,
        "ticket": ticket
    })
    print(f"✓ Pedido registrado. Ticket #{ticket} — Total: ${total:.2f}")


def list_orders(order_list):
    """Muestra todos los pedidos registrados."""
    if not order_list:
        print("\n📭 No hay pedidos registrados.")
        return
    for order in order_list:
        print(f"\nTicket #{order['ticket']} — {order['customer']}")
        print(f"  Tel: {order['phone']}")
        for name, qty, price, sub in order["items"]:
            print(f"  {qty}x {name}: ${price:.2f} → ${sub:.2f}")
        print(f"  Total: ${order['total']:.2f}")


def search_by_phone(order_list, search_phone):
    """Busca pedidos por teléfono (búsqueda parcial)."""
    found = []
    for order in order_list:
        if search_phone in order["phone"]:
            found.append(order)
    return found


def show_menu():
    print("\n" + "=" * 35)
    print("   🍕 Pizzería — Sistema de Pedidos")
    print("=" * 35)
    print("1. Agregar pedido")
    print("2. Listar pedidos")
    print("3. Buscar por teléfono")
    print("4. Mostrar ventas totales")
    print("0. Salir")
    return input("Elegí una opción: ").strip()


if __name__ == "__main__":
    orders = []
    print("=== Sistema de Pedidos de la Pizzería ===")

    while True:
        option = show_menu()

        if option == "0":
            print("📋 ¡Hasta luego!")
            break
        elif option == "1":
            add_order(orders)
        elif option == "2":
            list_orders(orders)
        elif option == "3":
            search = input("Teléfono a buscar: ").strip()
            results = search_by_phone(orders, clean_phone(search))
            if results:
                print(f"\nSe encontraron {len(results)} pedido(s):")
                for order in results:
                    print(f"  #{order['ticket']} — {order['customer']} — ${order['total']:.2f}")
            else:
                print("📭 No se encontraron pedidos con ese teléfono.")
        elif option == "4":
            if not orders:
                print("📭 No hay pedidos registrados.")
            else:
                total = sum(o["total"] for o in orders)
                count = len(orders)
                print(f"\n💰 Ventas totales: ${total:.2f} ({count} pedido(s))")
        else:
            print("❌ Opción inválida. Elegí 0-4.")
```

**Salida esperada (secuencia de prueba mínima):**
```
=== Sistema de Pedidos de la Pizzería ===

=====================================
   🍕 Pizzería — Sistema de Pedidos
=====================================
1. Agregar pedido
2. Listar pedidos
3. Buscar por teléfono
4. Mostrar ventas totales
0. Salir
Elegí una opción: 1

--- Nuevo pedido ---
Nombre del comprador: María
Teléfono: 11 2345 6789
Pizza (cant nombre) o ENTER para terminar: 2 muzza
  Precio de muzza: $1200
  ✓ 2x muzza agregada.
Pizza (cant nombre) o ENTER para terminar:
✓ Pedido registrado. Ticket #3142 — Total: $2400.00

Elegí una opción: 4

💰 Ventas totales: $2400.00 (1 pedido(s))
```

**Pasos:**
1. Escribí `pedidos.py` completo.
2. Ejecutalo y probá agregar al menos 2 pedidos.
3. Probá la búsqueda por teléfono.
4. Probá opciones inválidas.

## 5. Ejercicio independiente (25 min)

**Consigna:** agregá una **opción 5. Ver detalle de pedido** que pida un número de ticket y muestre el pedido completo de ese ticket. Si el ticket no existe, mostrá un mensaje.

Además, modificá la opción 3 (búsqueda por teléfono) para que, si se encuentra un solo pedido, muestre automáticamente el detalle completo (no solo el resumen).

**Pista:** recorré la lista de pedidos comparando `order["ticket"]` con el número ingresado. Usá `read_int` para leer el número de ticket.

**Solución:** en el anexo docente.

## 6. Extensión y consolidación (20 min)

Para quienes terminan el ejercicio base:

1. **Agregar opción 6. Pedido más caro:** mostrá el pedido con el total más alto (usá `max()` con `key=lambda` o un `for` manual).
2. **Validar precio positivo:** que `read_float` no acepte precios negativos.
3. **Confirmación al agregar:** antes de guardar el pedido, mostrá un resumen y preguntá "¿Confirmar? (s/n)".

## 7. Cierre (10 min)

### Qué te llevás

- El TP-U3 ya tiene esqueleto: funciones de validación, menú, colecciones en memoria.
- Cada pedido se modela como un diccionario: es fácil de entender y de recorrer.
- La búsqueda con `in` en cadenas permite encontrar coincidencias parciales.
- El próximo encuentro es la entrega: vamos a cerrar el TP, hacer commits y push.

### Lo que viene

En el **Encuentro 25** hacemos el **cierre de la Unidad 3**: repaso general, trabajo en el TP y **entrega** con carpeta nueva, commits y push al repositorio.

## 8. Errores comunes y trampas

| Error | Causa | Fix |
| --- | --- | --- |
| El diccionario del pedido tiene claves mal escritas | Typo en `"customer"` vs `"costumer"` | Usar el mismo nombre en todas partes; copiar del ejemplo |
| No actualiza la lista después de agregar | `add_order` recibe la lista pero no la modifica | `order_list.append(...)` modifica la lista in-place |
| La búsqueda por teléfono nunca encuentra nada | No aplica `clean_phone` al buscar | Aplicar `clean_phone` tanto al guardar como al buscar |
| `sum()` sobre la lista vacía da 0 | No es error, pero confunde si no hay pedidos | Chequear `if not orders:` antes de mostrar ventas |
| El menú no reconoce opciones con espacios | `input()` sin `.strip()` | Siempre hacer `.strip()` sobre el resultado de `input()` |
| Olvida `import random` al principio del archivo | `random.randint` no está disponible | `import random` debe estar antes de cualquier función que lo use |
| Usa `break` para salir del `while` de pizzas pero después no guarda el pedido | Corta antes de calcular total y ticket | Verificar el flujo: `while` solo para las pizzas, guardar después |
| El precio de la pizza se pide con `input()` sin validar | No usa `read_float` para el precio | Reemplazar `input()` por `read_float()` |