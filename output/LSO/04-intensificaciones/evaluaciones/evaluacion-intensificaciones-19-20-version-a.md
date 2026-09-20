# Evaluación — Momento integrador de las Unidades 1 y 2 — Versión A

## Metadatos

| Campo | Valor |
|---|---|
| Versión | A |
| Dominio de datos | Tabla `Patients` con JOIN a `Provinces` y filtro por ciudad |
| Duración | 120 min (incluye defensa) |
| Tipo de evaluación | Rúbrica de 100 puntos |

## Consigna

Completá los siguientes endpoints en tu proyecto Minimal API sobre `hospital.db`. Trabajá de forma individual. Al final, subí el proyecto a GitHub y preparate para una defensa breve.

### Endpoints requeridos

1. **GET /patients** — Devuelve todos los pacientes. Campos: `PatientId`, `FirstName`, `LastName`, `City`.
   *(Endpoints GET base — 30 pts)*

2. **GET /patients/{id:long}** — Devuelve un paciente por ID. Si no existe, devolvé `Results.NotFound`.
   *(Endpoints GET base — 30 pts)*

3. **GET /patients/with-province** — Devuelve nombre completo del paciente y nombre de la provincia. JOIN entre `Patients` y `Provinces`. Mapeá a un record `PatientProvince` con las propiedades `FullName` y `ProvinceName`.
   *(Consultas Dapper con JOIN — 25 pts)*

4. **GET /patients/by-city?city=Cordoba** — Devuelve los pacientes que viven en la ciudad indicada. Usá parámetro Dapper `@city`.
   *(Parámetros y filtros — 20 pts)*

### Entrega

- Subí el proyecto a GitHub (repo del curso o repo individual).
- El README debe listar los endpoints con método, ruta y descripción.
- Durante la defensa (5 min por estudiante), explicá el endpoint 3 y mostrá qué pasa cuando consultás un ID inexistente.