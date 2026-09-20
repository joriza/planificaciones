# Evaluación — Momento integrador de las Unidades 1 y 2 — Versión B

## Metadatos

| Campo | Valor |
|---|---|
| Versión | B |
| Dominio de datos | Tabla `Doctors` con JOIN a `Admissions` y filtro por especialidad |
| Duración | 120 min (incluye defensa) |
| Tipo de evaluación | Rúbrica de 100 puntos |

## Consigna

Completá los siguientes endpoints en tu proyecto Minimal API sobre `hospital.db`. Trabajá de forma individual. Al final, subí el proyecto a GitHub y preparate para una defensa breve.

### Endpoints requeridos

1. **GET /doctors** — Devuelve todos los doctores. Campos: `DoctorId`, `FirstName`, `LastName`, `Specialty`.
   *(Endpoints GET base — 30 pts)*

2. **GET /doctors/{id:long}** — Devuelve un doctor por ID. Si no existe, devolvé `Results.NotFound`.
   *(Endpoints GET base — 30 pts)*

3. **GET /doctors/with-admissions** — Devuelve nombre del doctor y cantidad de admisiones que registró. LEFT JOIN entre `Doctors` y `Admissions` con `GROUP BY`. Mapeá a un record `DoctorAdmissions` con las propiedades `FullName` y `TotalAdmissions`.
   *(Consultas Dapper con JOIN — 25 pts)*

4. **GET /doctors/by-specialty?specialty=Cardiology** — Devuelve los doctores de la especialidad indicada. Usá parámetro Dapper `@specialty`.
   *(Parámetros y filtros — 20 pts)*

### Entrega

- Subí el proyecto a GitHub (repo del curso o repo individual).
- El README debe listar los endpoints con método, ruta y descripción.
- Durante la defensa (5 min por estudiante), explicá el endpoint 3 y mostrá qué pasa cuando consultás un ID inexistente.