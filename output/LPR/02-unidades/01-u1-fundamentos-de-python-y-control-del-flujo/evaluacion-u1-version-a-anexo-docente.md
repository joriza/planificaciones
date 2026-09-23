# Anexo docente — Evaluación de la Unidad 1 — Encuentro 9 — Versión A

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión A, las respuestas esperadas de los ítems conceptuales, los criterios de corrección ítem por ítem y la pauta de devolución.

## 1. Solución completa (`kiosco.py`)

```python
# kiosco.py — Programa de ventas de un kiosco escolar
# Evaluacion U1 — Version A
# Permite ver productos, registrar ventas con descuento y ver resumen

# Diccionario de productos del kiosco
# clave: codigo numerico, valor: {nombre, precio, stock}
products = {
    101: {"name": "Caramelos", "price": 50.0, "stock": 30},
    102: {"name": "Chicles",    "price": 25.0, "stock": 50},
    103: {"name": "Galletitas", "price": 100.0, "stock": 20},
    104: {"name": "Jugos",      "price": 150.0, "stock": 15}
}

# Acumuladores de la sesion
total_units = 0
total_money = 0.0


def show_products():
    # Muestra la lista de productos del kiosco
    print()
    print("=== PRODUCTOS DEL KIOSCO ===")
    print(f"{'Codigo':<8} {'Nombre':<15} {'Precio':<10} {'Stock':<8}")
    print("-" * 45)
    for code, data in products.items():
        print(f"{code:<8} {data['name']:<15} {data['price']:<10.2f} {data['stock']:<8}")


def read_int(message):
    # Pide un numero entero con validacion try/except (spike 9.1)
    while True:
        try:
            return int(input(message))
        except ValueError:
            print("Eso no es un numero entero; intenta de nuevo.")


def register_sale():
    # Registra una venta: pide codigo y cantidad, valida, descuenta y acumula
    global total_units, total_money

    print()
    print("=== REGISTRAR VENTA ===")

    # 2a: Pedir codigo de producto
    code = read_int("Codigo del producto: ")

    # 2b: Verificar que exista
    if code not in products:
        print("Codigo invalido. No existe ese producto.")
        return

    item = products[code]
    item_stock = item["stock"]

    # 2c: Pedir cantidad
    qty = read_int("Cantidad a comprar: ")

    # Validar cantidad positiva
    if qty <= 0:
        print("La cantidad debe ser un numero positivo.")
        return

    # 2d: Verificar stock suficiente
    if qty > item_stock:
        print(f"Stock insuficiente. Stock actual: {item_stock}.")
        return

    # 2e: Calcular total con descuento condicional
    discount_rate = 0.0
    if qty > 5:
        discount_rate = 0.10

    item_price = item["price"]
    subtotal = qty * item_price
    discount = subtotal * discount_rate
    sale_total = subtotal - discount

    # 2f: Actualizar stock y acumuladores
    item["stock"] -= qty
    total_units += qty
    total_money += sale_total

    # Mostrar resultado
    print(f"Subtotal: ${subtotal:.2f}")
    if discount_rate > 0:
        print(f"Descuento ({discount_rate * 100:.0f}%): ${discount:.2f}")
    print(f"Total de esta venta: ${sale_total:.2f}")


def show_summary():
    # Muestra el resumen de ventas de la sesion
    print()
    print("=== RESUMEN DE VENTAS ===")
    print(f"Unidades vendidas: {total_units}")
    print(f"Dinero acumulado: ${total_money:.2f}")


if __name__ == "__main__":
    # Bloque de ejecucion principal (spike 9.10)
    print("=== SISTEMA DE VENTAS DEL KIOSCO ===")
    running = True

    while running:
        print()
        print("1. Ver productos")
        print("2. Registrar venta")
        print("3. Mostrar resumen")
        print("4. Salir")
        option = input("Elegi una opcion: ")

        if option == "1":
            show_products()
        elif option == "2":
            register_sale()
        elif option == "3":
            show_summary()
        elif option == "4":
            running = False
            print("Saludos!")
        else:
            print("Opcion invalida. Intenta de nuevo.")
```

**Aceptaciones válidas menores:**
- Nombres de funciones distintos (ej. `view_products` en lugar de `show_products`).
- Productos iniciales distintos (códigos y nombres diferentes, siempre que haya al menos 4).
- Acumuladores como globales O como variables fuera de funciones con `global`.
- El descuento puede calcularse en una línea en lugar de paso a paso.
- Puede omitir el subtotal si muestra directamente el total con descuento.

## 2. Salidas de referencia para la corrección

| Prueba | Entrada | Salida esperada |
| --- | --- | --- |
| Menú | (ninguna) | Muestra "1. Ver productos", "2. Registrar venta", "3. Mostrar resumen", "4. Salir" |
| Opción 1 | `1` | Tabla con código, nombre, precio y stock para 4 productos |
| Opción 2 + código + cantidad | `2`, `101`, `3` | "Total de esta venta: $150.00" / stock de caramelos: 27 |
| Opción 2 + cantidad > 5 | `2`, `101`, `7` | "Subtotal: $350.00", "Descuento (10%): $35.00", "Total: $315.00" |
| Opción 2 + stock insuficiente | `2`, `101`, `999` | "Stock insuficiente. Stock actual: (lo que quede)." |
| Opción 3 | `3` | "Unidades vendidas: (suma)" y "Dinero acumulado: $(suma)" |
| Opción 4 | `4` | "Saludos!" y termina |
| Opción inválida | `9` | "Opcion invalida. Intenta de nuevo." y vuelve al menú |
| Entrada no numérica en código | `2`, `abc` | "Eso no es un numero entero; intenta de nuevo." |

## 3. Criterios de corrección ítem por ítem

| Ítem | Puntaje | Qué puntúa | Qué no puntúa | Errores previstos |
| --- | --- | --- | --- | --- |
| 1a — Diccionario products | 10 | 4+ productos con code, name, price, stock | Orden de productos, nombres específicos | Productos hardcodeados sin diccionario (usar listas paralelas sin clave) → descontar 5 pts |
| 1b — Opción inválida | 10 | Mensaje claro y retorno al menú | Mensaje exacto | No manejarla (crash o silencio) → 0 pts |
| 1c — Bucle del menú | 10 | `while` con bandera que corta en opción 4 | Variable bandera específica | `if option == "4": break` sin bandera → ok; sin bucle → 0 pts; `sys.exit()` → descontar 5 pts |
| 2a — Pedir código | 10 | `read_int()` o equivalente con `try/except ValueError` y reintento | Mensaje de validación exacto | Sin `try/except` → 0 pts; con `try/except` pero sin reintento → descontar 5 pts |
| 2b — Validar existencia | 10 | `if code not in products:` (o `.get()`) | Mensaje exacto | Sin chequeo, código inexistente causa KeyError → 0 pts |
| 2c — Pedir cantidad | 5 | Validación con `try/except` y >= 0 | Validación exacta | Sin validar entero → 0 pts; sin validar positivo → descontar 3 pts |
| 2d — Stock suficiente | 5 | `if qty > item_stock:` con mensaje | Mensaje exacto | Descontar sin verificar stock → 0 pts (stock negativo) |
| 2e — Descuento condicional | 5 | `if qty > 5:` aplica 10 % y muestra detalle | Mostrar descuento solo si aplica | Sin descuento cuando qty > 5 → 0 pts; descuento cuando qty ≤ 5 → descontar 3 pts |
| 2f — Actualizar | 5 | `item["stock"] -= qty`, total_units +=, total_money += | Nombres de variables | No actualiza stock → -2 pts; no actualiza acumuladores → -3 pts; `lista = lista.append()` → -2 pts |
| 3a — Total unidades | 10 | Muestra `total_units` | Formato exacto | No muestra o muestra 0 siempre → 0 pts |
| 3b — Dinero acumulado | 10 | Muestra `total_money` con 2 decimales (`:.2f`) | Redondeo exacto | Sin formato 2 decimales → descontar 3 pts |
| 4a — Tipo de input() | 5 | "str" o "string", explicación de conversión | Explicación extensa | Dice "int" → 0 pts |
| 4b — Opción inválida | 5 | Menciona el `else` del `if` anidado | Explicación extensa | No identifica dónde se maneja → descontar 3 pts |

## 4. Pauta de devolución

- **Cuándo:** al inicio del encuentro 10.
- **Cómo:** el docente proyecta la planilla con puntajes por criterio y comenta los errores más frecuentes al grupo completo. Luego entrega la devolución individual por escrito (puntaje + breve comentario).
- **Registro:** en la planilla de curso, columna "Evaluación U1" con puntaje sobre 100.
- **Recuperación:** estudiantes con menos de 60 pts deben rehacer el ejercicio en su versión corregida y presentarlo al inicio del encuentro 11. El docente registra "en recuperación" en la planilla y verifica en la fecha indicada.
