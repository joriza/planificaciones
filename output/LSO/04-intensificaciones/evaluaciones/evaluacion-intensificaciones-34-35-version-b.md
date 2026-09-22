# Evaluación — Intensificación de las Unidades 3 y 4 — Versión B

## Metadatos

| Campo | Valor |
|---|---|
| Versión | B |
| Dominio de datos | CRUD sobre tabla `Doctors` en `hospital.db` |
| Duración | 120 min |
| Tipo de evaluación | Por objetivo mínimo — Apto / No apto aún |

## Consigna

Sobre tu proyecto Minimal API, implementá las operaciones CRUD sobre la tabla `Doctors` y configurá el flujo Git. Trabajá de forma individual.

### Endpoints requeridos

1. **POST /doctors** — Recibe un JSON con `FirstName`, `LastName`, `Specialty`. Insertá con `ExecuteScalar<long>`, devolvé `Results.Created` con la URL del nuevo doctor.

2. **PUT /doctors/{id:long}** — Recibe el JSON completo del doctor. Verificá que exista con `QueryFirstOrDefault`. Si no existe, devolvé `Results.NotFound`. Si existe, ejecutá `UPDATE` con `Execute`, devolvé `Results.Ok` con el registro actualizado.

3. **DELETE /doctors/{id:long}** — Verificá existencia. Si no existe, devolvé `Results.NotFound`. Si existe, ejecutá `DELETE` con `Execute`, devolvé `Results.NoContent`.

4. Probá el ciclo completo con Thunder Client: POST → GET → PUT → GET → DELETE → GET (esperá 404).

### Git y README

5. Creá una rama `feature/crud-minimo`. Commiteá tus cambios. Abrí un Pull Request en GitHub y mergealo.

6. Escribí un `README.md` que incluya:
   - Título del proyecto
   - Descripción breve
   - Tecnologías (C#, .NET 6, SQLite, Dapper)
   - Tabla de endpoints (método, ruta, descripción)