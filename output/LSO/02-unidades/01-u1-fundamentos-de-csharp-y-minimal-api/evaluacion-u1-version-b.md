# Evaluación U1 — Versión B: Doctores en memoria

## Metadatos de versión

| Campo | Valor |
|---|---|
| Versión | B |
| Versiones equivalentes | A (Pacientes) |
| Dominio de datos | Doctores |
| Tabla de referencia | `doctors` (de `hospital.db`, usada como modelo, no como conexión) |

## Consigna

Construir una Minimal API en C# .NET 6 que exponga endpoints GET sobre una **lista de doctores en memoria** (sin base de datos). La API debe permitir listar, filtrar por especialidad, buscar por ID, contar y filtrar por antigüedad. La entrega se realiza en la carpeta `tp-u1/` del repositorio grupal.

### Datos de ejemplo (mínimo 6 doctores)

Cada grupo debe crear su propia lista de doctores en memoria con al menos 6 registros. A continuación se muestra un ejemplo representativo; los datos reales deben ser inventados por el grupo:

```csharp
var doctors = new List<Doctor>
{
    new Doctor(1, "Maria", "Gomez", "Cardiologia", "1165432100", "maria.gomez@hospital.com", "M", "1980-03-15"),
    new Doctor(2, "Pedro", "Ramirez", "Clinica Medica", null, "pedro.ramirez@hospital.com", "M", "1975-07-22"),
    new Doctor(3, "Laura", "Fernandez", "Pediatria", "1165112233", null, "F", "1988-11-10"),
    new Doctor(4, "Diego", "Torres", "Cardiologia", "1165778899", "diego.torres@hospital.com", "M", "1992-05-05"),
    new Doctor(5, "Valentina", "Acosta", "Neurologia", null, null, "F", "1985-09-18"),
    new Doctor(6, "Jorge", "Mendoza", "Clinica Medica", "1165432777", "jorge.mendoza@hospital.com", "M", "1979-12-01")
};
```

### Endpoints requeridos

| Método | Ruta | Comportamiento |
|---|---|---|
| GET | `/doctors` | Devuelve la lista completa. Si se pasa `?gender=M` o `?gender=F`, filtra por género. |
| GET | `/doctors/{id:long}` | Devuelve el doctor con ese ID o 404 con mensaje. |
| GET | `/doctors/count` | Devuelve `{ "total": 6 }`. |
| GET | `/doctors/older-than` | Parámetro query `?age=N`. Devuelve los doctores mayores de N años (edad calculada desde la fecha de nacimiento). |

### Endpoint extra (a elección del grupo)

Elegir UNO de los siguientes:
- `GET /doctors/by-specialty/{specialty}` — búsqueda por especialidad exacta.
- `GET /doctors/summary` — devuelve `{ "total": 6, "femenino": 3, "masculino": 3 }`.
- `GET /doctors/sorted` — devuelve la lista ordenada por apellido.

### Record canónico

```csharp
record Doctor(long DoctorId, string FirstName, string LastName, string Specialty,
              string? Phone, string? Email, string Gender, string BirthDate);
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
git commit -m "tp-u1: minimal api get doctores en memoria"
git push
```

## Puntaje

Versión B: 100 puntos según la rúbrica de la evaluación maestra. Los 10 puntos del endpoint extra se asignan al endpoint elegido por el grupo.

## Criterios de corrección específicos de la versión B

| Criterio | Esperado |
|---|---|
| Filtro `?gender=X` | Comparación exacta `p.Gender == gender` o ignorando mayúsculas a elección del alumno. |
| Edad en `older-than` | Calculada con `DateTime.Parse` y la lógica de año exacto (misma que en versión A). |
| Tipo del ID | `long DoctorId`, no `int DoctorId`. |
| Campos nulables | `string? Phone`, `string? Email`. |