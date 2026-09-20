# Anexo docente — Encuentro 4: Primer proyecto Minimal API

> Documento de uso docente. No se distribuye a estudiantes.

## Solución esperada del ejercicio independiente

El ejercicio pide un segundo endpoint `/bienvenida` con un texto propio. Solución de referencia (fragmento de `Program.cs`):

```csharp
app.MapGet("/bienvenida", () => "Bienvenido a la API del hospital.");
```

`Program.cs` completo esperado al cierre del encuentro:

```csharp
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/hola", () => "¡Hola desde la API del hospital!");
app.MapGet("/bienvenida", () => "Bienvenido a la API del hospital.");

app.Run();
```

Se acepta cualquier texto de respuesta siempre que la ruta sea `/bienvenida` y el endpoint responda correctamente al consultarlo en el navegador.

## Criterios de logro mínimos del encuentro

- [ ] Creó el proyecto con `dotnet new web -n HospitalApi` y este compila con `dotnet run`.
- [ ] `Program.cs` conserva la estructura mínima: builder, `Build()`, `MapGet`, `Run()`.
- [ ] Consultó `/hola` en el navegador y obtuvo el texto esperado.
- [ ] Agregó el endpoint `/bienvenida` y lo probó en el navegador.
- [ ] Aplica el ciclo editar → guardar (`Ctrl+S`) → detener (`Ctrl+C`) → `dotnet run` tras cada cambio.

## Qué observar durante la práctica

**Señales de avance fluido:**
- Editan `Program.cs` sin temor, guardan y reinician la API por su cuenta.
- Ante un error de compilación, leen la línea que indica la terminal y comparan con el modelo.

**Señales de bloqueo (intervenir pronto):**
- Ejecutan `dotnet run` en el directorio equivocado y no identifican el problema.
- No guardan el archivo antes de reejecutar y concluyen que "el código no funciona".
- Consultan una URL sin la ruta o mal escrita y asumen que la API está rota.
- Acumulan varias terminales con instancias simultáneas de la API.

**Registro sugerido:** anotar quiénes tienen `/hola` funcionando dentro de los primeros 40 minutos de práctica y quiénes requirieron intervención. Esa lista orienta la formación de parejas en los encuentros siguientes.

## Sugerencia de ajustes según el ritmo del grupo

**Si el grupo avanza lento:**
- Reducir el ejercicio independiente a un único endpoint nuevo, rehecho junto al docente paso a paso en el proyector.
- Repetir entre todos, dos veces, el ciclo completo (editar → guardar → `Ctrl+C` → `dotnet run` → recargar el navegador) antes del trabajo individual.

**Si el grupo avanza rápido:**
- Proponer un tercer endpoint `/horario` con un texto fijo (por ejemplo, el horario de atención del hospital).
- Proponer el experimento guiado de definir la misma ruta dos veces y observar el error del compilador: siembra la idea de rutas únicas.
- Dejar planteada la pregunta "¿qué pasa si quiero que la respuesta cambie en cada pedido?": queda como puente hacia el contenido de la unidad siguiente.
