# Intensificación y fortalecimiento de las Unidades 1 y 2 — Encuentros 17 y 18

## Metadatos

| Campo | Valor |
|---|---|
| Momento | Intensificación y fortalecimiento de las Unidades 1 y 2 — primera instancia |
| Encuentros | 17 y 18 |
| Duración | 2 encuentros × 240 min (480 min total) |
| Destinatarios | Totalidad del curso, con pistas diferenciadas por condición |
| Requisitos | Haber cursado las unidades 1 y 2; tener resueltos o intentados los TP-U1 y TP-U2; disponer de `hospital.db` |
| Lugar | Aula de informática con VS Code, SDK .NET 6, SQLite y Dapper instalados |

## Acuerdo pedagógico

| Dimensión | Grupo de intensificación (recuperación pedagógica) | Grupo de fortalecimiento (profundización) |
|---|---|---|
| **Contenidos** | U1: tipos y variables en C#, endpoint GET con `MapGet`, parámetros de ruta y query string. U2: conexión a SQLite con `Microsoft.Data.Sqlite`, consulta SELECT con Dapper `Query<T>`, mapeo a records. | U1: múltiples endpoints GET con lógica condicional, respuestas con `Results.Ok`/`Results.NotFound`, filtros combinados. U2: JOIN de 2 y 3 tablas, ORDER BY, consultas parametrizadas con LIKE, uso de `QueryFirstOrDefault`. |
| **Actividad / metodología** | Ejercicios guiados: crear un endpoint GET que devuelva pacientes desde SQLite con Dapper. Partir del `Program.cs` de la unidad y corregir errores comunes. | Desafíos autónomos: extender la API con endpoints de búsqueda por criterio, ordenar resultados por provincia, devolver JSON anidado con JOIN. |
| **Recursos** | VS Code, `hospital.db`, `dotnet new web`, Dapper NuGet, ejemplos resueltos de U1 y U2, guía de pasos para conectar SQLite. | VS Code, `hospital.db`, Thunder Client o curl, documentación de Dapper, consignas de desafío. |

## Desarrollo del Encuentro 17

### Apertura conjunta (20 min)

Plenaria: el docente recorre los núcleos de U1 y U2 mediante un mapa conceptual en el pizarrón. "De un lado, el endpoint que recibe la petición; del otro, la base de datos que responde. Dapper es el puente." Se asigna cada estudiante a su pista según el desempeño registrado en las evaluaciones de unidad.

### Pista intensificación (120 min + 80 min complementarios)

1. **(40 min)** Repaso de endpoint GET básico: `app.MapGet("/", ...)`, devolver string JSON. Ejercicio: crear un endpoint `/ping` que responda `{"status":"ok"}`.
2. **(40 min)** Conexión a SQLite desde C#: cadena de conexión, `SqliteConnection`, apertura y cierre. Ejercicio: ejecutar `SELECT COUNT(*) FROM Patients` y mostrar el resultado en consola.
3. **(40 min)** Dapper `Query<T>` con record `Patient`. Ejercicio: endpoint `/patients` que devuelva todos los pacientes como JSON.
4. **(80 min — complementario)** Agregar parámetro de ruta: `/patients/{id}` que devuelva un solo paciente o `404`.

### Pista fortalecimiento (120 min + 80 min complementarios)

1. **(35 min)** Endpoints con filtros: `/patients?province=Cordoba`. Implementar usando query string y Dapper con `WHERE`.
2. **(35 min)** JOIN: endpoint `/patients/details` que devuelva nombre del paciente y provincia mediante JOIN con `Provinces`. Mapear a record `PatientDetail` con alias en SQL.
3. **(50 min)** Consulta parametrizada con LIKE: `/patients/search?query=...` para buscar por alergias (`WHERE allergies LIKE @q`).
4. **(80 min — complementario)** Agregar ordenamiento: `/patients?sortBy=lastname&order=asc`. Combinar con filtro de provincia.

### Cierre conjunto (20 min)

Puesta en común: cada grupo muestra el endpoint más interesante que haya creado. El docente destaca la importancia de usar consultas parametrizadas para evitar SQL injection, y anuncia que en el próximo encuentro trabajarán con operaciones de escritura (POST).

---

## Desarrollo del Encuentro 18

### Apertura conjunta (20 min)

Repaso relámpago: el docente escribe en vivo un endpoint GET con parámetro de ruta y query string, y pregunta "¿Qué falta para que esta API sea completa?" (escribir, modificar, borrar). Se anticipa que ese será el contenido de la Unidad 3 y que hoy se consolidan los conceptos de GET con Dapper.

### Pista intensificación (120 min + 80 min complementarios)

1. **(40 min)** Consolidación de `Query<T>` con parámetros: endpoint `/patients/by-province/{provinceId}` que filtre por ID de provincia usando `new { ProvinceId = ... }`.
2. **(40 min)** Manejo de errores: `QueryFirstOrDefault` devuelve `null` cuando no hay resultados. Ejercicio: modificar `/patients/{id}` para que devuelva `Results.NotFound` si el paciente no existe.
3. **(40 min)** Repaso de JOIN simple: endpoint `/patients/with-province` que devuelva una lista con nombre de paciente y nombre de provincia (alias en SQL, mapeo a record con dos propiedades).
4. **(80 min — complementario)** Desafío guiado: endpoint `/provinces` que devuelva todas las provincias, y `/provinces/{id}/patients` que devuelva los pacientes de esa provincia.

### Pista fortalecimiento (120 min + 80 min complementarios)

1. **(40 min)** JOIN de 3 tablas: endpoint `/admissions/recent` que devuelva admisiones con nombre de paciente, diagnóstico y doctor mediante JOIN entre `Admissions`, `Patients` y `Doctors`. Mapeo con alias en cada columna.
2. **(40 min)** Agregación: endpoint `/stats/patients-by-province` que devuelva conteo de pacientes agrupado por provincia (`GROUP BY` con Dapper).
3. **(40 min)** Paginación con `LIMIT` y `OFFSET`: endpoint `/patients?page=1&size=10`. Implementar usando parámetros en Dapper.
4. **(80 min — complementario)** Desafío: endpoint `/doctors/{id}/patients` que devuelva los pacientes atendidos por un doctor específico, usando JOIN triple con `Admissions` como tabla puente.

### Cierre conjunto (20 min)

Plenaria final: el docente resume los patrones comunes — conexión, consulta, mapeo, respuesta — y muestra cómo varían poco entre GET, POST, PUT y DELETE. "Lo que cambia es el verbo HTTP y el comando SQL; la estructura del código se repite."

---

## Criterios de logro

| Condición | Criterio |
|---|---|
| Intensificación | El estudiante crea un endpoint GET que se conecta a SQLite, ejecuta una consulta SELECT con Dapper y devuelve los resultados como JSON. Maneja el caso de recurso no encontrado con `Results.NotFound`. Resuelve al menos 3 de los 4 ejercicios de cada encuentro. |
| Fortalecimiento | El estudiante implementa endpoints con JOIN de 2 o más tablas, filtros por query string con parámetros Dapper, y al menos una función de agregación o paginación. Resuelve los desafíos completos propuestos. |
| Ambos grupos | Participa de las plenarias de apertura y cierre, y puede explicar el rol de cada componente (endpoint, conexión, Dapper, record) en una consulta GET típica. |