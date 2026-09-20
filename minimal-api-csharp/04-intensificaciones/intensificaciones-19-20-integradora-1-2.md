# Momento de intensificación y fortalecimiento (encuentros 19 y 20) — Instancia integradora de las Unidades 1 y 2 (proyecto puente)

> Momento de intensificación y fortalecimiento de la estructura anual de 36 encuentros: después del momento de recuperación y profundización 17-18 y antes de la Unidad 3. Documento de referencia del docente: define el acuerdo pedagógico del momento, el desarrollo de sus dos encuentros y los criterios de logro. La evaluación del momento —el proyecto puente con su rúbrica de 100 puntos, en versiones A y B— está en `evaluaciones/evaluacion-intensificaciones-19-20.md` (con sus versiones y el anexo docente en la misma carpeta).

## 1. Metadatos del momento

| Campo | Detalle |
| --- | --- |
| Momento | Instancia integradora de las Unidades 1 y 2 (proyecto puente) |
| Encuentros | 19 y 20 de 36 |
| Duración | 2 encuentros de 240 minutos teóricos cada uno (4 horas reloj) |
| Destinatarios | Todo el curso: una sola pista, sin diferenciación por condición |
| Carácter/Objetivo | Procedimental |
| Requisitos previos | Unidades 1 y 2 aprobadas en proceso: tp-u1 y tp-u2 entregados con su ciclo de entrega por GitHub, y evaluaciones de unidad rendidas. El momento no imparte contenido nuevo |
| Lugar de trabajo | Aula-taller, PC por grupo, VS Code, terminal, `hospital.db`, navegador y GitHub |
| Uso de celular | No permitido |
| Evaluación | El proyecto puente con rúbrica de 100 puntos, en versiones A y B equivalentes asignadas por grupo |

## 2. Acuerdo pedagógico (una sola pista)

A diferencia de los momentos diferenciados (17-18 y 34-35), donde cada encuentro desarrolla las dos pistas en paralelo con plenarias conjuntas, en este momento hay **una única pista para todo el curso**: todos los grupos trabajan sobre la misma consigna de proyecto puente, en dos versiones equivalentes (A y B) que se asignan por grupo. El proyecto puente **es progresión, no redundancia**: las Unidades 1 y 2 ya están aprobadas en proceso; lo nuevo del momento no es un contenido sino una integración — por primera vez, la API en memoria y el acceso a datos con Dapper conviven en un mismo proyecto y responden a un solo diseño.

| Componente | Acuerdo |
| --- | --- |
| Contenidos integrados | Núcleos de la Unidad 1: proyecto Minimal API en `Program.cs`, rutas con parámetros, CRUD completo en memoria con `Results`, validación manual con 400 y 404. Núcleos de la Unidad 2: conexión a `hospital.db` con Dapper, consultas parametrizadas con `WHERE`, `LIKE` y `ORDER BY`, JOIN de dos tablas con record compuesto, escritura `INSERT` parametrizada con 201 y 400. Saber transversal: entrega por GitHub con carpeta nueva, commits de avance y push. Sin contenidos nuevos de ninguna unidad posterior |
| Actividad y metodología acordada | Proyecto puente grupal con consigna única en dos versiones equivalentes (A: `admissions` + `doctors`; B: `patients` + `province_names`), asignadas por grupo. Dos encuentros de desarrollo con la agenda fija del momento de intensificación y fortalecimiento (apertura 20 · bloque 1 90 · bloque 2 90 · cierre 40): E19 lanzamiento y desarrollo; E20 finalización, entrega por GitHub y evaluación con la rúbrica. Rotación de integrantes por bloque según presentes y equipos disponibles; ningún equipo sin usar. Batería de pruebas anotada como criterio de terminación y puesta en común final |
| Recursos acordados (condensado al 25%) | Aula-taller con PC por grupo; VS Code + terminal + SDK de .NET 6; `hospital.db`; repositorio de GitHub del grupo; consigna de la versión asignada y rúbrica de 100 puntos; navegador y `curl.exe` para las pruebas |

## 3. Desarrollo del Encuentro 19 — Lanzamiento y desarrollo del proyecto puente

| Momento | Tiempo | Qué ocurre |
| --- | --- | --- |
| Apertura | 20 min | Lanzamiento: qué es el proyecto puente (una API que integra las dos unidades), lectura guiada de la consigna de la versión asignada a cada grupo y armado de la ficha de diseño: rutas previstas, records, mensajes de error y batería de pruebas. El docente aprueba cada ficha antes de habilitar el teclado |
| Bloque 1 | 90 min | Parte 1 del proyecto — API en memoria (Unidad 1): crear la carpeta `puente-u1-u2/` en el repositorio del grupo y desarrollar el CRUD completo del recurso propio de la versión, con validación, códigos correctos y mensajes propios. Primer commit de avance al cierre del bloque |
| Bloque 2 | 90 min | Parte 2 del proyecto — lecturas sobre `hospital.db` (Unidad 2): copiar la base junto al `.csproj`, agregar los dos paquetes, y resolver los dos endpoints de consulta: el JOIN de dos tablas y la búsqueda con `LIKE` parametrizada. Commit de avance y push |
| Cierre | 40 min | Plenaria: cada grupo muestra qué funciona y qué falta, marca su avance contra la rúbrica de 100 puntos y deja por escrito el plan del Encuentro 20 |

## 4. Desarrollo del Encuentro 20 — Finalización, entrega por GitHub y evaluación

| Momento | Tiempo | Qué ocurre |
| --- | --- | --- |
| Apertura | 20 min | Retomar el repositorio: estado del remoto, commits de la clase anterior y checklist de lo pendiente según la rúbrica |
| Bloque 1 | 90 min | Parte 2 del proyecto — escritura validada (Unidad 2): endpoint de alta con validación previa (400 con mensaje), `INSERT` parametrizado e id generado, y 201 con la URL del recurso nuevo. Batería de pruebas completa ejecutada y anotada (navegador para los GET, `curl.exe` para el resto) |
| Bloque 2 | 90 min | Entrega: la carpeta `puente-u1-u2/` queda completa en el repositorio del grupo (proyecto, `hospital.db`, paquetes), con los commits de avance y el push final verificados en GitHub. Preparación de la puesta en común: quién explica qué |
| Cierre | 40 min | Puesta en común y evaluación: demo breve de cada grupo, aplicación de la rúbrica de 100 puntos con registro por grupo, devolución oral inmediata y síntesis del momento |

## 5. Actividades de extensión (grupos que completan los requisitos base)

Cada ítem se commitea por separado con la rutina del curso:

1. Agregar un endpoint de búsqueda extra con `LIKE` sobre otra columna del dominio de la versión (A: `diagnosis` en `admissions`; B: `city` en `patients`).
2. Agregar `GET <recurso>/count` sobre el recurso en memoria, con la cantidad de elementos como JSON.
3. Revisión cruzada: intercambiar repos con el grupo vecino y revisar su entrega contra la rúbrica; cada hallazgo se comunica como sugerencia, sin corregir código ajeno.

## 6. Criterios de logro — rúbrica de 100 puntos

La misma rúbrica se aplica a las versiones A y B (mismo proyecto y requisitos, distinto dominio). El desglose de cada criterio y su aplicación con ejemplos de desempeño están en el anexo docente de la evaluación.

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

## 7. Registro y devolución

- El puntaje de la rúbrica se registra por grupo en la planilla de resultados (grupo, versión asignada, puntos por criterio, total sobre 100): registro docente formal.
- La entrega que se evalúa es la que está publicada en GitHub al cierre del bloque de entrega del Encuentro 20; no se re-evalúan versiones posteriores.
- La devolución comentada se hace al inicio del Encuentro 21, junto con la devolución de la evaluación de la Unidad 2. El resultado del proyecto puente informa el estado aún provisorio del curso según los criterios de `06-aprobacion/criterios-aprobacion.md`.
