# Encuentro 7 — Verbos HTTP y CRUD en memoria

> Unidad 1 — Fundamentos de C#, Git/GitHub y Minimal API

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 7 |
| Unidad | 1 — Fundamentos de C#, Git/GitHub y Minimal API |
| Duración teórica | 4 horas reloj (240 minutos) |
| Concepto nuevo | Verbos HTTP (GET, POST, PUT, DELETE) y CRUD en memoria con `List<T>` |
| Requisitos previos | Clase 6 completada (JSON, parámetros de ruta y query string; proyecto `FichasApi`) |
| Uso de celular | No permitido |
| Planificación anual | Encuentro 7: «Verbos HTTP y CRUD en memoria» |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y puente | 30 min |
| Teoría mínima | 45 min |
| Práctica guiada | 90 min |
| Ejercicio independiente | 55 min |
| Puesta en común y cierre | 20 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

**Apertura y puente (30 min).** Hasta acá la API solo responde GET: informa, pero no registra. Pregunta disparadora: en el hospital, la recepcionista no se limita a informar; anota altas, corrige fichas y archiva bajas. ¿Cómo le dice el cliente a la API cuál de esas acciones quiere? La respuesta de hoy: el verbo HTTP viaja dentro de cada pedido.

Al finalizar el encuentro, cada estudiante puede:

1. Asociar cada verbo HTTP con su acción CRUD: GET-Read, POST-Create, PUT-Update, DELETE-Delete.
2. Identificar el código de respuesta adecuado entre 200, 201, 204 y 404.
3. Implementar un CRUD completo en memoria con `List<T>` y `record` en `Program.cs`.
4. Probar POST, PUT y DELETE con la extensión REST Client o Thunder Client de VS Code.
5. Usar `Results.Ok`, `Results.Created`, `Results.NoContent` y `Results.NotFound` en los handlers.

## 3. Teoría mínima (45 min)

### Charla rápida: la recepcionista que registra

La recepcionista del hospital no solo informa: registra altas (POST), corrige fichas (PUT) y archiva bajas (DELETE). Y siempre contesta con un código: "registramos" (201), "esa ficha no existe" (404), "archivado, no hay nada más que agregar" (204). En una API funciona igual: el verbo dice qué acción se pide y el código dice cómo terminó. Nadie lee la respuesta completa para adivinar el resultado: primero se mira el código.

### Lo mínimo indispensable

Un pedido HTTP lleva dos piezas clave para esta clase: el **verbo** (la acción pedida) y, cuando corresponde, un **cuerpo** con los datos. La respuesta trae un **código** y, a veces, contenido.

Verbos y su acción CRUD:

| Verbo | Acción CRUD | Uso típico en la API |
| --- | --- | --- |
| GET | Read | Pedir datos: listar todos u obtener uno |
| POST | Create | Crear un recurso nuevo (los datos viajan en el cuerpo) |
| PUT | Update | Reemplazar un recurso existente |
| DELETE | Delete | Borrar un recurso |

Códigos de respuesta básicos:

| Código | Nombre | Cuándo aparece |
| --- | --- | --- |
| 200 | Ok | Pedido atendido y hay contenido en la respuesta |
| 201 | Created | Se creó un recurso (POST exitoso) |
| 204 | No Content | Acción atendida sin contenido para devolver (DELETE) |
| 404 | NotFound | El recurso buscado no existe |

Todo vive mientras la aplicación corre: la "base de datos" de hoy es una `List<T>` en memoria. Al detener la app, los datos vuelven al estado inicial. La persistencia real se resuelve en la Unidad 2.

## 4. Práctica guiada (90 min)

### Paso 1 — Crear el proyecto

```powershell
dotnet new web -n PacientesApi
cd PacientesApi
code .
```

### Paso 2 — Reemplazar Program.cs

Abrir `Program.cs`, borrar todo su contenido y pegar este código completo:

```csharp
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Modelo: una ficha minima de paciente.
// record: tipo inmutable (no se modifica: se reemplaza por una copia corregida).
record Paciente(int Id, string Nombre, string Ciudad);

// "Base de datos" en memoria: lista que vive mientras la API corre.
// Si detenemos la app, se reinicia (lo resolvemos en la Unidad 2).
var pacientes = new List<Paciente>
{
    new(1, "Ana Torres", "Rosario"),
    new(2, "Luis Gomez", "Santa Fe")
};

// GET: listar todas las fichas
app.MapGet("/pacientes", () => pacientes);

// GET: una ficha por id (parametro de ruta)
app.MapGet("/pacientes/{id:int}", (int id) =>
{
    var p = pacientes.FirstOrDefault(x => x.Id == id);
    return p is null ? Results.NotFound(new { mensaje = "No existe el paciente" })
                     : Results.Ok(p);
});

// POST: alta de paciente (el cuerpo del pedido llega como objeto)
app.MapPost("/pacientes", (Paciente nuevo) =>
{
    pacientes.Add(nuevo);
    return Results.Created($"/pacientes/{nuevo.Id}", nuevo);
});

// PUT: reemplazo de la ficha (con copia corregida usando with)
app.MapPut("/pacientes/{id:int}", (int id, Paciente datos) =>
{
    var i = pacientes.FindIndex(x => x.Id == id);
    if (i == -1) return Results.NotFound(new { mensaje = "No existe el paciente" });
    pacientes[i] = datos with { Id = id }; // conserva el Id de la ruta
    return Results.Ok(pacientes[i]);
});

// DELETE: baja de la ficha
app.MapDelete("/pacientes/{id:int}", (int id) =>
{
    var p = pacientes.FirstOrDefault(x => x.Id == id);
    if (p is null) return Results.NotFound(new { mensaje = "No existe el paciente" });
    pacientes.Remove(p);
    return Results.NoContent();
});

app.Run();
```

### Paso 3 — Levantar la API

```powershell
dotnet run
```

Anotar el puerto de la línea `Now listening on:` (en los ejemplos se usa `http://localhost:5080`; reemplazar por el puerto propio).

### Paso 4 — Probar lo que el navegador puede (solo GET)

- `http://localhost:5080/pacientes` → la lista completa.
- `http://localhost:5080/pacientes/1` → la ficha de Ana.
- `http://localhost:5080/pacientes/99` → 404 con mensaje en JSON.

### Paso 5 — Instalar la herramienta para los demás verbos

El navegador solo envía GET. Para POST, PUT y DELETE, instalar en VS Code la extensión **REST Client** (humao.rest-client) desde la vista de Extensiones; **Thunder Client** es una alternativa equivalente. En este documento se usa REST Client.

### Paso 6 — Crear el archivo de pedidos

En la raíz del proyecto, crear `requests.http`:

```http
### Listar todos los pacientes (esperar 200)
GET http://localhost:5080/pacientes

### Obtener el paciente 1 (esperar 200)
GET http://localhost:5080/pacientes/1

### Buscar uno inexistente (esperar 404)
GET http://localhost:5080/pacientes/99

### Alta de paciente (esperar 201)
POST http://localhost:5080/pacientes
Content-Type: application/json

{
  "id": 3,
  "nombre": "Marta Diaz",
  "ciudad": "Parana"
}

### Reemplazar la ficha 1 (esperar 200)
PUT http://localhost:5080/pacientes/1
Content-Type: application/json

{
  "id": 1,
  "nombre": "Ana Torres",
  "ciudad": "Rafaela"
}

### Dar de baja el paciente 2 (esperar 204)
DELETE http://localhost:5080/pacientes/2
```

Ejecutar con "Send Request" justo encima de cada pedido. Recordar reemplazar `5080` por el puerto propio.

### Paso 7 — Ejecutar en orden y comparar

Correr los pedidos uno por uno y comparar cada respuesta con las salidas esperadas.

### Salidas esperadas

**GET /pacientes** → 200:

```json
[
  {
    "id": 1,
    "nombre": "Ana Torres",
    "ciudad": "Rosario"
  },
  {
    "id": 2,
    "nombre": "Luis Gomez",
    "ciudad": "Santa Fe"
  }
]
```

**GET /pacientes/1** → 200:

```json
{
  "id": 1,
  "nombre": "Ana Torres",
  "ciudad": "Rosario"
}
```

**GET /pacientes/99** → 404:

```json
{
  "mensaje": "No existe el paciente"
}
```

**POST (alta de Marta)** → 201 Created, con encabezado `Location` apuntando al recurso nuevo (`/pacientes/3`) y cuerpo:

```json
{
  "id": 3,
  "nombre": "Marta Diaz",
  "ciudad": "Parana"
}
```

**PUT /pacientes/1** → 200, con la ciudad cambiada a `"Rafaela"` y el Id sin cambios:

```json
{
  "id": 1,
  "nombre": "Ana Torres",
  "ciudad": "Rafaela"
}
```

**DELETE /pacientes/2** → 204 No Content, sin cuerpo. Si se repite el mismo DELETE, ahora responde 404: la ficha ya no existe.

Observación sobre el PUT: el cuerpo traía `"id": 1` igual al de la ruta, pero el código conserva el Id de la ruta con `datos with { Id = id }`. El Id no se negocia: lo define la URL.

## 5. Ejercicio independiente (55 min)

### Consigna

Agregar al mismo proyecto un reemplazo parcial: `PUT /pacientes/{id:int}/ciudad` que reciba en el cuerpo un objeto JSON con la ciudad nueva (`{"ciudad": "Rafaela"}`) y actualice únicamente ese campo de la ficha. Comportamiento esperado:

- Si el `id` existe: 200 con la ficha actualizada (mismo nombre, nueva ciudad).
- Si no existe: 404 con un mensaje en JSON.

### Pista

Combinar el parámetro de ruta `{id:int}`, un record mínimo para el cuerpo (una sola clave, igual que el objeto del POST), `FindIndex` para ubicar la ficha y `with` para crear la copia corregida. La solución completa está en el anexo docente.

## 6. Cierre (20 min)

### Qué te llevás

- El verbo HTTP dice la acción: GET lee, POST crea, PUT reemplaza, DELETE borra (Read, Create, Update, Delete).
- La respuesta lleva un código que cuenta cómo terminó: 200, 201, 204 o 404.
- El CRUD vive en una `List<T>` en memoria: al reiniciar la app, los datos vuelven al estado inicial.
- El navegador solo hace GET: para el resto de los verbos, REST Client o Thunder Client.

### Lo que viene

- Encuentro 8: «Mini-proyecto y cierre U1». Todo lo visto se integra en un solo proyecto: Admisión de pacientes.

### Recordatorio de commit (rutina desde el Encuentro 5)

Con el CRUD funcionando y el ejercicio terminado, al cierre del encuentro:

```powershell
git add .
git commit -m "Clase 7: CRUD en memoria con verbos HTTP"
git push
```

## 7. Errores comunes y trampas

| Trampa | Causa | Cómo se resuelve |
| --- | --- | --- |
| Esperar que la lista sobreviva al reinicio | La `List<T>` vive en memoria: detener la app la borra | Aceptar que los datos vuelven al estado inicial en cada `dotnet run`; la persistencia real llega en la Unidad 2 |
| Probar POST desde el navegador | El navegador solo envía GET | Usar REST Client / Thunder Client con cuerpo JSON y `Content-Type: application/json` |
| Devolver 200 cuando no existe | Responder siempre lo mismo por costumbre | Usar `Results.NotFound`: el 404 comunica el problema real al cliente |
| Olvidar validar antes de `Add` / `Remove` | Operar sin mirar si el recurso existe: fichas duplicadas o respuestas que no reflejan la realidad | Buscar primero (`FirstOrDefault` / `FindIndex`), recién después operar, y elegir el código según el resultado |
| Duplicar Ids | POST con un Id que ya existe queda registrado dos veces | Chequear antes de agregar; la validación formal con 400 se pide en el Encuentro 8 |
| Confundir el cuerpo del POST con parámetro de ruta | Mandar los datos en la URL en lugar del cuerpo | Los datos del POST viajan en el body (JSON); la URL solo identifica el recurso y el verbo identifica la acción |
