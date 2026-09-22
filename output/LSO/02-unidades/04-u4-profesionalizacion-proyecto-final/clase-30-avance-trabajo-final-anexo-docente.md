# Anexo docente — Encuentro 30: Avance trabajo final

---

## Preguntas guía para la apertura

1. "¿Qué endpoints tiene hoy su trabajo final? ¿Cuáles faltan?"
2. "¿Cómo saben si un endpoint funciona correctamente sin tener que mirar el código?"
3. "Si tuvieran que explicar su API a alguien que no sabe programar, ¿qué le dirían?"

---

## Resumen teórico para el pizarrón

- Trabajo final mínimo: GET (listar, uno, JOIN, conteo), POST, PUT, DELETE + doctor con conteo.
- Verificación sistemática: curl o Thunder Client, código HTTP, JSON de respuesta, terminal de errores.
- Defensa individual: explicar endpoints, mostrar código, responder conceptos, demostrar Git.
- Antes del encuentro 31: todo en `main`, README completo, protección activa.

---

## Ejemplo de verificacion con curl (para proyectar)

```bash
# Probar que el servidor responde
curl -s http://localhost:5000/patients | head -c 200

# Verificar que la respuesta es JSON valido
curl -s http://localhost:5000/patients | python -m json.tool

# Verificar codigo HTTP
curl -s -o /dev/null -w "%{http_code}" http://localhost:5000/patients

# Probar 404
curl -s -w "\n%{http_code}" http://localhost:5000/patients/9999

# Probar POST y capturar la URL del recurso creado
curl -s -i -X POST http://localhost:5000/patients \
  -H "Content-Type: application/json" \
  -d '{"firstName":"Test","lastName":"User","gender":"M","birthDate":"2000-01-01","provinceId":1}' \
  | grep -i location
```

---

## Rúbrica de evaluación del ejercicio independiente

| Criterio | Logrado (2 pts) | En desarrollo (1 pt) | No logrado (0 pts) |
|---|---|---|---|
| Primera funcionalidad adicional | Endpoint funcional, probado, código correcto | Endpoint existe pero no funciona | No implementado |
| Segunda funcionalidad adicional | Endpoint funcional, probado, código correcto | Endpoint existe pero no funciona | No implementado |
| Todos los endpoints mínimos funcionan | Los 8 endpoints básicos devuelven la respuesta esperada | 5-7 endpoints funcionan | Menos de 5 endpoints |
| PR mergeado con los cambios | PR aprobado y mergeado en main | PR abierto sin merge | Sin PR |
| README actualizado | README incluye todos los endpoints del trabajo final | README incompleto | README sin cambios |

---

## Solucion de los ejercicios independientes

### 1. `GET /doctors` — listar doctores

```csharp
app.MapGet("/doctors", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var doctors = connection.Query(@"
        SELECT doctor_id AS DoctorId,
               first_name AS FirstName,
               last_name AS LastName,
               specialty AS Specialty
        FROM doctors
    ").ToList();
    return Results.Ok(doctors);
});
```

### 2. `GET /admissions` con JOIN completo

```csharp
app.MapGet("/admissions", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var admissions = connection.Query(@"
        SELECT a.id AS AdmissionId,
               a.admission_date AS AdmissionDate,
               a.discharge_date AS DischargeDate,
               d.doctor_id AS DoctorId,
               d.first_name AS DoctorFirstName,
               d.last_name AS DoctorLastName,
               p.patient_id AS PatientId,
               p.first_name AS PatientFirstName,
               p.last_name AS PatientLastName
        FROM admissions a
        JOIN doctors d ON a.attending_doctor_id = d.doctor_id
        JOIN patients p ON a.patient_id = p.patient_id
    ").ToList();
    return Results.Ok(admissions);
});
```

### 3. `GET /patients?search={texto}` con LIKE

```csharp
app.MapGet("/patients", (string? search) =>
{
    using var connection = new SqliteConnection(connectionString);
    if (string.IsNullOrWhiteSpace(search))
    {
        var patients = connection.Query<Patient>("SELECT patient_id AS PatientId, first_name AS FirstName, last_name AS LastName, gender AS Gender, birth_date AS BirthDate, city AS City, province_id AS ProvinceId, allergies AS Allergies, height AS Height, weight AS Weight FROM patients").ToList();
        return Results.Ok(patients);
    }
    var filtered = connection.Query<Patient>(@"
        SELECT patient_id AS PatientId, first_name AS FirstName,
               last_name AS LastName, gender AS Gender,
               birth_date AS BirthDate, city AS City,
               province_id AS ProvinceId, allergies AS Allergies,
               height AS Height, weight AS Weight
        FROM patients
        WHERE last_name LIKE @pattern", new { pattern = $"%{search}%" }).ToList();
    return Results.Ok(filtered);
});
```

### 4. `GET /patients/{id:long}/admissions`

```csharp
app.MapGet("/patients/{id:long}/admissions", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);
    var admissions = connection.Query(@"
        SELECT a.id AS AdmissionId,
               a.admission_date AS AdmissionDate,
               a.discharge_date AS DischargeDate,
               a.diagnosis AS Diagnosis,
               d.first_name AS DoctorFirstName,
               d.last_name AS DoctorLastName
        FROM admissions a
        JOIN doctors d ON a.attending_doctor_id = d.doctor_id
        WHERE a.patient_id = @id
    ", new { id }).ToList();
    return Results.Ok(admissions);
});
```

---

## Notas para el docente

- Este encuentro es el último de trabajo puramente técnico antes de la defensa. Circular entre los grupos para asegurarse de que todos tengan el mínimo funcional.
- Si algún grupo está muy atrasado (menos de 5 endpoints funcionando), ayudarlos a priorizar: primero los endpoints GET con JOIN, después POST, PUT, DELETE.
- Recordar a los grupos que el `Program.cs` del trabajo final debe estar en la carpeta `trabajo-final/` y tener su propio `hospital.db` (copiado al lado del `.csproj`).
- Para la defensa del encuentro 31, preparar una lista de preguntas conceptuales posibles:
  - ¿Por qué los IDs se declaran como `long` y no como `int`?
  - ¿Qué hace `ExecuteScalar<long>` en el POST?
  - ¿Por qué usamos alias `AS` en el SELECT?
  - ¿Cuál es la diferencia entre `Results.Ok`, `Results.Created` y `Results.NoContent`?
  - ¿Qué pasa si la rama `main` no está protegida?
- Advertir que el README debe estar completo para el encuentro 31. Sin README profesional, el trabajo final se considera incompleto.