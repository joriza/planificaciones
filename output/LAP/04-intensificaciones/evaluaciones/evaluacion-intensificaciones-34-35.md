# Evaluación del momento de intensificación — Unidades 3 y 4 (Encuentros 34-35)

> Documento de la instancia de evaluación del momento de las Unidades 3 y 4. La consigna de cada versión está en su documento propio (`evaluacion-intensificaciones-34-35-version-a.md` y `evaluacion-intensificaciones-34-35-version-b.md`). La guía de corrección está incluida en este documento; no se generan anexos separados para esta evaluación.

## Metadatos

| Campo | Valor |
|---|---|
| Materia | Programación en Python |
| Instancia | Momento de intensificación y fortalecimiento de las Unidades 3 y 4 — Encuentros 34 y 35; resolución en el segundo encuentro, en el bloque que el docente disponga |
| Duración | 60 minutos |
| Modalidad | Ejercicio práctico pequeño en el repositorio del grupo, con ciclo Git completo (rama, commits, PR y fusión) |
| Entrega | Carpeta `intensificacion-34-35/` del repositorio del grupo, trabajada en una rama propia y fusionada por PR revisado |
| Destinatarios | Todo el curso (las dos pistas del momento); el ejercicio acredita los objetivos mínimos de U3 y U4 |
| Requisitos previos | Unidades 3 y 4 cursadas; Encuentros 34 y 35 trabajados; repositorio del grupo con `tp-u3/` y `trabajo-final/` y push funcionando |
| Lugar de trabajo | Laboratorio de informática: VS Code, terminal, Python 3.11, Git y GitHub |
| Celular | No permitido |
| Versiones | A (libros leídos) y B (videojuegos jugados), equivalentes; asignación por grupo a cargo del docente |
| Criterio | Apto / No apto aún, por objetivo mínimo |

## Acuerdo de evaluación

La evaluación del momento acredita los núcleos de la Unidad 3 (diccionarios, lista de registros, colección completa en JSON con `json.load` y `json.dump(ensure_ascii=False, indent=2)`, validación con `in`) y de la Unidad 4 (flujo Git profesional: rama por funcionalidad, commits con mensajes claros, PR revisado y fusión) en un ejercicio pequeño: un programa de consola con menú que administra una colección personal en JSON con alta, listado y salida que guarda, entregado con el ciclo Git completo. Sin temas nuevos.

Las versiones A y B son equivalentes en dificultad: mismos objetivos y mismos requisitos, con distinto dominio de datos, y ninguna tiene reglas que la otra no tenga. Su propósito es que la elección de versión no otorgue ventaja ni habilite la copia entre grupos. Quien no acredite en este momento llega con su diagnóstico explícito al cierre integral (Encuentro 36) y a la instancia de diciembre.

## Objetivos evaluados

- Cargar la colección con `json.load` y manejar el archivo ausente con `except FileNotFoundError` devolviendo la lista vacía.
- Guardar la colección completa con `json.dump(datos, f, ensure_ascii=False, indent=2)` en modo `"w"`.
- Construir cada registro como diccionario, agregarlo con `append` y recorrer la lista con `for`, validando con `in` antes de leer una clave.
- Repetir el menú con `while` delegando en funciones, y conservar los datos entre corridas (ciclo agregar-salir-reabrir-listar).
- Realizar el ciclo Git completo: rama propia, commits con mensajes claros, PR revisado por el par y fusión.

## Consigna general

Desarrollar el programa de la versión asignada al grupo, en la carpeta `intensificacion-34-35/` del repositorio, en un único archivo `.py`: un programa de consola con menú que administra una colección personal guardada en un `.json` junto al programa (lista de diccionarios con tres campos, uno de ellos numérico). La consigna completa con el dominio de datos está en el documento de cada versión.

## Requisitos técnicos (canon de la materia)

- Esqueleto canónico: `import json`, constantes (`RUTA_DATOS`), funciones con `def`, `def main():` como punto de entrada y guard `if __name__ == "__main__":` al final.
- Carga canónica de la colección: `try`, `with open(ruta, "r", encoding="utf-8")` y `json.load(f)`; `except FileNotFoundError` → `[]` con aviso.
- Guardado canónico: `with open(ruta, "w", encoding="utf-8")` y `json.dump(datos, f, ensure_ascii=False, indent=2)`.
- Conversión numérica en el renglón del `input()`, dentro de `try/except ValueError`, con reingreso; `try/except` siempre con la excepción específica.
- Validación con `in` antes de leer una clave de un diccionario; listado con `for`.
- Mensajes visibles y comentarios en español, sin tildes ni eñes dentro del código; un comentario por cada acción.
- Sin clases, sin librerías externas, sin módulos propios; sin `except:` desnudo.

## Criterios de acreditación por objetivo

| Objetivo mínimo | Evidencia en el ejercicio | Apto cuando |
|---|---|---|
| Carga JSON segura | Función de carga | `json.load` con `with open(..., encoding="utf-8")`; archivo ausente manejado con `except FileNotFoundError` y lista vacía con aviso |
| Guardado JSON completo | Función de guardado | `json.dump(..., ensure_ascii=False, indent=2)` en modo `"w"`; el archivo revisado en VS Code muestra tildes reales y formato indentado |
| Registros como diccionarios | Alta y listado | El diccionario se construye campo por campo y se agrega con `append`; el listado recorre con `for` y valida con `in` antes de leer una clave |
| Menú con persistencia | Ciclo agregar-salir-reabrir-listar | El menú repite con `while` y delega en funciones; los datos se conservan tras reabrir y coinciden con el `.json` |
| Ciclo Git completo | Historial y PR en GitHub | Rama propia con commits de mensaje claro, PR abierto, revisado por el par y fusionado |

**Regla de decisión:** el resultado es **Apto** cuando los cinco objetivos figuran acreditados. Con al menos un objetivo sin acreditar, el resultado es **No apto aún**, y se registran los objetivos pendientes como insumo del cierre integral (Encuentro 36) y de la instancia de diciembre, que evalúa el camino mínimo completo del curso.

## Guía de corrección

### Solución esperada (común; el dominio cambia por versión)

- `cargar_coleccion()`: patrón canónico del curso — `try`, `with open(RUTA, "r", encoding="utf-8")`, `json.load(f)`; `except FileNotFoundError` → `[]` con aviso de primera corrida.
- `alta(coleccion)`: pedir los tres campos; el numérico con `int()` bajo `try/except ValueError` con reingreso; construir el diccionario campo por campo y agregar con `append`.
- `listar(coleccion)`: `for` sobre la lista; validar con `in` (por ejemplo `if "titulo" in registro:`) antes de leer cada clave; lista vacía → aviso.
- `guardar(coleccion)`: `with open(RUTA, "w", encoding="utf-8")` y `json.dump(coleccion, f, ensure_ascii=False, indent=2)`.
- `main()`: menú `while` con opciones 1, 2 y 0; la opción se lee con `int()` validado; guardar al salir.
- Evidencia de Git en GitHub: rama `int-34-35`, commits por avance, PR con revisión del par y fusión.

### Errores que invalidan el objetivo

- `json.dump` sin `ensure_ascii=False` (el archivo muestra `\u00f1`) o sin `indent=2`: objetivo 2 no acreditado (defecto observable en el archivo).
- Guardado con modo `"a"` o parcial (sin reescribir la colección completa): objetivos 2 y 4 no acreditados (datos duplicados al reabrir).
- Lectura de clave sin validar con `in`: objetivo 3 no acreditado (riesgo de `KeyError` sin manejar).
- Menú sin `while`, o alta y listado resueltos dentro de `main()` sin funciones: objetivos 3 y 4 no acreditados.
- Fusión directa sobre `main` sin rama, PR sin revisión del par, o commits sin mensaje claro: objetivo 5 no acreditado.

### Registro del resultado

- Planilla mínima: grupo; versión; cinco columnas de objetivos; resultado final; enlace al PR fusionado.
- Apto: cinco objetivos acreditados. No apto aún: se consignan los pendientes y se comunican como insumo del cierre integral (36) y de la instancia de diciembre.

## Desarrollo del bloque de evaluación (60 minutos)

| Momento | Minutos |
|---|---|
| Lectura de la consigna y de la versión asignada | 5 |
| Desarrollo del programa en la rama del grupo | 30 |
| Prueba de los dos caminos y verificación del `.json` desde VS Code | 10 |
| Ciclo Git: commits, push, PR, revisión del par y fusión | 15 |
| **Total** | **60** |

## Versiones

| Versión | Dominio de datos | Programa | Consigna |
|---|---|---|---|
| A | Libros leídos (`libros.json`: `titulo`, `autor`, `paginas`) | `intensificacion-34-35/libros.py` | `evaluacion-intensificaciones-34-35-version-a.md` |
| B | Videojuegos jugados (`videojuegos.json`: `titulo`, `plataforma`, `horas`) | `intensificacion-34-35/videojuegos.py` | `evaluacion-intensificaciones-34-35-version-b.md` |
