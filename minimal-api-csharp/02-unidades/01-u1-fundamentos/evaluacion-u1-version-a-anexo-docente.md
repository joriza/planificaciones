# Anexo docente — Evaluación de la Unidad 1 — Versión A

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión A (tickets), las respuestas esperadas de los ítems conceptuales, los criterios de corrección ítem por ítem y la pauta de devolución para el encuentro 10.

## 1. Solución completa (`Program.cs`)

```csharp
// Program.cs - Evaluacion de la Unidad 1 - Version A (solucion del docente)
// Mini API de tickets de soporte en memoria (sin base de datos)

// 1) Prepara el programa
var builder = WebApplication.CreateBuilder(args);

// 2) Construye la aplicacion
var app = builder.Build();

// Lista compartida: datos iniciales provistos por la prueba
var tickets = new List<Ticket>
{
    new Ticket(1, "Impresora sin tinta", "alta", "2025-03-10"),
    new Ticket(2, "Teclado con teclas flojas", "media", "2025-03-11"),
    new Ticket(3, "Monitor que parpadea", "baja", "2025-03-12")
};

// Contador de ids: arranca despues del ultimo id de la lista
long nextTicketId = 4;

// ===== Parte 1 =====

// GET /tickets: toda la lista -> 200
app.MapGet("/tickets", () =>
{
    return Results.Ok(tickets);
});

// GET /tickets/{id:long}: un ticket o 404
app.MapGet("/tickets/{id:long}", (long id) =>
{
    // Find recorre la lista y devuelve el primer ticket con ese id, o null
    var ticket = tickets.Find(t => t.TicketId == id);

    // Sin coincidencia: 404 con mensaje. Con coincidencia: 200 con el ticket
    return ticket is null
        ? Results.NotFound(new { mensaje = "No existe el ticket" })
        : Results.Ok(ticket);
});

// ===== Parte 2 =====

// POST /tickets: alta con validacion -> 400 o 201
app.MapPost("/tickets", (TicketInput input) =>
{
    // Chequeos en orden, con un mensaje que diga QUE falta.
    // IsNullOrWhiteSpace cubre null, vacio y solo espacios
    if (string.IsNullOrWhiteSpace(input.Title))
    {
        return Results.BadRequest(new { mensaje = "Falta el titulo del ticket" });
    }

    if (string.IsNullOrWhiteSpace(input.Priority))
    {
        return Results.BadRequest(new { mensaje = "Falta la prioridad" });
    }

    if (string.IsNullOrWhiteSpace(input.CreatedDate))
    {
        return Results.BadRequest(new { mensaje = "Falta la fecha de creacion" });
    }

    // Se arma el ticket completo con el id del contador y se agrega
    var ticket = new Ticket(nextTicketId, input.Title, input.Priority, input.CreatedDate);
    nextTicketId++;

    tickets.Add(ticket);

    // 201 con la URL del recurso nuevo y el ticket en el cuerpo
    return Results.Created($"/tickets/{ticket.TicketId}", ticket);
});

// ===== Parte 3 =====

// DELETE /tickets/{id:long}: baja -> 404 o 204
app.MapDelete("/tickets/{id:long}", (long id) =>
{
    var ticket = tickets.Find(t => t.TicketId == id);

    // 1) Primero: existe el ticket?
    if (ticket is null)
    {
        return Results.NotFound(new { mensaje = "No existe el ticket" });
    }

    // 2) Existe: se quita de la lista y se responde 204 sin cuerpo
    tickets.Remove(ticket);

    return Results.NoContent();
});

app.Run();   // Deja la API escuchando pedidos

// ---- Records: provistos, SIEMPRE al final del archivo ----
record Ticket(long TicketId, string Title, string Priority, string CreatedDate);
record TicketInput(string Title, string Priority, string CreatedDate);
```

Aceptaciones válidas menores: `Find` resuelto con `FirstOrDefault` o con un `foreach`; `string.IsNullOrEmpty` en lugar de `IsNullOrWhiteSpace`; `Results.Created($"/tickets/{nextTicketId}", ticket)` calculado antes de incrementar (equivalente); un solo `if` combinado con un mensaje único que nombre los tres campos (puntúa el ítem completo de validación con mensaje general, no diferenciado). **No se acepta:** `TypedResults` (no es canon de .NET 6), ids `int`, rutas en español, responder el objeto crudo sin `Results`.

## 2. Salidas de referencia para la corrección

Con la API corriendo (`dotnet run`, puerto informado por la terminal; los ejemplos usan `5080`):

| Pedido | Respuesta esperada |
| --- | --- |
| `GET http://localhost:5080/tickets` | `200` con `[{...ticket 1...},{"ticketId":2,"title":"Teclado con teclas flojas","priority":"media","createdDate":"2025-03-11"},{"ticketId":3,...}]` (JSON camelCase) |
| `GET http://localhost:5080/tickets/2` | `200` con `{"ticketId":2,"title":"Teclado con teclas flojas","priority":"media","createdDate":"2025-03-11"}` |
| `GET http://localhost:5080/tickets/99` | `404` con `{"mensaje":"No existe el ticket"}` |
| `POST /tickets` con `{"title":"Mouse no responde","priority":"media","createdDate":"2025-03-13"}` | `201`, encabezado `Location: /tickets/4`, cuerpo con el ticket y `ticketId: 4` |
| `POST /tickets` con `title` vacío | `400` con `{"mensaje":"Falta el titulo del ticket"}` (o equivalente que nombre el campo) |
| `POST /tickets` con `priority` vacía | `400` con `{"mensaje":"Falta la prioridad"}` |
| `POST /tickets` con `createdDate` vacía | `400` con `{"mensaje":"Falta la fecha de creacion"}` |
| `DELETE /tickets/3` | `204`, sin cuerpo |
| `DELETE /tickets/3` de nuevo | `404` con `{"mensaje":"No existe el ticket"}` |
| `GET http://localhost:5080/tickets/3` tras el borrado | `404` con el mismo mensaje |

```powershell
curl.exe -i -X POST http://localhost:5080/tickets -H "Content-Type: application/json" -d "{\"title\":\"Mouse no responde\",\"priority\":\"media\",\"createdDate\":\"2025-03-13\"}"
curl.exe -i -X POST http://localhost:5080/tickets -H "Content-Type: application/json" -d "{\"title\":\"\",\"priority\":\"media\",\"createdDate\":\"2025-03-13\"}"
curl.exe -i -X DELETE http://localhost:5080/tickets/3
```

## 3. Criterios de corrección ítem por ítem

### Parte 1 — Consulta de tickets (30 puntos)

| Ítem | Qué se observa | Puntos |
| --- | --- | --- |
| 1a | Proyecto creado con `dotnet new web`, esqueleto pegado sin modificar y API corriendo con `dotnet run` | 4 |
| 1b | Ruta `GET /tickets` con `200` y la lista completa en JSON (`Results.Ok`) | 7 |
| 1c | Ruta `GET /tickets/{id:long}` con parámetro tipado `long id`; `200` con el ticket encontrado | 9 |
| 1d | `404` con mensaje en español cuando el id no existe (`Results.NotFound` + `new { mensaje = ... }`) | 10 |

### Parte 2 — Alta con validación (30 puntos)

| Ítem | Qué se observa | Puntos |
| --- | --- | --- |
| 2a | Ruta `POST /tickets` que lee el cuerpo con el record de entrada `TicketInput` (DTO sin id) | 5 |
| 2b | Validación con `string.IsNullOrWhiteSpace` y `400` con mensaje que dice qué falta, chequeado antes de agregar el ticket | 10 |
| 2c | Alta con el id del contador (`nextTicketId`, incrementado después de usarlo) y `201` con la URL del recurso nuevo (`Results.Created`) | 12 |
| 2d | Verificación posterior: `GET /tickets/4` responde `200` con el ticket creado | 3 |

### Parte 3 — Baja (25 puntos)

| Ítem | Qué se observa | Puntos |
| --- | --- | --- |
| 3a | Ruta `DELETE /tickets/{id:long}` con parámetro tipado `long id` | 5 |
| 3b | `404` con mensaje cuando el id no existe | 8 |
| 3c | `204` sin cuerpo cuando borra (`Results.NoContent`) | 7 |
| 3d | El ticket borrado desaparece: `GET` posterior al mismo id responde `404` | 5 |

### Parte 4 — Ítems conceptuales (15 puntos)

| Ítem | Respuesta esperada | Puntos |
| --- | --- | --- |
| C1 | Verbo y código correctos en las cuatro filas (2 puntos cada una): GET `404` · POST `201` · POST `400` · DELETE `204` | 8 |
| C2a | Formato `<trabajo>: <resumen de lo hecho>`, en minúsculas y sin tildes (p. ej. `eval-u1: crud de tickets en memoria`); se acepta cualquier par trabajo/resumen coherente con esta prueba | 3 |
| C2b | Orden: `git add .` → `git commit -m "..."` → `git push` | 2 |
| C2c | Evita versionar archivos generados; en el curso ignora `bin/` y `obj/` | 2 |

**Total: 100 puntos.** No se duplican descuentos por el mismo defecto en ítems distintos: una convención desviada penaliza una sola vez, en el ítem donde aparece.

### Errores previstos y criterio de intervención

| Error observable | Causa probable | Criterio |
| --- | --- | --- |
| `TypedResults` en las respuestas | Confusión de versión | Defecto de versión (canon: `Results` en .NET 6); descuenta en el ítem donde aparece |
| Ids declarados `int` | Canon de tipos incumplido | Descuenta el ítem de la ruta correspondiente |
| Rutas en español (`/tickets` → otra cosa) | Canon de rutas incumplido | Descuenta el ítem de ruta correspondiente |
| `400`/`404` sin cuerpo (`Results.BadRequest()` a secas) | Mensaje olvidado | Descuento parcial: el código correcto puntúa, el mensaje exigido no |
| `tickets.Add(...)` antes de las validaciones | Orden de chequeos | Las validaciones pierden efecto: descuenta el ítem 2b |
| Lista declarada dentro de un handler | Cada pedido arranca con la lista del esqueleto | Descuenta los ítems 2c y 3d si el estado no se sostiene |
| Contador sin incrementar | Duplicación de ids en el segundo POST | Descuento parcial en 2c |
| Error CS8803 (record antes de `app.Run()`) | Records movidos de lugar | Avisar la causa no invalida la prueba; se corrige lo que alcance a compilar |

## 4. Pauta de devolución (encuentro 10)

- El encuentro 10 **abre con la devolución**, antes de iniciar la Unidad 2: cada alumno recibe su corrección escrita individual, con el desglose ítem por ítem (qué puntúa, qué no y por qué).
- Comentarios generales al curso antes de arrancar la unidad: los aciertos más frecuentes (estructura del esqueleto, uso de `Results`, mensajes 400 diferenciados) y los errores comunes observados en esta versión.
- Los ítems no alcanzados se traducen en objetivos pendientes en la planilla y en pistas de recuperación según las capas de `06-aprobacion/criterios-aprobacion.md`: devolución y reincorporación en las clases de la Unidad 2; intensificaciones 17-18 si el pendiente persiste.
- La planilla de resultados registra: alumno, versión (A), puntaje por parte (30/30/25/15), total sobre 100, objetivos mínimos de U1 logrados/pendientes y observaciones de la defensa del TP-u1.
- Si la entrega del tp-u1 quedó incompleta, recordar la regla vigente: se evalúa lo presentado y el repositorio del grupo permanece abierto para completar con nuevos commits y push.
