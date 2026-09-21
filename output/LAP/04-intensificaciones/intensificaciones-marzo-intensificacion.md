# Momento de intensificación — Instancia de marzo (fuera de la estructura anual)

> Instancia de recuperación de marzo, antes del nuevo ciclo. **No imparte contenido nuevo**: su estándar es idéntico al de diciembre —no baja—; lo único que cambia es cuánto tiempo tuvo el estudiante para prepararse. Es solo para quienes no alcanzaron en diciembre. Su nombre es referencial y ordena alfabéticamente después de diciembre.

## Datos del momento

| Campo | Valor |
|---|---|
| Momento de uso | Marzo, antes del nuevo ciclo |
| Duración | 2 encuentros de 120 minutos |
| Destinatarios | Estudiantes que no alcanzaron los objetivos mínimos en la instancia de diciembre y contaron con más tiempo de preparación. Grupo único de intensificación: no hay pista de fortalecimiento |
| Requisitos | Haber asistido a la instancia de diciembre con resultado no apto aún. Material y devoluciones de diciembre disponibles. Repositorio del grupo disponible. Entorno en el laboratorio: VS Code, terminal, Python 3.11, Git y GitHub |
| Lugar de trabajo | Laboratorio de informática; uso de celular: no permitido |

## Acuerdo pedagógico

### Grupo de intensificación (recuperación pedagógica)

| Componente | Acuerdo |
|---|---|
| Contenidos mínimos irrenunciables | El mismo camino mínimo completo del curso que en diciembre: fundamentos de consola (U1); funciones y archivos de texto con `with open` y `FileNotFoundError` (U2); diccionarios y colección en JSON con `json.load` y `json.dump` (U3); entrega completa por Git con commits y `push` (U4) |
| Actividad y metodología | Repaso dirigido sobre el propio material de diciembre: autodiagnóstico inicial, corrección de lo que quedó incompleto y prueba en dos caminos de cada bloque; el estándar de la entrega es idéntico al de diciembre |
| Recursos | VS Code + terminal; repositorio propio del grupo y material de diciembre; hoja de errores comunes del curso |

## Encuentro 1 — Repaso dirigido del camino mínimo (U1 y U2)

### Objetivos del encuentro

- Detectar, sobre el propio trabajo de diciembre, qué mínimos siguen incompletos.
- Dejar corriendo y probado el tramo U1-U2 del camino mínimo.
- Explicitar el plan del Encuentro 2 (U3 y entrega por Git).

### Agenda (120 minutos)

| Bloque | Minutos | Actividad |
|---|---|---|
| Apertura y autodiagnóstico | 15 | Revisión del trabajo de diciembre contra la lista de mínimos; cada estudiante marca qué corrige hoy y qué queda para el Encuentro 2 |
| Bloque 1: fundamentos (U1) | 40 | Corrección y práctica del programa de consola: variables con conversión de `input()`, condicionales, bucles; prueba en dos caminos |
| Bloque 2: funciones y archivos (U2) | 40 | Corrección de funciones `def`/`return`; carga y guardado del `.txt` con `with open(..., encoding="utf-8")` y `FileNotFoundError` manejado |
| Cierre, commit y plan | 25 | Verificación del ciclo agregar-salir-reabrir-listar; commit con mensaje que refiera al avance, `push` y plan escrito para el Encuentro 2 |

### Detalle del trabajo

1. Partir del propio material de diciembre: no se reescribe desde cero, se corrige y completa.
2. Cada bloque cierra con la prueba en dos caminos: caso normal y caso de error (archivo ausente, número inválido).
3. Corregir estilo con la hoja de errores comunes: `except` específico, `encoding="utf-8"`, un comentario por acción.
4. Quien completa antes: repasar el tramo de JSON (U3) para adelantar la corrección del Encuentro 2.

## Encuentro 2 — Integración y entrega lista para la evaluación (U3 y U4)

### Objetivos del encuentro

- Dejar la colección en JSON funcionando con carga y guardado seguros (U3).
- Dejar la entrega por Git completa, con el mismo estándar de diciembre (U4).
- Ensayar la presentación del camino mínimo ante la evaluación de marzo.

### Agenda (120 minutos)

| Bloque | Minutos | Actividad |
|---|---|---|
| Apertura | 10 | Objetivo del día y repaso del patrón de carga segura de JSON |
| Bloque 1: dicts y JSON (U3) | 45 | Corrección de la agenda como lista de diccionarios; `json.load` y `json.dump(ensure_ascii=False, indent=2)`; validación con `in` antes de leer una clave |
| Bloque 2: entrega por Git (U4) | 45 | Revisión de carpetas y `.gitignore`; commits con mensajes claros por avance; `push` final y verificación del estado remoto |
| Cierre y condiciones de la evaluación | 20 | Prueba final completa en dos caminos; ensayo de la presentación: qué muestra el programa y qué explica cada núcleo |

### Detalle del trabajo

1. Colección en JSON verificada desde VS Code: tildes visibles y formato con `indent=2`.
2. Entrega completa y coherente: carpetas por trabajo, commits por avance y `push` verificado, igual que en diciembre.
3. Prueba integral: alta, listado, salida, reabrir y listar, con y sin archivo de datos.
4. Quien completa antes: anotar por cada núcleo (U1-U4) la línea del programa donde se cumple el mínimo.

## Criterios de logro

Los mismos del camino mínimo completo, con estándar idéntico al de diciembre:

- El programa corre con `python agenda.py` desde la terminal y no muestra traceback en situaciones previstas.
- Usa variables con conversión de `input()`, condicionales y bucles de forma correcta (U1).
- Define funciones con `def`/`return` y persiste en archivo con `with open(..., encoding="utf-8")` y `FileNotFoundError` manejado (U2).
- Organiza los datos como lista de diccionarios y los persiste en JSON con `json.load` y `json.dump(ensure_ascii=False, indent=2)` (U3).
- La entrega queda en el repositorio del grupo con carpetas, `.gitignore`, commits por avance y `push` (U4).
- El ciclo agregar-salir-reabrir-listar conserva los datos en todos los formatos trabajados.

## Evaluación del momento

La instancia de marzo tiene evaluación propia, en la carpeta de evaluaciones de los momentos del curso (ver README): evalúa el **camino mínimo completo del curso** (U1 a U4) con el mismo estándar de diciembre y criterio **Apto / No apto aún por objetivo mínimo**. Apto: acredita los objetivos mínimos del curso. No apto aún al cierre de marzo: los objetivos mínimos siguen pendientes al finalizar las instancias de recuperación.
