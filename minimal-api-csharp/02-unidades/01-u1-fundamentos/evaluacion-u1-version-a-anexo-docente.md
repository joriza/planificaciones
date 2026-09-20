# Evaluación de la Unidad 1 — Anexo docente Versión A: Guardia del hospital

> Documento de uso docente. No distribuir a estudiantes.

## Solución completa esperada (Program.cs)

```csharp
// tp-u1 — Versión A: Guardia del hospital
// CRUD en memoria de medicos de guardia. Todo el código en Program.cs,
// sin abstracciones, con Minimal API de .NET 6.

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Lista en memoria con 2 medicos precargados. Vive mientras la API esté en ejecución.
var medicos = new List<MedicoGuardia>
{
    new MedicoGuardia(1, "Ana Torres", "Clinica"),
    new MedicoGuardia(2, "Luis Perez", "Traumatologia")
};

// GET /medicos: devuelve la lista completa con 200 (Ok).
app.MapGet("/medicos", () => Results.Ok(medicos));

// GET /medicos/{id:int}: busca por Id con FirstOrDefault.
// La restricción {id:int} evita interpretar como Id un valor que no sea número.
app.MapGet("/medicos/{id:int}", (int id) =>
{
    var medico = medicos.FirstOrDefault(m => m.Id == id);
    if (medico is null)
    {
        // 404 NotFound: el recurso pedido no existe; 200 con vacío sería ambiguo.
        return Results.NotFound(new { mensaje = $"No existe un medico con Id {id}." });
    }
    return Results.Ok(medico);
});

// POST /medicos: agrega un medico nuevo y responde 201 con la ubicación del recurso.
app.MapPost("/medicos", (MedicoGuardia medico) =>
{
    // Validación mínima: el Id debe ser único en la lista.
    if (medicos.Any(m => m.Id == medico.Id))
    {
        // 400 BadRequest: la petición es válida en forma, pero el dato ya existe.
        return Results.BadRequest(new { mensaje = $"El Id {medico.Id} ya está registrado." });
    }
    medicos.Add(medico);
    return Results.Created($"/medicos/{medico.Id}", medico);
});

// DELETE /medicos/{id:int}: elimina y responde 204 (NoContent).
app.MapDelete("/medicos/{id:int}", (int id) =>
{
    var medico = medicos.FirstOrDefault(m => m.Id == id);
    if (medico is null)
    {
        return Results.NotFound(new { mensaje = $"No existe un medico con Id {id}." });
    }
    medicos.Remove(medico);
    return Results.NoContent();
});

app.Run();

// Record inmutable que modela al medico de guardia: Id, Nombre y Especialidad.
record MedicoGuardia(int Id, string Nombre, string Especialidad);
```

Prueba esperada del flujo completo (ejemplo):

```bash
dotnet run
# GET /medicos            -> 200 y la lista con los 2 medicos
# GET /medicos/1          -> 200 con Ana Torres
# GET /medicos/99         -> 404 con mensaje
# POST /medicos           -> 201 con {"id":3,"nombre":"...","especialidad":"..."}
# DELETE /medicos/2       -> 204 sin cuerpo
# DELETE /medicos/2       -> 404 con mensaje
```

## Solución del caso borde (Id repetido en POST)

Petición: `POST /medicos` con `{"id": 1, "nombre": "Maria Diaz", "especialidad": "Pediatria"}` cuando el Id 1 ya existe.

Respuesta esperada: código 400 con cuerpo similar a:

```json
{
  "mensaje": "El Id 1 ya está registrado."
}
```

Criterio de aceptación: la lista NO se modifica y el mensaje menciona el Id en conflicto. Se acepta cualquier redacción equivalente; se exige código 400 y un texto comprensible.

## Criterios de corrección por ítem de la rúbrica

| Ítem | Logrado | Parcial | No logrado |
|---|---|---|---|
| API funcionando sin errores (30) | 25-30: compila, ejecuta `dotnet run` y los 5 endpoints responden según consigna | 15-24: compila y corre, pero un endpoint falla o una ruta tiene un desvío menor | 0-14: no compila, no corre o los endpoints no responden |
| Estructura y claridad del código en Program.cs (20) | 15-20: todo en Program.cs, orden legible, nombres consistentes y comentarios que explican decisiones | 8-14: funciona pero es desordenado o los comentarios son escasos o genéricos | 0-7: código confuso, secciones mezcladas o copiado sin comprensión |
| Códigos de respuesta y validaciones correctos (20) | 15-20: 200, 404, 201, 204 y 400 con mensaje, todos correctos | 8-14: códigos correctos en su mayoría pero falta la validación o el mensaje del caso borde | 0-7: códigos incorrectos o ausentes |
| Entrega por Git (15) | 12-15: carpeta tp-u1, commits con mensajes referentes y push dentro del encuentro | 6-11: push hecho pero con mensajes genéricos ("cambios", "fix") o commits únicos tardíos | 0-5: sin push, sin commits o entrega fuera de la carpeta tp-u1 |
| Defensa individual (15) | 12-15: explica sus decisiones con sus palabras y realiza la modificación menor sin ayuda | 6-11: explica parcialmente y necesita ayudas del docente para la modificación | 0-5: no puede explicar el código ni modificarlo |

Aprobación: 60 puntos o más Y defensa realizada.

## Preguntas sugeridas para la defensa individual

Cada estudiante responde las preguntas y realiza una modificación menor. Modificaciones menores válidas: cambiar un dato precargado, agregar un tercer medico precargado, cambiar el texto de un mensaje, cambiar una especialidad.

1. **¿Qué hace `MapPost` en tu código y qué verbo HTTP le corresponde?**
   Respuesta esperada: registra el endpoint de alta en la ruta `/medicos`; corresponde al verbo POST, que se usa para crear recursos. Debe mencionar que el cuerpo de la petición viaja en JSON y se deserializa al record.
2. **¿Qué hace `FirstOrDefault` en tu búsqueda y qué devuelve si no encuentra nada?**
   Respuesta esperada: recorre la lista y devuelve el primer medico cuyo Id coincide con el parámetro; si no hay coincidencias devuelve `null`, y por eso el código compara contra `null` para responder 404.
3. **¿Por qué respondés 404 y no 200 cuando el medico no existe?**
   Respuesta esperada: 404 comunica que el recurso pedido no existe; un 200 con cuerpo vacío o con `null` diría que la petición fue exitosa cuando en realidad no se encontró nada. El código de estado informa el resultado real.
4. **¿Qué hiciste en el commit y por qué elegiste ese mensaje?**
   Respuesta esperada: describe el contenido real del commit (por ejemplo, alta y baja de medicos) y justifica el mensaje como referente: quien lea el historial entiende qué cambió sin abrir los archivos.
5. **¿Qué pasa con la lista de medicos si se reinicia la API? ¿Por qué?**
   Respuesta esperada: se pierde y vuelve a la lista precargada; los datos viven en memoria mientras el proceso está en ejecución y no hay persistencia (base de datos) en esta unidad.

## Registro de resultados — Versión A

| Grupo | Estudiante | API (30) | Código (20) | Códigos y validaciones (20) | Git (15) | Defensa (15) | Total (/100) | Defensa realizada (Sí/No) | Resultado | Observaciones |
|---|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |

Resultado: Aprobado (60 o más y defensa realizada) / No aprobado.
