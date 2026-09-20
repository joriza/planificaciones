# Anexo docente — Encuentro 27: Git profesional: ramas y PR

---

## Preguntas guía para la apertura

1. "¿Cómo organizaron el código hasta ahora? ¿Todo en main, cada uno en su propia rama sin revisión?"
2. "¿Alguna vez perdieron trabajo por un merge conflictivo o por sobrescribir el archivo de otro?"
3. "¿Qué beneficios imaginan que trae revisar el código de un compañero antes de integrarlo?"

---

## Resumen teórico para el pizarrón

- Repositorio único del grupo con carpetas: `tp-u1/`, `tp-u2/`, `tp-u3/`, `trabajo-final/`.
- Issue → feature branch → trabajo local → PR → revisión → merge → borrar rama.
- Main protegida: nadie pushea directo, todo código pasa por revisión.
- Nomenclatura: `feature/<tema>` (inglés, guiones).

---

## Ejemplo de código completo para la práctica guiada

El ejemplo de la práctica guiada se centra en Git, no en código C#. Si algún grupo termina rápido y quiere ver el endpoint de conteo funcionando, puede usar este fragmento completo (basado en la base `hospital.db`):

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/patients/count-by-province", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var result = connection.Query(@"
        SELECT p.province_id AS ProvinceId,
               p.province_name AS ProvinceName,
               COUNT(pa.patient_id) AS PatientCount
        FROM province_names p
        LEFT JOIN patients pa ON pa.province_id = p.province_id
        GROUP BY p.province_id, p.province_name
    ").ToList();
    return Results.Ok(result);
});

app.Run();
```

El record no es necesario para `Query()` sin tipo genérico; si se desea tipar, el record sería:

```csharp
record PatientCountByProvince(long ProvinceId, string ProvinceName, long PatientCount);
```

---

## Rúbrica de evaluación del ejercicio independiente

| Criterio | Logrado (2 pts) | En desarrollo (1 pt) | No logrado (0 pts) |
|---|---|---|---|
| Issue creado con título y cuerpo descriptivo | Issue completo, describe la tarea | Issue creado sin cuerpo | No hay issue |
| Rama feature creada desde `main` | Rama con nombre `feature/...` creada y subida | Rama creada pero sin push | No hay rama |
| Pull Request abierto y vinculado al issue | PR con referencia al issue y descripción | PR abierto sin descripción ni vínculo | No hay PR |
| Revisión completada y merge | PR aprobado, mergeado y rama eliminada | PR mergeado sin revisión formal | PR sin merge |

---

## Solución del ejercicio independiente

El resultado esperado es un Pull Request en el repositorio del grupo que:

1. Partió de un issue con título y cuerpo.
2. Se implementó en rama `feature/pacientes-por-provincia`.
3. Se abrió el PR vinculado al issue.
4. Un compañero revisó y aprobó.
5. Se mergeó a `main` y se eliminó la rama remota.

El código del endpoint puede variar; lo importante es que el flujo Git se haya completado.

---

## Notas para el docente

- Es probable que algunos grupos tengan dudas con los merge conflicts. Si ocurren, proyecte la resolución en el pizarrón: `git merge main` en la rama feature, resolver conflictos, `git add` y continuar.
- Enfatizar que la protección de `main` se configura en GitHub Settings > Branches > Add rule. Se hará en el encuentro 28, pero puede mostrarse hoy si algún grupo pregunta.
- El ejercicio independiente es el primero que apunta directamente al trabajo final. Asegurarse de que todos los grupos tengan al menos un endpoint funcionando en `main` al final de la clase.
- Registrar qué grupos completaron el flujo completo (issue → PR mergeado) para dar seguimiento en los encuentros siguientes.