# Evaluación de la Unidad 3 — Encuentro 26 — Versión A

> Dominio de esta versión: **veterinaria** (gestión de pedidos). Duración: 70 minutos. Puntaje total: 100 puntos. Resolución individual, con computadora, sin celular.

## Antes de empezar

- Carpeta `evaluacion-u3/`, archivo `pizzeria.py`.
- Seguí las convenciones del curso. Toda entrada numérica validada con `try/except ValueError`.
- Métodos de texto: usá `split`, `strip`, `join`, `replace` donde corresponda.
- Al terminar: commit con `"evaluacion-u3: entrega"` y push.

## Objetivos de la prueba

1. Procesar texto del usuario con métodos de cadenas.
2. Validar entrada con `try/except` y reintento.
3. Construir un menú interactivo con opciones que procesen datos.

## Material provisto

No hay esqueleto. Datos de ejemplo: una lista `appointmentList` vacía que se llena durante la ejecución.

## Parte 1 — Parsear un turno (30 puntos)

El usuario ingresa una línea de texto con formato: `nombre del mascota, precioUnitario, cantidad`. Por ejemplo: `"Ana Lopez, 12.5, 3"`.

| Ítem | Consigna | Pts |
| --- | --- | --- |
| 1a | Función `parse_order(order_text)`: recibe un string, usa `split(",")` y `strip()` para separar y limpiar los campos. Devuelve un dict con `petName`, `consultPrice` (float) y `quantity` (int). | 15 |
| 1b | Si la línea no tiene exactamente 3 campos separados por coma, mostrar "Formato inválido. Usá: nombre, tarifa, cantidad." | 10 |
| 1c | Si `consultPrice` o `quantity` no son numéricos, lanzar `ValueError` y capturarlo con mensaje claro. | 5 |
| **Total Parte 1** | | **30** |

## Parte 2 — Validación y registro (40 puntos)

| Ítem | Consigna | Pts |
| --- | --- | --- |
| 2a | Función `add_order()`: pide al usuario una línea de texto, llama a `parse_order()`, y si es válida agrega el turno a `appointmentList`. Usá `try/except ValueError` para capturar errores de conversión. | 15 |
| 2b | Función `valid_phone(phone)`: recibe un string, limpia espacios y guiones con `replace()` y `strip()`, verifica que tenga al menos 7 dígitos. Devuelve `True` o `False`. | 10 |
| 2c | Al agregar un turno, pedir también teléfono y validarlo con `valid_phone()`. Si no es válido, pedir de nuevo. | 10 |
| 2d | Generar número de ticket aleatorio con `random.randint(1000, 9999)` y mostrarlo al confirmar el turno. Hacé `import random` al inicio. | 5 |
| **Total Parte 2** | | **40** |

## Parte 3 — Menú y reporte (20 puntos)

| Ítem | Consigna | Pts |
| --- | --- | --- |
| 3a | Menú principal: 1-Agregar turno, 2-Listar pedidos, 3-Salir | 5 |
| 3b | Opción 2 (Listar): mostrar todos los pedidos con nombre, teléfono, tarifa, cantidad y ticket. Formato de tarifa con 2 decimales. | 10 |
| 3c | Opción inválida → "Opción inválida." | 5 |
| **Total Parte 3** | | **20** |

## Parte 4 — Ítems conceptuales (10 puntos)

| Ítem | Pregunta | Pts |
| --- | --- | --- |
| 4a | ¿Qué hace `split(",")` si el usuario no pone ninguna coma en el texto? | 5 |
| 4b | ¿Por qué conviene usar `try/except ValueError` en lugar de `if` para verificar que un texto sea numérico? | 5 |

## Batería de verificación

| Prueba | Turno | Salida esperada |
| --- | --- | --- |
| Opción 1 (válido) | "Ana, 12.5, 3" | Turno agregado, muestra ticket aleatorio |
| Opción 1 (mal formato) | "Ana, 12.5" | "Formato inválido. Usá: nombre, tarifa, cantidad." |
| Opción 1 (tarifa no numérico) | "Ana, doce, 3" | Mensaje de error de conversión |
| Opción 1 (teléfono inválido) | "Ana, 12.5, 3", tel: "abc" | Pide teléfono de nuevo |
| Opción 2 | Listar | Muestra todos los pedidos registrados |
| Opción 3 | Salir | "Saludos!" |

## Al terminar

Verificá ejecución: `python pizzeria.py`. Commit y push.