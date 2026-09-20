# Evaluación de la Unidad 3 — Integración de datos y publicación

> Encuentro 26, dedicado · Curso: Minimal API con C# .NET 6 · Documento de metadatos y acuerdos de la evaluación, en registro docente formal. Las consignas de los alumnos están en `evaluacion-u3-version-a.md` y `evaluacion-u3-version-b.md`; las soluciones y criterios de corrección, en los anexos docentes correspondientes.

## 1. Identificación

| Campo | Detalle |
| --- | --- |
| Instancia | Encuentro 26 — Evaluación de la Unidad 3 (encuentro dedicado) |
| Unidad | 3 — Integración de datos y publicación (encuentros 21 a 25) |
| Destinatarios | Todo el curso |
| Trabajo evaluado | `tp-u3` (entregado por GitHub al cierre del encuentro 25) |
| Modalidad | Verificación de entrega por GitHub + defensa individual + prueba práctica en versiones A y B equivalentes |
| Duración | 240 minutos: entrega y verificación 30 · defensa 90 · prueba A/B 90 · cierre 30 |
| Puntaje de la prueba | 100 puntos (valoración diagnóstica ítem a ítem) |
| Acreditación | Cualitativa, por objetivos mínimos de la Unidad 3 (`06-aprobacion/criterios-aprobacion.md`, sección 3): Apto / No apto aún |
| Uso de celular | No permitido en ningún momento del encuentro |
| Material consultable en la prueba | Solo el provisto con ella: enunciado, esqueleto de `Program.cs` y columnas de las tablas |

## 2. Estructura del encuentro

| Bloque | Tiempo | Qué ocurre |
| --- | --- | --- |
| 1. Entrega y verificación por GitHub | 30 min | Verificación en vivo del `tp-u3` de cada grupo en el repositorio: carpeta del trabajo, requisitos, commits y push. Registro docente de la entrega |
| 2. Defensa individual | 90 min | Cada integrante explica su parte del `tp-u3` y responde sobre los núcleos de la unidad. Se toma por turno mientras el curso resuelve la prueba |
| 3. Prueba práctica A/B | 90 min | Prueba individual con computadora, en la versión asignada (A o B), sobre `hospital.db` |
| 4. Cierre | 30 min | Últimas defensas y últimas pruebas, verificación de que toda la evidencia quedó registrada, anuncio de la devolución |

Los bloques 2 y 3 comparten los 180 minutos centrales: el curso resuelve la prueba práctica y el docente llama de a un alumno para su defensa, en un orden conocido de antemano. Ningún alumno rinde la prueba antes o después de su defensa: la secuencia por alumno queda registrada en la planilla.

## 3. Alcance de la evaluación

La evaluación recae sobre los núcleos de la Unidad 3. De las unidades anteriores se incluye únicamente lo estrictamente necesario para resolver la prueba (proyecto, conexión, parámetros y `Results`), que ya forma parte del canon de trabajo del curso.

| Núcleo de la Unidad 3 | Clase que lo construyó | Objetivo mínimo (criterios de aprobación) |
| --- | --- | --- |
| JOIN de tres tablas con alias calificados, DTO compuesto y endpoints con verificación de existencia (200/404) | 21 | U3-1: JOIN de tres tablas y endpoints compuestos |
| Agregaciones COUNT y AVG con GROUP BY, ORDER BY sobre el agregado | 22 | U3-2: reportes con agregaciones y GROUP BY |
| Subconsulta simple (escalar correlacionada) | 23 | U3-1/U3-3 (aporte conceptual) |
| Datos sucios: altas sin fecha (`IS NULL`, `COALESCE`) y altas imposibles (1971, previas al ingreso) | 23 | U3-3: tratar el dato sucio sin romper la consulta |
| Cadena de conexión en `appsettings.json` y publicación con `dotnet publish` | 24 | U3-4: configuración y publicación (se acredita en la defensa y en el `tp-u3`) |

Queda fuera de la prueba práctica: escritura (INSERT/UPDATE/DELETE, de la Unidad 2), HAVING y LIMIT parametrizados (extensión de la clase 22), el flujo profesional de repositorio (Unidad 4). La subconsulta se evalúa como ítem conceptual; su construcción práctica fue requisito de extensión del `tp-u3`.

## 4. Bloque 1 — Entrega y verificación por GitHub (30 min)

Verificación en vivo, grupo por grupo, sobre el repositorio único del grupo. El docente constata y registra:

| ✔ | Verificación | Fuente |
| --- | --- | --- |
| ☐ | La carpeta `tp-u3/` está en el repositorio, con el proyecto y `appsettings.json` | Clase 25, ciclo de entrega |
| ☐ | Los 5 requisitos de la consigna del `tp-u3` están presentes y compilan | Clase 25, sección 5 |
| ☐ | `bin/` y `obj/` no están versionados (`.gitignore` en la raíz) | Canon de entrega |
| ☐ | Historial con commits referentes por avance (`tp-u3: ...`) y push al día | Rutina desde el encuentro 5 |

Regla de entrega incompleta (`06-aprobacion/criterios-aprobacion.md`, sección 4): se evalúa lo presentado; los objetivos no alcanzados se marcan en el registro y guían la devolución y la recuperación. El repositorio permanece abierto para completar con nuevos commits.

## 5. Bloque 2 — Defensa individual del tp-u3 (90 min)

La defensa acredita la presentación individual (condición de aprobación de la cursada) y el objetivo U3-4. Duración referencial por alumno: 6 a 8 minutos dentro del turno.

**Recorrido de la defensa** (el mismo mapa de consolidación de la clase 25): cada integrante explica los requisitos del `tp-u3` que construyó, con el mapa requisito → clase, y justifica las decisiones de su código. El docente toma nota por objetivo.

**Preguntas núcleo de la defensa** (el docente elige tres o cuatro por alumno):

1. ¿Por qué la consulta está parametrizada y qué pasaría si concatenaras el valor?
2. ¿Qué hace tu endpoint con un id (o provincia) que no existe, y dónde está el corte?
3. En tu estadística: ¿qué agrupa el `GROUP BY` y qué calcula el agregado?
4. ¿Qué dato sucio elegiste tratar, con qué herramienta de la clase 23, y por qué?
5. ¿Dónde vive hoy la cadena de conexión y cómo la lee la API? (clase 24)
6. ¿Qué hace `dotnet publish -c Release` y qué tiene que viajar a la carpeta publish? (clase 24)

Registro de la defensa: Apto / No apto aún por los objetivos que ella acredita (U3-4 y evidencia complementaria de U3-1 a U3-3), con observación textual breve por alumno. La ausencia a la defensa deja los objetivos que ella acredita como pendientes, a recuperar por las capas de `criterios-aprobacion.md`.

## 6. Bloque 3 — Prueba práctica A/B (90 min)

Prueba individual con computadora. Consignas completas: `evaluacion-u3-version-a.md` y `evaluacion-u3-version-b.md`. La base `hospital.db` está provista en cada máquina; el alumno crea el proyecto con `dotnet new web`, agrega los paquetes, copia la base y pega el esqueleto provisto.

**Estructura idéntica en ambas versiones (100 puntos):**

| Parte | Contenido | Clase molde | Puntos |
| --- | --- | --- | --- |
| 1 | Endpoint compuesto con JOIN triple, con verificación de existencia: 200 con la lista o 404 con mensaje | 21 | 30 |
| 2 | Estadística con GROUP BY: COUNT y AVG en un mismo endpoint, con record propio | 22 | 25 |
| 3 | Manejo explícito de un dato sucio sobre los ingresos | 23 | 25 |
| 4 | Ítems conceptuales breves: parametrización, agregaciones, subconsulta | 22 y 23 | 20 |
| **Total** | | | **100** |

Tiempo sugerido: preparación del proyecto 10 · Parte 1, 30 · Parte 2, 20 · Parte 3, 20 · Parte 4, 10. La Parte 4 se responde por escrito en la hoja de la prueba. Al agotarse el tiempo, el `Program.cs` queda guardado en la carpeta indicada de la máquina y el docente lo verifica y registra in situ; la evidencia parcial alcanzada vale.

## 7. Criterios de calificación

Criterios comunes de corrección de la prueba (el desglose ítem por ítem está en cada anexo docente):

| Criterio | Qué se observa |
| --- | --- |
| Funcionalidad | Los endpoints responden lo pedido con el código de estado correcto, verificados en el navegador |
| Convenciones del curso | Rutas en inglés y plural, ids `long` (fechas `string` ISO), respuestas siempre con `Results`, records al final del archivo |
| Acceso a datos | Consultas siempre parametrizadas, alias `AS` en cada columna hacia el record, conexión con `using` dentro del handler, calificación de columnas en los JOIN |
| Robustez | Existencia verificada antes de consultar, 404 con mensaje en español, dato sucio tratado con la técnica pedida |
| Claridad | Código comentado; los nombres siguen las convenciones |

El puntaje de la prueba es valoración diagnóstica ítem a ítem. La acreditación de la unidad se registra cualitativamente por objetivos mínimos (Apto / No apto aún): la Parte 1 aporta evidencia a U3-1, la Parte 2 a U3-2, la Parte 3 a U3-3, la defensa y el `tp-u3` a U3-4. Los umbrales y las capas de recuperación son los de `06-aprobacion/criterios-aprobacion.md`.

## 8. Equivalencia entre las versiones A y B

- Misma estructura: mismas partes, mismos objetivos, mismos requisitos y mismo puntaje ítem por ítem (30/25/25/20).
- Distinto dominio: la versión A trabaja el dominio de las **especialidades** (`admissions` + `doctors`, con `patients` en el JOIN triple); la versión B el dominio de las **provincias** (`patients` + `province_names`, con `admissions` en el JOIN triple).
- Tratamiento del dato sucio análogo, con las dos técnicas de la clase 23: la versión A audita las **altas imposibles** (1971 o previas al ingreso); la versión B expone los **ingresos sin alta** (`IS NULL` con `COALESCE`). Mismo objetivo, misma dificultad, distinta técnica instanciada.
- Ninguna regla que una versión tenga y la otra no. El propósito es que la versión asignada no otorgue ventaja ni habilite la copia entre compañeros.

## 9. Asignación de versiones

- La versión (A o B) se asigna por posición en el aula o por grupo, según lo defina el docente al iniciar la prueba (por ejemplo, filas alternadas de máquinas).
- La asignación se comunica al comenzar y se registra en la planilla (alumno → versión).
- La prueba es individual: alumnos del mismo grupo de trabajo pueden tener versiones distintas; eso no afecta la prueba ni al grupo.

## 10. Devolución

- El encuentro 27 abre con la devolución de las tres instancias: verificación de la entrega, defensa y prueba, con comentario escrito individual y el estado objetivo por objetivo.
- Los objetivos no alcanzados activan la capa 1 de recuperación (reincorporación en las clases siguientes) y orientan la preparación del encuentro especial 34-35; el repositorio del grupo permanece abierto para completar el `tp-u3`.
- La planilla de resultados registra: alumno, versión (A o B), puntaje por parte y total de la prueba, resultado de la defensa y estado de cada objetivo mínimo de la unidad.
