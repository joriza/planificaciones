# Evaluación de la Unidad 3 — Encuentro 26 — Versión B

> Dominio de esta versión: **biblioteca del barrio** (gestión de préstamos de libros). Duración: 70 minutos. Puntaje total: 100 puntos. Resolución individual, con computadora, sin celular. Las condiciones completas están en `evaluacion-u3.md`.

## Antes de empezar

- Carpeta `evaluacion-u3/`, archivo `biblioteca.py`.
- Seguí las convenciones del curso. Toda entrada numérica validada con `try/except ValueError`.
- Métodos de texto: usá `split`, `strip`, `join`, `replace` donde corresponda.
- Al terminar: commit con `"evaluacion-u3: entrega"` y push.

## Objetivos de la prueba

1. Procesar texto del usuario con métodos de cadenas.
2. Validar entrada con `try/except` y reintento.
3. Construir un menú interactivo con opciones que procesen datos.

## Material provisto

No hay esqueleto. Datos de ejemplo: una lista `loanList` vacía que se llena durante la ejecución.

## Parte 1 — Parsear un préstamo (30 puntos)

El usuario ingresa una línea de texto con formato: `titulo del libro, dni del socio, cantidad de dias`. Por ejemplo: `"Cien Años de Soledad, 12345678, 7"`.

| Ítem | Consigna | Pts |
| --- | --- | --- |
| 1a | Función `parse_loan(loan_text)`: recibe un string, usa `split(",")` y `strip()` para separar y limpiar los campos. Devuelve un dict con `bookTitle`, `memberDni` (str) y `loanDays` (int). | 15 |
| 1b | Si la línea no tiene exactamente 3 campos separados por coma, mostrar "Formato inválido. Usá: titulo, dni, dias." | 10 |
| 1c | Si `loanDays` no es numérico, lanzar `ValueError` y capturarlo con mensaje claro. | 5 |
| **Total Parte 1** | | **30** |

## Parte 2 — Validación y registro (40 puntos)

| Ítem | Consigna | Pts |
| --- | --- | --- |
| 2a | Función `add_loan()`: pide al usuario una línea de texto, llama a `parse_loan()`, y si es válida agrega el préstamo a `loanList`. Usá `try/except ValueError` para capturar errores de conversión. | 15 |
| 2b | Función `valid_dni(dni)`: recibe un string, limpia espacios con `strip()`, verifica que tenga exactamente 8 dígitos numéricos. Devuelve `True` o `False`. | 10 |
| 2c | Al agregar un préstamo, pedir también DNI y validarlo con `valid_dni()`. Si no es válido, pedir de nuevo. | 10 |
| 2d | Generar número de préstamo aleatorio con `random.randint(1000, 9999)` y mostrarlo al confirmar el alta. Hacé `import random` al inicio. | 5 |
| **Total Parte 2** | | **40** |

## Parte 3 — Menú y reporte (20 puntos)

| Ítem | Consigna | Pts |
| --- | --- | --- |
| 3a | Menú principal: 1-Nuevo préstamo, 2-Listar préstamos, 3-Salir | 5 |
| 3b | Opción 2 (Listar): mostrar todos los préstamos con título, DNI del socio, días y número de préstamo. | 10 |
| 3c | Opción inválida → "Opción inválida." | 5 |
| **Total Parte 3** | | **20** |

## Parte 4 — Ítems conceptuales (10 puntos)

| Ítem | Pregunta | Pts |
| --- | --- | --- |
| 4a | ¿Qué hace `split(",")` si el usuario no pone ninguna coma en el texto? | 5 |
| 4b | ¿Por qué conviene usar `try/except ValueError` en lugar de `if` para verificar que un texto sea numérico? | 5 |

## Batería de verificación

| Prueba | Pedido | Salida esperada |
| --- | --- | --- |
| Opción 1 (válido) | "Cien Años de Soledad, 12345678, 7" + DNI "12345678" | Préstamo agregado, muestra número aleatorio |
| Opción 1 (mal formato) | "Cien Años de Soledad, 12345678" | "Formato inválido. Usá: titulo, dni, dias." |
| Opción 1 (días no numéricos) | "Cien Años de Soledad, 12345678, siete" | Mensaje de error de conversión |
| Opción 1 (DNI inválido) | Préstamo válido + DNI "abc" | Pide DNI de nuevo |
| Opción 2 | Listar | Muestra todos los préstamos registrados |
| Opción 3 | Salir | "Saludos!" |

## Al terminar

Verificá ejecución: `python biblioteca.py`. Commit y push.