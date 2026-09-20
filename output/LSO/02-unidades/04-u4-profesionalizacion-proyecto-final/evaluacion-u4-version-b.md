# Evaluación U4 — Versión B: Proyecto final sobre doctores

## Metadatos de versión

| Campo | Valor |
|---|---|
| Versión | B |
| Versiones equivalentes | A (Proyecto final sobre pacientes) |
| Dominio de datos | Doctores (principal), pacientes como segunda tabla |
| Rama feature de ejemplo | `feature/endpoint-doctores-admisiones` |
| Proyecto base | `trabajo-final/` |

## Consigna

Construir el trabajo final integrador del curso: una API completa sobre la base `hospital.db` con CRUD sobre doctores, endpoints de lectura con JOIN y agregación, flujo Git profesional (issues, ramas, PR, main protegida) y README profesional. La defensa individual se realiza en el encuentro 32.

### Endpoints requeridos

| Método | Ruta | Comportamiento |
|---|---|---|
| GET | `/doctors` | Lista todos los doctores ordenados por apellido. |
| GET | `/doctors/{id:long}` | Doctor por ID; 404 si no existe. |
| GET | `/doctors/with-admissions` | Doctores con conteo de admisiones (LEFT JOIN + COUNT + GROUP BY). |
| GET | `/doctors/search` | Parámetro query `?specialty=texto`. Busca doctores cuya especialidad contenga el texto (LIKE). |
| POST | `/doctors` | Crear doctor. Validar que `FirstName` no esté vacío. 201. |
| PUT | `/doctors/{id:long}` | Actualizar doctor. 204 o 404. |
| DELETE | `/doctors/{id:long}` | Eliminar doctor. 204 o 404. |
| GET | `/patients/{id:long}` | Paciente por ID; 404 si no existe. |

### Records necesarios (al final de `Program.cs`)

```csharp
record DoctorInput(string FirstName, string? LastName, string? Specialty,
                   string? Phone, string? Email);

record Doctor(long DoctorId, string FirstName, string? LastName, string? Specialty,
              string? Phone, string? Email);

record DoctorWithAdmissions(long DoctorId, string FirstName, string? LastName,
                            string? Specialty, long AdmissionCount);

record Patient(long PatientId, string FirstName, string LastName, string Gender,
               string BirthDate, string? City, string ProvinceId, string? Allergies,
               long? Height, long? Weight);
```

### Flujo Git profesional (obligatorio para esta unidad)

1. Crear la carpeta `trabajo-final/` al inicio de la U4.
2. Crear issues en GitHub para cada endpoint o grupo de endpoints.
3. Trabajar en ramas `feature/nombre` (una por issue).
4. Abrir pull requests y asignar a otro integrante para revisión.
5. Mergear cada PR a `main` después de revisión.
6. Activar branch protection en `main`.
7. Mantener `.gitignore` y `hospital.db` junto al `.csproj`.

### README.md

Debe incluir:
- Nombre del proyecto y descripción
- Requisitos (.NET 6 SDK, paquetes NuGet)
- Instrucciones de instalación
- Estructura del repositorio
- Tecnologías (.NET 6, Dapper, SQLite)
- Integrantes del grupo

### Puntaje

100 puntos según la rúbrica de la evaluación maestra de U4.

## Criterios de corrección específicos

| Criterio | Esperado |
|---|---|
| Branch protection en main | Activa en GitHub Settings. Sin ella, descontar 5 puntos. |
| Al menos 2 PR mergeados | Evidencia en el historial de PR de GitHub. |
| Cada PR con revisión | Comentario o approval de otro integrante. |
| Conteo de admisiones | LEFT JOIN + GROUP BY con todas las columnas no agregadas en GROUP BY. |
| Búsqueda LIKE | `?specialty=Cardio` debe encontrar "Cardiologia". |