# Desarrollo de APIs con C# .NET 6 (Minimal API)

> Repositorio de planificación de la asignatura. Documento en elaboración progresiva por fases: este README se completará con el índice general y el orden de creación de los documentos en la fase de cierre del repositorio.

## Identificación

| Campo | Detalle |
|---|---|
| Asignatura | Desarrollo de APIs con C# .NET 6 (Minimal API) |
| Nivel y modalidad | Nivel secundario, modalidad técnica |
| Régimen | Curso anual, 36 encuentros de 4 horas teóricas (144 horas anuales) |
| Entorno de trabajo | Visual Studio Code, terminal y SDK de .NET 6 |
| Acceso a datos | SQLite (hospital.db) mediante Dapper |
| Entregas | Repositorio único de GitHub por grupo (tp-u1, tp-u2, tp-u3, trabajo-final) |
| Documento madre | [01-planificacion/planificacion-anual.md](01-planificacion/planificacion-anual.md) |

## Fundamentación pedagógica del enfoque

La planificación de esta asignatura adopta decisiones de diseño respaldadas por modelos consolidados de la investigación educativa. La tabla siguiente explicita cada decisión y su fundamento, como instancia de transparencia curricular para docentes, equipos de conducción y familias.

| Decisión de diseño | Fundamento | Referencia |
|---|---|---|
| Todo saber que actúa como insumo (terminal, Git/GitHub, JSON, SQL) se enseña de forma explícita antes de su primer uso; la infraestructura de trabajo recurrente ingresa entre los primeros contenidos y se ejercita en cada encuentro | Teoría de la carga cognitiva: una sola novedad por encuentro evita sobrecargar la memoria de trabajo y reduce la carga extrínseca | Sweller |
| Diagnóstico inicial (encuentro 1) y nivelación de saberes previos (encuentros 2 y 3) previas al contenido específico | Aprendizaje significativo: el conocimiento nuevo se ancla en estructuras cognitivas previas; sin ancla, el aprendizaje es mecánico y frágil | Ausubel |
| Git y GitHub como saber transversal: rutina de un commit con mensaje referente al cierre de cada encuentro durante todo el curso | Práctica distribuida: la repetición espaciada consolida la retención más que una clase aislada, por más completa que sea | Dunlosky y colaboradores; Ebbinghaus |
| Cada encuentro se estructura en teoría mínima, práctica guiada y ejercicio independiente | Liberación gradual de la responsabilidad (yo hago, hacemos juntos, el estudiante hace) | Pearson y Gallagher (GRR) |
| Apertura con puente motivador, objetivos visibles, participación activa y cierre metacognitivo en cada encuentro | Modelo BOPPPS de diseño instruccional | BOPPPS |
| Apertura de clase con repaso de prerrequisitos, preguntas de verificación de comprensión y anticipación de errores comunes | Principios de instrucción efectiva | Rosenshine |
| La primera API en ejecución (encuentro 4) precede a la enseñanza de Git (encuentro 5) | Ancla motivadora: la herramienta llega cuando ya existe algo que versionar; el interés situacional sostiene el esfuerzo | Interés situacional y activación de conocimientos previos |
| Devolución de cada evaluación al inicio del encuentro siguiente y seguimiento del proceso mediante el historial de commits | La retroalimentación oportuna y específica es uno de los factores de mayor impacto sobre el aprendizaje | Hattie y Timperley; Black y Wiliam |
| Grupos recalculados en cada encuentro según alumnos presentes y equipos disponibles, con rotación de integrantes | Aprendizaje cooperativo con interdependencia positiva y responsabilidad individual | Johnson y Johnson |
| Proyecto integrador sobre una base de datos real, defensa individual y flujo profesional de repositorio (issues, ramas, pull requests) | Evaluación auténtica: el desempeño se valora en condiciones próximas a las del ejercicio profesional | Wiggins |

### Criterios de aplicación de la secuenciación de saberes

- Enseñar un saber y usarlo dentro del mismo encuentro no constituye una excepción: es la progresión GRR (teoría mínima, práctica guiada, uso independiente). La regla prohíbe utilizar como conocido aquello que nunca fue enseñado.
- Las herramientas de infraestructura se ubican inmediatamente después de una experiencia que les otorgue sentido (primera API en ejecución antes del control de versiones).
- Antes de cerrar cualquier documento derivado se verifica que ningún encuentro dependa de un saber aún no enseñado; toda corrección se propaga en cascada desde la planificación anual.
