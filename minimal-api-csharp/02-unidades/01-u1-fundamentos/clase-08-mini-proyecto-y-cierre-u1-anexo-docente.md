# Anexo docente — Encuentro 8: Mini-proyecto y cierre de la Unidad 1

> Material de uso interno docente. No se distribuye a estudiantes.
> Curso: Desarrollo de APIs con C# .NET 6 (Minimal API) · Unidad 1 — Fundamentos de C#, Git/GitHub y Minimal API

## Encuadre

| Campo | Detalle |
| --- | --- |
| Encuentro | 8 — «Mini-proyecto y cierre U1» (planificación anual) |
| Ejercicio evaluado | `PUT /ingresos/{id:int}` + validación de Id repetido en el POST (400) |
| Momento del bloque | Ejercicio independiente (55 min) + puesta en común y cierre (20 min) |
| Insumos | Proyecto `AdmisionApi` con el esqueleto de la práctica guiada, cuadro de referencia rápida visible |

## Solución del ejercicio

```csharp
// PUT completo: reemplazo de la ficha (patron de la clase 7).
app.MapPut("/ingresos/{id:int}", (int id, Ingreso datos) =>
{
    var i = ingresos.FindIndex(x => x.Id == id);
    if (i == -1) return Results.NotFound(new { mensaje = "No existe el ingreso" });

    ingresos[i] = datos with { Id = id }; // conserva el Id de la ruta
    return Results.Ok(ingresos[i]);
});

// POST con validacion: el Id repetido se rechaza con 400.
app.MapPost("/ingresos", (Ingreso nuevo) =>
{
    if (ingresos.Any(x => x.Id == nuevo.Id))
    {
        return Results.BadRequest(new { mensaje = "Ya existe un ingreso con ese Id" });
    }

    ingresos.Add(nuevo);
    return Results.Created($"/ingresos/{nuevo.Id}", nuevo);
});
```

Pruebas en `requests.http` (reemplazar `5080` por el puerto propio):

```http
### Reemplazar el ingreso 1 (esperar 200)
PUT http://localhost:5080/ingresos/1
Content-Type: application/json

{
  "id": 1,
  "paciente": "Ana Torres",
  "motivo": "Control de rutina reprogramado"
}

### POST con Id repetido (esperar 400)
POST http://localhost:5080/ingresos
Content-Type: application/json

{
  "id": 1,
  "paciente": "Otra Persona",
  "motivo": "Prueba de validacion"
}
```

Respuestas esperadas:

- PUT sobre un id existente → 200 con el motivo nuevo y el Id conservado (aunque el cuerpo trajera otro).
- PUT sobre un id inexistente → 404 con mensaje.
- POST con Id libre → 201 con encabezado `Location` apuntando a `/ingresos/<id>`.
- POST con Id repetido → 400 con `{"mensaje":"Ya existe un ingreso con ese Id"}` y sin agregar el ingreso: verificar con `GET /ingresos` que la lista no cambió.

## Criterios de logro de cierre de unidad

Lista de verificación de objetivos mínimos de la Unidad 1 (base para el tp-u1 del Encuentro 9):

| # | Objetivo mínimo | Verificación en el mini-proyecto |
| --- | --- | --- |
| 1 | Crea y ejecuta un proyecto minimal API | `AdmisionApi` corre con `dotnet run` |
| 2 | Define rutas con y sin parámetro, con restricción `:int` | `GET /ingresos` y `GET /ingresos/{id:int}` |
| 3 | Devuelve objetos JSON y distingue JSON de texto plano | Salidas del GET con claves y tipos correctos |
| 4 | Implementa CRUD completo en memoria (`List<T>` + `record` + `with`) | Los cinco endpoints responden |
| 5 | Elige el código HTTP correcto (200, 201, 204, 400, 404) | Panel de códigos del REST Client, pedido por pedido |
| 6 | Valida reglas simples y responde 400 con mensaje | POST con Id repetido rechazado, lista sin cambios |
| 7 | Versiona con git (commits por encuentro y push) | Historial del repositorio |
| 8 | Explica su código con el proyecto a la vista | Ensayo de defensa en la puesta en común |

## Sugerencia de agrupamiento para el repaso

- **Duplas mixtas:** quien quedó firme en CRUD (clase 7) junto a quien quedó firme en JSON y rutas (clase 6); el esqueleto se completa por turnos en la misma máquina.
- **Grupos impares:** tríos con roles rotativos: quien escribe, quien dicta el patrón de memoria, quien verifica contra el cuadro de referencia.
- **No agrupar entre sí** a quienes no terminaron la clase 7: necesitan un modelo cerca. Ubicarlos con un "firme" o con asistencia directa del docente.
- **Puesta en común:** cada dupla muestra un endpoint y nombra el código de respuesta esperado antes de ejecutarlo.

## Señales de riesgo para la evaluación (Encuentro 9)

Riesgo alto si un estudiante, al cierre del Encuentro 8:

- No completó el CRUD de la clase 7 ni el del mini-proyecto (PUT o validación del POST ausentes).
- No tiene commits de los encuentros o nunca hizo push al remoto.
- No puede explicar qué hace un endpoint propio ni qué código responde y por qué.
- Sigue probando POST, PUT o DELETE desde el navegador después de la clase 7.
- Copió el esqueleto pero no puede señalar dónde vive la lista en memoria.

Acción sugerida: registrar los nombres, acordar un repaso dirigido antes del Encuentro 9 y dejar constancia en el seguimiento del curso. El tp-u1 exige repositorio funcionando y git operativo: son requisitos de la defensa.

## Ajustes

- **Grupo que avanza rápido:** agregar `GET /ingresos/{id:int}/motivo` (devuelve solo el motivo en JSON) o un filtro por paciente con query string (`?paciente=Ana`). Ambos reutilizan lo visto, sin contenido nuevo.
- **Grupo que necesita más apoyo:** consolidar en clase los dos GET, el POST y el DELETE, y dejar el PUT como desafío para resolver antes de la evaluación; entregar el cuadro de referencia en papel para el Encuentro 9.
- **Puesta en común:** resolver en vivo los errores más frecuentes observados hoy, sobre el proyecto de algún estudiante (con su permiso).

## Recordatorio operativo

Al cierre: verificar que cada estudiante haya hecho commit y push del mini-proyecto completo (rutina desde el Encuentro 5): `git add .` → `git commit -m "Clase 8: mini-proyecto AdmisionApi (cierre U1)"` → `git push`.
