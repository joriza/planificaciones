# Continuidad pedagógica 4 — Repaso de las Unidades 1, 2 y 3

> Documento de continuidad pedagógica: actividades de repaso y fijación para desarrollar en una clase sin presencia docente. Se entrega a la administración para los casos de ausencia del docente. Repasa lo visto hasta su momento de uso: las Unidades 1, 2 y 3 completas. Es la base del proyecto integrador de la Unidad 4.

## Datos de referencia

| Campo | Valor |
| --- | --- |
| Curso | Programación en Python |
| Momento de uso | Tramo posterior a la Evaluación de la Unidad 3 (Encuentros 27 a 31) |
| Duración teórica | 120 minutos |
| Modalidad de trabajo | Resolución en grupo, según la organización habitual de la asignatura; presentación individual y manuscrita |
| Requisitos | Computadora con Python 3.11, VS Code y terminal; repositorio del grupo en GitHub con la carpeta `continuidad/` |

## Objetivos

- Organizar registros con diccionarios dentro de una lista.
- Cargar y guardar colecciones en JSON con `json.load()` y `json.dump()` (`ensure_ascii=False`).
- Procesar un CSV a mano con `split()` y `strip()`, descartando las líneas vacías.
- Validar con `in` antes de leer una clave de un diccionario.
- Manejar `FileNotFoundError` y `json.JSONDecodeError` con mensajes claros.

## Actividades puntuadas (100 puntos · 120 minutos)

| Nº | Actividad | Tiempo | Puntaje |
| --- | --- | --- | --- |
| 1 | Mapa de tres formatos | 15 min | 10 puntos |
| 2 | Corregir el bloque de datos | 25 min | 30 puntos |
| 3 | Programa de repaso: alumnos en JSON | 45 min | 35 puntos |
| 4 | Migración de formato: CSV → JSON | 20 min | 15 puntos |
| 5 | Entrega y cierre | 15 min | 10 puntos |
| | **Totales** | **120 min** | **100 puntos** |

En cada actividad, la presentación individual manuscrita consiste en transcribir a mano el resultado indicado más una observación propia del integrante.

### Actividad 1 — Mapa de tres formatos (15 min · 10 puntos)

El grupo completa en papel una tabla comparativa de los tres formatos trabajados (TXT, CSV, JSON), con una fila por formato: qué guarda, cómo se lee en el curso (¿con qué funciones o comandos?) y en qué caso conviene elegirlo.

Presentación manuscrita: la fila del formato que el grupo elegiría para una agenda, con una razón.

### Actividad 2 — Corregir el bloque de datos (25 min · 30 puntos)

El siguiente bloque tiene **cinco errores sembrados**. Encontrarlos, corregirlos y anotar el síntoma que produce cada uno:

```python
# Bloque de datos con errores

RUTA_DATOS = "alumnos.json"

def cargar_alumnos():
    # Leer la coleccion completa de alumnos.
    try:
        with open(RUTA_DATOS, "r", encoding="utf-8") as f:
            return json.load(f)
    except FileNotFoundError:
        return []

def guardar_alumnos(alumnos):
    # Sobrescribir el archivo con la coleccion completa.
    with open(RUTA_DATOS, "w", encoding="utf-8") as f:
        json.dump(alumnos, f)

def leer_csv(ruta):
    # Leer un CSV a mano.
    registros = []
    with open(ruta, "r", encoding="utf-8") as f:
        for linea in f:
            campos = linea.split(",")
            registros.append(campos)
    return registros

def promedio_de(alumno):
    # Devolver el promedio del alumno.
    return alumno["promedio"]
```

Presentación manuscrita: los cinco errores con su corrección y su síntoma.

### Actividad 3 — Programa de repaso: alumnos en JSON (45 min · 35 puntos)

Escribir un programa `alumnos.py` con el esqueleto canónico del curso que trabaje sobre una colección de alumnos guardada en `alumnos.json` (cada alumno es un diccionario con `nombre`, `edad` y `promedio`), con este menú:

```text
1) Agregar alumno: pedir nombre, edad (reintento try/except ValueError)
   y promedio (reintento con float) y agregar el diccionario a la lista.
2) Lista de alumnos: recorrer la coleccion y mostrar cada registro.
3) Buscar por nombre: mostrar el alumno cuyo nombre coincida, o avisar
   si no existe.
0) Guardar y salir: escribir la coleccion completa con json.dump() y
   terminar.
```

Al abrir: cargar la colección con `json.load()` dentro de un `try`; si el archivo no existe, avisar «No existe el archivo de datos: se empieza de cero» y arrancar con la lista vacía; si el JSON está dañado, avisar «El archivo de datos está dañado» y terminar con `sys.exit(1)`.

Al guardar: usar `json.dump(..., ensure_ascii=False, indent=2)` y verificar el archivo en VS Code.

Probar los dos caminos: primera corrida sin archivo y una corrida completa con alta, búsqueda, guardado y reapertura.

Presentación manuscrita: el archivo `alumnos.json` resultante (o sus primeras líneas), copiado a mano.

### Actividad 4 — Migración de formato: CSV → JSON (20 min · 15 puntos)

Dado el archivo `alumnos.csv`:

```text
Ana,19,8.5
Luis,20,6.0

José,21,7.0
```

Escribir un programa `migrar.py` que lea el CSV a mano (`split(",")` por línea, `strip()` en cada campo, descarte de la línea vacía), arme la lista de diccionarios y la guarde en `alumnos_migrados.json` con `ensure_ascii=False` e `indent=2`. Verificar el archivo generado: deben quedar tres registros y «José» debe verse con la tilde real, no escapada.

Presentación manuscrita: el contenido de `alumnos_migrados.json`, copiado a mano.

### Actividad 5 — Entrega y cierre (15 min · 10 puntos)

Guardar `alumnos.py` y `migrar.py` en la carpeta `continuidad/` del repositorio del grupo y realizar el ciclo de entrega:

```bash
git add .
git commit -m "continuidad: repaso de json y csv con dicts"
git push
```

Presentación manuscrita: qué formato elegirían para el proyecto integrador y una razón.

## Autoevaluación

Marcar con una cruz lo que se pueda afirmar al terminar la clase:

- [ ] Puedo explicar qué guarda un diccionario y cómo se recorre una lista de diccionarios.
- [ ] Mis `json.dump()` llevan `ensure_ascii=False` y mi archivo muestra las tildes reales.
- [ ] Mi lectura de CSV descarta la línea vacía con `strip()` y `continue`.
- [ ] Validé las claves con `in` antes de leer un diccionario (Actividad 2).
- [ ] Mi programa maneja archivo ausente y JSON dañado con mensajes propios, sin `traceback`.
- [ ] El commit del grupo quedó subido a GitHub con el mensaje pedido.

## Nota académica

La resolución de las actividades se realiza en la forma habitual de la asignatura, por lo general en grupo. Las tareas de programación requieren el uso de la computadora. La presentación es individual y manuscrita, al inicio de la próxima clase, y constituye una actividad más de la asignatura que forma parte del proceso de evaluación.
