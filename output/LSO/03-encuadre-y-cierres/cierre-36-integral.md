# Cierre 36 — Cierre integral de la asignatura

| Campo | Valor |
|---|---|
| Encuentro | 36 de 36 |
| Tipo | Cierre integral de la asignatura — Balance del año, metacognición, proyección |
| Duración | 240 min |
| Requisitos | Proyector, hojas impresas para actividades de balance, bolígrafos, apuntes del año completo |
| Materiales | Slide de balance anual, mapa conceptual en blanco, hoja de metacognición y proyección |
| Uso de celular | No permitido |

## Objetivos de aprendizaje

1. Realizar un balance integral del año completo conectando los cuatro bloques (U1, U2, U3, U4).
2. Desarrollar metacognición profunda sobre el propio proceso de aprendizaje a lo largo del año.
3. Proyectar cómo los conocimientos adquiridos pueden aplicarse en contextos futuros (otros cursos, proyectos personales, inserción laboral).
4. Evaluar de manera reflexiva las propias fortalezas y áreas de mejora sin generación de nota.

## Agenda

### Bloque 1 — Charla rápida / Bridge-in (5 min)

**Analogía:** Pensá en esta asignatura como un viaje de 36 encuentros que empezó con una recepción vacía (E1) y terminó con un auto completo y profesionalizado (E33). En el medio, aprendiste a armar el vehículo (U1), a cargarlo con datos (U2), a darle movimiento completo (U3) y a presentarlo bien al mundo (U4). Este cierre es el momento de mirar atrás y ver todo el camino recorrido.

**Actividad (voseo):** El docente proyecta una línea de tiempo con los 36 encuentros y pide: "¿Qué momento del año te marcó más?" Se toman 3-4 respuestas voluntarias. Se las conecta con los bloques teóricos que siguen.

### Bloque 2 — Objetivos de síntesis (5 min)

El docente presenta los objetivos del cierre integral: balancear el año completo, conectar los cuatro bloques en una visión unificada, y reflexionar sobre el propio aprendizaje y la proyección futura. Se aclara que este encuentro no introduce contenido nuevo ni tiene evaluación propia.

### Bloque 3 — Balance anual: síntesis U1-U4 (50 min)

**Teoría mínima (25 min):**
El docente guía un repaso estructurado de los cuatro bloques del año. De U1 se revisan: la estructura de un proyecto Minimal API (`Program.cs`, top-level statements, `WebApplication`), los verbos HTTP (`MapGet`, `MapPost`, `MapPut`, `MapDelete`), los códigos de respuesta (200, 201, 204, 400, 404) y la separación entre lógica de negocio y respuesta HTTP. De U2 se revisan: la conexión a SQLite, las consultas parametrizadas con Dapper, el mapeo de tipos y el uso de alias `AS`. De U3 se revisan: el CRUD completo (POST con `ExecuteScalar<long>`, PUT con `Execute`, DELETE con `Execute`), las consultas con JOIN de 2 tablas y JOIN triple, y el manejo de errores 400 y 404. De U4 se revisan: las ramas por feature, los pull requests revisados, la rama `main` protegida, el README de portada y la estructura del repositorio.

Se enfatiza la progresión del año: U1 construye la base (API mínima sin BD), U2 le agrega persistencia, U3 completa el CRUD, y U4 profesionaliza el proyecto. El docente muestra cómo cada unidad es un escalón que se apoya en la anterior.

**Práctica guiada (25 min):**
Los alumnos, organizados en grupos de a presentes ÷ equipos disponibles, reciben un mapa conceptual en blanco con los cuatro nodos de las unidades. Cada grupo completa el mapa agregando los elementos clave de cada unidad y las conexiones entre ellas. Se comparte en plenario y el docente compara los mapas de cada grupo, destacando las conexiones que más grupos identificaron.

### Bloque 4 — Práctica guiada: actividad de integración (45 min)

**Actividad (voseo):** El docente presenta un escenario de proyecto final completo: "Tenés que entregar un trabajo final que tenga CRUD completo con Dapper, esté en un repositorio profesional con README, ramas y PR, y que demuestre que entendés todo el recorrido del año." Los alumnos, en grupos de a presentes ÷ equipos disponibles, trabajan en una hoja de trabajo que tiene cuatro columnas: "U1 — Fundamentos", "U2 — Acceso a datos", "U3 — CRUD completo", "U4 — Profesionalización". Cada grupo completa las cuatro columnas con los elementos que aporta cada unidad al proyecto final y luego presenta su visión integrada. El docente circula y orienta.

Se revisan en plenario las conexiones más importantes entre las cuatro unidades: cómo los fundamentos de U1 se usan en U2, cómo U2 habilita U3, y cómo U4 presenta todo de manera profesional.

### Bloque 5 — Ejercicio independiente: metacognición y proyección (35 min)

**Actividad (voseo):** Cada alumno completa de manera individual una hoja de metacognición y proyección con las siguientes preguntas: (1) ¿Qué concepto de todo el año me costó más entender y por qué? (2) ¿Qué conexión entre unidades me pareció más importante? (3) ¿Qué habilidad nueva desarrollé este año que no tenía antes? (4) ¿Cómo cambió mi forma de aprender programación a lo largo del año? (5) ¿Qué quiero seguir aprendiendo después de esta asignatura? (6) ¿Cómo puedo aplicar lo que aprendí en otros cursos o proyectos? Las respuestas se entregan al docente y sirven como cierre reflexivo del año.

### Bloque 6 — Cierre (10 min)

**Takeaway:** "Hoy hicimos el balance completo del año: conectamos los cuatro bloques, reflexionamos sobre cómo aprendimos y proyectamos qué sigue. Lo que empezó como una recepción vacía en el E1 terminó como un proyecto profesional completo. Ese recorrido es lo más valioso de esta asignatura."

**Preview:** "Los encuentros restantes (E34, E35) son para trabajar en el proyecto final. Usá los apuntes de todo el año porque vas a necesitar cada bloque. El cierre de E36 marca el fin del recorrido formal de la asignatura."

### Bloque 7 — Errores comunes y trampas (90 min)

1. **No ver el año como una progresión.** Causa: los alumnos ven cada unidad como un mundo separado y no reconocen que cada una se apoya en la anterior. Fix: el docente siempre muestra cómo U1 se usa en U2, cómo U2 habilita U3 y cómo U3 se presenta con U4.
2. **Perder la conexión entre código y profesionalización.** Causa: los alumnos piensan que el código funcional es suficiente y no valoran la presentación profesional del repositorio. Fix: se insiste en que un proyecto sin README, sin ramas y sin PR no es un proyecto profesional, sin importar qué tan bien funcione el código.
3. **Confundir los tipos canónicos de Dapper entre las unidades.** Causa: los alumnos cometen los mismos errores de tipos (int vs long, DateTime vs string) en todas las unidades porque no internalizaron la regla. Fix: se refuerza que las reglas de la hoja de convenciones técnicas son la fuente única de verdad y deben aplicarse en todas las unidades.
4. **No reflexionar sobre el propio aprendizaje.** Causa: los alumnos están acostumbrados a evaluaciones con nota y no saben cómo evaluar su propio proceso. Fix: la hoja de metacognición tiene preguntas concretas y no abstractas; el docente modela la respuesta antes de pedir que la completen.
5. **Subestimar la importancia del cierre integral.** Causa: los alumnos piensan que el cierre es un "repaso de cierre de año" y no se involucran. Fix: el docente diseña actividades de integración que requieren pensar activamente sobre todo el año, no solo recordar.
6. **No proyectar hacia el futuro.** Causa: los alumnos no ven cómo lo aprendido en esta asignatura se conecta con otros cursos o con su desarrollo profesional. Fix: la pregunta de proyección en la hoja de metacognición obliga a pensar más allá del aula.
