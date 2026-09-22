# Continuidad pedagógica — Repaso tras evaluación de la Unidad 3

**Curso:** Minimal API con C# .NET 6
**Momento de uso:** Tras la evaluación de la Unidad 3 (encuentro 26)
**Duración teórica:** 240 minutos
**Requisitos:** Computadora con SDK .NET 6, VS Code, terminal, conexión a Internet, archivo `hospital.db` copiado junto al `.csproj`.
**Contenido repasado:** Unidades 1, 2 y 3 completas — fundamentos de C#, Minimal API GET, SQLite y Dapper (SELECT, JOIN, parámetros, LIKE), INSERT con POST, DELETE con MapDelete, UPDATE con MapPut, JOIN triple y CRUD completo.

---

## Objetivos

- Implementar los cuatro verbos HTTP (GET, POST, PUT, DELETE) con Dapper sobre SQLite.
- Ejecutar INSERT con `ExecuteScalar<long>` para obtener el ID generado.
- Ejecutar DELETE con `Execute` y devolver `Results.NoContent`.
- Ejecutar UPDATE con `Execute` y devolver `Results.NoContent` si se actualizó algo, o `Results.NotFound` si no existe.
- Escribir un JOIN entre tres tablas (`patients`, `admissions`, `doctors`) con alias y parámetros.
- Aplicar todas las convenciones del curso: `long` en PK, `string` en fechas, alias `AS`, consultas parametrizadas.

---

## Actividades (100 puntos — 240 minutos)

### Actividad 1 — POST: INSERT con Dapper (20 puntos — 50 minutos)

Escribí el código completo de un endpoint `POST /patients` que reciba en el cuerpo de la solicitud (`Body`) un objeto JSON con los siguientes campos: `firstName`, `lastName`, `gender`, `birthDate`, `city` (opcional) y `allergies` (opcional).

El endpoint debe:

1. Validar que `firstName`, `lastName`, `gender` y `birthDate` no sean `null` ni estén vacíos. Si falta alguno, devolver `Results.BadRequest`.
2. Insertar el nuevo paciente con `ExecuteScalar<long>`.
3. Devolver `Results.Created` con la URL del nuevo recurso y los datos insertados.

Usá un record `PatientCreateRequest` para el *body* y reutilizá el `Patient` existente para la respuesta. Incluí el record posicional `Patient` si no está declarado.

| Criterio | Puntaje |
| --- | --- |
| Validación de campos obligatorios con `Results.BadRequest` | 6 ptos. |
| INSERT con `ExecuteScalar<long>` para obtener el nuevo ID | 6 ptos. |
| Devolución `Results.Created` con URL (`$"/patients/{newId}"`) y datos | 5 ptos. |
| Record de request correcto (tipos `string?` en opcionales) | 3 ptos. |

### Actividad 2 — DELETE: borrar un paciente (20 puntos — 50 minutos)

Escribí un endpoint `DELETE /patients/{id:long}` que:

1. Ejecute un DELETE sobre la tabla `patients` con `@id`.
2. Si `Execute` devuelve 0 (no se borró nada, el paciente no existe), devolver `Results.NotFound`.
3. Si se borró al menos una fila, devolver `Results.NoContent`.

| Criterio | Puntaje |
| --- | --- |
| Ruta `{id:long}` y parámetro `long id` | 5 ptos. |
| DELETE parametrizado con `Execute` | 5 ptos. |
| Comprobación del valor de retorno de `Execute` (filas afectadas) | 5 ptos. |
| `Results.NotFound` vs. `Results.NoContent` correctos | 5 ptos. |

### Actividad 3 — PUT: actualizar un paciente (20 puntos — 50 minutos)

Escribí un endpoint `PUT /patients/{id:long}` que reciba en el cuerpo un objeto JSON con los mismos campos que en la Actividad 1.

El endpoint debe:

1. Verificar que el paciente existe con `QueryFirstOrDefault<Patient>`.
2. Si no existe, devolver `Results.NotFound`.
3. Si existe, ejecutar un UPDATE con `Execute` para todos los campos.
4. Devolver `Results.NoContent`.

| Criterio | Puntaje |
| --- | --- |
| Verificación de existencia con `QueryFirstOrDefault` | 6 ptos. |
| UPDATE parametrizado con `Execute` (todos los campos) | 6 ptos. |
| `Results.NotFound` y `Results.NoContent` correctos | 4 ptos. |
| Reutilización del record `PatientCreateRequest` o similar para el body | 4 ptos. |

### Actividad 4 — JOIN triple con filtro (20 puntos — 50 minutos)

La tabla `admissions` tiene las columnas: `admission_id`, `patient_id`, `admission_date`, `discharge_date`, `diagnosis` y `doctor_id`.

Escribí un endpoint `GET /admissions` que devuelva todas las admisiones con el nombre del paciente y el nombre del médico, combinando las tres tablas con JOIN.

El resultado debe ser una lista de objetos con esta estructura:

```json
[
  {
    "admissionId": 1,
    "patientName": "James Smith",
    "doctorName": "William Johnson",
    "diagnosis": "Allergy",
    "admissionDate": "2024-01-15"
  }
]
```

Incluí el record `AdmissionDetail` necesario para el mapeo.

| Criterio | Puntaje |
| --- | --- |
| JOIN entre 3 tablas (admissions → patients, admissions → doctors) | 8 ptos. |
| Alias AS para todas las columnas del SELECT | 5 ptos. |
| Record `AdmissionDetail` con tipos correctos | 4 ptos. |
| Devolución con `Results.Ok` | 3 ptos. |

### Actividad 5 — Repaso integrador U1+U2 (20 puntos — 40 minutos)

Sin ejecutar en la computadora, escribí en tu hoja el código de un endpoint `GET /doctors/{id:long}/summary` que devuelva un resumen de un médico:

1. Obtenga el médico por ID desde la tabla `doctors`.
2. Obtenga la cantidad de admisiones a su cargo desde la tabla `admissions` (COUNT).
3. Devuelva:

```json
{
  "doctorId": 3,
  "fullName": "William Johnson",
  "specialty": "Cardiology",
  "totalAdmissions": 12
}
```

Si el médico no existe, devolver `Results.NotFound`.

| Criterio | Puntaje |
| --- | --- |
| Consulta del médico con `QueryFirstOrDefault` | 6 ptos. |
| Consulta de COUNT con `ExecuteScalar<long>` | 6 ptos. |
| Objeto de respuesta con las cuatro propiedades | 4 ptos. |
| Manejo de médico inexistente con `Results.NotFound` | 4 ptos. |

---

## Autoevaluación para el alumno

| Afirmación | Lo logré | Lo logré parcialmente | No lo logré |
| --- | --- | --- | --- |
| Implemento POST con `ExecuteScalar<long>` y `Results.Created`. | ☐ | ☐ | ☐ |
| Implemento DELETE con `Execute` y `Results.NoContent`. | ☐ | ☐ | ☐ |
| Implemento PUT con verificación de existencia y `Results.NoContent`. | ☐ | ☐ | ☐ |
| Escribo un JOIN entre tres tablas con alias. | ☐ | ☐ | ☐ |
| Uso `ExecuteScalar<long>` para COUNT. | ☐ | ☐ | ☐ |
| Aplico las convenciones del curso (long en PK, alias AS, parámetros @). | ☐ | ☐ | ☐ |

**Tiempo real que me llevó:** ________ minutos.

---

## Nota académica obligatoria

La resolución de estas actividades se realiza en forma habitual, por lo general en grupo. Las tareas de programación requieren el uso de la computadora. La presentación es **individual y manuscrita**, al inicio de la próxima clase, y constituye una actividad más de la asignatura que forma parte del proceso de evaluación.