# Prompt plantilla — pedido de planificación anual de curso

> **Cómo usar este archivo**
> - Este prompt es el documento principal del encargo y es **autocontenido** en todo lo general: estructura fija del ciclo lectivo, momentos de intensificación y fortalecimiento, flujo de trabajo por fases y reglas fijas. No depende de documentos externos para esas cuestiones.
> - Documentos compañeros, cargados por referencia: la estructura de clase (`@input/estructura-de-la-clase.md`) — el formato de cada encuentro, que depende del tipo de materia (teórica, práctica o balanceada) y del alumnado (adolescentes, adultos) — y el archivo de la materia (`@input/materias/<materia>/materia.md`), que concentra los datos centrales que cambian con cada materia.
> - Entre implementaciones se editan tres cosas, todas fuera de este prompt: el **archivo de materia** (curso, stack, contenidos mínimos, tiempos e institución), el **curso-data** de la materia (`input/materias/<materia>/curso-data.json`: la firma pedagógica de los encuentros de unidad, validada y versionada por el docente) y el **pedido** de la materia (`input/materias/<materia>/pedido.md`: lo que cambia en cada corrida — libro de aula, continuidad, memoria y control de ejecución).
> - Para un curso nuevo: crear `input/materias/<nombre-elegido>/materia.md` desde `input/plantillas/plantilla-materia.md`, completarla, y crear `input/materias/<nombre-elegido>/pedido.md` desde `input/plantillas/plantilla-pedido.md`.
> - Estructura del repositorio: `input/materias/` concentra una subcarpeta por materia (identificador a elección del docente) con `materia.md`, `nota-catedra.md` (prosa libre, opcional) y `pedido.md` (datos particulares de corrida); `input/plantillas/` guarda los insumos deterministas compartidos (tramos invariantes con su banco de fraseos, esqueletos de unidad, filas de libro, `digest-codigo.md`); `tools/` guarda los scripts PowerShell de validación, render y verificación (`validar-curso-data.ps1`, `generar-administrativos.ps1`, `verificar-curso.ps1`, `lint-canon.ps1`). Cada curso se genera en su propia subcarpeta de `output/`, que concentra el corpus derivado de la materia (CSV administrativos, clases, evaluaciones y README índice); la firma pedagógica (`curso-data.json`) y la hoja de convenciones técnicas viven con la materia en `input/materias/<materia>/`.
> - Las evaluaciones de la asignatura son exclusivamente una por unidad didáctica y una por cada momento de intensificación y fortalecimiento. No existen evaluaciones cuatrimestrales ni de cierre: los encuentros de cierre (16, 33 y 36) son de síntesis, integración y metacognición.

## Prompt a enviar

[Datos generales]
Como docente me encuentro frecuentemente ante la necesidad de planificar las clases para todo el año.
Necesito que me prepare las clases según la plantilla @input/estructura-de-la-clase.md

[Canon de documentos — regla fija]
Cada regla del encargo tiene un único documento canónico, y ese documento es la única fuente de verdad de su tema: la estructura del ciclo lectivo y sus encuentros, los momentos de intensificación y fortalecimiento, el flujo de trabajo, los formatos administrativos y las reglas de evaluación viven en **este mismo prompt**; el formato de cada encuentro, en `@input/estructura-de-la-clase.md`; los datos centrales del curso (stack, contenidos mínimos, tiempos, institución), en el archivo de materia declarado en [Datos particulares]; la firma pedagógica de los encuentros de unidad (eje, carácter, tema, tiempos y TP de cada uno, más los slots globales), en el curso-data de la materia (`input/materias/<materia>/curso-data.json`); los insumos invariantes entre materias (tramos administrativos, banco de fraseos, esqueletos, filas de libro y digest de código), en `input/plantillas/`. Si un texto de este prompt o de un documento canónico repitiera o contradijera a otro, prevalece el canon de su tema y se corrige la repetición en el documento derivado, nunca al revés. Cuando el archivo de materia declare una hoja de convenciones técnicas del curso, esa hoja es, además, el canon de tipos, formatos y estructura del código: toda divergencia con ella es un defecto.

[Estructura del ciclo lectivo — regla fija]
La estructura del ciclo es **rígida**: 36 encuentros teóricos, 18 por cuatrimestre. Es el diseño teórico que se presenta formalmente; los eventos del calendario real pueden reducir las clases efectivas, lo cual nunca se expone en los documentos generados.

| Encuentros | Instancia | Observaciones |
|---|---|---|
| 1 | **Encuadre y diagnóstico de saberes previos** | Presentación de la asignatura y contrato pedagógico. Si la institución es de modalidad técnica (dato del archivo de materia), incluye seguridad e higiene y elementos de protección personal (EPP). |
| 2 a 3 | **Intensificación y fortalecimiento de saberes previos** | Primera instancia: nivelación sobre lo que el grupo trae. |
| 4 a 8 | **Unidad didáctica 1** | Cinco encuentros, con sistematización, consolidación y cierre de la unidad integrados. |
| 9 | **Evaluación de la Unidad 1** | Encuentro dedicado. |
| 10 a 14 | **Unidad didáctica 2** | Ídem Unidad 1. |
| 15 | **Evaluación de la Unidad 2** | Encuentro dedicado. |
| 16 | **Cierre integrador del cuatrimestre 1** | Síntesis, integración y metacognición del cuatrimestre. Sin evaluación propia. |
| 17 a 18 | **Intensificación y fortalecimiento de las Unidades 1 y 2 — primera instancia** | Núcleos de ambas unidades. |
| 19 a 20 | **Momento integrador de las Unidades 1 y 2 (proyecto puente)** | Proyecto puente que integra ambas unidades. No es redundante: es progresión. |
| 21 a 25 | **Unidad didáctica 3** | Con sistematización, consolidación y cierre. |
| 26 | **Evaluación de la Unidad 3** | Encuentro dedicado. |
| 27 a 31 | **Unidad didáctica 4** | Con sistematización, consolidación y cierre. |
| 32 | **Evaluación de la Unidad 4** | Encuentro dedicado: defensa del trabajo integrador. |
| 33 | **Cierre integrador del cuatrimestre 2** | Síntesis, integración y metacognición anual. Sin evaluación propia. |
| 34 a 35 | **Intensificación y fortalecimiento de las Unidades 3 y 4** | Núcleos e integración de ambas unidades. |
| 36 | **Cierre integral de la asignatura** | Balance, metacognición y proyección. Sin evaluación propia. |

Reglas de la estructura:
- El número de cada encuentro es su **ordinal** y no se renumera por eventos del calendario.
- **Cuatro unidades didácticas** de 5 encuentros cada una, con un encuentro **dedicado** de evaluación después de cada una (9, 15, 26 y 32). Esas cuatro evaluaciones son las únicas evaluaciones de unidad: no existen evaluaciones cuatrimestrales ni de cierre.
- Los **momentos de intensificación** (objetivos mínimos no alcanzados) y **fortalecimiento** (extensión de lo adquirido) ocupan los encuentros 2-3, 17-20 y 34-35.
- Los **cierres integradores cuatrimestrales** (16 y 33) y el **cierre integral** (36) son encuentros de síntesis, integración y metacognición: no imparten contenido nuevo ni tienen evaluación propia.
- La inclusión de **seguridad e higiene y EPP** en el Encuentro 1 depende de la modalidad de la institución, declarada en el archivo de materia.
- El total (36) y esta estructura son fijos: se presentan siempre como diseño teórico, sin exponer el recorte efectivo real del calendario.

[Momentos de intensificación y fortalecimiento — regla fija]
Además de las **clases regulares** existen momentos de **intensificación** (recuperación pedagógica: objetivos mínimos no alcanzados) y **fortalecimiento** (profundización: extensión de lo adquirido). **No imparten contenido nuevo.** Su ubicación y cantidad están fijadas por la sección [Estructura del ciclo lectivo].

Organización de los documentos: se genera **UN documento por cada momento** de la estructura anual, cubriendo los 2 encuentros del momento, en la carpeta `intensificaciones` del curso:

| Momento | Encuentros | Alcance |
|---|---|---|
| Saberes previos | 2-3 | Intensificación y fortalecimiento de previos, según el diagnóstico del Encuentro 1 |
| Unidades 1 y 2 — primera instancia | 17-18 | Pistas diferenciadas por condición |
| Unidades 1 y 2 — momento integrador (proyecto puente) | 19-20 | Para todo el curso, sin diferenciación |
| Unidades 3 y 4 | 34-35 | Pistas diferenciadas por condición |

**Regla de nombres:** el nombre de cada documento debe referenciar su momento y, a la vez, ordenarse alfabéticamente en orden de uso (prefijo numérico `intensificaciones-NN-NN-` para los momentos dentro de la estructura anual).

Existen dos momentos adicionales de intensificación, **fuera de la estructura anual de 36 encuentros**, solo para alumnos que no lograron los objetivos mínimos. Sus nombres son referenciales y ordenan alfabéticamente después de los numéricos, en orden de uso:

| Momento | Cuándo | Destinatarios |
|---|---|---|
| `intensificaciones-diciembre-intensificacion.md` | Diciembre, finalizada la cursada | Quienes no alcanzaron los objetivos mínimos en el ciclo |
| `intensificaciones-marzo-intensificacion.md` | Marzo, antes del nuevo ciclo | Quienes no alcanzaron en diciembre y tuvieron más tiempo para prepararse |

El estándar de marzo es idéntico al de diciembre: no baja; cambia cuánto tiempo tuvo el alumno para prepararlo.

**Evaluaciones de los momentos:** todos los momentos tienen su evaluación, en versiones equivalentes (A/B/C/D; mínimo dos según los grupos), en la carpeta de evaluaciones de los momentos del curso (ver README). Las evaluaciones de intensificación usan criterio **Apto / No apto aún por objetivo mínimo**; la del momento integrador (proyecto puente) usa rúbrica de 100 puntos. Las instancias de diciembre y marzo evalúan el camino mínimo completo del curso.

**Formato de los documentos:** cada documento de momento contiene: metadatos (momento de uso, duración, destinatarios, requisitos, lugar de trabajo), el **acuerdo pedagógico**, el desarrollo de sus 2 encuentros (agenda con tiempos teóricos) y los criterios de logro.

El **acuerdo pedagógico** se documenta por grupo de condición, en formato tabla:

**Grupo de intensificación (recuperación pedagógica):**
- Contenidos mínimos irrenunciables.
- Actividad y/o metodología acordada (ultra-condensada).
- Recursos acordados (condensado al 25%).

**Grupo de fortalecimiento (profundización):**
- Contenidos de fortalecimiento (ampliación sobre los contenidos regulares, sin adelantar unidades siguientes).
- Actividad y/o metodología acordada (ultra-condensada).
- Recursos acordados (condensado al 25%).

En los momentos diferenciados, cada encuentro desarrolla las **dos pistas en paralelo** (con plenarias conjuntas de apertura y cierre); en el momento integrador (19-20) hay una única pista para todo el curso.

[Flujo de trabajo por fases — regla fija]
Presentados los datos de la materia, trabaje en esta cascada data-first, en el orden exacto. La corrida es **continua por defecto**: no se detenga a esperar confirmación. Aplique frenos SOLO si el pedido de la materia o la orden de ejecución los declaran explícitamente (p. ej. «frenar tras la Fase 0»), o si corresponde el freno por defecto del modo materia nueva (pausa tras el curso-data validado, ver [Modos de trabajo]). Antes de comenzar, realice todas las consultas que considere necesarias.
1. Fase 0 — Curso-data (única autoría LLM de la firma pedagógica): redacte `input/materias/<materia>/curso-data.json` UNA sola vez, a partir del archivo de materia, del bloque [Datos particulares] y de la sección [Estructura del ciclo lectivo]: los 20 encuentros de unidad (4-8, 10-14, 21-25 y 27-31) con su eje, carácter, tema, tiempos y TP, más los slots globales (celular, recursos, TPs, denominaciones, ejes). Es la revisión previa al trabajo que más tiempo consume: todo lo demás se deriva de ella. Los 12 tramos invariantes del ciclo NO se redactan: viven en `input/plantillas/`. Si el JSON ya existe y está vigente, no lo re-redacte: valídelo y utilícelo. Controle el resultado con `powershell -File tools/validar-curso-data.ps1 -Materia input/materias/<materia>`. Si la materia tiene código, en esta fase redacte también `input/materias/<materia>/convenciones-tecnicas.md` a partir de `input/plantillas/plantilla-convenciones-tecnicas.md`, del archivo de materia y de la documentación de la base: cada regla de tipos, mapeo o respuestas se verifica con un spike de verificación (proyecto descartable con el stack: compilar y ejecutar los casos límite contra la fuente de datos real). Si la hoja ya existe y está vigente, no se re-redacta. El JSON y la hoja de convenciones quedan bajo propiedad del docente, versionados en git: usted no los re-escribe; un curso nuevo arranca del JSON vigente como plantilla.
2. Fase 1 — Administrativos (render determinista, cero LLM): genere los tres administrativos SOLO CSV con `powershell -File tools/generar-administrativos.ps1 -Materia input/materias/<materia> -Salida output/<materia>/01-planificacion` (si la materia declara horas por encuentro distintas de 4 en la ficha: agregar `-HorasPorEncuentro <h>`): `planificacion-anual.csv` (los 4 tramos de unidad compuestos desde el JSON y los 12 tramos invariantes desde `input/plantillas/`), `libro-de-aula-1-linea-por-encuentro.csv` y `libro-de-aula-2-lineas-por-encuentro.csv`. Los administrativos son solo CSV: no hay vistas en Markdown.

**Parada de administrativos (materia nueva):** si esta corrida redactó el curso-data en la Fase 0, FRENE al terminar la Fase 1: presente la anual y los dos libros de aula al docente para su revisión contra la plantilla institucional de la escuela, con el reporte de freno de la sección siguiente. Todo ajuste entra por el curso-data (validar y re-renderizar los administrativos); la Fase 2 continúa solo con la confirmación explícita del docente. Esta parada no existe en regeneración completa ni en actualización: la firma ya fue revisada por el docente.

3. Fase 2 — Prosa viva (un writer por carpeta): genere en paralelo las clases de los encuentros de unidad según las reglas de estructura, los documentos de encuadre y cierres del ciclo según la sección [Encuadre y cierres del ciclo], un documento por cada momento de intensificación y fortalecimiento según la sección [Momentos de intensificación y fortalecimiento], y la continuidad pedagógica según la sección [Continuidad pedagógica] y lo declarado en [Datos particulares], aplicando solo los frenos declarados explícitamente en el pedido o en la orden. Cada writer recibe SOLO: el slice de curso-data de SUS encuentros de unidad (sub-especificación embebida en el encargo, nunca el JSON completo), `input/plantillas/digest-codigo.md` si produce código, la hoja de convenciones técnicas declarada en el archivo de materia (leerla PRIMERO, es canon: toda divergencia es un defecto) y la referencia `@input/estructura-de-la-clase.md`; nunca el canon completo.
4. Fase 3 — Evaluaciones: una por cada unidad didáctica (en su encuentro dedicado) y una por cada momento de intensificación y fortalecimiento, según las secciones [Evaluaciones] y [Momentos de intensificación y fortalecimiento]: consigna maestra y versiones equivalentes.
5. Fase 4 — Cierre del repositorio y verificación: genere los criterios de aprobación, el README índice y los documentos de cierre del ciclo con `powershell -File tools/generar-cierre-anual.ps1 -Materia input/materias/<materia> -Salida output/<materia>/07-cierre-anual` (sección [Seguimiento y cierre del ciclo — regla fija]). El README debe detallar, para esta materia, la diferencia entre unidades didácticas y ejes temáticos (cuáles ejes coinciden con una unidad y cuáles son organizadores transversales) y el **orden de creación de todos los documentos** de la materia. Debe incluir también una sección de **fundamentación pedagógica del enfoque** en registro docente formal: secuenciación de prerrequisitos antes de su primer uso, reducción de la carga cognitiva, práctica distribuida de los saberes transversales, progresión GRR dentro del encuentro, ancla motivadora previa a las herramientas de infraestructura, retroalimentación oportuna y evaluación auténtica, con una tabla que asocie cada decisión de diseño con su fundamento y su referencia (Sweller, Ausubel, Rosenshine, Pearson y Gallagher, Hattie y Timperley, Johnson y Johnson, Wiggins, entre otros que refuercen el enfoque). Cierre con la verificación completa del corpus: `powershell -File tools/verificar-curso.ps1` y `powershell -File tools/lint-canon.ps1`, corrigiendo todo hallazgo antes de dar el curso por terminado.

**Reporte de freno (regla fija):** toda parada de esta cascada — la de Fase 0, la de administrativos y las que el pedido declare — se presenta al docente con: (1) síntesis de lo hecho y artefactos con su estado de verificación; (2) toda modificación realizada fuera del flujo canónico, con su motivo; (3) hallazgos con propuesta de tratamiento; (4) decisiones pendientes que requieren al docente; y (5) las formas de continuar. Sin ese reporte la parada no está completa.

[Modos de trabajo: corrida, regeneración y actualización — regla fija]
El modo de ejecución se deriva del estado del repositorio; solo se declara cuando pisa el modo derivado. Detección determinista, en este orden:
- **Materia nueva** — no existe `input/materias/<materia>/curso-data.json`: la cascada entera de la sección [Flujo de trabajo por fases], Fase 0 → 4, con la Fase 0 redactada desde cero. **Freno por defecto de este modo**: pausar tras el curso-data validado — apenas `curso-data.json` pasa `tools/validar-curso-data.ps1`, el docente revisa la firma y define cómo continuar; la hoja de convenciones y la cascada siguen tras la reanudación. Este modo tiene además una segunda parada por defecto al cerrar la Fase 1 (administrativos renderizados): ver [Flujo de trabajo por fases].
- **Regeneración completa** — existe el curso-data pero no `output/<materia>/`: la firma y la hoja son del docente y se reusan tal cual (validar sin re-redactar); todo el corpus se renderiza de nuevo. Corrida continua.
- **Actualización** — existe el curso-data y `output/<materia>/` está vigente: nada vigente se re-escribe desde cero; el cambio entra por los datos y alcanza solo a lo afectado. Corrida continua. Flujo:
  1. Edite el curso-data (`input/materias/<materia>/curso-data.json`) o el canon (`input/plantillas/`, este prompt, `input/estructura-de-la-clase.md`); nunca los derivados directamente.
  2. Valide con `powershell -File tools/validar-curso-data.ps1 -Materia input/materias/<materia>`.
  3. Ejecute `powershell -File tools/impacto.ps1 -Materia input/materias/<materia>`: produce el plan de regeneración en tres listas — (a) derivados a re-renderizar (SIEMPRE todos: los 3 CSV administrativos y el README, por generadores idempotentes), (b) prosa afectada por el diff (sus clases/evaluaciones/cierres, cada archivo con su motivo) y (c) intocado (nadie lo abre). Registre el plan resultante en el documento de seguimiento de la feature (odd doc), para que quede auditable.
  4. Re-renderice los derivados (lista (a): siempre todos; es automático y de costo cero).
  5. El LLM toca SOLO los archivos de la lista (b), con su motivo como guía; la lista (c) no se abre ni se re-lee.

  No hay cachés de hashes: la lista (b) sale del diff git del curso-data más la versión del canon, corrida a corrida. Si el curso-data no tiene versión previa en git, la actualización se comporta como regeneración completa.

[Correlación con la planificación anual — regla fija]
La planificación anual es el documento madre del corpus: todos los demás documentos se derivan de ella y mantienen con ella correlación exacta — numeración de encuentros, denominaciones de unidades, ejes e instancias, tiempos y momentos de evaluación y recuperación. Su fuente es el curso-data: la anual y el libro de aula son renders de `input/materias/<materia>/curso-data.json` más las plantillas. Si durante la creación de cualquier documento surge la necesidad de un cambio, ajuste PRIMERO el curso-data, valídelo con `tools/validar-curso-data.ps1`, re-renderice los administrativos afectados y propague el cambio en cascada a los documentos derivados. Nunca deje documentos desalineados y nunca corrija a mano un CSV renderizado: el cambio se hace en el JSON.

[Distribución del recurso tiempo — regla fija]
Si se le pasan horas totales del curso, son solo un dato nominal.
Los tiempos que realmente cuentan para la creación del material son las horas por encuentro y el tiempo efectivo disponible por encuentro, declarados en el archivo de materia. La cantidad de encuentros totales y su estructura son fijas y están definidas en la sección [Estructura del ciclo lectivo].
En la planificación no debe figurar ese factor de eficacia en ningún documento generado: queda como estimado implícito de planificación. Por ello, concilie ambos tiempos de modo que cada bloque declare actividades reales que justifiquen su duración: actividades de extensión y consolidación explícitas para quienes completan la consigna base (variante preferida), estimaciones por bloque ajustadas al grupo, rotación de integrantes en actividades grupales, o un mix de ellas alternando a lo largo del curso. Elija siempre la variante más defendible ante una revisión formal: cada tiempo declarado debe corresponder a una actividad prevista.
Exponga tiempos teóricos en cada documento generado.

[Estructura de la planificación — regla fija]
Organice la planificación según la estructura rígida del ciclo lectivo definida en la sección [Estructura del ciclo lectivo], que es el único canon de esa estructura: no la restate ni la reenumere.
Los encuentros del curso son las clases regulares: las únicas donde se imparte contenido nuevo a los alumnos.
Yo le pasaré los contenidos mínimos (en el archivo de materia).
Todo el contenido debe generarse en la carpeta del curso (declarada en [Datos particulares]).
Cada clase debe guardarse en un documento por separado.
Si lo considera necesario, genere otros documentos que me puedan servir como docente.

[Secuenciación de saberes — regla fija]
Todo saber que las actividades necesiten como insumo (herramientas, formatos, lenguajes, convenciones) debe enseñarse de forma explícita antes de su primer uso en clase; nunca explicarse recién en el momento en que aparece como requisito. Los saberes que funcionan como infraestructura de trabajo recurrente (por ejemplo, control de versiones, formatos de intercambio de datos o el manejo de la terminal) se incorporan entre los primeros contenidos del curso y se ejercitan como saber transversal en los encuentros siguientes, en lugar de ubicarse en la unidad que primero los exige. Antes de dar por cerrado el curso-data (Fase 0), verifique la secuencia completa: ningún encuentro puede depender de un saber que aún no se enseñó; si detecta una dependencia, reordene los contenidos en el JSON y propague el ajuste en cascada a los documentos derivados.

[Documentos administrativos — regla fija]
Los administrativos son SOLO CSV y no se redactan con LLM: se renderizan con `tools/generar-administrativos.ps1` (Fase 1) desde el curso-data y las plantillas. Sus contenidos son:
1) `planificacion-anual.csv` — Planificación anual de los encuentros: la cargaré manualmente en la plantilla que presenta cada escuela. Se arma según la sección [Estructura del ciclo lectivo], con **una fila por tramo** de la estructura y Tiempo igual a la cantidad de clases del tramo (solo el número). Composición: los 4 tramos de unidad se componen desde los 5 encuentros de unidad del curso-data; los 12 tramos invariantes salen de `input/plantillas/tramos-invariantes.json` con su banco de fraseos (variante `varianteFraseos` del JSON). Columnas:
   - Unidad temática (con denominación).
   - Tiempo (cantidad de clases; colocar solo el número).
   - Contenidos.
   - Expectativas de logro.
   - Actividades (especificar uso de celular).
   - TP obligatorio.
   - Técnicas/Capacidades.
   - Recursos.
   - Metodología de evaluación.
   > El uso de celular es un dato particular de cada curso: debe indicarse explícitamente en la columna Actividades tal como esté declarado en el archivo de materia (permitido y con su finalidad didáctica, o no permitido).
2) `libro-de-aula-1-linea-por-encuentro.csv` y `libro-de-aula-2-lineas-por-encuentro.csv` — Síntesis del plan de clases para completar el libro de aula: uno con 1 línea por encuentro y otro con 2 líneas por encuentro para mayor detalle (cada escuela tiene un formato diferente y lo desconozco de antemano). Cada fila sale del encuentro correspondiente del curso-data (eje, carácter, tema y actividades). Ambos con las columnas:
   - Nº Clase: secuencia numérica correspondiente.
   - Eje Temático: nombre del eje temático.
   - Nº Eje: identificador del eje temático.
    - Carácter/Objetivo: selección obligatoria del listado técnico adjunto.
    > La columna Carácter/Objetivo consigna el carácter dominante del encuentro; las dimensiones conceptual, procedimental y actitudinal se integran en todo encuentro. Auditada la asignatura, reasigne el carácter únicamente donde otra dimensión resulte pedagógicamente defendible como dominante (por ejemplo, encuentros cuyo clímax es la exposición o la defensa oral del trabajo propio), sin aplicar cuotas de alternancia artificiales.
   - Tema del Día: descripción sintética del contenido.
   - Actividades: detalle de las acciones pedagógicas a desarrollar.
   - Fecha: no estimar; la colocará el docente manualmente.
   - Material: no estimar; la colocará el docente manualmente.
   > Si [Datos particulares] declara un límite de caracteres para alguna columna del libro de aula, el contenido debe redactarse dentro de ese límite (estilo telegráfico si hace falta).
   > Formato de los tres CSV: solo la tabla, separador punto y coma (;), celdas que contengan punto y coma entre comillas dobles, codificación UTF-8 con BOM (acentos correctos en Excel). No se generan vistas .md de los administrativos.
   > El eje temático del libro de aula no siempre coincide con una unidad didáctica (el mapeo vive en `slots.ejes` del curso-data): el README debe detallarlo para la materia (regla de la Fase 4).

[Entregas por parte de los alumnos — regla fija]
Se organizarán por grupos. La matrícula y el parque informático varían durante el ciclo, por lo que la cantidad de integrantes por grupo se recalcula en cada encuentro con trabajo grupal: alumnos presentes ÷ equipos disponibles (mínimo posible), optimizando los recursos en función del alumno. Ningún equipo queda sin usar mientras haya alumnos sin equipo.

[Evaluaciones — regla fija]
Las evaluaciones de la asignatura son **exclusivamente**:
1. **Una por cada unidad didáctica**, en su encuentro dedicado (9, 15, 26 y 32): la entrega del trabajo por GitHub y la defensa individual se realizan en ese encuentro, y el encuentro siguiente abre con su devolución.
2. **Una por cada momento de intensificación y fortalecimiento** (incluidos diciembre y marzo, fuera de la planificación anual), con los criterios de la sección [Momentos de intensificación y fortalecimiento].
No existen evaluaciones cuatrimestrales ni de cierre: los encuentros 16, 33 y 36 son cierres de síntesis, integración y metacognición, sin evaluación propia.
Las versiones de una evaluación (A/B/C/D; mínimo dos según los grupos) existen únicamente para esas evaluaciones; las clases regulares no tienen versiones.
Las versiones deben ser equivalentes en dificultad: mismos objetivos y mismos requisitos, con distinto dominio o datos, y sin reglas que una tenga y la otra no. Esta igualdad rige para TODAS las evaluaciones (de unidad y de momentos), y su propósito es que la elección de versión no otorgue ventaja ni habilite la copia entre grupos.
Cada versión debe ser un ejercicio pequeño que incluya el contenido de la unidad a evaluar; incorpore contenidos de unidades anteriores solo si es estrictamente necesario.
Cada evaluación se genera en documento por separado de las clases.
Genere también el documento de criterios de aprobación de la asignatura (mínimos por unidad, regla de entrega incompleta y capas de recuperación), pensado para alumnos, familias y dirección.

[Encuadre y cierres del ciclo — regla fija]
Los encuentros de encuadre y cierres definidos en la sección [Estructura del ciclo lectivo] (1, 16, 33 y 36) tienen documento propio, en carpeta separada del contenido de unidades: encuadre y diagnóstico (incluye seguridad e higiene y EPP si la institución es de modalidad técnica, dato del archivo de materia), cierres integradores cuatrimestrales y cierre integral de la asignatura. No imparten contenido nuevo ni tienen evaluación propia.

[Continuidad pedagógica — regla fija]
Son actividades de repaso y fijación para que los alumnos trabajen en una clase sin presencia docente; los documentos se entregan a la administración para los casos de ausencia del docente.
La primera se basa en conocimientos previos (aún no hay temas vistos); las siguientes repasan lo visto hasta su momento de uso. La cantidad y los momentos de uso se declaran en [Datos particulares], repartiendo el contenido equitativamente a lo largo del contenido anual y ubicándolos según la estructura de la sección [Estructura del ciclo lectivo].
Cada documento debe contener: datos de referencia (curso, momento de uso, duración teórica, requisitos), objetivos, actividades puntuadas sobre 100 con tiempos que suman la duración teórica, autoevaluación para el alumno y anexo docente (soluciones y criterios de corrección) claramente separado.
Todo documento de continuidad debe incluir esta nota, en registro académico: la resolución se realiza en forma habitual (por lo general, en grupo); las tareas de programación requieren el uso de la computadora (omitir esta parte si el documento no tiene tareas de programación); la presentación es individual y manuscrita, al inicio de la próxima clase, y constituye una actividad más de la asignatura que forma parte del proceso de evaluación.

[Seguimiento y cierre del ciclo — regla fija]
El ciclo se cierra con tres tipos de documentos derivados, generados en la Fase 4 con `tools/generar-cierre-anual.ps1` (render determinista, cero LLM), en la carpeta `07-cierre-anual/` del curso:
1) `seguimiento-anual.csv` — planilla de seguimiento del docente: una fila por encuentro (36) más las mesas de diciembre y marzo (filas D y M), con Nº, Instancia, Eje temático y Tema del día derivados del curso-data y de las filas invariantes; Fecha, TPs entregados, Defensas/Resultados y Observaciones quedan a cargo del docente.
2) `memoria-anual.md` — memoria anual de cátedra en registro docente formal: datos de referencia, desarrollo efectivo del ciclo, resultados por instancia, trabajos prácticos, continuidad pedagógica, intensificación y fortalecimiento, balance y ajustes propuestos, y firma. El análisis lo escribe el docente al cierre del ciclo; los ajustes que surjan entran por el curso-data y se re-deriva el corpus.
3) `informe-mesa-diciembre.md` e `informe-mesa-marzo.md` — informes formales de las mesas (fuera de la estructura anual): datos de la mesa, destinatarios, alcance evaluado (camino mínimo por unidad y TPs), metodología (criterio Apto / No apto aún por objetivo mínimo; el estándar de marzo es idéntico al de diciembre), instrumento (versiones A/B del corpus) y resultados, a cargo del docente.
Regla de propiedad: estos documentos se generan SOLO si no existen (`-Force` para sobrescribir). Una vez creados son del docente: el modo actualización jamás los regenera; la regeneración completa los re-crea vacíos.

[Indicaciones finales — reglas fijas]
Redacte los documentos institucionales (planificación anual, libro de aula, criterios de aprobación, continuidad pedagógica y los metadatos y acuerdos de las evaluaciones) en registro docente formal; los materiales de clase dirigidos al alumno conservan el registro didáctico del curso.
Los anexos docentes (soluciones y criterios) van SIEMPRE en archivos separados con sufijo `-anexo-docente.md`, nunca dentro de los documentos que se entregan a alumnos o a administración.
Si tiene planificaciones anteriores en memoria, ignórelas; tome de la memoria únicamente lo que se declare en [Datos particulares].
Siempre que pueda, ejecute en sub-agentes para preservar el contexto principal y acelerar el proceso de creación. Dieta de contexto de cada writer: recibe solo el slice de curso-data de sus encuentros (nunca el JSON completo), `input/plantillas/digest-codigo.md` si produce código, la hoja de convenciones técnicas declarada en el archivo de materia (leerla PRIMERO, es canon: toda divergencia es un defecto) y la referencia de `@input/estructura-de-la-clase.md`; nunca el canon completo. Reporte compacto obligatorio de cada subagente: máximo 15 líneas — archivos escritos, verificaciones ejecutadas (comando y resultado), desvíos del encargo y uso de tokens si lo conoce; sin prosa narrativa.
Consulte todo lo que considere necesario antes de comenzar a realizar.

[Datos particulares] ← carga por referencia — este prompt NO se edita por materia

El identificador de la materia —el nombre de su carpeta en `input/materias/`— se declara en la orden de ejecución (p. ej.: «genere la documentación de la materia LPR»). Todas las rutas se derivan de él, sin editar este archivo:
- Ficha de la materia: `@input/materias/<materia>/materia.md` (curso, stack, contenidos mínimos, tiempos e institución).
- Curso-data: `input/materias/<materia>/curso-data.json` (si existe y está vigente: validarlo y reutilizarlo, no re-redactarlo). Si existiera además un `curso-data.json` en `output/<materia>/`, es un duplicado involuntario: **vale siempre el de `input/materias/`** (canon del plan de trabajo); la corrida lo reporta como hallazgo y sugiere eliminar el duplicado, pero nunca lo borra automáticamente.
- Pedido particular: `@input/materias/<materia>/pedido.md` — sus secciones (Libro de aula, Continuidad pedagógica, Qué tomar de memoria, Control de este pedido) SON el bloque [Datos particulares] de esta corrida y mandan sobre los valores por defecto. Si no existe, crearlo desde `input/plantillas/plantilla-pedido.md` junto al docente antes de continuar.
- Carpeta del curso: `output/<materia>/`.
- Convenciones técnicas: la ruta declarada en la ficha (materias con código); la Fase 0 la redacta y verifica con spike si no existe.

---

## Versión en blanco del bloque [Datos particulares]

La versión en blanco del pedido vive en input/plantillas/plantilla-pedido.md.
