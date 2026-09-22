# Encuentro 13 — Parámetros y LIKE en Dapper

**Unidad 2:** Acceso a datos con SQLite y Dapper  
**Duración:** 240 minutos  
**Carácter:** Procedimental  
**Eje 4:** Dapper y consultas parametrizadas  

---

## Objetivos de aprendizaje

- Usar parámetros con `@` en consultas Dapper para evitar inyección SQL.
- Filtrar texto con `LIKE` y el comodín `%`.
- Construir objetos anónimos `new { ... }` para pasar parametros a Dapper.
- Combinar filtro parametrizado con JOIN en un endpoint GET.

---

## Charla rápida

En la clase 10 concatenaban el valor directamente al SQL: `"'ON'"`. Eso funciona, pero es peligroso: si un usuario malicioso escribe un valor con comillas, puede manipular la consulta (inyección SQL). Ademas, si el valor contiene una comilla, el SQL se rompe. La forma correcta es usar parametros con `@`: el SQL dice `WHERE provincia = @prov`, y el valor se pasa aparte. Como una carta que lleva el destinatario en el sobre, no escrito en la carta misma.

---

## Teoría mínima

### Parámetros con `@`

En lugar de concatenar:

```csharp
// MAL (concatenación — riesgo de inyeccion)
command.CommandText = "SELECT ... WHERE province_id = '" + provincia + "'";

// BIEN (parametrizado — seguro)
connection.Query<Doctor>(sql, new { provincia });
```

El SQL usa `@nombre` y el valor se pasa en un objeto anónimo con propiedades que coinciden con esos nombres.

### LIKE y comodín %

`LIKE` busca patrones en texto. `%` significa "cualquier secuencia de caracteres".

```sql
WHERE allergies LIKE '%Penicillin%'
```

Esto devuelve pacientes que tienen "Penicillin" en cualquier parte del campo `allergies`.

Con parametros:

```sql
WHERE allergies LIKE @alergia
```
```csharp
new { alergia = "%Penicillin%" }  // el % va en el valor, no en el SQL
```

### Objeto anónimo

```csharp
new { id = 42 }
new { alergia = "%Penicillin%", provincia = "ON" }
```

Las propiedades del objeto anónimo deben coincidir exactamente (nombre y cantidad) con los `@parametros` del SQL.

---

## Práctica guiada

Van a crear un endpoint que busque pacientes por alergia usando Dapper con LIKE parametrizado.

### Paso 1: Crear el proyecto

```bash
dotnet new web -o dapper-parametros
cd dapper-parametros
```

Copiar `hospital.db` junto al `.csproj`. Agregar paquetes:

```bash
dotnet add package Microsoft.Data.Sqlite
dotnet add package Dapper
```

### Paso 2: Escribir el código

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";

// Record para pacientes con provincia
public record PatientWithProvince(
    long PatientId,
    string FirstName,
    string LastName,
    string Gender,
    string BirthDate,
    string? City,
    string ProvinceName,
    string? Allergies,
    long? Height,
    long? Weight
);

// GET /patients/allergy/{allergyText} — buscar pacientes por alergia
app.MapGet("/patients/allergy/{allergyText}", (string allergyText) =>
{
    using var connection = new SqliteConnection(connectionString);

    // El parametro LIKE lleva los % en el valor, no en la consulta
    var patients = connection.Query<PatientWithProvince>(@"
        SELECT p.patient_id AS PatientId,
               p.first_name AS FirstName,
               p.last_name AS LastName,
               p.gender AS Gender,
               p.birth_date AS BirthDate,
               p.city AS City,
               pn.province_name AS ProvinceName,
               p.allergies AS Allergies,
               p.height AS Height,
               p.weight AS Weight
        FROM patients p
        JOIN province_names pn ON p.province_id = pn.province_id
        WHERE p.allergies LIKE @patron
        ORDER BY p.last_name, p.first_name
    ", new { patron = $"%{allergyText}%" }).ToList();

    return patients.Count == 0
        ? Results.Ok(new List<PatientWithProvince>())  // lista vacia, no 404
        : Results.Ok(patients);
});

app.Run();
```

### Paso 3: Probar

```bash
dotnet run
```

Probar:
- `http://localhost:5000/patients/allergy/Penicillin` — devuelve pacientes con alergia a Penicillin.
- `http://localhost:5000/patients/allergy/Peanuts` — devuelve pacientes con alergia a maní.
- `http://localhost:5000/patients/allergy/XYZ` — devuelve lista vacía `[]` (ningún paciente tiene esa alergia).

Notar que la busqueda es parcial: `"Penicillin"` encuentra tambien `"Penicillin (severe)"` si existiera, porque el `%` cubre ambos extremos.

---

## Ejercicio independiente

**Consigna:** Crear un endpoint `/patients/by-province` que acepte un código de provincia como parámetro de ruta (ej: `ON`, `BC`) y devuelva los pacientes de esa provincia usando Dapper con un parámetro `@prov`. Usar el record `PatientWithProvince` de la práctica guiada.

**Pista:** La consulta JOIN es igual a la de la práctica guiada, pero el WHERE cambia de `allergies LIKE @patron` a `p.province_id = @prov`.

**Solución esperada:**

```csharp
// GET /patients/by-province/{provinceId} — pacientes por provincia
app.MapGet("/patients/by-province/{provinceId}", (string provinceId) =>
{
    using var connection = new SqliteConnection(connectionString);

    var patients = connection.Query<PatientWithProvince>(@"
        SELECT p.patient_id AS PatientId,
               p.first_name AS FirstName,
               p.last_name AS LastName,
               p.gender AS Gender,
               p.birth_date AS BirthDate,
               p.city AS City,
               pn.province_name AS ProvinceName,
               p.allergies AS Allergies,
               p.height AS Height,
               p.weight AS Weight
        FROM patients p
        JOIN province_names pn ON p.province_id = pn.province_id
        WHERE p.province_id = @prov
        ORDER BY p.last_name, p.first_name
    ", new { prov = provinceId }).ToList();

    return Results.Ok(patients);
});
```

Probar `http://localhost:5000/patients/by-province/ON` (muchos), `BC` (pocos), `XX` (vacio).

---

### Qué te llevás

- Los parámetros con `@` y objetos anónimos eliminan la concatenación de SQL, previniendo inyección y errores de sintaxis.
- `LIKE` con `%` permite búsquedas parciales de texto.
- El valor del comodín se incluye en el objeto anónimo, no en el SQL.

### Lo que viene

En el Encuentro 14 se cierra la Unidad 2: repaso de todos los conceptos y entrega del TP-U2 (SQLite y Dapper básico).

## Errores comunes y trampas

| Error | Causa | Solución |
|-------|-------|----------|
| `@` en el objeto anónimo | `new { @patron = ... }` es inválido; el `@` solo va en el SQL | Usar `new { patron = ... }` sin `@` |
| Los `%` en el SQL en vez del valor | `LIKE '%@patron%'` no funciona porque Dapper no expande el `%` dentro del string | Escribir en C#: `new { patron = $"%{texto}%" }` |
| El nombre del parámetro no coincide | Dapper no encuentra el valor y la consulta falla en runtime | Verificar que `@prov` en SQL coincida con `new { prov = ... }` |
| Olvidar `?` en `string? Allergies` | Si la alergia es NULL, Dapper no puede asignar `null` a un `string` no nulable | Declarar `string? Allergies` |
| `Query<T>` sin `.ToList()` | No falla pero devuelve `IEnumerable<T>` diferido | Agregar `.ToList()` |
| `InvalidOperationException` por tipo | `doctor_id` como `int` en vez de `long` | Usar `long DoctorId` |
| LIKE sensible a mayúsculas | SQLite es sensible por defecto para TEXT con LIKE | Usar `LIKE` (default de SQLite es case-insensitive para ASCII) |

---

## Reparto de tiempos (240 minutos)

| Bloque | Minutos |
|--------|---------|
| Apertura y motivación | 20 |
| Desarrollo teórico-práctico | 120 |
| Consolidación y cierre | 20 |
| Actividad complementaria | 80 |
| **Total** | **240** |