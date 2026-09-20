# {{denominacion}} — Índice del curso

> Documento índice del corpus de la asignatura **{{denominacion}}**, redactado en registro docente formal. Presenta el curso, organiza el corpus completo mediante vínculos a cada documento, documenta el orden de creación de los materiales y la fundamentación pedagógica del enfoque. Es un documento derivado: se genera con `{{rutaReadmeTool}}` a partir del árbol del corpus y de la firma pedagógica del curso (`{{rutaData}}`).

---

## 1. Presentación del curso

| Campo | Detalle |
| --- | --- |
| Asignatura (denominación formal) | {{denominacion}} |
| Nivel y modalidad | Nivel secundario, escuela técnica |
{{FILA_STACK}}{{FILA_ENTORNO}}| Carga horaria | {{cargaHoraria}} |
| Uso del celular | {{celular}} |

El ciclo lectivo sigue una estructura fija de 36 encuentros organizados en 16 tramos: encuadre y diagnóstico (encuentro 1), recuperación y profundización de saberes previos (encuentros 2-3), cuatro unidades didácticas con su encuentro dedicado de evaluación (encuentros 4-9, 10-15, 21-26 y 27-32), cierres integradores cuatrimestrales sin evaluación propia (encuentros 16 y 33), momentos de intensificación y fortalecimiento (encuentros 17-20 y 34-35) y cierre integral (encuentro 36). La terminal, git y GitHub, y el trabajo colaborativo se enseñan de forma explícita antes de su primer uso y se ejercitan como saberes transversales durante todo el año.

---

## 2. Índice completo del corpus

{{INDICE}}

---

## 3. Orden de creación de los documentos

{{ORDEN}}

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
| **Evaluación auténtica.** Los productos evaluados son reales y versionados en GitHub ({{tp.u1}}, {{tp.u2}}, {{tp.u3}} y {{tp.u4}}), con defensa oral individual del propio código y un trabajo integrador final que replica el flujo profesional de un repositorio (README de portada, issues, ramas por feature, pull requests revisados y main protegida). | La evaluación auténtica valora el desempeño en situaciones reales del dominio: la comprensencia se evidencia cuando el alumno puede explicar y justificar lo que hizo. | Wiggins (1998) |
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

La planificación anual ([`01-planificacion/planificacion-anual.csv`](01-planificacion/planificacion-anual.csv), render determinista de la firma pedagógica del curso `{{rutaData}}`) es el **documento madre** del curso: el libro de aula, las unidades didácticas y sus clases, las evaluaciones, el encuadre y los cierres del ciclo, los momentos de intensificación y fortalecimiento, la continuidad pedagógica y los criterios de aprobación derivan de ella con correlación exacta de numeración de encuentros, denominaciones de tramos, ejes, tiempos y momentos de evaluación y recuperación. Todo cambio futuro se ajusta **primero** en `{{rutaData}}`, se re-renderizan los administrativos con `{{rutaTool}}` y este índice con `{{rutaReadmeTool}}`, y se propaga **en cascada** a los documentos derivados; nunca se dejan documentos desalineados. Ante cualquier duda técnica de contenido, decide la hoja de [convenciones-tecnicas.md](convenciones-tecnicas.md).

{{NOTA_CATEDRA}}
