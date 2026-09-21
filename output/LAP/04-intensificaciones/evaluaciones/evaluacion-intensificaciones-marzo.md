# Evaluación de la instancia de marzo — Camino mínimo completo del curso

> Documento de la instancia de evaluación de marzo (fuera de la estructura anual). La consigna de cada versión está en su documento propio (`evaluacion-intensificaciones-marzo-version-a.md` y `evaluacion-intensificaciones-marzo-version-b.md`). La guía de corrección está incluida en este documento; no se generan anexos separados para esta evaluación.

## Metadatos

| Campo | Valor |
|---|---|
| Materia | Programación en Python |
| Instancia | Instancia de intensificación de marzo, antes del nuevo ciclo; evaluación al cierre de sus dos encuentros, en el día y horario que disponga la institución |
| Duración | 90 minutos |
| Modalidad | Ejercicio práctico pequeño en el repositorio, con ciclo Git completo (rama, commits y push) |
| Entrega | Carpeta `intensificacion-marzo/` del repositorio del grupo, trabajada en una rama propia con commits por avance y push |
| Destinatarios | Estudiantes que no alcanzaron en diciembre y contaron con más tiempo de preparación (grupo único de intensificación) |
| Requisitos previos | Instancia de diciembre rendida con resultado no apto aún; material y devoluciones de diciembre disponibles; repositorio del grupo disponible |
| Lugar de trabajo | Laboratorio de informática: VS Code, terminal, Python 3.11, Git y GitHub |
| Celular | No permitido |
| Versiones | A (semillas de la huerta) y B (juegos de mesa), equivalentes entre sí y con dominios distintos de los de diciembre; asignación a cargo del docente |
| Criterio | Apto / No apto aún, por objetivo mínimo del camino |

## Acuerdo de evaluación

La instancia evalúa el **camino mínimo completo del curso** (U1 a U4) con el mismo estándar de diciembre —no baja— en un único ejercicio pequeño: un programa de consola que importa un legado en `.txt`, organiza los datos como lista de diccionarios con un campo numérico y los persiste en JSON, con alta, listado con condición y entrega por Git. Lo único que cambia respecto de diciembre es cuánto tiempo tuvo el estudiante para prepararse; por eso las versiones usan dominios de datos distintos de los de diciembre, equivalentes entre sí.

Las versiones A y B son equivalentes en dificultad: mismos objetivos y mismos requisitos, con distinto dominio de datos, y ninguna tiene reglas que la otra no tenga. Apto acredita los objetivos mínimos del curso. No apto aún al cierre de marzo: los objetivos siguen pendientes al finalizar las instancias de recuperación.

## Objetivos evaluados

- (U1) Usar variables con conversión de `input()`, decisión con `if/elif/else` y repetición con `while` y `for`.
- (U1) Convertir el dato numérico con `int()` dentro de `try/except ValueError`, con mensaje claro y reintento.
- (U2) Leer el archivo legado `.txt` con `with open(..., encoding="utf-8")`, separando los campos con `split(",")` y limpiándolos con `.strip()`, con `FileNotFoundError` manejado.
- (U2) Definir al menos cuatro funciones con `def` que reciben parámetros y devuelven datos o modifican la colección.
- (U3) Organizar los datos como lista de diccionarios y persistirlos con `json.load` y `json.dump(..., ensure_ascii=False, indent=2)`, validando con `in` antes de leer el campo numérico.
- (U4) Entregar por Git: carpeta, `.gitignore`, rama propia, commits por avance con mensajes claros y push verificado.
- Integración: conservar los datos en el ciclo importar/agregar-salir-reabrir-listar.

## Consigna general

Desarrollar `intensificacion-marzo/camino_minimo.py` en el repositorio: un programa de consola con menú que carga un archivo legado `.txt` (una línea por registro, `texto,texto`), importa cada línea como un diccionario con esos dos campos, permite agregar registros completos por teclado (con un campo numérico) y listar la colección con una condición de tres salidas sobre el campo numérico, guardando todo en un `.json`. El dominio de datos y los umbrales están en el documento de cada versión.

## Requisitos técnicos (canon de la materia)

- Esqueleto canónico: `import json`, constantes (`RUTA_LEGADO`, `RUTA_DATOS`), funciones con `def`, `def main():` y guard `if __name__ == "__main__":` al final.
- Toda conversión numérica en el renglón del `input()`, dentro de `try/except ValueError`, con reingreso; `try/except` siempre con la excepción específica, sin `except:` desnudo.
- Apertura de archivos siempre con `with open(ruta, modo, encoding="utf-8")`; `except FileNotFoundError` con valor inicial y aviso.
- Campos del legado separados con `split(",")` y limpiados con `.strip()`; líneas vacías filtradas con `if linea.strip() == ""`.
- Colección en JSON con `json.load` y `json.dump(..., ensure_ascii=False, indent=2)`; validación con `in` antes de leer el campo numérico.
- Mensajes visibles y comentarios en español, sin tildes ni eñes dentro del código; un comentario por cada acción.
- Sin clases, sin librerías externas, sin módulos propios; `.gitignore` con `__pycache__/`.

## Criterios de acreditación por objetivo

| Objetivo mínimo | Evidencia en el ejercicio | Apto cuando |
|---|---|---|
| Constructos básicos (U1) | Menú, alta y listado | Variables, `if/elif/else` y bucles `while`/`for` usados con corrección, sin tracebacks previstos |
| Conversión validada (U1) | Opción del menú y campo numérico | `int()` en el renglón del `input()`, con mensaje claro y reintento ante valor inválido |
| Legado `.txt` (U2) | Importación del legado | `with open(..., encoding="utf-8")`, `split(",")` + `.strip()`, líneas vacías filtradas y `FileNotFoundError` manejado con aviso |
| Funciones (U2) | Código del programa | Al menos cuatro funciones con `def` que reciben parámetros y devuelven datos o modifican la colección |
| Colección JSON (U3) | Guardado y listado | Lista de diccionarios; `json.load`/`json.dump(..., ensure_ascii=False, indent=2)`; validación con `in` antes de leer el campo numérico |
| Entrega por Git (U4) | Historial y repositorio remoto | Carpeta correcta, `.gitignore` con `__pycache__/`, rama propia, commits por avance con mensajes claros y push verificado |
| Conservación de datos | Ciclo importar/agregar-salir-reabrir-listar | Los datos siguen disponibles tras reabrir y el `.json` verificado desde VS Code coincide |

**Regla de decisión:** el resultado es **Apto** cuando los siete objetivos figuran acreditados, con el mismo estándar de diciembre. Con al menos un objetivo sin acreditar, el resultado es **No apto aún**: los objetivos mínimos siguen pendientes al finalizar las instancias de recuperación.

## Guía de corrección

### Solución esperada (común; el dominio cambia por versión)

- `cargar_legado()`: `with open(RUTA_LEGADO, "r", encoding="utf-8")` + `read().splitlines()`; filtrar líneas vacías; por línea, `split(",")` + `.strip()` de cada campo; `except FileNotFoundError` → `[]` con aviso.
- `importar_legado(coleccion, legado)`: si la colección ya tiene registros, avisar y no importar de nuevo; si no, construir por cada línea un diccionario con los dos campos del legado y agregarlo con `append` (sin campo numérico: queda pendiente).
- `agregar_registro(coleccion)`: pedir por teclado los tres campos; el numérico con `int()` bajo `try/except ValueError` con reingreso; construir el diccionario campo por campo y agregar con `append`.
- `listado(coleccion)`: `for` sobre la lista; validar con `in` antes de leer el campo numérico; si está, decidir la condición con `if/elif/else` (tres salidas según los umbrales de la versión) y acumular el contador de la primera condición; si no está, mostrar «(sin dato)»; lista vacía → aviso.
- `guardar(coleccion)`: `with open(RUTA_DATOS, "w", encoding="utf-8")` y `json.dump(..., ensure_ascii=False, indent=2)`.
- `main()`: menú `while` con opciones 1 (importar), 2 (agregar), 3 (listado) y 0 (salir guardando); la opción se lee con `int()` validado.

### Errores que invalidan el objetivo

- `open()` sin `encoding="utf-8"`, o `FileNotFoundError` sin manejar: objetivo del legado no acreditado.
- `split(",")` sin `.strip()`, o líneas vacías procesadas como registro: objetivo del legado no acreditado (defecto canon observable).
- `json.dump` sin `ensure_ascii=False` o sin `indent=2`, o guardado con modo `"a"`: objetivo JSON no acreditado (observable en el archivo).
- Lectura del campo numérico sin validar con `in`: objetivo JSON no acreditado.
- Importar que duplica registros al repetirse, o conversión sin `try/except ValueError`: objetivos de integración y U1 no acreditados según corresponda.
- Entrega sin rama propia, sin `.gitignore` o con push sin verificar: objetivo de Git no acreditado.

### Registro del resultado

- Planilla mínima: apellido y nombre; grupo; versión; siete columnas de objetivos; resultado final.
- Apto: acredita los objetivos mínimos del curso. No apto aún: se consignan los pendientes al cierre de las instancias de recuperación.

## Desarrollo del bloque de evaluación (90 minutos)

| Momento | Minutos |
|---|---|
| Lectura de la consigna y de la versión asignada | 10 |
| Desarrollo del programa en el repositorio | 55 |
| Prueba de los dos caminos y verificación del `.json` desde VS Code | 10 |
| Entrega: rama, commits, push y verificación en GitHub | 15 |
| **Total** | **90** |

## Versiones

| Versión | Dominio de datos | Consigna |
|---|---|---|
| A | Semillas de la huerta (`semillas.txt` → `semillas.json`, campo numérico `cantidad`) | `evaluacion-intensificaciones-marzo-version-a.md` |
| B | Juegos de mesa (`juegos.txt` → `juegos.json`, campo numérico `jugadores`) | `evaluacion-intensificaciones-marzo-version-b.md` |
