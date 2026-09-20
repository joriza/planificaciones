# Evaluación — Intensificación de las Unidades 1 y 2 — Versión A

## Metadatos

| Campo | Valor |
|---|---|
| Versión | A |
| Dominio de datos | Tabla `Patients` con `Provinces` (JOIN paciente-provincia) |
| Duración | 120 min |
| Tipo de evaluación | Por objetivo mínimo — Apto / No apto aún |

## Consigna

Sobre tu proyecto Minimal API existente (el de los encuentros 17–18), creá los siguientes endpoints. Trabajá de forma individual. Verificá cada uno con Thunder Client.

### Endpoints requeridos

1. **GET /employees** — Devuelve todos los pacientes como JSON. Usá `Query<Patient>` con los alias canónicos de `convenciones-tecnicas.md`.

2. **GET /employees/{id:long}** — Devuelve un paciente por su ID. Usá `QueryFirstOrDefault<Patient>`. Si no existe, devolvé `Results.NotFound`.

3. **GET /employees/with-province** — Devuelve una lista con nombre del paciente y nombre de la provincia. Usá `JOIN Provinces` y mapeá a un record `PatientWithProvince` (propiedades `FullName` y `ProvinceName`).

### Registros necesarios

Ubicalos después de `app.Run()`. Incluí `Patient` (campos canónicos). Definí `PatientWithProvince` con las propiedades que necesita el endpoint 3.

### Condiciones de aprobación

- Todos los endpoints deben devolver JSON válido.
- El endpoint por ID debe devolver `404` para un ID inexistente.
- El JOIN debe mostrar datos reales de la base para al menos 2 pacientes.
- El código debe usar consultas parametrizadas en todos los casos.
- No debe haber concatenación de cadenas SQL.