# Evaluación U1 — Versión A: Pacientes en memoria

## Metadatos de versión

| Campo | Valor |
|---|---|
| Versión | A |
| Versiones equivalentes | B (Doctores) |
| Dominio de datos | Pacientes |
| Tabla de referencia | `patients` (de `hospital.db`, usada como modelo, no como conexión) |

## Consigna

Construir una Minimal API en C# .NET 6 que exponga endpoints GET sobre una **lista de pacientes en memoria** (sin base de datos). La API debe permitir listar, filtrar por género, buscar por ID, contar y filtrar por edad. La entrega se realiza en la carpeta `tp-u1/` del repositorio grupal.

### Datos de ejemplo (mínimo 6 pacientes)

Cada grupo debe crear su propia lista de pacientes en memoria con al menos 6 registros. A continuación se muestra un ejemplo representativo; los datos reales deben ser inventados por el grupo:

```csharp
var patients = new List<Patient>
{
    new Patient(1, "Ana", "Lopez", "F", "1990-05-15", "Cordoba", "AR-C", null, 165, 62),
    new Patient(2, "Luis", "Martinez", "M", "1985-08-22", "Rosario", "AR-E", "Penicilina", 178, 80),
    new Patient(3, "Elena", "Garcia", "F", "1978-12-03", null, "AR-B", null, 160, null),
    new Patient(4, "Carlos", "Perez", "M", "2000-01-10", "Mendoza", "AR-M", null, 182, 75),
    new Patient(5, "Sofia", "Diaz", "F", "1995-07-30", "La Plata", "AR-B", "Ibuprofeno", null, 68),
    new Patient(6, "Miguel", "Fernandez", "M", "1982-11-18", "Salta", "AR-A", null, 175, 90)
};
```

### Endpoints requeridos

| Método | Ruta | Comportamiento |
|---|---|---|
| GET | `/patients` | Devuelve la lista completa. Si se pasa `?gender=M` o `?gender=F`, filtra por género. |
| GET | `/patients/{id:long}` | Devuelve el paciente con ese ID o 404 con mensaje. |
| GET | `/patients/count` | Devuelve `{ "total": 6 }`. |
| GET | `/patients/older-than` | Parámetro query `?age=N`. Devuelve los pacientes mayores de N años. |

### Endpoint extra (a elección del grupo)

Elegir UNO de los siguientes:
- `GET /patients/by-name/{lastName}` — búsqueda por apellido exacto (sin LIKE, la lista está en memoria).
- `GET /patients/summary` — devuelve `{ "total": 6, "femenino": 3, "masculino": 3 }`.
- `GET /patients/sorted` — devuelve la lista ordenada por apellido.

### Record canónico

```csharp
record Patient(long PatientId, string FirstName, string LastName, string Gender,
               string BirthDate, string? City, string ProvinceId, string? Allergies,
               long? Height, long? Weight);
```

### Requisitos técnicos

- Usar `long` para el ID (nunca `int`).
- Fechas como `string` (nunca `DateTime`).
- Campos nulables con `?`.
- Records al final del archivo, después de `app.Run()`.
- Respuestas con `Results.Ok()` y `Results.NotFound(new { mensaje = "..." })`.
- Mensajes de error en español.

### Entrega en GitHub

```bash
# Dentro del repositorio grupal
mkdir -p tp-u1
# Copiar Program.cs a tp-u1/
# Crear .gitignore con "bin/" y "obj/"
git add .
git commit -m "tp-u1: minimal api get pacientes en memoria"
git push
```

## Puntaje

Versión A: 100 puntos según la rúbrica de la evaluación maestra. Los 10 puntos del endpoint extra se asignan al endpoint elegido por el grupo.

## Criterios de corrección específicos de la versión A

| Criterio | Esperado |
|---|---|
| Filtro `?gender=X` | Insensible a mayúsculas? No, se compara exacto: `p.Gender == gender`. El alumno puede elegir. |
| Edad en `older-than` | Calculada con `DateTime.Parse` y la lógica de año exacto. |
| Tipo del ID | `long PatientId`, no `int PatientId`. |
| Campo nulable | `string? City`, `long? Height`, `string? Allergies`. |