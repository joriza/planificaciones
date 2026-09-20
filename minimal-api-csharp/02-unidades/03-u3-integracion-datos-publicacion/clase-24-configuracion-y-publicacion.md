# Encuentro 24 — Configuración y publicación

> Unidad 3 — Integración de datos y publicación

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 24 |
| Unidad | 3 — Integración de datos y publicación |
| Duración teórica | 4 horas reloj (240 minutos) |
| Concepto nuevo | Cadena de conexión en `appsettings.json` leída con `builder.Configuration[...]`; compilación en Release; `dotnet publish`; ejecución de la API publicada con `dotnet ./HospitalApi.dll` |
| Requisitos previos | Clase 23 completada (endpoints robustos sobre hospital.db; `Data Source=hospital.db` escrito a mano en cada proyecto de la materia) |
| Uso de celular | No permitido |
| Grupos | Presentes ÷ equipos disponibles (mínimo posible); rotación de integrantes entre la práctica y la extensión |
| Planificación anual | Encuentro 24: configuración de la cadena de conexión en appsettings.json; publicación con dotnet publish y ejecución en release |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y puente | 20 min |
| Teoría mínima | 40 min |
| Práctica guiada | 70 min |
| Ejercicio independiente | 50 min |
| Extensión y consolidación | 45 min |
| Cierre | 15 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

**Apertura y puente (20 min).** Observación del curso: en cada proyecto desde la Unidad 2, la cadena `var connectionString = "Data Source=hospital.db";` está escrita dentro del código. Funciona, pero tiene un precio: cambiar la cadena exige tocar el código, recompilar y volver a probar. Pregunta puente: ¿qué pasa si el archivo de la base está en otra carpeta, o si el día de mañana la base vive en un servidor? El dato de conexión es CONFIGURACIÓN, no lógica: pertenece a un archivo de configuración que el programa lee al arrancar. Y una vez que la API queda lista, falta el segundo paso de la vida real: empaquetarla con `dotnet publish` y correrla desde la carpeta publicada, sin `dotnet run`.

Al finalizar el encuentro, cada estudiante puede:

1. Mover la cadena de conexión a `appsettings.json` (sección `ConnectionStrings`) y leerla con `builder.Configuration["ConnectionStrings:Hospital"]`.
2. Justificar el valor por defecto con `??`: si la clave no existe, la API arranca igual con la cadena canónica.
3. Publicar la API con `dotnet publish -c Release` y ubicar `hospital.db` junto al ejecutable en la carpeta publish.
4. Ejecutar la API publicada con `dotnet ./HospitalApi.dll` y probarla en el navegador, reconociendo el cambio de puerto.
5. Completar un checklist de despliegue local que verifica cada paso antes de dar por publicada la API.

## 3. Teoría mínima (40 min)

### Charla rápida: el pedido para llevar

Un restaurante no manda la cocina entera cuando alguien pide comida para llevar: cocina en la cocina, y lo que viaja es el plato terminado, empaquetado, con lo justo para comerlo en otra mesa. `dotnet run` es la cocina: necesita el proyecto completo, el código fuente y la carpeta del programa. `dotnet publish` es el pedido empaquetado: compila en modo Release, junta en una sola carpeta lo que la API necesita para correr y nada más. La carpeta `publish` es el envase: si falta algo dentro (la base de datos, por ejemplo), el plato llega incompleto a la otra mesa.

### Lo mínimo indispensable

**El archivo de configuración.** El proyecto de `dotnet new web` ya trae `appsettings.json` con la configuración de logging. La cadena de conexión se agrega como una sección más:

```json
{
  "ConnectionStrings": {
    "Hospital": "Data Source=hospital.db"
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

La ruta de la clave se escribe con dos puntos: `ConnectionStrings:Hospital` (sección, luego subclave).

**La lectura.** Antes de `builder.Build()`, la configuración ya está disponible en el builder. La lectura canónica del curso, mínima y sin registos extra:

```csharp
// La cadena vive en appsettings.json; si la clave falta, ?? entrega el default.
var connectionString = builder.Configuration["ConnectionStrings:Hospital"]
                       ?? "Data Source=hospital.db";
```

`builder.Configuration["..."]` devuelve `string?`: la clave puede no existir. El `?? "Data Source=hospital.db"` garantiza que `connectionString` sea un `string` seguro: si alguien renombra la clave en el JSON, la API arranca igual con la cadena canónica en lugar de romperse en el arranque.

**Los dos modos de compilación.** `Debug` (el de `dotnet run`) compila rápido y lleva información extra para depurar. `Release` (`-c Release`) compila optimizado: es el modo con el que el software sale al mundo. `dotnet publish -c Release` hace las dos cosas: compila en Release y copia el resultado a la carpeta publish (`bin\Release\net6.0\publish\`).

**La base junto al ejecutable.** La cadena `Data Source=hospital.db` es una ruta relativa: se resuelve contra la carpeta DESDE la que corre el programa, no contra donde está el código. Por eso el checklist de publicación incluye copiar `hospital.db` a la carpeta publish y correr desde ahí. Si el archivo no está, SQLite no da un error claro al arrancar: crea una base VACÍA con ese nombre en la carpeta actual, y el primer pedido al endpoint falla con `no such table`. El síntoma y la causa viven en lugares distintos: por eso existe el checklist.

**Ejecutar lo publicado.** Dentro de la carpeta publish:

```powershell
dotnet ./HospitalApi.dll
```

El programa que corre es el mismo, pero ya no viaja `dotnet run` ni launchSettings: el puerto por defecto pasa a ser el 5000 (ver la línea `Now listening on:`).

## 4. Práctica guiada (70 min)

### Paso 1 — Crear el proyecto

```powershell
dotnet new web -n HospitalApi
cd HospitalApi
code .
```

Agregar los paquetes y copiar `hospital.db` a la raíz, como siempre.

```powershell
dotnet add package Microsoft.Data.Sqlite
dotnet add package Dapper
```

### Paso 2 — Editar appsettings.json

Abrir `appsettings.json` (está en la raíz del proyecto, creado por la plantilla) y agregar la sección `ConnectionStrings` al principio. El archivo debe quedar así:

```json
{
  "ConnectionStrings": {
    "Hospital": "Data Source=hospital.db"
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

Guardar. Las comas separan las secciones: `ConnectionStrings` cierra con `},` y deja lugar a `Logging`.

### Paso 3 — Reemplazar Program.cs

Borrar todo el contenido de `Program.cs` y pegar este código completo (la API compacta de la unidad: un detalle con JOIN triple y una estadística):

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var builder = WebApplication.CreateBuilder(args);

// La cadena de conexion vive en appsettings.json (seccion ConnectionStrings,
// clave Hospital). Si la clave no existe, el ?? entrega la cadena canonica
// y la API arranca igual. Este dato es configuracion, no logica.
var connectionString = builder.Configuration["ConnectionStrings:Hospital"]
                       ?? "Data Source=hospital.db";

var app = builder.Build();

// GET /admissions/full: el detalle compuesto de la unidad (JOIN triple).
app.MapGet("/admissions/full", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var admissions = connection.Query<AdmissionDetail>(@"
        SELECT a.admission_date AS AdmissionDate,
               a.discharge_date AS DischargeDate,
               a.diagnosis AS Diagnosis,
               p.first_name || ' ' || p.last_name AS PatientName,
               d.first_name || ' ' || d.last_name AS DoctorName,
               d.specialty AS DoctorSpecialty
        FROM admissions a
        JOIN patients p ON a.patient_id = p.patient_id
        JOIN doctors d ON a.attending_doctor_id = d.doctor_id
        ORDER BY a.admission_date DESC").ToList();

    return Results.Ok(admissions);
});

// GET /stats/admissions-by-specialty: la estadistica de la clase 22.
app.MapGet("/stats/admissions-by-specialty", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var stats = connection.Query<AdmissionBySpecialty>(@"
        SELECT d.specialty AS Specialty,
               COUNT(*) AS TotalAdmissions
        FROM admissions a
        JOIN doctors d ON a.attending_doctor_id = d.doctor_id
        GROUP BY d.specialty
        ORDER BY TotalAdmissions DESC").ToList();

    return Results.Ok(stats);
});

app.Run();

// Los records van SIEMPRE al final del archivo, despues de app.Run().
record AdmissionDetail(
    string AdmissionDate,
    string? DischargeDate,
    string? Diagnosis,
    string PatientName,
    string DoctorName,
    string DoctorSpecialty);

record AdmissionBySpecialty(string Specialty, int TotalAdmissions);
```

La diferencia con las clases anteriores está en el bloque de arriba de todo: la cadena ya no está escrita a mano, se lee del archivo de configuración.

### Paso 4 — Levantar en modo desarrollo y probar

```powershell
dotnet run
```

Probar `http://localhost:5080/admissions/full` → 200. La API está leyendo la cadena desde `appsettings.json`. Para confirmarlo: renombrar la clave `Hospital` a `HospitalX` en el JSON, reiniciar y volver a probar → sigue funcionando con 200, porque el `??` entregó el default. Volver a dejar la clave como estaba.

### Paso 5 — Publicar en Release

```powershell
dotnet publish -c Release
```

Leer la salida: al final aparece `HospitalApi -> ...\bin\Release\net6.0\publish\`. Esa carpeta es el envase del pedido.

### Paso 6 — Llevar la base al envase y correr

```powershell
cd bin\Release\net6.0\publish
Copy-Item ..\..\..\..\hospital.db .
dotnet ./HospitalApi.dll
```

(El `Copy-Item` sube cuatro niveles —publish, net6.0, Release, bin— hasta la raíz del proyecto; también puede copiarse `hospital.db` arrastrándolo desde el Explorador de archivos.)

### Paso 7 — Probar la API publicada

Mirar la línea `Now listening on:`: el puerto ya no es el de `dotnet run` (por lo general es 5000). Probar en el navegador:

- `http://localhost:5000/admissions/full` → 200 con el detalle completo.
- `http://localhost:5000/stats/admissions-by-specialty` → 200 con el ranking.

### Checklist de despliegue local

| ✔ | Paso | Verificación |
| --- | --- | --- |
| ☐ | `dotnet publish -c Release` termina sin errores | La salida muestra la ruta de `...\publish\` |
| ☐ | `HospitalApi.dll` existe en la carpeta publish | `dir` muestra el dll |
| ☐ | `hospital.db` está junto al dll | `dir` muestra la base en la misma carpeta |
| ☐ | Se corre desde la carpeta publish | `dotnet ./HospitalApi.dll` con la terminal parada ahí |
| ☐ | `Now listening on` leído | El puerto anotado (no asumir el de desarrollo) |
| ☐ | Endpoints probados en el navegador | 200 en los dos endpoints |

### Salidas esperadas

**Durante `dotnet run` (desarrollo):** `http://localhost:5080/admissions/full` → 200 con el detalle de ingresos; renombrar la clave no rompe el arranque gracias al `??`.

**Durante la publicación:** la última línea es la ruta de publish:

```text
HospitalApi -> D:\ruta\HospitalApi\bin\Release\net6.0\publish\
```

**API publicada:** `dotnet ./HospitalApi.dll` arranca y muestra `Now listening on: http://localhost:5000`; ambos endpoints responden 200 con el mismo JSON que en desarrollo. La misma API, otro envase.

## 5. Ejercicio independiente (50 min)

Trabajo por grupos: presentes ÷ equipos disponibles, un equipo por PC. Rotación de roles a mitad del bloque: quien conduce publica, quien observó verifica el checklist.

### Consigna

1. Agregar al `appsettings.json` una sección propia del curso con el nombre del hospital:

   ```json
   "App": {
     "HospitalName": "Hospital Central"
   }
   ```

2. Exponer el endpoint `GET /` que devuelva 200 con un objeto que incluya el nombre leído de la configuración (con el mismo patrón del `??`, con un texto por defecto si la clave falta). Ejemplo de respuesta: `{"api":"Hospital Central API"}`.
3. Re-publicar con `dotnet publish -c Release`, verificar el endpoint NUEVO desde la API publicada (no desde desarrollo) y completar el checklist de despliegue con la fila extra del nuevo endpoint.

### Pista

La lectura es idéntica a la de la cadena: `builder.Configuration["App:HospitalName"] ?? "HospitalApi"`. El endpoint de raíz no consulta la base: responde directo. Recordar que lo publicado es una COPIA congelada del programa: los cambios en el código o en el JSON valen después de volver a publicar. La solución completa está en el anexo docente.

## 6. Extensión y consolidación (45 min)

Para los grupos que completan la consigna base. Los demás consolidan completando el checklist con acompañamiento.

1. **Ensayo de falla 1: la clave rota.** Borrar la sección `ConnectionStrings` completa del `appsettings.json` y eliminar también el `??` del código (dejar `var connectionString = builder.Configuration["ConnectionStrings:Hospital"];`). Publicar y correr: el arranque NO falla. El primer pedido al endpoint sí: 500, y en la terminal el error de conexión. Lectura: la configuración ausente explota tarde (al pedir datos), no temprano; el `??` del canon evita exactamente eso. Reponer todo.
2. **Ensayo de falla 2: la base que no viaja.** Borrar `hospital.db` de la carpeta publish, correr `dotnet ./HospitalApi.dll` desde ahí y pedir un endpoint: 500 con `no such table`. Verificar con `dir` que apareció un `hospital.db` NUEVO y vacío en la carpeta: SQLite crea el archivo si no existe, y el error real (base ausente) se disfraza de error de tabla. Es el motivo del checklist.
3. **Consolidación: el mapa del despliegue.** Cada grupo escribe en papel la secuencia completa — editar JSON → dotnet run → probar → dotnet publish → copiar base → correr dll → probar — con el verificador de cada paso. Rotación: escribe quien no condujo. Ese mapa es el guion del despliegue del tp-u3 en la clase 25.

## 7. Cierre (15 min)

### Qué te llevás

- La cadena de conexión es configuración, no lógica: vive en `appsettings.json` (sección `ConnectionStrings`) y se lee con `builder.Configuration["ConnectionStrings:Hospital"]`, con `??` para el valor por defecto.
- `dotnet publish -c Release` empaqueta la API en `bin\Release\net6.0\publish\`: el plato terminado, listo para otra mesa.
- `Data Source=hospital.db` es una ruta relativa al directorio de ejecución: la base viaja a la carpeta publish y la API corre desde ahí con `dotnet ./HospitalApi.dll`.
- El puerto cambia al correr publicado (típicamente 5000): siempre leer `Now listening on`, nunca asumir.
- Cuando falta la base, SQLite crea una vacía y el error llega como `no such table` en el primer pedido: el checklist de despliegue existe para que el síntoma nunca sea una sorpresa.

### Lo que viene

Encuentro 25: «Sprint integrador; cierre de la Unidad 3 y entrega del tp-u3». Sin contenido nuevo: todo lo de la unidad (JOIN triple, GROUP BY, subconsultas, datos sucios, configuración y publicación) se usa junto para construir y entregar el trabajo práctico. El ciclo de entrega ya es conocido: carpeta `tp-u3/`, commits referentes y push.

### Recordatorio de commit (rutina desde el Encuentro 5)

```powershell
git add .
git commit -m "Clase 24: configuracion y publicacion"
git push
```

## 8. Errores comunes y trampas

| Trampa | Causa | Cómo se resuelve |
| --- | --- | --- |
| `no such table: admissions` al correr publicado | `hospital.db` no se copió a la carpeta publish; SQLite creó una base vacía en el directorio de ejecución | Copiar la base junto al dll (checklist) y correr desde esa carpeta |
| Probar el puerto 5080 contra la API publicada | Asumir el puerto de desarrollo | Leer `Now listening on:` del proceso publicado (típicamente 5000) |
| La API publicada no muestra los cambios recientes | Se editó el código o el JSON y no se volvió a publicar: lo publicado es una copia congelada | Repetir `dotnet publish -c Release` después de cada cambio que deba viajar |
| `builder.Configuration["..."]` da error de nulos al arrancar | La clave no existe y se usa el valor directamente, sin `??` | Agregar el `?? "valor por defecto"`: la clave ausente no debe romper el arranque |
| JSON mal formado después de editar `appsettings.json` | Falta una coma entre secciones o sobra una al final | Comparar contra el JSON del paso 2: `ConnectionStrings` cierra con `},` y deja lugar a la sección siguiente |
| Publicar desde una carpeta equivocada | El comando se corrió fuera de la carpeta del proyecto (sin el `.csproj` a la vista) | Parar la terminal en la raíz del proyecto (junto al `.csproj`) antes de publicar |
