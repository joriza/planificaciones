# Encuentro 25 — Sprint integrador, cierre de la Unidad 3 y entrega del tp-u3

> Unidad 3 — Integración de datos y publicación

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 25 |
| Unidad | 3 — Integración de datos y publicación |
| Duración teórica | 4 horas reloj (240 minutos) |
| Concepto nuevo | Ninguno: encuentro de cierre. Integración de JOIN triple, agregaciones con GROUP BY, subconsultas, datos sucios, configuración y publicación en el trabajo práctico `tp-u3` |
| Requisitos previos | Clases 21 a 24 completadas; proyecto de la clase 24 con la API publicada funcionando; repositorio del grupo con `tp-u1` y `tp-u2` entregados |
| Uso de celular | No permitido |
| Grupos | Presentes ÷ equipos disponibles (mínimo posible); rotación de integrantes al cerrar cada requisito del sprint |
| Planificación anual | Encuentro 25: sprint integrador, cierre de la Unidad 3 y entrega del tp-u3 |

### Reparto de tiempos teóricos (formato de cierre de unidad)

| Momento | Tiempo teórico |
| --- | --- |
| Apertura | 15 min |
| Sprint integrador y consolidación | 75 min |
| Trabajo del tp-u3 | 90 min |
| Ciclo de entrega por GitHub | 45 min |
| Cierre | 15 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

**Apertura (15 min).** Anuncio del encuentro: no hay contenido nuevo; hay integración. La Unidad 3 construyó, clase a clase, las piezas de una API que sabe leer una base real con sus imperfecciones y mudarse empaquetada a otra carpeta. Hoy esas piezas se usan juntas en un solo trabajo: el `tp-u3`, que se construye en sprint durante el encuentro y se entrega por GitHub con el ciclo ya conocido. La evaluación de la unidad es el próximo encuentro.

Al finalizar el encuentro, cada estudiante puede:

1. Planificar el trabajo en sprint: leer la consigna, repartir los requisitos entre los integrantes del grupo y estimar el orden de construcción.
2. Implementar los requisitos del `tp-u3` combinando las herramientas de las cuatro clases de la unidad (JOIN triple, GROUP BY, búsqueda con validación, dato sucio, configuración).
3. Probar cada requisito contra casos felices y casos de error (400 y 404) antes de darlo por terminado.
4. Completar el ciclo de entrega: carpeta `tp-u3/`, commits con mensajes referentes y push al repositorio del grupo.
5. Explicar qué herramienta de la unidad resuelve cada requisito del trabajo (mapa requisito → clase), base de la defensa de la evaluación.

## 3. Consolidación de la unidad (75 min)

### Charla rápida: el examen de manejo

El examen de manejo no tiene teoría nueva: uno sienta, arranca el auto y maneja. Todo lo que se estudió —espejos, cambios, frenada— vale porque se usa TODO a la vez, en una sola vuelta. El sprint de hoy es el examen de manejo de la Unidad 3: el mismo motor, la misma base y las mismas herramientas de siempre, ahora juntas en un solo trabajo con fecha de entrega.

### La unidad en un cuadro

Consolidación guiada con el proyector: recorrer los cuatro temas de la unidad y fijar, para cada uno, la herramienta y el archivo donde ya se resolvió. Cada grupo completa el mismo cuadro en papel (es el mapa de la defensa del encuentro 26):

| Problema del hospital | Herramienta | Clase que la resolvió |
| --- | --- | --- |
| Cada ingreso con los datos del paciente y del médico | JOIN triple con alias calificados + DTO compuesto | 21 |
| ¿Cuántos ingresos por especialidad? ¿Qué médico atendió más? | COUNT/AVG/SUM + GROUP BY + ORDER/LIMIT | 22 |
| Pacientes con más de N ingresos; pacientes de 60 años o más | Subconsulta escalar correlacionada y subconsulta con `IN` | 23 |
| Alta sin fecha (`NULL`), typos («Stomache Pain»), altas de 1971 | `IS NULL`, `COALESCE` y filtros de auditoría | 23 |
| La cadena de conexión escrita dentro del código | `appsettings.json` + `builder.Configuration[...]` + `??` | 24 |
| Entregar la API para correr en otra carpeta | `dotnet publish -c Release` + `dotnet ./HospitalApi.dll` | 24 |

Verificación de la consolidación: por cada fila, un grupo distinto nombra el endpoint de la práctica de esa clase que ya lo resolvió. Quien no lo ubica, lo busca en su proyecto: el sprint empieza con la caja de herramientas a la vista.

### Las reglas del sprint

- Los requisitos de la consigna (sección 5) se reparten entre los integrantes: uno o dos por requisito, según el tamaño del grupo. Ningún requisito sin dueño.
- Rotación al cerrar cada requisito: quien lo construyó lo explica en dos minutos y quien observó revisa la prueba antes de marcarlo terminado.
- Un requisito se considera terminado cuando compila, responde bien en el caso feliz Y en el caso de error que pida la consigna, y tiene su commit.

## 4. Práctica guiada: arranque del sprint (90 min)

Los pasos 1 a 6 los hace todo el grupo junto (el andamio); el paso 7 organiza el reparto. A partir de ahí, cada integrante construye su requisito con la consigna de la sección 5.

### Paso 1 — Crear la carpeta del trabajo y el proyecto

En la raíz del repositorio del grupo (donde ya están `tp-u1` y `tp-u2`):

```powershell
mkdir tp-u3
cd tp-u3
dotnet new web -n HospitalApi
cd HospitalApi
code .
```

### Paso 2 — Agregar los paquetes y copiar la base

```powershell
dotnet add package Microsoft.Data.Sqlite
dotnet add package Dapper
```

Copiar `hospital.db` a la raíz del proyecto (junto al `.csproj`), como en toda la unidad.

### Paso 3 — Configurar appsettings.json

Editar `appsettings.json` (el andamio ya adopta el patrón de la clase 24):

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

### Paso 4 — Pegar el esqueleto de Program.cs

Borrar todo y pegar este código completo. El esqueleto ya trae el patrón de existencia + 404 que la consigna exige, y los records de los dos requisitos de consulta:

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var builder = WebApplication.CreateBuilder(args);

// Configuracion de la clase 24: la cadena vive en appsettings.json
// y el ?? garantiza el arranque aunque la clave falte.
var connectionString = builder.Configuration["ConnectionStrings:Hospital"]
                       ?? "Data Source=hospital.db";

var app = builder.Build();

// GET /patients/{id}: un paciente por id. Es el ejemplo de partida del
// esqueleto: muestra el patron completo de existencia + 404 con mensaje
// que los requisitos de la consigna reutilizan.
app.MapGet("/patients/{id:long}", (long id) =>
{
    using var connection = new SqliteConnection(connectionString);

    var patient = connection.QueryFirstOrDefault<Patient>(@"
        SELECT patient_id AS PatientId,
               first_name AS FirstName,
               last_name AS LastName,
               gender AS Gender,
               birth_date AS BirthDate
        FROM patients
        WHERE patient_id = @Id",
        new { Id = id });

    return patient is null ? Results.NotFound(new { mensaje = "No existe el paciente" })
                           : Results.Ok(patient);
});

app.Run();

// Los records van SIEMPRE al final del archivo, despues de app.Run().
// Record canonico de paciente (ids long, fechas string).
record Patient(long PatientId, string FirstName, string LastName, string Gender, string BirthDate);

// Detalle de ingreso (clase 21): para el requisito del JOIN triple.
record AdmissionDetail(
    string AdmissionDate,
    string? DischargeDate,
    string? Diagnosis,
    string PatientName,
    string DoctorName,
    string DoctorSpecialty);

// Estadistica por especialidad (clase 22): para el requisito de GROUP BY.
record AdmissionBySpecialty(string Specialty, int TotalAdmissions);
```

### Paso 5 — Correr el andamio

```powershell
dotnet run
```

### Paso 6 — Verificar el andamio antes de repartir

- `http://localhost:5080/patients/1` → 200 con el paciente 1.
- `http://localhost:5080/patients/9999` → 404 con `{"mensaje":"No existe el paciente"}`.

Si el andamio no responde así, el sprint no arranca: se corrige primero (las causas típicas están en la sección 8).

### Paso 7 — Leer la consigna y repartir

Leer la consigna completa (sección 5) en voz alta, decidir en el grupo el orden de construcción (sugerido: JOIN triple → 404 de existencia → estadística → búsqueda → dato sucio) y anotar en papel quién es dueño de cada requisito. El andamio ya trae `AdmissionDetail` y `AdmissionBySpecialty` para que dos de los requisitos arranquen con su DTO listo; los demás DTOs los define cada dueño siguiendo el mismo estilo.

### Salida esperada del bloque

Al terminar el bloque de 90 minutos el grupo tiene: el proyecto `tp-u3/HospitalApi` configurado con `appsettings.json`, el andamio corriendo y probado, el reparto anotado y al menos el primer requisito construyéndose. Los requisitos restantes se completan en el bloque de ejercicio independiente y, si hiciera falta, se cierran con el ciclo de entrega del final.

## 5. Ejercicio independiente: consigna del tp-u3 y ciclo de entrega (45 min)

### Consigna: tp-u3 — «API de ingresos del hospital»

Una API sobre `hospital.db` con TODOS estos requisitos. Cada uno se construye sobre el molde de la clase indicada, con consultas parametrizadas, `Results` explícitos, records al final y comentarios en español:

1. **Endpoint compuesto con JOIN triple** — `GET /admissions/full`: cada ingreso con los datos del paciente y del médico tratante (DTO compuesto con alias AS, nombres armados con `||`, orden por fecha de ingreso descendente). Molde: clase 21.
2. **Endpoint de estadística con GROUP BY** — elegir UNO: `GET /stats/admissions-by-specialty` (ingresos por especialidad), `GET /stats/by-month` (ingresos por mes) o `GET /stats/top-doctors/{top}` (los N médicos con más ingresos, con `LIMIT` parametrizado). Molde: clase 22.
3. **Búsqueda LIKE con validación** — `GET /patients/search?term=xxx`: pacientes cuyo apellido contenga el término. Término ausente, vacío o con menos de 2 caracteres → 400 con mensaje; término válido sin coincidencias → 200 con `[]`. Molde: clases 12 y 22.
4. **404 de existencia sobre el JOIN triple** — `GET /doctors/{id}/admissions`: los ingresos atendidos por un médico; médico inexistente → 404 con mensaje. Molde: clase 21.
5. **Manejo explícito de un dato sucio** — elegir UNO y justificarlo en un comentario del endpoint: (a) `GET /admissions/open` con `IS NULL` (los aún internados), (b) `GET /patients/{id}/admissions` con altas imposibles filtradas (1971 o previas al ingreso), (c) `COALESCE` para no exponer diagnósticos nulos. Molde: clase 23.

**Entrega (el ciclo ya conocido desde el tp-u1):** carpeta `tp-u3/` en el repositorio del grupo, commits con mensajes referentes (`tp-u3: ...`) durante el desarrollo y push al final. Verificar que `.gitignore` sigue excluyendo `bin/` y `obj/`.

**Defensa (encuentro 26):** cada integrante explica los requisitos que construyó y el mapa requisito → clase del cuadro de la sección 3.

### Pista

Cada requisito ya tiene su solución de referencia en el proyecto del grupo: las clases 21 a 24 dejaron endpoints completos y probados en el cuadro de consolidación. El trabajo del sprint es adaptarlos al proyecto del TP (cambiar poco, entender todo: la defensa pregunta el porqué de cada línea). El tratamiento del dato sucio se elige según lo que el grupo quiera contar en la defensa; los tres son válidos. La solución completa del TP está en el anexo docente.

### Ciclo de entrega (checklist)

| ✔ | Paso | Verificación |
| --- | --- | --- |
| ☐ | Los 5 requisitos compilan y responden | Cada endpoint probado en el navegador, caso feliz y caso de error |
| ☐ | `git status` muestra solo lo esperado | Sin `bin/` ni `obj/` en la lista (`.gitignore` en la raíz) |
| ☐ | Commits por avance con mensajes referentes | `tp-u3: endpoint join triple`, `tp-u3: estadistica por especialidad`, ... |
| ☐ | Push al remoto | `git push` sin errores |
| ☐ | Verificación en GitHub | La carpeta `tp-u3/` está en el repositorio con el `Program.cs` y `appsettings.json` |

```powershell
git status
git add .
git commit -m "tp-u3: api de ingresos del hospital"
git push
```

## 6. Extensión y consolidación

Para los grupos que completan la consigna base dentro del tiempo. Los demás consolidan terminando los requisitos con acompañamiento: la entrega honesta de lo alcanzado vale más que la entrega apurada de todo.

1. **Requisito extra de subconsulta.** Agregar `GET /stats/seniors-by-specialty` (la consulta gancho de la clase 23): ingresos a pacientes de 60 años o más, por especialidad. Es el único requisito de la unidad que la consigna no pide; sumarlo es la diferencia entre TP completo y TP integral.
2. **Demostración publicada.** Publicar el TP con el checklist de la clase 24 y dejar la API publicada lista para la defensa del encuentro 26: mostrar los endpoints desde `dotnet ./HospitalApi.dll` vale como prueba de madurez del despliegue.
3. **Revisión cruzada.** Intercambiar repositorios con otro grupo y revisar la consigna del ajeno con el checklist de esta sección: cada hallazgo se reporta como sugerencia, no como corrección. Rotación: revisa quien no expuso.

## 7. Cierre (15 min)

### Qué te llevás

- El sprint convierte la unidad en un producto: cinco requisitos que se resuelven con cinco herramientas ya construidas y probadas clase a clase; el trabajo del sprint es adaptar y conectar, no inventar.
- Un requisito está terminado cuando compila, responde al caso feliz Y al caso de error, y tiene su commit; probar el caso feliz solo es la mitad del trabajo.
- El ciclo de entrega ya es rutina: carpeta nueva, commits referentes, push y verificación en GitHub; lo nuevo de este TP es la carpeta `tp-u3/` y los requisitos de robustez.
- El cuadro de consolidación (problema → herramienta → clase) es el mapa de la defensa: cada requisito del TP tiene una clase que lo respalda.
- La entrega es honesta: si el tiempo no alcanzó, se entrega lo que funciona, con el commit que lo documente; la evaluación defiende lo entregado, no lo prometido.

### Lo que viene

Encuentro 26 — Evaluación de la Unidad 3: verificación de la entrega del `tp-u3` por GitHub (30 min), defensa individual de los requisitos construidos (90 min) y prueba práctica individual en versiones A y B (90 min), con el cierre final del encuentro. La defensa recorre exactamente el mapa de la sección 3; la prueba práctica resuelve una consigna pequeña sobre los mismos núcleos de la unidad.

### Recordatorio de commit (rutina desde el Encuentro 5)

```powershell
git add .
git commit -m "tp-u3: api de ingresos del hospital"
git push
```

## 8. Errores comunes y trampas

| Trampa | Causa | Cómo se resuelve |
| --- | --- | --- |
| El sprint arranca sin andamio verificado | Se salteó el paso 6 y se repartió sobre un proyecto que no corre | Corregir el andamio primero: los cinco requisitos heredan el mismo error si la base no responde |
| Requisito «terminado» sin caso de error | Se probó solo el caso feliz | Cada endpoint del TP se prueba con su 400 o su 404 antes de marcarse en el checklist |
| `bin/` y `obj/` en el repositorio | `.gitignore` no está en la raíz del repo o quedó incompleto | Verificar `git status` antes del add; el `.gitignore` de las entregas anteriores sigue siendo el de todo el curso |
| Commit gigante de todo el TP al final | Se retrasó la rutina de commit por avance | Commit por requisito terminado: el historial `tp-u3: ...` es parte de la evidencia |
| Búsqueda `/patients/search` sin casos de validación | El 400 quedó sin probar (o sin implementar) | Probar en vivo los tres bordes: sin término, término de 1 carácter, término válido sin coincidencias |
| Duplicar el DTO del andamio en cada requisito | Copiar y pegar en lugar de reutilizar | Un record por forma de respuesta; `AdmissionDetail` y `AdmissionBySpecialty` ya están en el esqueleto para reutilizarse |
