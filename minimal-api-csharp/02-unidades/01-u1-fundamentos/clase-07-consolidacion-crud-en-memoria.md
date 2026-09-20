# Encuentro 7 — Consolidación: CRUD en memoria

> Unidad 1 — Fundamentos de Minimal API con C#

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 7 de 36 |
| Unidad | 1 — Fundamentos de Minimal API con C# |
| Eje temático | 1 — Fundamentos de Minimal API |
| Carácter/Objetivo | Procedimental |
| Duración teórica | 240 minutos (4 horas reloj) |
| Concepto nuevo | Sin conceptos teóricos nuevos: consolidación integradora de rutas, parámetros, verbos y códigos en una mini API de pacientes con validación sistemática (campos vacíos → 400) y 404 en todos los endpoints |
| Requisitos previos | Encuentros 4 a 6: proyecto, rutas con parámetros, JSON automático, CRUD completo con `Results`, rutina de commits con git local |
| Uso de celular | No permitido |
| Organización del trabajo | Grupos: alumnos presentes ÷ equipos disponibles (mínimo posible); ningún equipo queda sin usar; rotación de integrantes en cada actividad |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y puente | 20 min |
| Teoría mínima | 40 min |
| Práctica guiada | 70 min |
| Ejercicio independiente | 50 min |
| Extensión y consolidación | 45 min |
| Cierre | 15 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

Al finalizar el encuentro, cada estudiante puede:

1. Reconstruir un CRUD completo en memoria sin copiar el encuentro anterior, siguiendo el cuadro de referencia rápida.
2. Aplicar la validación sistemática: campos vacíos → 400 con mensaje en español, id inexistente → 404, en todos los endpoints.
3. Ordenar los chequeos de un endpoint con id y cuerpo: primero el 404, después el 400, recién después el proceso.
4. Ejecutar y registrar la batería completa de pruebas (navegador + `curl`) de una API antes de declararla terminada.
5. Explicar en qué se convierte esta lista en memoria cuando llegue la base de datos de la Unidad 2.

## 3. Teoría mínima (40 min)

### Charla rápida: el ensayo general

Antes del estreno, la obra se representa completa, con todo y vestuario: es el ensayo general. Esta clase es el ensayo general de la Unidad 1 y, más todavía, de la carrera: la mini API de pacientes que van a construir tiene **las mismas rutas, los mismos verbos y los mismos códigos** que van a usar en la Unidad 2 con `hospital.db` y Dapper. Hoy la lista de pacientes está escrita en el código; en la Unidad 2, esa misma lista sale de una base de datos real. Lo único que va a cambiar es de dónde salen los datos: el esqueleto del CRUD queda exactamente igual.

### Lo mínimo indispensable

- **Todo CRUD es la misma estructura:** lista compartida arriba, cinco endpoints en el medio (GET todos, GET uno, POST, PUT, DELETE), records al final. Cambian el nombre de la entidad y los campos; el esqueleto no.
- **Validación sistemática:** en POST y PUT, ningún campo vacío. Si hay uno, 400 con un mensaje que diga qué falta, en español y dentro de `new { mensaje = ... }`. Nunca un 400 sin cuerpo.
- **404 en los tres endpoints con id:** GET, PUT y DELETE de un id inexistente responden `Results.NotFound(new { mensaje = ... })`.
- **Orden de los chequeos en PUT y DELETE:** primero ¿existe el recurso? (404), después ¿son válidos los datos? (400), recién después se procesa. En POST no hay 404 posible: el chequeo es directo al 400.
- **Chequeo de vacíos:** `string.IsNullOrWhiteSpace` cubre los tres casos trampa: `null`, `""` y `"   "` (solo espacios). Comparar con `== ""` deja pasar los espacios.
- **Batería de pruebas:** una API está terminada cuando su tabla de pruebas pasó completa: cada fila del cuadro de referencia, ejecutada y con su código anotado.

## 4. Práctica guiada (70 min)

Proyecto nuevo del día: `PatientsApi`. La entidad es `Patient`, versión de estudio con cinco campos: el preludio de la tabla `patients` de `hospital.db`. Rotación de teclado por paso.

### Paso 1 — Crear el proyecto

```powershell
dotnet new web -n PatientsApi
cd PatientsApi
code .
```

### Paso 2 — Escribir la mini API de pacientes

Reemplazar **todo** el contenido de `Program.cs` por esto y guardar con `Ctrl+S`:

```csharp
// Program.cs - Encuentro 7: mini API de pacientes en memoria
// Consolidacion de la Unidad 1: rutas + parametros + verbos + codigos.
// Preludio de hospital.db: en la Unidad 2, la lista pasa a ser la tabla patients.

// 1) Prepara el programa
var builder = WebApplication.CreateBuilder(args);

// 2) Construye la aplicacion
var app = builder.Build();

// Lista compartida: el cuaderno de pacientes, creado UNA vez al arrancar
var patients = new List<Patient>
{
    new Patient(1, "Ana", "Garcia", "F", "2001-03-14"),
    new Patient(2, "Bruno", "Lopez", "M", "1999-11-02"),
    new Patient(3, "Carla", "Perez", "F", "2003-07-25")
};

// Contador de ids: siempre suma 1, nunca se repite
long nextPatientId = 4;

// ---- READ ----

// GET /patients: toda la lista -> 200
app.MapGet("/patients", () =>
{
    return Results.Ok(patients);
});

// GET /patients/{id:long}: uno o 404
app.MapGet("/patients/{id:long}", (long id) =>
{
    var patient = patients.Find(p => p.PatientId == id);

    return patient is null
        ? Results.NotFound(new { mensaje = "No existe el paciente" })
        : Results.Ok(patient);
});

// ---- CREATE ----

// POST /patients: alta con validacion completa
app.MapPost("/patients", (PatientInput input) =>
{
    // Chequeo en orden, con un mensaje que diga QUE falta
    if (string.IsNullOrWhiteSpace(input.FirstName) ||
        string.IsNullOrWhiteSpace(input.LastName))
    {
        return Results.BadRequest(new { mensaje = "Faltan el nombre o el apellido" });
    }

    if (string.IsNullOrWhiteSpace(input.Gender))
    {
        return Results.BadRequest(new { mensaje = "Falta el genero (M o F)" });
    }

    if (string.IsNullOrWhiteSpace(input.BirthDate))
    {
        return Results.BadRequest(new { mensaje = "Falta la fecha de nacimiento" });
    }

    var patient = new Patient(nextPatientId, input.FirstName, input.LastName, input.Gender, input.BirthDate);
    nextPatientId++;

    patients.Add(patient);

    // 201 Created con la ruta del paciente nuevo
    return Results.Created($"/patients/{patient.PatientId}", patient);
});

// ---- UPDATE ----

// PUT /patients/{id:long}: reemplazo con el orden de chequeos 404 -> 400 -> proceso
app.MapPut("/patients/{id:long}", (long id, PatientInput input) =>
{
    var patient = patients.Find(p => p.PatientId == id);

    // 1) Primero: existe el paciente?
    if (patient is null)
    {
        return Results.NotFound(new { mensaje = "No existe el paciente" });
    }

    // 2) Despues: los datos nuevos son validos? (mismos chequeos que el POST)
    if (string.IsNullOrWhiteSpace(input.FirstName) ||
        string.IsNullOrWhiteSpace(input.LastName))
    {
        return Results.BadRequest(new { mensaje = "Faltan el nombre o el apellido" });
    }

    if (string.IsNullOrWhiteSpace(input.Gender))
    {
        return Results.BadRequest(new { mensaje = "Falta el genero (M o F)" });
    }

    if (string.IsNullOrWhiteSpace(input.BirthDate))
    {
        return Results.BadRequest(new { mensaje = "Falta la fecha de nacimiento" });
    }

    // 3) Recien ahora: se reemplaza el record por uno nuevo con el mismo id
    var updated = new Patient(patient.PatientId, input.FirstName, input.LastName, input.Gender, input.BirthDate);
    patients[patients.IndexOf(patient)] = updated;

    return Results.Ok(updated);
});

// ---- DELETE ----

// DELETE /patients/{id:long}: baja con 404 o 204
app.MapDelete("/patients/{id:long}", (long id) =>
{
    var patient = patients.Find(p => p.PatientId == id);

    if (patient is null)
    {
        return Results.NotFound(new { mensaje = "No existe el paciente" });
    }

    patients.Remove(patient);

    return Results.NoContent();
});

// 4) Deja la API escuchando pedidos
app.Run();

// ---- Records: SIEMPRE al final del archivo ----
// Patient: version de estudio para la Unidad 1. En la Unidad 2 este mismo
// record se completa con el resto de las columnas de hospital.db
record Patient(long PatientId, string FirstName, string LastName, string Gender, string BirthDate);

// PatientInput: cuerpo del pedido para POST y PUT (DTO), sin id
record PatientInput(string FirstName, string LastName, string Gender, string BirthDate);
```

### Paso 3 — La batería completa de pruebas

Con la API corriendo (`dotnet run`), ejecutar la batería completa y anotar cada código. Primero el READ con el navegador:

| URL | Respuesta esperada |
| --- | --- |
| `http://localhost:5080/patients` | Array con los tres pacientes (200) |
| `http://localhost:5080/patients/2` | `{"patientId":2,"firstName":"Bruno","lastName":"Lopez","gender":"M","birthDate":"1999-11-02"}` |
| `http://localhost:5080/patients/99` | `{"mensaje":"No existe el paciente"}` con 404 |

Después el resto, con `curl.exe` en otra terminal:

| Pedido | Código esperado |
| --- | --- |
| POST con los cuatro campos completos | 201 + `Location: /patients/4` |
| POST con `firstName` vacío | 400 `{"mensaje":"Faltan el nombre o el apellido"}` |
| POST con `birthDate` vacío | 400 `{"mensaje":"Falta la fecha de nacimiento"}` |
| PUT `/patients/1` con datos completos | 200 con el paciente reemplazado |
| PUT `/patients/99` | 404 |
| PUT `/patients/2` con `gender` vacío | 400 `{"mensaje":"Falta el genero (M o F)"}` |
| DELETE `/patients/3` | 204 sin cuerpo |
| DELETE `/patients/3` de nuevo | 404 (ya no existe) |

Comando de ejemplo del POST completo:

```powershell
curl.exe -i -X POST http://localhost:5080/patients -H "Content-Type: application/json" -d "{\"firstName\":\"Diego\",\"lastName\":\"Sosa\",\"gender\":\"M\",\"birthDate\":\"2000-01-30\"}"
```

```text
HTTP/1.1 201 Created
Location: http://localhost:5080/patients/4

{"patientId":4,"firstName":"Diego","lastName":"Sosa","gender":"M","birthDate":"2000-01-30"}
```

### Paso 4 — Lectura comparada con el encuentro 6

Abrir el `Program.cs` del encuentro 6 (doctors) y el de hoy, lado a lado. Cambiaron: el nombre de la lista, los nombres de ruta, los campos del record y los mensajes. No cambió: la estructura completa. Esa es la evidencia de que el CRUD es un esqueleto reutilizable.

### Paso 5 — Cierre del bloque con la rutina de git

```powershell
git add .
git commit -m "u1-clase-07: crud de pacientes con validacion"
```

## 5. Ejercicio independiente (50 min)

**Consigna.** Sobre `PatientsApi`, sin tocar los endpoints existentes:

1. Agregar `GET /patients/by-gender/{gender}` que devuelva `Results.Ok` con los pacientes cuyo `Gender` coincida (comparando en minúsculas los dos lados).
2. Agregar `GET /patients/count` que devuelva `{"total":...}`.
3. Armar la tabla de verificación del grupo: al menos ocho pedidos (incluyendo un 400 y un 404), con el código esperado y el código observado. La tabla se escribe en el cuaderno y se revisa con el docente.
4. Cierre con la rutina: `git add .` + `git commit -m "u1-clase-07: filtros por genero y contador"`.

**Pista.** Los dos endpoints nuevos son de lectura: `Results.Ok(...)` siempre. Para filtrar: `patients.FindAll(p => p.Gender.ToLower() == gender.ToLower())`. Para contar: `patients.Count`. La tabla de verificación se arma copiendo la batería del paso 3 y agregando los dos endpoints nuevos.

## 6. Extensión y consolidación (45 min)

Para los grupos que terminan la base. Rotación: un ítem por integrante.

1. **Validar el género:** en POST y PUT, si `Gender` no es `"M"` ni `"F"` (ignorando mayúsculas), responder 400 con `{"mensaje":"El genero debe ser M o F"}`.
2. **Validar la fecha:** si `BirthDate` no se puede interpretar como fecha (`DateTime.TryParse` devuelve `false`), responder 400 con `{"mensaje":"La fecha no es valida"}`. La fecha sigue viajando y guardándose como string ISO; solo se valida al entrar.
3. **Búsqueda por texto:** endpoint `GET /patients/search/{text}` que devuelva los pacientes cuyo nombre o apellido contenga el texto (en minúsculas, con `Contains`). Lista vacía es 200 con `[]`, no 404.
4. **Ensayo de defensa:** cada integrante elige un endpoint del `Program.cs` y explica, en un minuto, qué ruta atiende, qué verbos y códigos usa y qué validación aplica. Es el ensayo de la defensa individual del encuentro 9.

## 7. Cierre (15 min)

### Qué te llevás

- Todo CRUD es la misma estructura: lista compartida arriba, cinco endpoints en el medio, records al final. Cambia la entidad; el esqueleto, no.
- La validación es sistemática, no un adorno: campos vacíos → 400 con mensaje que dice qué falta; id inexistente → 404; en PUT y DELETE el orden es 404 primero, 400 después, proceso al final.
- `string.IsNullOrWhiteSpace` es el chequeo de vacíos del curso: cubre `null`, `""` y los espacios.
- Una API está terminada cuando su batería de pruebas pasó completa, con los códigos anotados.
- Esta lista en memoria es el ensayo general: en la Unidad 2, los mismos endpoints leerán y escribirán `hospital.db` con Dapper.

### Lo que viene

En el Encuentro 8 se cierra la Unidad 1: desarrollo en clase del TP-u1 —una mini API en memoria con temática a elección del grupo, CRUD completo, validación y códigos correctos, todo en `Program.cs`— y el ciclo completo de entrega, que se enseña una sola vez: repo remoto en GitHub, `git remote add origin` y `git push`, con la carpeta `tp-u1/` en la raíz del repositorio del grupo.

## 8. Errores comunes y trampas

1. **Validar después de usar el dato.** Causa: escribir el `Add` primero y los chequeos después (o copiar el POST sin chequeos). Fix: el orden fijo de siempre: 404 (si hay id), 400 (si hay cuerpo), proceso al final.
2. **Validar solo el POST y olvidar el PUT.** Causa: pensar que el reemplazo «ya viene bien». Fix: el PUT acepta lo mismo que acepta el POST; los chequeos se repiten en los dos.
3. **Comparar con `== ""`.** Causa: parece suficiente. Fix: deja pasar `"   "` (solo espacios); usar `string.IsNullOrWhiteSpace`.
4. **Atribuir a un bug el 404 del segundo DELETE.** Causa: no leer el código de respuesta. Fix: borrar dos veces el mismo id DEBE dar 404 la segunda; el grupo tiene que poder explicarlo.
5. **Responder `BadRequest()` sin cuerpo.** Causa: olvidar el mensaje. Fix: todo 400 y 404 del curso lleva `new { mensaje = "..." }` en español: el cuerpo es lo que le permite al cliente entender qué corregir.
6. **Probar contra una versión vieja de la API.** Causa: editar y no reiniciar. Fix: `Ctrl+S` + `Ctrl+C` + `dotnet run` antes de cada batería; si los códigos observados no coinciden con los esperados, primera sospecha: ¿reinicié?
