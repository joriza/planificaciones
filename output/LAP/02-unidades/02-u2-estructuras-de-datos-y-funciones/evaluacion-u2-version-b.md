# Evaluación de la Unidad 2 — Encuentro 15 — Versión A

> Dominio de esta versión: **taller de barrio** (gestión de herramientas y cuotas). Duración: 70 minutos. Puntaje total: 100 puntos. Resolución individual, con computadora, sin celular. Las condiciones completas están en `evaluacion-u2.md`.

## Antes de empezar

- Creá una carpeta `evaluacion-u2/` dentro de tu repositorio grupal.
- Dentro, creá un único archivo `taller.py`.
- Seguí las convenciones del curso: identificadores en inglés snake_case, comentarios y mensajes en español, f-strings, `if __name__ == "__main__":`, sin persistencia.
- Toda entrada numérica debe validarse con `while True` + `try/except ValueError`.
- Al terminar: `git add .`, `git commit -m "evaluacion-u2: entrega"`, `git push`.

## Objetivos de la prueba

1. Usar listas y diccionarios para modelar datos de un dominio.
2. Definir funciones con parámetros y valor de retorno.
3. Validar entrada del usuario con `try/except`.
4. Organizar el programa en un menú interactivo.

## Material provisto

No hay esqueleto. El estudiante escribe todo desde cero.

## Parte 1 — Datos y funciones de base (30 puntos)

Definí una lista `toolList` de herramientas del taller. Cada herramienta es un diccionario con `toolName`, `toolCondition` y `feePaid` (bool).

| Ítem | Consigna | Pts |
| --- | --- | --- |
| 1a | Crear `toolList` con al menos 4 herramientas de ejemplo | 10 |
| 1b | Función `list_members()` que muestre todos los herramientas con su estado de depósito | 10 |
| 1c | Función `find_member(name)` que busque por nombre (insensible a mayúsculas) y devuelva el herramienta o `None` | 10 |
| **Total** | | **30** |

## Parte 2 — Gestión de cuotas (40 puntos)

| Ítem | Consigna | Pts |
| --- | --- | --- |
| 2a | Menú principal con opciones: 1-Listar, 2-Pagar depósito, 3-Agregar herramienta, 4-Mostrar estadísticas, 5-Salir | 5 |
| 2b | Función `pay_fee(name)`: busca al herramienta por nombre, si existe y `feePaid` es `False`, lo cambia a `True`; si ya pagó, avisa. Toda entrada validada. | 15 |
| 2c | Función `add_member(name, age)`: agrega un nuevo herramienta con `feePaid = False`. Validar que no exista ya por nombre. | 15 |
| 2d | Opción inválida → mensaje claro y vuelve al menú | 5 |
| **Total** | | **40** |

## Parte 3 — Estadísticas (20 puntos)

| Ítem | Consigna | Pts |
| --- | --- | --- |
| 3a | Función `show_stats()`: mostrar cantidad de herramientas totales, cuántos pagaron la `toolDeposit` y cuántos deben | 10 |
| 3b | Función `active_members()`: mostrar solo los herramientas con depósito al día | 10 |
| **Total** | | **20** |

## Parte 4 — Ítems conceptuales (10 puntos)

Al final del archivo, en comentarios:

| Ítem | Pregunta | Pts |
| --- | --- | --- |
| 4a | ¿Qué ventaja tiene usar un diccionario para cada herramienta en lugar de listas paralelas? | 5 |
| 4b | ¿Qué devuelve una función si no tiene `return`? | 5 |

## Batería de verificación

| Prueba | Turno | Salida esperada |
| --- | --- | --- |
| Menú | Programa arranca | Menú con 5 opciones |
| Opción 1 | Listar | Muestra todos los herramientas con nombre, edad y estado de depósito |
| Opción 2 | "Ana", paga | Cambia a pagado, muestra confirmación |
| Opción 2 | "Ana" otra vez | "El herramienta ya tiene la depósito al día" |
| Opción 2 | "Inexistente" | "Herramienta no encontrado." |
| Opción 3 | "Nuevo", 16 | Agrega, muestra confirmación |
| Opción 3 | "Ana", 17 | "Ya existe un herramienta con ese nombre." |
| Opción 4 | Estadísticas | Muestra total, pagaron, deben |
| Opción 4 | activos | Solo herramientas con depósito al día |
| Opción 5 | Salir | "Saludos!" |
| Opción inválida | "9" | "Opción inválida." |

## Al terminar

Verificá que el archivo se ejecuta: `python taller.py`. Luego commit y push.