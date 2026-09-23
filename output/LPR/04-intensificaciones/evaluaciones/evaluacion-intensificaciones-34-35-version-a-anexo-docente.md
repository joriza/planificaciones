# Anexo docente — Evaluación del momento 34-35 — Versión A

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión A, las respuestas esperadas de los ítems conceptuales, los criterios de corrección ítem por ítem y la pauta de devolución.

## 1. Solución completa

### Programa de referencia `pizzeria_videoteca.py`

```python
def parse_appointment(order_text, customer_name, order_list):
    # Procesa el texto del pedido y devuelve un diccionario con los datos del turno.
    ingredientes = order_text.split(",")
    ingredientes_limpios = [ing.strip() for ing in ingredientes]
    turno = {
        "cliente": customer_name,
        "ingredientes": ingredientes_limpios,
        "cantidad": len(ingredientes_limpios)
    }
    order_list.append(turno)
    return turno


def validar_telefono(telefono):
    # Valida que el teléfono sea numérico (sin guiones).
    try:
        int(telefono.replace("-", ""))
        return True
    except ValueError:
        return False


def calcular_precio_pizza(ingredientes):
    # Calcula el precio de la pizza según la cantidad de ingredientes.
    precio_base = 10.0
    precio_ingrediente = 5.0
    return precio_base + (len(ingredientes) * precio_ingrediente)


def registrar_alquiler(peliculas, stock_peliculas, alquileres, pelicula, cantidad, movie_price):
    # Registra un alquiler si hay copias disponibles.
    if cantidad > stock_peliculas[pelicula]:
        return "Sin copias disponibles"
    total = movie_price * cantidad
    alquiler = {"pelicula": pelicula, "cantidad": cantidad, "total": total}
    alquileres.append(alquiler)
    stock_peliculas[pelicula] -= cantidad
    return alquiler


if __name__ == "__main__":
    ingredientes = ["Mozzarella", "Jamón", "Aceitunas", "Chorizo"]
    peliculas = ["El Padrino", "Titanic", "Inception"]
    precio_pelicula = 50.0
    stock_peliculas = {"El Padrino": 3, "Titanic": 2, "Inception": 4}
    pedidos = []
    alquileres = []

    while True:
        print("=== PIZZERIA + VIDEOTECA ===")
        print("1. Pedir pizza")
        print("2. Alquilar película")
        print("3. Ver resumen del día")
        print("4. Salir")
        opcion = input("Opción: ")

        if opcion == "1":
            cliente = input("Nombre del comprador: ")
            ing_text = input("Ingredientes (separados por coma): ")
            telefono = input("Teléfono: ")
            if not validar_telefono(telefono):
                print("Teléfono inválido, intente de nuevo.")
                continue
            turno = parse_appointment(ing_text, cliente, pedidos)
            precio = calcular_precio_pizza(turno["ingredientes"])
            print(f"Pedido registrado: {cliente} pidió una pizza con {turno['cantidad']} ingredientes por ${precio:.2f}")
        elif opcion == "2":
            pelicula = input("Nombre de la película: ")
            cantidad = int(input("Cantidad de copias: "))
            if pelicula in peliculas:
                resultado = registrar_alquiler(peliculas, stock_peliculas, alquileres, pelicula, cantidad, precio_pelicula)
                print(f"Alquiler registrado: {resultado}")
            else:
                print("Película no disponible")
        elif opcion == "3":
            print("--- Pedidos del día ---")
            for pedido in pedidos:
                print(f"{pedido['cliente']}: {pedido['cantidad']} ingredientes")
            print("--- Alquileres del día ---")
            for alquiler in alquileres:
                print(f"{alquiler['pelicula']}: {alquiler['cantidad']} copias por ${alquiler['total']:.2f}")
        elif opcion == "4":
            break
        else:
            print("Opción inválida")
```

## 2. Salidas de referencia para la corrección

| Prueba | Pedido | Respuesta esperada | Comando de verificación |
| --- | --- | --- | --- |
| `parseAppointment` | `split(",")` y `strip()` para limpiar ingredientes | La función devuelve un diccionario con `cliente`, `ingredientes` (lista limpia) y `cantidad` | Ejecutar con `"Mozzarella, Jamón, Aceitunas"` y verificar la lista limpia |
| `validar_telefono` | `try`/`except ValueError` con `int()` | Devuelve `True` para `"15-1234-5678"` y `False` para `"abc"` | Ejecutar con teléfono válido y no válido |
| `calcular_precio_pizza` | Precio base + ingredientes × precio unitario | 3 ingredientes → $25.00 (10 + 3×5) | Ejecutar con 3 ingredientes |
| Menú principal | `while True` con opciones 1 a 4 y `break` en opción 4 | El programa muestra el menú repetidamente hasta que el usuario elige salir | Ejecutar y verificar que la opción 4 termina el programa |
| Opción 2 — Alquilar película | Validación de stock y cálculo del total | Si stock < cantidad → "Sin copias disponibles". Si hay stock, se registra el alquiler | Ejecutar con stock=1, cantidad=3 |
| Opción 3 — Ver resumen | `for` sobre pedidos y alquileres | Se muestran todos los pedidos y alquileres del día | Ejecutar con 1 pedido y 1 alquiler |
| Funciones con `def` | Al menos 4 funciones con `def`, parámetros y `return` | Todas las funciones están definidas correctamente | Inspeccionar la definición de cada función |
| Bloque principal | `if __name__ == "__main__":` con menú | El programa arranca desde el bloque principal | Ejecutar el archivo directamente |

## 3. Criterios de corrección ítem por ítem

- **`parseAppointment` (15 pts):** 5 pts por `split(",")`. 5 pts por `strip()` en cada ingrediente. 5 pts por `return` del diccionario con los datos correctos.
- **`validar_telefono` (10 pts):** 5 pts por `try`/`except ValueError`. 5 pts por la lógica de validación correcta.
- **`calcular_precio_pizza` (10 pts):** 5 pts por el precio base. 5 pts por el cálculo correcto con la cantidad de ingredientes.
- **Menú principal (10 pts):** 5 pts por `while True` con opciones. 5 pts por `break` en opción 4 y manejo de opción inválida.
- **Opción 2 — Alquilar película (15 pts):** 5 pts por la validación de stock. 5 pts por el cálculo del total. 5 pts por la actualización del stock después del alquiler.
- **Opción 3 — Ver resumen (10 pts):** 5 pts por el `for` sobre pedidos. 5 pts por el `for` sobre alquileres.
- **Funciones (15 pts):** 5 pts por cada función con `def`, parámetros y `return` correctos (3 funciones × 5 pts).
- **Bloque principal (10 pts):** 5 pts por `if __name__ == "__main__":`. 5 pts por la inicialización de variables y la llamada al menú.
- **Commit y push (5 pts):** 5 pts por el commit con mensaje descriptivo y push al repo.

**Total:** 100 puntos. Criterio de Apto: ≥ 60 puntos.

**Errores previstos y criterio de intervención:**
- Si el alumno no usa `strip()` después de `split()`, indicar que los espacios alrededor de las comas generan ingredientes con espacios.
- Si el alumno no usa `try`/`except` para la validación del teléfono, indicar que `int()` lanza `ValueError` con texto no numérico.
- Si el alumno no actualiza el stock después de un alquiler, pedirle que reste las copias alquiladas del stock.
- Si el alumno no tiene el bloque `if __name__ == "__main__":`, pedirle que mueva la ejecución al bloque principal.

## 4. Pauta de devolución

La devolución se realiza en el encuentro 35. Se devuelve con nota de Apto o No apto aún por objetivo mínimo. Si el objetivo mínimo queda pendiente, se ofrece la instancia de diciembre (recuperación) como primera capa y la instancia de marzo como segunda capa con el mismo estándar. Se registra la nota en la planilla de evaluación y se anota la letra de la versión asignada.