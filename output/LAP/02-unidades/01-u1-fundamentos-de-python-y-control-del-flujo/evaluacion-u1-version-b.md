# Evaluación de la Unidad 1 — Encuentro 9 — Versión A

> Dominio de esta versión: **biblioteca escolar** (préstamo de libros, ejemplares y descuentos). Duración: 70 minutos (bloque de resolución). Puntaje total: 100 puntos. Resolución individual, con computadora, sin celular. Las condiciones completas están en `evaluacion-u1.md`.

## Antes de empezar

- Creá una carpeta `evaluacion-u1/` dentro de tu repositorio grupal.
- Dentro de esa carpeta, creá un único archivo `biblioteca.py`.
- El programa debe seguir las **convenciones del curso**: identificadores en inglés y `snake_case`; comentarios y mensajes al usuario en español; f-strings para la salida; sin `except:` desnudo; sin archivos ni persistencia.
- Toda entrada numérica debe validarse con `while True` + `try/except ValueError`, mostrando un mensaje accionable en español.
- Al terminar, hacé commit con `git commit -m "evaluacion-u1: entrega"` y push al repositorio remoto.

## Objetivos de la prueba

1. Escribir un programa de consola que use variables, condicionales y bucles.
2. Validar entrada del usuario con `try/except ValueError`.
3. Aplicar descuentos condicionales y acumular totales.
4. Organizar el código con funciones arriba y bloque `if __name__ == "__main__":` al final.

## Material provisto

No hay esqueleto inicial. El estudiante escribe el programa completo desde cero. Se espera que use un diccionario para los libros del biblioteca.

## Parte 1 — Menú principal y listado de libros (30 puntos)

Agregá un diccionario `products` con al menos 4 libros del biblioteca. Cada clave es un código numérico (`int`) y cada valor es un diccionario con `name`, `price` y `ejemplares`.

Mostrá un menú con las opciones:

| Opción | Acción | Pts |
| --- | --- | --- |
| 1 | Ver libros: mostrá código, nombre, tarifa y ejemplares de cada película | 10 |
| 2 | Registrar una préstamo | — (se evalúa en Parte 2) |
| 3 | Mostrar resumen de ventas | — (se evalúa en Parte 3) |
| 4 | Salir | — |
| *inválida* | Mostrar "Opción inválida. Intentá de nuevo." | 10 |
| *bucle* | El menú se repite hasta que el usuario elige Salir | 10 |

El programa debe repetir el menú hasta que el usuario elige "4 — Salir". Usá un bucle `while` con una bandera (`running = True` / `running = False`).

## Parte 2 — Registrar una préstamo (40 puntos)

Cuando el usuario elige la opción 2, el programa debe:

| Ítem | Consigna | Pts |
| --- | --- | --- |
| 2a | Pedir un código de película con `input()`. Validar que el código sea un número entero. | 10 |
| 2b | Verificar que el código exista en `products`. Si no, mostrar "Código inválido. No existe ese película." y volver al menú. | 10 |
| 2c | Pedir la cantidad a comprar. Validar que sea entero positivo. | 5 |
| 2d | Verificar que haya ejemplares suficiente. Si no, mostrar "Ejemplares insuficiente. Ejemplares actual: {bookCopies}." y volver al menú. | 5 |
| 2e | Si la cantidad supera las 5 unidades, aplicar un `lateFee` del 10 % al `bookPrice`. Mostrar el `loanTotal` con recargo detallado. | 5 |
| 2f | Descontar del ejemplares y acumular en variables globales `total_units` y `total_money`. | 5 |
| **Total Parte 2** | | **40** |

## Parte 3 — Resumen de ventas (20 puntos)

Cuando el usuario elige la opción 3, el programa debe mostrar:

| Ítem | Consigna | Pts |
| --- | --- | --- |
| 3a | Total de unidades vendidas en la sesión | 10 |
| 3b | Dinero acumulado en la sesión, formateado con 2 decimales | 10 |
| **Total Parte 3** | | **20** |

## Parte 4 — Ítems conceptuales (10 puntos)

Respondé brevemente en comentarios al final del archivo (después del bloque `if __name__ == "__main__":`):

| Ítem | Pregunta | Pts |
| --- | --- | --- |
| 4a | ¿Qué tipo de dato devuelve `input()` siempre? ¿Por qué hay que convertirlo antes de usarlo como número? | 5 |
| 4b | ¿Qué pasa si un `lector` elige una opción de menú que no existe? ¿Dónde se maneja eso en tu programa? | 5 |
| **Total Parte 4** | | **10** |

## Batería de verificación: salida esperada

| Prueba | Turno | Salida esperada (aproximada) |
| --- | --- | --- |
| Menú | El programa arranca | Menú con 4 opciones, espera input |
| Opción 1 | Ver lista | Muestra código, nombre, tarifa y ejemplares de cada película |
| Opción 2 | Código 101, cantidad 3 | Descuenta ejemplares, no aplica recargo, muestra "Total: $ ..." |
| Opción 2 (cantidad > 5) | Código 101, cantidad 7 | Aplica 10 % recargo, muestra "Subtotal: $..., Recargo: $..., Total: $..." |
| Opción 2 (ejemplares insuf.) | Código 101, cantidad 999 | "Ejemplares insuficiente. Ejemplares actual: ..." |
| Opción 3 | Mostrar resumen | "Unidades vendidas: ... - Dinero acumulado: $ ..." |
| Opción 4 | Salir | "Saludos!" y termina |
| Opción inválida | "9" | "Opción inválida. Intentá de nuevo." |
| Entrada no numérica | "abc" en código | "Eso no es un número entero; intentá de nuevo." |

## Al terminar

1. Verificá que el archivo se ejecuta sin errores: `python biblioteca.py`.
2. Hacé `git add .`, `git commit -m "evaluacion-u1: entrega"` y `git push`.
3. Si no podés hacer push, avisá al docente antes de que termine el encuentro.