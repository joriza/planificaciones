# Encuentro 14 — Escritura con Dapper, cierre de la Unidad 2 y entrega del tp-u2

> Unidad 2 — Acceso a datos con SQLite y Dapper

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 14 de 36 |
| Unidad | Unidad didáctica 2: Acceso a datos con SQLite y Dapper (cierre de unidad) |
| Momento | Cierre de unidad (consolidación + trabajo del TP + entrega) |
| Eje temático | Nº 2 — Acceso a datos con Dapper (transversal: Nº 5, Terminal, Git y GitHub) |
| Carácter/Objetivo | Procedimental: escribir en la base y cerrar la unidad con la entrega |
| Duración teórica | 4 horas reloj (240 minutos) |
| Concepto nuevo | `Execute` (UPDATE/DELETE) y `ExecuteScalar<long>` (INSERT + `last_insert_rowid()`); filas afectadas como señal de 404; `Results.Created` (201) y `Results.NoContent` (204); cuerpo JSON de entrada con record (`DoctorInput`); cierre y entrega del tp-u2 |
| Requisitos previos | Clases 10 a 13 completas: conexión, consultas parametrizadas, validación 400/404, JOIN; rutina git (add/commit/push) del Encuentro 5 y ciclo completo de entrega (carpeta, remote, push a GitHub) del Encuentro 8 |
| Uso de celular | No permitido |
| Registro | Didáctico: material de clase dirigido al estudiante (el anexo docente va en archivo separado) |
| Grupos | Alumnos presentes ÷ equipos disponibles (mínimo posible); ningún equipo sin usar; rotación de integrantes en el trabajo del TP |
| Planificación anual | Encuentro 14: escritura con Dapper (INSERT/UPDATE/DELETE parametrizados, 201/400/404); consolidación; cierre de la unidad y entrega del tp-u2 |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura | 15 min |
| Consolidación: teoría y práctica de escritura con Dapper | 75 min |
| Trabajo del tp-u2 | 90 min |
| Ciclo de entrega del tp-u2 | 45 min |
| Cierre | 15 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

**Apertura (15 min).** Última pieza de la unidad: hasta hoy la API solo **leyó** `hospital.db`; hoy aprende a **escribir** en ella. Pregunta disparadora: si un médico nuevo entra al hospital, ¿quién carga su ficha? Con la API del final de la clase, el alta, el cambio y la baja de médicos se hacen con POST, PUT y DELETE contra la base real, y los datos quedan guardados en el archivo. Después del bloque de escritura, el resto del encuentro es consolidación aplicada: el tp-u2, que se entrega por GitHub al final.

Al finalizar el encuentro, cada estudiante puede:

1. Insertar filas con `ExecuteScalar<long>` (INSERT + `last_insert_rowid()`) y responder 201 con la URL del recurso nuevo.
2. Actualizar y borrar con `Execute`, usando la cantidad de filas afectadas para distinguir 404 (no existía) de 204 (operación hecha).
3. Recibir el cuerpo JSON del pedido en un record de entrada (`DoctorInput`) y validarlo con `IsNullOrWhiteSpace` antes de escribir.
4. Armar el tp-u2: API sobre `hospital.db` con lecturas filtradas y escritura de un recurso, en su propia carpeta del repositorio.
5. Completar el ciclo de entrega (carpeta `tp-u2/`, commits con mensaje referente y push) y verificarlo en GitHub.

## 3. Teoría mínima (20 min)

### Charla rápida: el libro de novedades del hospital

Además del archivo de historias, el hospital tiene un libro de novedades: cuando entra un médico nuevo, se agrega su línea; si cambia de especialidad, se reescribe su línea; si se va, se tacha. El empleado no rehace el libro: agrega, reescribe o tacha **la línea que corresponde**, siempre identificada por su número.

En SQL, las tres órdenes del libro: `INSERT` agrega una fila, `UPDATE` reescribe las filas que cumplen el `WHERE`, `DELETE` tacha las que lo cumplen. Dapper las ejecuta con dos métodos nuevos.

### Los dos métodos de escritura de Dapper

| Método | Para qué | Qué devuelve |
| --- | --- | --- |
| `ExecuteScalar<long>` | INSERT cuando hace falta el id nuevo | Ejecuta el INSERT y trae el resultado de la segunda consulta: `last_insert_rowid()`, el id que SQLite asignó |
| `Execute` | UPDATE y DELETE (y cualquier INSERT sin id necesario) | La **cantidad de filas afectadas**: 1 si tocó una, 0 si no encontró nada |

La cantidad de filas afectadas es la señal perfecta para el 404: `rows == 0` significa que el id no existía y **nada se escribió**. Un `UPDATE` que no encuentra su fila no falla: apenas informa; por eso el chequeo es responsabilidad de la API.

### Los códigos de la escritura

- **201 Created** (alta): `Results.Created($"/doctors/{newId}", doctor)` responde con la URL del recurso nuevo en el encabezado `Location` y el recurso en el cuerpo.
- **400 Bad Request**: los datos del cuerpo no pasan la validación (campo vacío). Con mensaje, como en la clase 12.
- **404 Not Found**: el id que se quería modificar o borrar no existe (filas afectadas en 0). Con mensaje.
- **204 No Content**: el cambio o el borrado quedaron hechos; la respuesta no lleva cuerpo, porque no hay nada nuevo que decir: la base ya quedó bien.

### El cuerpo del pedido llega como record

En los GET de la unidad, los datos entraban por la ruta o la query string. En POST y PUT entran por el **cuerpo** del pedido, en JSON. La Minimal API los encaja en un record de entrada por nombre de propiedad: el JSON `{"firstName":"Ana","lastName":"Garcia","specialty":"Cardiologist"}` aterriza en un `DoctorInput(string FirstName, string LastName, string Specialty)`. Es el mismo mapeo por nombre de toda la unidad, ahora en el sentido inverso: del JSON hacia C#.

### El pedido de escritura se prueba con curl

El navegador solo envía GET; la escritura se prueba con `curl`, siempre de una línea. En Windows PowerShell, usar `curl.exe` (el `curl` solo puede ser un alias de `Invoke-WebRequest`). Las comillas internas del JSON van escapadas con `\"`.

## 4. Práctica guiada (55 min)

### Paso 1 — Partir del proyecto de la unidad

Abrir `u2-api/` (clases 10 a 13). Hoy el archivo se organiza alrededor de `doctors`: lecturas mínimas (lista y por id) más las tres operaciones de escritura. Los endpoints de pacientes de las clases anteriores pueden seguir en tu archivo; el listado de referencia muestra solo lo de hoy, para leerlo entero de una mirada.

### Paso 2 — Reemplazar Program.cs completo

Reemplazar todo el contenido de `Program.cs` por este archivo (última versión completa del encuentro):

```csharp
using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion al archivo hospital.db

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// GET /doctors: todos los medicos, ordenados por apellido y nombre
app.MapGet("/doctors", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var doctors = connection.Query<Doctor>(
        @"SELECT doctor_id  AS DoctorId,
                 first_name AS FirstName,
                 last_name  AS LastName,
                 specialty  AS Specialty
          FROM doctors
          ORDER BY last_name, first_name");

    return Results.Ok(doctors);
});

// GET /doctors/{id}: UN medico por id (404 con mensaje)
app.MapGet("/doctors/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    var doctor = connection.QueryFirstOrDefault<Doctor>(
        @"SELECT doctor_id  AS DoctorId,
                 first_name AS FirstName,
                 last_name  AS LastName,
                 specialty  AS Specialty
          FROM doctors
          WHERE doctor_id = @id",
        new { id });

    if (doctor is null)
    {
        return Results.NotFound(new { mensaje = "No existe el medico con ese id" });
    }

    return Results.Ok(doctor);
});

// POST /doctors: ALTA de un medico. El cuerpo JSON llega como DoctorInput
app.MapPost("/doctors", (DoctorInput input) =>
{
    // Validacion de la clase 12: los tres datos son obligatorios
    if (string.IsNullOrWhiteSpace(input.FirstName) ||
        string.IsNullOrWhiteSpace(input.LastName) ||
        string.IsNullOrWhiteSpace(input.Specialty))
    {
        return Results.BadRequest(new { mensaje = "Faltan datos del medico" });
    }

    using var connection = new SqliteConnection(connectionString);

    // ExecuteScalar: corre el INSERT y trae el resultado de la segunda
    // consulta; last_insert_rowid() devuelve el id que SQLite asigno
    long newId = connection.ExecuteScalar<long>(
        @"INSERT INTO doctors (first_name, last_name, specialty)
          VALUES (@FirstName, @LastName, @Specialty);
          SELECT last_insert_rowid();",
        new { input.FirstName, input.LastName, input.Specialty });

    // 201 Created: URL del recurso nuevo + el recurso en el cuerpo
    var created = new Doctor(newId, input.FirstName, input.LastName, input.Specialty);
    return Results.Created($"/doctors/{newId}", created);
});

// PUT /doctors/{id}: REEMPLAZO de los datos del medico con ese id
app.MapPut("/doctors/{id:long}", (long id, DoctorInput input) =>
{
    // Misma validacion que el alta: los tres datos son obligatorios
    if (string.IsNullOrWhiteSpace(input.FirstName) ||
        string.IsNullOrWhiteSpace(input.LastName) ||
        string.IsNullOrWhiteSpace(input.Specialty))
    {
        return Results.BadRequest(new { mensaje = "Faltan datos del medico" });
    }

    using var connection = new SqliteConnection(connectionString);

    // Execute devuelve la cantidad de filas afectadas:
    // 0 significa que no habia medico con ese id y NADA se escribio
    int rows = connection.Execute(
        @"UPDATE doctors
          SET first_name = @FirstName,
              last_name  = @LastName,
              specialty  = @Specialty
          WHERE doctor_id = @id",
        new { id, input.FirstName, input.LastName, input.Specialty });

    if (rows == 0)
    {
        return Results.NotFound(new { mensaje = "No existe el medico con ese id" });
    }

    // 204 No Content: la actualizacion quedo hecha, sin cuerpo
    return Results.NoContent();
});

// DELETE /doctors/{id}: BAJA del medico con ese id
app.MapDelete("/doctors/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    // Misma tecnica del PUT: filas afectadas 0 = id inexistente
    int rows = connection.Execute(
        "DELETE FROM doctors WHERE doctor_id = @id",
        new { id });

    if (rows == 0)
    {
        return Results.NotFound(new { mensaje = "No existe el medico con ese id" });
    }

    return Results.NoContent();   // 204: borrado hecho, respuesta sin cuerpo
});

app.Run();   // Deja la API escuchando pedidos

// ---- Records: SIEMPRE al final del archivo ----

// Medico: una fila de la tabla doctors (respuesta del GET y del POST)
record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);

// Datos de entrada del POST y del PUT: llega por el cuerpo del pedido
// en JSON; sin id, porque el id lo asigna la base en el alta
record DoctorInput(string FirstName, string LastName, string Specialty);
```

### Paso 3 — Escribir en la base con curl

Correr `dotnet run` y probar el ciclo completo (reemplazar `5080` por el propio puerto). Cada comando es una sola línea:

```powershell
# POST: alta de un medico nuevo (responde 201 con el recurso y su id asignado)
curl -X POST http://localhost:5080/doctors -H "Content-Type: application/json" -d "{\"firstName\":\"Ana\",\"lastName\":\"Garcia\",\"specialty\":\"Cardiologist\"}"

# GET: verificar que el medico nuevo esta en la base (usar el id del paso anterior)
curl http://localhost:5080/doctors/28

# PUT: reemplazo de los datos del medico 28 (responde 204 sin cuerpo)
curl -X PUT http://localhost:5080/doctors/28 -H "Content-Type: application/json" -d "{\"firstName\":\"Ana\",\"lastName\":\"Garcia\",\"specialty\":\"Neurologist\"}"

# GET: verificar el cambio de especialidad
curl http://localhost:5080/doctors/28

# DELETE: baja del medico 28 (responde 204 sin cuerpo)
curl -X DELETE http://localhost:5080/doctors/28

# GET: verificar la baja (404 con mensaje)
curl -i http://localhost:5080/doctors/28
```

### Salida esperada (verificada)

El ciclo completo deja evidencia verificable en cada paso:

1. El POST responde **201** con cuerpo `{"doctorId":28,"firstName":"Ana","lastName":"Garcia","specialty":"Cardiologist"}` (el id lo asigna la base: la referencia tiene 27 médicos, el nuevo es el 28) y encabezado `Location: http://localhost:5080/doctors/28`.
2. El GET del nuevo médico lo devuelve; después del PUT, `specialty` vale `"Neurologist"`.
3. El DELETE responde **204** sin cuerpo; el GET posterior responde **404** con `{"mensaje":"No existe el medico con ese id"}`.
4. **La escritura persiste**: cortar la API con Ctrl+C, volver a correr `dotnet run` y repetir el GET del médico 28 antes del DELETE: sigue estando. Los datos viven en `hospital.db`, no en la memoria (el Puente de la clase 10, cerrado).

### Paso 4 — El caso que enseña: borrar un médico con ingresos

Repetir el DELETE sobre un médico **original** de la base (por ejemplo el 7, Hazel Patterson): la respuesta es un **500** y en la terminal aparece `SQLite Error 19: 'FOREIGN KEY constraint failed'`. Causa: el médico tiene ingresos en `admissions` que apuntan a él, y la base no permite borrarlo sin dejar huérfanos. La API no se rompió: la base protegió la integridad. Para la baja, usar un médico creado por el propio grupo en el POST. (Este caso vuelve como trampa documentada al final del documento.)

## 5. Ejercicio independiente: trabajo del tp-u2 (90 min)

### Consigna

Desarrollar el **tp-u2**: una API sobre `hospital.db` en una carpeta nueva del repositorio del grupo. Requisitos mínimos (todos se resuelven con lo practicado en la unidad):

1. **Lecturas**: listar un recurso con `ORDER BY`; obtenerlo por id con 404 con mensaje.
2. **Búsqueda filtrada**: al menos un endpoint con query string y validación (400 con mensaje) y 404 con mensaje si no hay resultados (`LIKE` o igualdad, a elección del grupo).
3. **Cruce**: al menos un JOIN de dos tablas con record compuesto.
4. **Escritura**: POST, PUT y DELETE parametrizados sobre **un** recurso elegido (recomendado: `doctors`; `patients` exige además un `provinceId` existente y es el camino difícil).
5. **Calidad**: consultas SIEMPRE parametrizadas; ids `long`, fechas `string` ISO; records al final; comentarios abundantes en español y sin tildes; `Results` explícito en todas las respuestas.

El docente revisa avance por grupo durante el bloque (una pasada por equipo a mitad del bloque está pautada en el anexo docente). La solución modelo completa está en el anexo docente.

### Pista

Empezá con `dotnet new web` en la carpeta nueva, copiá `hospital.db`, agregá los dos paquetes y armá las lecturas primero (son el guion de las clases 10 a 13) y la escritura al final (la de hoy). Cada requisito que funcione, va a commit: no guardes todo para el final.

## 6. Ciclo de entrega del tp-u2 (45 min)

El ciclo completo se aprendió en el Encuentro 8: hoy **se aplica**, sin contenido nuevo. Checklist de entrega, en orden:

| # | Paso | Verificación |
| --- | --- | --- |
| 1 | Carpeta `tp-u2/` en la raíz del repositorio del grupo, con el proyecto dentro (`dotnet new web` + `hospital.db` + paquetes) | La API corre con `dotnet run` desde `tp-u2/` |
| 2 | Los 5 requisitos de la consigna funcionando | Recorrido de prueba anotado: qué URL se probó y qué respondió |
| 3 | Commits de avance con mensaje referente | `git log --oneline` muestra al menos 3 commits del trabajo, con la convención `tp-u2: <resumen>` |
| 4 | `git add .`, commit de cierre y `git push` | `git status` sin pendientes; `git push` termina sin error |
| 5 | Verificación en GitHub web | La carpeta `tp-u2/` está en el remoto, con `Program.cs` y `hospital.db`, y los commits del historial |

Comandos del cierre de la entrega (parados en la raíz del repositorio):

```powershell
git add .
git commit -m "tp-u2: api con lecturas filtradas, join y escritura de medicos"
git push
```

Quien no llegue con el ciclo completo, entrega igual lo que tenga funcionando: la evaluación del Encuentro 15 verifica la entrega tal como está y la defensa individual expone decisiones y pendientes.

## 7. Cierre (15 min)

### Qué te llevás

- Escribir es `Execute` (UPDATE/DELETE) y `ExecuteScalar<long>` (INSERT + `last_insert_rowid()`), siempre parametrizado igual que la lectura.
- Las **filas afectadas** son el 404 de la escritura: 0 filas significa id inexistente y nada escrito.
- Códigos de la escritura: 201 con `Results.Created` y la URL del recurso nuevo; 400 con mensaje si los datos no pasan la validación; 404 con mensaje si el id no existe; 204 sin cuerpo si el cambio quedó hecho.
- El cuerpo JSON del POST/PUT aterriza en un record de entrada sin id (`DoctorInput`): el id lo asigna la base.
- La base protege su integridad: borrar un médico con ingresos dispara un error de clave foránea. Los datos también tienen reglas.
- La unidad completa: conexión, lectura parametrizada, filtros con validación, JOIN y escritura — todo sobre `hospital.db`, todo en `Program.cs`.

### Lo que viene

- Encuentro 15: evaluación de la Unidad 2. Entrega por GitHub (verificación del tp-u2), defensa individual (explicar las consultas con Dapper y las decisiones de cada endpoint) y prueba práctica individual en versiones A y B equivalentes. Repaso recomendado: el cuadro de códigos 200/201/204/400/404 y los dos métodos de escritura de hoy.

### Recordatorio de commit (rutina desde el Encuentro 5; la entrega completa es el paso 6)

```powershell
git add .
git commit -m "tp-u2: api con lecturas filtradas, join y escritura de medicos"
git push
```

## 8. Errores comunes y trampas

| Trampa | Causa | Cómo se resuelve |
| --- | --- | --- |
| 500 `FOREIGN KEY constraint failed` al borrar un médico | El médico tiene ingresos en `admissions` que lo referencian: la base bloquea el borrado | Probar la baja con un médico creado por POST en la práctica; leer el error completo en la terminal (Paso 4) |
| `last_insert_rowid()` devuelve un id raro o 0 | Ejecutar el INSERT y el `SELECT last_insert_rowid()` en métodos o conexiones distintas | Los dos van juntos, en la MISMA llamada a `ExecuteScalar<long>`, sobre la MISMA conexión |
| El POST no recibe el cuerpo | Falta el encabezado `Content-Type: application/json` en el curl, o el JSON tiene las comillas sin escapar | En PowerShell usar `curl.exe` con `-H "Content-Type: application/json"` y comillas internas `\"` |
| PUT que "funciona" pero no cambia nada | `WHERE doctor_id = @id` sin la propiedad `id` en el objeto anónimo | Contar los huecos `@` del SQL y las propiedades de `new { ... }`: deben emparejarse; revisar con el GET posterior |
| 201 sin `Location` o con URL vacía | `Results.Created(null, ...)` o la URL escrita a mano con otro formato | `Results.Created($"/doctors/{newId}", created)`: la URL es la ruta del recurso con su id real |
| Escribir sobre `patients` sin `provinceId` existente | `province_id` es clave foránea: un código inexistente dispara el mismo error 19 que el DELETE | Elegir `doctors` para la escritura del tp, o usar un código de `/provinces` verificado (camino del tp, en el anexo) |
| Entregar sin commits de avance | Guardar todo el trabajo para un único commit final | El requisito 3 del ciclo de entrega pide al menos 3 commits: cada requisito funcionando va a commit |
