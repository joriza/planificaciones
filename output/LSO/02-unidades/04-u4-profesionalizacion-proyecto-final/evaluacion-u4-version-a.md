# Evaluación U4 — Versión A: Proyecto final sobre pacientes

## Metadatos de versión

| Campo | Valor |
|---|---|
| Versión | A |
| Versiones equivalentes | B (Proyecto final sobre doctores) |
| Dominio de datos | Pacientes (principal), doctores como segunda tabla |
| Rama feature de ejemplo | `feature/endpoint-pacientes-provincia` |
| Proyecto base | `trabajo-final/` |

## Consigna

Construir el trabajo final integrador del curso: una API completa sobre la base `hospital.db` con CRUD sobre pacientes, endpoints de lectura con JOIN, flujo Git profesional (issues, ramas, PR, main protegida) y README profesional. La defensa individual se realiza en el encuentro 32.

### Endpoints requeridos

| Método | Ruta | Comportamiento |
|---|---|---|
| GET | `/patients` | Lista todos los pacientes ordenados. |
| GET | `/patients/{id:long}` | Paciente por ID; 404 si no existe. |
| GET | `/patients/with-province` | Pacientes con nombre de provincia (JOIN). |
| GET | `/patients/count-by-province` | Conteo de pacientes por provincia (LEFT JOIN + GROUP BY). |
| POST | `/patients` | Crear paciente. Validar `FirstName`. 201. |
| PUT | `/patients/{id:long}` | Actualizar paciente. 204 o 404. |
| DELETE | `/patients/{id:long}` | Eliminar paciente. 204 o 404. |
| GET | `/doctors/{id:long}` | Doctor por ID; 404 si no existe. |

### Records necesarios (al final de `Program.cs`)

```csharp
record PatientInput(string FirstName, string LastName, string Gender,
                    string BirthDate, string? City, string ProvinceId,
                    string? Allergies, long? Height, long? Weight);

record Patient(long PatientId, string FirstName, string LastName, string Gender,
               string BirthDate, string? City, string ProvinceId, string? Allergies,
               long? Height, long? Weight);

record PatientWithProvince(long PatientId, string FirstName, string LastName, string Gender,
                           string BirthDate, string? City, string ProvinceName, string? Allergies,
                           long? Height, long? Weight);

record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);
```

### Flujo Git profesional (obligatorio para esta unidad)

1. Crear la carpeta `trabajo-final/` al inicio de la U4.
2. Crear issues en GitHub para cada endpoint o grupo de endpoints.
3. Trabajar en ramas `feature/nombre` (una por issue).
4. Abrir pull requests y asignar a otro integrante para revisión.
5. Mergear cada PR a `main` después de revisión.
6. Activar branch protection en `main` (Settings → Branches → Add rule: `main`, require PR).
7. Mantener `.gitignore` y `hospital.db` junto al `.csproj`.

### README.md

Debe incluir:
- Nombre del proyecto y descripción
- Requisitos (.NET 6 SDK, paquetes NuGet)
- Instrucciones de instalación (`dotnet run`)
- Estructura del repositorio
- Tecnologías (.NET 6, Dapper, SQLite)
- Integrantes del grupo

### Puntaje

100 puntos según la rúbrica de la evaluación maestra de U4.

## Criterios de corrección específicos

| Criterio | Esperado |
|---|---|
| Branch protection en main | Activa en GitHub Settings. Sin ella, descontar 5 puntos. |
| Al menos 2 PR mergeados | Debe haber evidencia en el historial de PR. |
| Cada PR con revisión | Comentario o approval de otro integrante. |
| README completo | Debe incluir los 5 elementos de la rúbrica. |
| Defensa individual | 20 puntos aparte; si es insatisfactoria, no aprueba aunque tenga 100 en entrega. |