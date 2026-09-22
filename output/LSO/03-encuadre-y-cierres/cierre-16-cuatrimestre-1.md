# Cierre 16 — Cierre integrador del cuatrimestre 1

| Campo | Valor |
|---|---|
| Encuentro | 16 de 36 |
| Tipo | Cierre integrador del cuatrimestre 1 — Síntesis e integración de U1+U2, metacognición |
| Duración | 240 min |
| Requisitos | Proyector, hojas impresas para actividades de síntesis, bolígrafos |
| Materiales | Slide de síntesis U1+U2, mapa conceptual en blanco, hoja de metacognición |
| Uso de celular | No permitido |

## Objetivos de aprendizaje

1. Sintetizar e integrar los contenidos de U1 (Fundamentos de C# y Minimal API) y U2 (Acceso a datos con SQLite y Dapper).
2. Desarrollar metacognición sobre el propio proceso de aprendizaje durante el primer cuatrimestre.
3. Identificar conexiones entre los conocimientos de los dos primeros cuatrimestres y reconocer cómo se articulan.
4. Evaluar de manera reflexiva las propias fortalezas y áreas de mejora sin generación de nota.

## Agenda

### Bloque 1 — Charla rápida / Bridge-in (5 min)

**Analogía:** Pensá en U1 y U2 como dos estaciones de un mismo viaje: en la primera aprendiste a armar el vehículo (la API mínima) y en la segunda aprendiste a cargarlo y transportar datos (la base de datos). Sin las dos estaciones, el viaje no completo. Este encuentro es el momento de mirar el mapa completo del recorrido que hiciste hasta ahora.

**Actividad (voseo):** El docente proyecta un mapa de camino con dos estaciones señaladas y pregunta: "¿Qué recuerdan del viaje hasta ahora?" Se toman 3-4 respuestas voluntarias. Se las conecta con los bloques teóricos que siguen.

### Bloque 2 — Objetivos de síntesis (5 min)

El docente presenta los objetivos del cierre: repasar U1 y U2, conectar ambos mundos (código sin base de datos → código con base de datos), y reflexionar sobre el propio aprendizaje. Se aclara que este encuentro no introduce contenido nuevo ni tiene evaluación propia.

### Bloque 3 — Síntesis e integración U1+U2 (50 min)

**Teoría mínima (25 min):**
El docente guía un repaso estructurado de los ejes de U1 y U2. De U1 se revisan: la estructura de un proyecto Minimal API (`Program.cs`, top-level statements, `WebApplication`), los verbos HTTP (`MapGet`, `MapPost`, `MapPut`, `MapDelete`), los códigos de respuesta (200, 201, 204, 400, 404) y la separación entre lógica de negocio y respuesta HTTP. De U2 se revisan: la conexión a SQLite (`Data Source=hospital.db`), las consultas parametrizadas con Dapper (`Query<T>`, `QueryFirstOrDefault<T>`, `Execute`, `ExecuteScalar<long>`), el mapeo de tipos (INTEGER → `long`, TEXT → `string`, nullable → `string?`/`long?`) y el uso de alias `AS` en los SELECT.

Se enfatiza la conexión entre ambas unidades: U1 construye la API sin base de datos (endpoints que devuelven datos en memoria) y U2 le agrega persistencia conectando esa misma API a `hospital.db`. El docente muestra cómo un endpoint `MapGet` de U1 se transforma en un endpoint que consulta la base de datos con Dapper en U2.

**Práctica guiada (25 min):**
Los alumnos, organizados en grupos de a presentes ÷ equipos disponibles, reciben un diagrama de flujo en blanco que muestra el recorrido de una petición HTTP: desde que el cliente envía la petición hasta que la API responde. Cada grupo completa el diagrama agregando los elementos de U1 (ruta, verbo, handler) y los elementos de U2 (conexión a BD, consulta parametrizada, mapeo de resultados). Se comparte en plenario y el docente compara los diagramas de cada grupo.

### Bloque 4 — Práctica guiada: actividad de integración (45 min)

**Actividad (voseo):** El docente presenta un escenario: "Tenés una API que devuelve una lista de pacientes en memoria (U1). Ahora querés que esa lista venga de la base de datos `hospital.db` usando Dapper (U2)." Los alumnos, en grupos de a presentes ÷ equipos disponibles, trabajan en una hoja de trabajo que tiene dos columnas: "Lo que ya sé de U1" y "Lo que necesito agregar de U2". Cada grupo completa ambas columnas y luego comparte con otro grupo. El docente circula y orienta.

Se revisan en plenario las conexiones más importantes entre U1 y U2: cómo se construye el endpoint en U1 y cómo se modifica para que consulte la base en U2, sin cambiar la estructura general del archivo `Program.cs`.

### Bloque 5 — Ejercicio independiente: metacognición (35 min)

**Actividad (voseo):** Cada alumno completa de manera individual una hoja de metacognición con las siguientes preguntas: (1) ¿Qué concepto de U1 o U2 me costó más entender y por qué? (2) ¿Qué conexión entre U1 y U2 me pareció más importante? (3) ¿Qué habilidad nueva desarrollé en este cuatrimestre que no tenía antes? (4) ¿Qué estrategia de estudio me funcionó mejor? Las respuestas se entregan al docente y sirven como insumo para el próximo cierre integrador.

### Bloque 6 — Cierre (10 min)

**Takeaway:** "Hoy repasamos U1 y U2, conectamos ambos mundos (API sin BD → API con BD) y reflexionamos sobre cómo aprendimos. El diagnóstico de saberes previos del E1 y este cierre integrador forman un ciclo: al inicio sabíamos poco, al final podemos conectar conceptos."

**Preview:** "En el próximo encuentro (E17) arrancamos el cuatrimestre 2 con U3, donde vamos a completar el CRUD completo con Dapper, incluyendo POST, PUT y DELETE. Traigan sus apuntes de U1 y U2 porque los vamos a necesitar."

### Bloque 7 — Errores comunes y trampas (90 min)

1. **No conectar U1 y U2 como un todo continuo.** Causa: los alumnos ven cada unidad como un mundo separado y no reconocen que U2 extiende la API de U1. Fix: el docente siempre muestra cómo un endpoint de U1 se transforma en uno de U2, usando el mismo esqueleto de `Program.cs`.
2. **Confundir los tipos canónicos de Dapper (int vs long, DateTime vs string).** Causa: los alumnos vienen de otros lenguajes donde `int` es el tipo numérico por defecto y `DateTime` es el tipo de fecha por defecto. Fix: se refuerza que SQLite INTEGER siempre devuelve `Int64` (`long`) y que las fechas viajan como texto ISO (`string`).
3. **Olvidar los alias `AS` en los SELECT.** Causa: los alumnos escriben `SELECT patient_id` sin alias y Dapper no puede mapear la columna `patient_id` al parámetro `PatientId` del record posicional. Fix: se insiste en que todo SELECT debe usar `AS` con el nombre exacto del constructor del record.
4. **Subestimar la importancia de la práctica guiada en el cierre.** Causa: los alumnos piensan que un cierre es "repaso liviano" y no se involucran. Fix: el docente diseña actividades de integración que requieren pensar activamente, no solo recordar.
5. **No reflexionar sobre el propio aprendizaje.** Causa: los alumnos están acostumbrados a evaluaciones con nota y no saben cómo evaluar su propio proceso. Fix: la hoja de metacognición tiene preguntas concretas y no abstractas; el docente modela la respuesta antes de pedir que la completen.
6. **Perder el hilo entre encuentros.** Causa: al haber 36 encuentros, los alumnos pierden de vista cómo se conectan los contenidos. Fix: los cierres integradores (E16, E33, E36) sirven como puntos de anclaje que explicitan las conexiones entre unidades.
