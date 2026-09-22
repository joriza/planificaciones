# Encuentro 24 — CRUD completo y JOIN triple

## Metadatos de bloque

| Campo | Valor |
|---|---|
| **Duracion** | 240 minutos |
| **Unidad** | 3 — CRUD completo con Dapper |
| **Eje** | 5 — CRUD con Dapper |
| **Tipo** | Procedimental |
| **Requiere** | Encuentros 21-23 (POST, DELETE, PUT), manejo solido de `ExecuteScalar<long>`, `Execute` y `QueryFirstOrDefault` |
| **Nuevo concepto** | CRUD completo sobre una tabla, JOIN triple entre `admissions`, `doctors` y `patients`, record anidado |

## Reparto de tiempos (240 minutos)

| Bloque | Duracion |
|---|---|
| Apertura y motivacion | 20 min |
| Teoria minima con ejemplo completo | 50 min |
| Ejercicio progresivo | 120 min |
| Puesta en comun y correccion de errores | 30 min |
| Cierre | 20 min |

## Objetivos de aprendizaje

- Consolidar los cuatro verbos CRUD (GET, POST, PUT, DELETE) sobre la tabla `admissions`.
- Ejecutar una consulta JOIN que combine tres tablas (`admissions` + `doctors` + `patients`) en un solo endpoint.
- Mapear un resultado de JOIN triple usando un record compuesto con datos de varias tablas.
- Usar `SELECT` con alias para columnas de tablas distintas que tienen nombres iguales.

## Charla rapida / analogia

Hasta ahora trabajaste cada verbo por separado. Es como tener un martillo, un destornillador y una llave inglesa: cada herramienta sirve para una operacion distinta. Hoy vas a **armar la caja completa** aplicando los cuatro verbos sobre una sola tabla. Ademas, vas a hacer una **consulta que cruza tres tablas** (admisiones, doctores y pacientes) para responder la pregunta: "¿Que doctor atiende a que paciente, en que fecha y con que diagnostico?".

## Teoria minima

### JOIN triple

Un JOIN triple combina tres tablas encadenando dos JOIN:

```sql
SELECT a.admission_id, a.admission_date, a.diagnosis,
       d.first_name AS DoctorFirstName, d.last_name AS DoctorLastName,
       p.first_name AS PatientFirstName, p.last_name AS PatientLastName
FROM admissions a
JOIN doctors d ON a.doctor_id = d.doctor_id
JOIN patients p ON a.patient_id = p.patient_id
```

Cada JOIN agrega columnas de una tabla adicional. Cuando dos columnas tienen el mismo nombre (`first_name` en doctores y pacientes), **es obligatorio usar alias** para distinguirlas.

### Record compuesto

Para mapear un JOIN triple necesitas un record que contenga las columnas de las tres tablas:

```csharp
record AdmissionDetail(long AdmissionId, string AdmissionDate, string? Diagnosis,
                       long DoctorId, string DoctorFirstName, string? DoctorLastName,
                       long PatientId, string PatientFirstName, string? PatientLastName);
```

Los nombres del record coinciden con los alias del SELECT.

### CRUD completo sobre admissions

Al final de este encuentro vas a tener estos endpoints para `admissions`:

| Verbo | Ruta | Accion |
|---|---|---|
| GET | `/admissions` | Listar todas con JOIN triple |
| GET | `/admissions/{id:long}` | Una admision con JOIN triple |
| POST | `/admissions` | Crear nueva admision |
| PUT | `/admissions/{id:long}` | Actualizar admision existente |
| DELETE | `/admissions/{id:long}` | Eliminar admision |

## Practica guiada: endpoint GET /admissions con JOIN triple

Agregamos este endpoint que lista las admisiones con los nombres del doctor y del paciente:

```csharp
// GET /admissions — listar admisiones con JOIN triple
app.MapGet("/admissions", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var admisiones = connection.Query<AdmissionDetail>(@"
        SELECT a.admission_id AS AdmissionId,
               a.admission_date AS AdmissionDate,
               a.diagnosis AS Diagnosis,
               d.doctor_id AS DoctorId,
               d.first_name AS DoctorFirstName,
               d.last_name AS DoctorLastName,
               p.patient_id AS PatientId,
               p.first_name AS PatientFirstName,
               p.last_name AS PatientLastName
        FROM admissions a
        JOIN doctors d ON a.doctor_id = d.doctor_id
        JOIN patients p ON a.patient_id = p.patient_id
        ORDER BY a.admission_date DESC").ToList();

    return Results.Ok(admisiones);
});
```

Record al final del archivo:

```csharp
record AdmissionDetail(long AdmissionId, string AdmissionDate, string? Diagnosis,
                       long DoctorId, string DoctorFirstName, string? DoctorLastName,
                       long PatientId, string PatientFirstName, string? PatientLastName);
```

### ¿Que hace cada linea?

1. `FROM admissions a` — alias `a` para admissions (ahorra escritura en JOINs).
2. `JOIN doctors d ON a.doctor_id = d.doctor_id` — cruza con doctores.
3. `JOIN patients p ON a.patient_id = p.patient_id` — cruza con pacientes.
4. `ORDER BY a.admission_date DESC` — las mas recientes primero.
5. Cada columna tiene alias para que Dapper coincida con el record `AdmissionDetail`.
6. Las columnas con nombre repetido (`first_name`, `last_name`) se diferencian con prefijos `Doctor` y `Patient`.

### Salida esperada

```bash
curl http://localhost:5000/admissions

# Respuesta: 200 OK
# Cuerpo: [
#   {
#     "admissionId": 1,
#     "admissionDate": "2024-03-15",
#     "diagnosis": "Neumonia",
#     "doctorId": 3,
#     "doctorFirstName": "Carlos",
#     "doctorLastName": "Mendez",
#     "patientId": 5,
#     "patientFirstName": "Maria",
#     "patientLastName": "Garcia"
#   },
#   ...
# ]
```

## Ejercicio progresivo

### Etapa 1 — GET /admissions/{id:long} con JOIN triple (guiada)

Crea el endpoint que devuelve una sola admision con JOIN triple. Usa `QueryFirstOrDefault` con parametro `@id`.

**Pista:** la consulta es la misma que la del listado pero agregando `WHERE a.admission_id = @id` al final.

### Etapa 2 — CRUD completo: POST + PUT + DELETE sobre admissions (semiguiada)

Combina los endpoints de los encuentros 21, 22 y 23 en un unico archivo `Program.cs` que tenga GET, POST, PUT y DELETE sobre `admissions`. Usa `AdmissionInput` para la entrada y `Admission` para el record basico.

**Pista:** copia los endpoints que ya escribiste en encuentros anteriores y unificalos en el mismo archivo. Asegurate de que los records esten todos despues de `app.Run()`.

### Etapa 3 — GET /patients?search=texto con JOIN a provincia (independiente)

Crea un endpoint GET que busque pacientes por nombre (o apellido) usando `LIKE` e incluya el nombre de la provincia mediante JOIN con `province_names`. Debe devolver un record compuesto con datos del paciente y de la provincia.

**Pista:** `SELECT p.patient_id AS PatientId, p.first_name AS FirstName, ..., pr.province_name AS ProvinceName FROM patients p JOIN province_names pr ON p.province_id = pr.province_id WHERE p.first_name LIKE @search`. El parametro debe ser `"%texto%"`.

### Qué te llevás

- Un JOIN triple combina tres tablas con dos `JOIN` consecutivos.
- Cuando dos tablas tienen columnas con el mismo nombre, los alias del SELECT son obligatorios.
- El record compuesto refleja las columnas del SELECT con sus alias.
- CRUD completo = GET + POST + PUT + DELETE sobre una misma tabla.

### Lo que viene

En el Encuentro 25 cerramos la Unidad 3: repaso general y entrega del TP-U3, una API que implementa CRUD completo sobre dos tablas relacionadas.

## Errores comunes y trampas

| Error | Causa | Solucion |
|---|---|---|
| `InvalidOperationException` en JOIN triple | Alias faltante o incorrecto en el SELECT. | Verificar que cada alias coincida exactamente con el nombre del parametro del record. |
| Dos columnas con el mismo nombre sin alias (ej. dos `first_name`) | Dapper construye el record con el ultimo valor, perdiendo datos. | Usar alias distintivos: `d.first_name AS DoctorFirstName`, `p.first_name AS PatientFirstName`. |
| JOIN sin condicion (`ON`) | Producto cartesiano: cada fila de admissions se combina con cada fila de doctors y patients. | Agregar `ON a.doctor_id = d.doctor_id` y `ON a.patient_id = p.patient_id`. |
| Olvidar `?.ToList()` en la consulta | `Query<T>` devuelve `IEnumerable<T>`, no `List<T>`. Puede diferir la ejecucion. | Agregar `.ToList()` para ejecutar la consulta inmediatamente. |
| El PUT de admisiones actualiza todas las filas | Falta `WHERE admission_id = @Id` en el UPDATE. | Verificar que el WHERE este presente y que el objeto anonimo incluya `Id = id`. |