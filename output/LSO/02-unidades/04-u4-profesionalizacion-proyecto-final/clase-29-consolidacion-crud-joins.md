# Encuentro 29 — Consolidación CRUD con JOINs

**Unidad 4:** Profesionalización y proyecto final
**Carácter:** Procedimental
**Duración:** 240 minutos

---

## Objetivos de aprendizaje

- Consolidar las cuatro operaciones CRUD (GET, POST, PUT, DELETE) con Dapper.
- Implementar endpoints con JOIN entre dos y tres tablas.
- Diseñar un endpoint de conteo con agrupación.
- Aplicar el flujo Git profesional para integrar los cambios.

---

## Reparto de tiempos (240 minutos)

| Bloque | Minutos |
|---|---|
| Apertura y motivación | 20 |
| Desarrollo teórico-práctico | 120 |
| Consolidación y cierre | 20 |
| Actividad complementaria / trabajo final | 80 |
| **Total** | **240** |

---

## Teoría mínima

### Repaso rápido del CRUD canónico

| Operación | Endpoint | Método Dapper | Código HTTP |
|---|---|---|---|
| Listar todos | `GET /patients` | `Query<T>` | 200 |
| Obtener uno | `GET /patients/{id:long}` | `QueryFirstOrDefault<T>` | 200 / 404 |
| Crear | `POST /patients` | `ExecuteScalar<long>` | 201 |
| Actualizar | `PUT /patients/{id:long}` | `Execute` | 204 / 404 |
| Eliminar | `DELETE /patients/{id:long}` | `Execute` | 204 / 404 |

### JOIN de dos tablas (pacientes + provincias)

```sql
SELECT pa.patient_id AS PatientId,
       pa.first_name AS FirstName,
       pa.last_name AS LastName,
       pa.gender AS Gender,
       pa.birth_date AS BirthDate,
       pa.city AS City,
       pn.province_name AS ProvinceName
FROM patients pa
JOIN province_names pn ON pa.province_id = pn.province_id
```

### JOIN de tres tablas (admisiones + doctores + pacientes)

```sql
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
```

### Endpoint de conteo con agrupación

```sql
SELECT pn.province_name AS ProvinceName,
       COUNT(pa.patient_id) AS PatientCount
FROM province_names pn
LEFT JOIN patients pa ON pa.province_id = pn.province_id
GROUP BY pn.province_name
ORDER BY PatientCount DESC
```

---

## Práctica guiada

### Paso 1: Endpoint GET con JOIN de dos tablas

Crear o verificar el endpoint que devuelve pacientes con el nombre de la provincia:

```csharp
app.MapGet("/patients/with-province", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var patients = connection.Query(@"
        SELECT pa.patient_id AS PatientId,
               pa.first_name AS FirstName,
               pa.last_name AS LastName,
               pa.gender AS Gender,
               pa.birth_date AS BirthDate,
               pa.city AS City,
               pa.allergies AS Allergies,
               pa.height AS Height,
               pa.weight AS Weight,
               pn.province_name AS ProvinceName
        FROM patients pa
        JOIN province_names pn ON pa.province_id = pn.province_id
    ").ToList();
    return Results.Ok(patients);
});
```

Probar con `curl http://localhost:5000/patients/with-province`.

### Paso 2: Endpoint de conteo por provincia

Agregar el endpoint que devuelve cuántos pacientes tiene cada provincia:

```csharp
app.MapGet("/patients/count-by-province", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var result = connection.Query(@"
        SELECT pn.province_name AS ProvinceName,
               COUNT(pa.patient_id) AS PatientCount
        FROM province_names pn
        LEFT JOIN patients pa ON pa.province_id = pn.province_id
        GROUP BY pn.province_name
        ORDER BY PatientCount DESC
    ").ToList();
    return Results.Ok(result);
});
```

Probar con `curl http://localhost:5000/patients/count-by-province`.

### Paso 3: Endpoint de admisiones con JOIN triple

```csharp
app.MapGet("/admissions/with-doctors-patients", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var admissions = connection.Query(@"
        SELECT a.id AS AdmissionId,
               a.admission_date AS AdmissionDate,
               a.discharge_date AS DischargeDate,
               d.doctor_id AS DoctorId,
               d.first_name AS DoctorFirstName,
               d.last_name AS DoctorLastName,
               d.specialty AS Specialty,
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

### Paso 4: Integrar con el flujo Git

Los cambios de este encuentro se trabajan desde la rama `main` del repositorio grupal, dentro de la carpeta `trabajo-final/`:

```bash
git checkout main
git pull origin main
git checkout -b feature/endpoint-joins
# agregar los endpoints al Program.cs del trabajo final
git add .
git commit -m "trabajo-final: endpoints con JOINs y conteo por provincia"
git push origin feature/endpoint-joins
```

Abrir Pull Request, solicitar revisión y mergear.

---

## Ejercicio independiente

Sobre la base del trabajo final en `trabajo-final/`:

1. Agregar un endpoint `GET /doctors/{id:long}` que devuelva un doctor con la cantidad de admisiones que atendió.
2. El endpoint debe usar `QueryFirstOrDefault` con un JOIN entre `doctors` y `admissions`, y un `COUNT` agrupado.
3. Probar con `curl http://localhost:5000/doctors/1`.
4. Integrar el cambio mediante el flujo Git profesional (rama, PR, revisión, merge).

**Pista:** la consulta SQL puede ser:

```sql
SELECT d.doctor_id AS DoctorId,
       d.first_name AS FirstName,
       d.last_name AS LastName,
       d.specialty AS Specialty,
       COUNT(a.id) AS AdmissionCount
FROM doctors d
LEFT JOIN admissions a ON a.attending_doctor_id = d.doctor_id
WHERE d.doctor_id = @id
```

**Solución esperada:** endpoint funcional que devuelve un doctor con la cantidad de admisiones. PR mergeado en el repositorio grupal.

---

### Qué te llevás

- El CRUD con JOINs es la operación más común en APIs reales.
- Combinar datos de varias tablas, contarlos y devolverlos en un mismo endpoint es lo que distingue una API funcional de un asistente de base de datos.

### Lo que viene

En el Encuentro 30 todo el tiempo se dedica al avance del trabajo final: cada grupo llega con los endpoints de este encuentro integrados y funcionando.

## Errores comunes y trampas

| Error | Causa | Solución |
|---|---|---|
| JOIN sin alias en columnas | Dapper busca nombres PascalCase y encuentra snake_case | Usar `SELECT columna AS Propiedad` siempre. |
| LEFT JOIN vs INNER JOIN | Se usa LEFT cuando se necesitan solo los que tienen relación | Elegir según la necesidad: LEFT incluye filas sin relación, INNER solo las que coinciden. |
| COUNT sin GROUP BY | La consulta devuelve una sola fila | Agrupar por las columnas no agregadas. |
| Endpoint devuelve 500 | La consulta SQL tiene un error (tabla mal nombrada, columna inexistente) | Revisar el mensaje de error en la terminal; probar la consulta directamente en SQLite. |
| Olvidar `ToList()` en `Query<T>` | Dapper ejecuta la consulta pero no materializa la lista | `Query<T>(sql).ToList()` fuerza la ejecución y cierra el lector. |