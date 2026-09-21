# Momento integrador — Proyecto puente Unidades 1 y 2 (Encuentros 19-20)

> Momento integrador de las Unidades 1 y 2: un proyecto puente para todo el curso, con una única pista y sin diferenciación por condición. **No imparte contenido nuevo**: integra los núcleos de U1 (Fundamentos de Python) y U2 (Funciones y archivos de texto) en una progresión, no en una repetición. Los temas nuevos de la Unidad 3 comienzan en el Encuentro 21.

## Datos del momento

| Campo | Valor |
|---|---|
| Momento de uso | Encuentros 19 y 20 — Momento integrador de las Unidades 1 y 2 (proyecto puente) |
| Duración | 2 encuentros de 120 minutos |
| Destinatarios | Todo el curso, en grupos de trabajo. Única pista: no hay diferenciación por condición |
| Requisitos | Haber trabajado los núcleos de U1 y U2 en los Encuentros 17-18. Entorno listo: VS Code, terminal, Python 3.11, Git y GitHub. Repositorio del grupo disponible |
| Lugar de trabajo | Laboratorio de informática; uso de celular: no permitido |

## Proyecto puente: registro de asistencia del curso

Cada grupo construye en la carpeta `puente/` de su repositorio un programa `asistencia.py` que administra la asistencia de una comisión, con los datos en `asistencia.txt` junto al programa. El proyecto **integra** (no repite): los fundamentos de U1 (variables y tipos, `input`/`print` con conversión, condicionales, bucles, listas y cadenas con `split`/`strip`) se usan como insumo de la estructura de U2 (funciones con `def` y `return`, `with open` en modos `r`/`w`/`a`, `FileNotFoundError`, menú con `while` y persistencia en un solo `.py`).

### Requisitos del programa

| Núcleo | Requisito |
|---|---|
| U1 — Fundamentos | Cargar la lista de estudiantes desde una línea del archivo (formato `nombre,apellido,grado`, separada con `split(",")` y `.strip()`); registrar presencias con contador; decidir la condición de cada estudiante (presente, ausente, tardío) con `if/elif/else` |
| U2 — Funciones y archivos | Al menos cuatro funciones: `cargar_registros()`, `registrar_asistencia()`, `listado_del_dia()`, `guardar_registros()`; carga con `FileNotFoundError` manejado; guardado con `with open(..., encoding="utf-8")` en modo `"w"` |
| Entrega | Carpeta `puente/` en el repositorio del grupo; commits por avance y `push` al cierre de cada encuentro |
| Defensa breve | Cada grupo muestra el programa corriendo y explica una decisión de diseño y un error que anticipó |

## Acuerdo pedagógico (todo el curso)

| Componente | Acuerdo |
|---|---|
| Contenidos integrados | Núcleos mínimos de U1 y U2 en un único programa con persistencia en `.txt`; sin contenido de U3 (sin diccionarios ni JSON) |
| Actividad y metodología | Trabajo en grupos con entregas por Git; Encuentro 19: diseño por issues simples y núcleo del programa; Encuentro 20: completar, probar en dos caminos, demostrar. Rotación de roles: quien escribe, quien prueba, quien comenta |
| Recursos | VS Code + terminal; Python 3.11; Git y GitHub; repositorio del grupo; consigna del proyecto y rúbrica de 100 puntos |

## Encuentro 19 — Diseño del puente y núcleo del programa

### Objetivos del encuentro

- Interpretar la consigna y la rúbrica de 100 puntos del proyecto puente.
- Planificar el programa en función de los requisitos por núcleo (U1 y U2).
- Dejar corriendo el núcleo: carga de datos, menú y una operación completa.

### Agenda (120 minutos)

| Bloque | Minutos | Actividad |
|---|---|---|
| Apertura conjunta | 15 | Presentación del proyecto puente: consigna, requisitos por núcleo y rúbrica de 100 puntos; armado de grupos y de la carpeta `puente/` |
| Trabajo por grupos | 75 | Planificación breve en comentario de encabezado (qué función resuelve cada requisito); esqueleto con las cuatro funciones; implementación de `cargar_registros()` con `FileNotFoundError` y de `registrar_asistencia()`; primer commit |
| Puesta en común | 20 | Dos grupos muestran su avance corriendo; sistematización docente: cómo el mismo programa usa los tres constructos de U1 dentro de las funciones de U2 |
| Cierre y commit | 10 | Commit de avance con mensaje que refiera al logro del encuentro y `push` |

### Detalle del trabajo

1. Esqueleto fijo del curso: constantes (`RUTA_DATOS`), funciones con `def`, `main()` como punto de entrada y guard `if __name__ == "__main__":`.
2. Formato de datos acordado: una línea por estudiante con `nombre,apellido,grado`; carga con `read().splitlines()` y separación por campos con `split(",")` y `.strip()`.
3. Núcleo mínimo corriendo al cierre del encuentro: cargar, registrar una asistencia y salir guardando.
4. Quien completa antes: probar el caso sin archivo de datos y documentar en comentario qué hace el programa en la primera corrida.

## Encuentro 20 — Completar, probar y demostrar

### Objetivos del encuentro

- Completar el listado del día y el guardado con los dos caminos de prueba.
- Demostrar el programa corriendo y defender una decisión de diseño.
- Reconocer, en el propio proyecto, qué sabe cada integrante y qué refuerza antes de la Unidad 3.

### Agenda (120 minutos)

| Bloque | Minutos | Actividad |
|---|---|---|
| Apertura conjunta | 10 | Objetivo del día y criterios de la rúbrica que se verifican hoy |
| Trabajo por grupos | 75 | Completar `listado_del_dia()` (condición por estudiante con contador) y `guardar_registros()`; pruebas de los dos caminos (datos válidos y archivo ausente); ensayo de la demostración |
| Demostraciones | 25 | Demo de 3 minutos por grupo: programa corriendo, una decisión de diseño y un error anticipado |
| Cierre metacognición | 10 | Cada estudiante anota qué núcleo domina y cuál refuerza; queda como insumo de la Unidad 3 (Encuentro 21) |

### Detalle del trabajo

1. `listado_del_dia()`: recorrer los registros con `for`, decidir la condición de cada uno y contar presencias con acumulador; mostrar el total al final.
2. `guardar_registros()`: reescribir el archivo completo con `with open(..., "w", encoding="utf-8")`; verificar el resultado abriendo el `.txt` desde VS Code.
3. Prueba en dos caminos: caso normal (presencias y ausencias) y caso de error (renombrar el archivo y reabrir).
4. Quien completa antes: agregar la opción de listar solo los ausentes del día y explicar qué constructos de U1 usa esa opción.

## Criterios de logro

- El programa corre con `python asistencia.py` desde la terminal y no muestra traceback en ninguna situación prevista.
- La carga y el guardado usan `with open(..., encoding="utf-8")` y el archivo ausente se maneja con `except FileNotFoundError`.
- El programa define al menos cuatro funciones; cada una cumple una única responsabilidad clara.
- El menú repite con `while` y delega en funciones; las decisiones usan `if/elif/else`.
- Los datos se separan y limpian con `split(",")` y `.strip()`, y el ciclo agregar-salir-reabrir-listar conserva los datos.
- El trabajo queda en `puente/` con commits por avance y `push` al cierre de cada encuentro.
- Cada grupo demuestra el programa y explica una decisión de diseño con sus palabras.

## Evaluación del momento

El momento tiene evaluación propia con **rúbrica de 100 puntos**, en la carpeta de evaluaciones de los momentos del curso (ver README): única consigna para todo el curso, sin versiones por condición. La rúbrica pondera funcionamiento, integración de núcleos de U1 y U2, estilo según las convenciones del curso, entrega por Git y defensa breve. La Unidad 3 se abre en el Encuentro 21 sin adelantar contenido.
