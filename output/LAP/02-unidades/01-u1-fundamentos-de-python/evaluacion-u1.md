# Evaluación de la Unidad 1 — Fundamentos de Python

> Documento de la instancia de evaluación. La consigna de cada versión está en su documento propio (`evaluacion-u1-version-a.md` y `evaluacion-u1-version-b.md`); las soluciones y los criterios de corrección, en los anexos docentes.

## Metadatos

| Campo | Valor |
|---|---|
| Materia | Programación en Python |
| Instancia | Evaluación de la Unidad 1 — Encuentro dedicado 9 |
| Duración | 120 minutos |
| Modalidad | Ejercicio práctico por grupo de repositorio, con defensa individual |
| Entrega | Repositorio GitHub del grupo, carpeta `evaluacion-u1/`, con commit y push dentro del encuentro |
| Destinatarios | Estudiantes de la materia en condición regular |
| Requisitos previos | Repositorio del grupo creado y con push funcionando (Encuentro 7); contenidos de los Encuentros 4 a 8 |
| Lugar de trabajo | Aula de informática: VS Code, terminal, Python 3.11, Git y GitHub |
| Celular | No permitido |
| Versiones | A (gestión de notas) y B (inventario de productos), equivalentes; asignación por grupo a cargo del docente |
| Aprobación | 60 puntos o más de 100 en la rúbrica, y defensa individual con resultado apto |

## Acuerdo de evaluación

La evaluación de la Unidad 1 consiste en un ejercicio práctico pequeño que integra los contenidos de la unidad: un programa de consola que procesa una colección de datos ingresados por teclado y emite un reporte final. El ejercicio se desarrolla y se entrega en el encuentro dedicado: la entrega se realiza por GitHub (commit y push) y cada integrante sostiene una defensa individual breve sobre el trabajo entregado. El encuentro siguiente abre con la devolución del trabajo y de las defensas.

Las versiones A y B son equivalentes en dificultad: mismos objetivos y mismos requisitos, con distinto dominio de datos; ninguna tiene reglas que la otra no tenga. Su propósito es que la elección de versión no otorgue ventaja ni habilite la copia entre grupos. La asignación la realiza el docente al inicio del encuentro, alternando versiones entre grupos vecinos.

## Objetivos evaluados

- Escribir un programa de consola en un único archivo `.py`, con el esqueleto canónico de la materia, ejecutable con `python archivo.py`.
- Convertir y validar la entrada del teclado (`input()` siempre devuelve `str`), con reintento ante valores inválidos.
- Decidir con `if/elif/else` y repetir con `while` y `for`, acumulando resultados en contadores y listas.
- Emitir un reporte final protegido contra el caso límite de colección vacía.
- Entregar el trabajo en el repositorio del grupo con `commit` y `push` convencionales.

## Consigna general

Desarrollar el programa de la versión asignada al grupo, en la carpeta `evaluacion-u1/` del repositorio, en un único archivo `.py`. El programa procesa una colección pequeña de registros ingresados por teclado (cantidad + nombre + tres valores numéricos por registro) y emite una ficha por registro y un resumen final. La consigna completa con el dominio de datos está en el documento de cada versión.

## Requisitos técnicos (canon de la materia)

- Esqueleto canónico: constantes si hacen falta, funciones con `def`, `def main():` como punto de entrada y guard `if __name__ == "__main__":` al final.
- Toda conversión numérica en el mismo renglón del `input()`, dentro de `try/except ValueError`, con reingreso mediante `while True` + `break`.
- Listas con `append`, recorrido y `len()`; contadores y acumuladores inicializados antes del bucle y actualizados dentro.
- `try/except` siempre con la excepción específica; prohibido el `except:` desnudo.
- Mensajes visibles y comentarios en español, sin tildes ni eñes dentro del código; un comentario por cada acción.
- Sin clases, sin librerías externas, sin módulos propios y sin construcciones anidadas innecesarias.
- Probar los dos caminos: el caso válido y el caso de error; probar también el caso de colección vacía.

## Rúbrica (100 puntos)

| Criterio | Puntos |
|---|---|
| Entrada validada: conversiones con `try/except ValueError` y reingreso en todos los datos numéricos | 20 |
| Estructuras y cálculo: lista de tres valores por registro, promedio con `len()`, clasificación con `if/elif/else` | 25 |
| Reporte final: contadores por categoría, promedio general, porcentaje y mejor registro, protegidos contra la colección vacía | 15 |
| Estructura y estilo: esqueleto canónico, comentarios por acción, identificadores en español sin tildes | 20 |
| Entrega por GitHub: carpeta y archivo correctos, commit con mensaje convencional, push verificado, sin archivos extra | 20 |
| **Total** | **100** |

Los puntos de la rúbrica califican el trabajo entregado por el grupo. La defensa individual no suma puntos: es condición de aprobación para cada integrante. Quien no la sostenga no aprueba la unidad, con las capas de recuperación previstas en los criterios de aprobación de la asignatura.

## Defensa individual

Cada integrante explica, sin leer y en no más de tres minutos:

1. Qué hace el programa, mostrando su ejecución con un dato válido.
2. Una línea señalada por el docente: qué hace y por qué está ahí (una conversión, un `append`, una condición).
3. Un error previsto: mostrar en vivo qué ocurre al ingresar una letra donde va un número.

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

| Versión | Dominio de datos | Archivo esperado |
|---|---|---|
| A | Gestión de notas de un parcial | `evaluacion-u1/reporte_notas.py` |
| B | Inventario de stock en tres depósitos | `evaluacion-u1/reporte_stock.py` |

Ambas versiones exigen exactamente las mismas estructuras y reportes: cantidad con reingreso, registro con nombre limpio y tres valores numéricos en una lista, promedio por registro con `len()`, clasificación con `if/elif/else`, resumen con contadores, promedio general, porcentaje y mejor registro, y protección del caso vacío. Solo cambia el dominio de los datos.

## Devolución

El Encuentro 10 abre con la devolución del trabajo calificado y del registro de defensas.
