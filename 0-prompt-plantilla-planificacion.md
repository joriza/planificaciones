# Prompt plantilla — pedido de planificación anual de curso

> **Cómo usar este archivo**
> - Copiar completo el texto desde «Prompt a enviar» hasta el final del bloque **[Datos particulares]** (no copiar la «Versión en blanco» del final del archivo).
> - Documentos compañeros, cargados por referencia: la estructura anual de 36 encuentros (`@estructura-anual-36.md`), la estructura de clase (`@estructura-de-la-clase.md`) y los encuentros especiales (`@encuentros-especiales.md`).
> - Entre implementaciones solo se edita el bloque **[Datos particulares]**: ahí viven JUNTOS todos los datos que cambian de un curso a otro (tiempos, unidades, contenidos, stack, evaluación, base de datos, uso de celular, encuentros especiales, continuidad pedagógica, frenos de ejecución).
> - Para un curso nuevo hay dos caminos: editar el bloque cargado (curso Minimal API) reemplazando los valores, o copiar la **versión en blanco** del final de este archivo y completarla desde cero.
> - Todo lo anterior a ese bloque son reglas fijas del encargo y no se tocan.

## Prompt a enviar

[Datos generales]
Como docente me encuentro frecuentemente ante la necesidad de planificar las clases para todo el año.
Necesito que me prepare las clases según la plantilla @estructura-de-la-clase.md

[Canon de documentos — regla fija]
Cada regla del encargo tiene un único documento canónico, y ese documento es la única fuente de verdad de su tema: la estructura del ciclo lectivo y sus instancias (cantidad y ordinal de encuentros, unidades, evaluaciones dedicadas, recuperación y profundización, cierres) viven en @estructura-anual-36.md; el formato de cada encuentro, en @estructura-de-la-clase.md; los encuentros especiales (momentos, ubicación, destinatarios, formato, evaluaciones y nombres), en @encuentros-especiales.md. Este prompt concentra únicamente el flujo de trabajo, los formatos administrativos y los datos de cada curso. Si un texto de este prompt repitiera o contradijera a un documento canónico, prevalece el documento canónico: corríjase la repetición en este prompt, nunca al revés.

[Flujo de trabajo por fases — regla fija]
Presentados los datos de la materia, trabaje en este orden exacto. Cada freno se denomina por su fase: al llegar a un FRENO de Fase, deténgase y espere mi confirmación antes de continuar:
1. Consultas: antes de comenzar, realice todas las consultas que considere necesarias.
2. Planificación anual (documento madre): con los datos de la materia de [Datos particulares] y la estructura de @estructura-anual-36.md, arme la planificación anual por tramos según la sección [Documentos administrativos]. Es la revisión previa al trabajo que más tiempo consume: todo lo demás se deriva de ella. FRENO de Fase 2.
3. Libro de aula: derivado directo de la planificación anual (correlación exacta de encuentros, ejes y denominaciones), en sus dos versiones y sus CSV. FRENO de Fase 3.
4. Documentos de clases: genere los encuentros de unidad y las evaluaciones de los encuentros dedicados, según las reglas de estructura y respetando los frenos de fase adicionales declarados en [Datos particulares].
5. Instancias y encuentros especiales: los documentos de encuadre y cierres definidos en @estructura-anual-36.md, según la sección [Instancias del ciclo], y un documento por cada momento especial según @encuentros-especiales.md, con sus evaluaciones en versiones A y B.
6. Continuidad pedagógica: según la sección [Continuidad pedagógica] y lo declarado en [Datos particulares].
7. Cierre del repositorio: genere los criterios de aprobación y el README índice. El README debe detallar, para esta materia, la diferencia entre unidades didácticas y ejes temáticos (cuáles ejes coinciden con una unidad y cuáles son organizadores transversales) y el **orden de creación de todos los documentos** de la materia. Debe incluir también una sección de **fundamentación pedagógica del enfoque** en registro docente formal: secuenciación de prerrequisitos antes de su primer uso, reducción de la carga cognitiva, práctica distribuida de los saberes transversales, progresión GRR dentro del encuentro, ancla motivadora previa a las herramientas de infraestructura, retroalimentación oportuna y evaluación auténtica, con una tabla que asocie cada decisión de diseño con su fundamento y su referencia (Sweller, Ausubel, Rosenshine, Pearson y Gallagher, Hattie y Timperley, Johnson y Johnson, Wiggins, entre otros que refuercen el enfoque).

[Correlación con la planificación anual — regla fija]
La planificación anual es el documento madre: todos los demás documentos se derivan de ella y mantienen con ella correlación exacta — numeración de encuentros, denominaciones de unidades, ejes e instancias, tiempos y momentos de evaluación y recuperación. Si durante la creación de cualquier documento surge la necesidad de un cambio, ajuste PRIMERO la planificación anual y propague el cambio en cascada a los documentos derivados. Nunca deje documentos desalineados.

[Distribución del recurso tiempo — regla fija]
Si se le pasan horas totales del curso, son solo un dato nominal.
Los tiempos que realmente cuentan para la creación del material son las horas por encuentro y el tiempo efectivo disponible por encuentro, declarados en [Datos particulares]. La cantidad de encuentros totales y su estructura son fijas y están definidas en @estructura-anual-36.md.
En la planificación no debe quedar en evidencia ese porcentaje efectivo, pero sí debe ser tomado en cuenta para armar los contenidos. Por ello, elija una forma de rellenar los tiempos de modo que sumen el tiempo teórico: inflar el estimado de tiempos, agregar actividades complementarias explícitas, rotar integrantes en actividades grupales si el tiempo lo permite, o un mix de ellas alternando a lo largo del curso. Elija siempre la variante de apariencia más profesional y menos evidente.
Exponga tiempos teóricos en cada documento generado; nunca exponga el recorte efectivo.

[Estructura de la planificación — regla fija]
Organice la planificación según la estructura rígida del ciclo lectivo definida en @estructura-anual-36.md, que es el único canon de esa estructura: no la restate ni la reenumere.
Los encuentros del curso son las clases regulares: las únicas donde se imparte contenido nuevo a los alumnos.
Yo le pasaré los contenidos mínimos.
Todo el contenido debe generarse en una subcarpeta con un nombre acorde al curso.
Cada clase debe guardarse en un documento por separado.
Si lo considera necesario, genere otros documentos que me puedan servir como docente.

[Secuenciación de saberes — regla fija]
Todo saber que las actividades necesiten como insumo (herramientas, formatos, lenguajes, convenciones) debe enseñarse de forma explícita antes de su primer uso en clase; nunca explicarse recién en el momento en que aparece como requisito. Los saberes que funcionan como infraestructura de trabajo recurrente (por ejemplo, control de versiones, formatos de intercambio de datos o el manejo de la terminal) se incorporan entre los primeros contenidos del curso y se ejercitan como saber transversal en los encuentros siguientes, en lugar de ubicarse en la unidad que primero los exige. Antes de dar por cerrada la planificación anual, verifique la secuencia completa: ningún encuentro puede depender de un saber que aún no se enseñó; si detecta una dependencia, reordene los contenidos y propague el ajuste en cascada a los documentos derivados.

[Documentos administrativos — regla fija]
Además de los documentos de clase, genere los siguientes documentos en formato tabla:
1) Planificación anual de los encuentros: la cargaré manualmente en la plantilla que presenta cada escuela. Se arma según la estructura de @estructura-anual-36.md, con **una fila por tramo** de la estructura y Tiempo igual a la cantidad de clases del tramo (solo el número). Columnas:
   - Unidad temática (con denominación).
   - Tiempo (cantidad de clases; colocar solo el número).
   - Contenidos.
   - Expectativas de logro.
   - Actividades (especificar uso de celular).
   - TP obligatorio.
   - Técnicas/Capacidades.
   - Recursos.
   - Metodología de evaluación.
   > El uso de celular es un dato particular de cada curso: debe indicarse explícitamente en la columna Actividades tal como esté declarado en [Datos particulares] (permitido y con su finalidad didáctica, o no permitido).
2) Síntesis del plan de clases para completar el libro de aula: dos documentos, uno con 1 línea por encuentro y otro con 2 líneas por encuentro para mayor detalle (cada escuela tiene un formato diferente y lo desconozco de antemano). Ambos con las columnas:
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
   > Ambos documentos del libro de aula se generan también en versión CSV (solo la tabla), para abrir en planilla con doble clic: separador punto y coma (;), celdas que contengan punto y coma entre comillas dobles, codificación UTF-8 con BOM (acentos correctos en Excel).
   > El eje temático del libro de aula no siempre coincide con una unidad didáctica: el README debe detallar ese mapeo para la materia (regla de la Fase 2).

[Entregas por parte de los alumnos — regla fija]
Se organizarán por grupos. La matrícula y el parque informático varían durante el ciclo, por lo que la cantidad de integrantes por grupo se recalcula en cada encuentro con trabajo grupal: alumnos presentes ÷ equipos disponibles (mínimo posible), optimizando los recursos en función del alumno. Ningún equipo queda sin usar mientras haya alumnos sin equipo.

[Evaluaciones — regla fija]
Las versiones de una evaluación (por ejemplo, A y B) existen únicamente para las instancias de evaluación; las clases regulares no tienen versiones.
Las versiones deben ser equivalentes en dificultad: mismos objetivos y mismos requisitos, con distinto dominio o datos, y sin reglas que una tenga y la otra no. Esta igualdad rige para TODAS las evaluaciones (de unidad, de momentos especiales y de las instancias fuera de la planificación anual), y su propósito es que la elección de versión no otorgue ventaja ni habilite la copia entre grupos.
Cada versión debe ser un ejercicio pequeño que incluya el contenido de la unidad a evaluar; incorpore contenidos de unidades anteriores solo si es estrictamente necesario.
Cada unidad tiene un encuentro dedicado de evaluación, en el encuentro que le asigna @estructura-anual-36.md: la entrega del trabajo por GitHub y la defensa individual se realizan en ese encuentro, y el encuentro siguiente abre con su devolución.
Los momentos especiales también tienen su evaluación, en dos versiones equivalentes (A y B); sus momentos, destinatarios y criterios de calificación son los de @encuentros-especiales.md, único canon del tema.
Genere también el documento de criterios de aprobación de la asignatura (mínimos por unidad, regla de entrega incompleta y capas de recuperación), pensado para alumnos, familias y dirección.

[Encuentros especiales — regla fija]
Además de las clases regulares existen encuentros especiales de recuperación pedagógica (intensificación) y profundización (fortalecimiento). @encuentros-especiales.md es el único canon del tema: qué momentos existen (dentro y fuera de la planificación anual), su ubicación en la estructura, destinatarios, formato, evaluaciones y regla de nombres. Generación: UN documento por cada momento especial, cubriendo los encuentros que ese documento define para el momento. No imparten contenido nuevo.

[Instancias del ciclo — regla fija]
Los encuentros de encuadre y cierres definidos en @estructura-anual-36.md tienen documento propio, en carpeta separada del contenido de unidades: encuadre y diagnóstico (incluye seguridad e higiene y EPP si la institución es de modalidad técnica, dato de [Datos particulares]), cierres integradores cuatrimestrales y cierre integral de la asignatura. No imparten contenido nuevo.

[Continuidad pedagógica — regla fija]
Son actividades de repaso y fijación para que los alumnos trabajen en una clase sin presencia docente; los documentos se entregan a la administración para los casos de ausencia del docente.
La primera se basa en conocimientos previos (aún no hay temas vistos); las siguientes repasan lo visto hasta su momento de uso. La cantidad y los momentos de uso se declaran en [Datos particulares], repartiendo el contenido equitativamente a lo largo del contenido anual y ubicándolos según la estructura de @estructura-anual-36.md.
Cada documento debe contener: datos de referencia (curso, momento de uso, duración teórica, requisitos), objetivos, actividades puntuadas sobre 100 con tiempos que suman la duración teórica, autoevaluación para el alumno y anexo docente (soluciones y criterios de corrección) claramente separado.
Todo documento de continuidad debe incluir esta nota, en registro académico: la resolución se realiza en forma habitual (por lo general, en grupo); las tareas de programación requieren el uso de la computadora (omitir esta parte si el documento no tiene tareas de programación); la presentación es individual y manuscrita, al inicio de la próxima clase, y constituye una actividad más de la asignatura que forma parte del proceso de evaluación.

[Indicaciones finales — reglas fijas]
Redacte los documentos institucionales (planificación anual, libro de aula, criterios de aprobación, continuidad pedagógica y los metadatos y acuerdos de las evaluaciones) en registro docente formal; los materiales de clase dirigidos al alumno conservan el registro didáctico del curso.
Los anexos docentes (soluciones y criterios) van SIEMPRE en archivos separados con sufijo `-anexo-docente.md`, nunca dentro de los documentos que se entregan a alumnos o a administración.
Si tiene planificaciones anteriores en memoria, ignórelas; tome de la memoria únicamente lo que se declare en [Datos particulares].
Siempre que pueda, ejecute en sub-agentes para preservar el contexto principal y acelerar el proceso de creación.
Consulte todo lo que considere necesario antes de comenzar a realizar.

[Datos particulares] ← COMPLETAR EN CADA IMPLEMENTACIÓN — mantener estos campos juntos, no distribuirlos en otras secciones

(Curso, stack y contenidos mínimos)
- Tema: impartir clases de Minimal API con C# .NET 6.
- Nivel y enfoque: empezar desde cero; el alumno solo debe conocer cómo funciona una Minimal API. Es un primer acercamiento, básico, sin conceptos complicados como patrón repositorio o inyección de dependencias. En resumen: sin abstracciones.
- Conocimientos previos de los alumnos: cero C#.
- Entorno de trabajo: VS Code + terminal.
- Uso de celular: no permitido; el alumno no lo necesita para este curso.
- Evaluación: en documento por separado, 2 versiones para cada instancia de evaluación.
- Ejemplos: muy mínimos y funcionales.
- Acceso a datos: no utilice Entity Framework; utilice Dapper, que es más comprensible para quien solo ha utilizado unas pocas consultas SQL.
- Herramientas de entrega: contenidos mínimos de git y github, web y terminal. Un único repositorio por grupo para todo el curso, con una carpeta por trabajo (tp-u1, tp-u2, tp-u3, trabajo-final) y mono-rama main hasta la última unidad; el ciclo completo de entrega (gitignore en la raíz, init, commits, repo remoto, remote add, push) se enseña una sola vez en el primer encuentro con entrega y de ahí en adelante cada entrega es carpeta nueva + commits + push. La última unidad profesionaliza el mismo repositorio: README de portada, issues, ramas por feature, pull requests revisados y main protegida. Un commit con mensaje referente por cada final de encuentro o de clase sin terminar.
- Base de datos: tengo una pequeña base de datos en SQLite para utilizar en los ejemplos; se llama hospital.db.
- Restricción de archivos: busque la forma de que se toque solo Program.cs; otros archivos solo si es estrictamente necesario, de esta forma se simplifica la cantidad de archivos que debe recordar el alumno.
- Código de ejemplo: agregue una buena dosis de comentarios para que los estudiantes puedan comprender mejor las acciones del código presentado.

(Tiempo)
- Cantidad de horas por encuentro: 4.
- Tiempo efectivo disponible por encuentro: 50%.

(Institución)
- Modalidad: escuela técnica (el Encuentro 1 incluye seguridad e higiene y EPP).

(Libro de aula)
- Límite de caracteres: Tema del Día y Actividades, máximo 35 por celda (en la versión de 2 líneas, 35 por línea).

(Continuidad pedagógica)
- Cantidad y momentos: 4 documentos — el primero al inicio del curso (conocimientos previos) y uno tras la evaluación de cada una de las unidades 1 a 3 (encuentros 9, 15 y 26).

(Qué tomar de memoria)
- Únicamente las especificaciones de la base de datos (hospital.db).

(Control de este pedido)
- Frenar dentro de la Fase 4 al completar los encuentros de la unidad 1. Luego le pediré que continúe.

---

## Versión en blanco del bloque [Datos particulares]

> Para un curso nuevo: copiar este bloque, reemplazar el bloque cargado de arriba y completar cada ⟨marcador⟩.
> Borrar los campos que no apliquen al curso. No agregar datos particulares fuera de este bloque.

[Datos particulares] ← COMPLETAR EN CADA IMPLEMENTACIÓN — mantener estos campos juntos, no distribuirlos en otras secciones

(Curso, stack y contenidos mínimos)
- Tema: ⟨tema y stack del curso, p. ej. "clases de X con Y"⟩.
- Nivel y enfoque: ⟨nivel del grupo, alcance del curso y exclusiones explícitas de conceptos⟩.
- Conocimientos previos de los alumnos: ⟨punto de partida real del grupo⟩.
- Entorno de trabajo: ⟨editor + herramientas que usará el alumno⟩.
- Uso de celular: ⟨"no permitido" o "permitido" indicando su finalidad didáctica⟩.
- Evaluación: ⟨formato y cantidad de versiones por instancia de evaluación⟩.
- Ejemplos: ⟨estilo y tamaño esperado de los ejemplos de código⟩.
- Acceso a datos: ⟨tecnología de persistencia y por qué esa elección⟩ (borrar si el curso no usa datos).
- Herramientas de entrega: ⟨lo que el alumno necesita para realizar las entregas⟩.
- Base de datos: ⟨nombre y motor, si existe⟩ (borrar si no aplica).
- Restricción de archivos: ⟨límites de estructura del proyecto para el alumno⟩.
- Código de ejemplo: ⟨densidad de comentarios deseada en el código presentado⟩.

(Tiempo)
- Cantidad de horas por encuentro: ⟨H⟩.
- Tiempo efectivo disponible por encuentro: ⟨%⟩.

(Institución)
- Modalidad: ⟨técnica (seguridad e higiene y EPP en el Encuentro 1) / no técnica⟩.

(Libro de aula)
- ⟨límite de caracteres por celda/línea de Tema del Día y Actividades⟩ (borrar si no hay límite).

(Continuidad pedagógica)
- ⟨cantidad y momentos de uso⟩ (borrar si no aplica).

(Qué tomar de memoria)
- ⟨temas cuyo contexto previo sí debe recuperarse de memoria; "nada" si no hay⟩.

(Control de este pedido)
- ⟨frenos dentro de una fase (p. ej. tras la unidad X) / generar todo — y qué se pedirá después⟩.
