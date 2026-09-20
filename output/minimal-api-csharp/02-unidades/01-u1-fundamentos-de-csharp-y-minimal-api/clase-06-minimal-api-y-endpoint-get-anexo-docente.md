# Anexo docente — Encuentro 6: Minimal API y endpoint GET

## Encuadre

Tercer encuentro de la Unidad 1. Los estudiantes pasan de la consola a la web. Este es un salto conceptual importante: el código ya no "muestra" sino que "responde" a pedidos HTTP. La estructura de `Program.cs` cambia: aparecen builder, endpoints y `app.Run()`. El ejercicio progresivo ahora es una API que devuelve los mismos pacientes que antes se imprimían en consola. Sin base de datos aún: los datos son literales en el código.

## Qué observar durante la clase

- Dificultad para entender que el servidor sigue ejecutándose hasta `Ctrl+C`: algunos cierran la terminal o creen que el programa terminó.
- Tendencia a poner el record al principio: reforzar la regla CS8803.
- Confusión entre ruta (`/patients`) y URL completa (`http://localhost:5000/patients`).
- Olvido de `Results.Ok`: devuelven el objeto crudo o usan `return patients;`.
- Error al probar en navegador mientras el servidor no está corriendo.

## Solución completa del ejercicio independiente

El `Program.cs` completo con ambos endpoints:

```csharp
var patients = new List<Patient>
{
    new Patient(1, "Ana", "Lopez", "F", "1990-05-15"),
    new Patient(2, "Luis", "Martinez", "M", "1985-08-22"),
    new Patient(3, "Elena", "Garcia", "F", "1978-12-03")
};

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// GET /patients — devolver la lista completa
app.MapGet("/patients", () =>
{
    return Results.Ok(patients);
});

// GET /patients/count — devolver la cantidad de pacientes
app.MapGet("/patients/count", () =>
{
    return Results.Ok(new { total = patients.Count });
});

app.Run();

record Patient(long PatientId, string FirstName, string LastName, string Gender, string BirthDate);
```

## Errores previsibles

1. **Proyecto creado como `console` en lugar de `web`:** el `using` necesario no está presente y falla la compilación.
2. **Puerto incorrecto:** .NET puede asignar `5001` o `5293`. El estudiante escribe `5000` fijo y no encuentra la página.
3. **No detener el servidor anterior:** al ejecutar `dotnet run` de nuevo, falla porque el puerto está ocupado.
4. **Endpoint escrito como `MapGet("/patients", patients => ...)`:** confunden el parámetro lambda con la variable de la lista.
5. **Error `CS8803`:** el record aparece antes de `app.Run()`.

## Criterios de logro (4-8)

| Nivel | Descripción |
|---|---|
| 4 | Crea el proyecto web y lo ejecuta; no completa ningún endpoint correcto. |
| 5 | Un endpoint funciona (listado o conteo), el otro no compila o no responde. |
| 6 | Ambos endpoints responden; el record está al final. |
| 7 | Endpoints correctos, formato JSON exacto, detiene el servidor correctamente. |
| 8 | Explica qué hace cada línea: builder, endpoints, app.Run y ubicación del record. |

## Agrupamiento

Individual. Cada estudiante crea su propio proyecto `hospital-api`. El proyecto de consola del encuentro anterior queda como referencia.

## Ajustes para la siguiente edición

- Si más del 30% tiene problemas con el puerto, agregar una línea fija `app.Urls.Add("http://localhost:5000");` entre `builder.Build()` y `app.Run()`.
- Si el concepto de endpoint como "función que espera un pedido" no queda claro, volver a la analogía del take-away al inicio del desarrollo teórico-práctico.