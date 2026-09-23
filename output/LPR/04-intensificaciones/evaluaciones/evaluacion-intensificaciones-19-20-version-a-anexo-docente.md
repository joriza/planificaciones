# Anexo docente — Evaluación del momento 19-20 — Versión A

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión A, las respuestas esperadas de los ítems conceptuales, los criterios de corrección ítem por ítem y la pauta de devolución.

## 1. Solución completa

### Programa de referencia `biblioteca_club.py`

```python
def register_loan(libros, ejemplares, prestamos, recargo, lector, book_price, dias):
    # Registra un préstamo si hay ejemplares suficientes y devuelve el diccionario de préstamo.
    if dias > ejemplares:
        return "Sin ejemplares disponibles"
    total = book_price * dias
    if total > 50:
        total = total * 0.9  # recargo del 10%
    prestamo = {"lector": lector, "libro": libros[0], "dias": dias, "total": total}
    prestamos.append(prestamo)
    return prestamo


def listar_libros(libros, tarifas, ejemplares):
    # Muestra cada libro con su tarifa y ejemplares disponibles.
    for i in range(len(libros)):
        print(f"{libros[i]}: ${tarifas[i]:.2f}/día — Ejemplares: {ejemplares[i]}")


def mostrar_lectores(prestamos):
    # Muestra los lectores que pidieron préstamo sin repetir.
    vistos = set()
    for prestamo in prestamos:
        lector = prestamo["lector"]
        if lector not in vistos:
            print(lector)
            vistos.add(lector)


def calcular_total(prestamos):
    # Suma el total de todos los préstamos registrados.
    total = 0
    for prestamo in prestamos:
        total += prestamo["total"]
    return total


if __name__ == "__main__":
    libros = ["Matemáticas", "Historia", "Literatura"]
    tarifas = [10.0, 25.0, 15.0]
    ejemplares = [3, 2, 4]
    prestamos = []

    while True:
        print("=== BIBLIOTECA DE AULA ===")
        print("1. Registrar préstamo")
        print("2. Mostrar libros")
        print("3. Mostrar lectores")
        print("4. Calcular total de préstamos")
        print("5. Salir")
        opcion = input("Opción: ")

        if opcion == "1":
            lector = input("Nombre del lector: ")
            libro = input("Libro: ")
            dias = int(input("Días: "))
            precio = tarifas[libros.index(libro)]
            resultado = register_loan(libros, ejemplares[libros.index(libro)], prestamos, 0.1, lector, precio, dias)
            print(f"Préstamo registrado: {resultado}")
        elif opcion == "2":
            listar_libros(libros, tarifas, ejemplares)
        elif opcion == "3":
            mostrar_lectores(prestamos)
        elif opcion == "4":
            total = calcular_total(prestamos)
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
- **Opción 4 — Calcular total (10 pts):** 5 pts por el acumulador `total`. 5 pts por la función `calcular_total` con `return`.
- **Función `registerLoan` (15 pts):** 5 pts por `def` con parámetros correctos. 5 pts por `return` del préstamo registrado. 5 pts por el mensaje de error "Sin ejemplares disponibles".
- **Bloque principal (10 pts):** 5 pts por `if __name__ == "__main__":`. 5 pts por la inicialización de variables y la llamada al menú.
- **Try/except (10 pts):** 5 pts por el bloque `try`/`except ValueError`. 5 pts por el mensaje de error claro.
- **Commit y push (5 pts):** 5 pts por el commit con mensaje descriptivo y push al repo.

**Total:** 100 puntos. Criterio de Apto: ≥ 60 puntos.

**Errores previstos y criterio de intervención:**
- Si el alumno usa `lista = lista.append(x)`, pedirle que corrija: `append` devuelve `None`.
- Si el alumno no usa `try`/`except` para la conversión de `input()`, indicar que `input()` siempre devuelve `str`.
- Si el alumno no tiene el bloque `if __name__ == "__main__":`, pedirle que mueva la ejecución al bloque principal.
- Si el alumno confunde `ejemplares` (cantidad disponible) con el `total` (precio × días), reforzar con el ejemplo del préstamo.

## 4. Pauta de devolución

La devolución se realiza en el encuentro 20. Se devuelve con nota de Apto o No apto aún por objetivo mínimo. Si el objetivo mínimo queda pendiente, se ofrece la intensificación de las Unidades 3 y 4 (encuentros 34-35) como primera capa de recuperación. Se registra la nota en la planilla de evaluación y se anota la letra de la versión asignada.