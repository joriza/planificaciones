# Momento de intensificación y fortalecimiento — Unidades 1 y 2, primera instancia (Encuentros 17-18)

> Momento de recuperación y profundización sobre los núcleos de la Unidad 1 (Fundamentos de Python) y la Unidad 2 (Funciones y archivos de texto). **No imparte contenido nuevo**: consolida objetivos mínimos no alcanzados y extiende lo adquirido. Los temas nuevos de la Unidad 3 comienzan en el Encuentro 21.

## Datos del momento

| Campo | Valor |
|---|---|
| Momento de uso | Encuentros 17 y 18 — Intensificación y fortalecimiento de las Unidades 1 y 2 (primera instancia) |
| Duración | 2 encuentros de 120 minutos |
| Destinatarios | Todo el curso, en dos pistas: grupo de intensificación (objetivos mínimos de U1 o U2 no alcanzados) y grupo de fortalecimiento (objetivos alcanzados; amplía sobre lo regular sin adelantar la Unidad 3) |
| Requisitos | Unidades 1 y 2 cursadas; evaluaciones de los Encuentros 9 y 15 rendidas, con devolución recibida. Repositorio del grupo con `tp-u1/` y `tp-u2/` |
| Lugar de trabajo | Laboratorio de informática. VS Code, terminal, Python 3.11, Git y GitHub; uso de celular: no permitido |

## Acuerdo pedagógico

### Grupo de intensificación (recuperación pedagógica)

| Componente | Acuerdo |
|---|---|
| Contenidos mínimos irrenunciables | Programa de consola con variables, tipos, `input`/`print`, condicionales y bucles; funciones con `def` y `return`; lectura y escritura de un `.txt` con `with open` y `FileNotFoundError`; menú con persistencia en un solo `.py` |
| Actividad y metodología | Reconstrucción guiada de la agenda mínima (`agenda.py`): cada paso repite el patrón del curso (convertir `input`, `try/except` específico, `with open` con `encoding="utf-8"`) y se prueba con dos caminos: normal y de error |
| Recursos | VS Code + terminal; `tp-u1/` y `tp-u2/` del grupo; hoja de errores comunes del curso |

### Grupo de fortalecimiento (profundización)

| Componente | Acuerdo |
|---|---|
| Contenidos de fortalecimiento | Extensión sobre lo regular sin adelantar U3: validación de datos con reintento, búsquedas y filtros sobre listas, opciones extra del menú (modificar y eliminar), reportes con acumuladores sobre cadenas y listas |
| Actividad y metodología | Desafío de evolución: cada par extiende su propia `agenda.py` con dos funcionalidades nuevas y las documenta; revisión cruzada entre pares con la hoja de errores comunes |
| Recursos | VS Code + terminal; `tp-u2/` del grupo; enunciado de funcionalidades opcionales |

## Encuentro 17 — Núcleos de ambas unidades, por pista

### Objetivos del encuentro

- Ubicar los objetivos mínimos de U1 y U2 que cada estudiante tiene pendientes, a partir de las devoluciones.
- Pista intensificación: reconstruir la agenda mínima con menú, funciones y un archivo de texto.
- Pista fortalecimiento: extender la propia agenda con validaciones y una funcionalidad nueva documentada.

### Agenda (120 minutos)

| Bloque | Minutos | Actividad |
|---|---|---|
| Plenaria conjunta de apertura | 15 | Repaso relámpago de los núcleos de U1 y U2 sobre la pizarra; lectura de las devoluciones propias y armado de las pistas |
| Trabajo por pistas | 70 | Intensificación: pasos 1-3 de la agenda mínima (esqueleto, carga segura, alta y listado). Fortalecimiento: incorporar validación con reintento y la primera funcionalidad opcional a la propia `agenda.py` |
| Plenaria conjunta de cierre | 25 | Puesta en común de errores comunes: `input` sin convertir, modo `"w"` que sobrescribe, `except` desnudo, `open` sin `encoding` |
| Cierre y commit | 10 | Rutina de cierre del curso: `git add .`, commit con mensaje que refiera al avance, `push` |

### Detalle de la pista de intensificación

**Paso 1 — Esqueleto del programa** (constantes, funciones, `main()` y guard, con la forma fija del curso):

```python
RUTA_DATOS = "contactos.txt"   # Archivo de datos junto al programa


def cargar_contactos():
    # Devolver la lista guardada; lista vacia si el archivo no existe
    try:
        with open(RUTA_DATOS, "r", encoding="utf-8") as f:
            return f.read().splitlines()
    except FileNotFoundError:
        # Primera corrida: todavia no existe el archivo de datos
        return []


def guardar_contactos(contactos):
    # Sobrescribir el archivo con la lista completa
    with open(RUTA_DATOS, "w", encoding="utf-8") as f:
        for contacto in contactos:
            f.write(contacto + "\n")
```

**Paso 2 — Carga al inicio de `main()`** y verificación de los dos caminos: con y sin `contactos.txt` en la carpeta.

**Paso 3 — Alta y listado con menú**:

```python
def alta(contactos):
    # Pedir los datos del nuevo contacto
    nombre = input("Nombre: ")
    telefono = input("Telefono: ")
    # Guardar el contacto como una linea nombre,telefono
    contactos.append(nombre + "," + telefono)
    print("Contacto agregado")


def listado(contactos):
    # Mostrar todos los contactos guardados
    for contacto in contactos:
        print(contacto)
```

Menu con `while` y `if/elif/else` dentro de `main()`; opción de salir que llama a `guardar_contactos`.

**Quien completa antes:** probar el caso de error de la carga (renombrar el archivo) y explicar por qué el programa arranca igual.

### Detalle de la pista de fortalecimiento

1. Validación con reintento: `telefono = input(...)` acepta solo dígitos; si no, volver a pedir con mensaje claro (patrón `ValueError` del curso).
2. Primera funcionalidad opcional: elegir entre buscar por nombre, modificar un contacto o eliminarlo, y documentarla en un comentario de encabezado.
3. Revisión cruzada en pares con la hoja de errores comunes del curso.
4. Quien completa antes: agregar la segunda funcionalidad opcional y un caso de prueba para cada camino.

## Encuentro 18 — Cierre de pistas y autoevaluación frente a los mínimos

### Objetivos del encuentro

- Pista intensificación: completar la agenda mínima con persistencia real y verificarla con los dos caminos.
- Pista fortalecimiento: cerrar el desafío de evolución y presentarlo brevemente.
- Que cada estudiante compare su estado con los objetivos mínimos de U1 y U2 antes del momento integrador.

### Agenda (120 minutos)

| Bloque | Minutos | Actividad |
|---|---|---|
| Plenaria conjunta de apertura | 10 | Objetivo del día y recordatorio del patrón de prueba en dos caminos |
| Trabajo por pistas | 85 | Intensificación: alta + listado + persistencia completa; prueba del ciclo completo (agregar, salir, reabrir, listar). Fortalecimiento: segunda funcionalidad, reporte con acumulador (por ejemplo, contactos por inicial) y ensayo de demostración de 3 minutos |
| Plenaria conjunta de cierre | 20 | Demostraciones breves de la pista de fortalecimiento; autoevaluación escrita de la pista de intensificación frente a la lista de mínimos |
| Cierre y commit | 5 | Commit final del encuentro y verificación del `push` |

### Detalle de la pista de intensificación

1. Completar `main()`: menú con alta, listado y salida; guardado al salir.
2. Probar el ciclo completo: crear dos contactos, salir, volver a entrar y listarlos; abrir `contactos.txt` desde VS Code para verificar qué quedó escrito.
3. Agregar el manejo de `ValueError` si la agenda guarda una edad numérica.
4. Quien completa antes: responder por escrito ¿qué pasa si se agregan dos contactos con el mismo nombre? y proponer la regla que usaría el programa.

### Detalle de la pista de fortalecimiento

1. Segunda funcionalidad opcional sobre la propia agenda, con su caso de prueba.
2. Reporte con acumulador sobre el listado (por ejemplo: cuántos contactos empiezan con cada letra, o cuántos hay en total por archivo).
3. Ensayo de demostración de 3 minutos: qué extiende, cómo lo probó, qué error evitó.
4. Quien completa antes: revisar el repositorio de otro grupo y proponer una mejora concreta.

## Criterios de logro

### Grupo de intensificación

- Ejecuta un programa de consola con `python agenda.py` desde la terminal.
- Lee y escribe un archivo de texto con `with open(..., encoding="utf-8")`, sin `FileNotFoundError` sin manejar.
- Define al menos dos funciones con `def` que reciben parámetros y modifican o devuelven datos.
- El menú repite con `while` y delega en funciones con `if/elif/else`.
- El ciclo agregar-salir-reabrir-listar conserva los datos.
- Convierte `input()` numérico con `int()` y maneja `ValueError` con mensaje claro.

### Grupo de fortalecimiento

- Extiende la agenda con dos funcionalidades nuevas, cada una con su caso de prueba.
- Implementa validación de entrada con reintento en lugar de cortar el programa.
- Produce un reporte con acumulador sobre la colección guardada.
- Presenta en 3 minutos qué extendió, cómo lo probó y qué error anticipó.

## Evaluación del momento

El momento tiene evaluación propia, en la carpeta de evaluaciones de los momentos del curso (ver README), con versiones equivalentes por grupo y criterio **Apto / No apto aún por objetivo mínimo** sobre los núcleos de U1 y U2. El resultado define el acompañamiento en el momento integrador (Encuentros 19-20); la Unidad 3 no se adelanta en ninguno de los dos casos.
