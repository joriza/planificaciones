# Encuentro 31 — Cierre U4: entrega y defensa

## Datos del encuentro

| Campo | Valor |
|---|---|
| Unidad | 4 — Proyecto integrador y Git profesional |
| Encuentro | 31 de 36 |
| Eje temático | 4 — Proyecto integrador y Git profesional |
| Carácter/Objetivo | Actitudinal |
| Duración | 120 minutos (2 horas reloj) |
| Requisitos | Integrador funcional con persistencia (Encuentros 29 y 30); flujo issue → rama → PR; `main` protegida |
| Concepto nuevo | Entrega final del trabajo y ensayo de la defensa individual |
| TP obligatorio | Trabajo final: integrador con Git |

## Objetivos de aprendizaje

- Verificar el estado final del trabajo contra la lista de requisitos y cerrar los issues pendientes.
- Completar la sección del proyecto en el README con instrucciones de ejecución probadas.
- Realizar la entrega final del trabajo por GitHub con `main` al día y etiquetada por commits revisados.
- Ensayar la defensa individual con el guion del curso, que se sostiene formalmente en el Encuentro 32.

## Reparto de tiempos (120 minutos)

| Bloque | Minutos |
|---|---|
| Apertura y motivación | 10 min |
| Desarrollo teórico-práctico | 70 min |
| Consolidación y cierre | 25 min |
| Actividad complementaria | 15 min |
| **Total** | **120 min** |

## Apertura y motivación (10 min)

La unidad cierra con el destino de todo lo construido: una entrega formal y una defensa individual. El repositorio es la evidencia: los issues cuentan qué se propuso, las ramas y los PR cómo se construyó, y `main` el resultado final. La defensa no es un examen de memoria: es explicar decisiones propias sobre un trabajo que cada integrante vio crecer por etapas.

## Desarrollo teórico-práctico (70 min)

### Parte 1: verificación final contra los requisitos (20 min)

Lista de verificación del trabajo final, leída en voz alta y marcada por grupo:

- [ ] `trabajo-final/prestamos.py` corre con `python prestamos.py` desde su carpeta.
- [ ] Menú con las cinco opciones y salida limpia.
- [ ] Registro con claves `equipo`, `alumno`, `fecha` (ISO) y `devuelto`.
- [ ] Persistencia en `prestamos.json`: re-corrida conserva los datos.
- [ ] Archivo ausente → arranca vacío; JSON dañado → mensaje y salida con código `1`.
- [ ] Campos vacíos rechazados con reintentos.
- [ ] Sin librerías externas; esqueleto canónico completo.
- [ ] Issues del proyecto todos cerrados; historial de `main` solo con merges de PR.

Todo faltante se corrige hoy: los issues que queden abiertos se resuelven en una rama `feature/ajustes-finales` con su PR revisado.

### Parte 2: README del proyecto (20 min)

El README del repositorio gana su sección final, por PR (issue 6, rama `feature/readme-final`):

```markdown
## Trabajo final — Gestor de préstamos de equipos

Programa de consola para registrar préstamos de equipos del aula-taller.

### Cómo ejecutar

    python trabajo-final/prestamos.py

Los datos se guardan solos en `trabajo-final/prestamos.json`.

### Qué sabe hacer

- Registrar préstamos con fecha ISO y validar que ningún campo quede vacío.
- Listar y buscar préstamos por alumno.
- Registrar devoluciones y conservar todo entre corridas (JSON).
- Avisar con claridad si el archivo de datos está dañado (no continúa: evita perder datos).

### Cómo está construido

Un solo archivo `prestamos.py` con constantes, funciones, `main()` y guard.
Persistencia con la biblioteca estándar (`json`), sin librerías externas.
```

Regla de la sección: cada instrucción publicada se probó antes del push; el README miente si el comando no corre desde la raíz del repositorio.

### Parte 3: entrega final (15 min)

Secuencia de cierre y verificación cruzada entre grupos:

```bash
git switch main
git pull
git log --oneline --graph
git status
```

Estado esperado: `nothing to commit, working tree clean`, historial legible con merges de PR y ningún issue abierto. La entrega queda constituida por ese estado del repositorio; no hay archivos por correo ni pendientes locales.

### Parte 4: ensayo de la defensa (15 min)

Guion mínimo del curso; cada integrante explica, sin leer, cuatro puntos:

1. Qué problema resuelve el proyecto y qué opción del menú lo resuelve.
2. Una función elegida: qué recibe, qué hace, qué devuelve.
3. Un error previsto y cómo lo maneja el programa (ejemplo: JSON dañado).
4. Un momento del historial: qué muestra un PR del proyecto y qué dijo la revisión.

El grupo ensaya en parejas cruzadas: mientras uno explica, el otro marca con el guion qué faltó. El docente rota por los grupos escuchando un punto por integrante.

## Consolidación y cierre (25 min)

Ronda final por grupo frente al curso (2 minutos por grupo): muestra del programa corriendo y del historial de `main`. Retroalimentación del docente anotada en un issue de devolución (`devolucion-defensa`) para trabajarla antes del Encuentro 32.

### Qué te llevás

- La entrega no es un archivo: es el estado del repositorio, limpio, documentado y reconstruible desde el historial.
- Un README con instrucciones probadas es parte del trabajo, no un adorno.
- La defensa se prepara explicando: problema, función, error manejado e historia del PR.
- El flujo issue → rama → PR → revisión ya no es un ejercicio: es la forma en la que el grupo trabaja.

## Actividad complementaria (15 min)

Preparación individual de la defensa formal del Encuentro 32: cada integrante elige su función y su PR, repasa el guion con sus palabras y anota por escrito las dos respuestas que le costaron más en el ensayo. El issue de devolución del grupo sirve de guía para lo que hay que reforzar.

## Lo que viene

En el Encuentro 32, encuentro dedicado de evaluación, cada integrante sostiene su defensa individual del trabajo final sobre el repositorio entregado, y se realiza la instancia práctica de la evaluación de la Unidad 4.
