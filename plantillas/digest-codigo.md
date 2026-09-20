# Digest de código para writers — Minimal API con C# .NET 6

> Digest de trabajo para writers — canon completo: `minimal-api-csharp/convenciones-tecnicas.md`; ante conflicto manda el canon completo.

- **Entorno:** VS Code + terminal, SDK .NET 6; proyecto con `dotnet new web`, corre con `dotnet run` y corta con `Ctrl+C`.
- **Un solo archivo:** todo el código en `Program.cs` (top-level statements); records SIEMPRE al final, después de `app.Run()` (CS8803); sin carpetas `Models/`, `Services/`, `Interfaces/` ni `Controllers/`.
- **Esqueleto:** `builder` → `app` → endpoints (`MapGet`/`MapPost`/`MapPut`/`MapDelete`) → `app.Run()` → records al final.
- **Records:** ids SIEMPRE `long` (nunca `int`); fechas SIEMPRE `string` ISO `yyyy-MM-dd` (nunca `DateOnly`/`DateTime`); `?` solo si la columna acepta NULL; `int` solo para conteos y medidas.
- **Fechas:** viajan como texto ISO y se muestran tal cual; convertir solo al presentar, nunca en el record ni en la consulta.
- **Mapeo:** columnas snake_case con alias en el SELECT (`SELECT patient_id AS PatientId`); el JSON sale camelCase sin configuración.
- **Dapper (desde la Unidad 2):** paquetes `Microsoft.Data.Sqlite` + `Dapper`; cadena `"Data Source=hospital.db"` con la base junto al `.csproj`; conexión dentro de cada handler: `using var connection = new SqliteConnection(connectionString);` (se cierra sola).
- **Consultas SIEMPRE parametrizadas:** el valor llega por `@id` con `new { id }`; jamás concatenar el SQL con datos. Métodos: `Query<T>`, `QueryFirstOrDefault<T>`, `Execute`, `ExecuteScalar<long>`.
- **Respuestas SIEMPRE con `Results`** (nunca `TypedResults`, nunca el objeto crudo):
  - `200` → `Results.Ok(dato)`: lectura (GET) y reemplazo en memoria (PUT sin base de datos).
  - `201` → `Results.Created(url, dato)`: alta (POST), con la URL del recurso nuevo.
  - `204` → `Results.NoContent()`: borrado (DELETE) y actualización sobre base de datos (PUT con Dapper), sin cuerpo.
  - `400` → `Results.BadRequest(new { mensaje = "..." })`: dato faltante, mal formado o que no pasa la validación.
  - `404` → `Results.NotFound(new { mensaje = "..." })`: el id pedido no existe.
  - Mensajes de `400`/`404` en español dentro de `new { mensaje = "..." }`; `500` nunca se devuelve a propósito.
- **Código legible:** comentario en cada acción del ejemplo (sin tildes ni eñes dentro del código); ejemplos mínimos que compilan y corren tal cual, sin pseudocódigo.
- **Naming:** identificadores y rutas en inglés y en plural (`Patient`, `patientId`, `/patients/{id:long}`); texto y comentarios en español.
- **Git:** un repositorio por grupo, mono-rama `main`, `.gitignore` en la raíz con `bin/` y `obj/`, una carpeta por trabajo (`tp-u1/` … `trabajo-final/`); al cerrar cada encuentro: `git add .` + `git commit -m "<carpeta>: <resumen>"` (español, minúsculas tras los dos puntos, sin tildes) + `git push`.
