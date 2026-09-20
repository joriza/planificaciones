# Anexo docente — Encuentro 11: Dapper: Query&lt;T&gt; y primeros endpoints con datos reales

> Material de uso interno docente. No se distribuye a estudiantes.
> Curso: Desarrollo de APIs con C# .NET 6 (Minimal API) · Unidad 2 — Acceso a datos: SQLite y Dapper

## Encuadre

| Campo | Detalle |
| --- | --- |
| Encuentro | 11 — «Dapper: Query&lt;T&gt; / SELECT con mapeo a records» · «Conexión a la base / Alias AS y DTOs» (carácter procedimental) |
| Ejercicio evaluado | `GET /especialidades` con `DISTINCT`, `ORDER BY` y record propio de una propiedad |
| Momento del bloque | Ejercicio independiente (55 min) + puesta en común y cierre (20 min) |
| Insumos | Proyecto `HospitalApi` con los paquetes instalados, `hospital.db` junto al `.csproj` y `/provincias` + `/medicos` funcionando |

**Decisiones didácticas del código de la práctica** (todas verificadas con .NET 6 + Microsoft.Data.Sqlite + Dapper actuales):

- **Ids como `long`:** SQLite entrega los enteros como `Int64` y Dapper encaja el constructor del record por tipos exactos. Con `int`, el endpoint responde 500 con `... one matching signature (System.Int64 ...) is required for ... materialization`. Se enseña `long` de entrada y el error queda documentado en la trampa correspondiente.
- **Fechas como `string` en esta etapa:** SQLite guarda fechas como TEXT `AAAA-MM-DD` y el mapeo automático a `DateOnly` falla con la combinación actual de paquetes (mismo error de constructor). La conversión a tipos de fecha se retoma más adelante; hoy el foco es el mapeo por nombre.
- **Conexión dentro del handler con `using`:** una conexión por pedido, cerrada automáticamente al salir del bloque. Se evita a propósito la conexión global: más adelante se discute por qué.
- **Sin `connection.Open()`:** Dapper abre y cierra la conexión si está cerrada; menos líneas para la primera conexión de la carrera. En el anexo queda registrado por si alguien pregunta.

## Solución esperada

Se agrega al `Program.cs` de la práctica: el endpoint (junto a los demás) y el record (al final del archivo, junto a los otros):

```csharp
// GET /especialidades: las especialidades medicas sin repetir, alfabeticas
app.MapGet("/especialidades", () =>
{
    using var connection = new SqliteConnection(connectionString);

    // DISTINCT: una sola fila por valor distinto de la columna
    var especialidades = connection.Query<SpecialtyName>(
        @"SELECT DISTINCT specialty AS Name
          FROM doctors
          ORDER BY Name").ToList();

    return Results.Ok(especialidades);
});
```

```csharp
record SpecialtyName(string Name);
```

Salida esperada (verificada sobre `hospital.db`; el arreglo es de un solo nivel, cada elemento con la clave `name` en camelCase):

```json
[
  {"name":"Cardiologist"},
  {"name":"Cardiovascular Surgeon"},
  {"name":"Gastroenterologist"},
  {"name":"General Surgeon"},
  {"name":"Gerontologist"},
  {"name":"Internist"},
  {"name":"Neurologist"},
  {"name":"Nuclear Medicine"},
  {"name":"Obstetrician/Gynecologist"},
  {"name":"Oncologist"},
  {"name":"Orthopaedic Surgeon"},
  {"name":"Pediatrician"},
  {"name":"Psychiatrist"},
  {"name":"Respirologist"},
  {"name":"Urologist"}
]
```

El `AS Name` es obligatorio: sin él, la columna `specialty` no encaja en la propiedad `Name` y el endpoint responde 500 con `... is required for SpecialtyName materialization`. Se acepta cualquier orden de las líneas del SQL (`SELECT DISTINCT ... ORDER BY` también puede escribirse como `ORDER BY specialty`) siempre que la salida quede alfabética por la clave `name`.

No se considera logro: devolver la tabla completa con repetidos (falta `DISTINCT`); usar el record `Doctor` recortado en lugar de uno propio de una propiedad; devolver 200 con arreglo vacío por un `WHERE` de más; omitir el `ORDER BY`.

## Criterios de logro

| # | Criterio | Evidencia observable |
| --- | --- | --- |
| 1 | El endpoint responde 200 con el arreglo de especialidades | JSON en el navegador, un elemento por especialidad, sin repetidos |
| 2 | La salida está ordenada alfabéticamente | `Cardiologist` primero, `Urologist` último |
| 3 | Hay un record propio de una propiedad | `record SpecialtyName(string Name);` al final del archivo |
| 4 | El `AS Name` está presente y justificado | Ante la pregunta "¿qué pasa si lo saco?", predice el 500 de materialización o lo demuestra |
| 5 | Sabe explicar el recorrido del dato | Menciona conexión → SQL → encaje por nombre → JSON con palabras propias |

## Qué observar durante la práctica

- **Predicción antes de probar:** antes de recargar `/provincias` y `/medicos`, que anuncien cuántos elementos va a traer cada uno (13 y 27; se contaron en el Encuentro 10). Quien no predice está copiando sin leer el SQL.
- **Lectura del error del Paso 6:** pedir que encuentren en el mensaje de la terminal los dos nombres que no coincidieron (`province_id` / `ProvinceId`). El objetivo del experimento no es asustar con el 500 sino mostrar que el error **dice** qué falló; es la misma lectura que harán solos en el ejercicio.
- **Coincidencia de nombres uno a uno:** el error más frecuente del encuentro es un alias faltante o mal tipeado entre las cuatro columnas de `/medicos`. Que comparen columna por columna contra el record, no contra el ejemplo de `/provincias`.
- **Ubicación del `.db`:** un 500 `no such table` casi siempre significa que la base no quedó junto al `.csproj`. Mostrar el archivo fantasma vacío que Microsoft.Data.Sqlite crea cuando no encuentra el real: explica el error y enseña a borrarlo.
- **`long` versus `int`:** quien "corrige" el `long` del ejemplo por `int` por costumbre de la Unidad 1 va a chocar con el error de constructor. Está bien que choque: la trampa está documentada y la lectura del error cierra el aprendizaje.
- **Prueba rápida de comprensión:** cambiar el `ORDER BY last_name, first_name` de `/medicos` por `ORDER BY first_name` y pedir la primera fila esperada antes de recargar.

## Ajustes

- **Si avanza con facilidad:** (a) laboratorio de errores guiado: cambiar `long` por `int` a propósito, leer el error completo y volver atrás; (b) anticipo del Encuentro 12: agregar `WHERE province_id = 'ON'` a `/provincias` con el valor escrito en el SQL (todavía sin parámetros) y contar cuántas filas quedan.
- **Si se traba:** checklist en este orden: (1) ¿los dos `using` están al tope? (2) ¿los dos `PackageReference` figuran en el `.csproj`? (3) ¿`hospital.db` está junto al `.csproj`? (4) ¿cada columna tiene su `AS` y coincide con el record? Comparar contra `/provincias`, que funciona, en lugar de reescribir desde cero.
- **Error frecuente a anticipar:** editar el SQL sin detener la API y concluir que "no pasa nada": con `dotnet run` el cambio requiere Ctrl+C y ejecutar de nuevo. Recordarlo antes del Paso 6.
- **Nota operativa sobre paquetes:** la práctica usa `dotnet add package` sin versión (verificado hoy con .NET 6). Si en el futuro una versión exigiera un runtime más nuevo, fijar versiones compatibles: `dotnet add package Microsoft.Data.Sqlite --version 8.0.0` y `dotnet add package Dapper --version 2.1.35`.

## Recordatorio operativo

Verificar en los últimos minutos que cada estudiante haya hecho commit y push (rutina desde el Encuentro 5): `git add .` → `git commit -m "Clase 11: la API lee hospital.db con Dapper"` → `git push`. Confirmar que `hospital.db` quedó incluido en el commit: sin ese archivo, el proyecto no levanta en otra máquina.
