# Programación en Python — Índice del curso

> Documento índice del corpus de la asignatura **Programación en Python**, redactado en registro docente formal. Presenta el curso, organiza el corpus completo mediante vínculos a cada documento, documenta el orden de creación de los materiales y la fundamentación pedagógica del enfoque. Es un documento derivado: se genera con `tools/generar-readme.ps1` a partir del árbol del corpus y de la firma pedagógica del curso (`materias/Programación en Python.json`).

---

## 1. Presentación del curso

| Campo | Detalle |
| --- | --- |
| Asignatura (denominación formal) | Programación en Python |
| Nivel y modalidad | Nivel secundario, escuela técnica |
| Carga horaria | 36 encuentros de 4 horas reloj (240 minutos teóricos por encuentro): 144 horas anuales, 18 encuentros por cuatrimestre |
| Uso del celular | No permitido |

El ciclo lectivo sigue una estructura fija de 36 encuentros organizados en 16 tramos: encuadre y diagnóstico (encuentro 1), recuperación y profundización de saberes previos (encuentros 2-3), cuatro unidades didácticas con su encuentro dedicado de evaluación (encuentros 4-9, 10-15, 21-26 y 27-32), cierres integradores cuatrimestrales sin evaluación propia (encuentros 16 y 33), momentos de intensificación y fortalecimiento (encuentros 17-20 y 34-35) y cierre integral (encuentro 36). La terminal, git y GitHub, y el trabajo colaborativo se enseñan de forma explícita antes de su primer uso y se ejercitan como saberes transversales durante todo el año.

---

## 2. Índice completo del corpus

Cada documento se presenta con una descripción de qué es y cuándo se usa. Los archivos con sufijo `-anexo-docente.md` son **anexos docentes: material de uso exclusivo del docente** (soluciones, criterios de corrección y guías de conducción); no se entregan a alumnos ni a administración.

### 2.1 Raíz del corpus — canon técnico

| Documento | Qué es y cuándo se usa |
| --- | --- |
| [convenciones-tecnicas.md](convenciones-tecnicas.md) | Canon del curso: fuente única de verdad de tipos, formatos y estructura de código. Se consulta ante cualquier duda técnica; toda divergencia con esta hoja es un defecto. |

### 2.2 Carpeta `01-planificacion/` — documentos administrativos

| Documento | Qué es y cuándo se usa |
| --- | --- |
| [01-planificacion/planificacion-anual.csv](01-planificacion/planificacion-anual.csv) | Documento madre del curso: presentación y organización de los 16 tramos del ciclo anual (una fila por tramo), con ejes temáticos y correlación exacta. Es un render determinista de la firma pedagógica del curso (`materias/Programación en Python.json`) mediante `tools/generar-administrativos.ps1`. Versión planilla (separador `;`, UTF-8 con BOM) para la carga institucional. |
| [01-planificacion/libro-de-aula-1-linea-por-encuentro.csv](01-planificacion/libro-de-aula-1-linea-por-encuentro.csv) | Síntesis del plan de clases con una línea por encuentro (36 filas), para completar el libro de aula. El docente completa manualmente Fecha y Material al dictar cada encuentro. Render determinista del mismo origen; UTF-8 con BOM. |
| [01-planificacion/libro-de-aula-2-lineas-por-encuentro.csv](01-planificacion/libro-de-aula-2-lineas-por-encuentro.csv) | Versión del libro de aula con 2 líneas por encuentro (72 filas), para instituciones que solicitan mayor detalle. Render determinista del mismo origen; UTF-8 con BOM. |

### 2.3 Carpeta `02-unidades/` — unidades didácticas y sus evaluaciones

Cada unidad reúne los documentos de clase dirigidos al alumno (con su anexo docente como material de uso exclusivo del docente) y el documento de evaluación de la unidad con sus versiones equivalentes.

#### Fundamentos de Python (`01-u1-fundamentos-de-python/`, encuentros 4 a 9)

| Encuentro | Documento del alumno | Qué trabajó | Anexo docente (solo docente) |
| --- | --- | --- | --- |
| 4 | [clase-04-primer-programa-en-python.md](02-unidades/01-u1-fundamentos-de-python/clase-04-primer-programa-en-python.md) | . | [anexo clase 4](02-unidades/01-u1-fundamentos-de-python/clase-04-primer-programa-en-python-anexo-docente.md) |
| 5 | [clase-05-condicionales-y-bucles.md](02-unidades/01-u1-fundamentos-de-python/clase-05-condicionales-y-bucles.md) | . | [anexo clase 5](02-unidades/01-u1-fundamentos-de-python/clase-05-condicionales-y-bucles-anexo-docente.md) |
| 6 | [clase-06-listas-y-cadenas.md](02-unidades/01-u1-fundamentos-de-python/clase-06-listas-y-cadenas.md) | . | [anexo clase 6](02-unidades/01-u1-fundamentos-de-python/clase-06-listas-y-cadenas-anexo-docente.md) |
| 7 | [clase-07-git-y-github-ciclo-completo.md](02-unidades/01-u1-fundamentos-de-python/clase-07-git-y-github-ciclo-completo.md) | . | [anexo clase 7](02-unidades/01-u1-fundamentos-de-python/clase-07-git-y-github-ciclo-completo-anexo-docente.md) |
| 8 | [clase-08-cierre-u1-repaso-y-tp.md](02-unidades/01-u1-fundamentos-de-python/clase-08-cierre-u1-repaso-y-tp.md) | . | [anexo clase 8](02-unidades/01-u1-fundamentos-de-python/clase-08-cierre-u1-repaso-y-tp-anexo-docente.md) |
| 9 | [evaluacion-u1.md](02-unidades/01-u1-fundamentos-de-python/evaluacion-u1.md) | Encuentro dedicado de evaluación de la Unidad 1: entrega, defensa individual y prueba práctica según los acuerdos de la unidad. Documento de metadatos de la instancia. | — |
| 9 | [evaluacion-u1-version-a.md](02-unidades/01-u1-fundamentos-de-python/evaluacion-u1-version-a.md) · [evaluacion-u1-version-b.md](02-unidades/01-u1-fundamentos-de-python/evaluacion-u1-version-b.md) | Prueba práctica individual en versiones equivalentes (mismos objetivos y requisitos, distinto dominio o datos). | [anexo versión A](02-unidades/01-u1-fundamentos-de-python/evaluacion-u1-version-a-anexo-docente.md) · [anexo versión B](02-unidades/01-u1-fundamentos-de-python/evaluacion-u1-version-b-anexo-docente.md) |

#### Funciones y archivos de texto (`02-u2-funciones-y-archivos-de-texto/`, encuentros 10 a 15)

| Encuentro | Documento del alumno | Qué trabajó | Anexo docente (solo docente) |
| --- | --- | --- | --- |
| 10 | [clase-10-funciones-def-y-return.md](02-unidades/02-u2-funciones-y-archivos-de-texto/clase-10-funciones-def-y-return.md) | . | [anexo clase 10](02-unidades/02-u2-funciones-y-archivos-de-texto/clase-10-funciones-def-y-return-anexo-docente.md) |
| 11 | [clase-11-leer-archivos-de-texto.md](02-unidades/02-u2-funciones-y-archivos-de-texto/clase-11-leer-archivos-de-texto.md) | . | [anexo clase 11](02-unidades/02-u2-funciones-y-archivos-de-texto/clase-11-leer-archivos-de-texto-anexo-docente.md) |
| 12 | [clase-12-escribir-archivos-de-texto.md](02-unidades/02-u2-funciones-y-archivos-de-texto/clase-12-escribir-archivos-de-texto.md) | . | [anexo clase 12](02-unidades/02-u2-funciones-y-archivos-de-texto/clase-12-escribir-archivos-de-texto-anexo-docente.md) |
| 13 | [clase-13-menu-con-persistencia.md](02-unidades/02-u2-funciones-y-archivos-de-texto/clase-13-menu-con-persistencia.md) | . | [anexo clase 13](02-unidades/02-u2-funciones-y-archivos-de-texto/clase-13-menu-con-persistencia-anexo-docente.md) |
| 14 | [clase-14-cierre-u2-repaso-y-tp.md](02-unidades/02-u2-funciones-y-archivos-de-texto/clase-14-cierre-u2-repaso-y-tp.md) | . | [anexo clase 14](02-unidades/02-u2-funciones-y-archivos-de-texto/clase-14-cierre-u2-repaso-y-tp-anexo-docente.md) |
| 15 | [evaluacion-u2.md](02-unidades/02-u2-funciones-y-archivos-de-texto/evaluacion-u2.md) | Encuentro dedicado de evaluación de la Unidad 2: entrega, defensa individual y prueba práctica según los acuerdos de la unidad. Documento de metadatos de la instancia. | — |
| 15 | [evaluacion-u2-version-a.md](02-unidades/02-u2-funciones-y-archivos-de-texto/evaluacion-u2-version-a.md) · [evaluacion-u2-version-b.md](02-unidades/02-u2-funciones-y-archivos-de-texto/evaluacion-u2-version-b.md) | Prueba práctica individual en versiones equivalentes (mismos objetivos y requisitos, distinto dominio o datos). | [anexo versión A](02-unidades/02-u2-funciones-y-archivos-de-texto/evaluacion-u2-version-a-anexo-docente.md) · [anexo versión B](02-unidades/02-u2-funciones-y-archivos-de-texto/evaluacion-u2-version-b-anexo-docente.md) |

#### Datos estructurados y JSON (`03-u3-datos-estructurados-y-json/`, encuentros 21 a 26)

| Encuentro | Documento del alumno | Qué trabajó | Anexo docente (solo docente) |
| --- | --- | --- | --- |
| 21 | [clase-21-diccionarios-y-registros.md](02-unidades/03-u3-datos-estructurados-y-json/clase-21-diccionarios-y-registros.md) | . | [anexo clase 21](02-unidades/03-u3-datos-estructurados-y-json/clase-21-diccionarios-y-registros-anexo-docente.md) |
| 22 | [clase-22-csv-plano-a-mano.md](02-unidades/03-u3-datos-estructurados-y-json/clase-22-csv-plano-a-mano.md) | . | [anexo clase 22](02-unidades/03-u3-datos-estructurados-y-json/clase-22-csv-plano-a-mano-anexo-docente.md) |
| 23 | [clase-23-json-con-la-stdlib.md](02-unidades/03-u3-datos-estructurados-y-json/clase-23-json-con-la-stdlib.md) | . | [anexo clase 23](02-unidades/03-u3-datos-estructurados-y-json/clase-23-json-con-la-stdlib-anexo-docente.md) |
| 24 | [clase-24-txt-csv-o-json-eleccion.md](02-unidades/03-u3-datos-estructurados-y-json/clase-24-txt-csv-o-json-eleccion.md) | . | [anexo clase 24](02-unidades/03-u3-datos-estructurados-y-json/clase-24-txt-csv-o-json-eleccion-anexo-docente.md) |
| 25 | [clase-25-cierre-u3-repaso-y-tp.md](02-unidades/03-u3-datos-estructurados-y-json/clase-25-cierre-u3-repaso-y-tp.md) | . | [anexo clase 25](02-unidades/03-u3-datos-estructurados-y-json/clase-25-cierre-u3-repaso-y-tp-anexo-docente.md) |
| 26 | [evaluacion-u3.md](02-unidades/03-u3-datos-estructurados-y-json/evaluacion-u3.md) | Encuentro dedicado de evaluación de la Unidad 3: entrega, defensa individual y prueba práctica según los acuerdos de la unidad. Documento de metadatos de la instancia. | — |
| 26 | [evaluacion-u3-version-a.md](02-unidades/03-u3-datos-estructurados-y-json/evaluacion-u3-version-a.md) · [evaluacion-u3-version-b.md](02-unidades/03-u3-datos-estructurados-y-json/evaluacion-u3-version-b.md) | Prueba práctica individual en versiones equivalentes (mismos objetivos y requisitos, distinto dominio o datos). | [anexo versión A](02-unidades/03-u3-datos-estructurados-y-json/evaluacion-u3-version-a-anexo-docente.md) · [anexo versión B](02-unidades/03-u3-datos-estructurados-y-json/evaluacion-u3-version-b-anexo-docente.md) |

#### Proyecto integrador y Git profesional (`04-u4-proyecto-integrador-y-git-profesional/`, encuentros 27 a 32)

| Encuentro | Documento del alumno | Qué trabajó | Anexo docente (solo docente) |
| --- | --- | --- | --- |
| 27 | [clase-27-git-profesional-ramas-y-pr.md](02-unidades/04-u4-proyecto-integrador-y-git-profesional/clase-27-git-profesional-ramas-y-pr.md) | . | [anexo clase 27](02-unidades/04-u4-proyecto-integrador-y-git-profesional/clase-27-git-profesional-ramas-y-pr-anexo-docente.md) |
| 28 | [clase-28-readme-y-main-protegida.md](02-unidades/04-u4-proyecto-integrador-y-git-profesional/clase-28-readme-y-main-protegida.md) | . | [anexo clase 28](02-unidades/04-u4-proyecto-integrador-y-git-profesional/clase-28-readme-y-main-protegida-anexo-docente.md) |
| 29 | [clase-29-integrador-diseno-y-nucleo.md](02-unidades/04-u4-proyecto-integrador-y-git-profesional/clase-29-integrador-diseno-y-nucleo.md) | . | [anexo clase 29](02-unidades/04-u4-proyecto-integrador-y-git-profesional/clase-29-integrador-diseno-y-nucleo-anexo-docente.md) |
| 30 | [clase-30-integrador-datos-y-funciones.md](02-unidades/04-u4-proyecto-integrador-y-git-profesional/clase-30-integrador-datos-y-funciones.md) | . | [anexo clase 30](02-unidades/04-u4-proyecto-integrador-y-git-profesional/clase-30-integrador-datos-y-funciones-anexo-docente.md) |
| 31 | [clase-31-cierre-u4-entrega-y-defensa.md](02-unidades/04-u4-proyecto-integrador-y-git-profesional/clase-31-cierre-u4-entrega-y-defensa.md) | . | [anexo clase 31](02-unidades/04-u4-proyecto-integrador-y-git-profesional/clase-31-cierre-u4-entrega-y-defensa-anexo-docente.md) |
| 32 | [evaluacion-u4.md](02-unidades/04-u4-proyecto-integrador-y-git-profesional/evaluacion-u4.md) | Encuentro dedicado de evaluación de la Unidad 4: entrega, defensa individual y prueba práctica según los acuerdos de la unidad. Documento de metadatos de la instancia. | — |
| 32 | [evaluacion-u4-version-a.md](02-unidades/04-u4-proyecto-integrador-y-git-profesional/evaluacion-u4-version-a.md) · [evaluacion-u4-version-b.md](02-unidades/04-u4-proyecto-integrador-y-git-profesional/evaluacion-u4-version-b.md) | Prueba práctica individual en versiones equivalentes (mismos objetivos y requisitos, distinto dominio o datos). | [anexo versión A](02-unidades/04-u4-proyecto-integrador-y-git-profesional/evaluacion-u4-version-a-anexo-docente.md) · [anexo versión B](02-unidades/04-u4-proyecto-integrador-y-git-profesional/evaluacion-u4-version-b-anexo-docente.md) |

### 2.4 Carpeta `03-encuadre-y-cierres/` — encuadre y cierres del ciclo anual

Documentos de encuadre y cierres definidos en la estructura anual. No imparten contenido nuevo ni tienen evaluación propia: los cierres son encuentros de síntesis y metacognición, y el cierre cuatrimestral abre con la devolución de la unidad evaluada en el encuentro anterior.

| Documento | Qué es y cuándo se usa |
| --- | --- |
| [encuadre-01-diagnostico.md](03-encuadre-y-cierres/encuadre-01-diagnostico.md) | Encuentro 1: presentación de la asignatura y contrato pedagógico; diagnóstico de saberes previos. Se usa al inicio del ciclo lectivo. |
| [cierre-16-cuatrimestre-1.md](03-encuadre-y-cierres/cierre-16-cuatrimestre-1.md) | Encuentro 16: cierre integrador del cuatrimestre 1 —síntesis, integración y metacognición del cuatrimestre, sin evaluación propia—; abre con la devolución de la unidad evaluada en el encuentro anterior. Se usa al finalizar el cuatrimestre 1. |
| [cierre-33-cuatrimestre-2.md](03-encuadre-y-cierres/cierre-33-cuatrimestre-2.md) | Encuentro 33: cierre integrador del cuatrimestre 2 —síntesis, integración y metacognición del cuatrimestre, sin evaluación propia—; abre con la devolución de la unidad evaluada en el encuentro anterior. Se usa al finalizar el cuatrimestre 2. |
| [cierre-36-integral.md](03-encuadre-y-cierres/cierre-36-integral.md) | Encuentro 36: cierre integral de la asignatura; balance del recorrido, metacognición final y proyección formativa, sin contenidos nuevos. Se usa en el último encuentro del ciclo. |

### 2.5 Carpeta `04-intensificaciones/` — momentos de intensificación y fortalecimiento y sus evaluaciones

Un documento por cada momento de intensificación y fortalecimiento, cubriendo los encuentros que el momento define. Los momentos dentro de la estructura anual no imparten contenido nuevo; diciembre y marzo (fuera de la planificación anual) evalúan el camino mínimo completo del curso. Cada momento tiene su evaluación en versiones equivalentes, con sus anexos docentes (solo docente) en la subcarpeta `evaluaciones/`.

| Momento | Documento del momento | Evaluaciones (subcarpeta `evaluaciones/`) |
| --- | --- | --- |
| Saberes previos (encuentros 2-3) | [intensificaciones-02-03-saberes-previos.md](04-intensificaciones/intensificaciones-02-03-saberes-previos.md) | [base](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-02-03.md) · [versión A](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-02-03-version-a.md) · [versión B](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-02-03-version-b.md) |
| Unidades 1 y 2 (encuentros 17-18) | [intensificaciones-17-18-unidades-1-y-2.md](04-intensificaciones/intensificaciones-17-18-unidades-1-y-2.md) | [base](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-17-18.md) · [versión A](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-17-18-version-a.md) · [versión B](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-17-18-version-b.md) |
| Integradora 1 y 2 (encuentros 19-20) | [intensificaciones-19-20-integradora-1-y-2.md](04-intensificaciones/intensificaciones-19-20-integradora-1-y-2.md) | [base](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-19-20.md) · [versión A](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-19-20-version-a.md) · [versión B](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-19-20-version-b.md) |
| Unidades 3 y 4 (encuentros 34-35) | [intensificaciones-34-35-unidades-3-y-4.md](04-intensificaciones/intensificaciones-34-35-unidades-3-y-4.md) | [base](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-34-35.md) · [versión A](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-34-35-version-a.md) · [versión B](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-34-35-version-b.md) |
| Diciembre (fuera de la planificación anual) | [intensificaciones-diciembre-intensificacion.md](04-intensificaciones/intensificaciones-diciembre-intensificacion.md) | [base](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-diciembre.md) · [versión A](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-diciembre-version-a.md) · [versión B](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-diciembre-version-b.md) |
| Marzo (fuera de la planificación anual) | [intensificaciones-marzo-intensificacion.md](04-intensificaciones/intensificaciones-marzo-intensificacion.md) | [base](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-marzo.md) · [versión A](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-marzo-version-a.md) · [versión B](04-intensificaciones/evaluaciones/evaluacion-intensificaciones-marzo-version-b.md) |

Los momentos de recuperación (17-18 y 34-35) usan criterio de **Apto / No apto aún por objetivo mínimo**; el proyecto puente (19-20) usa **rúbrica de 100 puntos**; diciembre y marzo evalúan el **camino mínimo completo** del curso (el estándar de marzo es idéntico al de diciembre).

### 2.6 Carpeta `05-continuidad/` — continuidad pedagógica

Actividades de repaso y fijación para que los alumnos trabajen sin presencia docente; se entregan a la administración para los casos de ausencia del docente. Cada documento incluye actividades puntuadas sobre 100 y autoevaluación; la resolución se presenta de forma individual y manuscrita al inicio de la clase siguiente.

| Documento | Qué es y cuándo se usa | Anexo docente (solo docente) |
| --- | --- | --- |
| [continuidad-01-saberes-previos.md](05-continuidad/continuidad-01-saberes-previos.md) | Documento 1 de 4: repaso de saberes previos antes de la primera unidad didáctica. Se usa ante ausencia docente. | [anexo continuidad 1](05-continuidad/continuidad-01-saberes-previos-anexo-docente.md) |
| [continuidad-02-tras-evaluacion-u1.md](05-continuidad/continuidad-02-tras-evaluacion-u1.md) | Documento 2 de 4: repaso de los contenidos trabajados hasta la evaluación de la Unidad 1. Se usa ante ausencia docente. | [anexo continuidad 2](05-continuidad/continuidad-02-tras-evaluacion-u1-anexo-docente.md) |
| [continuidad-03-tras-evaluacion-u2.md](05-continuidad/continuidad-03-tras-evaluacion-u2.md) | Documento 3 de 4: repaso de los contenidos trabajados hasta la evaluación de la Unidad 2. Se usa ante ausencia docente. | [anexo continuidad 3](05-continuidad/continuidad-03-tras-evaluacion-u2-anexo-docente.md) |
| [continuidad-04-tras-evaluacion-u3.md](05-continuidad/continuidad-04-tras-evaluacion-u3.md) | Documento 4 de 4: repaso de los contenidos trabajados hasta la evaluación de la Unidad 3. Se usa ante ausencia docente. | [anexo continuidad 4](05-continuidad/continuidad-04-tras-evaluacion-u3-anexo-docente.md) |

### 2.7 Carpeta `06-aprobacion/` — criterios de aprobación

| Documento | Qué es y cuándo se usa |
| --- | --- |
| [06-aprobacion/criterios-aprobacion.md](06-aprobacion/criterios-aprobacion.md) | Documento institucional dirigido a alumnos, familias y dirección: qué se evalúa en cada unidad, mínimos exigibles, regla de entrega incompleta y capas de recuperación. Se informa a los alumnos al inicio de la cursada y se consulta en cada instancia de evaluación y recuperación. |

---

## 3. Orden de creación de los documentos

El corpus se genera en cascada, en el siguiente orden: cada documento deriva del anterior y mantiene con él correlación exacta. Cualquier creación futura de material para esta materia debe respetar esta misma secuencia.

1. **Mapa maestro del encargo** (fuera del corpus, en el repositorio de planificación) y hoja de canon técnico: [convenciones-tecnicas.md](convenciones-tecnicas.md).
2. **Planificación anual**, documento madre (render determinista de la firma pedagógica `materias/Programación en Python.json` mediante `tools/generar-administrativos.ps1`): [01-planificacion/planificacion-anual.csv](01-planificacion/planificacion-anual.csv); y **libro de aula**, derivado directo de la anual: [01-planificacion/libro-de-aula-1-linea-por-encuentro.csv](01-planificacion/libro-de-aula-1-linea-por-encuentro.csv), [01-planificacion/libro-de-aula-2-lineas-por-encuentro.csv](01-planificacion/libro-de-aula-2-lineas-por-encuentro.csv).
3. **Encuadre del ciclo**: [encuadre-01-diagnostico.md](03-encuadre-y-cierres/encuadre-01-diagnostico.md).
4. **Saberes previos** (momento de intensificación previo a las unidades): [intensificaciones-02-03-saberes-previos.md](04-intensificaciones/intensificaciones-02-03-saberes-previos.md), con su evaluación en `04-intensificaciones/evaluaciones/`.
5. **Fundamentos de Python** (encuentros 4 a 8), cada clase con su anexo docente: [clase-04](02-unidades/01-u1-fundamentos-de-python/clase-04-primer-programa-en-python.md), [clase-05](02-unidades/01-u1-fundamentos-de-python/clase-05-condicionales-y-bucles.md), [clase-06](02-unidades/01-u1-fundamentos-de-python/clase-06-listas-y-cadenas.md), [clase-07](02-unidades/01-u1-fundamentos-de-python/clase-07-git-y-github-ciclo-completo.md), [clase-08](02-unidades/01-u1-fundamentos-de-python/clase-08-cierre-u1-repaso-y-tp.md).
6. **Funciones y archivos de texto** (encuentros 10 a 14), cada clase con su anexo docente: [clase-10](02-unidades/02-u2-funciones-y-archivos-de-texto/clase-10-funciones-def-y-return.md), [clase-11](02-unidades/02-u2-funciones-y-archivos-de-texto/clase-11-leer-archivos-de-texto.md), [clase-12](02-unidades/02-u2-funciones-y-archivos-de-texto/clase-12-escribir-archivos-de-texto.md), [clase-13](02-unidades/02-u2-funciones-y-archivos-de-texto/clase-13-menu-con-persistencia.md), [clase-14](02-unidades/02-u2-funciones-y-archivos-de-texto/clase-14-cierre-u2-repaso-y-tp.md).
7. **Datos estructurados y JSON** (encuentros 21 a 25), cada clase con su anexo docente: [clase-21](02-unidades/03-u3-datos-estructurados-y-json/clase-21-diccionarios-y-registros.md), [clase-22](02-unidades/03-u3-datos-estructurados-y-json/clase-22-csv-plano-a-mano.md), [clase-23](02-unidades/03-u3-datos-estructurados-y-json/clase-23-json-con-la-stdlib.md), [clase-24](02-unidades/03-u3-datos-estructurados-y-json/clase-24-txt-csv-o-json-eleccion.md), [clase-25](02-unidades/03-u3-datos-estructurados-y-json/clase-25-cierre-u3-repaso-y-tp.md).
8. **Proyecto integrador y Git profesional** (encuentros 27 a 31), cada clase con su anexo docente: [clase-27](02-unidades/04-u4-proyecto-integrador-y-git-profesional/clase-27-git-profesional-ramas-y-pr.md), [clase-28](02-unidades/04-u4-proyecto-integrador-y-git-profesional/clase-28-readme-y-main-protegida.md), [clase-29](02-unidades/04-u4-proyecto-integrador-y-git-profesional/clase-29-integrador-diseno-y-nucleo.md), [clase-30](02-unidades/04-u4-proyecto-integrador-y-git-profesional/clase-30-integrador-datos-y-funciones.md), [clase-31](02-unidades/04-u4-proyecto-integrador-y-git-profesional/clase-31-cierre-u4-entrega-y-defensa.md).
9. **Evaluaciones de unidad** (documento base, versiones equivalentes y anexos docentes en la carpeta de cada unidad): [evaluacion-u1](02-unidades/01-u1-fundamentos-de-python/evaluacion-u1.md), [evaluacion-u2](02-unidades/02-u2-funciones-y-archivos-de-texto/evaluacion-u2.md), [evaluacion-u3](02-unidades/03-u3-datos-estructurados-y-json/evaluacion-u3.md), [evaluacion-u4](02-unidades/04-u4-proyecto-integrador-y-git-profesional/evaluacion-u4.md).
10. **Cierres del ciclo**: [cierre-16-cuatrimestre-1.md](03-encuadre-y-cierres/cierre-16-cuatrimestre-1.md), [cierre-33-cuatrimestre-2.md](03-encuadre-y-cierres/cierre-33-cuatrimestre-2.md), [cierre-36-integral.md](03-encuadre-y-cierres/cierre-36-integral.md).
11. **Momentos de intensificación y fortalecimiento** del ciclo y de diciembre y marzo (cada uno con su evaluación —base, versiones equivalentes y anexos docentes— en `04-intensificaciones/evaluaciones/`): [intensificaciones-17-18-unidades-1-y-2.md](04-intensificaciones/intensificaciones-17-18-unidades-1-y-2.md), [intensificaciones-19-20-integradora-1-y-2.md](04-intensificaciones/intensificaciones-19-20-integradora-1-y-2.md), [intensificaciones-34-35-unidades-3-y-4.md](04-intensificaciones/intensificaciones-34-35-unidades-3-y-4.md), [intensificaciones-diciembre-intensificacion.md](04-intensificaciones/intensificaciones-diciembre-intensificacion.md), [intensificaciones-marzo-intensificacion.md](04-intensificaciones/intensificaciones-marzo-intensificacion.md).
12. **Continuidad pedagógica** (con anexos docentes): [continuidad-01-saberes-previos.md](05-continuidad/continuidad-01-saberes-previos.md), [continuidad-02-tras-evaluacion-u1.md](05-continuidad/continuidad-02-tras-evaluacion-u1.md), [continuidad-03-tras-evaluacion-u2.md](05-continuidad/continuidad-03-tras-evaluacion-u2.md), [continuidad-04-tras-evaluacion-u3.md](05-continuidad/continuidad-04-tras-evaluacion-u3.md).
13. **Criterios de aprobación**: [06-aprobacion/criterios-aprobacion.md](06-aprobacion/criterios-aprobacion.md).
14. **README índice**: este documento, generado con `tools/generar-readme.ps1` a partir del árbol del corpus y de la firma pedagógica (`materias/Programación en Python.json`).

---

## 4. Fundamentación pedagógica del enfoque

El diseño de la asignatura no es una suma de temas ordenados cronológicamente: cada decisión de estructura responde a un principio instruccional reconocido. La siguiente tabla asocia cada decisión de diseño adoptada en este curso con su fundamento y su referencia.

| Decisión de diseño | Fundamento | Referencia |
| --- | --- | --- |
| **Secuenciación de prerrequisitos antes de su primer uso.** La terminal y el manejo de archivos se enseñan en los encuentros 2 y 3, antes de crear el primer proyecto (encuentro 4); HTTP y JSON se presentan en el encuentro 3, antes del primer endpoint; git local se enseña en el encuentro 5, antes de exigir la rutina de commits; el ciclo completo de entrega se enseña en el encuentro 8, antes de la primera entrega evaluada. Ningún encuentro depende de un saber que aún no se enseñó. | El aprendizaje significativo exige que el nuevo contenido se ancle en saberes ya disponibles en la estructura cognitiva del alumno; los organizadores previos preparan ese anclaje. | Ausubel (1968) |
| **Reducción de la carga cognitiva.** La implementación se concentra en el mínimo de piezas posible: un único archivo de programa, sin abstracciones intermedias (sin capas de acceso ni inyección de dependencias), con ejemplos mínimos y funcionales y comentarios abundantes; el alumno no necesita retener la organización de múltiples archivos. | La memoria de trabajo es limitada: eliminar fuentes de carga extrínseca (archivos múltiples, abstracciones tempranas) libera capacidad para el aprendizaje del contenido. | Sweller (1988) |
| **Práctica distribuida de los saberes transversales.** La terminal, git y GitHub reaparecen en cada encuentro: rutina de commit al final de cada clase, carpeta nueva y push en cada entrega, repositorio vivo durante todo el año. | La revisión diaria y la práctica distribuida consolidan los saberes y automatizan los procedimientos, reduciendo el olvido y liberando recursos cognitivos para el contenido nuevo. | Rosenshine (2012) |
| **Progresión GRR dentro del encuentro.** Cada clase transita de la teoría mínima y la práctica guiada (yo hago) al ejercicio independiente (hacés solo), con el anexo docente como soporte de la etapa guiada; en la Unidad 4 el acompañamiento se retira gradualmente hasta el sprint mentorizado. | Liberación gradual de la responsabilidad: la explicitación y el modelado del docente ceden progresivamente hacia la práctica autónoma del alumno. | Pearson y Gallagher (1983) |
| **Ancla motivadora previa a las herramientas de infraestructura.** Primero la propia API corriendo (encuentro 4) y recién después git local (encuentro 5) y el ciclo completo de entrega (encuentro 8): la experiencia de ver funcionar el propio proyecto da sentido a las herramientas de versionado y entrega que le siguen. | El nuevo aprendizaje se ancla en una experiencia concreta y significativa: aquello que el alumno comprende y valora se vuelve punto de partida para lo que viene. | Ausubel (1968) |
| **Retroalimentación oportuna.** La evaluación de cada unidad se devuelve al encuentro siguiente; los anexos docentes incluyen soluciones y criterios de corrección que habilitan devoluciones inmediatas durante la clase. | La retroalimentación efectiva responde a las preguntas «¿hacia dónde voy?», «¿cómo voy?» y «¿qué sigue?», y llega a tiempo para poder usarse. | Hattie y Timperley (2007) |
| **Evaluación auténtica.** Los productos evaluados son reales y versionados en GitHub (TP-U1: programa de consola, TP-U2: agenda en archivo de texto, TP-U3: datos en JSON y Trabajo final: integrador con Git), con defensa oral individual del propio código y un trabajo integrador final que replica el flujo profesional de un repositorio (README de portada, issues, ramas por feature, pull requests revisados y main protegida). | La evaluación auténtica valora el desempeño en situaciones reales del dominio: la comprensencia se evidencia cuando el alumno puede explicar y justificar lo que hizo. | Wiggins (1998) |
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

## 5. Nota de correlación

La planificación anual ([`01-planificacion/planificacion-anual.csv`](01-planificacion/planificacion-anual.csv), render determinista de la firma pedagógica del curso `materias/Programación en Python.json`) es el **documento madre** del curso: el libro de aula, las unidades didácticas y sus clases, las evaluaciones, el encuadre y los cierres del ciclo, los momentos de intensificación y fortalecimiento, la continuidad pedagógica y los criterios de aprobación derivan de ella con correlación exacta de numeración de encuentros, denominaciones de tramos, ejes, tiempos y momentos de evaluación y recuperación. Todo cambio futuro se ajusta **primero** en `materias/Programación en Python.json`, se re-renderizan los administrativos con `tools/generar-administrativos.ps1` y este índice con `tools/generar-readme.ps1`, y se propaga **en cascada** a los documentos derivados; nunca se dejan documentos desalineados. Ante cualquier duda técnica de contenido, decide la hoja de [convenciones-tecnicas.md](convenciones-tecnicas.md).
