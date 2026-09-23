# Continuidad pedagógica 03 — Tras la evaluación de la Unidad 2

> Programación en Python · Actividad de continuidad pedagógica · Tras el encuentro 15

## Datos de referencia

| Campo | Detalle |
| --- | --- |
| Curso | Programación en Python |
| Momento de uso | Después del encuentro 15 (evaluación de la Unidad 2) |
| Duración teórica | 120 minutos (2 horas reloj) |
| Requisitos | Contenidos de las Unidades 1 y 2: variables y tipos, entrada/salida, condicionales, bucles, contadores y acumuladores (U1); listas y métodos, mutabilidad, tuplas, conjuntos (`set`), diccionarios, funciones (`def`, `return`, ámbito local), bloque `if __name__ == "__main__"` (U2). Para las tareas de programación: computadora con Python 3 y VS Code. |
| Entrega | Individual, manuscrita (parte en papel) + archivos `.py` de las tareas de programación. |

## Objetivos

1. Manipular **listas** con sus métodos principales (`append`, `remove`, `pop`, `sort`, `index`) en ejercicios de código.
2. Distinguir **tuplas**, **conjuntos** y **diccionarios** según su uso y propiedades (mutabilidad, unicidad, clave↔valor).
3. Escribir **funciones** con `def` y `return`, diferenciando variables locales y globales.
4. Integrar estructuras de datos y funciones en un programa completo con `if __name__ == "__main__"`.

## Actividades

| # | Actividad | Puntaje | Tiempo estimado |
| --- | --- | --- | --- |
| 1 | **Completar código: métodos de listas (papel).** Dado un programa que opera sobre una lista de números, completá las líneas usando los métodos apropiados (`append`, `remove`, `pop`, `sort`, `index`). Indicá qué contiene la lista al final. | 15 | 20 min |
| 2 | **Elección de estructura (papel).** Para cada situación, elegí y justificá si conviene usar lista, tupla, conjunto o diccionario: (a) almacenar los días de la semana en orden, (b) guardar los nombres de estudiantes sin repetidos, (c) asociar un nombre de producto con su precio, (d) registrar temperaturas horarias de un día que no van a cambiar. | 15 | 20 min |
| 3 | **Escribir una función (papel).** Escribí el código de una función `calcular_promedio(lista_numeros)` que recibe una lista de `float` y devuelve el promedio. Incluí el `if __name__ == "__main__"` con un ejemplo de uso que cree una lista, llame a la función y muestre el resultado. | 20 | 25 min |
| 4 | **Hallar el error: ámbito y tipos (papel).** Cada fragmento tiene un error de ámbito (variable local usada como global) o de tipo (modificar una tupla, usar un conjunto con índice). Señalalo, explicá por qué está mal y corregilo. | 15 | 15 min |
| 5 | **Tarea de programación: gestor de contactos.** Escribí un programa `gestor_contactos.py` que: (a) use un diccionario donde cada clave es un nombre (`str`) y cada valor es un teléfono (`str`), (b) tenga una función `agregar_contacto(directorio, nombre, telefono)` que agrega un nuevo par, (c) tenga una función `listar_contactos(directorio)` que recorre el diccionario y muestra cada contacto, (d) en el bloque `if __name__` cree un directorio vacío, agregue al menos 3 contactos y los liste. Incluí comentarios. | 35 | 40 min |
| **Total** | | **100** | **120 min** |

## Autoevaluación

1. **¿Podés explicar la diferencia entre una lista y una tupla sin dudar?** Sí / Más o menos / No.
   *Reflexión breve: ¿en qué actividad usaste esa diferencia?*

2. **¿Cuándo usarías un conjunto (`set`) en lugar de una lista?** Lo tengo claro / Tengo dudas / No lo sé.
   *Reflexión breve: ¿qué propiedad del conjunto lo hace útil para evitar duplicados?*

3. **En tus funciones, ¿diferenciás bien las variables locales de las globales?** Siempre / A veces / Casi nunca.
   *Reflexión breve: ¿tuviste algún error de ámbito en la Actividad 4?*

4. **¿Recordás para qué sirve el bloque `if __name__ == "__main__"`?** Sí, lo explico / Lo uso pero no sé explicarlo / No.
   *Reflexión breve: ¿lo usaste en la Actividad 5?*

5. **¿Qué estructura de datos (lista, tupla, conjunto o diccionario) te resultó más difícil de entender y por qué?**
   *Escribí tu respuesta brevemente.*

## Nota académica

La resolución se realiza en forma habitual (por lo general, en grupo); las tareas de programación requieren el uso de la computadora; la presentación es individual y manuscrita, al inicio de la próxima clase, y constituye una actividad más de la asignatura que forma parte del proceso de evaluación.
