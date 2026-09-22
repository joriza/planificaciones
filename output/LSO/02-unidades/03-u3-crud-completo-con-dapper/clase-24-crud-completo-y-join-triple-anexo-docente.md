# Anexo docente — Encuentro 24: CRUD completo y JOIN triple

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

La solución de referencia es el Program.cs completo con los cuatro endpoints CRUD mostrado en el Paso 1 del desarrollo teórico-práctico.

**Salida esperada con hospital.db real**:

```
> curl http://localhost:5000/patients | head -c 500

HTTP/1.1 200 OK
Content-Type: application/json

[
  {
    "patientId": 1,
    "firstName": "Donald",
    "lastName": "Waterfield",
    "gender": "M",
    "birthDate": "1963-02-12",
    "city": "Barrie",
    "provinceId": "ON",
    "allergies": "Penicillin",
    "height": 156,
    "weight": 65
  },
  {
    "patientId": 2,
    "firstName": "Mickey",
    "lastName": "Baasha",
    "gender": "M",
    "birthDate": "2017-11-19",
    "city": null,
    "provinceId": "ON",
    "allergies": null,
    "height": null,
    "weight": null
  }
]
```

```
> curl -X POST http://localhost:5000/patients \
    -H "Content-Type: application/json" \
    -d '{"firstName":"Test","lastName":"User","gender":"M","birthDate":"2000-01-01","provinceId":"ON"}'

HTTP/1.1 201 Created
Location: /patients/259

{
  "patientId": 259,
  "firstName": "Test",
  "lastName": "User",
  "gender": "M",
  "birthDate": "2000-01-01",
  "city": null,
  "provinceId": "ON",
  "allergies": null,
  "height": null,
  "weight": null
}
```

```
> curl -X PUT http://localhost:5000/patients/259 \
    -H "Content-Type: application/json" \
    -d '{"firstName":"Test","lastName":"User","gender":"M","birthDate":"2000-01-01","city":"Toronto","provinceId":"ON"}'

HTTP/1.1 204 No Content
```

```
> curl -X DELETE http://localhost:5000/patients/259

HTTP/1.1 204 No Content
```

## 2. Solución de la actividad de extensión

### Actividad 1 — Endpoint GET con JOIN de 3 tablas y filtro por especialidad

La solución completa está en la Actividad 1 del encuentro. La salida esperada para `GET /admissions/by-specialty/Cardiologist`:

```
> curl http://localhost:5000/admissions/by-specialty/Cardiologist | head -c 800

HTTP/1.1 200 OK
Content-Type: application/json

[
  {
    "patientId": 258,
    "patientName": "Zoe Anderson",
    "doctorName": "Monica Singleton",
    "doctorSpecialty": "Cardiologist",
    "admissionDate": "2019-06-02",
    "dischargeDate": null,
    "diagnosis": "Pregnancy"
  }
]
```

### Actividad 2 — Paginación del JOIN con filtros combinados

La solución completa está en la Actividad 2 del encuentro. La salida esperada para `GET /admissions/detail?provinceId=ON&page=1&pageSize=2`:

```json
[
  {
    "patientId": 258,
    "patientName": "Zoe Anderson",
    "doctorName": "Monica Singleton",
    "doctorSpecialty": "Cardiologist",
    "admissionDate": "2019-06-02",
    "dischargeDate": null,
    "diagnosis": "Pregnancy"
  },
  {
    "patientId": 257,
    "patientName": "Yvonne Fisher",
    "doctorName": "Larry Miller",
    "doctorSpecialty": "Cardiovascular Surgeon",
    "admissionDate": "2019-06-01",
    "dischargeDate": "2019-06-05",
    "diagnosis": "Myocardial Infarction"
  }
]
```

## 3. Respuesta esperada del ejercicio

| Pedido | Respuesta esperada | Código |
| --- | --- | --- |
| GET /patients | Array de 258 pacientes ordenados por patient_id | 200 |
| GET /patients/1 | Paciente Donald Waterfield | 200 |
| GET /patients/9999 | `{ "mensaje": "Paciente no encontrado" }` | 404 |
| POST /patients con datos válidos | Paciente creado con patientId asignado | 201 |
| POST /patients sin firstName | `{ "mensaje": "El nombre y el apellido son obligatorios" }` | 400 |
| PUT /patients/1 con datos válidos | Sin body | 204 |
| PUT /patients/9999 | `{ "mensaje": "Paciente no encontrado" }` | 404 |
| DELETE /patients/1 | Sin body | 204 |
| DELETE /patients/9999 | `{ "mensaje": "Paciente no encontrado" }` | 404 |
| GET /admissions/detail | Array de 306+ ingresos con paciente y doctor | 200 |
| GET /admissions/by-specialty/Cardiologist | Array de ingresos filtrados por Cardiologist | 200 |

## 4. Criterios de corrección (lista de verificación)

- [ ] Los cuatro endpoints (GET, POST, PUT, DELETE) están presentes en el mismo Program.cs
- [ ] Cada endpoint usa `using var connection = new SqliteConnection(connectionString)`
- [ ] El GET usa `Query<T>` y devuelve `Results.Ok(lista)`
- [ ] El POST usa `ExecuteScalar<long>` y devuelve `Results.Created(url, dato)` con código 201
- [ ] El PUT valida existencia primero y devuelve `Results.NoContent()` con código 204
- [ ] El DELETE valida existencia primero y devuelve `Results.NoContent()` con código 204
- [ ] El JOIN de 3 tablas usa `JOIN patients p ON ... JOIN doctors d ON ...`
- [ ] Cada columna del SELECT del JOIN tiene alias `AS` que coincide con el record
- [ ] Los records están después de `app.Run()`
- [ ] No hay carpetas `Models/`, `Services/`, `Interfaces/` ni `Controllers/`
- [ ] El código compila y corre tal cual contra hospital.db
- [ ] Los comentarios en el código están en español y no llevan tildes ni eñes dentro del código fuente

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| `InvalidOperationException` al materializar el record del JOIN | Falta un alias `AS` en alguna columna del SELECT. | Verificar que cada columna tenga `AS NombreDelCampo` coincidiendo con el record. |
| `null` en `PatientName` o `DoctorName` | El `||` en SQLite devuelve `null` si algún operando es `NULL`. | Usar `COALESCE` para manejar nulos en la concatenación. |
| El JOIN no devuelve resultados | Se usó `JOIN` pero las FKs tienen valores inexistentes. | Verificar que los `patient_id` y `attending_doctor_id` en `admissions` tengan registros en las tablas padre. |
| CS8803: records before top-level statements | Los records están antes de `app.Run()`. | Mover los records después de `app.Run()`. |
| `500` al ejecutar cualquier endpoint | `hospital.db` no está en la carpeta correcta. | Verificar que el archivo esté junto al `.csproj`. |
| El POST devuelve `200` en vez de `201` | Se usó `Results.Ok()` en vez de `Results.Created()`. | `Results.Created(url, dato)` devuelve `201` con header `Location`. |

## 6. Registro de la clase

| Grupo | Completó los 4 endpoints CRUD | Implementó el JOIN de 3 tablas | Usó alias AS en el SELECT | Probo el endpoint con JOIN | Observaciones |
| --- | --- | --- | --- | --- | --- |
| Grupo 1 | Sí | Sí | Sí | Sí | |
| Grupo 2 | Sí | Sí | No, faltó alias en 1 columna | Sí | Requiere refuerzo en alias AS |
| Grupo 3 | Sí (faltó DELETE) | No | Sí | No | Requiere refuerzo en DELETE y JOIN |
| Grupo 4 | Sí | Sí | Sí | Sí | |

**Notas para la evaluación de proceso:** verificar que cada grupo pueda explicar por qué se usan alias `AS` en el SELECT del JOIN. Evaluar si el grupo entiende la diferencia entre `ExecuteScalar<long>` (INSERT), `Execute` (UPDATE/DELETE), `Query<T>` (GET many) y `QueryFirstOrDefault<T>` (GET one). Registrar qué grupos no completaron los 4 endpoints o tuvieron errores en el JOIN.
