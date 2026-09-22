# Análisis del proyecto y plan de mejoras — la documentación anual del docente

> Documento de análisis y propuesta. Fecha: 2026-09-22. Origen: encargo +det42 (z-pdt-planificaciones.md).
> No es vinculante hasta aprobación: cada ítem del plan indica si requiere decisión del docente.
> Evidencia: corpus LPR vigente (98 .md, 884 KB), corpus LSO v1 (histórico en `main`, en regeneración),
> `input/plantillas/`, `prompt-plantilla-planificacion.md`, `tools/`, registro de features en `odd/tasks/`.

---

## 0. Resumen ejecutivo

El proyecto cumple su propósito original —que el docente programe una vez (curso-data) y derive toda la
documentación anual— y ya resolvió lo más costoso: administrativos 100% deterministas, cascada data-first
en 5 fases, slices de contexto por writer y versiones equivalentes por sustitución de dominio. Quedan tres
frentes de mejora, en este orden de valor:

1. **Anexos docentes (la duda original):** la separación tiene sentido real solo cuando el documento sale
   físicamente del docente (evaluaciones, continuidad). Para las clases —que se dictan en pizarrón y se
   entregan a alumnos solo por excepción— el anexo es un segundo documento que duplica estructura y
   contenido. Propuesta: **regla por destino** + fusión del anexo de clase en un único guión docente.
2. **Cerrar el ciclo anual:** faltan tres documentos que el docente necesita sí o sí al ejecutar y cerrar
   el año: planilla de seguimiento (TPs, defensas, instancias), memoria anual de cátedra e informes de
   mesa diciembre/marzo. Todos derivables de datos que el proyecto ya tiene.
3. **Generalización entre materias (determinismo moderado):** las secciones estructurales repetidas del
   corpus (metadatos, cierres, previews, rúbricas, salidas verificadas) pueden salir de un banco de frases
   compartido, igual que los 12 tramos invariantes de los administrativos. Ahorro estimado: 15-25% de los
   tokens de salida de la Fase 2, además de la eliminación del segundo documento por clase.

---

## 1. El proyecto visto desde su propósito original

### 1.1 La misión

> «Ser de ayuda para un docente en la creación de toda la documentación anual que requiere para llevar a
> cabo su trabajo, habiendo programado previamente todo su trabajo.»

Esa misión tiene dos mitades. La segunda (derivar documentos de una programación previa) está lograda y
validada con dos materias. La primera (**toda** la documentación anual) tiene un mapa de cobertura con
tres huecos, analizado en §4.

### 1.2 Lo que ya resuelve bien (preservar)

| Fortaleza | Evidencia |
|---|---|
| Programar una vez, derivar todo | `curso-data.json` = firma pedagógica propiedad del docente; anual y libros son render determinista (byte-idéntico, costo cero) |
| Cascada data-first en 5 fases | Fase 0 única autoría LLM de la firma; Fase 1 cero LLM; Fases 2-3 writers con slice de contexto; Fase 4 verificación |
| Modo actualización quirúrgico | `impacto.ps1` produce las tres listas (re-render / prosa afectada / intocado) |
| Versiones equivalentes baratas | `generar-version-b.ps1` + tabla de dominio por materia (LPR ya tiene la suya); C/D a costo marginal |
| Guardarrails de calidad | `validar-curso-data.ps1`, `verificar-curso.ps1`, `lint-canon.ps1` como puerta de salida |
| Diseño pedagógico explícito | BOPPPS + GRR, secuenciación de prerrequisitos, práctica distribuida, evaluación auténtica con defensa, fundamentación con autores (Sweller, Rosenshine, etc.) |
| Correlación exacta anual ↔ derivados | regla fija: el cambio entra por el curso-data, nunca editando derivados |

### 1.3 Cobertura del ciclo anual docente

| Documento del ciclo real | Estado | Fuente hoy |
|---|---|---|
| Planificación anual (plantilla institucional) | ✅ | `planificacion-anual.csv` (determinista) |
| Libro de aula (1 y 2 líneas) | ✅ | CSVs deterministas |
| Guión de dictado de cada clase | ✅ | `clase-XX.md` + anexo |
| Evaluaciones de unidad con versiones equivalentes | ✅ | base + A/B + anexo docente |
| Evaluaciones de momentos (6, incl. dic/mar) | ✅ | base + A/B |
| Documentos de intensificación/fortalecimiento | ✅ | 6 momentos con acuerdo pedagógico |
| Continuidad pedagógica (entrega a administración) | ✅ | 4 documentos + anexos |
| Criterios de aprobación (alumnos/familias/dirección) | ✅ | `06-aprobacion/` |
| Índice y fundamentación del curso | ✅ | README derivado + nota de cátedra |
| PDFs para imprimir | ✅ | `convertir-a-pdf.ps1` (combinado / solo anexos) |
| **Planilla de seguimiento anual** (TPs, defensas, instancias por grupo/alumno) | ❌ | — (los "registros de clase" viven dispersos en 20 anexos) |
| **Memoria anual de cátedra** (qué se hizo, desvíos, resultados) | ❌ | — |
| **Informes de mesa diciembre/marzo** (para administración) | ❌ | — (las evaluaciones existen; el informe formal no) |
| Comunicación a familias (boletín/comunicados) | ⚠️ fuera de alcance razonable | varía por escuela; los criterios de aprobación cubren la comunicación formal mínima |

---

## 2. Anexos docentes — análisis de la duda original

### 2.1 Qué contiene cada documento hoy (evidencia, clase LPR E7)

| Contenido | `clase-XX.md` | `-anexo-docente.md` |
|---|---|---|
| Metadatos + reparto de tiempos | ✅ | — (pero abre con su propio encabezado y nota) |
| Teoría mínima + práctica guiada resuelta | ✅ | — |
| Ejercicio independiente | consigna + **pista** (sin solución) | **solución completa + salida verificada** |
| Extensión | consignas | **soluciones** |
| Errores anticipados | ✅ §8 «Errores comunes y trampas» (error/causa/fix) | ✅ §5 «Errores esperados y cómo intervenir» (error/causa/intervención) — **solapado** |
| Criterios de corrección con puntos | — | ✅ checklist ✔/criterio/puntos |
| Registro de la clase (qué observar) | — | ✅ tabla |

### 2.2 La regla que falta: el destino decide

El canon actual aplica una regla universal: «las soluciones y criterios van SIEMPRE en archivo separado,
nunca dentro de los documentos que se entregan a alumnos o a administración». Esa regla protege el caso
correcto —evaluaciones y continuidad, que salen físicamente del docente— pero también separa el anexo de
las clases, cuyo destino real es **el propio docente** (dictado en pizarrón; entrega a alumnos solo
excepcional, según lo confirmado). Para una clase, la solución a la vista del guión es una ventaja, no un
riesgo: el docente que dicta quiere la solución, la rúbrica y los errores previstos **en el mismo recorrido
de lectura**.

**Propuesta — regla por destino del documento:**

| Destino | Documentos | Anexo separado |
|---|---|---|
| Alumno lo recibe físico/digital | Evaluaciones (versiones A/B), eventuales fichas | **Sí, obligatorio** (solución y rúbrica jamás en la hoja) |
| Administración lo recibe | Continuidad pedagógica | **Sí, obligatorio** (la administración recibe la actividad, no las soluciones) |
| Solo el docente | Clases (guión de dictado), bases de evaluación, documentos de momentos | **No: se fusiona en el guión** |

### 2.3 Solapamiento y costo concreto (corpus LPR)

- 32 anexos docentes = 288 KB = **32% del corpus** (98 .md / 884 KB).
- Anexos de clase: 20 archivos, **176 KB** (77% del peso de las clases mismas, que suman 228 KB).
- Anexos de evaluación de unidad: 8 / 60 KB; de continuidad: 4 / 52 KB (estos quedan).
- Duplicación detectada: la sección de errores aparece dos veces (clase §8 y anexo §5) con lentes casi
  idénticos; el anexo re-expone la consigna del ejercicio que la clase ya enunció; cada anexo repite
  encabezado, nota de alcance y estructura de tablas.
- Cada writer de clase produce hoy dos documentos completos: duplica tokens de salida estructural
  (encabezados, tablas, notas) y el overhead de armado.

### 2.4 Recomendación

1. **Fusionar** el anexo de clase dentro de `clase-XX.md` como secciones marcadas para el docente
   (convención de marcado, p. ej. sufijo `— docente` en el heading o marcadores HTML), en el punto de
   lectura natural: solución inmediatamente después del ejercicio, rúbrica al cierre, errores anticipados
   en una sola sección (fin de la duplicación clase/anexo).
2. **Recorte determinista para la entrega excepcional**: un script (o modo de `convertir-a-pdf.ps1`)
   que genere la «vista alumno» excluyendo las secciones docentes. La regla canónica cambia de «archivo
   separado siempre» a «separación por destino, con generador de vista alumno para clases».
3. **Mantener intactos** los anexos de evaluaciones y continuidad.
4. Ajustes derivados: `scaffold-clase.ps1` emite la clase fusionada; `-SoloAnexos` de
   `convertir-a-pdf.ps1` queda solo para evaluaciones/continuidad; `verificar-curso.ps1` y `lint-canon.ps1`
   actualizan sus reglas (anexos de clase dejan de existir).

**Ahorro estimado por materia nueva** (Fase 2, unidades): −20 archivos de salida, ~11% de KB de prosa de
unidades tras deduplicar, y un solo documento por writer. Combinado con §5 (frases estructurales), la
reducción de tokens de salida de la Fase 2 se estima en **25-35%**.

**Requiere decisión del docente** (es cambio de canon con impacto en corpus existentes: se aplicaría a
materias nuevas; LPR/LSO existentes se adaptan solo si se regeneran).

---

## 3. Mejoras pedagógicas

| # | Mejora | Fundamento | Prioridad |
|---|---|---|---|
| P-1 | **Una sola fuente de errores anticipados** por clase (hoy duplicada clase/anexo): tabla única error/causa probable/intervención docente. Al fusionar (§2.4) queda una sección. | Rosenshine: anticipar errores es parte del chequeo de comprensión; dos versiones divergentes del mismo listado son un riesgo de inconsistencia, no una fortaleza | P1 |
| P-2 | **Consolidar el «registro de la clase»** (hoy una tabla suelta en cada anexo) en la planilla de seguimiento anual (§4.1): lo que el docente observa en cada encuentro tiene un único lugar donde acumularse y servir al proceso evaluativo. | Evaluación de proceso con evidencia acumulada; hoy el registro se pierde en 20 archivos distintos | P1 |
| P-3 | **Cerrar la deuda del formato U4** (baseline del linter: 5 ERROR tipo-estructura en clases 27-31, formato sprint/mentoría sin tabla de tiempos). Propuesta: regla específica de reparto para encuentros de integrador (agenda de sprint con tiempos), sancionada en `estructura-de-la-clase.md`. | El formato distinto es intencional y defendible; lo que falta es canonizarlo para que el linter lo valide en vez de falsar error | P2 |
| P-4 | **Consistencia de soluciones en evaluaciones de momentos**: las 18 evaluaciones de intensificación no tienen anexo separado (solo las 4 de unidad lo tienen). Verificar que la base contenga soluciones/criterios completos (docente) y estandarizar: base = docente, versiones = alumno. | Paridad del principio «la solución nunca está en la hoja del alumno» | P2 |
| P-5 | **Variantes de estructura de clase por tipo de materia** (teórica vs. práctica vs. balanceada; adolescentes vs. adultos): `estructura-de-la-clase.md` ya es el lugar canónico; preparar la variante teórica recién cuando aparezca la primera materia de ese tipo (decisión del docente: «atacaremos los conflictos a medida que aparezcan»). | Evita sobre-ingeniería prematura; el archivo ya documenta la dependencia | P3 |

Notas pedagógicas que quedan **bien resueltas** y no se tocan: recorte efectivo como estimado implícito
(+det19/20), extensiones «para quienes terminan antes» como variante de relleno más defendible, acuerdos
pedagógicos diferenciados por condición, cierres metacognitivos sin evaluación propia.

---

## 4. Mejoras funcionales: cerrar el ciclo anual

El orden propuesto sigue la dependencia de datos: la planilla alimenta la memoria y los informes de mesa.

### 4.1 Planilla de seguimiento anual (P1 — el hueco de mayor uso diario)

- **Qué:** una planilla por curso (CSV + vista de uso) con una fila por encuentro y columnas para: TPs
  entregados por grupo (checkbox), defensas realizadas, resultados de instancias (evaluación de unidad,
  momentos), asistencia a intensificaciones, observaciones del registro de clase.
- **Por qué:** es el único documento de uso **semanal** del ciclo; hoy su contenido vive disperso en 20
  anexos. Además es el insumo directo de la memoria anual y de las mesas.
- **Implementación:** determinista desde `curso-data.json` (encuentros, instancias, TPs, grupos declarados);
  el docente la completa a mano (como Fecha/Material de los libros de aula). Script nuevo
  `generar-seguimiento.ps1` + fila en el README de tabla de herramientas.
- **Esfuerzo:** bajo (patrón ya probado de `generar-administrativos.ps1`).

### 4.2 Memoria anual de cátedra (P2)

- **Qué:** informe de cierre: lo planificado vs. lo efectivo (encuentros dictados, desvíos y motivos),
  resultados por instancia (agregados desde la planilla), funcionamiento de intensificaciones, ajustes
  propuestos para el próximo ciclo (que entran como cambios al curso-data: se cierra el lazo).
- **Implementación:** esqueleto determinista desde curso-data (estructura del ciclo, instancias, TPs) +
  prosa LLM breve para el análisis (lo único que no puede derivarse). Carpeta `07-memoria/` del curso.
- **Requiere decisión:** formato institucional variable por escuela → plantilla con secciones estándar y
  nota de ajuste manual, mismo criterio que la anual.

### 4.3 Informes de mesa diciembre/marzo (P2)

- **Qué:** el documento formal que acompaña cada mesa: instancia, destinatarios (los inscriptos que no
  alcanzaron), camino mínimo evaluado (ya existe en las evaluaciones de diciembre/marzo), criterio
  Apto/No apto aún, y espacio para resultados de la mesa.
- **Implementación:** derivado de las evaluaciones existentes + curso-data; mayormente determinista con
  espacios manuales (fecha, firmantes).

### 4.4 Fuera de alcance razonable (listado explícito)

Comunicados a familias y boletines: dependen de sistemas por escuela; los criterios de aprobación ya
cubren la comunicación formal mínima. Se listan para dejar constancia de la decisión, no se proponen.

---

## 5. Mejoras de implementación: tiempos, tokens y generalización

### 5.1 Evidencia de la comparación LSO ↔ LPR

El corpus LSO v1 (histórico en `main`) y el corpus LPR (canon vigente) tienen **formatos de clase
distintos**: LSO v1 usa «Datos del encuentro» (5 campos) y reparto genérico (Apertura / Desarrollo /
Cierre / **Actividad complementaria: 80 min**); LPR usa «Metadatos de bloque» (9 campos) y reparto
BOPPPS+GRR específico. La regeneración de LSO en curso converge al canon v2 — esa deriva es exactamente
la razón por la que la generalización debe anclarse al **canon vigente** (LPR + LSO regenerada), no al
corpus viejo. El viejo LSO además exhibe el anti-patrón que el canon nuevo ya corrige: la actividad
complementaria como relleno visible de 80 minutos.

### 5.2 Banco de frases estructurales (determinismo moderado)

**Qué es repetido y generalizable entre materias** (detectado en las 20 clases LPR; idéntico en estructura,
cambia solo el contenido):

| Sección | Repetición | Generalizable |
|---|---|---|
| Blockquote de unidad en cada clase | 20/20 | Total (proviene del curso-data) |
| Tabla «Metadatos de bloque» (campos fijos) | 20/20 | Esqueleto completo |
| Encabezados de sección numerados | 20/20 | Total |
| Cierre «Qué te llevás» / «Lo que viene» | 20/20 | Estructura + fraseo del título |
| Tabla de criterios ✔/criterio/puntos | en anexos y evaluaciones | Esqueleto |
| Bloques «Salida verificada» | anexos y evaluaciones | Formato |
| Tabla «Registro de la clase» | anexos | Esqueleto (migra a planilla, §4.1) |
| Nota de continuidad (resolución grupal / entrega individual manuscrita) | 4/4 | Total (ya es prosa fija del canon) |

**Propuesta:** extender el patrón ya probado de `tramos-invariantes.json` a la prosa de clase:
`input/plantillas/frases-estructurales.json` con los bloques fijos + placeholders, y que
`scaffold-clase.ps1` los emita ya resueltos. El writer recibe el documento con la estructura completa y
escribe **solo el contenido pedagógico** (teoría, consignas, soluciones, fraseos concretos). Mismo
tratamiento para evaluaciones (`scaffold-evaluacion.ps1`).

**Qué NO se parametriza** (límite del determinismo moderado): teoría mínima, analogías, consignas,
soluciones, intervenciones docentes, prosa de criterios — eso es contenido pedagógico y sigue siendo LLM.

### 5.3 Ahorro estimado (materia nueva, Fase 2 unidades)

| Palanca | Efecto |
|---|---|
| Fusión clase+anexo (§2.4) | −20 documentos de salida; ~11% menos KB de prosa; un solo armado por writer |
| Frases estructurales en scaffold (§5.2) | El writer deja de emitir tablas y encabezados estructurales: −15 a −20% de tokens de salida por clase |
| Ambas combinadas | **−25 a −35% de tokens de salida** en unidades; menor tiempo de pared (menos archivos, menos orquestación) |
| Administrativos/README | Ya en cero LLM (sin cambios) |

Los tokens de entrada ya están resueltos por slices + digest (y el 93% del input es caché según la
medición real del entorno); la palanca restante es la **salida**, que es la cara.

### 5.4 Deuda técnica registrada (no olvidar)

- Baseline del linter (`odd/tasks/optimizacion-tiempo-tokens.md`): 5 ERROR U4 (→ P-3), 1 ERROR snippet
  defectuoso intencional (`int PatientId` — convención de supresión pendiente), 4 AVISO preview-libro
  (falsos positivos leves), 3 AVISO prosa-estampada (estructura intencional).
- `tabla-dominio.json` filas D: pasada de lectura natural pendiente.
- Anexos de clase (si se aprueba la fusión): actualizar `convertir-a-pdf.ps1 -SoloAnexos`, scaffolds,
  verificador y linter en la misma feature (una sola unidad de trabajo, no incremental suelto).

---

## 6. Plan priorizado

| ID | Mejora | Eje | Esfuerzo | Ahorro/valor | ¿Decisión docente? |
|---|---|---|---|---|---|
| **P1-A** | Regla por destino para anexos + fusión anexo de clase en el guión docente + vista alumno determinista | Funcional/tokens | Medio | −25-35% tokens salida Fase 2; −20 archivos/materia | **Sí** (cambio de canon) |
| **P1-B** | Planilla de seguimiento anual (determinista desde curso-data) | Funcional/pedagógico | Bajo | Documento de uso diario; insumo de P2-B/P2-C | Sí (columnas deseadas) |
| **P1-C** | Tabla única de errores anticipados por clase (viene con P1-A) | Pedagógico | Incluido | Consistencia Rosenshine | No (con P1-A) |
| **P2-A** | Banco de frases estructurales + scaffolds que las emiten | Tokens | Medio | −15-20% salida por clase; uniformidad entre materias | No (aprobado nivel moderado) |
| **P2-B** | Memoria anual de cátedra (esqueleto determinista + prosa breve) | Funcional | Medio | Cierra el ciclo; alimenta el ajuste del curso-data | Sí (formato institucional) |
| **P2-C** | Informes de mesa diciembre/marzo | Funcional | Bajo | Documento formal exigible | Sí (formato) |
| **P2-D** | Canonizar formato U4 sprint/mentoría + regla de supresión del linter | Implementación | Bajo | Linter sin falsos positivos | Sí (5 ERROR actuales) |
| **P2-E** | Consistencia de soluciones en evaluaciones de momentos | Pedagógico | Bajo | Paridad alumno/docente | No |
| **P3-A** | Variante teórica de `estructura-de-la-clase.md` | Pedagógico | Diferido | Preparación materias distintas | Cuando aparezca |
| **P1-D** | Distribución del corpus y de PDFs por destinatario (docente / alumnos-regulares / alumnos-sin-regularidad / administración), matriz declarativa + modo `-PorDestinatario` + guías de camino por punto de reingreso | Funcional | Bajo-medio | Entrega sin errores de destinatario; autonomía del docente; reincorporaciones cubiertas | Sí (aprobado como análisis §9) |
| **P3-B** | Pasada de lectura natural: fraseos v2/v3 + tabla-dominio filas D | Tokens | Bajo | Calidad del banco existente | No |

Orden de ejecución sugerido: **P1-A y P1-B juntos** (una feature: canon + tools + scaffold + pdf), luego
P2-A sobre el corpus ya fusionado, luego P2-B/C/D/E, P3 cuando toque.

### 6.1 Registro de decisiones (2026-09-22)

- **P1-A — DECLINADO por ahora.** Se mantiene la estrategia vigente de anexos separados. Razón del
  docente: los documentos llegan a los alumnos solo en casos excepcionales (p. ej. enfermedad
  prolongada), donde el detalle adicional es un beneficio, no un riesgo; la promoción depende siempre
  de una evaluación presencial o de una actividad mejor pensada por el docente.
- **P1-B, P2-B y P2-C — CONFIRMADOS.** Planilla de seguimiento anual, memoria anual de cátedra e
  informes de mesa diciembre/marzo. Implementación: feature `odd/tasks/documentos-cierre-anual.md`
  (documentos derivados una vez y luego propiedad del docente; esqueletos completos sin prosa LLM:
  el análisis lo escribe el docente al cierre, los ajustes entran por el curso-data).

## 7. Riesgos

- **Fusión de anexos**: riesgo de entrega accidental de soluciones a alumnos → mitigado por la vista
  alumno determinista (el documento fuente siempre contiene todo; lo que sale es un render).
- **Regeneración en curso**: LSO se está regenerando ahora en otra sesión; aplicar P1-A antes de que
  termine cambia el objetivo de esa corrida → conveniente esperar o aplicar solo a materias nuevas.
- **Sobre-generalización**: frases demasiado genéricas suenan a plantilla ante una revisión → el banco
  cubre estructura, no contenido; los fraseos concretos siguen siendo LLM (límite moderado ya aprobado).
- **Materias muy distintas**: la generalización actual se valida con 2 materias prácticas similares
  (C#/Python, cero base); no extrapolar a teóricas sin P3-A.

## 8. Próximos pasos

1. El docente revisa este plan y decide P1-A (fusión + regla por destino) y el alcance de P1-B/P2-B/P2-C.
2. Se ejecuta la feature P1-A+P1-B cuando la regeneración de LSO termine (una feature, un odd doc,
   con work-unit commits).
3. P2-A se valida comparando el banco de frases contra LSO regenerada + LPR (dos materias canon v2).

> **Estado de ejecución (actualización 2026-09-22):** P1-A declinado por ahora (§6.1); P1-B, P2-B y P2-C
> implementados (feature `odd/tasks/documentos-cierre-anual.md`, corpus `07-cierre-anual/` en LAP).

---

## 9. Ampliación: distribución del corpus por destinatario (análisis, 2026-09-22)

> Encargo del docente: analizar la viabilidad y corrección de organizar los documentos de
> `output/<materia>` por destino — docente, alumnos regulares, alumnos sin regularidad, administración —
> y distribuir los PDFs por destinatario dentro de `pdf/`.

### 9.1 Veredicto: correcta y viable

La propuesta formaliza la misma regla que este plan ya identificado como la correcta (§2.2: **el destino
decide**), con una diferencia clave respecto de P1-A: **no cambia la autoría ni la estructura de carpetas
del corpus** — solo declara una matriz de clasificación y la usa para distribuir los PDFs. Eso la hace
compatibles con la declinación de P1-A (los anexos siguen separados) y de bajo costo: es un concepto
nuevo (`destinos`) + un modo nuevo del conversor existente.

### 9.2 Matriz de destinos propuesta (con refinamientos sobre el mapa del docente)

| Destino | Documentos | Fuente hoy |
|---|---|---|
| **docente** | Anexos docente de clases y de evaluaciones (`*-anexo-docente.md`), bases de evaluaciones (`evaluacion-uN.md`, bases de momentos), encuadre y cierres (`03-encuadre-y-cierres/`), documentos de momentos (`04-intensificaciones/*.md`), memoria anual y seguimiento (`07-cierre-anual/`) | 02, 03, 04, 05 (anexos), 07 |
| **alumnos-regulares** | Clases (`clase-*.md`), versiones A/B de evaluaciones de unidad, versiones A/B de los momentos del ciclo (02-03, 17-18, 19-20, 34-35), criterios de aprobación (copia para dirección) | 02 (clases + versiones), 06 |
| **alumnos-sin-regularidad** | Versiones A/B de diciembre y marzo + guías de camino por punto de reingreso: reincorporación a mitad de ciclo (18-19) y camino mínimo por mesa (§9.4) | 04-intensificaciones/evaluaciones + guías nuevas |
| **administración** | CSVs de `01-planificacion/`, documentos de continuidad de `05-continuidad/` (sin anexos), informes de mesa (`07-cierre-anual/`), criterios de aprobación (dirección) | 01, 05 (actividades), 06, 07 |

Refinamientos sobre el mapa propuesto (los cuatro bordes que el corte por nombre dejaba sueltos):
1. **Bases de evaluaciones → docente**, no alumnos: el corte «02-unidades sin anexo en el nombre» habría
   puesto `evaluacion-uN.md` (consigna maestra con criterios) en manos del alumno. Las versiones A/B son
   las únicas que viajan al alumno.
2. **Anexos de continuidad → docente**: la administración recibe la actividad para el caso de ausencia,
   nunca las soluciones (es el principio de §2.2 aplicado al mismo folder).
3. **Momentos del ciclo**: los documentos de acuerdos van al docente; las versiones A/B de los momentos
   en-ciclo van a alumnos regulares (el grupo con dificultades sigue siendo alumno regular con pistas
   diferenciadas); solo diciembre/marzo van al destino de regularidad.
4. **06-aprobacion y 07-cierre-anual no estaban en el mapa**: criterios → alumnos + administración
   (dirección; el PDF puede figurar en ambos destinos); seguimiento y memoria → docente; informes de
   mesa → administración.

### 9.3 Implementación (P1-D)

1. **Matriz declarativa compartida** `input/plantillas/destinos.json`: clasificación por patrón de nombre
   (estructuralmente invariante entre materias, igual que `tramos-invariantes.json`); fail-loud si un
   documento del corpus no clasifica en ningún destino.
2. **`tools/convertir-a-pdf.ps1 -PorDestinatario`**: crea `pdf/docente/`, `pdf/alumnos-regulares/`,
   `pdf/alumnos-sin-regularidad/`, `pdf/administracion/` y distribuye los PDFs. Coexiste con
   `-Combinado`, `-SoloAnexos` y `-Unidad` (modos por carpeta, quedan vigentes).
3. **README del curso**: sección de distribución por destinatario (entrada en `readme-descripciones.json`).
4. **`verificar-curso.ps1`**: chequeo de cobertura de la matriz (todo documento mapeado, nada ambiguo).
5. **Esfuerzo**: bajo-medio; cero cambio en el canon de contenido; PDFs siguen sin versionarse (gitignore).

### 9.4 Definición de «alumnos sin regularidad» (tres escenarios, incl. reincorporación a mitad de ciclo)

El instrumento ya existe (evaluaciones A/B de diciembre y marzo). La definición se completa con los
**tres escenarios de reingreso** y su guía correspondiente (nueva, determinista):

1. **Fin del ciclo → diciembre.** El alumno que reincorpora a fin del ciclo es equivalente al caso de
   diciembre: sin documento extra; la guía de camino de diciembre cubre el camino mínimo completo.
2. **Post-diciembre → marzo.** Ídem: la guía de marzo (mismo estándar, más tiempo de preparación).
3. **Reincorporación a mitad de ciclo → punto de referencia entre los encuentros 18 y 19** (punto
   declarado por el docente). Es la costura natural del ciclo: el cuatrimestre 1 queda completo (previos,
   U1, U2, evaluaciones 9 y 15, cierre 16, primera intensificación 17-18) y el proyecto puente (19-20)
   abre la integración antes del segundo cuatrimestre. Propuesta: `guia-reincorporacion-18-19.md` con:
   - el **camino mínimo de la primera mitad** (encuentros 2-18) por unidad — denominaciones, expectativas
     y TPs de `slots.unidades`/`slots.tps` — con referencia a las clases del corpus que el alumno ya
     tiene como material (clase-04…08, 10…14); cero prosa nueva, todo derivado;
   - el **punto de integración de reingreso**: el proyecto puente (19-20) como actividad que retoma U1-U2
     y engancha con U3, con las dos rutas posibles (con el mínimo alcanzado: pista integradora; sin él:
     pista de intensificación del momento 17-18 como refuerzo previo);
   - la **verificación de reingreso** con instrumentos existentes (evaluaciones U1/U2 y del momento
     17-18, versiones A/B; el docente elige cuáles aplicar) — no se inventa un instrumento nuevo.

La familia completa queda: **guías de camino por punto de reingreso** (`mitad-de-ciclo-18-19`,
`diciembre`, `marzo`) — un mismo generador determinista (puede ser el quinto/séptimo archivo de
`generar-cierre-anual.ps1` o un `generar-guias-camino.ps1` separado; decisión de implementación).
Ubicación del .md: `04-intensificaciones/` (familia de contenidos); el PDF viaja al destino
`alumnos-sin-regularidad` — la matriz desacopla ubicación de contenido y destino de distribución.
Si en el futuro apareciera otro punto de reingreso (p. ej. tras el 20), el generador parametriza el
corte; el 18-19 queda como el estándar declarado por el docente.

**Cada guía incluye un plan de estudio por bloque** (variante aprobada por el docente, 2026-09-22):
una sección `Plan de estudio por bloque` con tabla derivada — Bloque · Encuentros y clases del corpus
a estudiar · Qué debe poder hacer (expectativas de la unidad) · TP asociado · Instrumento de
verificación — compuesta desde el curso-data y la estructura del ciclo, sin prosa nueva. El detalle
por objetivo (el listado del camino mínimo) NO se duplica: la guía referencia el acuerdo pedagógico
del momento correspondiente (canon vigente). Para el reingreso 18-19 los bloques son: saberes previos
(2-3, requisito), U1 (4-9), U2 (10-15), refuerzo/intensificación (17-18) e integración (19-20, punto
de reingreso); para diciembre y marzo, los bloques siguen las unidades u1-u4 más los transversales
(GitHub y entrega), con los instrumentos por unidad y la referencia al programa integrador del
momento.

**Decisión registrada (2026-09-22):** no se crean unidades pedagógicas ni de estudio autónomo nuevas
para la recuperación: los momentos de intensificación vigentes, las clases del corpus y estas guías de
camino cubren el reingreso con los materiales ya generados. Las unidades de estudio autónomo dedicadas
solo revivirían ante un caso real documentado — p. ej. un alumno que necesite estudiar sin computadora
o con un enfoque muy distinto del curso — y como nueva feature con su decisión de canon.

### 9.5 Otras acciones deterministas para administración (01-planificacion)

Cubiertas hoy: los 3 CSV institucionales, los informes de mesa y los criterios (dirección). Opcional,
barato y del mismo patrón: `caratula-administracion.md` — índice determinista de los documentos que
administra la institución (qué contiene, dónde está, espacios de fecha/registro manual). Se recomienda
como ítem de bajo costo, no crítico.

### 9.6 Relación con el resto del plan

- **No depende de P1-A**: si algún día se aprueba la fusión de anexos de clase (§2.4), la matriz no
  cambia (clasifica por patrón de destino, no por estructura interna).
- **Potencia P1-B/P2-C**: la planilla de seguimiento y los informes de mesa ya existen; la matriz solo
  les asigna destino de distribución.
- **Validación cruzada**: la matriz se prueba contra el corpus LPR vigente (98 .md, todos clasificables)
  y contra LSO al terminar su regeneración.

---

## 10. Secuencia de ejecución de los pendientes (matriz aprobada, 2026-09-22)

> **Instrucción para agentes LLM:** esta secuencia fue analizada, balanceada y aprobada con el docente.
> **NO re-analizar el orden, el alcance ni el balance**: ejecutar los ítems en este orden, uno por
> feature (con su odd doc propio). Solo el docente la modifica. Estado de base: P1-B, P2-B y P2-C ya
> implementados (feature `odd/tasks/documentos-cierre-anual.md`); P1-A declinado por ahora (§6.1).

Criterio del orden (de menor a mayor): primeros los ítems baratos y de riesgo cero que dejan el terreno
limpio (higiene de linter y bancos), después el paquete funcional de mayor impacto ya aprobado, y al
final la inversión más pesada de tokens, que necesita los dos corpus canon v2 estables. Cada paso
de-riesga el siguiente.

| # | Ítem | Qué implica | Impacto | Costo | Importancia | Viabilidad | Requiere |
|---|---|---|---|---|---|---|---|
| 1 | **P2-E** — Consistencia de soluciones en evaluaciones de momentos | Verificar y estandarizar en el corpus: base = docente, versiones A/B = alumno; paridad del principio «la solución nunca en la hoja» | Medio | Bajo (~½ sesión) | Media — cierra una regla de canon a medias | Alta — inmediata, sin dependencias | Nada |
| 2 | **P2-D** — Canonizar formato U4 sprint/mentoría + convención de supresión del linter | Sancionar en `estructura-de-la-clase.md` el reparto de los integradores; regla para el snippet defectuoso intencional; limpia los 5 ERROR del baseline | Medio | Bajo (~½ sesión) | Alta — con el linter en cero real, toda regresión futura se ve | Alta — decisión única del docente y edición de canon | **Decisión del docente** (se presenta en el paso) |
| 3 | **P3-B** — Pasada de lectura natural: fraseos v2/v3 + tabla-dominio filas D | Leer y pulir las 24 reescrituras nuevas del banco y las filas D de dominio | Bajo-medio | Bajo (1 sesión de lectura) | Media — los bancos que reutilizará P2-A quedan limpios | Alta — inmediata | Nada |
| 4 | **P1-D** — Distribución por destinatario + guías de camino | `destinos.json` + `-PorDestinatario` en el PDF + cobertura en `verificar-curso` + 3 guías de camino con plan de estudio por bloque + READMEs | **Alto** | Bajo-medio (1-2 sesiones; patrones ya probados) | **Alta** — entrega sin errores de destinatario y reingresos cubiertos | Alta — análisis aprobado | LSO regenerada (validar la matriz contra 2 corpus) |
| 5 | **P2-A** — Banco de frases estructurales + scaffolds que las emiten | Extraer las secciones estructurales repetidas a `frases-estructurales.json`; extender `scaffold-clase/evaluacion`; validar contra LPR + LSO regenerada | **Alto** (−15-20% tokens de salida por clase, uniformidad entre materias) | Medio-alto (2-3 sesiones) | Alta — la palanca de optimización más grande que queda | Media — la más invasiva de canon/tools | Los dos corpus canon v2 terminados |
| — | **P3-A** — Variante teórica de `estructura-de-la-clase.md` | Diferido por diseño | — | — | — | — | **Disparador:** la primera materia teórica que aparezca |

Notas de la secuencia:

- **Micro-tarea pegada al paso 3:** pulido cosmético de `tools/generar-cierre-anual.ps1` (4 avisos
  PSScriptAnalyzer: variables muertas `$stack`/`$entorno` en `Build-InformeMesa` y verbos `Build-*`).
- **Fuera de la matriz:** P1-A (declinado por ahora), los documentos de cierre ya implementados, y el
  link roto LAP→LPR del README del corpus (decisión del docente de no tocar output; se resuelve si ese
  README se regenera algún día).
- **Motor LaTeX para PDFs: DESCARTADO (2026-09-22, análisis de viabilidad en el acta).** El pipeline
  wkhtmltopdf cumple los lineamientos vigentes (densidad −24,3%, numeración de código, look validado)
  y la decisión es no tocar lo que funciona. Consecuencias operativas: **no instalar MiKTeX/xelatex en
  esta máquina** — el conversor elige xelatex primero si existe y el cambio sería silencioso, perdiendo
  el look y la métrica de 368 páginas. La regla «los markdown del corpus no contienen LaTeX» se mantiene
  por diseño (todo vive en conversión).
- **Lectura del orden:** los pasos 1-3 son higiene (casi gratis, sin dependencias, dejan los portones y
  bancos limpios); el paso 4 es la mayor ganancia funcional con costo moderado; el paso 5 es la mayor
  ganancia de tokens y va al final sobre base estable. Invertir el orden es factible solo renunciando a
  la higiene previa: el linter con baseline sucia hace ruido en medio del trabajo grande.
- **Numeración de código — refinamiento pendiente (2026-09-22):** verde firme (#2e7d32) sin subrayado para los números de línea. El estado vigente (verde pálido #6a9955 + subrayado, commit 66ec36d) es el único con layout validado por el docente en wkhtmltopdf 0.12.6; los intentos de refinamiento (effb6ea, aa30da9, fdee9f6) desalinearon el fondo del código por fragmentación de cajas inline en el WebKit viejo. Diagnóstico cuantificado para retomar: los fondos de `code` inline se pintan ~2,4pt a la derecha del texto y recortados ~11,5pt por la derecha; los bloques `pre` no pintan fondo en absoluto en este motor; pandoc 3.10 + numberLines emite spans por línea que disparan la fragmentación. Retomar con: post-proceso de HTML en el conversor (control total del markup, sin peleas con WebKit) o cambio de motor (descartado: §9.6-10).
