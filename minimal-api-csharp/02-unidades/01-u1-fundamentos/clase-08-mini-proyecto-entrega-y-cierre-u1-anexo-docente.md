# Anexo docente — Encuentro 8: Mini proyecto (TP-u1), entrega y cierre de la Unidad 1

> Documento docente formal. No se entrega a los alumnos: contiene la solución modelo del TP, la solución de las actividades de extensión, la respuesta esperada, los criterios de corrección, los errores previstos con su intervención y el registro para el encuentro 9.

## 1. Solución modelo del TP-u1 (Program.cs completo)

Modelo con la temática videojuegos (`games`), equivalente en estructura a cualquier temática elegida por los grupos. Este archivo cumple los diez requisitos de la consigna y sirve de referencia de corrección.

```csharp
// Program.cs - TP-u1 (solucion modelo): mini API de videojuegos en memoria
// Tematica elegida: games (videojuegos)

// 1) Prepara el programa
var builder = WebApplication.CreateBuilder(args);

// 2) Construye la aplicacion
var app = builder.Build();

// Lista compartida: datos iniciales del grupo
var games = new List<Game>
{
    new Game(1, "Puertos del sur", "Aventura", "2020-06-15"),
    new Game(2, "Neon carrera", "Carreras", "2022-11-08"),
    new Game(3, "Torre infinita", "Puzzle", "2018-02-27")
};

// Contador de ids: nunca se repite, aunque se borren juegos
long nextGameId = 4;

// ---- READ ----

// GET /games: toda la lista -> 200
app.MapGet("/games", () =>
{
    return Results.Ok(games);
});

// GET /games/{id:long}: uno o 404
app.MapGet("/games/{id:long}", (long id) =>
{
    var game = games.Find(g => g.GameId == id);

    return game is null
        ? Results.NotFound(new { mensaje = "No existe el game" })
        : Results.Ok(game);
});

// ---- CREATE ----

// POST /games: alta con validacion -> 400 o 201
app.MapPost("/games", (GameInput input) =>
{
    if (string.IsNullOrWhiteSpace(input.Title) ||
        string.IsNullOrWhiteSpace(input.Platform))
    {
        return Results.BadRequest(new { mensaje = "Faltan el titulo o la plataforma" });
    }

    if (string.IsNullOrWhiteSpace(input.ReleaseDate))
    {
        return Results.BadRequest(new { mensaje = "Falta la fecha de lanzamiento" });
    }

    var game = new Game(nextGameId, input.Title, input.Platform, input.ReleaseDate);
    nextGameId++;

    games.Add(game);

    return Results.Created($"/games/{game.GameId}", game);
});

// ---- UPDATE ----

// PUT /games/{id:long}: reemplazo con el orden de chequeos 404 -> 400 -> 200
app.MapPut("/games/{id:long}", (long id, GameInput input) =>
{
    var game = games.Find(g => g.GameId == id);

    if (game is null)
    {
        return Results.NotFound(new { mensaje = "No existe el game" });
    }

    if (string.IsNullOrWhiteSpace(input.Title) ||
        string.IsNullOrWhiteSpace(input.Platform))
    {
        return Results.BadRequest(new { mensaje = "Faltan el titulo o la plataforma" });
    }

    if (string.IsNullOrWhiteSpace(input.ReleaseDate))
    {
        return Results.BadRequest(new { mensaje = "Falta la fecha de lanzamiento" });
    }

    // Los records no se editan: se reemplazan con el mismo id
    var updated = new Game(game.GameId, input.Title, input.Platform, input.ReleaseDate);
    games[games.IndexOf(game)] = updated;

    return Results.Ok(updated);
});

// ---- DELETE ----

// DELETE /games/{id:long}: baja -> 404 o 204
app.MapDelete("/games/{id:long}", (long id) =>
{
    var game = games.Find(g => g.GameId == id);

    if (game is null)
    {
        return Results.NotFound(new { mensaje = "No existe el game" });
    }

    games.Remove(game);

    return Results.NoContent();
});

// 4) Deja la API escuchando pedidos
app.Run();

// ---- Records: SIEMPRE al final del archivo ----
// Game: entidad completa, id long, fecha como string ISO
record Game(long GameId, string Title, string Platform, string ReleaseDate);

// GameInput: cuerpo del pedido para POST y PUT (DTO), sin id
record GameInput(string Title, string Platform, string ReleaseDate);
```

## 2. Solución de las actividades de extensión

```csharp
// Extension 1: GET /games/count -> {"total":...}
app.MapGet("/games/count", () =>
{
    return Results.Ok(new { total = games.Count });
});

// Extension 2: GET /games/by-platform/{platform} -> filtro insensible a mayusculas
app.MapGet("/games/by-platform/{platform}", (string platform) =>
{
    var found = games.FindAll(g => g.Platform.ToLower() == platform.ToLower());

    // Lista vacia es 200 con []; el 404 queda para el id inexistente
    return Results.Ok(found);
});
```

Extensión 3, validación de fecha reforzada (se agrega en POST y PUT, junto a los demás chequeos, después del chequeo de vacíos):

```csharp
// Extension 3: la fecha tiene que ser interpretable como fecha.
// La fecha sigue viajando y guardandose como string ISO; solo se valida al entrar.
if (!DateTime.TryParse(input.ReleaseDate, out _))
{
    return Results.BadRequest(new { mensaje = "La fecha de lanzamiento no es valida" });
}
```

Extensión 4, revisión cruzada: cada hallazgo se comunica al grupo vecino con la fila del checklist que no pasó y la corrección sugerida; nadie edita el repositorio ajeno. Verificación docente: los dos repos muestran al menos un commit propio de la mejora sugerida, si el grupo la aceptó.

## 3. Respuesta esperada (modelo, con salida verificada)

Con la API corriendo (`dotnet run` dentro de `tp-u1/`) y el puerto informado por la terminal:

| Pedido | Código | Cuerpo esperado |
| --- | --- | --- |
| `GET http://localhost:5080/games` (navegador) | 200 | Array con los tres games |
| `GET http://localhost:5080/games/2` (navegador) | 200 | `{"gameId":2,"title":"Neon carrera","platform":"Carreras","releaseDate":"2022-11-08"}` |
| `GET http://localhost:5080/games/99` | 404 | `{"mensaje":"No existe el game"}` |
| `POST` con los tres campos | 201 | `{"gameId":4,...}` + `Location: /games/4` |
| `POST` con `title` vacío | 400 | `{"mensaje":"Faltan el titulo o la plataforma"}` |
| `PUT /games/1` completo | 200 | JSON reemplazado |
| `PUT /games/99` | 404 | `{"mensaje":"No existe el game"}` |
| `DELETE /games/3` | 204 | Sin cuerpo |
| `DELETE /games/3` otra vez | 404 | `{"mensaje":"No existe el game"}` |

Comando de alta de referencia:

```powershell
curl.exe -i -X POST http://localhost:5080/games -H "Content-Type: application/json" -d "{\"title\":\"Cielo rojo\",\"platform\":\"Consola\",\"releaseDate\":\"2023-05-19\"}"
```

```text
HTTP/1.1 201 Created
Location: http://localhost:5080/games/4

{"gameId":4,"title":"Cielo rojo","platform":"Consola","releaseDate":"2023-05-19"}
```

## 4. Criterios de corrección del TP-u1 (lista de verificación)

Se aplica sobre el repositorio publicado en GitHub y sobre la API corriendo en la PC del grupo, antes de la defensa del encuentro 9. La lista también guía la verificación de entrega del encuentro 9.

| ✔ | Criterio | Evidencia |
| --- | --- | --- |
| ☐ | El proyecto está en `tp-u1/` en la raíz del repo del grupo | Estructura visible en GitHub |
| ☐ | Todo el código vive en `Program.cs`, con records al final | Lectura del archivo; sin carpetas extra |
| ☐ | Entidad con id `long` + tres o cuatro campos; fecha como string ISO | Record de la entidad |
| ☐ | CRUD completo: GET todos, GET uno, POST, PUT, DELETE | Los cinco endpoints en el archivo |
| ☐ | Rutas en inglés y plural, con `{id:long}` y parámetro `long id` | Rutas del archivo |
| ☐ | Record Input (DTO) sin id; el id lo asigna un contador | POST/PUT del archivo |
| ☐ | Campos vacíos → 400 con mensaje en español | Prueba con curl |
| ☐ | Id inexistente → 404 con mensaje, en GET, PUT y DELETE | Pruebas con curl |
| ☐ | Códigos correctos: 200, 201 con Location, 204, 400, 404, siempre con `Results` | Batería completa |
| ☐ | Comentarios abundantes, en español y sin tildes | Lectura del archivo |
| ☐ | `.gitignore` en la raíz con `bin/` y `obj/`; ninguno visible en GitHub | Repo publicado |
| ☐ | Al menos un commit con mensaje `tp-u1: ...` | Pestaña Commits |
| ☐ | `git push` hecho: la entrega completa está visible en GitHub | Repo publicado |

Interpretación de resultados para el registro: el TP se considera **completo** con todas las filas marcadas; con deficiencias menores (comentarios escasos, un mensaje 400 impreciso) queda **completo con observaciones**; con CRUD incompleto, validación ausente o entrega sin push queda **incompleto** y el grupo lo corrige antes del encuentro 9.

## 5. Errores esperados en el desarrollo y la entrega, y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| El grupo «adapta» el ejemplo de movies cambiando solo nombres | Copiar el ejemplo en lugar de diseñar el propio | Volver a la ficha de diseño: los campos y mensajes tienen que salir de la temática del grupo; exigir al menos un campo distinto al del ejemplo |
| El push falla con `Updates were rejected` | El repo remoto se creó con README | No intentar nada por cuenta propia: crear de nuevo el repo remoto vacío junto al docente y repetir el ciclo |
| El repo de GitHub muestra `tp-u1/tp-u1/...` anidado | Se creó el proyecto con `dotnet new web` dentro de una carpeta ya existente | Verificar la estructura; aplanar moviendo los archivos del proyecto a `tp-u1/` y rehacer el commit con acompañamiento |
| `bin/` y `obj/` visibles en GitHub | `.gitignore` inexistente, adentro de `tp-u1/`, o posterior al primer commit | Corregir la ubicación del `.gitignore` a la raíz; acompañar la limpieza del índice y un nuevo commit |
| La API «no anda» en la revisión docente | Última edición sin reiniciar, o `dotnet run` desde otra carpeta | Pedir correr `dotnet run` desde `tp-u1/` frente al docente y repetir dos filas de la batería |
| Mensajes de commit tipo `arreglos` o `final2` | Mensaje escrito a las apuradas | Corregir el hábito en el momento; la convención `tp-u1: resumen` es parte del criterio de entrega |
| Solo un integrante puede explicar el TP | Trabajo sin rotación real | Consultar a cada integrante un endpoint distinto en el momento; reasignar la escritura del próximo bloque si hay desequilibrio evidente |
| Grupo terminó temprano y espera sin tarea | Falta de asignación de extensión | Asignar las actividades de extensión (sección 2 de este anexo) y su commit correspondiente |

## 6. Registro para el encuentro 9

- Al cierre del encuentro, recorrer los repos publicados y completar la lista de verificación de la sección 4 por grupo; guardarla como insumo directo de la verificación de entrega del encuentro 9.
- Registrar los grupos con entrega incompleta y el acuerdo de corrección pactado (qué falta y para cuándo), para seguimiento individual en el encuentro 9.
- Anotar los hallazgos de la revisión cruzada aceptados: alimentan la coevaluación y la devolución del encuentro 10.
