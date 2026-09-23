# Evaluación de la Unidad 4 — Encuentro 32 — Versión A

> Dominio de esta versión: **verdulería** (los tokens de ejemplo usan el dominio del TP grupal). Duración: 40 minutos (ventana de verificación práctica). Puntaje total: 100 puntos (60 modificación + 20 explicación + 20 defensa). Resolución individual.

## Antes de empezar

- Trabajá sobre **tu copia local** del repositorio grupal del trabajo integrador.
- No crees una carpeta nueva: trabajá en el mismo `main.py` o en un archivo nuevo dentro del proyecto.
- Creá una rama nueva: `git switch -c evaluacion-u4` y al terminar hacé commit en esa rama (sin mergear a main).
- Seguí las convenciones del curso.

## Objetivos de la verificación

1. Demostrar que comprendés el código del trabajo integrador de tu grupo.
2. Realizar una modificación guiada sobre el programa existente.
3. Explicar por escrito los cambios realizados.

## Material provisto

Tu propio trabajo integrador del grupo en el estado en que quedó al cierre del encuentro 31.

## Parte 1 — Modificación guiada (60 puntos)

Agregá una **nueva funcionalidad** al programa integrador de tu grupo. La funcionalidad es la misma para todas las versiones, los ejemplos usan tokens del dominio verdulería:

**Consigna:** agregá una opción en el menú principal que permita al usuario **buscar un `producto` por nombre y mostrar su información completa** (nombre, `productPrice`, `stockWeight`). Si no existe, mostrar "Producto no encontrado."

| Ítem | Consigna | Pts |
| --- | --- | --- |
| 1a | Agregar la opción en el menú principal del programa (ej. "5. Buscar producto") | 10 |
| 1b | Implementar la función `find_product(name)` que recorre `productList` y devuelve el producto si existe, o `None` si no | 20 |
| 1c | Mostrar la información completa del producto (nombre, precio, kilos/copias disponibles) con f-strings | 15 |
| 1d | Validar que el nombre de búsqueda no esté vacío | 15 |
| **Total Parte 1** | | **60** |

## Parte 2 — Explicación escrita (20 puntos)

Agregá un comentario multilínea al final del archivo (o en un archivo `EXPLICACION.md` dentro de la rama) respondiendo:

| Ítem | Pregunta | Pts |
| --- | --- | --- |
| 2a | ¿Qué archivo(s) modificaste y qué función agregaste? | 10 |
| 2b | ¿Cómo verificaste que la modificación funciona? | 10 |
| **Total Parte 2** | | **20** |

## Parte 3 — Defensa individual (20 puntos)

Durante la defensa con el docente se evalúa:

| Ítem | Qué se observa | Pts |
| --- | --- | --- |
| 3a | El repositorio tiene README, issues cerrados, PR mergeados, main protegida | 10 |
| 3b | El estudiante ejecuta el programa, explica su módulo y responde preguntas | 10 |
| **Total Parte 3** | | **20** |

## Batería de verificación

| Prueba | Entrada | Salida esperada |
| --- | --- | --- |
| Opción 5 | `5` | Pide nombre del producto |
| Buscar producto existente | `papa` | Muestra nombre, precio y kilos |
| Buscar producto inexistente | `xyz` | "Producto no encontrado." |
| Buscar con nombre vacío | (enter) | "El nombre no puede estar vacío." |

## Al terminar

```bash
git add .
git commit -m "evaluacion-u4: agregar busqueda de producto"
# NO hacer push a main. Solo dejar el commit en la rama evaluacion-u4.
# El docente revisa la rama durante la defensa.
```
