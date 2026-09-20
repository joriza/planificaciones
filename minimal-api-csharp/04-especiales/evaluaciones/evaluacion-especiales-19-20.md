# Evaluación del momento especial 19-20 — Proyecto puente de las Unidades 1 y 2

> Evaluación de los Encuentros 19 y 20 — Instancia integradora de las Unidades 1 y 2 · Curso: Minimal API con C# .NET 6. Este documento se entrega junto con la versión asignada al grupo (A o B). Leerlo completo antes de comenzar.

## 1. Identificación

| Campo | Detalle |
| --- | --- |
| Instancia | Encuentros 19 y 20 — Instancia integradora de las Unidades 1 y 2 (proyecto puente) |
| Destinatarios | Todo el curso: una sola pista, sin diferenciación por condición |
| Modalidad | Proyecto puente grupal, desarrollado durante los dos encuentros, con entrega por GitHub y evaluación con rúbrica |
| Duración | 2 encuentros de 240 minutos teóricos cada uno |
| Puntaje total | 100 puntos (rúbrica única para las versiones A y B) |
| Uso de celular | No permitido |
| Material consultable | El material del curso: apuntes y clases del repositorio, el propio repositorio del grupo y la documentación provista con la consigna |
| Registro | Docente formal: planilla de resultados por grupo (versión, puntos por criterio, total) |

## 2. Qué se evalúa

La evaluación **es** el proyecto puente: una única Minimal API que integra los núcleos de las dos unidades aprobadas en proceso.

1. Construir un CRUD completo en memoria con rutas, parámetros, verbos, validación y códigos de respuesta adecuados (Unidad 1).
2. Consultar `hospital.db` con Dapper mediante un JOIN de dos tablas y una búsqueda parcial con `LIKE`, ambas parametrizadas (Unidad 2).
3. Implementar una escritura parametrizada sobre la base, precedida de la validación de los campos obligatorios (Unidad 2).
4. Sostener las convenciones del curso: `Results`, ids `long`, fechas `string` ISO, rutas en inglés y plural, records al final del archivo.
5. Gestionar la entrega en el repositorio del grupo con carpeta nueva, commits de avance y push, y comunicar las decisiones del proyecto en la puesta en común.

No se evalúa ningún contenido posterior a la Unidad 2: el momento no imparte contenido nuevo, integra lo ya aprendido.

## 3. Estructura: la evaluación es el proyecto puente

El proyecto se desarrolla en la carpeta `puente-u1-u2/` del repositorio del grupo, en un único `Program.cs` con dos partes que conviven. Cada parte se corresponde con un criterio de la rúbrica:

| Parte | Versión A (`admissions` + `doctors`) | Versión B (`patients` + `province_names`) | Criterio | Puntos |
| --- | --- | --- | --- | --- |
| Parte 1 — API en memoria | CRUD de `appointments` (turnos) | CRUD de `checkups` (controles) | 1 | 30 |
| Parte 2a — JOIN de dos tablas | `GET /admissions/by-doctor/{id:long}` | `GET /provinces/{provinceId}/patients` | 2 | 15 |
| Parte 2b — Búsqueda con LIKE | `GET /doctors?text=...` (especialidad) | `GET /patients?text=...` (apellido) | 3 | 10 |
| Parte 2c — Escritura validada | `POST /doctors` | `POST /patients` | 4 | 15 |
| Transversal | Convenciones del curso, entrega por GitHub, batería de pruebas y puesta en común (idénticas en ambas versiones) | | 5, 6, 7 y 8 | 30 |
| **Total** | | | | **100** |

Los requisitos completos de cada parte están en la consigna de cada versión. La rúbrica completa está en la sección 4.

## 4. Rúbrica de 100 puntos

| # | Criterio | Qué se observa | Puntos |
| --- | --- | --- | --- |
| 1 | API en memoria (U1) | CRUD completo del recurso propio: GET todos (200), GET uno (200 o 404 con mensaje), POST (201 con `Location` o 400 con mensaje), PUT (200, 400 o 404) y DELETE (204 o 404), con datos propios del grupo | 30 |
| 2 | Lectura con JOIN (U2) | JOIN de dos tablas del dominio con `ON` por la clave compartida, record compuesto con alias de columnas, y 200 con la lista o 404 con mensaje si no hay resultados | 15 |
| 3 | Búsqueda con LIKE (U2) | Búsqueda parcial parametrizada (`LIKE @patron` con comodines, nunca concatenada) por query string, con orden definido | 10 |
| 4 | Escritura validada (U2) | `INSERT` parametrizado precedido de la validación de los campos obligatorios (400 con mensaje), id generado con `ExecuteScalar<long>` y 201 con la URL del recurso nuevo | 15 |
| 5 | Convenciones del curso | `Results` explícito en todas las respuestas; ids `long` y fechas `string` ISO; rutas en inglés y plural con `{id:long}`; records al final del archivo; comentarios abundantes en español y sin tildes | 10 |
| 6 | Entrega por GitHub | Carpeta `puente-u1-u2/` en la raíz del repositorio del grupo con el proyecto, `hospital.db` y los dos paquetes; al menos 3 commits de avance con mensaje `puente-u1-u2: ...`; push visible con `.gitignore` correcto en la raíz | 12 |
| 7 | Batería de pruebas | Batería ejecutada y anotada: qué URL o comando se probó, qué código se esperaba y qué código respondió, para cada endpoint | 4 |
| 8 | Puesta en común | Cada integrante explica una parte del proyecto; el grupo comunica decisiones técnicas y pendientes | 4 |
| **Total** | | | **100** |

La aplicación de la rúbrica con el desglose por criterio y ejemplos de desempeño por nivel está en el anexo docente.

## 5. Versiones A y B equivalentes

- **Mismo proyecto y mismos requisitos:** ambas versiones piden exactamente lo mismo — un CRUD en memoria, un JOIN de dos tablas, una búsqueda con `LIKE` y una escritura validada, con la misma entrega por GitHub y la misma rúbrica ítem por ítem.
- **Distinto dominio:** la versión A trabaja el dominio de turnos e ingresos (tablas `admissions` y `doctors` de `hospital.db`); la versión B, el dominio de pacientes por provincia (tablas `patients` y `province_names`).
- **Ninguna regla que una tenga y la otra no:** la regla de validación es idéntica en ambas (los campos obligatorios de la tabla no van vacíos, con 400 y mensaje); los datos obligatorios que difieren en cantidad (tres columnas en `doctors`, cinco en `patients`) son los que fija cada tabla. La clave foránea de `patients` hacia `province_names` es una propiedad de la base, advertida en ambas versiones como regla del dato, no como regla de la API.
- El propósito de la equivalencia es que la versión asignada no otorgue ventaja ni habilite la copia entre grupos.

## 6. Mecánica de asignación de versiones

- La versión (A o B) se asigna **por grupo**, no por integrante: todo el grupo trabaja sobre la misma versión durante los dos encuentros.
- La asignación se comunica en la apertura del Encuentro 19, junto con la consigna, y se registra en la planilla de resultados (grupo → versión).
- Grupos vecinos reciben versiones distintas siempre que la cantidad de grupos lo permita.
- La rotación de integrantes por bloque (según presentes y equipos disponibles) no cambia la versión del grupo.

## 7. Entrega, evaluación y devolución

- **Entrega:** la carpeta `puente-u1-u2/` queda completa en el repositorio del grupo con commits de avance y push, verificados en GitHub al cierre del bloque de entrega del Encuentro 20. Esa entrega publicada es la que se evalúa.
- **Evaluación:** la rúbrica de 100 puntos se aplica en la plenaria de cierre del Encuentro 20, con demo breve de cada grupo y registro por criterio.
- **Devolución:** al inicio del Encuentro 21, junto con la devolución de la evaluación de la Unidad 2. El resultado informa el estado aún provisorio del curso según `06-aprobacion/criterios-aprobacion.md`.
