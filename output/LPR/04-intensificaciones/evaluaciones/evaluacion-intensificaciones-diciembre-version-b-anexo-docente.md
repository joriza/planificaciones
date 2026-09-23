# Anexo docente — Evaluación de la intensificación de diciembre — Versión B

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión B, las respuestas esperadas de los ítems conceptuales, los criterios de corrección ítem por ítem y la pauta de devolución.
>
> Esta versión es equivalente a la versión A con dominio sustituido (videoteca en lugar de verdulería). Las soluciones y criterios son los mismos; solo cambian los datos de ejemplo y el contexto del dominio.

## 1. Solución completa

### Programa de referencia `videoteca.py`

```python
def add_movie(movie_list, movie_title, movie_price, stock_copies):
    # Agrega una película a la lista como diccionario.
    movie = {
        "movieTitle": movie_title,
        "moviePrice": movie_price,
        "stockCopies": stock_copies
    }
    movie_list.append(movie)
    return movie


def list_movies(movie_list):
    # Muestra cada película con su precio y stock de copias.
    for movie in movie_list:
        print(f"{movie['movieTitle']}: ${movie['moviePrice']:.2f} — Copias: {movie['stockCopies']}")


def find_movie(movie_list, movie_title):
    # Busca una película por título y la devuelve o None.
    for movie in movie_list:
        if movie["movieTitle"] == movie_title:
            return movie
    return None


def rent_movie(movie_list, movie_title, copies):
    # Registra un alquiler si hay copias suficientes y devuelve el total.
    movie = find_movie(movie_list, movie_title)
    if movie is None:
        return "Película no encontrada"
    if copies > movie["stockCopies"]:
        return "Sin copias disponibles"
    total = movie["moviePrice"] * copies
    movie["stockCopies"] -= copies
    return total


if __name__ == "__main__":
    movie_list = []

    while True:
        print("=== VIDEOTECA ===")
        print("1. Agregar película")
        print("2. Listar películas")
        print("3. Buscar película")
        print("4. Alquilar película")
        print("5. Salir")
        opcion = input("Opción: ")

        if opcion == "1":
            title = input("Nombre de la película: ")
            try:
                price = float(input("Precio de alquiler: $"))
                copies = float(input("Copias disponibles: "))
            except ValueError:
                print("Dato inválido, intente de nuevo.")
                continue
            add_movie(movie_list, title, price, copies)
            print(f"Película '{title}' agregada.")
        elif opcion == "2":
            list_movies(movie_list)
        elif opcion == "3":
            title = input("Nombre de la película a buscar: ")
            result = find_movie(movie_list, title)
            if result:
                print(f"Encontrada: {result['movieTitle']} — ${result['moviePrice']:.2f} — {result['stockCopies']} copias")
            else:
                print("Película no encontrada")
        elif opcion == "4":
            title = input("Nombre de la película: ")
            try:
                copies = float(input("Cantidad de copias: "))
            except ValueError:
                print("Dato inválido, intente de nuevo.")
                continue
            result = rent_movie(movie_list, title, copies)
            print(f"Resultado del alquiler: {result}")
        elif opcion == "5":
            break
        else:
            print("Opción inválida")
```

## 2. Salidas de referencia para la corrección

| Prueba | Pedido | Respuesta esperada | Comando de verificación |
| --- | --- | --- | --- |
| Programa base | Variables con tipos correctos (`str`, `float`, `int`) | El programa declara variables y usa `input()` con conversión | Ejecutar y verificar que pide datos correctamente |
| Condicionales | `if`/`elif`/`else` para stock bajo y recargo | Si copias < 1 → "Sin copias disponibles". Si precio > 500 → recargo del 10% | Ejecutar con copias=0.5 y precio=600 |
| Bucle `while` con menú | `while True` con opciones 1 a 5 y `break` en opción 5 | El programa muestra el menú repetidamente hasta que el usuario elige salir | Ejecutar y verificar que la opción 5 termina el programa |
| Lista de películas | `append()` para agregar, `for` para mostrar | Se muestran las películas agregadas con sus datos | Ejecutar con 2 películas agregadas |
| Búsqueda por título | `for` sobre la lista comparando `movieTitle` | Muestra la película encontrada o "Película no encontrada" | Ejecutar buscando una película existente y una inexistente |
| Funciones | Al menos `add_movie`, `list_movies`, `find_movie`, `rent_movie` con `def`, parámetros y `return` | Todas las funciones están definidas correctamente | Inspeccionar la definición de cada función |
| Bloque principal | `if __name__ == "__main__":` con menú | El programa arranca desde el bloque principal | Ejecutar el archivo directamente |
| `try`/`except` | `try`/`except ValueError` para conversión de precio y copias | Muestra "Dato inválido, intente de nuevo" si el usuario ingresa texto donde se espera un número | Ejecutar ingresando texto en lugar de un número |

## 3. Criterios de corrección ítem por ítem

- **Programa base (10 pts):** 5 pts por variables con tipos correctos. 5 pts por `input()` con conversión de tipos.
- **Condicionales (15 pts):** 5 pts por `if`/`elif`/`else` para stock bajo. 5 pts por recargo del 10% cuando el precio > 500. 5 pts por mensajes claros.
- **Bucle `while` con menú (10 pts):** 5 pts por `while True`. 5 pts por `break` en opción 5 y manejo de opción inválida.
- **Lista de películas (10 pts):** 5 pts por `append()` para agregar. 5 pts por `for` para mostrar con f-string.
- **Búsqueda por título (10 pts):** 5 pts por el `for` sobre la lista. 5 pts por la comparación de `movieTitle` y el mensaje "Película no encontrada".
- **Funciones (15 pts):** 5 pts por cada función con `def`, parámetros y `return` correctos (3 funciones × 5 pts).
- **Bloque principal (10 pts):** 5 pts por `if __name__ == "__main__":`. 5 pts por la inicialización de `movie_list` y la llamada al menú.
- **`try`/`except` (10 pts):** 5 pts por el bloque `try`/`except ValueError`. 5 pts por el mensaje de error claro.
- **Commit y push (5 pts):** 5 pts por el commit con mensaje descriptivo y push al repo.

**Total:** 100 puntos. Criterio de Apto: ≥ 60 puntos.

**Errores previstos y criterio de intervención:**
- Si el alumno usa `lista = lista.append(x)`, pedirle que corrija: `append` devuelve `None`.
- Si el alumno no usa `try`/`except` para la conversión de `input()`, indicar que `input()` siempre devuelve `str`.
- Si el alumno no tiene el bloque `if __name__ == "__main__":`, pedirle que mueva la ejecución al bloque principal.
- Si el alumno no actualiza el stock después de un alquiler, pedirle que reste la cantidad alquilada del stock.
- Si el alumno confunde `stockCopies` (cantidad de copias) con `moviePrice` (precio de alquiler), reforzar con el ejemplo del alquiler.

## 4. Pauta de devolución

La devolución se realiza al finalizar la defensa oral. Se devuelve con nota de Apto o No apto aún por objetivo mínimo. Si el objetivo mínimo queda pendiente, se informa la instancia de marzo como siguiente oportunidad con el mismo estándar, y se entrega la lista de objetivos pendientes para que el estudiante se prepare. Se registra la nota en la planilla de evaluación y se anota la letra de la versión asignada.