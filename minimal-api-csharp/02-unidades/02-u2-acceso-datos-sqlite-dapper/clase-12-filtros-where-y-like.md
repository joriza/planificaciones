# Encuentro 12 — Filtros WHERE y búsquedas con LIKE

> Unidad 2 — Acceso a datos con SQLite y Dapper

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 12 |
| Unidad | 2 — Acceso a datos con SQLite y Dapper |
| Duración teórica | 4 horas reloj (240 minutos) |
| Concepto nuevo | Filtros WHERE con parámetros (objeto anónimo) y búsquedas parciales con LIKE |
| Requisitos previos | Clase 11 completada (conexión a hospital.db con Microsoft.Data.Sqlite, `Query<T>` de Dapper, records como DTOs y mapeo con alias AS). Tener a mano el archivo `hospital.db` |
| Uso de celular | No permitido |
| Planificación anual | Encuentro 12: «Filtros WHERE / Parámetros con objeto anónimo» y «Búsquedas con LIKE / Endpoints de búsqueda» |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y puente | 30 min |
| Teoría mínima | 45 min |
| Práctica guiada | 90 min |
| Ejercicio independiente | 55 min |
| Puesta en común y cierre | 20 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

**Apertura y puente (30 min).** La API ya consulta hospital.db, pero siempre devuelve lo mismo: la lista entera. Pregunta disparadora: en la recepción del hospital, cuando alguien pregunta "¿hay algún paciente apellidado parecido a...?", nadie lee el libro de fichas completo: se filtra. ¿Cómo le dice el cliente a la API qué filas quiere? La respuesta de hoy tiene dos partes: la cláusula WHERE define el criterio y el parámetro transporta el valor, separado del texto SQL.

Al finalizar el encuentro, cada estudiante puede:

1. Escribir consultas SELECT con WHERE y parámetros `@` usando objetos anónimos de Dapper (`new { ... }`), sin concatenar strings.
2. Explicar por qué concatenar valores en el texto SQL produce errores de sintaxis y abre la puerta a la inyección SQL.
3. Construir patrones de búsqueda parcial con LIKE y el comodín `%`, pasando el patrón como valor del parámetro.
4. Implementar y probar endpoints GET de búsqueda contra hospital.db, por parámetro de ruta y por query string.
5. Elegir entre filtro exacto (`=`) y búsqueda parcial (LIKE) según lo que pida la consulta.

## 3. Teoría mínima (45 min)

### Charla rápida: el dato no dicta la pregunta

En la recepción, el visitante dice el valor: "busco a alguien apellidado parecido a Morris". La recepcionista no le entrega el libro de fichas para que la reemplace: ella conserva la pregunta y solo recibe el dato. Si el visitante pudiera dictar instrucciones ("buscá, y de paso arrancá la página de las altas"), el desastre está servido. Con la base de datos pasa lo mismo: el texto SQL es la pregunta fija de la API; lo que llega del cliente es un valor que se usa dentro de esa pregunta, nunca una parte de la pregunta.

### Lo mínimo indispensable

**Filtro exacto con WHERE y parámetro.** La cláusula WHERE filtra filas; el marcador `@City` no es texto: es un hueco con nombre que Dapper completa con el valor que viaja en el objeto anónimo, aparte del SQL:

```sql
WHERE city = @City
```

```csharp
// La clave del objeto anónimo completa el marcador @City.
new { City = city }
```

La clave debe llamarse igual que el marcador (para Dapper no distingue mayúsculas de minúsculas: `City` y `city` equivalen). Regla de oro del curso: **el texto SQL nunca se arma concatenando valores**.

**El camino prohibido y por qué.**

```csharp
// NUNCA hacer esto: el valor viaja pegado al texto SQL.
var sql = "SELECT ... WHERE city = '" + city + "'";
```

Con `city = "Toronto"` parece funcionar. Pero alcanza con que llegue `Toronto' OR '1'='1` para que la condición se lea "city = 'Toronto' o siempre-verdad": la consulta devuelve TODOS los pacientes, y con instrucciones más agresivas (borrar tablas) el daño es mayor. Eso es **inyección SQL**: el dato se interpreta como parte de la instrucción. Además, un apóstrofe inocente (un apellido como O'Brien) rompe la sintaxis y produce un error. Con parámetros, el SQL viaja fijo y el valor viaja separado: lo que llegue es dato, nunca instrucción.

**Búsqueda parcial con LIKE.** El comodín `%` reemplaza cualquier secuencia de caracteres:

| Patrón | Significado | Ejemplo que coincide |
| --- | --- | --- |
| `'Pen%'` | empieza con "Pen" | Penicillin |
| `'%ia'` | termina en "ia" | Penicillin |
| `'%son%'` | contiene "son" | Watson, Johnson |

LIKE se combina con parámetros igual que `=`. La única diferencia: el patrón se arma **dentro del valor**, no en el texto SQL:

```csharp
// El comodín % se escribe en el VALOR; el SQL sigue siendo fijo.
new { Pattern = "%" + term + "%" }
```

Dato útil: en SQLite, LIKE no distingue mayúsculas de minúsculas en texto sin acentos: `%SON%` encuentra lo mismo que `%son%`. El filtro exacto con `=`, en cambio, sí distingue.

**Buscar y no encontrar no es un error.** Un endpoint de búsqueda devuelve 200 con una lista vacía (`[]`) cuando nada coincide. El 404 queda reservado para "este recurso individual no existe", como el paciente por id de la Unidad 1.

## 4. Práctica guiada (90 min)

### Paso 1 — Crear el proyecto

```powershell
dotnet new web -n BusquedasApi
cd BusquedasApi
code .
```

### Paso 2 — Agregar los paquetes

```powershell
dotnet add package Microsoft.Data.Sqlite
dotnet add package Dapper
```

### Paso 3 — Copiar hospital.db a la raíz del proyecto

El mismo archivo de las clases 10 y 11: 13 provincias, 27 médicos, 258 pacientes, 306 ingresos. Verificar con `ls` (o el explorador de VS Code) que `hospital.db` queda en la raíz, junto al `.csproj`.

### Paso 4 — Reemplazar Program.cs

Abrir `Program.cs`, borrar todo su contenido y pegar este código completo:

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Cadena de conexion: el archivo hospital.db vive en la raiz del proyecto.
var connectionString = "Data Source=hospital.db";

// GET /patients/by-city/{city}: filtro EXACTO con WHERE y parametro.
app.MapGet("/patients/by-city/{city}", (string city) =>
{
    // Una conexion nueva por pedido (using: se cierra sola al terminar).
    using var connection = new SqliteConnection(connectionString);

    // El SQL es fijo: @City es un marcador, no texto que se reemplaza a mano.
    var patients = connection.Query<PatientCard>(@"
        SELECT patient_id AS PatientId,
               first_name AS FirstName,
               last_name AS LastName,
               city AS City,
               allergies AS Allergies
        FROM patients
        WHERE city = @City
        ORDER BY last_name, first_name",
        // Objeto anonimo: la clave City completa el marcador @City.
        new { City = city }).ToList();

    return Results.Ok(patients);
});

// GET /patients/search?lastName=xxx: busqueda PARCIAL con LIKE (query string).
app.MapGet("/patients/search", (string lastName) =>
{
    using var connection = new SqliteConnection(connectionString);

    var patients = connection.Query<PatientCard>(@"
        SELECT patient_id AS PatientId,
               first_name AS FirstName,
               last_name AS LastName,
               city AS City,
               allergies AS Allergies
        FROM patients
        WHERE last_name LIKE @Pattern
        ORDER BY last_name, first_name",
        // El comodin % se escribe en el VALOR: el SQL sigue siendo fijo.
        new { Pattern = "%" + lastName + "%" }).ToList();

    return Results.Ok(patients);
});

app.Run();

// Los tipos (records) se declaran al final del archivo cuando el programa
// usa instrucciones de nivel superior: es una regla de C#.
// DTO minimo: solo las columnas que la busqueda necesita (record inmutable).
record PatientCard(long PatientId, string FirstName, string LastName, string? City, string? Allergies);
```

### Paso 5 — Levantar la API

```powershell
dotnet run
```

Anotar el puerto de la línea `Now listening on:` (en los ejemplos se usa `http://localhost:5080`; reemplazar por el puerto propio).

### Paso 6 — Probar el filtro exacto en el navegador

- `http://localhost:5080/patients/by-city/Toronto` → 200 con los pacientes de esa ciudad.
- `http://localhost:5080/patients/by-city/toronto` → 200 con `[]`: el filtro exacto distingue mayúsculas.
- `http://localhost:5080/patients/by-city/Nowhere` → 200 con `[]`: búsqueda sin coincidencias, no un error.

### Paso 7 — Probar la búsqueda parcial con requests.http

El navegador también sirve acá, pero con query string conviene el archivo de pedidos de la Unidad 1. En la raíz del proyecto, crear `requests.http`:

```http
### Busqueda parcial: apellidos que contienen "son" (esperar 200)
GET http://localhost:5080/patients/search?lastName=son

### Patron vacio: %% coincide con todos los apellidos (las 258 filas)
GET http://localhost:5080/patients/search?lastName=

### Mayusculas: mismo resultado que "son" (LIKE no distingue en SQLite)
GET http://localhost:5080/patients/search?lastName=SON

### Sin el parametro de query string (esperar 400)
GET http://localhost:5080/patients/search
```

Ejecutar con "Send Request" justo encima de cada pedido. Recordar reemplazar `5080` por el puerto propio.

### Salidas esperadas

**GET /patients/by-city/Toronto** → 200. La cantidad exacta de filas depende de los datos de hospital.db; la estructura debe coincidir con esta (respuesta similar a):

```json
[
  {
    "patientId": 12,
    "firstName": "Emily",
    "lastName": "Watson",
    "city": "Toronto",
    "allergies": "Penicillin"
  }
]
```

**GET /patients/by-city/Nowhere** → 200 con lista vacía:

```json
[]
```

**GET /patients/search?lastName=son** → 200 con todos los pacientes cuyo apellido contenga "son" (Watson, Johnson, ...) — misma estructura que el ejemplo anterior.

**GET /patients/search?lastName=** → 200 con las 258 filas: el patrón `%%` coincide con cualquier apellido (la columna es NOT NULL, no hay filas descartadas).

**GET /patients/search (sin parámetro)** → 400: el parámetro de query string es requerido; sin él, la API no sabe qué buscar y corta antes de llegar a la base de datos.

## 5. Ejercicio independiente (55 min)

### Consigna

Agregar al mismo proyecto dos endpoints de búsqueda nuevos:

1. `GET /patients/by-province/{provinceId}`: filtro exacto por código de provincia (`ON`, `BC`, `NS`, ...). Usar el mismo DTO `PatientCard` de la práctica. Respuesta: 200 con la lista, incluso si viene vacía (un código inexistente es una búsqueda sin coincidencias, no un error).
2. `GET /patients/search-allergy?term=xxx`: búsqueda parcial por alergia: pacientes cuya columna `allergies` contenga el término (por ejemplo `term=penicil` encuentra a los alérgicos a Penicillin). Respuesta: 200 con la lista, incluso vacía.

### Pista

Repetir el patrón de la práctica: SQL fijo con marcador, objeto anónimo con la clave correspondiente y alias AS hacia el DTO en cada columna. Para la búsqueda parcial, el `%` se arma en el valor. Dato a tener en cuenta: `allergies` admite NULL — un valor NULL nunca coincide con LIKE, por eso los pacientes sin alergias registradas no aparecen en el resultado. La solución completa está en el anexo docente.

## 6. Cierre (20 min)

### Qué te llevás

- WHERE filtra filas y el parámetro transporta el valor: SQL fijo + objeto anónimo (`new { City = city }`), nunca concatenación.
- Concatenar valores en el SQL es inyección SQL: el dato pasa a ser instrucción.
- LIKE busca parcial con `%`: el comodín se escribe en el valor del parámetro.
- Búsqueda sin coincidencias = 200 con `[]`; el 404 queda para el recurso individual inexistente.
- El filtro exacto (`=`) distingue mayúsculas; LIKE en SQLite no.

### Lo que viene

Encuentro 13: «JOIN de dos tablas / Consulta con relación» y «Pacientes y provincias / GET con datos reales». La ficha del paciente trae solo el código de provincia (`ON`): el próximo encuentro enseña a completarla con el nombre real consultando la tabla relacionada `province_names`.

### Recordatorio de commit (rutina desde el Encuentro 5)

Con los endpoints funcionando y el ejercicio terminado, al cierre del encuentro:

```powershell
git add .
git commit -m "Clase 12: filtros WHERE con parámetros y búsquedas con LIKE"
git push
```

## 7. Errores comunes y trampas

| Trampa | Causa | Cómo se resuelve |
| --- | --- | --- |
| Armar el SQL concatenando valores (`"..." + city + "..."`) | Creer que el SQL es "un string más" | SQL fijo con marcador `@` + objeto anónimo: el valor viaja separado y no puede convertirse en instrucción |
| Escribir el patrón dentro del SQL (`LIKE '%@term%'`) | Tratar el marcador como si fuera parte del texto | El marcador entre comillas es texto literal; el patrón se arma en el valor: `new { Pattern = "%" + term + "%" }` |
| `SQLiteException: Must declare the scalar variable @city` | La clave del objeto anónimo no coincide con el marcador | Nombrar igual la clave y el marcador (`@City` ↔ `new { City = city }`) |
| Devolver 404 cuando la búsqueda no trae nada | Confundir "sin resultados" con "recurso inexistente" | Los endpoints de búsqueda devuelven 200 con `[]`; el 404 es para el recurso individual (paciente por id) |
| Lista devuelta con todas las propiedades vacías o nulas | Falta el alias AS: Dapper mapea por nombre y `first_name` no coincide con `FirstName` | Alias AS en cada columna hacia el PascalCase del DTO |
| 400 al probar el endpoint de búsqueda | Falta el parámetro de query string en la URL | Agregar `?lastName=...` (o `?term=...`): el parámetro es requerido, la API no adivina el criterio |
