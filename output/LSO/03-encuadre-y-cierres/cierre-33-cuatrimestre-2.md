# Cierre 33 — Cierre integrador del cuatrimestre 2

| Campo | Valor |
|---|---|
| Encuentro | 33 de 36 |
| Tipo | Cierre integrador del cuatrimestre 2 — Síntesis anual de U3+U4, metacognición |
| Duración | 240 min |
| Requisitos | Proyector, hojas impresas para actividades de síntesis, bolígrafos, apuntes de los cuatrimestres anteriores |
| Materiales | Slide de síntesis U3+U4, mapa conceptual en blanco, hoja de metacognición anual |
| Uso de celular | No permitido |

## Objetivos de aprendizaje

1. Sintetizar e integrar los contenidos de U3 (CRUD completo con Dapper) y U4 (Profesionalización y proyecto final).
2. Desarrollar metacognición sobre el propio proceso de aprendizaje del segundo cuatrimestre y del año completo.
3. Identificar conexiones entre los conocimientos de U3 y U4 y reconocer cómo se articulan con los contenidos del primer cuatrimestre.
4. Evaluar de manera reflexiva las propias fortalezas y áreas de mejora sin generación de nota.

## Agenda

### Bloque 1 — Charla rápida / Bridge-in (5 min)

**Analogía:** Pensá en U3 y U4 como el motor y el chassis de un auto que ya venimos construyendo desde el principio del año. En U3 aprendiste a darle movimiento completo (CRUD: crear, leer, actualizar, borrar) y en U4 aprendiste a presentarlo bien (repository limpio, README, ramas y PR). Sin el motor no hay auto; sin el chassis no hay presentación profesional. Este cierre es el momento de ver el auto completo.

**Actividad (voseo):** El docente proyecta una imagen de un auto incompleto (solo motor o solo chassis) y pregunta: "¿Qué le falta a este auto para estar listo?" Se toman 3-4 respuestas voluntarias. Se las conecta con la idea de que U3 y U4 juntos completan el vehículo.

### Bloque 2 — Objetivos de síntesis (5 min)

El docente presenta los objetivos del cierre: repasar U3 y U4, conectar ambos mundos (CRUD funcional → proyecto profesionalizado), y reflexionar sobre el aprendizaje del segundo cuatrimestre. Se aclara que este encuentro no introduce contenido nuevo ni tiene evaluación propia.

### Bloque 3 — Síntesis e integración U3+U4 (50 min)

**Teoría mínima (25 min):**
El docente guía un repaso estructurado de los ejes de U3 y U4. De U3 se revisan: el CRUD completo con Dapper (POST con `ExecuteScalar<long>` para obtener el ID generado, PUT con `Execute` para actualizar, DELETE con `Execute` para eliminar), las consultas con JOIN de 2 tablas y JOIN triple, el manejo de errores 400 y 404 con `Results.BadRequest` y `Results.NotFound`, y la cadena de conexión `"Data Source=hospital.db"`. De U4 se revisan: las ramas por feature, los pull requests revisados, la rama `main` protegida, el README de portada, los commits con mensaje referente al avance, y la estructura del repositorio con carpetas `tp-u1/`, `tp-u2/`, `tp-u3/`, `trabajo-final/`.

Se enfatiza la conexión entre ambas unidades: U3 construire la funcionalidad completa de la API y U4 la presentamos de manera profesional en el repositorio de GitHub. El docente muestra cómo un endpoint CRUD completo de U3 se integra en un proyecto que cumple con los estándares de U4 (ramas, PR, README, main protegida).

**Práctica guiada (25 min):**
Los alumnos, organizados en grupos de a presentes ÷ equipos disponibles, reciben un escenario de proyecto final: "Tenés que entregar una Minimal API con CRUD completo que esté en un repositorio profesional." Cada grupo completa un mapa conceptual que conecta los elementos de U3 (endpoints CRUD, consultas con JOIN, tipos canónicos) con los elementos de U4 (rama por feature, PR, README, main protegida). Se comparte en plenario y el docente compara los mapas de cada grupo.

### Bloque 4 — Práctica guiada: actividad de integración (45 min)

**Actividad (voseo):** El docente presenta un escenario completo: "Sos el líder de un equipo de 4 personas. Tenemos que entregar un trabajo final que tenga CRUD completo con Dapper y esté en un repositorio profesional con README, ramas y PR." Los alumnos, en grupos de a presentes ÷ equipos disponibles, trabajan en una hoja de trabajo que tiene tres columnas: "Lo que ya sé de U3 (CRUD)", "Lo que ya sé de U4 (profesionalización)" y "Lo que necesito integrar para el proyecto final". Cada grupo completa las tres columnas y luego presenta su plan de integración. El docente circula y orienta.

Se revisan en plenario las conexiones más importantes entre U3 y U4: cómo un endpoint CRUD funcional se convierte en parte de un proyecto profesional con commits, ramas y PR.

### Bloque 5 — Ejercicio independiente: metacognición (35 min)

**Actividad (voseo):** Cada alumno completa de manera individual una hoja de metacognición anual con las siguientes preguntas: (1) ¿Qué concepto de este cuatrimestre me costó más entender y por qué? (2) ¿Qué conexión entre U3 y U4 me pareció más importante? (3) ¿Qué habilidad nueva desarrollé este cuatrimestre que no tenía antes? (4) ¿Cómo cambió mi forma de aprender programación a lo largo del año? (5) ¿Qué quiero seguir aprendiendo después de esta asignatura? Las respuestas se entregan al docente y sirven como insumo para el cierre integral del E36.

### Bloque 6 — Cierre (10 min)

**Takeaway:** "Hoy repasamos U3 y U4, conectamos ambos mundos (CRUD funcional → proyecto profesional) y reflexionamos sobre cómo aprendimos este cuatrimestre y sobre cómo crecimos como programadores a lo largo del año."

**Preview:** "En el próximo encuentro (E34 y E35) vamos a trabajar en el proyecto final. Usá los apuntes de los tres cuatrimestres porque vas a necesitar todo: los fundamentos de U1, el acceso a datos de U2, el CRUD completo de U3 y la profesionalización de U4."

### Bloque 7 — Errores comunes y trampas (90 min)

1. **No conectar U3 y U4 como un todo continuo.** Causa: los alumnos ven U3 como "código funcional" y U4 como "trabajo de gestión" y no reconocen que U4 es la presentación profesional de lo que U3 construyó. Fix: el docente siempre muestra cómo un endpoint CRUD completo de U3 se integra en un proyecto que cumple con los estándares de U4.
2. **Confundir los métodos Dapper (Execute vs ExecuteScalar vs Query).** Causa: los alumnos mezclan cuándo usar cada método, especialmente para INSERT donde se necesita el ID generado. Fix: se refuerza que `ExecuteScalar<long>` se usa para obtener el ID de un INSERT, `Execute` para UPDATE/DELETE, y `Query<T>` para SELECT de múltiples filas.
3. **No usar ramas por feature en el proyecto final.** Causa: los alumnos siguen trabajando en `main` porque es más fácil y no ven la diferencia. Fix: se insiste en que desde U4 se usan ramas por feature y que `main` protegida es un estándar profesional, no un requisito opcional.
4. **Omitir el README de portada.** Causa: los alumnos piensan que el README es un detalle menor y no le dan la importancia que tiene como documentación de presentación. Fix: se explicita que el README de portada es parte de la evaluación del trabajo final y que debe contener instrucciones claras de instalación y uso.
5. **No reflexionar sobre el propio aprendizaje.** Causa: los alumnos están acostumbrados a evaluaciones con nota y no saben cómo evaluar su propio proceso. Fix: la hoja de metacognición tiene preguntas concretas y no abstractas; el docente modela la respuesta antes de pedir que la completen.
6. **Perder el hilo entre cuatrimestres.** Causa: al haber 36 encuentros divididos en dos cuatrimestres, los alumnos pierden de vista cómo se conectan los contenidos de ambos. Fix: los cierres integradores (E16, E33, E36) sirven como puntos de anclaje que explicitan las conexiones entre unidades y cuatrimestres.
