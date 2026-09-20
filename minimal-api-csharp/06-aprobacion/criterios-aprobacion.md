# Criterios de aprobación — Minimal API con C# .NET 6

> Documento institucional de la asignatura, en registro docente formal. Deriva de la planificación anual (`01-planificacion/planificacion-anual.md`) con correlación exacta de encuentros, trabajos e instancias. Explica en lenguaje claro qué se evalúa, qué se exige para aprobar y qué caminos de recuperación existen cuando un objetivo mínimo no se alcanza.

## 1. Presentación y destinatarios

Este documento define los criterios de aprobación de la cursada de **Minimal API con C# .NET 6** y está pensado para tres destinatarios:

| Destinatario | Para qué le sirve este documento |
| --- | --- |
| **Alumnos** | Saber qué se espera de ellos en cada unidad, qué se evalúa y qué hacer si un objetivo queda pendiente. |
| **Familias** | Comprender, sin tecnicismos innecesarios, cómo se evalúa la materia, cuándo se informan los resultados y qué instancias de acompañamiento existen. |
| **Dirección** | Contar con el registro formal de los criterios aplicados, verificables contra la planificación anual y las actas de cada instancia. |

Los criterios son los mismos para todo el curso. La evaluación es cualitativa y por objetivos mínimos: cada objetivo se registra como **Apto** o **No apto aún**, y la aprobación de la cursada se define por el alcance completo de esos objetivos, no por una escala numérica.

## 2. Qué se evalúa

### 2.1 Proceso

Se observa y registra el trabajo sostenido en clase durante todo el año:

- **Trabajo en clase:** participación en la práctica guiada y el ejercicio independiente de cada encuentro, avance revisable en el propio repositorio (commits) y corrección de errores comunes.
- **Trabajo grupal:** los grupos se recalculan en cada encuentro con trabajo grupal (alumnos presentes divididos equipos disponibles, en la cantidad mínima posible), ningún equipo queda sin usar y los integrantes rotan entre actividades; se valora la colaboración y la comunicación técnica dentro del grupo.
- **Continuidad pedagógica:** las actividades de repaso dejadas para las clases sin presencia docente y su presentación individual (detalladas en la sección 7).

### 2.2 Productos

Las instancias de evaluación con producto verificable son:

| Instancia | Encuentros | Producto y modalidad |
| --- | --- | --- |
| Trabajo práctico **tp-u1** | Entrega en 8, evaluación en 9 | Entrega por GitHub (carpeta del trabajo, commits y push en el repositorio del grupo), defensa individual y prueba práctica en versiones A y B equivalentes |
| Trabajo práctico **tp-u2** | Entrega en 14, evaluación en 15 | Ídem tp-u1, sobre la base `hospital.db` con Dapper |
| Trabajo práctico **tp-u3** | Entrega en 25, evaluación en 26 | Ídem, con consultas avanzadas y publicación |
| Trabajo integrador **trabajo-final** | Entrega en 31, defensa en 32 | Entrega por GitHub con el flujo profesional del repositorio y defensa individual del integrador |
| Evaluación integradora del cuatrimestre 1 | 16 | Prueba práctica individual en versiones A y B sobre los núcleos de las Unidades 1 y 2, más instancia de metacognición |
| Proyecto puente de las Unidades 1 y 2 | 19 y 20 | Proyecto integrador grupal desarrollado en dos encuentros, con cierre con rúbrica de 100 puntos |
| Evaluación integradora del cuatrimestre 2 | 33 | Prueba práctica individual en versiones A y B sobre los núcleos de las Unidades 3 y 4, más metacognición anual |
| Momentos especiales 17-18 y 34-35 | 17-18 y 34-35 | Evaluación en versiones A y B con criterio Apto / No apto aún por objetivo mínimo (ver sección 5) |

Todas las versiones A y B son equivalentes: mismos objetivos y mismos requisitos, con distinto dominio o datos, de modo que la versión asignada no otorgue ventaja ni habilite la copia. La entrega de los trabajos se realiza por GitHub en el repositorio único del grupo, con una carpeta por trabajo; la defensa es siempre **individual**: cada alumno explica y justifica oralmente el propio código.

## 3. Objetivos mínimos por unidad

Cada unidad define objetivos mínimos irrenunciables. La siguiente tabla es la referencia única de qué debe lograr cada estudiante para acreditar la unidad; se verifica en la evaluación de la unidad, en los momentos especiales y, de persistir, en diciembre y marzo.

| Unidad | Nº | Objetivo mínimo |
| --- | --- | --- |
| **U1 — Fundamentos de Minimal API** | 1 | Crear y correr la API: crear el proyecto con `dotnet new web`, ejecutarlo con `dotnet run` y probar un endpoint en el navegador |
| | 2 | Construir un endpoint GET con parámetro de ruta que devuelva JSON |
| | 3 | Implementar verbos HTTP y códigos de respuesta adecuados en un CRUD en memoria (200, 201, 400, 404) |
| | 4 | Completar el ciclo de entrega por GitHub: carpeta del trabajo, commits y push en el repositorio del grupo |
| **U2 — Acceso a datos con SQLite y Dapper** | 1 | Consultar `hospital.db` con Dapper: SELECT parametrizado con WHERE (y ORDER BY) |
| | 2 | Búsqueda parcial con LIKE parametrizada, con validación manual y códigos 400 y 404 |
| | 3 | Resolver un JOIN de dos tablas mapeado a un record compuesto |
| | 4 | Escritura validada: INSERT, UPDATE y DELETE parametrizados con códigos 201, 400 y 404 |
| **U3 — Integración de datos y publicación** | 1 | Resolver un JOIN de tres tablas (`admissions`, `patients`, `doctors`) y exponer endpoints compuestos |
| | 2 | Construir reportes con agregaciones (COUNT, AVG, SUM) y GROUP BY |
| | 3 | Tratar el dato sucio (valores NULL, errores de tipeo, fechas erróneas) sin romper la consulta |
| | 4 | Configurar la cadena de conexión en `appsettings.json` y publicar con `dotnet publish` |
| **U4 — Trabajo integrador profesional** | 1 | Mantener un README de portada del repositorio del trabajo |
| | 2 | Trabajar con el flujo profesional: issues, ramas por feature, pull requests revisados y main protegida |
| | 3 | Integrar en el trabajo final subconsultas y estadísticas sobre `hospital.db` |
| | 4 | Defender individualmente el integrador: decisiones técnicas y participación propia en el proyecto |

Los logros se registran por objetivo: un estudiante puede tener una unidad acreditada y otra con objetivos pendientes; la recuperación trabaja exactamente sobre los objetivos pendientes, nunca sobre todo de nuevo.

## 4. Regla de entrega incompleta

Si un trabajo práctico no está completo al llegar su encuentro de evaluación:

1. **Se evalúa lo presentado.** El docente toma la evaluación con el contenido entregado hasta ese momento: lo que compila, corre y responde vale como evidencia; el faltante se consigna en observaciones.
2. **Se identifican los objetivos no alcanzados.** El registro docente marca, objetivo por objetivo, qué quedó alcanzado y qué quedó pendiente; esa fila de objetivos es la que guía la devolución.
3. **Se activa la capa de recuperación correspondiente** (sección 5), solo para los objetivos no alcanzados.
4. **La entrega sigue disponible para completar.** El repositorio del grupo permanece abierto: el trabajo puede completarse después del encuentro con nuevos commits y push, y lo completado se revisa en la instancia de recuperación que corresponda.

Una entrega incompleta nunca invalida lo ya logrado: el resultado se construye por objetivos, no por todo o nada.

## 5. Capas de recuperación

Las capas se aplican **solo sobre los objetivos no alcanzados** registrados en cada instancia; un objetivo ya acreditado no se vuelve a evaluar. Cada capa tiene criterio explícito y resultado registrado.

| Capa | Cuándo | Destinatarios | Qué se trabaja | Criterio de resultado |
| --- | --- | --- | --- | --- |
| **1. Devolución y reincorporación en las clases siguientes** | Encuentro siguiente a cada evaluación (10, 16, 27 y 33 abren con devolución) y clases regulares posteriores | Quien registre objetivos no alcanzados en la evaluación de unidad | Devolución individual detallada y reincorporación de los objetivos pendientes en las prácticas y trabajos de las clases siguientes | Seguimiento docente registrado; el estado de cada objetivo se actualiza en las instancias siguientes |
| **2. Momentos especiales de recuperación dentro del ciclo** | Encuentros 17-18 (núcleos de U1 y U2) y 34-35 (núcleos de U3 y U4) | Quien registre objetivos no alcanzados del cuatrimestre; en paralelo, quienes ya los alcanzaron trabajan en profundización | Guías de refuerzo sobre los objetivos pendientes, con pistas diferenciadas por condición; evaluación del momento en versiones A y B | **Apto / No apto aún por objetivo mínimo**, con resultado aún provisorio: acredita lo alcanzado a la fecha y deja registrado qué sigue pendiente |
| **3. Instancia de diciembre** | Diciembre, finalizada la cursada (fuera de la estructura anual) | Quienes no alcanzaron los objetivos mínimos del ciclo | Camino mínimo completo del curso (U1 a U4) en dos encuentros de repaso guiado y evaluación | **Apto / No apto aún por objetivo mínimo** sobre el camino mínimo completo |
| **4. Instancia de marzo** | Marzo, antes del nuevo ciclo (fuera de la estructura anual) | Quienes no alcanzaron en diciembre y contaron con más tiempo de preparación | El mismo camino mínimo completo, con el **mismo estándar** de diciembre: no se baja la exigencia; cambia el tiempo disponible para prepararla | **Apto / No apto aún por objetivo mínimo**, idéntico criterio a diciembre |

Dos aclaraciones para familias y alumnos:

- Los momentos 17-18 y 34-35 son también de **profundización** para quienes ya alcanzaron los objetivos: no son instancias sancionatorias, sino tiempo de clase destinado a que nadie quede atrás.
- Diciembre y marzo evalúan el camino mínimo completo del curso, nada menos: acreditarlos exige lo mismo que acreditar la cursada (sección 6).

## 6. Criterio de aprobación de la cursada

La cursada de la asignatura queda **aprobada** cuando, en el registro docente del estudiante, se verifican juntas estas dos condiciones:

1. **Todos los objetivos mínimos de las cuatro unidades** (tabla de la sección 3) alcanzan el criterio de **Apto**, verificado en las evaluaciones de unidad, en los momentos especiales o en las instancias de diciembre/marzo.
2. **Las defensas individuales fueron presentadas** en los encuentros dedicados de evaluación (9, 15, 26 y 32): la defensa es la evidencia personal de comprensión del propio trabajo y no puede reemplazarse por la entrega grupal.

Si una defensa no pudo presentarse en su encuentro, los objetivos que ella acredita quedan pendientes y se recuperan por las capas de la sección 5, donde la defensa se presenta o se retoma. El resultado final se define por objetivos y no por promedios: no se usan escalas numéricas de aprobación. La rúbrica de 100 puntos corresponde únicamente al proyecto puente de los encuentros 19 y 20, como instrumento de valoración de esa instancia integradora.

## 7. Continuidad pedagógica y presentación individual

La continuidad pedagógica es parte del proceso de evaluación de la asignatura:

- Durante el año se utilizan **cuatro actividades de continuidad**: saberes previos (inicio del curso) y una tras cada evaluación de las unidades 1 a 3 (encuentros 9, 15 y 26), para uso en clases sin presencia docente.
- La resolución se realiza en forma habitual (por lo general, en grupo); las tareas de programación requieren el uso de la computadora.
- La **presentación es individual y manuscrita**, al inicio de la próxima clase, y constituye una actividad más de la asignatura que forma parte del proceso de evaluación.

La presentación manuscrita e individual cumple una función pedagógica precisa: evidencia lo que cada estudiante puede expresar por sí mismo, más allá del trabajo colaborativo de la clase, y alimenta el mismo registro por objetivos que el resto de las instancias.

## 8. Compromisos de la asignatura

La asignatura asume frente a alumnos y familias estos compromisos verificables:

| Compromiso | En qué consiste |
| --- | --- |
| **Devolución en el encuentro siguiente** | Cada evaluación se devuelve al inicio del encuentro siguiente (10, 16, 27 y 33), con el estado objetivo por objetivo y los núcleos a reforzar. |
| **Instancias de recuperación organizadas** | Ningún objetivo pendiente queda sin camino: devolución y reincorporación en clase, momentos especiales 17-18 y 34-35 dentro del ciclo, e instancias de diciembre y marzo con criterio conocido y anunciado de antemano. |
| **Trabajo grupal con recursos optimizados** | Los grupos se recalculan en cada encuentro según los presentes y los equipos disponibles (cantidad mínima posible), ningún equipo queda sin usar mientras haya alumnos sin equipo y los integrantes rotan para que todos pasen por todos los roles. |
