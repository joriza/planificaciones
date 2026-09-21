# Evaluación del momento de intensificación — Unidades 1 y 2, primera instancia (Encuentros 17-18)

> Documento de la instancia de evaluación del momento de las Unidades 1 y 2. La consigna de cada versión está en su documento propio (`evaluacion-intensificaciones-17-18-version-a.md` y `evaluacion-intensificaciones-17-18-version-b.md`). La guía de corrección está incluida en este documento; no se generan anexos separados para esta evaluación.

## Metadatos

| Campo | Valor |
|---|---|
| Materia | Programación en Python |
| Instancia | Momento de intensificación y fortalecimiento de las Unidades 1 y 2 (primera instancia) — Encuentros 17 y 18; resolución en el segundo encuentro, en el bloque que el docente disponga |
| Duración | 60 minutos |
| Modalidad | Ejercicio práctico pequeño en el repositorio del grupo, con un único archivo `.py` |
| Entrega | Carpeta `intensificacion-17-18/` del repositorio del grupo, con commit y push dentro del bloque |
| Destinatarios | Todo el curso (las dos pistas del momento); el ejercicio acredita los objetivos mínimos de U1 y U2 |
| Requisitos previos | Unidades 1 y 2 cursadas; Encuentros 17 y 18 trabajados; repositorio del grupo con push funcionando |
| Lugar de trabajo | Laboratorio de informática: VS Code, terminal, Python 3.11, Git y GitHub |
| Celular | No permitido |
| Versiones | A (lista de tareas pendientes) y B (películas por ver), equivalentes; asignación por grupo a cargo del docente |
| Criterio | Apto / No apto aún, por objetivo mínimo |

## Acuerdo de evaluación

La evaluación del momento acredita los núcleos de la Unidad 1 (variables y tipos, `input`/`print` con conversión, condicionales, bucles) y de la Unidad 2 (funciones con `def`, archivos de texto con `with open`, `FileNotFoundError`, menú con persistencia) en un ejercicio pequeño: un programa de consola que administra una colección en un `.txt` con alta, listado y salida que guarda. Sin contenido de la Unidad 3: sin diccionarios ni JSON.

Las versiones A y B son equivalentes en dificultad: mismos objetivos y mismos requisitos, con distinto dominio de datos, y ninguna tiene reglas que la otra no tenga. Su propósito es que la elección de versión no otorgue ventaja ni habilite la copia entre grupos. El resultado define el acompañamiento en el momento integrador (Encuentros 19-20); la Unidad 3 no se adelanta en ningún caso.

## Objetivos evaluados

- Ejecutar el programa con `python archivo.py` desde la terminal, sin traceback en las situaciones previstas.
- Definir al menos tres funciones con `def` que reciben parámetros y devuelven datos o modifican la colección.
- Leer y escribir el archivo de datos con `with open(..., encoding="utf-8")`; archivo ausente manejado con `except FileNotFoundError` y arranque con lista vacía.
- Repetir el menú con `while` y delegar en las funciones con `if/elif/else`.
- Convertir el dato numérico con `int()` dentro de `try/except ValueError`, con mensaje claro y reintento.
- Conservar los datos en el ciclo agregar-salir-reabrir-listar, verificando el archivo desde VS Code.

## Consigna general

Desarrollar el programa de la versión asignada al grupo, en la carpeta `intensificacion-17-18/` del repositorio, en un único archivo `.py`: un programa de consola con menú que administra una colección guardada en un `.txt` junto al programa (una línea por registro, con el formato `texto,numero`). La consigna completa con el dominio de datos está en el documento de cada versión.

## Requisitos técnicos (canon de la materia)

- Esqueleto canónico: constantes si hacen falta, funciones con `def`, `def main():` como punto de entrada y guard `if __name__ == "__main__":` al final.
- Toda conversión numérica en el mismo renglón del `input()`, dentro de `try/except ValueError`, con reingreso mediante `while True` + `break`.
- Apertura de archivos siempre con `with open(ruta, modo, encoding="utf-8")`; modos `"r"` para leer y `"w"` para reescribir completo.
- `try/except` siempre con la excepción específica; prohibido el `except:` desnudo.
- Mensajes visibles y comentarios en español, sin tildes ni eñes dentro del código; un comentario por cada acción.
- Sin clases, sin librerías externas, sin módulos propios; listas con `append` y recorrido con `for`.
- Probar los dos caminos: el caso normal y el caso de error (archivo ausente, número inválido).

## Criterios de acreditación por objetivo

| Objetivo mínimo | Evidencia en el ejercicio | Apto cuando |
|---|---|---|
| Ejecución en consola | Corrida con `python archivo.py` | El programa corre y toda situación prevista se resuelve con mensaje claro, sin traceback |
| Funciones con `def` | Código del programa | Al menos tres funciones reciben parámetros y devuelven datos o modifican la colección |
| Archivo de datos con `with open` y `FileNotFoundError` | Carga y guardado | Ambas operaciones usan `encoding="utf-8"`; el archivo ausente arranca con lista vacía y aviso |
| Menú con `while` y delegación | `main()` | El menú repite hasta la salida y cada opción delega en funciones con `if/elif/else` |
| Conversión numérica y `ValueError` | Opción del menú y dato numérico del alta | `int()` en el renglón del `input()`, con mensaje claro y reintento ante valor inválido |
| Persistencia del ciclo | Prueba agregar-salir-reabrir-listar | Los datos siguen disponibles tras reabrir y el `.txt` verificado desde VS Code coincide |

**Regla de decisión:** el resultado es **Apto** cuando los seis objetivos figuran acreditados. Con al menos un objetivo sin acreditar, el resultado es **No apto aún**, y se registran los objetivos pendientes como insumo del acompañamiento en el momento integrador (Encuentros 19-20).

## Guía de corrección

### Solución esperada — Versión A (tareas pendientes)

- `cargar_tareas()`: `with open(RUTA, "r", encoding="utf-8")` + `read().splitlines()`; `except FileNotFoundError` → `[]` con aviso de primera corrida.
- `agregar_tarea(tareas)`: pedir descripción y prioridad; `int(input())` bajo `try/except ValueError` con reingreso; `tareas.append(descripcion + "," + str(prioridad))`.
- `listar_tareas(tareas)`: `for` sobre la lista; mostrar descripción y prioridad (separar con `split(",")` si se presenta con formato); lista vacía → aviso.
- `guardar_tareas(tareas)`: `with open(RUTA, "w", encoding="utf-8")` y una línea por tarea con `f.write(tarea + "\n")`.
- `main()`: menú `while` con opciones 1, 2 y 0; la opción se lee con `int()` validado; guardar al salir.

### Solución esperada — Versión B (películas por ver)

- Misma estructura de cuatro funciones y `main()`, con dominio `titulo,anio`: título y año de estreno; el año es el dato numérico validado.
- Nombres de funciones acordes al dominio (`cargar_peliculas()`, `agregar_pelicula()`, `listar_peliculas()`, `guardar_peliculas()`); el patrón es exactamente el mismo.

### Errores que invalidan el objetivo

- `open()` sin `encoding="utf-8"` en lectura o escritura: objetivo 3 no acreditado (defecto del canon).
- `except:` desnudo, o `FileNotFoundError` sin manejar con valor inicial `[]`: objetivo 3 no acreditado.
- Conversión sin `try/except ValueError`, o con mensaje sin reintento: objetivo 5 no acreditado.
- Menú que corta tras una opción (sin `while`), o lógica de alta/listado resuelta dentro de `main()` sin funciones: objetivos 2 y 4 no acreditados.
- Ciclo agregar-salir-reabrir-listar que pierde los datos, o guardado con `"w"` fuera de la salida: objetivo 6 no acreditado.

### Registro del resultado

- Planilla mínima: grupo; versión; seis columnas de objetivos; resultado final.
- Apto: seis objetivos acreditados. No apto aún: se consignan los pendientes y se comunican como insumo del momento integrador (19-20).

## Desarrollo del bloque de evaluación (60 minutos)

| Momento | Minutos |
|---|---|
| Lectura de la consigna y de la versión asignada | 5 |
| Desarrollo del programa en el repositorio del grupo | 35 |
| Prueba de los dos caminos y verificación del `.txt` desde VS Code | 10 |
| Entrega: `commit`, `push` y verificación en GitHub | 10 |
| **Total** | **60** |

## Versiones

| Versión | Dominio de datos | Programa | Consigna |
|---|---|---|---|
| A | Lista de tareas pendientes (`tareas.txt`, `descripcion,prioridad`) | `intensificacion-17-18/tareas.py` | `evaluacion-intensificaciones-17-18-version-a.md` |
| B | Películas por ver (`peliculas.txt`, `titulo,anio`) | `intensificacion-17-18/peliculas.py` | `evaluacion-intensificaciones-17-18-version-b.md` |
