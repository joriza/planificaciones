# Intensificación y fortalecimiento de las Unidades 1 y 2 — Encuentros 17 y 18

## Metadatos

| Campo | Valor |
|---|---|
| Momento | Intensificación y fortalecimiento de las Unidades 1 y 2 — primera instancia |
| Encuentros | 17 y 18 |
| Duración | 2 encuentros × 240 min (4 horas reloj cada uno) |
| Destinatarios | Totalidad del curso, con pistas diferenciadas por condición |
| Requisitos | Haber cursado las unidades 1 y 2; tener resueltos o intentados los TP-U1 y TP-U2; repo grupal GitHub clonado en la PC |
| Lugar | Aula de informática con VS Code, terminal y repo grupal GitHub |
| Uso de celular | No permitido |

## Acuerdo pedagógico

| Dimensión | Grupo de intensificación (recuperación pedagógica) | Grupo de fortalecimiento (profundización) |
|---|---|---|
| **Contenidos** | U1: tipos (`int`, `long`, `float`, `string`, `bool`), entrada/salida (`Console.WriteLine`, `Console.ReadLine`), condicionales (`if`/`else`, `switch`), bucles (`for`, `while`), métodos (`static`, parámetros, retorno), primer endpoint GET (`MapGet`), parámetros de ruta y query. U2: conexión a SQLite (`Data Source=hospital.db`), SELECT con WHERE y parámetros, JOIN de 2 tablas, ORDER BY, `Query<T>` con alias `AS`, LIKE para búsqueda por patrón. | U1: tipos canónicos de Dapper (`long` para INTEGER, `string` para TEXT, `string?`/`long?` para nullable), registros posicionales, top-level statements, `Results.Ok`/`Results.NotFound`/`Results.Created`/`Results.BadRequest`, códigos HTTP 200/201/204/400/404. U2: `QueryFirstOrDefault<T>`, `ExecuteScalar<long>`, `Execute` para INSERT/UPDATE/DELETE, consultas parametrizadas con `new { id }`, triple JOIN, validación de existencia antes de operaciones. |
| **Actividad / metodología** | Ejercicios guiados paso a paso: corregir errores comunes en ejemplos de U1 y U2, refactorizar programas existentes del TP, cerrar el ciclo Git (commit + push) del TP correspondiente. El docente modela cada operación en vivo y acompaña individualmente. | Desafíos de profundización autónomos: extender programas con nuevas funcionalidades, refactorizar con tipos canónicos y registros posicionales, escribir consultas con triple JOIN y validación de existencia. Trabajo en parejas con revisión entre pares. |
| **Recursos** | VS Code, terminal, repo grupal clonado, guía impresa de núcleos U1 y U2, ejemplos resueltos del TP-U1 y TP-U2, lista de verificación de objetivos por alumno, `hospital.db` copiado al lado del `.csproj`. | VS Code, terminal, repo grupal, consignas de desafío impresas, documentación de convenciones técnicas del curso, `hospital.db` copiado al lado del `.csproj`. |

## Desarrollo del Encuentro 17

### Apertura conjunta (15 min)

Plenaria: el docente recorre los núcleos de U1 y U2 con un mapa conceptual en el pizarrón (tipos → variables → control de flujo → métodos → primer GET → conexión BD → SELECT → JOIN → alias). Se asigna cada estudiante a su pista según el desempeño registrado en los TP-U1 y TP-U2. Se recuerda que **no se permite celular**.

### Pista intensificación — Bloque 1 (50 min)

**U1: tipos, control de flujo y primer endpoint GET (50 min)**

1. **(15 min)** Repaso declaración de variables y tipos en C#. Ejercicio guiado: programa que pida nombre y edad con `Console.ReadLine`, los convierta con `int.Parse`, y los muestre con `Console.WriteLine`. Errores comunes: no convertir con `int.Parse`, concatenar tipos distintos.
2. **(15 min)** Condicionales. Ejercicio: programa que verifique si un número es positivo, negativo o cero. Usar `if`/`else if`/`else`. El docente modela en vivo y corrige errores.
3. **(20 min)** Primer endpoint GET: el docente muestra el esqueleto de `Program.cs` con `MapGet` que devuelve un mensaje de texto. Los alumnos lo escriben, lo ejecutan con `dotnet run` y lo prueban en el navegador. Se verifica que cada estudiante tenga el endpoint funcionando.

### Pista fortalecimiento — Bloque 1 (50 min)

**U1 profundizado: tipos canónicos y registros posicionales (50 min)**

1. **(15 min)** Tipos canónicos de Dapper: INTEGER → `long`, TEXT → `string`, nullable → `string?`/`long?`. El docente explica por qué `int` no funciona para claves primarias INTEGER y muestra el error `InvalidOperationException`.
2. **(15 min)** Records posicionales: declaración después de `app.Run()`. Ejercicio: declarar un record `Patient` con los campos canónicos y verificar que compile.
3. **(20 min)** Top-level statements y `Results.*`: escribir un endpoint `MapGet` completo que devuelva `Results.Ok(patient)` y otro que devuelva `Results.NotFound(new { mensaje = "..." })`. El docente verifica cada endpoint.

### Pista intensificación — Bloque 2 (50 min)

**U2: SELECT, WHERE y parámetros (50 min)**

1. **(15 min)** Conexión a SQLite: cadena `"Data Source=hospital.db"`, `using var connection = new SqliteConnection(connectionString)`. El docente modela la apertura y cierre de conexión.
2. **(15 min)** SELECT con WHERE y parámetro: `WHERE patient_id = @id` con `new { id }`. Ejercicio: endpoint GET que devuelva un paciente por ID. El docente verifica que cada estudiante tenga el endpoint funcionando.
3. **(20 min)** LIKE para búsqueda parcial: `WHERE first_name LIKE @name` con `new { name = $"%{query}%" }`. Ejercicio: endpoint GET `/patients/search?name=...` que devuelva pacientes cuyo nombre contenga el texto buscado.

### Pista fortalecimiento — Bloque 2 (50 min)

**U2 profundizado: JOIN y alias (50 min)**

1. **(15 min)** JOIN de 2 tablas: `SELECT ... FROM patients JOIN provinces ON patients.province_id = provinces.province_id`. El docente explica la relación entre tablas y la necesidad del alias `AS`.
2. **(15 min)** Alias `AS` en SELECT: `SELECT patient_id AS PatientId, first_name AS FirstName, provinces.name AS ProvinceName`. El docente modela un record `PatientWithProvince` y verifica que los nombres coincidan exactamente.
3. **(20 min)** Ejercicio: escribir un endpoint GET `/patients-with-province/{id:long}` que devuelva un paciente con el nombre de su provincia usando JOIN y alias. Verificar que funcione contra `hospital.db`.

### Pista intensificación — Bloque 3 (50 min)

**U1: métodos y control de flujo avanzado (50 min)**

1. **(15 min)** Métodos en C#: `static`, parámetros y retorno. Ejercicio: crear un método `Saludar(string nombre)` que devuelva un string de saludo. Llamarlo desde el `Main` (top-level statement).
2. **(15 min)** Bucles: `for` y `while`. Ejercicio: mostrar la tabla de multiplicar de un número ingresado por consola. El docente verifica cada solución.
3. **(20 min)** Integrador U1: programa completo que pida un número por consola, muestre su tabla de multiplicar con `for`, y luego se convierte en un endpoint GET que acepte el número como parámetro de query.

### Pista fortalecimiento — Bloque 3 (50 min)

**U2 profundizado: ORDER BY, QueryFirstOrDefault y ExecuteScalar (50 min)**

1. **(15 min)** ORDER BY: `SELECT * FROM patients ORDER BY first_name ASC`. Ejercicio: endpoint que devuelva la lista de pacientes ordenada alfabéticamente.
2. **(15 min)** `QueryFirstOrDefault<T>`: devuelve `null` si no hay resultados. Ejercicio: endpoint que devuelva 404 si el paciente no existe, 200 si existe. Validar con `patient is null`.
3. **(20 min)** `ExecuteScalar<long>` para conteos: `SELECT COUNT(*) FROM patients`. Ejercicio: endpoint GET `/patients/count` que devuelva el total de pacientes como `Results.Ok(new { total = count })`.

### Pista intensificación — Bloque 4 (45 min)

**Integración y práctica (45 min)**

1. **(15 min)** Ejercicio integrador U1+U2: crear un endpoint GET `/patients` que devuelva la lista completa de pacientes desde `hospital.db` usando Dapper. El docente verifica que cada estudiante tenga el endpoint funcionando.
2. **(15 min)** Commit y push: cada estudiante hace `git add .`, `git commit -m "feat: endpoint GET patients con Dapper"` y `git push`. El docente verifica los commits en GitHub.
3. **(15 min)** Repaso de errores comunes: el docente recorre las trampas más frecuentes (tipos incorrectos, sin alias `AS`, conexión no cerrada, records antes de `app.Run()`).

### Pista fortalecimiento — Bloque 4 (45 min)

**Desafíos de integración (45 min)**

1. **(15 min)** Desafío U1: crear un endpoint GET `/greeting/{name:long}` que acepte un nombre como parámetro de ruta y devuelva un saludo personalizado con `Results.Ok`. Agregar validación: si el nombre está vacío, devolver `Results.BadRequest`.
2. **(15 min)** Desafío U2: escribir una consulta con LIKE que busque pacientes por ciudad (`WHERE city LIKE @city`). El docente verifica que la consulta funcione contra `hospital.db`.
3. **(15 min)** Commit y push: cada estudiante hace commit de los desafíos con mensaje descriptivo. El docente verifica que el repo esté actualizado.

### Cierre conjunto (15 min)

Puesta en común: cada pista comparte la línea de código que más le costó resolver. El docente destaca los errores típicos (tipos incorrectos, sin alias `AS`, conexión no cerrada, records antes de `app.Run()`). Anticipa que en el próximo encuentro se completa U2 con operaciones de escritura (INSERT, UPDATE, DELETE) y se consolida el ciclo Git.

### Errores comunes y trampas

1. **Declarar el ID como `int` en el record.** Causa: `InvalidOperationException`: Dapper busca constructor `(Int64, String)` porque SQLite INTEGER devuelve `Int64`, pero el record ofrece `(int, String)`. Fix: usar `long PatientId` en todos los records.
2. **SELECT sin alias `AS` en snake_case.** Causa: `InvalidOperationException`: Dapper busca constructor con parámetros `patient_id` (snake_case) en lugar de `PatientId` (PascalCase). Fix: usar `SELECT patient_id AS PatientId, ...`.
3. **Records antes de `app.Run()`.** Causa: Error CS8803: las top-level statements deben preceder a las declaraciones de tipos. Fix: escribir `app.Run();` y después los records.
4. **Olvidar `using` en la conexión.** Causa: la conexión no se cierra y puede agotar el pool de SQLite. Fix: usar `using var connection = new SqliteConnection(...)` dentro del bloque del endpoint.
5. **Concatenar datos al SQL en lugar de parámetro.** Causa: riesgo de inyección SQL y errores de sintaxis con cadenas que contengan comillas. Fix: usar `@id` y `new { id }` en toda consulta.
6. **No proteger `main` con ramas por feature.** Causa: los alumnos hacen push directo a `main` y generan conflictos. Fix: se refuerza que desde la Unidad 4 se usan ramas por feature y PR revisados.

## Desarrollo del Encuentro 18

### Apertura conjunta (15 min)

Repaso relámpago: el docente escribe en vivo un programa que pida tres números, los guarde en una lista y muestre el promedio. Pregunta "¿qué falta? — operaciones de escritura en la base de datos". Anuncia que hoy se consolidan las operaciones CRUD con Dapper y se cierra el ciclo Git de los TP-U1 y TP-U2. Se recuerda que **no se permite celular**.

### Pista intensificación — Bloque 1 (50 min)

**U2: INSERT y DELETE (50 min)**

1. **(15 min)** INSERT con `Execute`: `INSERT INTO patients (...) VALUES (...)`. Ejercicio guiado: endpoint POST `/patients` que agregue un paciente a `hospital.db`. El docente modela la conexión, la consulta parametrizada y la verificación de filas afectadas.
2. **(15 min)** DELETE con `Execute`: `DELETE FROM patients WHERE patient_id = @id`. Ejercicio: endpoint DELETE `/patients/{id:long}` que elimine un paciente. Verificar que devuelva `Results.NoContent()` si se eliminó y `Results.NotFound` si no existía.
3. **(20 min)** Validación de existencia antes de DELETE: verificar con `QueryFirstOrDefault` que el paciente exista antes de eliminar. Ejercicio: endpoint DELETE que primero consulte y luego elimine, devolviendo 404 si no existe.

### Pista fortalecimiento — Bloque 1 (50 min)

**U2 profundizado: INSERT con retorno de ID y operaciones completas (50 min)**

1. **(15 min)** `ExecuteScalar<long>` para obtener el ID generado por el INSERT: `INSERT INTO patients (...) VALUES (...); SELECT last_insert_rowid();`. Ejercicio: endpoint POST que devuelva `Results.Created($"/patients/{newId}", paciente)` con el ID del nuevo registro.
2. **(15 min)** UPDATE con `Execute`: `UPDATE patients SET first_name = @firstName WHERE patient_id = @id`. Ejercicio: endpoint PUT `/patients/{id:long}` que actualice un paciente existente. Devolver 200 si se actualizó, 404 si no existía.
3. **(20 min)** Triple JOIN: `SELECT ... FROM admissions JOIN patients ON ... JOIN doctors ON ...`. Ejercicio: endpoint GET `/admissions/{id:long}` que devuelva una admisión con los datos completos del paciente y el médico. Verificar que funcione contra `hospital.db`.

### Pista intensificación — Bloque 2 (50 min)

**U1: métodos y estructura del proyecto (50 min)**

1. **(15 min)** Repaso de la estructura de `Program.cs`: `using` directivas, `WebApplication.CreateBuilder`, `builder.Build()`, endpoints, `app.Run()`, records posicionales al final. El docente recorre el esqueleto completo.
2. **(15 min)** Parámetros de ruta y query: diferencia entre `/patients/{id:long}` (ruta) y `?name=...` (query). Ejercicio: dos endpoints, uno con parámetro de ruta y otro con parámetro de query, que devuelvan resultados diferentes.
3. **(20 min)** Integrador U1: programa completo con dos endpoints GET (uno con ruta, uno con query), un endpoint POST y un endpoint DELETE. El docente verifica que cada estudiante tenga los cuatro endpoints funcionando.

### Pista fortalecimiento — Bloque 2 (50 min)

**U2: validación y manejo de errores (50 min)**

1. **(15 min)** Validación de entrada: verificar que el ID recibido sea positivo antes de consultar la base. Devolver `Results.BadRequest(new { mensaje = "El ID debe ser positivo" })` si no lo es.
2. **(15 min)** Manejo de errores en consultas: capturar excepciones de SQLite y devolver `Results.BadRequest` con un mensaje descriptivo. El docente modela el bloque `try/catch` dentro del handler.
3. **(20 min)** Desafío completo: endpoint PUT que actualice un paciente, con validación de existencia (404 si no existe), validación de datos (400 si faltan campos obligatorios), y retorno 200 con el paciente actualizado. Verificar contra `hospital.db`.

### Pista intensificación — Bloque 3 (45 min)

**Integración y cierre Git (45 min)**

1. **(15 min)** Ejercicio integrador U1+U2: crear un endpoint GET `/patients/search?name=...` que use LIKE para buscar pacientes por nombre parcial y devuelva la lista con `Results.Ok`. El docente verifica que funcione.
2. **(15 min)** Commit y push final: cada estudiante hace `git add .`, `git commit -m "feat: CRUD completo con Dapper"` y `git push`. El docente verifica los commits en GitHub.
3. **(15 min)** Repaso de errores comunes: el docente recorre las trampas más frecuentes (tipos incorrectos, sin alias `AS`, conexión no cerrada, records antes de `app.Run()`).

### Pista fortalecimiento — Bloque 3 (45 min)

**Desafíos de integración y cierre Git (45 min)**

1. **(15 min)** Desafío U1+U2: crear un endpoint GET `/patients-by-province/{provinceId:long}` que use JOIN entre patients y provinces y devuelva la lista de pacientes de una provincia específica. Verificar contra `hospital.db`.
2. **(15 min)** Desafío U2: escribir una consulta que use `ExecuteScalar<long>` para contar cuántos pacientes tienen alergias registradas (columna `allergies` no nula).
3. **(15 min)** Commit y push final: cada estudiante hace commit de los desafíos con mensaje descriptivo. El docente verifica que el repo esté actualizado.

### Cierre conjunto (15 min)

Plenaria final: el docente muestra el repo grupal actualizado con los commits del encuentro. Verifica que los TP-U1 y TP-U2 estén commiteados y pusheados. "Con esto cerramos las dos primeras unidades. En el proyecto puente (encuentros 19 y 20) van a integrar todo: entrada, condicionales, bucles, endpoints GET, conexión a SQLite y consultas Dapper — un solo proyecto que vale como recuperatorio."

### Errores comunes y trampas

1. **Declarar el ID como `int` en el record.** Causa: `InvalidOperationException`: Dapper busca constructor `(Int64, String)` porque SQLite INTEGER devuelve `Int64`, pero el record ofrece `(int, String)`. Fix: usar `long PatientId` en todos los records.
2. **Fecha declarada como `DateTime` o `DateOnly`.** Causa: `InvalidOperationException`: Dapper recibe `String` de la columna TEXT y no encuentra constructor que acepte `DateTime`/`DateOnly`. Fix: usar `string BirthDate` en el record. Convertir con `DateTime.Parse()` solo al presentar.
3. **SELECT sin alias `AS` en snake_case.** Causa: `InvalidOperationException`: Dapper busca constructor con parámetros `patient_id` (snake_case) en lugar de `PatientId` (PascalCase). Fix: usar `SELECT patient_id AS PatientId, ...`.
4. **Concatenar datos al SQL en lugar de parámetro.** Causa: riesgo de inyección SQL y errores de sintaxis con cadenas que contengan comillas. Fix: usar `@id` y `new { id }` en toda consulta.
5. **Olvidar `using` en la conexión.** Causa: la conexión no se cierra y puede agotar el pool de SQLite. Fix: usar `using var connection = new SqliteConnection(...)` dentro del bloque del endpoint.
6. **Devolver el objeto crudo sin `Results`.** Causa: ASP.NET serializa con nombres del record (PascalCase) sin configuración adicional, pero viola la convención del curso. Fix: envolver siempre con `Results.Ok()`, `Results.NotFound()`, etc.

## Criterios de logro

| Condición | Criterio |
|---|---|
| Intensificación | El estudiante escribe programas que usan tipos correctos (`long`, `string`, `string?`), `Console.ReadLine`/`Console.WriteLine`, condicionales, bucles, métodos con `def`, endpoint GET con `MapGet`, conexión a SQLite con Dapper, SELECT con WHERE y LIKE, y operaciones INSERT/DELETE con validación de existencia. Commitea y pushea al repo grupal. |
| Fortalecimiento | El estudiante compone tipos canónicos de Dapper, escribe consultas con triple JOIN y alias `AS`, usa `ExecuteScalar<long>` para conteos y IDs generados, implementa validación de entrada y manejo de errores, y resuelve los desafíos completos de ambos encuentros. |
| Ambos grupos | Participa de las plenarias de apertura y cierre, actualiza el repositorio grupal con los avances de cada encuentro, y puede explicar con sus palabras la diferencia entre un endpoint GET en memoria y uno que consulta `hospital.db` con Dapper. |
