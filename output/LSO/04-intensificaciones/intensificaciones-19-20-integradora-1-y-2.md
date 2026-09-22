# Proyecto puente integrador de las Unidades 1 y 2 — Encuentros 19 y 20

## Metadatos

| Campo | Valor |
|---|---|
| Momento | Proyecto puente integrador de las Unidades 1 y 2 |
| Encuentros | 19 y 20 |
| Duración | 2 encuentros × 240 min (4 horas reloj cada uno) |
| Destinatarios | Totalidad del curso (una sola pista) |
| Requisitos | Haber completado los TP-U1 y TP-U2; tener el repo grupal clonado con los dos TP commiteados; conocer tipos C#, endpoint GET, conexión a SQLite y consultas Dapper básicas |
| Lugar | Aula de informática con VS Code, terminal, hospital.db y repo grupal GitHub |
| Uso de celular | No permitido |

## Acuerdo pedagógico

| Dimensión | Única pista para todo el curso |
|---|---|
| **Contenidos** | Proyecto integrador (Minimal API) que articula: tipos C# (`long`, `string`, `string?`), endpoint GET con `MapGet`, conexión a SQLite (`Data Source=hospital.db`), consultas Dapper parametrizadas (`Query<T>`, `QueryFirstOrDefault<T>`), JOIN de 2 tablas con alias `AS`, y respuestas HTTP con `Results.Ok`/`Results.NotFound`/`Results.BadRequest`. Dominio: sistema de gestión de admisiones hospitalarias (pacientes, doctores, admisiones). |
| **Actividad / metodología** | Construcción progresiva del proyecto (Minimal API completa que consulta `hospital.db`). Encuentro 19: consigna, planificación grupal y primera parte con commits. Encuentro 20: finalización, puesta en común y cierre con defensa. Trabajo individual con revisión entre pares. |
| **Recursos** | VS Code, terminal, `hospital.db` copiado al lado del `.csproj`, repo grupal clonado, consigna del proyecto puente impresa con rúbrica de 100 puntos, ejemplos resueltos de U1 y U2, convenciones técnicas del curso a la mano. |

## Criterios de evaluación — rúbrica (100 puntos)

| Dimensión | Puntaje | Indicadores |
|---|---|---|
| Endpoint GET con parámetros de ruta y query | 20 pts | Usa `MapGet` con parámetro de ruta (`:long`) y/o query. Conecta a `hospital.db` con Dapper. Devuelve 200 con datos o 404 si no existe. |
| Consulta con JOIN de 2 tablas y alias `AS` | 25 pts | Escribe un SELECT con JOIN entre dos tablas, usa alias `AS` para cada columna, y mapea con `Query<T>` o `QueryFirstOrDefault<T>`. |
| Parámetros y LIKE | 15 pts | Usa consultas parametrizadas (`@id`, `@name`) con `new { id }` / `new { name }`. Implementa LIKE para búsqueda parcial. |
| Respuestas HTTP correctas | 15 pts | Usa `Results.Ok`, `Results.NotFound`, `Results.BadRequest` con `new { mensaje = "..." }` en español. No devuelve objetos crudos. |
| Código y estructura | 10 pts | Un único `Program.cs`, records posicionales después de `app.Run()`, `using` en la conexión, identificadores en inglés y plurales. |
| Entrega y defensa | 15 pts | Repositorio GitHub actualizado con commit del proyecto. Breve explicación oral del proyecto y las decisiones tomadas. |

---

## Desarrollo del Encuentro 19

### Apertura (15 min)

El docente presenta el proyecto puente: "Van a construir una Minimal API que conecte a la base de datos `hospital.db` y exponga endpoints que devuelvan datos reales. No es un TP nuevo — es integrar todo lo que ya saben de U1 y U2 en un solo proyecto. No usamos archivos ni persistencia adicional — todo se hace contra la base de datos." **No se permite celular.** Se entrega la consigna impresa y se explica la rúbrica de 100 puntos.

### Desarrollo — Bloque 1: Consigna y planificación (55 min)

1. **(10 min)** Lectura colectiva de la consigna. El docente aclara el alcance: el proyecto debe ofrecer al menos tres endpoints:
   - `GET /patients/{id:long}` — obtener un paciente por ID (con JOIN a provinces para incluir el nombre de la provincia)
   - `GET /patients/search?name=...` — buscar pacientes por nombre parcial (con LIKE)
   - `GET /admissions/{id:long}` — obtener una admisión con los datos del paciente y el doctor (con triple JOIN)
2. **(15 min)** Planificación en parejas: cada estudiante diagrama la estructura del proyecto (records necesarios, endpoints a crear, consultas SQL con alias `AS`). Se revisan los nombres de los records y se verifica que coincidan con los tipos canónicos.
3. **(30 min)** Puesta en común de los diagramas. El docente valida y sugiere los nombres de records: `Patient`, `PatientWithProvince`, `AdmissionDetail`. Se define la estructura de datos y se repasa la cadena de conexión `"Data Source=hospital.db"`.

### Desarrollo — Bloque 2: Endpoint GET con ruta y JOIN (55 min)

1. **(15 min)** Implementar `GET /patients/{id:long}`: conexión a `hospital.db`, SELECT con JOIN a provinces, alias `AS` para cada columna, `QueryFirstOrDefault<PatientWithProvince>`, devolver 404 si no existe. El docente modela el primer endpoint en vivo.
2. **(15 min)** Implementar `GET /patients/search?name=...`: conexión a `hospital.db`, SELECT con LIKE, `Query<Patient>`, devolver lista vacía si no hay coincidencias (200 con lista vacía, no 404). El docente verifica cada endpoint.
3. **(15 min)** Probar ambos endpoints con `curl` o Thunder Client. Verificar que los tipos se mapean correctamente (`long` para IDs, `string` para nombres, `string?` para campos nullable).
4. **(10 min)** Commit parcial: `git add .`, `git commit -m "feat: endpoints GET patients con JOIN y LIKE"`, `git push`. El docente verifica los commits en GitHub.

### Cierre (15 min)

Puesta en común de pantallas: el docente verifica que cada estudiante tenga los dos primeros endpoints funcionando. Revisa commits en GitHub. Anticipa las opciones del próximo encuentro (endpoint de admisiones con triple JOIN) y recuerda que el proyecto se completa en el E20 con la defensa oral.

### Errores comunes y trampas

1. **No usar alias `AS` en el SELECT del JOIN.** Causa: `InvalidOperationException`: Dapper busca constructor con parámetros `patient_id` y `province_id` en lugar de `PatientId` y `ProvinceId`. Fix: usar `SELECT patient_id AS PatientId, provinces.name AS ProvinceName`.
2. **Usar `int` en lugar de `long` para la clave primaria.** Causa: `InvalidOperationException`: Dapper espera `Int64` para columnas INTEGER de SQLite. Fix: usar `long` en todos los records.
3. **Concatenar el parámetro de búsqueda al SQL en lugar de usar LIKE con parámetro.** Causa: riesgo de inyección SQL y errores de sintaxis. Fix: usar `WHERE first_name LIKE @name` con `new { name = $"%{query}%" }`.
4. **Devolver un objeto crudo sin envolver en `Results`.** Causa: viola la convención del curso y puede generar serialización inesperada. Fix: envolver siempre con `Results.Ok()`, `Results.NotFound()`, etc.
5. **No cerrar la conexión con `using`.** Causa: la conexión no se cierra y puede agotar el pool de SQLite. Fix: usar `using var connection = new SqliteConnection(...)` dentro del bloque del endpoint.

---

## Desarrollo del Encuentro 20

### Apertura (15 min)

Repaso de lo creado en el encuentro anterior. El docente muestra una versión completa del proyecto en el proyector y recorre los endpoints que faltan. Recuerda que hoy se finaliza el proyecto puente, se hace la puesta en común y la defensa. **No se permite celular.**

### Desarrollo — Bloque 3: Endpoint de admisiones con triple JOIN (55 min)

1. **(15 min)** Implementar `GET /admissions/{id:long}`: conexión a `hospital.db`, SELECT con triple JOIN (admissions → patients → doctors), alias `AS` para cada columna, `QueryFirstOrDefault<AdmissionDetail>`, devolver 404 si no existe. El docente modela el endpoint en vivo.
2. **(15 min)** Verificar que el record `AdmissionDetail` tenga los tipos canónicos correctos (`long` para IDs, `string` para textos, `string?` para nullable). El docente recorre el aula y verifica cada implementación.
3. **(15 min)** Probar el endpoint con `curl` o Thunder Client para tres casos: admisión existente, admisión inexistente (debe devolver 404), y admisión con datos de paciente y doctor completos.
4. **(10 min)** Commit parcial: `git add .`, `git commit -m "feat: endpoint GET admissions con triple JOIN"`, `git push`. El docente verifica los commits en GitHub.

### Desarrollo — Bloque 4: Pulido, README y entrega (55 min)

1. **(15 min)** Pulido del código: verificar que todos los endpoints usen tipos canónicos, alias `AS`, parámetros parametrizados y respuestas `Results.*`. Agregar comentarios útiles en español. Eliminar código muerto o duplicado.
2. **(15 min)** README de portada: crear `README.md` en la raíz del repo con título ("Minimal API Hospital — Proyecto Puente U1+U2"), descripción, tecnologías (C# .NET 6, Dapper, SQLite), cómo ejecutar (`dotnet run`, `curl`) y ejemplo de uso para cada endpoint.
3. **(15 min)** Commit final y push: `git add .`, `git commit -m "feat: proyecto puente U1+U2 completo con README"`, `git push`. Cada estudiante verifica que GitHub muestre el archivo `Program.cs` y el `README.md` correctamente.
4. **(10 min)** Preparación de la defensa: cada estudiante prepara una breve explicación (2-3 minutos) de su proyecto: qué hace, cómo conecta U1 y U2, y una decisión de diseño que tomó.

### Cierre con defensa (15 min)

El docente recorre los puestos y cada estudiante explica brevemente:
- Qué hace el proyecto
- Cómo conecta los conocimientos de U1 (endpoints Minimal API) y U2 (consultas Dapper a SQLite)
- Una consulta con JOIN que le haya costado más y cómo la resolvió
- Cómo validó que los tipos se mapean correctamente (`long` para INTEGER, `string` para TEXT)

El docente registra los puntajes parciales en la rúbrica de 100 puntos. Entrega el resultado al final del encuentro.

### Errores comunes y trampas

1. **No usar alias `AS` en el SELECT del triple JOIN.** Causa: `InvalidOperationException`: Dapper busca constructor con nombres de columna snake_case en lugar de PascalCase. Fix: usar `SELECT ... AS NombreDelCampo` para cada columna.
2. **Usar `int` en lugar de `long` para claves foráneas.** Causa: `InvalidOperationException`: Dapper espera `Int64` para todas las columnas INTEGER de SQLite, incluyendo las foreign keys. Fix: usar `long` en todos los records.
3. **Concatenar datos al SQL en lugar de parámetro.** Causa: riesgo de inyección SQL y errores de sintaxis. Fix: usar siempre `@param` y `new { param }`.
4. **Olvidar `using` en la conexión.** Causa: la conexión no se cierra y puede agotar el pool de SQLite. Fix: usar `using var connection = new SqliteConnection(...)` dentro de cada handler.
5. **No proteger `main` con ramas por feature.** Causa: los alumnos hacen push directo a `main` y generan conflictos. Fix: se refuerza que desde la Unidad 4 se usan ramas por feature y PR revisados.
6. **Devolver el objeto crudo sin `Results`.** Causa: ASP.NET serializa con nombres del record sin configuración adicional, pero viola la convención del curso. Fix: envolver siempre con `Results.Ok()`, `Results.NotFound()`, etc.

## Criterios de logro

| Condición | Criterio |
|---|---|
| Aprobado (≥ 60 pts) | El proyecto compila y ejecuta. Al menos dos endpoints funcionan correctamente (uno con JOIN de 2 tablas, otro con LIKE). Usa tipos canónicos (`long`, `string`, `string?`), alias `AS`, parámetros parametrizados y respuestas `Results.*`. Hay commit en el repo y README de portada. |
| Destacado (≥ 85 pts) | Cumple el criterio anterior + endpoint de admisiones con triple JOIN funcionando, README completo con ejemplos de uso, código bien comentado, y defensa oral que muestra comprensión de las decisiones de diseño y la conexión entre U1 y U2. |
| No aprobado (< 60 pts) | El proyecto no compila, no corre, o falta funcionalidad central (no usa Dapper, no usa JOIN, no hay commit en el repo). El estudiante pasa al grupo de intensificación en los momentos siguientes (encuentros 34-35 o diciembre). |
