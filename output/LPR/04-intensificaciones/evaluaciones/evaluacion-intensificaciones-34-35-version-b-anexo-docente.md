# Anexo docente — Evaluación del momento 34-35 — Versión B

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión B, las respuestas esperadas de los ítems conceptuales, los criterios de corrección ítem por ítem y la pauta de devolución.
>
> Esta versión es equivalente a la versión A con dominio sustituido (veterinaria + videoteca en lugar de pizzería + videoteca). Las soluciones y criterios son los mismos; solo cambian los datos de ejemplo y el contexto del dominio.

## 1. Solución completa

### Programa de referencia `veterinaria_videoteca.py`

```python
def parse_appointment(appointment_text, pet_name, appointment_list):
    # Procesa el texto de la cita y devuelve un diccionario con los datos del turno.
    vacunas = appointment_text.split(",")
    vacunas_limpias = [v.strip() for v in vacunas]
    turno = {
        "mascota": pet_name,
        "vacunas": vacunas_limpias,
        "cantidad": len(vacunas_limpias)
    }
    appointment_list.append(turno)
    return turno


def validar_nombre(name):
    # Valida que el nombre no esté vacío.
    if name.strip() == "":
        return False
    return True


def calculate_consult_price(vaccines):
    # Calcula el precio de la consulta según la cantidad de vacunas.
    precio_base = 10.0
    precio_vacuna = 5.0
    return precio_base + (len(vaccines) * precio_vacuna)


def rent_movie(movies, stock_movies, rentals, movie, copies, movie_price):
    # Registra un alquiler si hay copias disponibles.
    if copies > stock_movies[movie]:
        return "Sin copias disponibles"
    total = movie_price * copies
    rental = {"movie": movie, "copies": copies, "total": total}
    rentals.append(rental)
    stock_movies[movie] -= copies
    return rental


if __name__ == "__main__":
    vaccines = ["Rabia", "Parvovirus", "Moquillo", "Leptospirosis"]
    movies = ["El Padrino", "Titanic", "Inception"]
    movie_price = 50.0
    stock_movies = {"El Padrino": 3, "Titanic": 2, "Inception": 4}
    appointments = []
    rentals = []

    while True:
        print("=== VETERINARIA + VIDEOTECA ===")
        print("1. Pedir turno")
        print("2. Alquilar película")
        print("3. Ver resumen del día")
        print("4. Salir")
        opcion = input("Opción: ")

        if opcion == "1":
            pet = input("Nombre de la mascota: ")
            vac_text = input("Vacunas (separadas por coma): ")
            historial = input("Historial (teléfono): ")
            if not validar_nombre(pet):
                print("Nombre inválido, intente de nuevo.")
                continue
            turno = parse_appointment(vac_text, pet, appointments)
            precio = calculate_consult_price(turno["vacunas"])
            print(f"Turno registrado: {pet} pidió una consulta con {turno['cantidad']} vacunas por ${precio:.2f}")
        elif opcion == "2":
            movie = input("Nombre de la película: ")
            copies = int(input("Cantidad de copias: "))
            if movie in movies:
                result = rent_movie(movies, stock_movies, rentals, movie, copies, movie_price)
                print(f"Alquiler registrado: {result}")
            else:
                print("Película no disponible")
        elif opcion == "3":
            print("--- Turnos del día ---")
            for appt in appointments:
                print(f"{appt['mascota']}: {appt['cantidad']} vacunas")
            print("--- Alquileres del día ---")
            for rental in rentals:
                print(f"{rental['movie']}: {rental['copies']} copias por ${rental['total']:.2f}")
        elif opcion == "4":
            break
        else:
            print("Opción inválida")
```

## 2. Salidas de referencia para la corrección

| Prueba | Pedido | Respuesta esperada | Comando de verificación |
| --- | --- | --- | --- |
| `parseAppointment` | `split(",")` y `strip()` para limpiar vacunas | La función devuelve un diccionario con `mascota`, `vacunas` (lista limpia) y `cantidad` | Ejecutar con `"Rabia, Parvovirus, Moquillo"` y verificar la lista limpia |
| `validar_nombre` | Validación de que el nombre no esté vacío | Devuelve `False` para `""` y `True` para `"Luna"` | Ejecutar con nombre vacío y nombre válido |
| `calculate_consult_price` | Precio base + vacunas × precio unitario | 3 vacunas → $25.00 (10 + 3×5) | Ejecutar con 3 vacunas |
| Menú principal | `while True` con opciones 1 a 4 y `break` en opción 4 | El programa muestra el menú repetidamente hasta que el usuario elige salir | Ejecutar y verificar que la opción 4 termina el programa |
| Opción 2 — Alquilar película | Validación de stock y cálculo del total | Si stock < copias → "Sin copias disponibles". Si hay stock, se registra el alquiler | Ejecutar con stock=1, copias=3 |
| Opción 3 — Ver resumen | `for` sobre turnos y alquileres | Se muestran todos los turnos y alquileres del día | Ejecutar con 1 turno y 1 alquiler |
| Funciones | Al menos 4 funciones con `def`, parámetros y `return` | Todas las funciones están definidas correctamente | Inspeccionar la definición de cada función |
| Bloque principal | `if __name__ == "__main__":` con menú | El programa arranca desde el bloque principal | Ejecutar el archivo directamente |

## 3. Criterios de corrección ítem por ítem

- **`parseAppointment` (15 pts):** 5 pts por `split(",")`. 5 pts por `strip()` en cada vacuna. 5 pts por `return` del diccionario con los datos correctos.
- **`validar_nombre` (10 pts):** 5 pts por la validación de que el nombre no esté vacío. 5 pts por el mensaje de error claro.
- **`calculate_consult_price` (10 pts):** 5 pts por el precio base. 5 pts por el cálculo correcto con la cantidad de vacunas.
- **Menú principal (10 pts):** 5 pts por `while True` con opciones. 5 pts por `break` en opción 4 y manejo de opción inválida.
- **Opción 2 — Alquilar película (15 pts):** 5 pts por la validación de stock. 5 pts por el cálculo del total. 5 pts por la actualización del stock después del alquiler.
- **Opción 3 — Ver resumen (10 pts):** 5 pts por el `for` sobre turnos. 5 pts por el `for` sobre alquileres.
- **Funciones (15 pts):** 5 pts por cada función con `def`, parámetros y `return` correctos (3 funciones × 5 pts).
- **Bloque principal (10 pts):** 5 pts por `if __name__ == "__main__":`. 5 pts por la inicialización de variables y la llamada al menú.
- **Commit y push (5 pts):** 5 pts por el commit con mensaje descriptivo y push al repo.

**Total:** 100 puntos. Criterio de Apto: ≥ 60 puntos.

**Errores previstos y criterio de intervención:**
- Si el alumno no usa `strip()` después de `split()`, indicar que los espacios alrededor de las comas generan vacunas con espacios.
- Si el alumno no usa `try`/`except` para la validación del historial, indicar que la validación de entrada es necesaria.
- Si el alumno no actualiza el stock después de un alquiler, pedirle que reste las copias alquiladas del stock.
- Si el alumno no tiene el bloque `if __name__ == "__main__":`, pedirle que mueva la ejecución al bloque principal.

## 4. Pauta de devolución

La devolución se realiza en el encuentro 35. Se devuelve con nota de Apto o No apto aún por objetivo mínimo. Si el objetivo mínimo queda pendiente, se ofrece la instancia de diciembre (recuperación) como primera capa y la instancia de marzo como segunda capa con el mismo estándar. Se registra la nota en la planilla de evaluación y se anota la letra de la versión asignada.