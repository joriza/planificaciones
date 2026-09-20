# Evaluación de la Unidad 2 — Acceso a datos con SQLite y Dapper

> Evaluación del Encuentro 15 — encuentro dedicado · Curso: Minimal API con C# .NET 6. Documento de metadatos y acuerdos de la instancia, en registro docente formal. Se entrega a los alumnos junto con la versión asignada (A o B); los anexos docentes con soluciones van en archivos separados y no se entregan.

## 1. Identificación

| Campo | Detalle |
| --- | --- |
| Instancia | Encuentro 15 — Evaluación de la Unidad 2 (encuentro dedicado) |
| Destinatarios | Todo el curso |
| Unidad evaluada | Unidad didáctica 2: Acceso a datos con SQLite y Dapper |
| Modalidad | Entrega por GitHub + defensa individual del tp-u2 + prueba práctica individual con computadora en versiones A y B equivalentes |
| Duración | 240 minutos (encuentro teórico completo) |
| Puntaje de la prueba | 100 puntos (estructura ítem por ítem en cada versión) |
| Uso de celular | No permitido durante todo el encuentro |
| Material consultable | Solo el provisto con la prueba: enunciado, esqueleto de `Program.cs` y columnas de las tablas |
| Base de datos | `hospital.db` provista por el docente (copia nueva junto al esqueleto de cada versión) |
| Documentos de la instancia | `evaluacion-u2-version-a.md` · `evaluacion-u2-version-b.md` · un anexo docente separado por versión |

## 2. Estructura del encuentro (240 minutos)

| Bloque | Contenido | Tiempo |
| --- | --- | --- |
| 1 | Entrega y verificación por GitHub del tp-u2 | 30 min |
| 2 | Defensa individual del tp-u2 | 90 min |
| 3 | Prueba práctica individual en versiones A y B | 90 min |
| 4 | Cierre y registro de la instancia | 30 min |
| **Total** | | **240 min** |

**Bloque 1 — Entrega y verificación por GitHub (30 min).** Verificación de la entrega del tp-u2 realizada en el Encuentro 14, por grupo, contra el repositorio remoto: la carpeta `tp-u2/` con el proyecto (`Program.cs` y `hospital.db`), la API corre con `dotnet run`, los commits de avance con la convención `tp-u2: <resumen>` y el push terminado (la carpeta y su historial son visibles en GitHub web). Se consigna **entregado / pendiente** por grupo. Quien no completó el ciclo entrega igual lo que tenga: se evalúa lo presentado y se consignan los objetivos pendientes (regla de entrega incompleta de `06-aprobacion/criterios-aprobacion.md`).

**Bloque 2 — Defensa individual del tp-u2 (90 min).** Turno por alumno, con el tp-u2 del grupo en pantalla. El docente elige dos o tres endpoints del trabajo y cada estudiante explica: la consulta SQL de cada uno (qué tabla lee, qué filtra, qué ordena), por qué el valor viaja parametrizado, qué códigos de estado responde en cada camino y qué decisión tomó frente a los requisitos de la consigna. La defensa es **individual**: acredita comprensión personal del trabajo del grupo y no puede reemplazarse por la entrega. El resultado se registra por objetivo mínimo (Apto / No apto aún).

**Bloque 3 — Prueba práctica en versiones A y B (90 min).** Prueba individual con computadora, sobre la versión asignada: ejercicio pequeño que cubre los núcleos de la unidad (lectura por id, búsqueda con LIKE validada, JOIN de dos tablas, escritura validada e ítems conceptuales breves). Esqueleto de `Program.cs` y `hospital.db` provistos por el docente.

**Bloque 4 — Cierre y registro (30 min).** Registro de la planilla de la instancia (sección 12), comunicación al curso de la devolución (abre el Encuentro 16) y de los núcleos a reforzar en los encuentros de intensificación y fortalecimiento 17 y 18.

## 3. Objetivos evaluados

Sobre los objetivos mínimos de la Unidad 2 definidos en `06-aprobacion/criterios-aprobacion.md`:

1. Consultar `hospital.db` con Dapper: SELECT parametrizado con WHERE (y ORDER BY).
2. Búsqueda parcial con LIKE parametrizada, con validación manual y códigos 400 y 404.
3. Resolver un JOIN de dos tablas mapeado a un record compuesto.
4. Escritura validada: INSERT, UPDATE y DELETE parametrizados con códigos 201, 400 y 404.

De la Unidad 1 se evalúa solo lo estrictamente necesario: crear el proyecto con `dotnet new web`, verbos HTTP y códigos de respuesta. Se verifica además la entrega del tp-u2 por GitHub con commits y push (objetivo de entrega del trabajo).

## 4. Alcance de la instancia

| Unidad | Núcleos incluidos | Núcleos excluidos |
| --- | --- | --- |
| Unidad 2 | Conexión a `hospital.db`; SELECT con alias de columnas (`AS`); WHERE y ORDER BY; query string; búsqueda con LIKE y validación manual (400/404); JOIN de dos tablas con record compuesto; escritura parametrizada INSERT/UPDATE/DELETE con códigos 201/204/400/404 | Nada de la unidad queda fuera del alcance de la instancia |
| Unidad 1 (estrictamente necesario) | Crear el proyecto (`dotnet new web`), verbos HTTP y códigos de respuesta 200/201/400/404 | CRUD en memoria como tema propio (solo como repaso) |
| Unidades posteriores | — | JOIN de tres tablas, agregaciones y GROUP BY, subconsultas, datos sucios, `appsettings.json` y `dotnet publish` (Unidad 3) |

**Cobertura de la prueba práctica:** la prueba cubre SELECT con alias, WHERE/ORDER BY, query string, LIKE validado, JOIN de dos tablas e INSERT validado (201/400), más los ítems conceptuales de parametrización y alias. UPDATE y DELETE con 204/404 se verifican en la defensa del tp-u2 y quedan como alcance teórico de la unidad: pueden aparecer en las preguntas de defensa, no en la prueba escrita.

## 5. La prueba práctica (versiones A y B)

Ejercicio pequeño con computadora, de resolución individual, dentro del bloque de 90 minutos. Misma estructura, mismos requisitos y mismos puntos en ambas versiones; cambia el dominio de datos.

| Parte | Contenido | Puntos | Tiempo sugerido |
| --- | --- | --- | --- |
| Parte 1 | GET por id con parámetro de ruta (200 / 404 con mensaje) | 15 | 10 min |
| Parte 2 | Búsqueda con LIKE validada por query string `?text=` (400 si falta, 404 sin resultados, 200 con la lista) | 25 | 25 min |
| Parte 3 | JOIN de dos tablas mapeado a record compuesto | 25 | 25 min |
| Parte 4 | Escritura validada: INSERT parametrizado con 201 y 400 | 20 | 20 min |
| Parte 5 | Ítems conceptuales breves: parametrización y alias `AS` | 15 | 10 min |
| **Total** | | **100** | **90 min** |

| Versión | Dominio (tablas) | Búsqueda (Parte 2) | JOIN (Parte 3) |
| --- | --- | --- | --- |
| A | `doctors` + `admissions` | Médicos por especialidad (`GET /doctors/search?text=`) | Ingresos atendidos por un médico (`GET /doctors/{id:long}/admissions`) |
| B | `patients` + `province_names` | Pacientes por ciudad (`GET /patients/search?text=`) | Pacientes de una provincia (`GET /provinces/{provinceId}/patients`) |

Cada versión incluye el material provisto y las salidas esperadas de cada endpoint:

- **Esqueleto de `Program.cs`** con los `using`, la cadena de conexión y todos los records al final del archivo: no se modifican, solo se agregan los endpoints pedidos.
- **`hospital.db`** provista por el docente, para copiar junto al `.csproj`.
- **Columnas de las tablas** del dominio de la versión (nombres `snake_case` y tipos).
- **Salidas esperadas**: qué responde cada endpoint en el camino válido y en cada camino de error.

## 6. Condiciones de resolución

- Resolución estrictamente individual, con computadora.
- Sin celular en ningún momento del encuentro.
- Material consultable: únicamente el provisto con la prueba. No se consultan apuntes, repos propios, la web ni material de clases anteriores.
- La base `hospital.db` la provee el docente con la prueba: se copia junto al `.csproj` y no se modifica desde otro software.
- Todo el código va en `Program.cs` (endpoints y records provistos al final, sin moverlos).
- Convenciones obligatorias del curso: rutas en inglés y plural, ids `long`, fechas `string` ISO, respuestas siempre con `Results` (nunca el objeto crudo), consultas siempre parametrizadas.
- Entrega: al finalizar (o al agotarse el tiempo), el `Program.cs` queda guardado en la carpeta indicada de la máquina y el docente lo verifica y registra in situ. El tiempo agotado no invalida la prueba: se registra la evidencia parcial alcanzada.

## 7. Entrega por GitHub y defensa individual

**Verificación de la entrega (Bloque 1):**

| # | Verificación | Evidencia |
| --- | --- | --- |
| 1 | Carpeta `tp-u2/` en el repositorio del grupo, con el proyecto dentro | La carpeta y `Program.cs` son visibles en GitHub web |
| 2 | La API corre desde `tp-u2/` | `dotnet run` sin error |
| 3 | Commits de avance con la convención del curso | `git log --oneline` muestra la secuencia `tp-u2: <resumen>` |
| 4 | Push terminado, sin pendientes | `git status` limpio; historial en el remoto |

**Defensa individual (Bloque 2):** preguntas tipo: leer en voz alta el SQL de un endpoint y explicar qué hace; explicar por qué el valor va por `@parámetro` y no concatenado; recorrer los caminos de un endpoint de búsqueda (válido, 400, 404); justificar el código de estado de cada respuesta del tp; explicar el record compuesto del JOIN y sus alias. El docente registra por objetivo (U2.1 a U2.4): **Apto / No apto aún**. La presentación de la defensa en su encuentro es condición de acreditación de la cursada (`06-aprobacion/criterios-aprobacion.md`, sección 6); quien no la presente recupera por las capas de esa misma hoja.

## 8. Criterios de calificación

| Criterio | Qué se observa |
| --- | --- |
| Funcionalidad | Los endpoints responden lo pedido con el código de estado correcto, verificados en el navegador y con `curl` |
| Convenciones del curso | Rutas en inglés plural, ids `long`, `Results` explícito, records al final del archivo |
| Acceso a datos | Consultas SQL parametrizadas (nunca concatenadas), alias de columnas `snake_case` → `PascalCase`, conexión con `using` dentro del handler |
| Validación manual | Los datos requeridos se validan antes de responder; 400 y 404 con mensaje en español |
| Claridad | El código conserva comentarios; los nombres siguen las convenciones |

El resultado de la prueba se expresa sobre 100 puntos, con el desglose ítem por ítem que figura en cada versión (los criterios detallados de corrección están en el anexo docente de cada versión). Los umbrales de acreditación y las capas de recuperación son los de `06-aprobacion/criterios-aprobacion.md`: el resultado se define por objetivos, no por promedios.

## 9. Regla de equivalencia entre las versiones A y B

- Misma estructura: mismas partes, mismos objetivos, mismos requisitos y mismo puntaje ítem por ítem.
- Distinto dominio: la versión A trabaja sobre médicos e ingresos (tablas `doctors` y `admissions`); la versión B sobre pacientes y provincias (tablas `patients` y `province_names`).
- Ninguna regla que una tenga y la otra no: las diferencias de detalle son las que fija cada tabla y están declaradas en el enunciado de cada versión — los campos obligatorios de la escritura (tres en `doctors`, cinco en `patients`); el nombre del médico concatenado en el JOIN de la A frente a la columna simple de la B; el parámetro de ruta numérico de la A frente al código de texto de la B. La regla validada es idéntica en ambas: campos obligatorios no vacíos.
- El propósito de la equivalencia es que la versión asignada no otorgue ventaja ni habilite la copia entre compañeros.

## 10. Mecánica de asignación de versiones

- La versión (A o B) se asigna por posición en el aula o por grupo, según lo defina el docente al iniciar la prueba (por ejemplo, filas alternadas de máquinas).
- La asignación se comunica al comenzar y se registra en la planilla de resultados (alumno → versión).
- La prueba es individual: alumnos de un mismo grupo de trabajo pueden tener versiones distintas; eso no afecta la prueba ni el grupo.

## 11. Devolución

- La devolución abre el **Encuentro 16** (cierre integrador del cuatrimestre 1): corrección escrita individual de la prueba ítem por ítem, resultado de la defensa por objetivo y estado de la entrega del tp-u2.
- Los núcleos no alcanzados se traducen en pistas de recuperación para los encuentros de intensificación y fortalecimiento 17 y 18, con resultado aún provisorio de Apto o No apto (`06-aprobacion/criterios-aprobacion.md`, capas 1 y 2).

## 12. Registro de la instancia

Planilla de resultados del encuentro, una fila por alumno:

| Columna | Contenido |
| --- | --- |
| Alumno / Grupo | Identificación y grupo de trabajo |
| Versión | A o B asignada |
| Entrega tp-u2 | Entregado / pendiente, con observación de lo faltante |
| Defensa | Objetivos U2.1 a U2.4: Apto / No apto aún |
| Prueba — Partes 1 a 5 | Puntaje por parte (15 / 25 / 25 / 20 / 15) |
| Total prueba | Sobre 100 |
| Observaciones | Núcleos a reforzar para las intensificaciones 17-18 |

La planilla alimenta la devolución del Encuentro 16, los encuentros de intensificación y fortalecimiento 17-18 y el registro anual de objetivos por estudiante.
