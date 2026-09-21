# Momento de intensificación y fortalecimiento — Unidades 3 y 4 (Encuentros 34-35)

> Momento de recuperación y profundización sobre los núcleos de la Unidad 3 (Datos estructurados y JSON) y la Unidad 4 (Proyecto integrador y Git profesional). **No imparte contenido nuevo**: consolida objetivos mínimos no alcanzados y extiende lo adquirido. Es el último momento de intensificación de la estructura anual; el Encuentro 36 es el cierre integral de la asignatura, sin evaluación.

## Datos del momento

| Campo | Valor |
|---|---|
| Momento de uso | Encuentros 34 y 35 — Intensificación y fortalecimiento de las Unidades 3 y 4 |
| Duración | 2 encuentros de 120 minutos |
| Destinatarios | Todo el curso, en dos pistas: grupo de intensificación (objetivos mínimos de U3 o U4 no alcanzados) y grupo de fortalecimiento (objetivos alcanzados; amplía sobre lo regular sin temas nuevos) |
| Requisitos | Unidades 3 y 4 cursadas; evaluaciones de los Encuentros 26 y 32 rendidas, con devolución recibida. Repositorio del grupo con `tp-u3/` y `trabajo-final/` |
| Lugar de trabajo | Laboratorio de informática. VS Code, terminal, Python 3.11, Git y GitHub; uso de celular: no permitido |

## Acuerdo pedagógico

### Grupo de intensificación (recuperación pedagógica)

| Componente | Acuerdo |
|---|---|
| Contenidos mínimos irrenunciables | Diccionarios: crear, leer y recorrer; lista de registros en memoria; guardado y carga de una colección completa en JSON con `json.load` y `json.dump(ensure_ascii=False, indent=2)`; menú con persistencia completa; flujo Git: rama, commit, PR simple |
| Actividad y metodología | Reconstrucción guiada de la agenda en JSON (`agenda_json.py`): cada paso repite el patrón del curso (carga segura con `FileNotFoundError`, validación con `in` antes de leer una clave, `try/except` específico) y se prueba en dos caminos |
| Recursos | VS Code + terminal; `tp-u3/` del grupo; hoja de errores comunes del curso |

### Grupo de fortalecimiento (profundización)

| Componente | Acuerdo |
|---|---|
| Contenidos de fortalecimiento | Extensión sobre lo regular sin temas nuevos: búsquedas y filtros combinados sobre la colección JSON, migración de la agenda TXT a JSON, reportes con acumuladores, funcionalidad opcional sobre el integrador y ensayo reforzado de la defensa |
| Actividad y metodología | Desafío de evolución: cada par extiende su colección con filtros y un reporte, y ensaya la defensa con preguntas cruzadas entre pares, siguiendo la rúbrica conocida |
| Recursos | VS Code + terminal; `trabajo-final/` del grupo; enunciado de funcionalidades opcionales |

## Encuentro 34 — Núcleos de ambas unidades, por pista

### Objetivos del encuentro

- Ubicar los objetivos mínimos de U3 y U4 pendientes, a partir de las devoluciones.
- Pista intensificación: reconstruir la agenda en JSON con carga y guardado seguros.
- Pista fortalecimiento: extender la colección con filtros combinados y un reporte.

### Agenda (120 minutos)

| Bloque | Minutos | Actividad |
|---|---|---|
| Plenaria conjunta de apertura | 15 | Repaso relámpago de los núcleos de U3 y U4 sobre la pizarra; lectura de las devoluciones propias y armado de las pistas |
| Trabajo por pistas | 70 | Intensificación: carga segura de JSON, alta de un registro como diccionario y listado con `for`. Fortalecimiento: filtro combinado sobre la colección y reporte con acumulador sobre su propio integrador |
| Plenaria conjunta de cierre | 25 | Puesta en común de errores comunes: `KeyError` por leer sin validar, `json.dump` sin `ensure_ascii=False`, confundir texto y JSON al mirar el archivo |
| Cierre y commit | 10 | Commit con mensaje que refiera al avance y `push` |

### Detalle de la pista de intensificación

**Carga y guardado seguros** (patrón canónico del curso):

```python
import json

RUTA_DATOS = "agenda.json"   # Constante arriba, en mayusculas


def cargar_agenda():
    # Devolver la agenda guardada; lista vacia si el archivo no existe
    try:
        with open(RUTA_DATOS, "r", encoding="utf-8") as f:
            return json.load(f)
    except FileNotFoundError:
        # Primera corrida: todavia no existe el archivo de datos
        return []


def guardar_agenda(agenda):
    # Sobrescribir el archivo con la agenda completa
    with open(RUTA_DATOS, "w", encoding="utf-8") as f:
        json.dump(agenda, f, ensure_ascii=False, indent=2)
```

1. Alta de un registro: construir el diccionario campo por campo (`nombre`, `telefono`) y agregarlo a la lista con `append`.
2. Listado: recorrer la lista con `for` y mostrar cada campo del diccionario.
3. Validar con `in` antes de leer una clave (`if "telefono" in registro:`).
4. Quien completa antes: abrir `agenda.json` desde VS Code y explicar qué cambió con `ensure_ascii=False` y `indent=2`.

### Detalle de la pista de fortalecimiento

1. Filtro combinado: listar los registros que cumplen dos condiciones a la vez (por ejemplo, dos campos con valores dados) sobre la propia colección.
2. Reporte con acumulador: contar cuántos registros cumplen cada condición y mostrar el total.
3. Ensayo de defensa: responder en pares tres preguntas tipo rúbrica sobre el propio integrador (por qué JSON, qué pasa sin archivo, qué valida el programa).
4. Quien completa antes: proponer y documentar una funcionalidad opcional para el integrador, sin implementarla todavía.

## Encuentro 35 — Cierre de pistas y puente al cierre integral

### Objetivos del encuentro

- Pista intensificación: completar el menú con persistencia JSON y realizar un ciclo completo de Git con PR.
- Pista fortalecimiento: implementar la funcionalidad opcional acordada y reforzar la defensa.
- Que cada estudiante llegue al Encuentro 36 con su estado frente a los mínimos explicitado.

### Agenda (120 minutos)

| Bloque | Minutos | Actividad |
|---|---|---|
| Plenaria conjunta de apertura | 10 | Objetivo del día y recordatorio del patrón de prueba en dos caminos |
| Trabajo por pistas | 80 | Intensificación: menú completo con alta, listado y salida que guarda; ciclo Git: rama por funcionalidad, commit, PR simple y cierre. Fortalecimiento: implementación de la funcionalidad opcional y ensayo de defensa de 5 minutos con preguntas cruzadas |
| Plenaria conjunta de cierre | 25 | Autoevaluación escrita frente a la lista de mínimos de U3 y U4; explicitación de lo que cada quien reforzará para la instancia de diciembre si hiciera falta |
| Cierre y commit | 5 | Commit final del momento y verificación del `push` |

### Detalle de la pista de intensificación

1. Menú con `while` en `main()`: alta, listado y salida; el guardado llama a `guardar_agenda()`.
2. Probar el ciclo completo: agregar un registro, salir, reabrir y listar; verificar el `agenda.json` resultante desde VS Code.
3. Ciclo Git completo: crear rama, hacer el trabajo, commit por avance, abrir PR y fusionarlo tras revisión del par.
4. Quien completa antes: agregar el manejo de `json.JSONDecodeError` con aviso y `sys.exit(1)`, y probarlo dañando el archivo a propósito.

### Detalle de la pista de fortalecimiento

1. Implementar la funcionalidad opcional documentada en el Encuentro 34, con su caso de prueba.
2. Ensayo de defensa de 5 minutos con preguntas cruzadas entre pares y lista breve de mejoras.
3. Revisión de README del integrador: que la portada refleje el estado real del proyecto.
4. Quien completa antes: revisar el PR de otro grupo y proponer una mejora concreta.

## Criterios de logro

### Grupo de intensificación

- Carga y guarda una lista de diccionarios con `json.load` y `json.dump(ensure_ascii=False, indent=2)`.
- Maneja el archivo de datos ausente con `except FileNotFoundError` y valor inicial `[]`.
- Valida con `in` antes de leer una clave y evita el `KeyError` sin manejar.
- El menú repite con `while`, delega en funciones y conserva los datos entre corridas.
- Realiza un ciclo Git completo: rama, commit con mensaje claro, PR revisado y fusión.

### Grupo de fortalecimiento

- Implementa un filtro combinado y un reporte con acumulador sobre la colección JSON.
- Agrega una funcionalidad opcional al propio proyecto, con su caso de prueba.
- Sostiene una defensa de 5 minutos respondiendo preguntas sobre decisiones del proyecto.
- Revisa el trabajo de otro par y formula una mejora concreta y justificada.

## Evaluación del momento

El momento tiene evaluación propia, en la carpeta de evaluaciones de los momentos del curso (ver README), con versiones equivalentes por grupo y criterio **Apto / No apto aún por objetivo mínimo** sobre los núcleos de U3 y U4. Quien no acredite en este momento llega con su diagnóstico explícito al cierre integral (Encuentro 36) y a la instancia de diciembre, que evalúa el camino mínimo completo del curso.
