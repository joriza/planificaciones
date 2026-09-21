# Evaluación de la Unidad 4 — Proyecto integrador y Git profesional

> Documento de la instancia de evaluación. La consigna de cada versión está en su documento propio (`evaluacion-u4-version-a.md` y `evaluacion-u4-version-b.md`); las soluciones y los criterios de corrección, en los anexos docentes.

## Metadatos

| Campo | Valor |
|---|---|
| Materia | Programación en Python |
| Instancia | Evaluación de la Unidad 4 — Encuentro dedicado 32 |
| Duración | 120 minutos |
| Modalidad | Entrega final del proyecto integrador por GitHub, con defensa individual |
| Entrega | Estado final del repositorio del grupo: carpeta `trabajo-final/` con el programa y su JSON, README actualizado, `main` al día con push |
| Destinatarios | Estudiantes de la materia en condición regular |
| Requisitos previos | Desarrollo del integrador durante los Encuentros 27 a 31 con flujo issue → rama → PR; `main` protegida; repositorio del grupo con push funcionando |
| Lugar de trabajo | Aula de informática: VS Code, terminal, Python 3.11, Git y GitHub |
| Celular | No permitido |
| Versiones | A (gestión de notas) y B (inventario de productos), equivalentes; asignación por grupo al inicio de la unidad (Encuentro 27) |
| Aprobación | 60 puntos o más de 100 en la rúbrica, y defensa individual con resultado apto |

## Acuerdo de evaluación

La evaluación de la Unidad 4 consiste en la entrega final del trabajo integrador desarrollado por el grupo durante la unidad y en la defensa individual de cada integrante, ambas en el encuentro dedicado. El proyecto integrador aplica la persistencia en JSON de la Unidad 3 dentro de un flujo profesional de Git: issues que cuentan qué se propuso, ramas por feature y pull requests revisados que cuentan cómo se construyó, README con instrucciones probadas y `main` protegida. El encuentro siguiente abre con la devolución.

Las versiones A y B son equivalentes en dificultad: mismos objetivos y mismos requisitos, con distinto dominio de datos; ninguna tiene reglas que la otra no tenga. El ejemplo guiado trabajado en los encuentros de la unidad (gestor de préstamos de equipos) sirvió de modelo de estructura y requisitos; el trabajo final se desarrolla en el dominio asignado a cada grupo. La asignación la realiza el docente al inicio de la unidad, en el Encuentro 27, al definir los issues del proyecto, alternando versiones entre grupos vecinos.

## Objetivos evaluados

- Completar un programa integrador de consola con menú de cinco opciones, registros de cuatro claves (incluida fecha ISO y un campo booleano) y persistencia JSON con carga segura.
- Sostener el flujo profesional de trabajo: issues definidos y cerrados, ramas `feature/*` con pull requests revisados y mergeados, `main` protegida e historial legible.
- Documentar el proyecto en el README con instrucciones de ejecución probadas.
- Entregar el trabajo como estado del repositorio: `main` al día, sin issues abiertos, sin pendientes locales.
- Sustentar la defensa individual explicando decisiones propias sobre el trabajo del grupo.

## Consigna general

Entregar el proyecto integrador de la versión asignada al grupo en la carpeta `trabajo-final/` del repositorio, con su programa `.py`, su archivo de datos JSON generado por el propio programa y la sección del proyecto en el README. La consigna completa con el dominio de datos y los requisitos del flujo Git está en el documento de cada versión.

## Requisitos técnicos (canon de la materia)

- Esqueleto canónico: `import` solo de lo usado (`json`, `sys`), constantes en `MAYUSCULAS_CON_GUIONES_BAJOS`, funciones con `def`, `def main():` y guard `if __name__ == "__main__":` al final.
- Toda lectura y escritura con `with open(ruta, modo, encoding="utf-8")`; `json.dump(..., ensure_ascii=False, indent=2)` en toda escritura JSON.
- Carga segura: `except FileNotFoundError` → colección vacía; `except json.JSONDecodeError` → aviso y `sys.exit(1)`.
- Campos obligatorios validados: ningún campo vacío en el alta, con reingreso; datos numéricos bajo `try/except ValueError`.
- Guardado de la colección en cada alta y al salir.
- Excepciones específicas siempre; sin `except:` desnudo; sin `traceback` en situaciones previstas; un comentario por acción; identificadores y mensajes en español, sin tildes ni eñes dentro del código.
- Sin clases, sin librerías externas, sin módulos propios.
- Flujo Git profesional: `.gitignore` en la raíz, mínimo cinco issues del proyecto todos cerrados, mínimo cinco ramas `feature/*` con sus pull requests revisados y mergeados, `main` protegida e historial de `main` solo con merges de PR.

## Rúbrica (100 puntos)

| Criterio | Puntos |
|---|---|
| Funcionalidad del integrador: menú de cinco opciones completo, registro de cuatro claves con fecha ISO y campo booleano, marcación de estado sobre un registro existente | 25 |
| Persistencia JSON y manejo de errores: carga segura de los tres caminos, salida con código 1 ante daño, campos vacíos rechazados, guardado por alta y al salir | 20 |
| Git profesional: issues cerrados, ramas `feature/*`, PR revisados y mergeados, `main` protegida, README con instrucciones probadas | 25 |
| Calidad del código: canon completo de estructura, estilo y comentarios | 15 |
| Entrega final: estado del repositorio publicado (`main` al día, sin issues abiertos, sin pendientes locales, sin archivos extra) | 15 |
| **Total** | **100** |

Los puntos de la rúbrica califican el trabajo entregado por el grupo. La defensa individual no suma puntos: es condición de aprobación para cada integrante. Quien no la sostenga no aprueba la unidad, con las capas de recuperación previstas en los criterios de aprobación de la asignatura.

## Defensa individual

Cada integrante sostiene, sin leer y en no más de cinco minutos, el guion de cuatro puntos del curso:

1. Qué problema resuelve el proyecto y qué opción del menú lo resuelve, mostrando el programa corriendo.
2. Una función elegida: qué recibe, qué hace y qué devuelve.
3. Un error previsto y cómo lo maneja el programa, mostrándolo en vivo.
4. Un momento del historial: qué muestra un pull request del proyecto y qué dijo la revisión.

El docente registra apto / no apto por integrante.

## Desarrollo del encuentro dedicado (120 minutos)

| Momento | Minutos |
|---|---|
| Verificación final contra la lista de requisitos de la versión | 20 |
| Entrega final: estado del repositorio (`main` al día, push, sin issues abiertos) | 20 |
| Defensas individuales (5 minutos por integrante, guion de cuatro puntos) | 70 |
| Cierre y registro de devoluciones | 10 |
| **Total** | **120** |

## Versiones

| Versión | Dominio de datos | Archivos esperados |
|---|---|---|
| A | Gestión de notas (gestor de entregas de trabajos prácticos) | `trabajo-final/entregas.py` + `entregas.json` |
| B | Inventario de productos (gestor de pedidos de insumos) | `trabajo-final/pedidos.py` + `pedidos.json` |

Ambas versiones exigen exactamente el mismo programa y el mismo flujo Git: registro de cuatro claves (`nombre, categoria, fecha ISO, estado booleano`), menú de cinco opciones con marcación de estado sobre un registro existente, persistencia JSON con carga segura, README del proyecto y mínimo cinco issues con sus ramas y PR revisados. Solo cambia el dominio de los datos.

## Devolución

El Encuentro 33 abre con la devolución del trabajo calificado y del registro de defensas.
