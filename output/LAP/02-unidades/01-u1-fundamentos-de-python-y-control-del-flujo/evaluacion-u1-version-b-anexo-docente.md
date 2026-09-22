# Anexo docente — Evaluación de la Unidad 1 — Encuentro 9 — Versión B

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión B, los criterios de corrección y la pauta de devolución.

## 1. Solución completa (`biblioteca.py`)

```python
# biblioteca.py — Programa de prestamos de una biblioteca de aula
# Evaluacion U1 — Version B
# Permite ver libros, registrar prestamos con recargo y ver resumen

# Diccionario de libros de la biblioteca
# clave: codigo numerico, valor: {nombre, tarifa, ejemplares}
products = {
    101: {"name": "El principito",      "price": 30.0, "stock": 5},
    102: {"name": "Harry Potter",       "price": 45.0, "stock": 3},
    103: {"name": "Cien anios soledad", "price": 50.0, "stock": 2},
    104: {"name": "Dragon Ball 1",       "price": 20.0, "stock": 8}
}

# Acumuladores de la sesion
total_units = 0
total_money = 0.0


def show_products():
    # Muestra la lista de libros de la biblioteca
    print()
    print("=== LIBROS DE LA BIBLIOTECA ===")
    print(f"{'Codigo':<8} {'Nombre':<22} {'Tarifa':<10} {'Ejemplares':<10}")
    print("-" * 50)
    for code, data in products.items():
        print(f"{code:<8} {data['name']:<22} {data['price']:<10.2f} {data['stock']:<10}")


def read_int(message):
    # Pide un numero entero con validacion try/except
    while True:
        try:
            return int(input(message))
        except ValueError:
            print("Eso no es un numero entero; intenta de nuevo.")


def register_loan():
    # Registra un prestamo: pide codigo y cantidad, valida, descuenta y acumula
    global total_units, total_money

    print()
    print("=== REGISTRAR PRESTAMO ===")

    # Pedir codigo de libro
    code = read_int("Codigo del libro: ")

    # Verificar que exista
    if code not in products:
        print("Codigo invalido. No existe ese libro.")
        return

    item = products[code]
    item_stock = item["stock"]

    # Pedir cantidad
    qty = read_int("Cantidad a prestar: ")

    # Validar cantidad positiva
    if qty <= 0:
        print("La cantidad debe ser un numero positivo.")
        return

    # Verificar ejemplares suficiente
    if qty > item_stock:
        print(f"Ejemplares insuficiente. Ejemplares actual: {item_stock}.")
        return

    # Calcular total con recargo condicional
    late_fee = 0.0
    if qty > 5:
        late_fee = 0.10

    book_price = item["price"]
    subtotal = qty * book_price
    surcharge = subtotal * late_fee
    loan_total = subtotal + surcharge

    # Actualizar stock y acumuladores
    item["stock"] -= qty
    total_units += qty
    total_money += loan_total

    # Mostrar resultado
    print(f"Subtotal: ${subtotal:.2f}")
    if late_fee > 0:
        print(f"Recargo ({late_fee * 100:.0f}%): ${surcharge:.2f}")
    print(f"Total de este prestamo: ${loan_total:.2f}")


def show_summary():
    # Muestra el resumen de prestamos de la sesion
    print()
    print("=== RESUMEN DE PRESTAMOS ===")
    print(f"Unidades prestadas: {total_units}")
    print(f"Dinero acumulado: ${total_money:.2f}")


if __name__ == "__main__":
    # Bloque de ejecucion principal
    print("=== SISTEMA DE PRESTAMOS DE LA BIBLIOTECA ===")
    running = True

    while running:
        print()
        print("1. Ver libros")
        print("2. Registrar prestamo")
        print("3. Mostrar resumen")
        print("4. Salir")
        option = input("Elegi una opcion: ")

        if option == "1":
            show_products()
        elif option == "2":
            register_loan()
        elif option == "3":
            show_summary()
        elif option == "4":
            running = False
            print("Saludos!")
        else:
            print("Opcion invalida. Intenta de nuevo.")
```

**Aceptaciones válidas menores:** mismas que la versión A.

## 2. Salidas de referencia

| Prueba | Entrada | Salida esperada |
| --- | --- | --- |
| Menú | (ninguna) | "1. Ver libros", "2. Registrar prestamo", "3. Mostrar resumen", "4. Salir" |
| Opción 1 | `1` | Tabla con código, nombre, tarifa y ejemplares de 4 libros |
| Opción 2 + cantidad > 5 | `2`, `101`, `7` | "Subtotal: $210.00", "Recargo (10%): $21.00", "Total: $231.00" |
| Opción 2 + ejemplares insuf. | `2`, `101`, `999` | "Ejemplares insuficiente. Ejemplares actual: (lo que quede)." |
| Opción 3 | `3` | "Unidades prestadas: ..." y "Dinero acumulado: $..." |

## 3. Criterios de corrección

Idénticos a la versión A (ver `evaluacion-u1-version-a-anexo-docente.md`), con los siguientes ajustes de dominio:

| Ítem | Ajuste |
| --- | --- |
| Parte 1 | libros en lugar de productos; tarifa en lugar de precio; ejemplares en lugar de stock |
| Parte 2 | préstamo en lugar de venta; bookPrice/bookCopies en lugar de itemPrice/itemStock; lateFee/recargo en lugar de discountRate/descuento; loanTotal en lugar de saleTotal; registerLoan en lugar de registerSale |
| Parte 4 | lector en lugar de cliente |

## 4. Pauta de devolución

Idéntica a la versión A. Ver `evaluacion-u1-version-a-anexo-docente.md`.