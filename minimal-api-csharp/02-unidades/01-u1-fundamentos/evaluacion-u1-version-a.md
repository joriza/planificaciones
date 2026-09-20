# Evaluación de la Unidad 1 — Versión A

> Dominio de esta versión: soporte técnico — tickets de contacto/mensajes. Mini API **en memoria**, sin base de datos. Duración: 90 minutos. Puntaje total: 100 puntos. Resolución individual, con computadora, sin celular. Las condiciones completas están en `evaluacion-u1.md`.

## Antes de empezar

- Creás el proyecto con `dotnet new web` y reemplazás **todo** el contenido de `Program.cs` por el esqueleto de abajo: trae la lista base, el contador de ids y los records, y **no se modifican**. Solo agregás los endpoints pedidos, en los lugares marcados.
- Todo el código en `Program.cs`; records siempre al final del archivo.
- Convenciones del curso: rutas en inglés y plural, ids `long`, fechas `string` ISO (`yyyy-MM-dd`), respuestas siempre con `Results`, comentarios en el código.
- Los mensajes de 400 y 404 van dentro de `new { mensaje = "..." }`, en español. Esta prueba propone los de cada consigna; un mensaje equivalente que nombre el dato que falta también puntúa.
- Al terminar, dejás el `Program.cs` guardado en la carpeta indicada y avisás al docente.

Tiempo sugerido: Parte 1, 25 min · Parte 2, 30 min · Parte 3, 20 min · Parte 4, 10 min · revisión final, 5 min.

## Material provisto — Esqueleto de `Program.cs`

```csharp
// Program.cs - Evaluacion de la Unidad 1 - Version A
// Mini API de tickets de soporte en memoria (sin base de datos)

// 1) Prepara el programa
var builder = WebApplication.CreateBuilder(args);

// 2) Construye la aplicacion
var app = builder.Build();

// Lista compartida: datos iniciales provistos, NO se modifican
var tickets = new List<Ticket>
{
    new Ticket(1, "Impresora sin tinta", "alta", "2025-03-10"),
    new Ticket(2, "Teclado con teclas flojas", "media", "2025-03-11"),
    new Ticket(3, "Monitor que parpadea", "baja", "2025-03-12")
};

// Contador de ids: arranca despues del ultimo id de la lista
long nextTicketId = 4;

// ===== Parte 1: completar a partir de aqui =====
// b) GET /tickets -> 200 con la lista completa (7 puntos)
// c) GET /tickets/{id:long} -> 200 con el ticket o 404 con mensaje (9 + 10 puntos)

// ===== Parte 2: completar a partir de aqui =====
// POST /tickets -> valida y responde 400 o 201 (30 puntos)

// ===== Parte 3: completar a partir de aqui =====
// DELETE /tickets/{id:long} -> 404 o 204 (25 puntos)

app.Run();   // Deja la API escuchando pedidos

// ---- Records: provistos, SIEMPRE al final del archivo ----
record Ticket(long TicketId, string Title, string Priority, string CreatedDate);
record TicketInput(string Title, string Priority, string CreatedDate);
```

## Parte 1 — Consulta de tickets (30 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| a | Crear el proyecto con `dotnet new web`, pegar el esqueleto y correr la API con `dotnet run` | 4 |
| b | Endpoint `GET /tickets`: responde `200` con la lista completa de tickets | 7 |
| c | Endpoint `GET /tickets/{id:long}` con parámetro de ruta tipado `long id`: responde `200` con el ticket cuyo id llega por la ruta | 9 |
| d | En ese mismo endpoint, si el id no existe: `404` con `{"mensaje":"No existe el ticket"}` | 10 |

## Parte 2 — Alta con validación (30 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| a | Endpoint `POST /tickets` que lee el cuerpo con el record de entrada `TicketInput` (sin id: el id lo asigna la API) | 5 |
| b | Validación en orden, con `string.IsNullOrWhiteSpace`: falta `Title` → `400` `{"mensaje":"Falta el titulo del ticket"}`; falta `Priority` → `400` `{"mensaje":"Falta la prioridad"}`; falta `CreatedDate` → `400` `{"mensaje":"Falta la fecha de creacion"}` | 10 |
| c | Alta correcta: el ticket nuevo sale con el id del contador (`nextTicketId`, que después suma 1), se agrega a la lista y responde `201` con la URL del recurso nuevo (`Results.Created`) | 12 |
| d | Verificación: el `GET /tickets/4` del ticket recién creado responde `200` | 3 |

## Parte 3 — Baja (25 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| a | Endpoint `DELETE /tickets/{id:long}` con parámetro de ruta tipado `long id` | 5 |
| b | Si el id no existe: `404` con `{"mensaje":"No existe el ticket"}` | 8 |
| c | Si existe: quita el ticket de la lista y responde `204` sin cuerpo (`Results.NoContent`) | 7 |
| d | Verificación: después del borrado, el `GET` de ese mismo id responde `404` (el ticket ya no está) | 5 |

## Parte 4 — Ítems conceptuales (15 puntos)

Responder por escrito, con tus palabras.

### C1. Verbos y códigos de respuesta (8 puntos)

Para cada situación, indicar el verbo HTTP y el código de estado que corresponde:

| Situación | Verbo | Código |
| --- | --- | --- |
| El navegador pide el detalle de un ticket y ese id no existe | | |
| Se da de alta un ticket con todos los campos válidos | | |
| Llega un `POST` de ticket sin título y la API lo rechaza | | |
| Se borra un ticket existente | | |

### C2. Mensaje de commit referente (7 puntos)

a) Escribí un mensaje de commit referente para esta prueba, siguiendo la convención del curso (3 puntos).

b) Ordená los comandos de una entrega ya conectada al remoto: `git push`, `git add .`, `git commit -m "..."` (2 puntos).

c) ¿Qué carpetas ignora el `.gitignore` del curso y por qué? (2 puntos)

## Batería de verificación: salida esperada de cada prueba

Con la API corriendo (`dotnet run`): el navegador solo envía GET; el resto, con `curl.exe` en otra terminal. Los ejemplos usan el puerto `5080`: reemplazá por el de tu línea `Now listening on:`.

| Prueba | Pedido | Salida esperada |
| --- | --- | --- |
| 1 | Navegador: `http://localhost:5080/tickets` | `200` con el array de los tres tickets |
| 2 | Navegador: `http://localhost:5080/tickets/2` | `200` con `{"ticketId":2,"title":"Teclado con teclas flojas","priority":"media","createdDate":"2025-03-11"}` |
| 3 | Navegador: `http://localhost:5080/tickets/99` | `404` con `{"mensaje":"No existe el ticket"}` |
| 4 | `POST /tickets` con los tres campos completos | `201` con `Location: /tickets/4` y el ticket creado |
| 5 | `POST /tickets` sin `title` | `400` con `{"mensaje":"Falta el titulo del ticket"}` |
| 6 | `POST /tickets` sin `priority` | `400` con `{"mensaje":"Falta la prioridad"}` |
| 7 | `POST /tickets` sin `createdDate` | `400` con `{"mensaje":"Falta la fecha de creacion"}` |
| 8 | `DELETE /tickets/3` | `204` sin cuerpo |
| 9 | `DELETE /tickets/3` de nuevo | `404` con `{"mensaje":"No existe el ticket"}` (ya no existe) |
| 10 | Navegador: `http://localhost:5080/tickets/3` después del borrado | `404` con el mismo mensaje |

Comandos `curl` de ejemplo (una línea cada uno; las variantes de las pruebas 6, 7 y 9 se obtienen cambiando el JSON o el id):

```powershell
curl.exe -i -X POST http://localhost:5080/tickets -H "Content-Type: application/json" -d "{\"title\":\"Mouse no responde\",\"priority\":\"media\",\"createdDate\":\"2025-03-13\"}"
curl.exe -i -X POST http://localhost:5080/tickets -H "Content-Type: application/json" -d "{\"title\":\"\",\"priority\":\"media\",\"createdDate\":\"2025-03-13\"}"
curl.exe -i -X DELETE http://localhost:5080/tickets/3
```

## Al terminar

- Haber ejecutado la batería completa y observado cada código.
- Dejar el `Program.cs` guardado en la carpeta indicada y avisar al docente.
