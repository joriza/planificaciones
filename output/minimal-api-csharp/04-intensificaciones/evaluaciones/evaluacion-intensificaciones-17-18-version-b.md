# Evaluación — Intensificación de las Unidades 1 y 2 — Versión B

## Metadatos

| Campo | Valor |
|---|---|
| Versión | B |
| Dominio de datos | Tabla `Doctors` con `Admissions` (JOIN doctor- admisiones) |
| Duración | 120 min |
| Tipo de evaluación | Por objetivo mínimo — Apto / No apto aún |

## Consigna

Sobre tu proyecto Minimal API existente (el de los encuentros 17–18), creá los siguientes endpoints. Trabajá de forma individual. Verificá cada uno con Thunder Client.

### Endpoints requeridos

1. **GET /doctors** — Devuelve todos los doctores como JSON. Usá `Query<Doctor>`. Campos: `DoctorId`, `FirstName`, `LastName`, `Specialty`.

2. **GET /doctors/{id:long}** — Devuelve un doctor por su ID. Usá `QueryFirstOrDefault<Doctor>`. Si no existe, devolvé `Results.NotFound`.

3. **GET /doctors/with-admissions** — Devuelve una lista con nombre del doctor y cantidad de admisiones. Usá `LEFT JOIN Admissions` con `GROUP BY` y mapeá a un record `DoctorAdmissions` (propiedades `DoctorName` y `AdmissionCount`).

### Registros necesarios

Ubicalos después de `app.Run()`. Incluí `Doctor` con los campos canónicos de la tabla `doctors`. Definí `DoctorAdmissions` con las propiedades que necesita el endpoint 3.

### Condiciones de aprobación

- Todos los endpoints deben devolver JSON válido.
- El endpoint por ID debe devolver `404` para un ID inexistente.
- El JOIN debe mostrar datos reales de la base para al menos 2 doctores.
- El código debe usar consultas parametrizadas en todos los casos.
- No debe haber concatenación de cadenas SQL.