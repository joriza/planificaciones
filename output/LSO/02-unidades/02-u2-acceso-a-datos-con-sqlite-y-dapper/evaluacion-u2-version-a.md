# Evaluación U2 — Versión A: Pacientes y provincias

## Metadatos de versión

| Campo | Valor |
|---|---|
| Versión | A |
| Versiones equivalentes | B (Doctores y admisiones) |
| Dominio de datos | Pacientes con JOIN a provincias |
| Consultas | SELECT, WHERE, LIKE, JOIN, ORDER BY |
| Proyecto base | `tp-u2/` |

## Consigna

Construir una Minimal API que consulte la base `hospital.db` usando Dapper, con endpoints sobre la tabla `patients` y su relación con `province_names`. Todos los endpoints deben usar consultas parametrizadas, alias `AS` obligatorios y registros posicionales con tipos canónicos.

### Endpoints requeridos

| Método | Ruta | Comportamiento |
|---|---|---|
| GET | `/patients` | Devuelve todos los pacientes ordenados por `last_name`. |
| GET | `/patients/{id:long}` | Devuelve un paciente por ID; 404 si no existe. |
| GET | `/patients/by-name/{lastName}` | Busca pacientes cuyo apellido contenga el texto (LIKE `%texto%`). |
| GET | `/patients/with-province` | Devuelve pacientes con `ProvinceName` (JOIN con `province_names`). |
| GET | `/doctors/{id:long}` | Devuelve un doctor por ID; 404 si no existe. |

### Records necesarios

```csharp
record Patient(long PatientId, string FirstName, string LastName, string Gender,
               string BirthDate, string? City, string ProvinceId, string? Allergies,
               long? Height, long? Weight);

record PatientWithProvince(long PatientId, string FirstName, string LastName, string Gender,
                           string BirthDate, string? City, string ProvinceName, string? Allergies,
                           long? Height, long? Weight);

record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);
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
- Endpoint `GET /patients/by-name/{lastName}` debe usar `LIKE @patron` con `new { patron = $"%{lastName}%" }`.
- Endpoint `GET /patients/with-province` debe hacer `JOIN province_names pn ON p.province_id = pn.province_id`.

### Entrega en GitHub

```bash
# Dentro del repositorio grupal
mkdir -p tp-u2
# Copiar Program.cs y hospital.db a tp-u2/
# Crear .gitignore
git add .
git commit -m "tp-u2: consultas pacientes con Dapper y SQLite"
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