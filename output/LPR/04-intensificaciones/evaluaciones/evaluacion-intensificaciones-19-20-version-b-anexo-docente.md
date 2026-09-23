# Anexo docente — Evaluación del momento 19-20 — Versión B

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión B, las respuestas esperadas de los ítems conceptuales, los criterios de corrección ítem por ítem y la pauta de devolución.
>
> Esta versión es equivalente a la versión A con dominio sustituido (biblioteca de aula + taller de escuela en lugar de kiosco escolar + club de barrio). Las soluciones y criterios son los mismos; solo cambian los datos de ejemplo y el contexto del dominio.

## 1. Solución completa

### Programa de referencia `biblioteca_taller.py`

```python
def register_loan(books, copies, loans, late_fee, reader, book_price, days):
    # Registra un préstamo si hay ejemplares suficientes y devuelve el diccionario de préstamo.
    if days > copies:
        return "Sin ejemplares disponibles"
    total = book_price * days
    if total > 50:
        total = total * 0.9  # recargo del 10%
    loan = {"reader": reader, "book": books[0], "days": days, "total": total}
    loans.append(loan)
    return loan


def list_books(books, prices, copies):
    # Muestra cada libro con su precio y ejemplares disponibles.
    for i in range(len(books)):
        print(f"{books[i]}: ${prices[i]:.2f}/día — Ejemplares: {copies[i]}")


def show_readers(loans):
    # Muestra los lectores que pidieron préstamo sin repetir.
    seen = set()
    for loan in loans:
        reader = loan["reader"]
        if reader not in seen:
            print(reader)
            seen.add(reader)


def calculate_total(loans):
    # Suma el total de todos los préstamos registrados.
    total = 0
    for loan in loans:
        total += loan["total"]
    return total


if __name__ == "__main__":
    books = ["Matemáticas", "Historia", "Literatura"]
    prices = [10.0, 25.0, 15.0]
    copies = [3, 2, 4]
    loans = []

    while True:
        print("=== BIBLIOTECA DE AULA ===")
        print("1. Registrar préstamo")
        print("2. Mostrar libros")
        print("3. Mostrar lectores")
        print("4. Calcular total de préstamos")
        print("5. Salir")
        opcion = input("Opción: ")

        if opcion == "1":
            reader = input("Nombre del lector: ")
            book = input("Libro: ")
            days = int(input("Días: "))
            price = prices[books.index(book)]
            result = register_loan(books, copies[books.index(book)], loans, 0.1, reader, price, days)
            print(f"Préstamo registrado: {result}")
        elif opcion == "2":
            list_books(books, prices, copies)
        elif opcion == "3":
            show_readers(loans)
        elif opcion == "4":
            total = calculate_total(loans)
            print(f"Total de préstamos del día: ${total:.2f}")
        elif opcion == "5":
            break
        else:
            print("Opción inválida")
```

## 2. Salidas de referencia para la corrección

| Prueba | Pedido | Respuesta esperada | Comando de verificación |
| --- | --- | --- | --- |
| Menú principal | Bucle `while True` con opciones 1 a 5 y `break` en opción 5 | El programa muestra el menú repetidamente hasta que el usuario elige salir | Ejecutar y verificar que la opción 5 termina el programa |
| Opción 1 — Registrar préstamo | `registerLoan` con validación de ejemplares y recargo del 10% | Si ejemplares < días → "Sin ejemplares disponibles". Si total > 50 → recargo aplicado | Ejecutar con ejemplares=1, días=3 y con total > 50 |
| Opción 2 — Mostrar libros | `for` sobre la lista de libros mostrando nombre, tarifa y ejemplares | Se muestran los 3 libros con sus datos | Ejecutar y verificar la salida |
| Opción 3 — Mostrar lectores | `set` para evitar duplicados, `for` sobre préstamos | Se muestran los lectores sin repetir | Ejecutar con 2 préstamos del mismo lector |
| Opción 4 — Calcular total | Acumulador `total` con `for` sobre préstamos | Suma correcta de todos los totales de préstamo | Ejecutar con 2 préstamos y verificar la suma |
| Función `registerLoan` | `def` con parámetros, `return` de préstamo o mensaje | La función recibe los datos y devuelve el resultado correcto | Inspeccionar la definición de la función |
| Bloque principal | `if __name__ == "__main__":` con menú | El programa arranca desde el bloque principal | Ejecutar el archivo directamente |

## 3. Criterios de corrección ítem por ítem

- **Menú principal (10 pts):** 5 pts por `while True` con opciones. 5 pts por `break` en opción 5 y manejo de opción inválida.
- **Opción 1 — Registrar préstamo (20 pts):** 10 pts por la validación de ejemplares correcta. 10 pts por el recargo del 10% cuando el total supera $50.
- **Opción 2 — Mostrar libros (10 pts):** 5 pts por el `for` sobre la lista. 5 pts por la salida con f-string mostrando nombre, tarifa y ejemplares.
- **Opción 3 — Mostrar lectores (10 pts):** 5 pts por el uso de `set` para evitar duplicados. 5 pts por el `for` sobre la lista de préstamos.
- **Opción 4 — Calcular total (10 pts):** 5 pts por el acumulador `total`. 5 pts por la función `calculate_total` con `return`.
- **Función `registerLoan` (15 pts):** 5 pts por `def` con parámetros correctos. 5 pts por `return` del préstamo registrado. 5 pts por el mensaje de error "Sin ejemplares disponibles".
- **Bloque principal (10 pts):** 5 pts por `if __name__ == "__main__":`. 5 pts por la inicialización de variables y la llamada al menú.
- **Try/except (10 pts):** 5 pts por el bloque `try`/`except ValueError`. 5 pts por el mensaje de error claro.
- **Commit y push (5 pts):** 5 pts por el commit con mensaje descriptivo y push al repo.

**Total:** 100 puntos. Criterio de Apto: ≥ 60 puntos.

**Errores previstos y criterio de intervención:**
- Si el alumno usa `lista = lista.append(x)`, pedirle que corrija: `append` devuelve `None`.
- Si el alumno no usa `try`/`except` para la conversión de `input()`, indicar que `input()` siempre devuelve `str`.
- Si el alumno no tiene el bloque `if __name__ == "__main__":`, pedirle que mueva la ejecución al bloque principal.
- Si el alumno confunde `copies` (ejemplares disponibles) con el `total` (precio × días), reforzar con el ejemplo del préstamo.

## 4. Pauta de devolución

La devolución se realiza en el encuentro 20. Se devuelve con nota de Apto o No apto aún por objetivo mínimo. Si el objetivo mínimo queda pendiente, se ofrece la intensificación de las Unidades 3 y 4 (encuentros 34-35) como primera capa de recuperación. Se registra la nota en la planilla de evaluación y se anota la letra de la versión asignada.