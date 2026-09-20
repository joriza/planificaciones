# Minimal API con C# .NET 6 — Índice del curso

> Documento índice del corpus de la asignatura **Minimal API con C# .NET 6**, redactado en registro docente formal. Presenta el curso, organiza el corpus completo mediante vínculos a cada documento, documenta el orden de creación de los materiales, la diferencia entre unidades didácticas y ejes temáticos, y la fundamentación pedagógica del enfoque. Deriva de la planificación anual, documento madre del curso.

---

## 1. Presentación del curso

| Campo | Detalle |
| --- | --- |
| Asignatura (denominación formal) | Minimal API con C# .NET 6 |
| Nivel y modalidad | Nivel secundario, escuela técnica |
| Qué es | Un primer acercamiento al desarrollo de APIs web desde cero: el alumno aprende a construir una Minimal API de .NET 6 comprendiendo cada pieza, sin conceptos intermedios (sin patrón repositorio ni inyección de dependencias) y con la totalidad del código en un único archivo `Program.cs` |
| A quién va dirigida | Alumnos del nivel secundario de una escuela técnica, sin conocimientos previos de C# ni de desarrollo web |
| Stack tecnológico | C# con .NET 6 (Minimal API), Dapper para el acceso a datos, SQLite como motor de base de datos |
| Entorno de trabajo | Visual Studio Code y terminal, con el SDK de .NET 6 |
| Base de datos | `hospital.db` (SQLite), incorporada desde la Unidad 2; la Unidad 1 trabaja en memoria |
| Entregas | Un único repositorio de GitHub por grupo, con una carpeta por trabajo (`tp-u1`, `tp-u2`, `tp-u3`, `trabajo-final`); cada entrega se acompaña de una defensa individual en el encuentro dedicado |
| Carga horaria | 36 encuentros de 4 horas reloj (240 minutos teóricos por encuentro): 144 horas anuales, 18 encuentros por cuatrimestre |
| Uso del celular | No permitido en ningún encuentro |

El ciclo lectivo sigue una estructura fija de 36 encuentros organizados en 16 tramos: encuadre y diagnóstico (encuentro 1), recuperación y profundización de saberes previos (encuentros 2-3), cuatro unidades didácticas con su encuentro dedicado de evaluación (encuentros 4-9, 10-15, 21-26 y 27-32), cierres integradores cuatrimestrales sin evaluación propia (encuentros 16 y 33), momentos de intensificación y fortalecimiento (encuentros 17-20 y 34-35) y cierre integral (encuentro 36). La terminal, git y GitHub, y el trabajo colaborativo se enseñan de forma explícita antes de su primer uso y se ejercitan como saberes transversales durante todo el año.

---

## 2. Índice completo del corpus

Cada documento se presenta con una descripción de qué es y cuándo se usa. Los archivos con sufijo `-anexo-docente.md` son **anexos docentes: material de uso exclusivo del docente** (soluciones, criterios de corrección y guías de conducción); no se entregan a alumnos ni a administración.

### 2.1 Raíz del corpus — canon técnico

| Documento | Qué es y cuándo se usa |
| --- | --- |
| [convenciones-tecnicas.md](convenciones-tecnicas.md) | Canon del curso: fuente única de verdad de tipos, formatos y estructura de código (entorno, esqueleto de `Program.cs`, records canónicos, acceso a datos, respuestas HTTP, control de versiones). Se consulta ante cualquier duda técnica; toda divergencia con esta hoja es un defecto. |

### 2.2 Carpeta `01-planificacion/` — documentos administrativos

| Documento | Qué es y cuándo se usa |
| --- | --- |
| [planificacion-anual.csv](01-planificacion/planificacion-anual.csv) | Documento madre del curso: presentación y organización de los 16 tramos del ciclo anual (una fila por tramo), con ejes temáticos y correlación exacta. Es un render determinista de la firma pedagógica del curso (`materias/minimal-api-csharp.json`) mediante `tools/generar-administrativos.ps1`. Versión planilla (separador `;`, UTF-8 con BOM) para la carga institucional. |
| [libro-de-aula-1-linea-por-encuentro.csv](01-planificacion/libro-de-aula-1-linea-por-encuentro.csv) | Síntesis del plan de clases con una línea por encuentro (36 filas), para completar el libro de aula. El docente completa manualmente Fecha y Material al dictar cada encuentro. Render determinista del mismo origen; UTF-8 con BOM. |
| [libro-de-aula-2-lineas-por-encuentro.csv](01-planificacion/libro-de-aula-2-lineas-por-encuentro.csv) | Versión del libro de aula con 2 líneas por encuentro (72 filas), para instituciones que solicitan mayor detalle. Render determinista del mismo origen; UTF-8 con BOM. |

### 2.3 Carpeta `02-unidades/` — unidades didácticas y sus evaluaciones

Cada unidad reúne los documentos de clase dirigidos al alumno (con su anexo docente como material de uso exclusivo del docente) y el documento de evaluación de la unidad con sus dos versiones equivalentes.

#### Unidad didáctica 1 — Fundamentos de Minimal API con C# (`01-u1-fundamentos/`, encuentros 4 a 9)

| Encuentro | Documento del alumno | Qué trabajó | Anexo docente (solo docente) |
| --- | --- | --- | --- |
| 4 | [clase-04-primer-proyecto-minimal-api.md](02-unidades/01-u1-fundamentos/clase-04-primer-proyecto-minimal-api.md) | Primer proyecto con `dotnet new web`, anatomía de `Program.cs`, primer endpoint GET probado en el navegador. | [anexo clase 4](02-unidades/01-u1-fundamentos/clase-04-primer-proyecto-minimal-api-anexo-docente.md) |
| 5 | [clase-05-rutas-parametros-y-git-local.md](02-unidades/01-u1-fundamentos/clase-05-rutas-parametros-y-git-local.md) | Rutas y parámetros de ruta, tipos devueltos y JSON automático; incorporación de git local con la rutina de commit por clase. | [anexo clase 5](02-unidades/01-u1-fundamentos/clase-05-rutas-parametros-y-git-local-anexo-docente.md) |
| 6 | [clase-06-verbos-http-y-crud-en-memoria.md](02-unidades/01-u1-fundamentos/clase-06-verbos-http-y-crud-en-memoria.md) | Verbos HTTP y códigos de respuesta con cuadro de referencia rápida; CRUD completo en memoria. | [anexo clase 6](02-unidades/01-u1-fundamentos/clase-06-verbos-http-y-crud-en-memoria-anexo-docente.md) |
| 7 | [clase-07-consolidacion-crud-en-memoria.md](02-unidades/01-u1-fundamentos/clase-07-consolidacion-crud-en-memoria.md) | Consolidación con una mini API integradora en memoria; errores comunes y correcciones. | [anexo clase 7](02-unidades/01-u1-fundamentos/clase-07-consolidacion-crud-en-memoria-anexo-docente.md) |
| 8 | [clase-08-mini-proyecto-entrega-y-cierre-u1.md](02-unidades/01-u1-fundamentos/clase-08-mini-proyecto-entrega-y-cierre-u1.md) | Cierre de la unidad: desarrollo del tp-u1 en clase y ciclo completo de entrega (repositorio remoto en GitHub, remote add, push). | [anexo clase 8](02-unidades/01-u1-fundamentos/clase-08-mini-proyecto-entrega-y-cierre-u1-anexo-docente.md) |
| 9 | [evaluacion-u1.md](02-unidades/01-u1-fundamentos/evaluacion-u1.md) | Encuentro dedicado de evaluación de la Unidad 1: entrega por GitHub, defensa individual y prueba práctica. Documento de metadatos y acuerdos. | — |
| 9 | [evaluacion-u1-version-a.md](02-unidades/01-u1-fundamentos/evaluacion-u1-version-a.md) · [evaluacion-u1-version-b.md](02-unidades/01-u1-fundamentos/evaluacion-u1-version-b.md) | Prueba práctica individual en dos versiones equivalentes (mismos objetivos y requisitos, distinto dominio o datos). | [anexo versión A](02-unidades/01-u1-fundamentos/evaluacion-u1-version-a-anexo-docente.md) · [anexo versión B](02-unidades/01-u1-fundamentos/evaluacion-u1-version-b-anexo-docente.md) |

#### Unidad didáctica 2 — Acceso a datos con SQLite y Dapper (`02-u2-acceso-datos-sqlite-dapper/`, encuentros 10 a 15)

| Encuentro | Documento del alumno | Qué trabajó | Anexo docente (solo docente) |
| --- | --- | --- | --- |
| 10 | [clase-10-sqlite-y-dapper-primera-consulta.md](02-unidades/02-u2-acceso-datos-sqlite-dapper/clase-10-sqlite-y-dapper-primera-consulta.md) | Devolución de la Unidad 1; primera mirada a `hospital.db`; conexión y primer SELECT con Dapper mapeado a records. | [anexo clase 10](02-unidades/02-u2-acceso-datos-sqlite-dapper/clase-10-sqlite-y-dapper-primera-consulta-anexo-docente.md) |
| 11 | [clase-11-consultas-parametrizadas-y-orden.md](02-unidades/02-u2-acceso-datos-sqlite-dapper/clase-11-consultas-parametrizadas-y-orden.md) | Consultas parametrizadas con WHERE y ORDER BY; parámetros de ruta y query string sobre la base. | [anexo clase 11](02-unidades/02-u2-acceso-datos-sqlite-dapper/clase-11-consultas-parametrizadas-y-orden-anexo-docente.md) |
| 12 | [clase-12-filtros-where-like-y-validacion.md](02-unidades/02-u2-acceso-datos-sqlite-dapper/clase-12-filtros-where-like-y-validacion.md) | Filtros WHERE y LIKE, búsquedas; validación manual simple y códigos 400 y 404. | [anexo clase 12](02-unidades/02-u2-acceso-datos-sqlite-dapper/clase-12-filtros-where-like-y-validacion-anexo-docente.md) |
| 13 | [clase-13-join-de-dos-tablas.md](02-unidades/02-u2-acceso-datos-sqlite-dapper/clase-13-join-de-dos-tablas.md) | JOIN de dos tablas (`patients` con `province_names`, `admissions` con `doctors`) y records compuestos. | [anexo clase 13](02-unidades/02-u2-acceso-datos-sqlite-dapper/clase-13-join-de-dos-tablas-anexo-docente.md) |
| 14 | [clase-14-escritura-cierre-u2-y-entrega.md](02-unidades/02-u2-acceso-datos-sqlite-dapper/clase-14-escritura-cierre-u2-y-entrega.md) | Escritura parametrizada (INSERT, UPDATE, DELETE con 201, 400 y 404); consolidación, cierre de la unidad y entrega del tp-u2. | [anexo clase 14](02-unidades/02-u2-acceso-datos-sqlite-dapper/clase-14-escritura-cierre-u2-y-entrega-anexo-docente.md) |
| 15 | [evaluacion-u2.md](02-unidades/02-u2-acceso-datos-sqlite-dapper/evaluacion-u2.md) | Encuentro dedicado de evaluación de la Unidad 2: entrega por GitHub, defensa individual y prueba práctica. Documento de metadatos y acuerdos. | — |
| 15 | [evaluacion-u2-version-a.md](02-unidades/02-u2-acceso-datos-sqlite-dapper/evaluacion-u2-version-a.md) · [evaluacion-u2-version-b.md](02-unidades/02-u2-acceso-datos-sqlite-dapper/evaluacion-u2-version-b.md) | Prueba práctica individual en dos versiones equivalentes. | [anexo versión A](02-unidades/02-u2-acceso-datos-sqlite-dapper/evaluacion-u2-version-a-anexo-docente.md) · [anexo versión B](02-unidades/02-u2-acceso-datos-sqlite-dapper/evaluacion-u2-version-b-anexo-docente.md) |

#### Unidad didáctica 3 — Integración de datos y publicación (`03-u3-integracion-datos-publicacion/`, encuentros 21 a 26)

| Encuentro | Documento del alumno | Qué trabajó | Anexo docente (solo docente) |
| --- | --- | --- | --- |
| 21 | [clase-21-join-triple-y-endpoints-compuestos.md](02-unidades/03-u3-integracion-datos-publicacion/clase-21-join-triple-y-endpoints-compuestos.md) | Devolución de la Unidad 2; JOIN de tres tablas (`admissions`, `patients`, `doctors`) y endpoints compuestos. | [anexo clase 21](02-unidades/03-u3-integracion-datos-publicacion/clase-21-join-triple-y-endpoints-compuestos-anexo-docente.md) |
| 22 | [clase-22-agregaciones-y-group-by.md](02-unidades/03-u3-integracion-datos-publicacion/clase-22-agregaciones-y-group-by.md) | Agregaciones COUNT, AVG y SUM con GROUP BY (por especialidad, por mes). | [anexo clase 22](02-unidades/03-u3-integracion-datos-publicacion/clase-22-agregaciones-y-group-by-anexo-docente.md) |
| 23 | [clase-23-subconsultas-y-datos-sucios.md](02-unidades/03-u3-integracion-datos-publicacion/clase-23-subconsultas-y-datos-sucios.md) | Subconsultas simples; datos sucios reales (NULL, errores de tipeo, fechas erróneas): robustez y manejo de errores. | [anexo clase 23](02-unidades/03-u3-integracion-datos-publicacion/clase-23-subconsultas-y-datos-sucios-anexo-docente.md) |
| 24 | [clase-24-configuracion-y-publicacion.md](02-unidades/03-u3-integracion-datos-publicacion/clase-24-configuracion-y-publicacion.md) | Configuración de la cadena de conexión en `appsettings.json`; publicación con `dotnet publish` y ejecución en release. | [anexo clase 24](02-unidades/03-u3-integracion-datos-publicacion/clase-24-configuracion-y-publicacion-anexo-docente.md) |
| 25 | [clase-25-consolidacion-cierre-u3-y-entrega.md](02-unidades/03-u3-integracion-datos-publicacion/clase-25-consolidacion-cierre-u3-y-entrega.md) | Sprint integrador; consolidación, cierre de la unidad y entrega del tp-u3. | [anexo clase 25](02-unidades/03-u3-integracion-datos-publicacion/clase-25-consolidacion-cierre-u3-y-entrega-anexo-docente.md) |
| 26 | [evaluacion-u3.md](02-unidades/03-u3-integracion-datos-publicacion/evaluacion-u3.md) | Encuentro dedicado de evaluación de la Unidad 3: entrega por GitHub, defensa individual y prueba práctica. Documento de metadatos y acuerdos. | — |
| 26 | [evaluacion-u3-version-a.md](02-unidades/03-u3-integracion-datos-publicacion/evaluacion-u3-version-a.md) · [evaluacion-u3-version-b.md](02-unidades/03-u3-integracion-datos-publicacion/evaluacion-u3-version-b.md) | Prueba práctica individual en dos versiones equivalentes. | [anexo versión A](02-unidades/03-u3-integracion-datos-publicacion/evaluacion-u3-version-a-anexo-docente.md) · [anexo versión B](02-unidades/03-u3-integracion-datos-publicacion/evaluacion-u3-version-b-anexo-docente.md) |

#### Unidad didáctica 4 — Trabajo integrador profesional (`04-u4-trabajo-integrador-profesional/`, encuentros 27 a 32)

| Encuentro | Documento del alumno | Qué trabajó | Anexo docente (solo docente) |
| --- | --- | --- | --- |
| 27 | [clase-27-trabajo-final-y-readme.md](02-unidades/04-u4-trabajo-integrador-profesional/clase-27-trabajo-final-y-readme.md) | Devolución de la Unidad 3; lanzamiento del trabajo final (consigna integradora con subconsultas y estadísticas); README de portada del repositorio. | [anexo clase 27](02-unidades/04-u4-trabajo-integrador-profesional/clase-27-trabajo-final-y-readme-anexo-docente.md) |
| 28 | [clase-28-issues-y-ramas-por-feature.md](02-unidades/04-u4-trabajo-integrador-profesional/clase-28-issues-y-ramas-por-feature.md) | Issues y organización del trabajo; ramas por feature y flujo de trabajo. | [anexo clase 28](02-unidades/04-u4-trabajo-integrador-profesional/clase-28-issues-y-ramas-por-feature-anexo-docente.md) |
| 29 | [clase-29-pull-requests-y-main-protegida.md](02-unidades/04-u4-trabajo-integrador-profesional/clase-29-pull-requests-y-main-protegida.md) | Pull requests con revisión entre pares y main protegida. | [anexo clase 29](02-unidades/04-u4-trabajo-integrador-profesional/clase-29-pull-requests-y-main-protegida-anexo-docente.md) |
| 30 | [clase-30-sprint-de-desarrollo-mentoria.md](02-unidades/04-u4-trabajo-integrador-profesional/clase-30-sprint-de-desarrollo-mentoria.md) | Sprint de desarrollo mentorizado, con retirada gradual del acompañamiento docente. | [anexo clase 30](02-unidades/04-u4-trabajo-integrador-profesional/clase-30-sprint-de-desarrollo-mentoria-anexo-docente.md) |
| 31 | [clase-31-consolidacion-cierre-u4-y-defensa.md](02-unidades/04-u4-trabajo-integrador-profesional/clase-31-consolidacion-cierre-u4-y-defensa.md) | Consolidación, cierre de la unidad, preparación de la defensa y entrega del trabajo-final. | [anexo clase 31](02-unidades/04-u4-trabajo-integrador-profesional/clase-31-consolidacion-cierre-u4-y-defensa-anexo-docente.md) |
| 32 | [evaluacion-u4.md](02-unidades/04-u4-trabajo-integrador-profesional/evaluacion-u4.md) | Encuentro dedicado de evaluación de la Unidad 4: entrega por GitHub y defensa del trabajo integrador. Documento de metadatos y acuerdos. | — |
| 32 | [evaluacion-u4-version-a.md](02-unidades/04-u4-trabajo-integrador-profesional/evaluacion-u4-version-a.md) · [evaluacion-u4-version-b.md](02-unidades/04-u4-trabajo-integrador-profesional/evaluacion-u4-version-b.md) | Verificación práctica individual en dos versiones equivalentes. | [anexo versión A](02-unidades/04-u4-trabajo-integrador-profesional/evaluacion-u4-version-a-anexo-docente.md) · [anexo versión B](02-unidades/04-u4-trabajo-integrador-profesional/evaluacion-u4-version-b-anexo-docente.md) |

### 2.4 Carpeta `03-encuadre-y-cierres/` — encuadre y cierres del ciclo anual

Documentos de encuadre y cierres definidos en la estructura anual. No imparten contenido nuevo ni tienen evaluación propia: los cierres son encuentros de síntesis y metacognición, y el 16 y el 33 abren además con la devolución de la unidad evaluada en el encuentro anterior.

| Documento | Qué es y cuándo se usa |
| --- | --- |
| [encuadre-01-diagnostico.md](03-encuadre-y-cierres/encuadre-01-diagnostico.md) | Encuentro 1: presentación de la asignatura y contrato pedagógico; seguridad e higiene y EPP del aula-taller (modalidad técnica); diagnóstico de saberes previos. Se usa al inicio del ciclo lectivo. |
| [cierre-16-cuatrimestre-1.md](03-encuadre-y-cierres/cierre-16-cuatrimestre-1.md) | Encuentro 16: cierre integrador del cuatrimestre 1 —síntesis, integración y metacognición del cuatrimestre, sin evaluación propia—; abre con la devolución de la Unidad 2. Se usa al finalizar el primer cuatrimestre. |
| [cierre-33-cuatrimestre-2.md](03-encuadre-y-cierres/cierre-33-cuatrimestre-2.md) | Encuentro 33: cierre integrador del cuatrimestre 2 —síntesis, integración y metacognición anual, sin evaluación propia—; abre con la devolución de la Unidad 4. Se usa al finalizar el segundo cuatrimestre. |
| [cierre-36-integral.md](03-encuadre-y-cierres/cierre-36-integral.md) | Encuentro 36: cierre integral de la asignatura; balance del recorrido, metacognición final y proyección formativa, sin contenidos nuevos y sin versión A/B. Se usa en el último encuentro del ciclo. |

### 2.5 Carpeta `04-intensificaciones/` — momentos de intensificación y fortalecimiento y sus evaluaciones

Un documento por cada momento de intensificación y fortalecimiento, cubriendo los encuentros que el momento define. Los momentos dentro de la estructura anual no imparten contenido nuevo; diciembre y marzo (fuera de la planificación anual) evalúan el camino mínimo completo del curso. Cada momento tiene su evaluación en dos versiones equivalentes, con su anexo docente (solo docente) en la subcarpeta `evaluaciones/`.

| Momento | Documento del momento | Evaluaciones (subcarpeta `evaluaciones/`) |
| --- | --- | --- |
| Saberes previos (encuentros 2-3) | [intensificaciones-02-03-saberes-previos.md](04-intensificaciones/intensificaciones-02-03-saberes-previos.md) | [base](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-02-03.md) · [versión A](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-02-03-version-a.md) · [versión B](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-02-03-version-b.md) · [anexo docente](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-02-03-anexo-docente.md) |
| Recuperación y profundización de las Unidades 1 y 2 (encuentros 17-18) | [intensificaciones-17-18-unidades-1-2.md](04-intensificaciones/intensificaciones-17-18-unidades-1-2.md) | [base](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-17-18.md) · [versión A](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-17-18-version-a.md) · [versión B](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-17-18-version-b.md) · [anexo docente](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-17-18-anexo-docente.md) |
| Momento integrador de las Unidades 1 y 2, proyecto puente (encuentros 19-20) | [intensificaciones-19-20-integradora-1-2.md](04-intensificaciones/intensificaciones-19-20-integradora-1-2.md) | [base](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-19-20.md) · [versión A](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-19-20-version-a.md) · [versión B](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-19-20-version-b.md) · [anexo docente](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-19-20-anexo-docente.md) |
| Recuperación y profundización de las Unidades 3 y 4 (encuentros 34-35) | [intensificaciones-34-35-unidades-3-4.md](04-intensificaciones/intensificaciones-34-35-unidades-3-4.md) | [base](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-34-35.md) · [versión A](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-34-35-version-a.md) · [versión B](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-34-35-version-b.md) · [anexo docente](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-34-35-anexo-docente.md) |
| Intensificación de diciembre (fuera de la planificación anual) | [intensificaciones-diciembre-intensificacion.md](04-intensificaciones/intensificaciones-diciembre-intensificacion.md) | [base](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-diciembre.md) · [versión A](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-diciembre-version-a.md) · [versión B](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-diciembre-version-b.md) · [anexo docente](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-diciembre-anexo-docente.md) |
| Intensificación de marzo (fuera de la planificación anual) | [intensificaciones-marzo-intensificacion.md](04-intensificaciones/intensificaciones-marzo-intensificacion.md) | [base](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-marzo.md) · [versión A](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-marzo-version-a.md) · [versión B](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-marzo-version-b.md) · [anexo docente](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-marzo-anexo-docente.md) |

Los momentos de recuperación (17-18 y 34-35) usan criterio de **Apto / No apto aún por objetivo mínimo**; el proyecto puente (19-20) usa **rúbrica de 100 puntos**; diciembre y marzo evalúan el **camino mínimo completo** del curso (el estándar de marzo es idéntico al de diciembre).

### 2.6 Carpeta `05-continuidad/` — continuidad pedagógica

Actividades de repaso y fijación para que los alumnos trabajen sin presencia docente; se entregan a la administración para los casos de ausencia del docente. Cada documento incluye actividades puntuadas sobre 100 y autoevaluación; la resolución se presenta de forma individual y manuscrita al inicio de la clase siguiente.

| Documento | Qué es y cuándo se usa | Anexo docente (solo docente) |
| --- | --- | --- |
| [continuidad-01-saberes-previos.md](05-continuidad/continuidad-01-saberes-previos.md) | Documento 1 de 4: repaso de saberes previos antes de la Unidad 1. Se usa ante ausencia docente en el tramo inicial del curso. | [anexo continuidad 1](05-continuidad/continuidad-01-saberes-previos-anexo-docente.md) |
| [continuidad-02-tras-evaluacion-u1.md](05-continuidad/continuidad-02-tras-evaluacion-u1.md) | Documento 2 de 4: repaso de los contenidos de la Unidad 1. Momento de uso: desde el encuentro 10. | [anexo continuidad 2](05-continuidad/continuidad-02-tras-evaluacion-u1-anexo-docente.md) |
| [continuidad-03-tras-evaluacion-u2.md](05-continuidad/continuidad-03-tras-evaluacion-u2.md) | Documento 3 de 4: repaso de los contenidos de las Unidades 1 y 2. Momento de uso: desde el encuentro 16. | [anexo continuidad 3](05-continuidad/continuidad-03-tras-evaluacion-u2-anexo-docente.md) |
| [continuidad-04-tras-evaluacion-u3.md](05-continuidad/continuidad-04-tras-evaluacion-u3.md) | Documento 4 de 4: repaso de los contenidos hasta la Unidad 3. Momento de uso: desde el encuentro 27. | [anexo continuidad 4](05-continuidad/continuidad-04-tras-evaluacion-u3-anexo-docente.md) |

### 2.7 Carpeta `06-aprobacion/` — criterios de aprobación

| Documento | Qué es y cuándo se usa |
| --- | --- |
| [criterios-aprobacion.md](06-aprobacion/criterios-aprobacion.md) | Documento institucional dirigido a alumnos, familias y dirección: qué se evalúa en cada unidad, mínimos exigibles, regla de entrega incompleta y capas de recuperación (intensificaciones del ciclo, diciembre y marzo). Se informa a los alumnos al inicio de la cursada y se consulta en cada instancia de evaluación y recuperación. |

---

## 3. Orden de creación de los documentos

El corpus se generó en cascada, en el siguiente orden: cada documento deriva del anterior y mantiene con él correlación exacta. Cualquier creación futura de material para esta materia debe respetar esta misma secuencia.

1. **Mapa maestro del encargo** (fuera del corpus del curso, en el repositorio de planificación) y hoja de canon técnico: [convenciones-tecnicas.md](convenciones-tecnicas.md).
2. **Planificación anual**, documento madre: [planificacion-anual.csv](01-planificacion/planificacion-anual.csv), render determinista de la firma pedagógica del curso (`materias/minimal-api-csharp.json`).
3. **Libro de aula**, derivado directo de la anual: [libro-de-aula-1-linea-por-encuentro.csv](01-planificacion/libro-de-aula-1-linea-por-encuentro.csv) y [libro-de-aula-2-lineas-por-encuentro.csv](01-planificacion/libro-de-aula-2-lineas-por-encuentro.csv).
4. **Clases de la Unidad 1** (encuentros 4 a 8) con sus anexos docentes: [clase-04](02-unidades/01-u1-fundamentos/clase-04-primer-proyecto-minimal-api.md), [clase-05](02-unidades/01-u1-fundamentos/clase-05-rutas-parametros-y-git-local.md), [clase-06](02-unidades/01-u1-fundamentos/clase-06-verbos-http-y-crud-en-memoria.md), [clase-07](02-unidades/01-u1-fundamentos/clase-07-consolidacion-crud-en-memoria.md), [clase-08](02-unidades/01-u1-fundamentos/clase-08-mini-proyecto-entrega-y-cierre-u1.md).
5. **Clases de la Unidad 2** (encuentros 10 a 14) con sus anexos docentes: [clase-10](02-unidades/02-u2-acceso-datos-sqlite-dapper/clase-10-sqlite-y-dapper-primera-consulta.md), [clase-11](02-unidades/02-u2-acceso-datos-sqlite-dapper/clase-11-consultas-parametrizadas-y-orden.md), [clase-12](02-unidades/02-u2-acceso-datos-sqlite-dapper/clase-12-filtros-where-like-y-validacion.md), [clase-13](02-unidades/02-u2-acceso-datos-sqlite-dapper/clase-13-join-de-dos-tablas.md), [clase-14](02-unidades/02-u2-acceso-datos-sqlite-dapper/clase-14-escritura-cierre-u2-y-entrega.md).
6. **Clases de la Unidad 3** (encuentros 21 a 25) con sus anexos docentes: [clase-21](02-unidades/03-u3-integracion-datos-publicacion/clase-21-join-triple-y-endpoints-compuestos.md), [clase-22](02-unidades/03-u3-integracion-datos-publicacion/clase-22-agregaciones-y-group-by.md), [clase-23](02-unidades/03-u3-integracion-datos-publicacion/clase-23-subconsultas-y-datos-sucios.md), [clase-24](02-unidades/03-u3-integracion-datos-publicacion/clase-24-configuracion-y-publicacion.md), [clase-25](02-unidades/03-u3-integracion-datos-publicacion/clase-25-consolidacion-cierre-u3-y-entrega.md).
7. **Clases de la Unidad 4** (encuentros 27 a 31) con sus anexos docentes: [clase-27](02-unidades/04-u4-trabajo-integrador-profesional/clase-27-trabajo-final-y-readme.md), [clase-28](02-unidades/04-u4-trabajo-integrador-profesional/clase-28-issues-y-ramas-por-feature.md), [clase-29](02-unidades/04-u4-trabajo-integrador-profesional/clase-29-pull-requests-y-main-protegida.md), [clase-30](02-unidades/04-u4-trabajo-integrador-profesional/clase-30-sprint-de-desarrollo-mentoria.md), [clase-31](02-unidades/04-u4-trabajo-integrador-profesional/clase-31-consolidacion-cierre-u4-y-defensa.md).
8. **Evaluaciones de unidad** (base, versiones A y B, y anexos docentes de cada versión, en la carpeta de su unidad): [evaluacion-u1](02-unidades/01-u1-fundamentos/evaluacion-u1.md), [evaluacion-u2](02-unidades/02-u2-acceso-datos-sqlite-dapper/evaluacion-u2.md), [evaluacion-u3](02-unidades/03-u3-integracion-datos-publicacion/evaluacion-u3.md), [evaluacion-u4](02-unidades/04-u4-trabajo-integrador-profesional/evaluacion-u4.md).
9. **Encuadre y cierres del ciclo**: [encuadre-01-diagnostico.md](03-encuadre-y-cierres/encuadre-01-diagnostico.md); luego [cierre-16-cuatrimestre-1.md](03-encuadre-y-cierres/cierre-16-cuatrimestre-1.md) y [cierre-33-cuatrimestre-2.md](03-encuadre-y-cierres/cierre-33-cuatrimestre-2.md), cierres de síntesis y metacognición sin evaluación propia; finalmente [cierre-36-integral.md](03-encuadre-y-cierres/cierre-36-integral.md).
10. **Momentos de intensificación y fortalecimiento** (6 momentos) con sus evaluaciones: [intensificaciones-02-03-saberes-previos.md](04-intensificaciones/intensificaciones-02-03-saberes-previos.md), [intensificaciones-17-18-unidades-1-2.md](04-intensificaciones/intensificaciones-17-18-unidades-1-2.md), [intensificaciones-19-20-integradora-1-2.md](04-intensificaciones/intensificaciones-19-20-integradora-1-2.md), [intensificaciones-34-35-unidades-3-4.md](04-intensificaciones/intensificaciones-34-35-unidades-3-4.md), [intensificaciones-diciembre-intensificacion.md](04-intensificaciones/intensificaciones-diciembre-intensificacion.md), [intensificaciones-marzo-intensificacion.md](04-intensificaciones/intensificaciones-marzo-intensificacion.md); y, en `04-intensificaciones/evaluaciones/`, base, versiones A y B y anexo docente para cada momento: [evaluacion-intensificaciones-02-03](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-02-03.md), [evaluacion-intensificaciones-17-18](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-17-18.md), [evaluacion-intensificaciones-19-20](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-19-20.md), [evaluacion-intensificaciones-34-35](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-34-35.md), [evaluacion-intensificaciones-diciembre](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-diciembre.md), [evaluacion-intensificaciones-marzo](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-marzo.md).
11. **Continuidad pedagógica** (4 documentos con sus anexos docentes): [continuidad-01-saberes-previos.md](05-continuidad/continuidad-01-saberes-previos.md), [continuidad-02-tras-evaluacion-u1.md](05-continuidad/continuidad-02-tras-evaluacion-u1.md), [continuidad-03-tras-evaluacion-u2.md](05-continuidad/continuidad-03-tras-evaluacion-u2.md), [continuidad-04-tras-evaluacion-u3.md](05-continuidad/continuidad-04-tras-evaluacion-u3.md).
12. **Criterios de aprobación**: [criterios-aprobacion.md](06-aprobacion/criterios-aprobacion.md).
13. **README índice**: este documento, que cierra el repositorio con la presentación del curso, el índice completo, el orden de creación, la diferencia entre unidades y ejes, y la fundamentación pedagógica.

---

## 4. Unidades didácticas y ejes temáticos

### 4.1 Diferencia conceptual

- **Unidad didáctica**: bloque de enseñanza con objetivos, contenidos, práctica, trabajo práctico obligatorio y encuentro dedicado de evaluación propios. Tiene extensión temporal definida en el ciclo (cinco encuentros más su evaluación) y constituye la unidad de acreditación de la materia.
- **Eje temático**: categoría temática con la que se rotula cada encuentro en el libro de aula. Un eje puede **coincidir con una unidad didáctica** (rótula los encuentros de esa unidad) o funcionar como **organizador transversal**: atraviesa encuentros de varias unidades porque el saber que agrupa se ejercita de forma recurrente durante todo el año, sin unidad propia.

### 4.2 Mapeo de esta materia

| Nº Eje | Denominación del eje | Tipo | Coincidencia con unidades |
| --- | --- | --- | --- |
| 1 | Fundamentos de Minimal API | Coincide con una unidad | Unidad didáctica 1 — Fundamentos de Minimal API con C# |
| 2 | Acceso a datos con Dapper | Coincide con una unidad | Unidad didáctica 2 — Acceso a datos con SQLite y Dapper |
| 3 | Integración y publicación | Coincide con una unidad | Unidad didáctica 3 — Integración de datos y publicación |
| 4 | Trabajo integrador profesional | Coincide con una unidad | Unidad didáctica 4 — Trabajo integrador profesional |
| 5 | Terminal, Git y GitHub | Organizador transversal | No tiene unidad propia |
| 6 | Diagnóstico, integración y metacognición | Organizador transversal | No tiene unidad propia |

Los ejes 5 y 6 no son unidades: no tienen TP propio ni encuentro dedicado de evaluación, y atraviesan encuentros de varias unidades.

### 4.3 Encuentros donde domina cada eje

| Nº Eje | Eje | Encuentros donde domina |
| --- | --- | --- |
| 1 | Fundamentos de Minimal API | 4, 5, 6, 7 y 9 |
| 2 | Acceso a datos con Dapper | 10, 11, 12, 13, 14 y 15 |
| 3 | Integración y publicación | 21, 22, 23, 24, 25 y 26 |
| 4 | Trabajo integrador profesional | 27, 30, 31 y 32 |
| 5 | Terminal, Git y GitHub | 8, 28 y 29 |
| 6 | Diagnóstico, integración y metacognición | 1, 2, 3, 16, 17, 18, 19, 20, 33, 34, 35 y 36 |

Ejemplos de cómo opera un organizador transversal:

- **Eje 5 — Terminal, Git y GitHub** domina en el encuentro 8 (cierre de la Unidad 1: el clímax del encuentro es el ciclo completo de entrega con repositorio remoto y push) y en los encuentros 28 y 29 (dentro de la Unidad 4: issues con ramas por feature y pull requests con main protegida, contenidos de la unidad pero rotulados por el eje transversal que los agrupa).
- **Eje 6 — Diagnóstico, integración y metacognición** domina en los encuentros 1 a 3 (encuadre, diagnóstico y saberes previos), en los cierres y recuperaciones del primer tramo (16 a 20) y en el cierre del segundo cuatrimestre y del año (33 a 36): instancias de síntesis que no imparten contenido nuevo.

El carácter dominante de cada encuentro, con su eje y denominación, consta en el libro de aula (`01-planificacion/`).

---

## 5. Fundamentación pedagógica del enfoque

El diseño de la asignatura no es una suma de temas ordenados cronológicamente: cada decisión de estructura responde a un principio instruccional reconocido. La siguiente tabla asocia cada decisión de diseño adoptada en este curso con su fundamento y su referencia.

| Decisión de diseño | Fundamento | Referencia |
| --- | --- | --- |
| **Secuenciación de prerrequisitos antes de su primer uso.** La terminal y el manejo de archivos se enseñan en los encuentros 2 y 3, antes de crear el primer proyecto (encuentro 4); HTTP y JSON se presentan en el encuentro 3, antes del primer endpoint; git local se enseña en el encuentro 5, antes de exigir la rutina de commits; el ciclo completo de entrega se enseña en el encuentro 8, antes de la primera entrega evaluada. Ningún encuentro depende de un saber que aún no se enseñó. | El aprendizaje significativo exige que el nuevo contenido se ancle en saberes ya disponibles en la estructura cognitiva del alumno; los organizadores previos preparan ese anclaje. | Ausubel (1968) |
| **Reducción de la carga cognitiva.** Todo el código vive en un único archivo `Program.cs`, sin abstracciones (sin patrón repositorio ni inyección de dependencias), con ejemplos mínimos y funcionales y comentarios abundantes; se evita que el alumno deba recordar la organización de múltiples archivos. | La memoria de trabajo es limitada: eliminar fuentes de carga extrínseca (archivos múltiples, abstracciones tempranas) libera capacidad para el aprendizaje del contenido. | Sweller (1988) |
| **Práctica distribuida de los saberes transversales.** La terminal, git y GitHub reaparecen en cada encuentro: rutina de commit al final de cada clase, carpeta nueva y push en cada entrega, repositorio vivo durante todo el año. | La revisión diaria y la práctica distribuida consolidan los saberes y automatizan los procedimientos, reduciendo el olvido y liberando recursos cognitivos para el contenido nuevo. | Rosenshine (2012) |
| **Progresión GRR dentro del encuentro.** Cada clase transita de la teoría mínima y la práctica guiada (yo hago) al ejercicio independiente (hacés solo), con el anexo docente como soporte de la etapa guiada; en la Unidad 4 el acompañamiento se retira gradualmente hasta el sprint mentorizado. | Liberación gradual de la responsabilidad: la explicitación y el modelado del docente ceden progresivamente hacia la práctica autónoma del alumno. | Pearson y Gallagher (1983) |
| **Ancla motivadora previa a las herramientas de infraestructura.** Primero la propia API corriendo (encuentro 4) y recién después git local (encuentro 5) y el ciclo completo de entrega (encuentro 8): la experiencia de ver funcionar el propio proyecto da sentido a las herramientas de versionado y entrega que le siguen. | El nuevo aprendizaje se ancla en una experiencia concreta y significativa: aquello que el alumno comprende y valora se vuelve punto de partida para lo que viene. | Ausubel (1968) |
| **Retroalimentación oportuna.** La evaluación de cada unidad se devuelve al encuentro siguiente; los anexos docentes incluyen soluciones y criterios de corrección que habilitan devoluciones inmediatas durante la clase. | La retroalimentación efectiva responde a las preguntas «¿hacia dónde voy?», «¿cómo voy?» y «¿qué sigue?», y llega a tiempo para poder usarse. | Hattie y Timperley (2007) |
| **Evaluación auténtica.** Los productos evaluados son reales y versionados en GitHub (tp-u1, tp-u2, tp-u3 y trabajo final), con defensa oral individual del propio código y un trabajo integrador que replica el flujo profesional de un repositorio (README, issues, ramas por feature, pull requests revisados y main protegida). | La evaluación auténtica valora el desempeño en situaciones reales del dominio: la comprensencia se evidencia cuando el alumno puede explicar y justificar lo que hizo. | Wiggins (1998) |
| **Trabajo cooperativo estructurado.** Los grupos se recalculan en cada encuentro según presentes y equipos disponibles (ningún equipo sin usar mientras haya alumnos sin equipo), con rotación de integrantes y revisión entre pares en los pull requests. | El aprendizaje cooperativo, con interdependencia positiva y responsabilidad individual, mejora los logros de todos los integrantes del grupo. | Johnson y Johnson (1999) |
| **Anticipación de errores comunes.** Cada clase cierra con los errores típicos del tema, su causa y su corrección; los momentos de intensificación y fortalecimiento retoman esos núcleos con pistas diferenciadas. | El monitoreo de la comprensión y la anticipación de los errores que los alumnos suelen cometer permiten corregir las confusiones antes de que se fijen. | Rosenshine (2012) |

### Referencias

- Ausubel, D. P. (1968). *Educational Psychology: A Cognitive View*. Holt, Rinehart and Winston.
- Hattie, J. y Timperley, H. (2007). «The Power of Feedback». *Review of Educational Research*, 77(1), 81-112.
- Johnson, D. W. y Johnson, R. T. (1999). *Learning Together and Alone: Cooperative, Competitive, and Individualistic Learning* (5.ª ed.). Allyn and Bacon.
- Pearson, P. D. y Gallagher, M. C. (1983). «The Instruction of Reading Comprehension». *Contemporary Educational Psychology*, 8(3), 317-344.
- Rosenshine, B. (2012). «Principles of Instruction: Research-Based Strategies That All Teachers Should Know». *American Educator*, 36(1), 12-19.
- Sweller, J. (1988). «Cognitive Load During Problem Solving: Effects on Learning». *Cognitive Science*, 12(2), 257-285.
- Wiggins, G. (1998). *Educative Assessment: Designing Assessments to Inform and Improve Student Performance*. Jossey-Bass.

---

## 6. Nota de correlación

La planificación anual ([`01-planificacion/planificacion-anual.csv`](01-planificacion/planificacion-anual.csv), render determinista de la firma pedagógica del curso `materias/minimal-api-csharp.json`) es el **documento madre** del curso: el libro de aula, las unidades didácticas y sus clases, las evaluaciones, el encuadre y los cierres del ciclo, los momentos de intensificación y fortalecimiento, la continuidad pedagógica y los criterios de aprobación derivan de ella con correlación exacta de numeración de encuentros, denominaciones de tramos, ejes, tiempos y momentos de evaluación y recuperación. Todo cambio futuro se ajusta **primero** en `materias/minimal-api-csharp.json`, se re-renderizan los administrativos con `tools/generar-administrativos.ps1` y se propaga **en cascada** a los documentos derivados; nunca se dejan documentos desalineados. Ante cualquier duda técnica de contenido, decide la hoja de [convenciones-tecnicas.md](convenciones-tecnicas.md).

---

## 7. Nota sobre tiempos y condiciones del curso

- **Tiempos teóricos:** cada encuentro declara 240 minutos teóricos (4 horas reloj), desagregados por bloques en su documento con actividades reales previstas para cada tramo temporal. Quienes completan la consigna base disponen siempre de **actividades de extensión y consolidación explícitas** (endpoints adicionales, casos límite, desafíos de profundización), de modo que el tiempo declarado corresponde a una actividad prevista para todos los alumnos.
- **Uso del celular:** no permitido en ningún encuentro. El alumno no lo necesita para este curso: el entorno de trabajo es la computadora del aula-taller con Visual Studio Code, terminal y navegador.
