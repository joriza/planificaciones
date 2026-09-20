# Anexo docente — Encuentro 7: Verbos HTTP y CRUD en memoria

> Material de uso interno docente. No se distribuye a estudiantes.
> Curso: Desarrollo de APIs con C# .NET 6 (Minimal API) · Unidad 1 — Fundamentos de C#, Git/GitHub y Minimal API

## Encuadre

| Campo | Detalle |
| --- | --- |
| Encuentro | 7 — «Verbos HTTP y CRUD en memoria» (planificación anual) |
| Ejercicio evaluado | `PUT /pacientes/{id:int}/ciudad` (reemplazo parcial de un solo campo) |
| Momento del bloque | Ejercicio independiente (55 min) + puesta en común y cierre (20 min) |
| Insumos | Proyecto `PacientesApi` de la práctica guiada, con el CRUD completo funcionando y `requests.http` creado |

## Solución esperada

Paso previo: declarar un record mínimo para el cuerpo del pedido, junto al record `Paciente` (mismo patrón que ya usa el POST):

```csharp
// Cuerpo del PUT parcial: un objeto JSON con una sola clave.
record CambioCiudad(string Ciudad);
```

Endpoint pedido, junto a los demás:

```csharp
// Solucion del ejercicio: reemplazo parcial de un solo campo.
// El cuerpo llega como objeto JSON y la API lo convierte a CambioCiudad (mismo patron que el POST).
app.MapPut("/pacientes/{id:int}/ciudad", (int id, CambioCiudad datos) =>
{
    var i = pacientes.FindIndex(x => x.Id == id);
    if (i == -1) return Results.NotFound(new { mensaje = "No existe el paciente" });

    pacientes[i] = pacientes[i] with { Ciudad = datos.Ciudad }; // copia corregida: solo cambia Ciudad
    return Results.Ok(pacientes[i]);
});
```

Pedido de prueba en `requests.http`:

```http
### Cambiar solo la ciudad del paciente 1 (esperar 200)
PUT http://localhost:5080/pacientes/1/ciudad
Content-Type: application/json

{ "ciudad": "Rafaela" }
```

Respuestas esperadas:

- Si el id existe → 200 con la ficha completa: ciudad nueva y resto de los campos intactos. Que el nombre siga ahí es la prueba de que `with` conservó la copia.
- Si no existe → 404 con `{"mensaje":"No existe el paciente"}`.

Detalle clave: el cuerpo es un objeto JSON (un par clave-valor, como los vistos en la clase 6). Si alguien manda el texto sin llaves, el pedido falla con 400 (JSON inválido): oportunidad para reforzar la diferencia entre texto plano y objeto JSON.

## Criterios de logro

| # | Criterio | Evidencia observable |
| --- | --- | --- |
| 1 | Ruta `PUT /pacientes/{id:int}/ciudad` definida | "Send Request" responde 200 o 404 según el caso |
| 2 | La ciudad llega por el cuerpo como objeto JSON | El pedido manda `{ "ciudad": "Rafaela" }` en el body |
| 3 | Solo cambia `Ciudad`; `Nombre` e `Id` se conservan | El 200 muestra la ficha con el nombre intacto |
| 4 | 404 con mensaje si el id no existe | `/pacientes/99/ciudad` responde 404 |
| 5 | No muta el `record` ni reconstruye la ficha a mano | El handler usa `with`, no asignaciones directas |

## Observaciones: manejo de códigos de respuesta

- Recorrer el panel de códigos del REST Client pedido por pedido: 200 en GET y PUT, 201 en POST, 204 en DELETE, 404 en los inexistentes.
- Señal de alerta: un estudiante que responde 200 en todos los casos. Preguntar: ¿cómo le avisa la API al cliente que el paciente no existe? Respuesta esperada: 404 con `Results.NotFound`.
- Verificar el encabezado `Location` del POST (apunta a `/pacientes/3`): es la convención REST; hoy se menciona, no se profundiza.
- 204 no trae cuerpo: quien espera texto en la respuesta del DELETE está confundiendo el código (el resultado) con el contenido (los datos).
- Preguntas rápidas de sondeo: ¿qué código responde el GET de un id inexistente? ¿Y un POST exitoso? ¿Y un DELETE repetido?

## Ajustes

- **Si se traba con el record del cuerpo:** versión equivalente por query string, sin record: `PUT /pacientes/1/ciudad?ciudad=Rafaela` con firma `(int id, string ciudad)`. Validar el resto igual y retomar el objeto del cuerpo en la puesta en común.
- **Si avanza con facilidad:** agregar `GET /pacientes/{id:int}/ciudad` que devuelva solo la ciudad (objeto con una clave), o anticipar la validación de Id duplicado del POST que se pedirá formalmente en el Encuentro 8.
- **Error conceptual a vigilar:** intentar `pacientes[i].Ciudad = ciudad`. Los `record` son inmutables: la única vía es reemplazar la ficha con `with`.

## Recordatorio operativo

Verificar que cada estudiante cierre con commit y push (rutina desde el Encuentro 5): `git add .` → `git commit -m "Clase 7: CRUD en memoria con verbos HTTP"` → `git push`.
