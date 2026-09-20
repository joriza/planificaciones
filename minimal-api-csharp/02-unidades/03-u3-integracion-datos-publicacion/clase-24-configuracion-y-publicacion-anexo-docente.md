# Anexo docente — Encuentro 24: configuración y publicación

> Material de uso interno docente. No se distribuye a estudiantes.
> Curso: Minimal API con C# .NET 6 · Unidad 3 — Integración de datos y publicación

## Encuadre

| Campo | Detalle |
| --- | --- |
| Encuentro | 24 — Configuración de la cadena de conexión en appsettings.json; publicación con dotnet publish y ejecución en release (planificación anual) |
| Ejercicio evaluado | Sección `App:HospitalName` en `appsettings.json`, endpoint `GET /` con lectura de configuración y fallback, re-publicación y verificación desde la API publicada |
| Momento del bloque | Ejercicio independiente (50 min) + extensión y consolidación (45 min) + cierre (15 min) |
| Insumos | Proyecto `HospitalApi` recién creado en la práctica (paquetes Microsoft.Data.Sqlite + Dapper, `hospital.db` en la raíz), SDK de .NET 6 |

## Preparación previa (gestión del aula)

- Correr antes de clase el ciclo completo del encuentro (configurar, correr, publicar, copiar la base, correr publicado) en una máquina con el perfil de las PCs del aula, y anotar: ruta real de publish, puerto real de la API publicada y tiempos de cada comando. Los tiempos de `dotnet publish` (primera vez vs siguientes) conviene conocerlos para administrar la clase.
- Verificar que todas las cuentas tienen permiso de escritura en la carpeta del proyecto (publicar crea carpetas nuevas) y que el Explorador de archivos está disponible como alternativa al `Copy-Item` de cuatro niveles.
- Tener a mano el `appsettings.json` completo del paso 2 para proyectarlo: la edición del JSON es la primera vez del curso que se toca un archivo que no es `Program.cs`, y el error de la coma perdida es esperable en varios grupos.
- Decidir y anunciar el criterio de evaluación del checklist: cada grupo debe dejar el checklist del paso 7 marcado en su carpeta de trabajo (papel o comentario de commit); es la evidencia del despliegue que se revisa en la clase 25.

## Solución esperada

Sección agregada a `appsettings.json` (junto a las existentes, separada por comas):

```json
{
  "ConnectionStrings": {
    "Hospital": "Data Source=hospital.db"
  },
  "App": {
    "HospitalName": "Hospital Central"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*"
}
```

Lectura de la configuración en `Program.cs` (junto a la de la cadena, antes de `builder.Build()`):

```csharp
// El nombre del hospital tambien es configuracion: misma lectura, mismo fallback.
var hospitalName = builder.Configuration["App:HospitalName"]
                   ?? "HospitalApi";
```

Endpoint de raíz (va junto a los demás, antes de `app.Run()`; no consulta la base):

```csharp
// Solucion del ejercicio: la portada de la API con el nombre configurado.
app.MapGet("/", () =>
{
    return Results.Ok(new { api = $"{hospitalName} API" });
});
```

Pedidos de prueba (desarrollo primero, publicación después):

```http
### Portada en desarrollo (esperar 200 con el nombre del JSON)
GET http://localhost:5080/

### Portada publicada (esperar 200; el puerto lo dice Now listening on)
GET http://localhost:5000/
```

Respuestas esperadas:

- `GET /` en desarrollo → 200 con `{"api":"Hospital Central API"}`: el valor leído de `App:HospitalName`.
- Después de `dotnet publish -c Release` + copiar `hospital.db` + `dotnet ./HospitalApi.dll`: `GET /` publicado → 200 con el mismo cuerpo. El ejercicio obliga a re-publicar: si la portada publicada no muestra el nombre nuevo, alguien probó contra el proceso viejo o no re-publicó.
- Cambio de control: renombrar la clave a `HospitalNameX` en el JSON y reiniciar en desarrollo → `{"api":"HospitalApi API"}`: el fallback del `??` en acción.

Detalles clave de la solución:

- El ejercicio evalúa generalizar el patrón del encuentro (configuración + fallback) a una clave propia, y entender que lo publicado es una copia congelada (re-publicar para que el cambio viaje). Quien hard-codea el nombre en el endpoint resolvió otra cosa.
- El endpoint de raíz no abre conexión: no toda respuesta necesita la base. Nombrarlo en la corrección: abrir conexiones que no se usan es un desperdicio silencioso.

## Solución de la extensión

Los tres puntos son ensayos controlados de falla: todos terminan con el entorno repuesto. La regla de seguridad del aula: probar las fallas SOLO sobre la copia publicada o con los archivos repuestos al final del punto.

Punto 1 — la clave rota (configuración ausente sin fallback):

- Quitar la sección `ConnectionStrings` del JSON y el `??` del código; publicar y correr.
- Resultado esperado: el arranque NO falla (no hay lectura de la cadena al arrancar); el PRIMER pedido a `/admissions/full` da 500 y en la terminal aparece el error de conexión de SQLite. La falla de configuración explota tarde: es el argumento exacto que justifica el `??` del canon.
- Repuesto: reponer sección y `??`, re-publicar (o volver a correr en desarrollo).

Punto 2 — la base que no viaja:

- Borrar `hospital.db` de la carpeta publish, correr `dotnet ./HospitalApi.dll` y pedir un endpoint.
- Resultado esperado: 500 con `no such table: admissions` en el primer pedido, y un `hospital.db` NUEVO y vacío aparecido en la carpeta (verificable con `dir`): SQLite crea el archivo si no existe. El síntoma (tabla inexistente) esconde la causa (base ausente).
- Repuesto: copiar de nuevo la base real a publish.

Punto 3 — el mapa del despliegue (papel): verificar que la secuencia del grupo incluya los ocho pasos con su verificación — editar JSON → `dotnet run` → probar → `dotnet publish -c Release` → copiar base → correr dll → leer puerto → probar endpoints. Ese mapa es el guion literal del ciclo de despliegue del tp-u3 en la clase 25.

## Criterios de corrección

| # | Criterio | Evidencia observable |
| --- | --- | --- |
| 1 | `App:HospitalName` en `appsettings.json` bien formado | El JSON parsea (la API arranca) y la sección convive con las existentes |
| 2 | Lectura con el patrón del encuentro | `builder.Configuration["App:HospitalName"] ?? "HospitalApi"`, antes de `Build()` |
| 3 | `GET /` responde con el nombre configurado | 200 con `{"api":"Hospital Central API"}` en desarrollo |
| 4 | Fallback demostrado | Con la clave renombrada, la portada muestra el texto por defecto en lugar de fallar |
| 5 | Re-publicación efectiva | `dotnet publish -c Release` re-corrido; `GET /` publicado muestra el nombre (puerto leído de `Now listening on`) |
| 6 | Checklist de despliegue completo | Los seis ítems del paso 7 (más la fila del endpoint nuevo) quedan marcados en la carpeta de trabajo |
| 7 | Cierre con rutina Git | `git log` muestra el commit "Clase 24: configuracion y publicacion" y el push al remoto |

## Qué observar en el aula

- **Este encuentro introduce el segundo archivo del curso (`appsettings.json`).** Anunciarlo explícitamente: sigue siendo excepcional; la regla «todo el código vive en Program.cs» no cambia, lo que vive en el JSON es configuración.
- **El paso 4 (renombrar la clave en vivo) es la prueba mínima del patrón:** los grupos deben ver el 200 posterior al sabotaje. Sin esa evidencia, el `??` queda como ritual y no como decisión.
- **Los ensayos de la extensión son la joya del encuentro:** la base que «se crea sola y vacía» explica el `no such table` que varios arrastran desde la Unidad 2. Dedicarle el tiempo que pide.
- **Señal de alerta:** grupos que publican sin errores pero prueban el puerto 5080 (proceso de desarrollo todavía abierto). Hacerles cerrar el `dotnet run` y probar contra el puerto publicado: son dos procesos distintos.
- **Sondeo rápido:** ¿dónde se lee la configuración, antes o después de `Build()`? (antes; el builder ya la tiene). ¿Qué tipo devuelve el indexador y por qué el `??`? (`string?`, la clave puede no existir). ¿Dónde resuelve SQLite la ruta relativa de la base? (contra el directorio de ejecución, no contra el código).

## Errores previsibles y respuestas

- *JSON inválido (coma faltante o de más)* → Edición manual de `appsettings.json`. Intervención: proyectar el JSON canónico del paso 2 y comparar línea por línea; el error se ve, no se adivina.
- *`dotnet publish` no encontrado o publica otra cosa* → El comando se corrió fuera de la carpeta del proyecto. Intervención: verificar con `dir` que el `.csproj` está en la carpeta actual antes de publicar.
- *La API publicada responde 500 con `no such table`* → Base no copiada (o copiada en otra carpeta). Intervención: ejecutar el checklist desde el paso «hospital.db junto al dll»; mostrar el `hospital.db` vacío que SQLite creó.
- *Portada publicada sin el nombre nuevo* → No se re-publicó después del cambio. Intervención: recordar la regla del envase: lo publicado es una copia congelada; cambiar el código no cambia el envase.
- *`Copy-Item` falla por ruta* → No se está parado en la carpeta publish (los cuatro `..\..` no aplican). Intervención: alternativa siempre válida: copiar con el Explorador de archivos arrastrando `hospital.db`.
- *Grupo que termina antes* → Derivar a los ensayos de falla de la extensión y encargarle anotar los mensajes de error literales: son material del repaso para la prueba de la unidad.
