# Evaluación de la Unidad 2 — Funciones y archivos de texto

> Documento de la instancia de evaluación. La consigna de cada versión está en su documento propio (`evaluacion-u2-version-a.md` y `evaluacion-u2-version-b.md`); las soluciones y los criterios de corrección, en los anexos docentes.

## Metadatos

| Campo | Valor |
|---|---|
| Materia | Programación en Python |
| Instancia | Evaluación de la Unidad 2 — Encuentro dedicado 15 |
| Duración | 120 minutos |
| Modalidad | Ejercicio práctico por grupo de repositorio, con defensa individual |
| Entrega | Repositorio GitHub del grupo, carpeta `evaluacion-u2/`, con commit y push dentro del encuentro |
| Destinatarios | Estudiantes de la materia en condición regular |
| Requisitos previos | Contenidos de los Encuentros 10 a 14 (incluidos los de la Unidad 1 que la unidad reutiliza); repositorio del grupo con push funcionando |
| Lugar de trabajo | Aula de informática: VS Code, terminal, Python 3.11, Git y GitHub |
| Celular | No permitido |
| Versiones | A (gestión de notas) y B (inventario de productos), equivalentes; asignación por grupo a cargo del docente |
| Aprobación | 60 puntos o más de 100 en la rúbrica, y defensa individual con resultado apto |

## Acuerdo de evaluación

La evaluación de la Unidad 2 consiste en un ejercicio práctico pequeño que integra los contenidos de la unidad: un programa de consola con menú que descompone su trabajo en funciones y persiste datos en un archivo de texto plano creado y leído por el propio programa. El ejercicio se desarrolla y se entrega en el encuentro dedicado: la entrega se realiza por GitHub (commit y push) y cada integrante sostiene una defensa individual breve sobre el trabajo entregado. El encuentro siguiente abre con la devolución del trabajo y de las defensas.

Las versiones A y B son equivalentes en dificultad: mismos objetivos y mismos requisitos, con distinto dominio de datos; ninguna tiene reglas que la otra no tenga. Su propósito es que la elección de versión no otorgue ventaja ni habilite la copia entre grupos. La asignación la realiza el docente al inicio del encuentro, alternando versiones entre grupos vecinos.

## Objetivos evaluados

- Estructurar un programa con funciones (`def`, parámetros, `return`) y el esqueleto canónico de la materia.
- Persistir datos en un archivo de texto con `with open(ruta, modo, encoding="utf-8")`, usando el modo correcto para cada operación (`"r"`, `"a"`, `"w"`).
- Leer el archivo con `split(",")` y `.strip()`, filtrando las líneas vacías.
- Manejar `FileNotFoundError` de la primera corrida con el mensaje canónico y convertir la entrada numérica con reingreso ante `ValueError`.
- Entregar el trabajo en el repositorio del grupo con `commit` y `push` convencionales.

## Consigna general

Desarrollar el programa de la versión asignada al grupo, en la carpeta `evaluacion-u2/` del repositorio, en un único archivo `.py` junto a su archivo de datos. El programa ofrece un menú de seis opciones sobre una colección de registros de tres campos (`nombre,categoria,valor numerico`) persistida en texto plano: alta, listado, búsqueda, cálculo sobre la colección, eliminación y salida. La consigna completa con el dominio de datos está en el documento de cada versión.

## Requisitos técnicos (canon de la materia)

- Esqueleto canónico: constantes en `MAYUSCULAS_CON_GUIONES_BAJOS` (ruta de datos, texto del menú), funciones con `def`, `def main():` y guard `if __name__ == "__main__":` al final.
- Toda lectura y escritura con `with open(ruta, modo, encoding="utf-8")`; el modo de archivo es correcto para cada operación: `"r"` para leer, `"a"` para agregar, `"w"` para reescribir todo.
- Carga inicial: `except FileNotFoundError` con el mensaje «No existe el archivo de datos: se empieza de cero» y arranque con la colección vacía.
- Al leer: `.strip()` en cada línea y en cada campo; líneas vacías filtradas con `if linea.strip() == "": continue`; conversión numérica con `int()` bajo `try/except ValueError`.
- Excepciones específicas siempre; sin `except:` desnudo; sin `traceback` en situaciones previstas.
- Mensajes visibles y comentarios en español, sin tildes ni eñes dentro del código; un comentario por cada acción.
- Sin clases, sin librerías externas, sin módulos propios.
- Probar los dos caminos: con archivo de datos y sin archivo de datos.

## Rúbrica (100 puntos)

| Criterio | Puntos |
|---|---|
| Menú y funciones: seis opciones operativas, descomposición en funciones con `return` y esqueleto canónico | 25 |
| Persistencia en texto: `with open` con `encoding="utf-8"`, modos `"r"`, `"a"` y `"w"` correctos por operación | 25 |
| Lectura robusta: `split(",")` y `.strip()` por campo, filtrado de líneas vacías, conversión numérica validada con reingreso | 20 |
| Manejo de errores: `FileNotFoundError` con mensaje canónico, excepciones específicas, sin `traceback` previsto | 15 |
| Entrega por GitHub: carpeta y archivos correctos, commit convencional, push verificado, sin archivos extra | 15 |
| **Total** | **100** |

Los puntos de la rúbrica califican el trabajo entregado por el grupo. La defensa individual no suma puntos: es condición de aprobación para cada integrante. Quien no la sostenga no aprueba la unidad, con las capas de recuperación previstas en los criterios de aprobación de la asignatura.

## Defensa individual

Cada integrante explica, sin leer y en no más de tres minutos:

1. Qué hace el programa, mostrando su ejecución: una alta, un listado y una búsqueda.
2. Qué modo de apertura usa cada operación y por qué (`"a"` en el alta, `"w"` en la eliminación).
3. Qué ocurre la primera vez, sin archivo de datos, y cómo lo maneja el programa (mostrarlo en vivo).

El docente registra apto / no apto por integrante.

## Desarrollo del encuentro dedicado (120 minutos)

| Momento | Minutos |
|---|---|
| Asignación de versión y lectura de la consigna | 10 |
| Desarrollo del ejercicio en el repositorio del grupo | 55 |
| Entrega: `commit`, `push` y verificación en GitHub | 15 |
| Defensas individuales (2 a 3 minutos por integrante) | 40 |
| **Total** | **120** |

## Versiones

| Versión | Dominio de datos | Archivos esperados |
|---|---|---|
| A | Gestión de notas (libreta de notas) | `evaluacion-u2/libreta_notas.py` + `notas.txt` |
| B | Inventario de productos | `evaluacion-u2/registro_productos.py` + `productos.txt` |

Ambas versiones exigen exactamente el mismo programa: menú de seis opciones, archivo de texto de tres campos (`nombre,categoria,valor numerico`), alta con `"a"`, eliminación con `"w"`, carga segura de la primera corrida, listado, búsqueda, cálculo promediado sobre la colección y las mismas validaciones. Solo cambia el dominio de los datos.

## Devolución

El Encuentro 16 abre con la devolución del trabajo calificado y del registro de defensas.
