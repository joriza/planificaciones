# Encuentro 27 — Git profesional: ramas y PR

> Profesionalización y proyecto final

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 27 de 36 |
| Unidad | 4 — Profesionalización y proyecto final |
| Eje temático | 6 — Profesionalización y control de versiones |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 240 minutos (4 horas reloj) |
| Concepto nuevo | Git profesional: ramas y PR |
| Requisitos previos | Haber completado el CRUD completo de la API Minimal con Dapper (Unidades 1-3) |
| Uso de celular | No permitido |
| Organización del trabajo | Grupos de trabajo (presentes ÷ equipos disponibles); cada grupo opera su propio repositorio |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y motivación | 20 min |
| Desarrollo teórico-práctico | 120 min |
| Consolidación y cierre | 20 min |
| Actividad complementaria | 80 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

1. Crear y gestionar ramas por feature en un repositorio compartido.
2. Abrir y revisar pull requests dentro del mismo grupo.
3. Configurar la rama `main` protegida para evitar pushes directos.
4. Aplicar el flujo profesional de Git al repositorio del trabajo final.

## 3. Apertura y motivación (20 min)

### Charla rápida

Imaginate que están cocinando un plato complejo en una cocina compartida. Si cada uno toca todos los ingredientes a la vez, se arma un caos: se pisaron los sabores, se rompió la receta. En programación pasa lo mismo cuando varios tocan el mismo código sin orden. Las ramas y los pull requests son la forma de organizar esa cocina: cada uno trabaja en su porción y antes de integrar, el resto del equipo revisa que no se haya roto nada.

### Puente desde el trabajo anterior

En los encuentros anteriores construyeron una API Minimal completa con Dapper: endpoints GET, POST, PUT y DELETE contra `hospital.db`. Todo el código vivía en un solo archivo `Program.cs` sobre la rama `main`. Pero en un equipo real, trabajar directamente sobre `main` es riesgoso: un cambio roto afecta a todos. Hoy van a aprender el flujo profesional que usan los equipos de desarrollo: ramas por feature, pull requests revisados y `main` protegida.

## 4. Desarrollo teórico-práctico (120 min)

### 4.1 — Ramas por feature (40 min)

En un flujo profesional, cada cambio nuevo se trabaja en una rama separada. La rama `main` siempre está limpia y lista para desplegar. Las ramas por feature llevan el nombre de lo que hacen, por ejemplo: `feature/crud-pacientes`, `feature/endpoints-join`, `feature/readme`.

**Concepto clave:** la rama `main` es la línea principal del proyecto. Las ramas de feature son copias aisladas donde se desarrolla una funcionalidad sin afectar al resto del equipo.

**Práctica guiada (código en Program.cs — solo para mostrar el contexto):**

El código de la API ya existe en el repositorio del grupo. Lo que cambia es la forma en que se trabaja sobre él:

```csharp
// Program.cs — la API Minimal con Dapper ya está funcionando
// Cada grupo tiene su repositorio en GitHub con la rama main protegida
// Los cambios se hacen en ramas de feature, nunca directamente en main

using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";

// GET /patients — listar todos los pacientes
app.MapGet("/patients", () =>
{
    // Abrir conexion a la base de datos
    using var connection = new SqliteConnection(connectionString);
    var patients = connection.Query<Patient>("SELECT * FROM patients");
    return Results.Ok(patients);
});

// Record posicional al final, despues de app.Run()
public record Patient(long PatientId, string FirstName, string LastName, string Gender, string BirthDate, string? City, long ProvinceId, string? Allergies, long? Height, long? Weight);
```

**Ejercicio independiente:**

Cada grupo debe:
1. Crear la rama `feature/crud-completo` desde `main`.
2. Hacer un cambio pequeño en `Program.cs` (por ejemplo, agregar un endpoint nuevo).
3. Commitear con mensaje descriptivo en español, sin tildes: `git commit -m "trabajo-final: agregar endpoint de pacientes"`
4. Push de la rama a GitHub.

### 4.2 — Pull requests revisados (40 min)

Una vez que la rama de feature está lista, se abre un pull request (PR) para proponer la integración en `main`. Lo importante: **otro miembro del mismo grupo revisa el PR antes de que se fusione**. Esto garantiza que dos pares de ojos miraron cada cambio.

**Flujo del PR dentro del grupo:**
1. El desarrollador abre un PR desde `feature/<nombre>` hacia `main`.
2. Otro integrante del grupo revisa el código, verifica que compile y que los endpoints funcionen.
3. Si hay observaciones, el autor las aborda en la misma rama y las sube.
4. El revisor aprueba y fusiona el PR.
5. La rama de feature se puede borrar después de fusionar.

**Práctica guiada:**

El docente muestra en pantalla cómo:
- Abrir un PR desde GitHub (web interface).
- Agregar un revisor del propio grupo.
- Dejar un comentario en una línea específica del código.
- Aprobar y fusionar.

**Ejercicio independiente:**

Cada grupo abre un PR desde `feature/crud-completo` hacia `main`. Un integrante del mismo grupo actúa como revisor y deja al menos un comentario o aprobación.

### 4.3 — Main protegida (40 min)

La rama `main` protegida es una barrera de seguridad: nadie puede hacer push directo a ella. Todos los cambios llegan a través de un PR revisado. Esto evita que un cambio roto se cuelgue en la línea principal del proyecto.

**Configuración en GitHub:**
1. Ir a Settings → Branches → Branch protection rules.
2. Agregar regla para `main`.
3. Marcar: "Require a pull request before merging" y "Require approvals" (al menos 1).
4. Marcar: "Include administrators" si aplica.

**Práctica guiada:**

Cada grupo configura la protección de `main` en su repositorio. Luego intentan hacer push directo a `main` y verifican que GitHub lo bloquea.

## 5. Consolidación y cierre (20 min)

Se revisan los conceptos clave en forma de pregunta rápida entre todos los grupos:

- ¿Qué es una rama de feature y para qué sirve?
- ¿Por qué no se puede hacer push directo a `main` cuando está protegida?
- ¿Quién revisa un pull request en el flujo de trabajo del grupo?
- ¿Qué mensaje de commit se espera?

El docente aclara dudas y verifica que cada grupo tenga al menos una rama de feature creada y un PR abierto.

## 6. Actividad complementaria (80 min)

### Trabajo en grupo: flujo profesional completo

Cada grupo completa el flujo profesional completo en su repositorio:

1. **Configurar `main` protegida** en GitHub (5 min).
2. **Crear la rama `feature/readme-portada`** y preparar el README de portada del repositorio (15 min).
3. **Crear la rama `feature/issues`** y abrir issues para organizar el trabajo final (15 min).
4. **Crear la rama `feature/crud-completo`** y verificar que el CRUD completo funcione contra `hospital.db` (20 min).
5. **Abrir PRs** para cada feature y que un compañero del grupo revise (15 min).
6. **Fusionar PRs** en orden y borrar ramas (10 min).

La actividad de extensión incluye verificar que cada PR tenga al menos una revisión aprobada antes de fusionar, y que `main` permanezca limpia durante todo el proceso.

## 7. Cierre (15 min)

### Qué te llevás

- Las ramas por feature permiten trabajar en paralelo sin pisarse.
- Los pull requests son el mecanismo de revisión dentro del equipo.
- La rama `main` protegida garantiza que solo código revisado se integra.
- El flujo profesional (rama → PR → revisión → merge) es el estándar en la industria.

## Lo que viene

Encuentro 28: README de portada y más — van a armar el README de portada del repositorio y a organizar el trabajo con issues de GitHub.

## 8. Errores comunes y trampas

| ✔ | Error | Causa probable | Intervención |
| --- | --- | --- | --- |
| ☐ | Hacer push directo a `main` y recibir rechazo de GitHub | No se configuró branch protection | Verificar que la regla de protección esté activa para `main` y que requiera PR |
| ☐ | Crear un PR sin asignar revisor del grupo | No se entiende que la revisión es interna | Recordar que el PR debe ser revisado por otro integrante del mismo grupo |
| ☐ | Commits con mensajes en inglés o con tildes | No seguir la convención del curso | El mensaje debe estar en español, minúsculas después de los dos puntos, sin tildes |
| ☐ | Trabajar en `main` en lugar de en una rama de feature | No crear la rama antes de empezar a codear | Siempre crear una rama `feature/<nombre>` antes de hacer cualquier cambio |
| ☐ | Fusionar PR sin revisión | Saltear el paso de revisión | El flujo requiere al menos una aprobación antes de merge |
