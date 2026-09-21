# Momento de intensificación — Instancia de diciembre (fuera de la estructura anual)

> Instancia de recuperación de diciembre, finalizada la cursada. **No imparte contenido nuevo**: evalúa y acompaña el camino mínimo completo del curso. Es solo para estudiantes que no alcanzaron los objetivos mínimos en el ciclo. Su nombre es referencial y ordena alfabéticamente después de los momentos de la estructura anual.

## Datos del momento

| Campo | Valor |
|---|---|
| Momento de uso | Diciembre, finalizada la cursada |
| Duración | 2 encuentros de 120 minutos |
| Destinatarios | Estudiantes que no alcanzaron los objetivos mínimos del curso durante el ciclo. Grupo único de intensificación: no hay pista de fortalecimiento |
| Requisitos | Cursada finalizada con objetivos mínimos pendientes (según evaluaciones de unidad y momentos del ciclo). Repositorio del grupo disponible. Entorno en el laboratorio: VS Code, terminal, Python 3.11, Git y GitHub |
| Lugar de trabajo | Laboratorio de informática; uso de celular: no permitido |

## Acuerdo pedagógico

### Grupo de intensificación (recuperación pedagógica)

| Componente | Acuerdo |
|---|---|
| Contenidos mínimos irrenunciables | Camino mínimo completo del curso: programa de consola con variables, tipos, `input`/`print`, condicionales y bucles (U1); funciones con `def` y `return` y archivos de texto con `with open` y `FileNotFoundError` (U2); diccionarios y colección en JSON con `json.load` y `json.dump` (U3); entrega por Git con commits y `push` (U4) |
| Actividad y metodología | Reconstrucción guiada de la agenda mínima y su evolución a JSON, con prueba en dos caminos (normal y de error) en cada paso; el segundo encuentro cierra con la entrega completa por Git, lista para la evaluación |
| Recursos | VS Code + terminal; repositorio propio del grupo; hoja de errores comunes del curso |

## Encuentro 1 — Camino mínimo: fundamentos, funciones y archivos de texto

### Objetivos del encuentro

- Reconstruir un programa de consola con los constructos básicos de U1.
- Estructurar el programa con funciones y persistir en `.txt` como en U2.
- Explicitar qué núcleos quedan para el Encuentro 2 (U3 y entrega por Git).

### Agenda (120 minutos)

| Bloque | Minutos | Actividad |
|---|---|---|
| Apertura y plan | 15 | Lectura del estado propio: qué mínimos faltan según las devoluciones del ciclo; plan de los dos encuentros |
| Bloque 1: fundamentos (U1) | 45 | Programa mínimo de consola: variables y tipos, `input` con `int()`, decisión con `if/elif/else`, repetición con `while` y `for`; prueba en dos caminos |
| Bloque 2: funciones y archivos (U2) | 45 | Reorganizar el programa con funciones `def`/`return`; carga segura del `.txt` con `except FileNotFoundError`; guardado con `with open(..., "w", encoding="utf-8")` |
| Cierre y commit | 15 | Verificar los dos caminos; commit con mensaje que refiera al avance y `push` |

### Detalle del trabajo

1. Esqueleto fijo del curso: constantes, funciones con `def`, `main()` y guard `if __name__ == "__main__":`.
2. Agenda mínima en texto plano: alta y listado con menú en `while`; persistencia al salir; ciclo agregar-salir-reabrir-listar verificado.
3. Conversión de `input()` numérico con `int()` y manejo de `ValueError` con mensaje claro.
4. Quien completa antes: agregar una validación con reintento y anotar qué prueba cubre cada camino.

## Encuentro 2 — Camino mínimo: datos en JSON y entrega completa

### Objetivos del encuentro

- Organizar los datos con diccionarios y persistir la colección completa en JSON (U3).
- Dejar la entrega por Git completa y coherente con el repositorio del curso (U4).
- Llegar a la evaluación de diciembre con el camino mínimo ejecutado de punta a punta.

### Agenda (120 minutos)

| Bloque | Minutos | Actividad |
|---|---|---|
| Apertura | 10 | Objetivo del día y repaso del patrón de carga segura |
| Bloque 1: dicts y JSON (U3) | 50 | Migrar la agenda a una lista de diccionarios; carga y guardado con `json.load` y `json.dump(ensure_ascii=False, indent=2)`; validación con `in` antes de leer una clave |
| Bloque 2: entrega por Git (U4) | 40 | Verificar carpetas y `.gitignore`; commits con mensajes claros por avance; `push` final; revisión del estado del repositorio |
| Cierre y plan de la evaluación | 20 | Prueba final del programa completo en dos caminos; explicitar qué se presenta en la evaluación de diciembre |

### Detalle del trabajo

1. Registro como diccionario: construir campo por campo y agregar con `append`; listar recorriendo con `for`.
2. Colección en JSON: reemplazar el texto plano por `agenda.json`; verificar el archivo desde VS Code (tildes visibles, formato con `indent=2`).
3. Ciclo Git completo de la entrega: rama, commits por avance, `push` y verificación del estado remoto.
4. Quien completa antes: probar el caso de JSON dañado y describir qué manejo le agregaría.

## Criterios de logro

- El programa corre con `python agenda.py` desde la terminal y no muestra traceback en situaciones previstas.
- Usa variables con conversión de `input()`, condicionales y bucles de forma correcta (U1).
- Define funciones con `def`/`return` y persiste en archivo con `with open(..., encoding="utf-8")` y `FileNotFoundError` manejado (U2).
- Organiza los datos como lista de diccionarios y los persiste en JSON con `json.load` y `json.dump(ensure_ascii=False, indent=2)` (U3).
- La entrega queda en el repositorio del grupo con carpetas, `.gitignore`, commits por avance y `push` (U4).
- El ciclo agregar-salir-reabrir-listar conserva los datos en todos los formatos trabajados.

## Evaluación del momento

La instancia de diciembre tiene evaluación propia, en la carpeta de evaluaciones de los momentos del curso (ver README): evalúa el **camino mínimo completo del curso** (U1 a U4) con criterio **Apto / No apto aún por objetivo mínimo**. Apto: acredita los objetivos mínimos del curso. No apto aún: los objetivos siguen pendientes y pasa a la instancia de marzo, con el mismo estándar y más tiempo de preparación.
