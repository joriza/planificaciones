# Evaluación U2 — Versión B: Doctores y admisiones

## Metadatos de versión

| Campo | Valor |
|---|---|
| Versión | B |
| Versiones equivalentes | A (Pacientes y provincias) |
| Dominio de datos | Doctores con JOIN a admisiones |
| Consultas | SELECT, WHERE, LIKE, JOIN, ORDER BY |
| Proyecto base | `tp-u2/` |

## Consigna

Construir una Minimal API que consulte la base `hospital.db` usando Dapper, con endpoints sobre la tabla `doctors` y su relación con `admissions`. Todos los endpoints deben usar consultas parametrizadas, alias `AS` obligatorios y registros posicionales con tipos canónicos.

### Endpoints requeridos

| Método | Ruta | Comportamiento |
|---|---|---|
| GET | `/doctors` | Devuelve todos los doctores ordenados por `last_name`. |
| GET | `/doctors/{id:long}` | Devuelve un doctor por ID; 404 si no existe. |
| GET | `/doctors/by-specialty/{specialty}` | Busca doctores cuya especialidad contenga el texto (LIKE `%texto%`). |
| GET | `/doctors/with-admissions` | Devuelve doctores con conteo de admisiones (LEFT JOIN y GROUP BY). |
| GET | `/patients/{id:long}` | Devuelve un paciente por ID; 404 si no existe. |

### Records necesarios

```csharp
record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);

record DoctorWithAdmissions(long DoctorId, string FirstName, string LastName,
                            string Specialty, long AdmissionCount);

record Patient(long PatientId, string FirstName, string LastName, string Gender,
               string BirthDate, string? City, string ProvinceId, string? Allergies,
               long? Height, long? Weight);
```

### Estructura del `Program.cs`

```
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// ... endpoints ...

app.Run();

// ... records ...
```

### Requisitos técnicos

- Todas las consultas parametrizadas con `@param` y `new { param = valor }`.
- `AS` alias en cada columna del SELECT.
- `Query<T>` para listas y `QueryFirstOrDefault<T>` para búsqueda individual.
- `Results.Ok()` y `Results.NotFound(new { mensaje = "..." })`.
- `using var connection` en cada endpoint.
- Endpoint `GET /doctors/by-specialty/{specialty}` debe usar `LIKE @patron` con `new { patron = $"%{specialty}%" }`.
- Endpoint `GET /doctors/with-admissions` debe usar `LEFT JOIN admissions a ON d.doctor_id = a.doctor_id` con `GROUP BY` y `COUNT(*)`.

### Entrega en GitHub

```bash
# Dentro del repositorio grupal
mkdir -p tp-u2
# Copiar Program.cs y hospital.db a tp-u2/
# Crear .gitignore
git add .
git commit -m "tp-u2: consultas doctores con Dapper y SQLite"
git push
```

### Puntaje

100 puntos según la rúbrica de la evaluación maestra.

## Criterios de corrección específicos

| Criterio | Esperado |
|---|---|
| SELECT sin alias AS | No compila con Dapper. Penalizar 5 puntos. |
| ID como `int` | Penalizar 5 puntos. |
| LIKE sin `%` alrededor del patrón | No filtra correctamente. Penalizar 5 puntos. |
| JOIN sin ON | Error SQL. Penalizar 10 puntos. |
| GROUP BY sin las columnas no agregadas | Error SQL en SQLite. Penalizar 10 puntos. |