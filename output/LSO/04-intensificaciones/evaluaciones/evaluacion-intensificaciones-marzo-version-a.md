# Evaluación — Intensificación de marzo — Versión A

## Metadatos

| Campo | Valor |
|---|---|
| Versión | A |
| Dominio de datos | CRUD completo sobre tabla `Patients` con JOIN a `Provinces` |
| Duración | 120 min |
| Tipo de evaluación | Por objetivo mínimo — Apto / No apto aún |

## Consigna

Presentá tu proyecto Minimal API completo sobre `hospital.db` que cumpla los siguientes puntos. Trabajá de forma individual. El proyecto puede ser el mismo que trabajaste durante diciembre y el verano, o uno nuevo.

### Requisitos (idénticos a diciembre)

1. **Programa de consola** (proyecto separado o integrado): variables `string`, `int` y `double`; condicional `if/else`; bucle `for`; función `static` con parámetro y retorno.

2. **GET /patients** — Lista completa con `Query<Patient>`.

3. **GET /patients/{id:long}** — Un paciente por ID con `QueryFirstOrDefault`. Si no existe, devolvé `Results.NotFound`.

4. **POST /patients** — Insertá con `ExecuteScalar`, devolvé `Results.Created`.

5. **PUT /patients/{id:long}** — Verificá existencia, actualizá con `Execute`, devolvé `Results.Ok` o `Results.NotFound`.

6. **DELETE /patients/{id:long}** — Verificá existencia, borrá con `Execute`, devolvé `Results.NoContent` o `Results.NotFound`.

7. Ciclo CRUD completo probado.

8. Rama `feature/crud-minimo` en GitHub, PR mergeado.

9. README.md con título, descripción, tecnologías y tabla de endpoints.

### Defensa

Durante la evaluación, el docente te va a pedir que:
- Expliques qué hace el endpoint POST y cómo se genera el nuevo ID.
- Muestres qué pasa cuando hacés GET de un ID que no existe.
- Señales en el código dónde se usan consultas parametrizadas.