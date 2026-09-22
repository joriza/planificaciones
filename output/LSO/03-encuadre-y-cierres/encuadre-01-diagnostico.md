# Encuadre 1 — Diagnóstico de saberes previos y contrato pedagógico

| Campo | Valor |
|---|---|
| Encuadre | 1 de 36 |
| Tipo | Encuadre — Diagnóstico de saberes previos y contrato pedagógico |
| Duración | 240 min |
| Requisitos | Proyector, hojas impresas para diagnóstico, bolígrafos, dispositivos con VS Code |
| Materiales | Slide de presentación, contrato pedagógico impreso, hoja de diagnóstico de saberes previos, lista de verificación de EPP |
| Uso de celular | No permitido |

## Objetivos de aprendizaje

1. Presentar la asignatura, sus objetivos y el contrato pedagógico que regirá el cuatrimestre.
2. Diagnosticar los saberes previos de los alumnos en lógica y algoritmos para ajustar la planificación de los encuentros siguientes.
3. Identificar y comprender las normas de seguridad e higiene y el uso correcto de los elementos de protección personal (EPP).
4. Establecer las condiciones de trabajo y los recursos tecnológicos que se utilizarán durante el cursado.

## Agenda

### Bloque 1 — Charla rápida / Bridge-in (5 min)

**Analogía:** Pensá en una Minimal API como la recepción de un hospital: es el primer punto de contacto donde todo llega y todo se deriva. Sin una recepción organizada, el hospital no funciona. De la misma manera, sin una asignatura bien presentada y un contrato claro, el cuatrimestre no arranca con las mejores condiciones.

**Actividad (voseo):** El docente proyecta una imagen de una recepción de hospital y pregunta en voz alta: "¿Qué creen que necesita una recepción para funcionar bien?" Se toman 3-4 respuestas voluntarias. Luego se conecta con la idea de que esta asignatura va a ser la "recepción" de sus conocimientos de programación: van a entrar con lo que saben y van a salir con una habilidad nueva.

### Bloque 2 — Presentación de la asignatura y contrato pedagógico (45 min)

**Teoría mínima (25 min):**
El docente presenta la asignatura "Minimal API con C# .NET 6". Se explica el alcance: un único archivo `Program.cs`, sin abstracciones intermedias, usando Dapper para el acceso a datos y SQLite como base de datos. Se describe la modalidad de la escuela técnica: 36 encuentros de 4 horas, sin conocimientos previos de C# requeridos.

Se entrega y se comenta el contrato pedagógico impreso. Se explican las reglas de funcionamiento: uso de VS Code y terminal, prohibición del celular, entrega de trabajos por GitHub, commit con mensaje en español sin tildes. Se aclara que la base de datos `hospital.db` se proporciona y que los alumnos no deben modificarla directamente.

**Práctica guiada (20 min):**
El docente muestra paso a paso cómo se estructura un proyecto Minimal API: la carpeta del proyecto, el archivo `.csproj`, el archivo `Program.cs` y la ubicación de `hospital.db`. Se recorre el esqueleto del archivo sin profundizar en el código, solo para que los alumnos visualicen la estructura que van a usar durante todo el cuatrimestre. Se responden preguntas sobre el contrato y los recursos.

### Bloque 3 — Seguridad e higiene y EPP (35 min)

**Teoría mínima (15 min):**
Dado que esta es una escuela técnica, se incluye el bloque obligatorio de seguridad e higiene. Se presentan las normas generales del taller: uso obligatorio de protección ocular, prohibición de alimentos y bebidas en la zona de equipos, uso correcto de las sillas y mesas, y procedimientos de evacuación. Se explica la lista de verificación de EPP: protección ocular, calzado cerrado, postura ergonómica frente a la pantalla.

Se entrega la lista de verificación de EPP y se pide a los alumnos que la firmen como constancia de lectura. Se aclara que el incumplimiento de estas normas puede generar la exclusión de la práctica del día.

**Práctica guiada (20 min):**
Los alumnos, organizados en grupos de a presentes ÷ equipos disponibles, recorren el aula identificando elementos de seguridad e higiene presentes (extintor, salida de emergencia, kit de primeros auxilios, señalética). Cada equipo anota en una hoja aparte lo que encontró y lo que falta. Se comparte en plenario y el docente complementa con la información que corresponda.

### Bloque 4 — Diagnóstico de saberes previos (50 min)

**Teoría mínima (10 min):**
El docente explica que el diagnóstico no es una evaluación sino una herramienta para conocer qué saben los alumnos antes de empezar. Se aclara que no se necesita saber C# para rendir bien: se evalúa lógica, pensamiento algorítmico y nociones básicas de programación que los alumnos puedan tener de experiencias previas.

Se reparte la hoja de diagnóstico de saberes previos. La hoja contiene preguntas de lógica (orden de pasos de un algoritmo, identificación de patrones) y preguntas de pseudocódigo (leer un fragmento de código simple y predecir la salida). No se permite usar celular ni consultar material externo.

**Práctica guiada (20 min):**
Los alumnos completan la hoja de diagnóstico de manera individual. El docente circula por el aula para resolver dudas de formato y para observar el nivel de participación. No se responden las preguntas del diagnóstico durante este momento.

**Ejercicio independiente (20 min):**
Se recogen las hojas de diagnóstico. El docente proyecta las respuestas de las preguntas más representativas y las comenta brevemente sin evaluar. Se explica que los resultados de este diagnóstico van a orientar la planificación de los próximos encuentros (E2 y E3) y que no tienen impacto en la nota del cuatrimestre.

### Bloque 5 — Práctica guiada (35 min)

**Actividad (voseo):** El docente presenta un fragmento de código Minimal API de ejemplo y pide a los alumnos que, en grupos de a presentes ÷ equipos disponibles, identifiquen qué partes del código ya reconocen de la presentación del Bloque 2. Se guía la discusión con preguntas: "¿Qué creen que hace esta línea?", "¿Dónde creen que se define la conexión a la base de datos?". El docente completa la explicación al final de la actividad.

### Bloque 6 — Ejercicio independiente (30 min)

**Actividad (voseo):** Cada alumno completa de manera individual una ficha de reflexión con tres preguntas: (1) ¿Qué sabías antes de hoy sobre programación web? (2) ¿Qué esperás aprender en esta asignatura? (3) ¿Qué te genera más curiosidad o más ansiedad? Las fichas se entregan al docente y sirven como insumo para los encuentros E2 y E3.

### Bloque 7 — Cierre (10 min)

**Takeaway:** "Hoy conocimos la estructura de la asignatura, firmamos el contrato pedagógico, repasamos las normas de seguridad y EPP, y completamos el diagnóstico de saberes previos. Ese diagnóstico le va a servir al docente para ajustar los próximos encuentros a lo que ustedes ya saben."

**Preview:** "En los próximos encuentros (E2 y E3) vamos a comenzar a trabajar con C# y la terminal. Traigan su dispositivo con VS Code instalado y el SDK .NET 6 configurado."

### Bloque 8 — Errores comunes y trampas (30 min)

1. **Confundir el diagnóstico con una evaluación.** Causa: los alumnos se ponen ansiosos al ver una hoja con preguntas. Fix: el docente deja claro desde el inicio que el diagnóstico no se califica y que sirve para conocer el punto de partida del grupo.
2. **No traer el dispositivo con VS Code instalado.** Causa: los alumnos subestiman la importancia de tener el entorno listo desde el primer día. Fix: en el contrato pedagógico se especifica que el entorno debe estar instalado antes del E2.
3. **Ignorar las normas de seguridad e higiene.** Causa: en escuelas técnicas, los alumnos a veces tienen la costumbre de comer o beber cerca de los equipos. Fix: se explicita en el contrato que la infracción puede generar la exclusión de la práctica.
4. **Subestimar la importancia del celular.** Causa: los alumnos están acostumbrados a usar el celular como herramienta de consulta constante. Fix: se establece desde el E1 que el celular no está permitido durante los encuentros; la consulta se hace en la terminal o en los materiales proporcionados.
5. **No leer el contrato pedagógico.** Causa: los alumnos suelen firmar sin leer. Fix: el docente dedica tiempo a recorrer las cláusulas más relevantes y responde preguntas antes de pedir la firma.
