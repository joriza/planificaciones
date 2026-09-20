# Momento integrador de las Unidades 1 y 2 (proyecto puente) — Encuentros 19 y 20

## Metadatos

| Campo | Valor |
|---|---|
| Momento | Proyecto puente integrador de las Unidades 1 y 2 |
| Encuentros | 19 y 20 |
| Duración | 2 encuentros × 240 min (480 min total) |
| Destinatarios | Totalidad del curso (una sola pista) |
| Requisitos | Haber completado los TP-U1 y TP-U2; tener `hospital.db` funcional; conocer endpoints GET y consultas Dapper básicas |
| Lugar | Aula de informática con VS Code, SDK .NET 6, SQLite, Dapper, Thunder Client o curl |

## Acuerdo pedagógico

| Dimensión | Única pista para todo el curso |
|---|---|
| **Contenidos** | Proyecto integrador que articula: endpoint GET con parámetros de ruta y query (U1), conexión a SQLite con Dapper (U2), JOIN entre tablas, consultas parametrizadas, mapeo a records, respuestas HTTP con `Results.Ok` y `Results.NotFound`. |
| **Actividad / metodología** | Construcción progresiva de una API de consulta sobre `hospital.db` que expone múltiples endpoints. Encuentro 19: diseño y endpoints base. Encuentro 20: endpoints avanzados y cierre con entrega. Trabajo individual con revisión entre pares. |
| **Recursos** | VS Code, `hospital.db`, `dotnet new web`, Dapper NuGet, consigna del proyecto puente impresa, rúbrica de evaluación (100 pts). |

## Criterios de evaluación — rúbrica (100 puntos)

| Dimensión | Puntaje | Indicadores |
|---|---|---|
| Endpoints GET base | 30 pts | Implementa `/patients`, `/patients/{id}` con manejo de `404`. Funcionan correctamente. |
| Consultas Dapper con JOIN | 25 pts | Endpoint `/patients/with-province` con JOIN, mapeo a record con alias. Resultados correctos. |
| Parámetros y filtros | 20 pts | Al menos un endpoint con parámetro de query string (`?province=...` o `?search=...`) usando parámetros Dapper. |
| Calidad del código | 15 pts | Nombres descriptivos, `using` correctos, `Program.cs` legible, consultas parametrizadas (sin concatenación SQL). |
| Entrega y defensa | 10 pts | Repositorio GitHub actualizado, commit con el proyecto, breve explicación oral de cada endpoint. |

---

## Desarrollo del Encuentro 19

### Apertura (20 min)

El docente presenta el proyecto puente: "Van a construir una API que consulte la base `hospital.db` desde múltiples ángulos. No es un TP nuevo: es juntar lo que ya saben de U1 y U2 en una sola aplicación." Se entrega la consigna impresa y se explica la rúbrica de 100 puntos. Cada estudiante crea su proyecto (`dotnet new web`) y restaura los paquetes Dapper y SQLite.

### Desarrollo (120 min + 80 min complementarios)

1. **(30 min)** Conexión a SQLite y primer endpoint. Configurar cadena de conexión en `Program.cs`. Endpoint `/patients` que devuelva todos los pacientes con Dapper `Query<Patient>`.
2. **(30 min)** Endpoint `/patients/{id}` que devuelva un solo paciente con `QueryFirstOrDefault` y `Results.NotFound` si no existe.
3. **(30 min)** Endpoint `/patients/with-province` con JOIN entre `Patients` y `Provinces`. Mapear a record `PatientWithProvince` con alias en SQL.
4. **(30 min)** Probar los tres endpoints con Thunder Client o curl. Verificar respuestas JSON y códigos HTTP.
5. **(80 min — complementario)** Agregar endpoint `/patients/search?q=...` que busque por apellido o alergia con LIKE y parámetros Dapper.

### Cierre (20 min)

Puesta en común de pantallas. El docente revisa que cada estudiante tenga los tres endpoints base funcionando. Sugiere mejoras para el próximo encuentro: ordenar resultados, agregar más filtros.

---

## Desarrollo del Encuentro 20

### Apertura (20 min)

Repaso de los endpoints creados en el encuentro anterior. El docente muestra una versión mejorada que incluye paginación y comenta que hoy se agregan los endpoints de agregación que completan el proyecto puente.

### Desarrollo (120 min + 80 min complementarios)

1. **(30 min)** Endpoint de conteo: `/stats/patients-by-province` que devuelva nombre de provincia y cantidad de pacientes usando `GROUP BY` y `COUNT(*)`.
2. **(30 min)** Endpoint `/patients/by-province/{provinceId}` que filtre pacientes por provincia usando JOIN con parámetro.
3. **(30 min)** Endpoint `/doctors` simple (desde `Doctors`, sin JOIN) para mostrar versatilidad de Dapper con distintas tablas.
4. **(30 min)** Integración final: verificar que todos los endpoints funcionan, revisar que no haya concatenación SQL, que los `using` estén en orden, que el código use `var` y records donde corresponda.
5. **(80 min — complementario)** Mejora opcional: agregar un endpoint `/patients?sort=lastname&order=asc` con paginación (`page`, `size`). Punto extra sobre 100 si funciona correctamente.

### Cierre con entrega (20 min)

Cada estudiante sube el proyecto a GitHub (mismo repo del curso o repo específico para el proyecto puente). El docente verifica el commit más reciente. Se realiza una defensa breve: cada estudiante explica un endpoint y cómo maneja el caso de datos no encontrados. El docente recoge la rúbrica completa para la evaluación.

---

## Criterios de logro

| Condición | Criterio |
|---|---|
| Aprobado (≥ 60 pts) | Los endpoints base funcionan, la consulta JOIN devuelve datos correctos, no hay SQL injection detectable, el repositorio tiene el código completo. |
| Destacado (≥ 85 pts) | Cumple los criterios anteriores e incorpora al menos una mejora opcional (filtro por query string, paginación o endpoint adicional con JOIN complejo) con código limpio y bien comentado. |
| No aprobado (< 60 pts) | Falta alguno de los endpoints base, hay errores de conexión o mapeo, o el código contiene concatenación SQL. El estudiante pasa al grupo de intensificación en los momentos siguientes. |