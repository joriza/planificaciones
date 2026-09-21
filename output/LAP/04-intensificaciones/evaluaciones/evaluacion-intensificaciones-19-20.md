# Evaluación del momento integrador — Proyecto puente Unidades 1 y 2 (Encuentros 19-20)

> Documento de la instancia de evaluación del momento integrador de las Unidades 1 y 2. La consigna de cada versión está en su documento propio (`evaluacion-intensificaciones-19-20-version-a.md` y `evaluacion-intensificaciones-19-20-version-b.md`). La guía de corrección está incluida en este documento; no se generan anexos separados para esta evaluación.

## Metadatos

| Campo | Valor |
|---|---|
| Materia | Programación en Python |
| Instancia | Momento integrador de las Unidades 1 y 2 (proyecto puente) — Encuentros 19 y 20; resolución en el Encuentro 20, en el bloque que el docente disponga tras la demostración del proyecto puente |
| Duración | 60 minutos |
| Modalidad | Ejercicio práctico pequeño por grupo, con defensa breve del grupo |
| Entrega | Carpeta `intensificacion-19-20/` del repositorio del grupo, con commits por avance y push dentro del bloque |
| Destinatarios | Todo el curso, en grupos de trabajo (única pista, sin diferenciación por condición) |
| Requisitos previos | Núcleos de U1 y U2 trabajados en los Encuentros 17 a 20; repositorio del grupo disponible |
| Lugar de trabajo | Laboratorio de informática: VS Code, terminal, Python 3.11, Git y GitHub |
| Celular | No permitido |
| Versiones | A (comisión de examen) y B (inscriptos de un torneo), equivalentes; asignación por grupo a cargo del docente |
| Aprobación | 60 puntos o más de 100 en la rúbrica, y defensa breve del grupo con resultado apto |

## Acuerdo de evaluación

La evaluación del momento integrador acredita la integración de los núcleos de la Unidad 1 (variables y tipos, `input` con conversión, condicionales, bucles, cadenas con `split`/`strip`) y de la Unidad 2 (funciones con `def`, `with open` en modos `r`/`w`, `FileNotFoundError`, menú con `while` y persistencia) en un ejercicio pequeño: un programa de consola que administra la lista de asistencia de una jornada a partir de un archivo de datos dado. Sin contenido de la Unidad 3: sin diccionarios ni JSON.

Las versiones A y B son equivalentes en dificultad: mismos objetivos y mismos requisitos, con distinto dominio de datos, y ninguna tiene reglas que la otra no tenga. Su propósito es que la elección de versión no otorgue ventaja ni habilite la copia entre grupos. Hay una única consigna para todo el curso, sin diferenciación por condición.

## Objetivos evaluados

- Cargar la colección desde el archivo de datos con `FileNotFoundError` manejado, separando los campos con `split(",")` y limpiándolos con `.strip()`.
- Definir al menos cuatro funciones con `def` y responsabilidad única: cargar, listado del día, cambiar estado y guardar.
- Decidir la condición de cada registro con `if/elif/else` y contar las presencias con un acumulador.
- Repetir el menú con `while` y validar la opción con `try/except ValueError`, con mensaje claro y reintento.
- Guardar la colección completa con `with open(..., "w", encoding="utf-8")` y conservar los datos en el ciclo marcar-salir-reabrir-listar.
- Entregar por Git con commits por avance y push, y defender una decisión de diseño y un error anticipado.

## Consigna general

Desarrollar `intensificacion-19-20/asistencia.py` en el repositorio del grupo: un programa de consola con menú que administra la asistencia de una jornada a partir de un archivo de datos dado, con una línea por persona en el formato `nombre,apellido,grupo,estado`, donde el estado es P (presente), A (ausente) o T (tardío). El programa ofrece el listado del día con condición y total de presentes, el cambio de estado por apellido y la salida que guarda. El archivo inicial y el detalle completo están en el documento de cada versión.

## Requisitos técnicos (canon de la materia)

- Esqueleto canónico: constantes si hacen falta, funciones con `def`, `def main():` como punto de entrada y guard `if __name__ == "__main__":` al final.
- Toda conversión numérica en el mismo renglón del `input()`, dentro de `try/except ValueError`, con reingreso mediante `while True` + `break`.
- Apertura de archivos siempre con `with open(ruta, modo, encoding="utf-8")`; modos `"r"` para leer y `"w"` para reescribir completo.
- `try/except` siempre con la excepción específica; prohibido el `except:` desnudo.
- Cada línea del archivo de datos se separa con `split(",")` y cada campo se limpia con `.strip()`.
- Mensajes visibles y comentarios en español, sin tildes ni eñes dentro del código; un comentario por cada acción.
- Sin clases, sin librerías externas, sin módulos propios; listas con `append` y recorrido con `for`.
- Probar los dos caminos: el caso normal y el caso de error (archivo ausente, opción inválida).

## Rúbrica (100 puntos)

| Criterio | Puntos |
|---|---|
| Carga y campos: `FileNotFoundError` manejado con lista vacía; `split(",")` y `.strip()` en cada línea del archivo de datos | 15 |
| Estructura funcional: al menos cuatro funciones con responsabilidad única; menú con `while` y opción validada con `try/except ValueError` y reintento | 20 |
| Registro y listado: condición P/A/T con `if/elif/else`; búsqueda por apellido con aviso si no está; total de presentes con acumulador, protegido contra la lista vacía | 20 |
| Persistencia: guardado completo con `with open(..., "w", encoding="utf-8")`; ciclo marcar-salir-reabrir-listar conserva los datos | 15 |
| Estructura y estilo: esqueleto canónico, comentarios por acción, español sin tildes ni eñes en el código | 10 |
| Entrega por Git: carpeta correcta, commits por avance con mensajes claros, push verificado | 10 |
| Defensa breve: decisión de diseño y error anticipado, explicados con palabras propias | 10 |
| **Total** | **100** |

Los puntos de la rúbrica califican el trabajo entregado por el grupo. La defensa breve no suma puntos: es condición de aprobación del grupo. Quien no la sostenga no acredita el momento, con las capas de recuperación previstas en los criterios de aprobación de la asignatura.

## Defensa breve del grupo

Cada grupo presenta, en no más de tres minutos:

1. El programa corriendo, con un dato válido del listado del día.
2. Una decisión de diseño: qué eligieron y por qué (por ejemplo, cómo buscan el apellido o cómo validan el estado).
3. Un error anticipado: qué podría fallar y cómo lo previene el programa.

El docente registra apto / no apto por grupo.

## Guía de corrección

### Solución esperada (común; el dominio cambia por versión)

- `cargar_registros()`: `with open(RUTA, "r", encoding="utf-8")` + `read().splitlines()`; por línea, `split(",")` y `.strip()` de cada campo; `except FileNotFoundError` → `[]` con aviso de primera corrida.
- `listado_del_dia(registros)`: `for` sobre los registros; condición con `if/elif/else`: P → «Presente», A → «Ausente», T → «Tardío»; acumulador de presentes y total al final; lista vacía → aviso sin operar.
- `cambiar_estado(registros)`: pedir el apellido, recorrer y comparar campo a campo; pedir el nuevo estado y validarlo con `if/elif/else` (solo P, A o T); apellido inexistente → «No se encontro ese apellido».
- `guardar_registros(registros)`: `with open(RUTA, "w", encoding="utf-8")` reescribiendo todos los registros, uno por línea.
- `main()`: menú `while` con opciones 1, 2 y 0; la opción se lee con `int()` validado; guardar al salir.

### Errores que invalidan el criterio

- `open()` sin `encoding="utf-8"`, o `FileNotFoundError` sin manejar: criterio de carga (15 puntos) sin acreditar.
- `split(",")` sin `.strip()`: comparaciones con espacios residuales y estados que no coinciden; afecta carga y listado.
- Estado cambiado sin validar P/A/T, o condición resuelta con `if` anidados sin `elif`: afecta el criterio de registro y listado.
- Guardado con `"w"` que escribe solo el último registro, o guardado ausente al salir: criterio de persistencia sin acreditar.
- `except:` desnudo, o lógica de las operaciones resuelta completa dentro de `main()` sin funciones: afecta estructura funcional y estilo.

### Registro del resultado

- Planilla mínima: grupo; versión; puntos por criterio; total sobre 100; resultado de la defensa (apto / no apto).
- Aprobación: 60 puntos o más y defensa apta. Menos de 60 puntos o defensa no apta: el grupo queda con acompañamiento pautado; la Unidad 3 se abre en el Encuentro 21 sin adelantar contenido.

## Desarrollo del bloque de evaluación (60 minutos)

| Momento | Minutos |
|---|---|
| Lectura de la consigna y de la versión asignada | 5 |
| Desarrollo del programa en el repositorio del grupo | 30 |
| Prueba de los dos caminos y verificación del archivo de datos | 10 |
| Entrega: `commit`, `push` y verificación en GitHub | 5 |
| Defensas breves por grupo (3 minutos por grupo) | 10 |
| **Total** | **60** |

## Versiones

| Versión | Dominio de datos | Programa | Consigna |
|---|---|---|---|
| A | Comisión de examen (`comision.txt`, `nombre,apellido,curso,estado`) | `intensificacion-19-20/asistencia.py` | `evaluacion-intensificaciones-19-20-version-a.md` |
| B | Inscriptos de un torneo (`torneo.txt`, `nombre,apellido,equipo,estado`) | `intensificacion-19-20/asistencia.py` | `evaluacion-intensificaciones-19-20-version-b.md` |
