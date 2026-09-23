# Encuentro 1 — Encuadre y diagnóstico

> Programación en Python · Encuentro de apertura

## 1. Metadatos

| Campo | Detalle |
| --- | --- |
| Encuentro | 1 de 36 |
| Instancia | Encuadre anual |
| Duración | 120 minutos (2 horas reloj) |
| Carácter | Encuadre y diagnóstico |
| Evaluación propia | No |
| Requisitos previos | Experiencia previa en programación en algún lenguaje (no necesariamente Python) |
| Uso de celular | No permitido |
| Entorno | VS Code + terminal; entregas por Git/GitHub |

## 2. Objetivos del encuentro

1. Conocer la organización anual de la asignatura, el contrato pedagógico y los acuerdos de convivencia para el aula-taller de la escuela técnica.
2. Identificar las normas de seguridad e higiene y los elementos de protección personal (EPP) requeridos en el aula-taller de informática.
3. Visibilizar los saberes previos del grupo en programación, uso de terminal, Git/GitHub y trabajo con repositorios.
4. Presentar las cuatro unidades del año y el panorama general de los contenidos.
5. Reconocer la modalidad de entregas por Git/GitHub y conformar los grupos de trabajo iniciales.

## 3. Reparto de tiempos

| Momento | Tiempo |
| --- | --- |
| Contrato pedagógico y presentación | 15 min |
| Seguridad e higiene y EPP del aula-taller | 15 min |
| Panorama de la materia y diagnóstico de saberes previos | 55 min |
| Acuerdos de trabajo y conformación de grupos | 20 min |
| Cierre | 15 min |
| **Total** | **120 min** |

## 4. Desarrollo

### 4.1 Contrato pedagógico y presentación (15 min)

**Consigna.** El docente se presenta, presenta la materia (Programación en Python, 36 encuentros de 2 h) y recorre la planificación anual: cuatro unidades, las instancias de evaluación (encuentros 9, 15, 26 y 32), TP-U1, TP-U2, TP-U3 y Trabajo Final. Explica el formato de evaluación (entrega por GitHub + defensa individual + prueba práctica A/B). Proyecta el contrato pedagógico con los derechos y obligaciones del aula-taller de la escuela técnica: asistencia, puntualidad, uso de equipos, política de celular (no permitido), criterios de aprobación y régimen de recuperación. Cada estudiante firma el contrato (en formato digital o planilla impresa). El grupo pregunta y comenta.

**¿Qué hace el grupo?** Escucha la presentación, lee el contrato proyectado, formula preguntas y firma.

### 4.2 Seguridad e higiene y EPP del aula-taller (15 min)

**Consigna.** Recorrido guiado por las normas de seguridad específicas del aula-taller de informática de la escuela técnica: correcta postura frente al equipo, gestión de cables (riesgo de tropiezos y enganches), prohibición de alimentos y bebidas cerca de los equipos, ventilación del aula, manipulación segura de conectores y periféricos. Se enumeran los EPP requeridos: sillita regulable con apoyo lumbar, superficie de trabajo despejada, iluminación adecuada (evitar reflejos en pantalla), pausas activas cada 30 min. Se entrega un volante digital con el resumen de normas y EPP.

**¿Qué hace el grupo?** Escucha, anota dudas, recibe el volante digital y firma la planilla de recepción de normas.

### 4.3 Panorama de la materia y diagnóstico de saberes previos (55 min)

Este bloque tiene dos partes: el panorama general de la materia y el diagnóstico propiamente dicho.

**Panorama de las cuatro unidades (10 min).** El docente presenta las denominaciones de cada unidad según el diseño del curso:

- **Unidad 1 — Fundamentos de Python y control del flujo:** primer contacto con el lenguaje, variables, tipos básicos, operadores, estructuras de control y bucles. Todo se resuelve en memoria, sin archivos ni bases de datos.
- **Unidad 2 — Estructuras de datos y funciones:** listas, tuplas, conjuntos, diccionarios, funciones con `def`, parámetros y `return`, organización del archivo con bloque de ejecución principal.
- **Unidad 3 — Procesamiento de texto y validación:** métodos de cadenas, validación de entrada con `try`/`except`, menú de consola en memoria, integración de los núcleos del curso en un solo archivo.
- **Unidad 4 — Trabajo integrador y flujo profesional:** repositorio profesional con README, issues, ramas por feature, pull requests revisados y main protegida. El trabajo final integra todo lo anterior.

**Consigna.** "Estas son las cuatro unidades del año. Cada una tiene su instancia de evaluación y su trabajo práctico. El cuatrimestre 1 cubre U1 y U2; el cuatrimestre 2 cubre U3 y U4."

**Actividad A — Relevamiento de lenguajes (15 min).** Cada estudiante completa un formulario breve (Google Forms / encuesta en papel) indicando:
- ¿Programaste antes? ¿En qué lenguaje(s)?
- ¿Usaste terminal o línea de comandos? (nunca / algunas veces / con frecuencia)
- ¿Usaste Git? (nunca / solo clonar / commits y push / trabajo en ramas)
- ¿Usaste GitHub? (nunca / solo ver repos / subir cambios / pull requests)
- ¿Trabajaste en equipo con repositorios compartidos?

**Consigna.** "Completá el formulario con lo que recuerdes. No estudies, no hay nota. Esto me sirve para saber desde dónde arrancamos."

**Actividad B — Diagnóstico práctico grupal (20 min).** En parejas (el docente asigna al azar), los alumnos reciben la siguiente consigna en un archivo de texto:

> "En la terminal de VS Code, creá una carpeta `diagnostico`. Dentro escribí un programa en cualquier lenguaje que sepas (el que más te guste) que pida el nombre al usuario y le responda 'Hola, [nombre]'. Si no recordás cómo hacerlo, escribí un archivo `notas.txt` con lo que SÍ sabés hacer y lo que NO sabés hacer todavía."

El docente circula, observa, toma nota de los niveles observados (no registra nombres). No interviene; solo responde dudas técnicas sobre el entorno (abrir terminal, crear archivo, ejecutar).

**Actividad C — Puesta en común y modalidad de entregas (10 min).** El docente proyecta los resultados agregados del formulario (sin identificar personas) y comenta: "Estos son los saberes del curso. Desde acá arrancamos. A quienes nunca usaron terminal o Git, no se preocupen: lo vamos a ver desde cero la próxima clase." Luego explica la modalidad de entregas: cada grupo trabaja con un único repositorio compartido en GitHub, con carpetas `tp-u1`, `tp-u2`, `tp-u3` y `trabajo-final`. El ciclo completo de entrega (gitignore en la raíz, init, commits, repo remoto, remote add, push) se enseña una sola vez en este primer encuentro. De ahí en adelante, cada entrega es carpeta nueva, commits y push. La última unidad profesionaliza ese mismo repositorio: README de portada, issues, ramas por feature, pull requests revisados y main protegida.

**¿Qué hace el grupo?** Responde el formulario individual, trabaja en parejas con la consigna práctica, participa de la puesta en común y escucha la explicación de la modalidad de entregas.

### 4.4 Acuerdos de trabajo y conformación de grupos (20 min)

**Consigna.** "Con los resultados del diagnóstico, armamos los equipos de trabajo. Cada equipo tendrá un repositorio compartido en GitHub. Las entregas se hacen por ese repo, con carpetas `tp-u1`, `tp-u2`, `tp-u3` y `trabajo-final`. Todos los integrantes del equipo deben saber usar Git: si alguien no lo usó nunca, durante la Unidad 1 va a practicar con guías paso a paso."

**Regla de conformación:** alumnos presentes ÷ equipos disponibles (cantidad de PCs / puestos). Se forma el mínimo de equipos posible, ningún equipo sin usar. El docente propone la distribución buscando heterogeneidad de niveles. Cada equipo elige un nombre y un delegado de comunicación.

**¿Qué hace el grupo?** Escucha la propuesta de equipos, negocia cambios menores, elige nombre y delegado.

### 4.5 Cierre (15 min)

**Consigna.** "Ronda de una palabra: cada uno dice una palabra que resume cómo se va del primer encuentro." El docente anota las palabras en el pizarrón y cierra: "La próxima clase arrancamos con Python: instalación, primer programa, variables. Traé las ganas."

#### Qué te llevás

- Organización general de la materia: unidades, instancias de evaluación, entregas por GitHub.
- Normas de seguridad e higiene y EPP del aula-taller.
- Un diagnóstico personal y grupal de saberes previos.
- Equipo de trabajo asignado y repositorio compartido.
- Entorno listo para la próxima clase (VS Code instalado, cuenta de GitHub creada).

#### Conformación inicial de grupos de trabajo

Los grupos se conforman en este encuentro según la cantidad de alumnos presentes y equipos disponibles. Cada grupo recibe un nombre y un delegado elegido por sus integrantes. La distribución queda asentada en el contrato pedagógico y se revisa al inicio de cada unidad.