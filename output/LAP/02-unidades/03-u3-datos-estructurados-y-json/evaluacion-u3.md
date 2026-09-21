# Evaluación de la Unidad 3 — Datos estructurados y JSON

> Documento de la instancia de evaluación. La consigna de cada versión está en su documento propio (`evaluacion-u3-version-a.md` y `evaluacion-u3-version-b.md`); las soluciones y los criterios de corrección, en los anexos docentes.

## Metadatos

| Campo | Valor |
|---|---|
| Materia | Programación en Python |
| Instancia | Evaluación de la Unidad 3 — Encuentro dedicado 26 |
| Duración | 120 minutos |
| Modalidad | Ejercicio práctico por grupo de repositorio, con defensa individual |
| Entrega | Repositorio GitHub del grupo, carpeta `evaluacion-u3/`, con commit y push dentro del encuentro |
| Destinatarios | Estudiantes de la materia en condición regular |
| Requisitos previos | Contenidos de los Encuentros 21 a 25 (incluidos los de las Unidades 1 y 2 que la unidad reutiliza); repositorio del grupo con push funcionando |
| Lugar de trabajo | Aula de informática: VS Code, terminal, Python 3.11, Git y GitHub |
| Celular | No permitido |
| Versiones | A (gestión de notas) y B (inventario de productos), equivalentes; asignación por grupo a cargo del docente |
| Aprobación | 60 puntos o más de 100 en la rúbrica, y defensa individual con resultado apto |

## Acuerdo de evaluación

La evaluación de la Unidad 3 consiste en un ejercicio práctico pequeño que integra los contenidos de la unidad: registros representados con diccionarios, una colección como lista de diccionarios y persistencia completa en JSON con la biblioteca estándar. El ejercicio se desarrolla y se entrega en el encuentro dedicado: la entrega se realiza por GitHub (commit y push) y cada integrante sostiene una defensa individual breve sobre el trabajo entregado. El encuentro siguiente abre con la devolución del trabajo y de las defensas.

Las versiones A y B son equivalentes en dificultad: mismos objetivos y mismos requisitos, con distinto dominio de datos; ninguna tiene reglas que la otra no tenga. Su propósito es que la elección de versión no otorgue ventaja ni habilite la copia entre grupos. La asignación la realiza el docente al inicio del encuentro, alternando versiones entre grupos vecinos.

## Objetivos evaluados

- Representar registros con diccionarios de claves canónicas y organizar la colección como lista de diccionarios.
- Persistir la colección completa con `json.load` y `json.dump(..., ensure_ascii=False, indent=2)`.
- Implementar la carga segura: `FileNotFoundError` con arranque en colección vacía y `json.JSONDecodeError` con aviso y `sys.exit(1)`.
- Consultar la colección: listado numerado, búsqueda sin distinguir mayúsculas y filtro por umbral numérico con exportación a un archivo de resultados que no pisa el archivo principal.
- Entregar el trabajo en el repositorio del grupo con `commit` y `push` convencionales.

## Consigna general

Desarrollar el programa de la versión asignada al grupo, en la carpeta `evaluacion-u3/` del repositorio, en un único archivo `.py` junto a su archivo de datos JSON. El programa ofrece un menú de cinco opciones sobre una colección de registros de tres claves (`nombre,categoria,valor numerico`): alta con nombre obligatorio, listado, búsqueda, filtro con exportación y salida guardando. La consigna completa con el dominio de datos está en el documento de cada versión.

## Requisitos técnicos (canon de la materia)

- Esqueleto canónico: `import` solo de lo usado (`json`, `sys`), constantes en `MAYUSCULAS_CON_GUIONES_BAJOS` (rutas de datos y de resultado, texto del menú), funciones con `def`, `def main():` y guard `if __name__ == "__main__":` al final.
- Toda lectura y escritura con `with open(ruta, modo, encoding="utf-8")`.
- Carga segura: `except FileNotFoundError` → colección vacía; `except json.JSONDecodeError` → aviso «El archivo de datos esta dañado» y `sys.exit(1)`.
- `json.dump(..., ensure_ascii=False, indent=2)` en toda escritura JSON.
- Guardado de la colección en cada alta y al salir.
- Opción de menú convertida con `int()` dentro de `try/except ValueError`, con reingreso.
- Excepciones específicas siempre; sin `except:` desnudo; sin `traceback` en situaciones previstas.
- Mensajes visibles y comentarios en español, sin tildes ni eñes dentro del código; un comentario por cada acción.
- Sin clases, sin librerías externas, sin módulos propios, sin comprensiones anidadas.
- Probar los tres caminos de carga: sin archivo, normal y con archivo dañado a mano.

## Rúbrica (100 puntos)

| Criterio | Puntos |
|---|---|
| Registros y colección: diccionarios con claves canónicas, alta con nombre obligatorio y guardado por alta | 20 |
| Persistencia JSON: `json.load`/`json.dump` con `ensure_ascii=False` e `indent=2`, carga segura con `FileNotFoundError` y `JSONDecodeError` + `sys.exit(1)`, guardado al salir | 25 |
| Consultas: listado numerado, búsqueda sin mayúsculas distintivas, filtro por umbral con exportación a `resultado.json` sin tocar el archivo principal | 25 |
| Canon de estructura y estilo: esqueleto, opción de menú validada, comentarios por acción, sin tildes en el código | 20 |
| Entrega por GitHub: carpeta y archivos correctos, commit convencional, push verificado, sin archivos extra | 10 |
| **Total** | **100** |

Los puntos de la rúbrica califican el trabajo entregado por el grupo. La defensa individual no suma puntos: es condición de aprobación para cada integrante. Quien no la sostenga no aprueba la unidad, con las capas de recuperación previstas en los criterios de aprobación de la asignatura.

## Defensa individual

Cada integrante explica, sin leer y en no más de tres minutos:

1. Por qué el registro se representa con un diccionario y no con una lista de campos.
2. Qué dos excepciones puede lanzar la carga del archivo de datos y qué hace el programa en cada caso (mostrar el camino del archivo dañado).
3. Cómo garantiza el filtro que el archivo principal no se pise al exportar (mostrar `resultado.json`).

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
| A | Gestión de notas | `evaluacion-u3/notas_json.py` + `notas.json` (y `resultado.json` generado) |
| B | Inventario de productos | `evaluacion-u3/inventario_json.py` + `inventario.json` (y `resultado.json` generado) |

Ambas versiones exigen exactamente el mismo programa: registro con tres claves (`nombre,categoria,valor numerico`), alta con nombre obligatorio, listado numerado, búsqueda exacta sin distinguir mayúsculas, filtro por umbral sobre el campo numérico con exportación a `resultado.json`, carga segura de los tres caminos y guardado en cada alta y al salir. Solo cambia el dominio de los datos y la dirección del umbral del filtro.

## Devolución

El Encuentro 27 abre con la devolución del trabajo calificado y del registro de defensas.
