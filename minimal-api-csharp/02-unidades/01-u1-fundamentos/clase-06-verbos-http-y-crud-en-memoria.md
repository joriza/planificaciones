# Encuentro 6 — Verbos HTTP y CRUD en memoria

> Unidad 1 — Fundamentos de Minimal API con C#

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 6 de 36 |
| Unidad | 1 — Fundamentos de Minimal API con C# |
| Eje temático | 1 — Fundamentos de Minimal API |
| Carácter/Objetivo | Conceptual |
| Duración teórica | 240 minutos (4 horas reloj) |
| Concepto nuevo | Verbos HTTP (GET, POST, PUT, DELETE), códigos de respuesta con la clase `Results` y CRUD completo sobre una lista estática compartida en memoria |
| Requisitos previos | Encuentros 4 y 5: proyecto, `dotnet run`, rutas con parámetros, JSON automático y repositorio local de git iniciado con su rutina de commit |
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

1. Asociar cada verbo HTTP con la acción de CRUD que resuelve: leer, crear, reemplazar, borrar.
2. Leer el cuerpo de un pedido POST/PUT con un record de entrada (DTO) y responder con `Results.Created`, `Results.Ok`, `Results.NoContent`, `Results.BadRequest` y `Results.NotFound` según el caso.
3. Sostener el estado de la API en una lista estática compartida, con ids `long` únicos por contador.
4. Probar el CRUD completo con el navegador (GET) y con `curl` (POST, PUT, DELETE), verificando el código de cada respuesta.
5. Explicar por qué los records no se editan: se reemplazan.

## 3. Teoría mínima (40 min)

### Charla rápida: el cuaderno de la recepción

Volviendo al hotel: la recepción tiene un cuaderno. Cuando llega un huésped, **escribe** una línea nueva. Si el huésped corrige su número de habitación, **reescribe** esa línea. Cuando se va, **tacha** la línea. Y cuando alguien pregunta quiénes están hospedados, **lee** el cuaderno sin cambiar nada. Cuatro acciones: leer, escribir, reescribir, tachar. Los verbos HTTP son exactamente eso: **GET** lee, **POST** crea, **PUT** reemplaza, **DELETE** borra. Y la lista que hoy van a manejar es el cuaderno.

### Lo mínimo indispensable

- **CRUD** nombra las cuatro operaciones sobre un dato: **C**reate (POST), **R**ead (GET), **U**pdate (PUT), **D**elete (DELETE).
- Hasta hoy la API solo leía. Ahora la lista de objetos vive en memoria, compartida por todos los pedidos: se declara **una vez**, arriba, fuera de los handlers. Si se declarara adentro de un handler, cada pedido arrancaría con el cuaderno vacío.
- El cuerpo de un POST o PUT se lee con un **record de entrada** (DTO), sin id: el id lo asigna la API, no el cliente.
- Los **códigos de respuesta** cuentan cómo terminó la operación. En este curso se responden **siempre** con la clase `Results`: `Results.Ok` (200), `Results.Created` (201, con la ruta del recurso nuevo), `Results.NoContent` (204, sin cuerpo), `Results.BadRequest` (400, dato inválido) y `Results.NotFound` (404, no existe). Nunca se devuelve el objeto crudo: desde hoy, todo endpoint contesta con un `Results`.
- Los **records son inmutables**: para actualizar, se construye uno nuevo con el mismo id y se reemplaza en la lista.
- `curl` es el cliente de los verbos que el navegador no manda. En Windows PowerShell se usa `curl.exe`, con el JSON en una sola línea y las comillas internas escapadas con `\"`.

### Referencia rápida: verbos HTTP y códigos de respuesta

| Verbo | Qué hace | Ruta | Caso | Método canónico | Código |
| --- | --- | --- | --- | --- | --- |
| GET | Leer todos | `/doctors` | Siempre hay respuesta | `Results.Ok(lista)` | 200 OK |
| GET | Leer uno | `/doctors/{id:long}` | Existe | `Results.Ok(doctor)` | 200 OK |
| GET | Leer uno | `/doctors/{id:long}` | No existe | `Results.NotFound(new { mensaje = ... })` | 404 Not Found |
| POST | Crear | `/doctors` | Datos vacíos | `Results.BadRequest(new { mensaje = ... })` | 400 Bad Request |
| POST | Crear | `/doctors` | Alta correcta | `Results.Created($"/doctors/{id}", doctor)` | 201 Created |
| PUT | Reemplazar | `/doctors/{id:long}` | No existe | `Results.NotFound(new { mensaje = ... })` | 404 Not Found |
| PUT | Reemplazar | `/doctors/{id:long}` | Datos vacíos | `Results.BadRequest(new { mensaje = ... })` | 400 Bad Request |
| PUT | Reemplazar | `/doctors/{id:long}` | Reemplazo correcto | `Results.Ok(actualizado)` | 200 OK |
| DELETE | Borrar | `/doctors/{id:long}` | No existe | `Results.NotFound(new { mensaje = ... })` | 404 Not Found |
| DELETE | Borrar | `/doctors/{id:long}` | Borrado correcto | `Results.NoContent()` | 204 No Content |

Este cuadro es material de consulta para el resto del curso: es el mapa de todo CRUD.

## 4. Práctica guiada (70 min)

Hoy se crea un proyecto nuevo, `DoctorsApi`, con el CRUD completo. Rotación de teclado por paso.

### Paso 1 — Crear el proyecto

```powershell
dotnet new web -n DoctorsApi
cd DoctorsApi
code .
```

### Paso 2 — Escribir la API completa

Reemplazar **todo** el contenido de `Program.cs` por esto y guardar con `Ctrl+S`:

```csharp
// Program.cs - Encuentro 6: verbos HTTP y CRUD en memoria
// CRUD = Create (POST), Read (GET), Update (PUT), Delete (DELETE)

// 1) Prepara el programa
var builder = WebApplication.CreateBuilder(args);

// 2) Construye la aplicacion
var app = builder.Build();

// Lista estatica compartida: se crea UNA vez cuando arranca la API y vive
// mientras la API este corriendo. Si la declararamos dentro de un handler,
// cada pedido empezaria con el cuaderno en blanco otra vez.
var doctors = new List<Doctor>
{
    new Doctor(1, "Laura", "Diaz", "Cardiologia"),
    new Doctor(2, "Martin", "Sosa", "Pediatria"),
    new Doctor(3, "Carla", "Ruiz", "Traumatologia")
};

// Contador de ids: arranca despues del ultimo id usado y suma 1 en cada alta.
// Asi ningun id se repite, aunque se borren doctors.
long nextDoctorId = 4;

// ---- READ: GET devuelve datos, nunca modifica ----

// GET /doctors: devuelve TODA la lista con codigo 200
app.MapGet("/doctors", () =>
{
    return Results.Ok(doctors);
});

// GET /doctors/{id:long}: devuelve UN doctor o 404 si no existe
app.MapGet("/doctors/{id:long}", (long id) =>
{
    // Find recorre la lista y devuelve el primero que cumple la condicion
    var doctor = doctors.Find(d => d.DoctorId == id);

    // "is null" pregunta si no se encontro. El ternario responde en una linea:
    // si no esta, 404 con mensaje; si esta, 200 con el doctor
    return doctor is null
        ? Results.NotFound(new { mensaje = "No existe el doctor" })
        : Results.Ok(doctor);
});

// ---- CREATE: POST crea un recurso nuevo ----

// DoctorInput es el record del cuerpo del pedido (DTO): solo los datos que
// envia el cliente. El id NO viaja en el pedido: lo asigna la API
app.MapPost("/doctors", (DoctorInput input) =>
{
    // Validacion minima: ningun campo puede quedar vacio.
    // IsNullOrWhiteSpace cubre null, vacio y solo espacios
    if (string.IsNullOrWhiteSpace(input.FirstName) ||
        string.IsNullOrWhiteSpace(input.LastName) ||
        string.IsNullOrWhiteSpace(input.Specialty))
    {
        return Results.BadRequest(new { mensaje = "Faltan datos del doctor" });
    }

    // Se arma el doctor completo con el id nuevo y se agrega a la lista
    var doctor = new Doctor(nextDoctorId, input.FirstName, input.LastName, input.Specialty);
    nextDoctorId++;

    doctors.Add(doctor);

    // 201 Created: devuelve el recurso nuevo y su ruta en el header Location
    return Results.Created($"/doctors/{doctor.DoctorId}", doctor);
});

// ---- UPDATE: PUT reemplaza los datos de un recurso existente ----

app.MapPut("/doctors/{id:long}", (long id, DoctorInput input) =>
{
    var doctor = doctors.Find(d => d.DoctorId == id);

    // Primero el 404: sin recurso no hay nada que reemplazar
    if (doctor is null)
    {
        return Results.NotFound(new { mensaje = "No existe el doctor" });
    }

    // Despues el 400: el reemplazo no puede meter campos vacios
    if (string.IsNullOrWhiteSpace(input.FirstName) ||
        string.IsNullOrWhiteSpace(input.LastName) ||
        string.IsNullOrWhiteSpace(input.Specialty))
    {
        return Results.BadRequest(new { mensaje = "Faltan datos del doctor" });
    }

    // Los records son inmutables: no se editan. Se construye uno nuevo con
    // el MISMO id y los datos actualizados, y se reemplaza en su posicion
    var updated = new Doctor(doctor.DoctorId, input.FirstName, input.LastName, input.Specialty);
    doctors[doctors.IndexOf(doctor)] = updated;

    // 200 OK con el dato ya reemplazado
    return Results.Ok(updated);
});

// ---- DELETE: DELETE borra un recurso existente ----

app.MapDelete("/doctors/{id:long}", (long id) =>
{
    var doctor = doctors.Find(d => d.DoctorId == id);

    if (doctor is null)
    {
        return Results.NotFound(new { mensaje = "No existe el doctor" });
    }

    doctors.Remove(doctor);

    // 204 No Content: borrado correcto, la respuesta no lleva cuerpo
    return Results.NoContent();
});

// 4) Deja la API escuchando pedidos
app.Run();

// ---- Records: SIEMPRE al final del archivo, despues de app.Run() ----
// Doctor: entidad completa de la lista, con su id
record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);

// DoctorInput: cuerpo del pedido para POST y PUT (DTO), sin id
record DoctorInput(string FirstName, string LastName, string Specialty);
```

Antes de correr, releer el archivo marcando las regiones: la lista y el contador arriba, los cinco endpoints en el medio, los records al final. Ese orden no es capricho: el compilador rechaza un record declarado antes de `app.Run()`.

### Paso 3 — READ con el navegador

```powershell
dotnet run
```

| URL | Respuesta esperada |
| --- | --- |
| `http://localhost:5080/doctors` | Array JSON con los tres doctors |
| `http://localhost:5080/doctors/2` | `{"doctorId":2,"firstName":"Martin","lastName":"Sosa","specialty":"Pediatria"}` |
| `http://localhost:5080/doctors/99` | `{"mensaje":"No existe el doctor"}` con estado **404** |

```json
[{"doctorId":1,"firstName":"Laura","lastName":"Diaz","specialty":"Cardiologia"},{"doctorId":2,"firstName":"Martin","lastName":"Sosa","specialty":"Pediatria"},{"doctorId":3,"firstName":"Carla","lastName":"Ruiz","specialty":"Traumatologia"}]
```

### Paso 4 — CREATE con curl

En una **nueva** terminal (la otra sigue ocupada por `dotnet run`), desde la carpeta del proyecto:

```powershell
curl.exe -i -X POST http://localhost:5080/doctors -H "Content-Type: application/json" -d "{\"firstName\":\"Pedro\",\"lastName\":\"Paz\",\"specialty\":\"Clinica\"}"
```

Salida esperada:

```text
HTTP/1.1 201 Created
Content-Type: application/json; charset=utf-8
Location: http://localhost:5080/doctors/4

{"doctorId":4,"firstName":"Pedro","lastName":"Paz","specialty":"Clinica"}
```

El `-i` muestra el código; el `Location` anuncia dónde vive el recurso nuevo. Verificar con el navegador: `http://localhost:5080/doctors/4` existe ahora.

Y el caso inválido, con un campo vacío:

```powershell
curl.exe -i -X POST http://localhost:5080/doctors -H "Content-Type: application/json" -d "{\"firstName\":\"\",\"lastName\":\"Paz\",\"specialty\":\"Clinica\"}"
```

Salida esperada:

```text
HTTP/1.1 400 Bad Request

{"mensaje":"Faltan datos del doctor"}
```

### Paso 5 — UPDATE con curl

```powershell
curl.exe -i -X PUT http://localhost:5080/doctors/1 -H "Content-Type: application/json" -d "{\"firstName\":\"Laura\",\"lastName\":\"Diaz De Arzuaga\",\"specialty\":\"Cardiologia\"}"
```

Salida esperada:

```text
HTTP/1.1 200 OK

{"doctorId":1,"firstName":"Laura","lastName":"Diaz De Arzuaga","specialty":"Cardiologia"}
```

Confirmar con GET que el cambio quedó, y probar el 404:

```powershell
curl.exe -i -X PUT http://localhost:5080/doctors/99 -H "Content-Type: application/json" -d "{\"firstName\":\"X\",\"lastName\":\"Y\",\"specialty\":\"Z\"}"
```

```text
HTTP/1.1 404 Not Found

{"mensaje":"No existe el doctor"}
```

### Paso 6 — DELETE con curl

```powershell
curl.exe -i -X DELETE http://localhost:5080/doctors/3
```

Salida esperada:

```text
HTTP/1.1 204 No Content
```

Sin cuerpo: el 204 es la respuesta que no dice nada porque no hay nada que decir. Verificar con GET: `/doctors/3` ahora responde 404.

### Paso 7 — Cierre del bloque con la rutina de git

```powershell
git add .
git commit -m "u1-clase-06: crud de doctors con results"
```

## 5. Ejercicio independiente (50 min)

**Consigna.** Sobre el mismo proyecto `DoctorsApi`:

1. Agregar el endpoint `GET /doctors/count` que devuelva un objeto anónimo con la cantidad de doctors de la lista (`total`).
2. Probarlo en el navegador **antes** y **después** de un DELETE, para ver que el total baja.
3. Ejecutar con `curl` el ciclo completo sobre un doctor propio: POST (anotar el código), GET (200), PUT (200), DELETE (204) y GET final (404). Anotar los cinco códigos observados.
4. Cierre con la rutina: `git add .` + `git commit -m "u1-clase-06: contador y ciclo completo de crud"`.

**Pista.** El contador es un `MapGet` de una línea: `Results.Ok(new { total = doctors.Count })`. La ruta literal `/doctors/count` no choca con `/doctors/{id:long}`: `count` no es un número, así que solo matchea la literal. Para el ciclo, copiar los comandos `curl.exe` de la práctica guiada y cambiar los valores.

## 6. Extensión y consolidación (45 min)

Para los grupos que terminan la base. Rotación: un ítem por integrante.

1. **Filtro por especialidad:** endpoint `GET /doctors/by-specialty/{specialty}` que devuelva `Results.Ok` con `doctors.FindAll(...)` comparando en minúsculas ambos lados. Ojo: la comparación con `==` distingue mayúsculas; normalizar con `ToLower()` en los dos lados.
2. **Exploración del 415:** enviar un POST **sin** el header `Content-Type: application/json` y anotar la respuesta. Conclusión: sin ese header, la API no sabe interpretar el cuerpo del pedido.
3. **Cuadro propio:** copiar el cuadro «Referencia rápida» a mano, en el cuaderno del grupo, pero para SU próxima API (nombres de ruta propios). Es el diseño del CRUD del encuentro 7.
4. **Auditoría del cuaderno:** correr `git log --oneline` y verificar que cada commit del día tiene un mensaje referente. Si no, corregir el hábito antes del cierre.

## 7. Cierre (15 min)

### Qué te llevás

- Los cuatro verbos son el CRUD: GET lee, POST crea, PUT reemplaza, DELETE borra.
- Todo endpoint responde con `Results`: 200 para datos leídos o reemplazados, 201 con `Location` para altas, 204 sin cuerpo para borrados, 400 con mensaje para datos inválidos y 404 con mensaje para id inexistente.
- La lista vive afuera de los handlers: un solo cuaderno compartido por todos los pedidos, con ids `long` únicos por contador.
- El cuerpo del POST/PUT llega como record Input (DTO), sin id; los records no se editan: se reemplazan.
- `curl.exe` con `-X`, `-H` y `-d` es el cliente de los verbos que el navegador no manda.

### Lo que viene

En el Encuentro 7 se consolida todo el recorrido de la unidad: una mini API en memoria de pacientes —el preludio de `hospital.db`— con el CRUD completo integrando rutas, parámetros, verbos y códigos, más la validación sistemática (campos vacíos → 400) y el 404 en todos los endpoints.

## 8. Errores comunes y trampas

1. **Records declarados antes de `app.Run()`.** Causa: ordenar el archivo «lógico» con los tipos arriba. Fix: el compilador rechaza tipos entre instrucciones (error CS8803); records siempre al final, después de `Run`.
2. **Lista declarada dentro de un handler.** Causa: creer que cada endpoint necesita «su» lista. Fix: la lista se declara una vez arriba; si está adentro, cada pedido arranca con el cuaderno vacío y los datos «desaparecen» entre pedido y pedido.
3. **POST sin `-H "Content-Type: application/json"`.** Causa: copiar el comando a medias. Fix: la API no sabe interpretar el cuerpo y falla (415); el header es obligatorio en POST y PUT.
4. **Olvidar `-X POST` en curl.** Causa: curl manda GET por defecto y la ruta `POST /doctors` responde 404 «inexplicable». Fix: revisar que el comando tenga `-X` con el verbo correcto.
5. **Intentar `doctor.FirstName = "..."` en el PUT.** Causa: tratar el record como objeto editable. Fix: los records son inmutables; se construye uno nuevo con el mismo id y se reemplaza en la lista.
6. **Comillas simples o sin escapar en el JSON de PowerShell.** Causa: JSON pegado desde un editor. Fix: el `-d` va en una línea, con comillas dobles internas escapadas: `-d "{\"firstName\":\"...\"}"`.
