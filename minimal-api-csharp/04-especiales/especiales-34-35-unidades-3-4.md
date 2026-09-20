# Encuentros especiales 34 y 35 — Recuperación y profundización de las Unidades 3 y 4

> Momento especial diferenciado del curso **Minimal API con C# .NET 6**: dos pistas en paralelo (recuperación y profundización) con plenarias conjuntas de apertura y cierre. No imparte contenido nuevo. La evaluación del momento, en versiones A y B equivalentes, está en `evaluaciones/evaluacion-especiales-34-35.md`.

## 1. Metadatos del momento

| Campo | Detalle |
| --- | --- |
| Momento | Encuentros 34 y 35 — Recuperación y profundización de las Unidades 3 y 4 |
| Cuándo | Inmediatamente después del cierre integrador del cuatrimestre 2 (Encuentro 33) |
| Duración | 2 encuentros de 240 minutos (4 horas reloj) cada uno |
| Destinatarios | Todo el curso, organizado por condición en dos pistas: **grupo de recuperación (intensificación)**, con objetivos mínimos de las Unidades 3 y 4 No apto aún según el registro del año (evaluaciones de los Encuentros 26, 32 y 33); **grupo de profundización (fortalecimiento)**, con los objetivos mínimos Apto |
| Requisitos | Registro de resultados de las evaluaciones de la Unidad 3, de la Unidad 4 y del cierre cuatrimestral para definir la condición de cada estudiante; VS Code y SDK de .NET 6 instalados y verificados; archivo `hospital.db` (lo distribuye el docente); repositorio de GitHub del grupo al día (tp-u3 y trabajo-final), con `main` protegida y cada alumno como colaborador |
| Lugar de trabajo | Aula-taller del curso, una PC por grupo de trabajo |
| Uso de celular | No permitido en ningún momento de los dos encuentros |
| Registro | Resultados de la evaluación del momento en registro docente formal; materiales de las pistas en registro didáctico |
| Organización del trabajo | Grupos: alumnos presentes ÷ equipos disponibles (mínimo posible); ningún equipo queda sin usar; rotación de integrantes en cada bloque |

## 2. Acuerdo pedagógico

El acuerdo se documenta por grupo de condición. Las dos pistas trabajan los **mismos núcleos de las Unidades 3 y 4**: ninguna pista introduce contenido nuevo del curso (no hay unidad siguiente que adelantar).

### Grupo de recuperación (intensificación)

| Componente | Acuerdo |
| --- | --- |
| Contenidos mínimos irrenunciables | **Unidad 3:** JOIN de tres tablas (`admissions` + `patients` + `doctors`, con alias `AS` y record compuesto); estadística con GROUP BY (COUNT y AVG, ORDER BY sobre el agregado, tipos correctos para conteo y promedio); detección de dato sucio (valores NULL, errores de tipeo, fechas imposibles) con respuesta sin 500; configuración de la cadena de conexión en `appsettings.json` y publicación con `dotnet publish`, corriendo en release. **Unidad 4:** flujo profesional completo (issue con criterios de aceptación → rama `feature/<tema>` → commits `(#N)` → push → pull request revisado → `main` protegida) y README de portada del repositorio (descripción, integrantes y tabla de endpoints) |
| Actividad y metodología acordada (ultra-condensada) | Repaso dirigido núcleo por núcleo con la guía condensada: ejemplo mínimo del docente, reconstrucción guiada del mismo endpoint por los alumnos y mini-ejercicio de un solo paso verificado antes de avanzar. Cada núcleo cierra con un commit referente en la rama `recuperacion/u3-u4` del grupo. Batería mínima de pruebas con navegador y `curl`, verificando el código de cada respuesta. El segundo encuentro abre con un recorrido integrado de ensayo que encadena los cuatro núcleos de la Unidad 3, y cierra con la evaluación del momento |
| Recursos acordados (condensado al 25%) | Guía única de repaso con los pasos mínimos de cada núcleo (equivale a una selección de una cuarta parte del material de las clases 21 a 24 y 27 a 29), cuadro de referencia rápida de `Results` y códigos de respuesta, y checklist del flujo issue → rama → PR. Sin material adicional: el molde canónico es el único insumo de código |

### Grupo de profundización (fortalecimiento)

| Componente | Acuerdo |
| --- | --- |
| Contenidos de profundización | Ampliación sobre los contenidos regulares, sin introducir contenido nuevo: **endpoint estadístico adicional con subconsulta simple sobre el trabajo final** (comparar cada grupo con un total ya conocido, por ejemplo especialidades con más ingresos que el promedio general, reutilizando la subconsulta vista en la clase 23); **mejora del README de portada** con un ejemplo `curl` completo por endpoint del trabajo final, incluyendo sus casos 200, 400 y 404; **refinamiento de la protección del repositorio** (reglas de protección de `main`, plantilla de pull request y checklist de revisión entre pares) |
| Actividad y metodología acordada (ultra-condensada) | Los tres desafíos se gestionan sobre el repositorio del grupo con el flujo profesional completo: issue con criterios de aceptación, rama `feature/<tema>`, commits que referencian el issue y pull request para revisión cruzada entre pares con checklist antes del merge. Cada desafío incluye su caso de prueba esperado (pedido y respuesta). El segundo encuentro cierra los pull requests pendientes y verifica el conjunto con una demo breve |
| Recursos acordados (condensado al 25%) | Hoja de desafíos con el criterio de aceptación de cada issue y su caso de prueba (una cuarta parte del volumen habitual de material práctico), checklist de revisión de pull requests y la documentación del propio trabajo final (README, issues y tablas de endpoints). Sin material adicional |

### Condiciones comunes a las dos pistas

- Sin contenido nuevo: lo que se recupera o profundiza ya fue enseñado en los Encuentros 21 a 31.
- Plenarias conjuntas de apertura y cierre en cada encuentro; los bloques de trabajo corren en paralelo.
- Rotación de integrantes en el trabajo grupal según los presentes y los equipos disponibles.
- Uso de celular no permitido; la gestión de issues y pull requests se hace desde el navegador de la PC del grupo.

## 3. Objetivos mínimos del momento

Esta tabla es la referencia común de las dos pistas y de la evaluación del momento (versión A/B). El criterio de logro es **Apto / No apto aún por objetivo mínimo**.

| Nº | Objetivo mínimo | Unidad | Criterio de Apto |
| --- | --- | --- | --- |
| OM1 | JOIN triple: construir endpoints con JOIN de tres tablas (`admissions` + `patients` + `doctors`) sobre `hospital.db`, con alias `AS` por columna, record compuesto y verificación de existencia con 404 | U3 | El `ON` empareja las claves correctas; el record compuesto se serializa a JSON; un id inexistente responde `404` con mensaje sin ejecutar la consulta principal |
| OM2 | Estadística con GROUP BY: agrupar con GROUP BY y COUNT/AVG, mapear el conteo a `int` y el promedio a `double`, y ordenar por el agregado | U3 | La consulta agrupa por la columna correcta; los tipos del record son correctos; el orden queda definido por el agregado |
| OM3 | Dato sucio: detectar valores NULL, errores de tipeo y fechas imposibles, y responder sin 500 con validación manual y mensajes en español | U3 | Los casos sucios provistos responden 400 o 404 con mensaje, nunca 500; el criterio de detección queda explicado |
| OM4 | Configuración y publicación: mover la cadena de conexión a `appsettings.json`, publicar con `dotnet publish` y ejecutar en release | U3 | La API corre desde el binario publicado apuntando a la misma base; el commit de evidencia queda en el repositorio |
| OM5 | Flujo profesional: sostener issue con criterios de aceptación, rama `feature/<tema>`, commits `(#N)`, push, pull request revisado y `main` protegida | U4 | La secuencia completa queda visible en GitHub, con criterios verificables en el issue y el PR abierto sin fusionar |
| OM6 | README de portada: mantener el README del repositorio con descripción del proyecto, integrantes y tabla de endpoints con sus códigos de respuesta | U4 | El README existe, refleja el trabajo final y su tabla de endpoints está actualizada |

## 4. Desarrollo del Encuentro 34

Agenda del momento especial: plenaria de apertura (20 min), bloque 1 (90 min), bloque 2 (90 min) y plenaria de cierre (40 min). Las dos pistas corren en paralelo durante los bloques.

| Bloque | Tiempo | Pista recuperación (intensificación) | Pista profundización (fortalecimiento) |
| --- | --- | --- | --- |
| Plenaria de apertura (conjunta) | 20 min | Encuadre del momento: lectura de la tabla de objetivos mínimos, devolución general del cierre cuatrimestral (Encuentro 33), condiciones de la evaluación del Encuentro 35 y conformación de las dos pistas según el registro | Misma plenaria |
| Bloque 1 (paralelo) | 90 min | Núcleos de la Unidad 3, parte 1: JOIN triple con alias y record compuesto (`admissions` + `patients` + `doctors`) y estadística con GROUP BY (COUNT/AVG, orden por el agregado). Reconstrucción guiada + mini-ejercicios verificados, un commit por núcleo en la rama `recuperacion/u3-u4` | Desafío 1: endpoint estadístico con subconsulta simple sobre el trabajo final (issue con criterios de aceptación, rama `feature/estadistica-<tema>`, desarrollo y pull request abierto para revisión) |
| Bloque 2 (paralelo) | 90 min | Núcleos de la Unidad 3, parte 2: detección de los casos sucios provistos (NULL, tipeos, fechas imposibles) y ajuste de validaciones y respuestas; cadena de conexión en `appsettings.json`, `dotnet publish` y corrida en release ante el docente. Commit de cierre del bloque | Desafíos 2 y 3: README de portada con un ejemplo `curl` por endpoint (200, 400 y 404) y refinamiento de la protección del repositorio (reglas de `main`, plantilla de pull request y checklist de revisión), por issue, rama y pull request |
| Plenaria de cierre (conjunta) | 40 min | Puesta en común: cada pista muestra un producto (un endpoint funcionando / el desafío más interesante). Registro docente de avance por objetivo mínimo y ajustes para el Encuentro 35 | Misma plenaria |

## 5. Desarrollo del Encuentro 35

Misma agenda: 20/90/90/40. Este encuentro cierra con la **evaluación del momento en versiones A y B**.

| Bloque | Tiempo | Pista recuperación (intensificación) | Pista profundización (fortalecimiento) |
| --- | --- | --- | --- |
| Plenaria de apertura (conjunta) | 20 min | Retomar el registro de avance del Encuentro 34; condiciones de la evaluación del bloque 2; preparación del ambiente de trabajo (VS Code, terminal, `hospital.db`, sesión de GitHub del grupo) | Misma plenaria |
| Bloque 1 (paralelo) | 90 min | Recorrido integrado de ensayo, cronometrado y con guía: encadena los cuatro núcleos de la Unidad 3 (JOIN triple → estadística → caso de dato sucio → publish) replicando la estructura de la prueba; corrección dirigida de los pendientes que el ensayo detecte | Cierre de los pull requests abiertos: revisión cruzada entre pares con checklist, correcciones, merge aprobado, actualización del README y demo breve de los endpoints nuevos |
| Bloque 2 | 90 min | **Evaluación del momento especial en versiones A y B**: ejercicio práctico individual con computadora sobre `hospital.db` + flujo issue → rama → PR. Rinden todos los presentes, cualquiera sea su pista | Misma evaluación |
| Plenaria de cierre (conjunta) | 40 min | Plenaria conjunta de cierre del momento: verificación y registro por objetivo mínimo (Apto / No apto aún), comunicación individual del resultado preliminar, acuerdos de continuidad para los objetivos pendientes y proyección hacia el Encuentro 36 | Misma plenaria |

La revisión docente de los pull requests de la evaluación es la devolución escrita del flujo profesional; el resultado formal por objetivo queda en el registro docente.

## 6. Criterios de logro del momento

| Objetivo mínimo | Apto | No apto aún |
| --- | --- | --- |
| OM1 a OM6 (tabla de la sección 3) | El estudiante cumple el criterio de Apto del objetivo: OM1, OM2 y OM5 se observan directamente en la evaluación del momento; OM3 se observa en la evaluación y se completa con la evidencia de los bloques; OM4 y OM6 se acreditan con la evidencia de los bloques y del repositorio al cierre del Encuentro 35 | El objetivo queda pendiente y se retoma en las instancias de intensificación posteriores a la cursada (diciembre y, de ser necesario, marzo) |

El resultado del momento es **aún provisorio**: acredita los objetivos mínimos de las Unidades 3 y 4 alcanzados a la fecha y deja registrado, objetivo por objetivo, qué continúa pendiente. No recalifica las evaluaciones del año ni reemplaza al Encuentro 36 de cierre integral.

## 7. Evaluación del momento

- La evaluación del momento especial se aplica en el **bloque 2 del Encuentro 35** (90 minutos de resolución); la revisión de los pull requests y el registro ocurren en la plenaria de cierre.
- Es un ejercicio práctico individual con computadora sobre `hospital.db`, con **flujo issue → rama → pull request**, en **versiones A y B equivalentes**: mismos objetivos, misma estructura, mismas reglas, distinto dominio y distinto núcleo central.
- Criterio de resultado: **Apto / No apto aún por objetivo mínimo** (tabla de la sección 3). No hay puntaje numérico.
- Documentos: `evaluaciones/evaluacion-especiales-34-35.md` (base), `evaluaciones/evaluacion-especiales-34-35-version-a.md`, `evaluaciones/evaluacion-especiales-34-35-version-b.md` y el anexo docente con las soluciones y los criterios por objetivo.
