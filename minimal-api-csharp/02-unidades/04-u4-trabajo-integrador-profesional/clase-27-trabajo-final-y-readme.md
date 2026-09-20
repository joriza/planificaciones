# Encuentro 27 — Lanzamiento del trabajo final y README de portada

## 1. Metadatos del encuentro

| Campo | Detalle |
| --- | --- |
| Encuentro | 27 |
| Unidad | Unidad didáctica 4: Trabajo integrador profesional (encuentro 1 de 5) |
| Eje temático | Eje 4: Trabajo integrador profesional |
| Carácter | Procedimental |
| Duración | 240 minutos: apertura y puente 20 · teoría mínima 40 · práctica guiada 70 · ejercicio independiente 50 · extensión y consolidación 45 · cierre 15 |
| Concepto nuevo | Consigna integradora del trabajo final (requisitos a-f); README de portada del repositorio; carpeta `trabajo-final/` |
| Requisitos | Contenidos de las unidades 1 a 3 (rutas, verbos, Dapper parametrizado, JOIN triple, GROUP BY, validaciones manuales, datos sucios); repositorio del grupo en GitHub con `tp-u1`, `tp-u2` y `tp-u3` entregados |
| Uso del celular | No permitido |
| Trabajo en equipo | Grupos: alumnos presentes ÷ equipos disponibles (mínimo posible); ningún equipo sin usar mientras haya alumnos sin equipo; rotación de integrantes |

## 2. Objetivos de aprendizaje

1. Leer e interpretar la consigna integradora del trabajo final y sus seis requisitos obligatorios.
2. Crear la carpeta `trabajo-final/` con un proyecto Minimal API conectado a `hospital.db` y verificar la conexión con un endpoint de prueba.
3. Redactar el README de portada del repositorio con la estructura obligatoria del curso.
4. Registrar el punto de partida del trabajo final con commits y push en el repositorio del grupo.

## 3. Teoría mínima

### Apertura y puente (20 min)

Devolución de la evaluación de la Unidad 3: resultados generales del grupo, dos núcleos logrados que se destacan (consultas con JOIN triple y agregaciones) y los errores frecuentes vistos en las defensas. La devolución cierra con el puente: todo lo que el grupo demostró en `tp-u3` es exactamente lo que hoy se convierte en el **trabajo final**. Se anuncia la lógica de la Unidad 4: la misma API, el mismo repositorio, ahora con flujo profesional de trabajo.

### El trabajo integrador y su consigna

El trabajo final es una API completa llamada **«Gestión hospitalaria»**: un producto único que integra las tres unidades anteriores sobre la misma base `hospital.db`. No se crea un repositorio nuevo: se trabaja sobre el repositorio del grupo, en una carpeta nueva llamada `trabajo-final/`, con todo el código en `Program.cs`.

**Consigna integradora — API «Gestión hospitalaria»** (documento canónico de la unidad; los encuentros 30 y 31 y la defensa del encuentro 32 derivan de esta consigna):

| Req | Requisito obligatorio | Endpoint | Códigos esperados |
| --- | --- | --- | --- |
| a | Endpoint compuesto con JOIN triple (`admissions` + `patients` + `doctors`) | `GET /admissions/details` | 200 |
| b | Estadística con GROUP BY | `GET /stats/specialties` | 200 |
| c | Búsqueda con LIKE validada por apellido | `GET /patients/search?term=...` | 200 · 400 · 404 |
| d | Escritura validada de un recurso: alta y baja de paciente | `POST /patients` y `DELETE /patients/{id}` | 201 · 204 · 400 · 404 |
| e | Manejo explícito de un dato sucio real de la base | `GET /admissions/dirty-dates` | 200 |
| f | README de portada del repositorio | archivo `README.md` en la raíz del repo | — |

Definición precisa de cada requisito:

- **(a) `GET /admissions/details`:** devuelve la lista de ingresos con fecha de ingreso, fecha de alta, diagnóstico, nombre completo del paciente, nombre completo del médico y especialidad, resueltos con un JOIN de tres tablas. Ordenada por fecha de ingreso descendente.
- **(b) `GET /stats/specialties`:** devuelve la cantidad de ingresos por especialidad médica con `COUNT(*)` y `GROUP BY`, ordenada por cantidad descendente.
- **(c) `GET /patients/search?term=...`:** busca pacientes por apellido con `LIKE`. Si falta el parámetro o viene vacío responde **400** con mensaje en español; si nadie coincide responde **404** con mensaje en español; si hay coincidencias responde **200** con la lista.
- **(d) `POST /patients` y `DELETE /patients/{id}`:** alta validada de paciente (201 al crear; 400 si falta un dato, el género no es `M`/`F`, la fecha no es ISO o la provincia no existe) y baja validada (204 al borrar; 404 si el id no existe; 400 si el paciente tiene ingresos registrados).
- **(e) `GET /admissions/dirty-dates`:** la base contiene un dato sucio real: ingresos cuya fecha de alta es **anterior** a la fecha de ingreso (varios registros con alta `'1971-01-05'`). El endpoint los detecta con una comparación de fechas ISO y los devuelve con 200, para poder explicar y mostrar el tratamiento del dato sucio en la defensa.
- **(f) `README.md` en la raíz del repositorio:** portada del repo con: nombre y descripción del proyecto, integrantes, cómo clonar y correr, y tabla de endpoints con ejemplos curl.

Reglas generales de la consigna (mismas del curso): todo el código en `Program.cs` con records al final; Dapper con consultas SIEMPRE parametrizadas; respuestas SIEMPRE con `Results`; rutas en inglés y plural; ids `long`, fechas `string` ISO; mensajes de error en español; commits con la convención `trabajo-final: <lo hecho>`.

### El README de portada

**Analogía — el cartel de la puerta:** el README es el cartel de la puerta de un negocio: quien pasa por la calle (quien entra al repo) tiene que poder leer qué se vende, quiénes atienden y cómo entrar. Si el cartel está vacío, aunque adentro el negocio funcione perfecto, nadie va a saber usarlo. En GitHub, el README es lo primero que se ve al entrar al repositorio: es la portada del proyecto.

Estructura obligatoria del README de portada (el ejemplo completo está en el anexo docente del encuentro):

```markdown
# <Nombre del proyecto>

<Descripción en dos líneas: qué es la API y sobre qué base trabaja.>

## Integrantes

| Nombre | Usuario de GitHub |
| --- | --- |
| ... | ... |

## Cómo clonar y correr

1. `git clone <url del repo>`
2. `cd <repo>/trabajo-final`
3. Requiere el SDK de .NET 6. `hospital.db` va junto al `.csproj`.
4. `dotnet run` y abrir `http://localhost:5080`.

## Endpoints

| Método | Ruta | Qué hace | Estado |
| --- | --- | --- | --- |
| ... | ... | ... | ... |
```

La columna **Estado** (`listo` / `en desarrollo` / `pendiente`) convierte al README en el tablero visible del trabajo final: se actualiza en cada encuentro de la unidad.

## 4. Práctica guiada

> Trabajo por grupos con rotación de integrantes: quien teclea, quien dicta la consigna y quien prueba con `curl` cambian de rol en cada paso. Todo se hace sobre el clon local del repositorio del grupo.

### Paso 1 — Crear el proyecto del trabajo final

```powershell
cd repo-del-grupo                      # carpeta del repositorio del grupo
dotnet new web -o trabajo-final        # proyecto nuevo en la carpeta trabajo-final
cd trabajo-final
dotnet add package Microsoft.Data.Sqlite
dotnet add package Dapper
copy ..\tp-u3\hospital.db .            # la base va SIEMPRE junto al .csproj
```

Verificar con `dir` (o `ls`): dentro de `trabajo-final/` deben quedar el `.csproj`, `Program.cs` y `hospital.db`.

### Paso 2 — Arrancar y comprobar que la base responde

Agregar a `Program.cs` el endpoint de prueba (requisitos de las unidades 1 y 2, conocidos):

```csharp
using Dapper;                    // Ejecuta SQL sobre la conexion
using Microsoft.Data.Sqlite;     // Conexion a archivos SQLite

var builder = WebApplication.CreateBuilder(args);   // Arranque estandar de la API
var app = builder.Build();                          // Construye la aplicacion

// Cadena de conexion canonica: hospital.db junto al .csproj
var connectionString = "Data Source=hospital.db";

// GET /patients/{id}: endpoint de prueba para verificar la conexion a la base
app.MapGet("/patients/{id:long}", (long id) =>
{
    // using: la conexion se cierra sola al salir del handler
    using var connection = new SqliteConnection(connectionString);

    // Consulta parametrizada: cada columna snake_case lleva AS para coincidir con el record
    var patient = connection.QueryFirstOrDefault<Patient>(
        @"SELECT patient_id  AS PatientId,
                 first_name  AS FirstName,
                 last_name   AS LastName,
                 gender      AS Gender,
                 birth_date  AS BirthDate,
                 city        AS City,
                 province_id AS ProvinceId,
                 allergies   AS Allergies,
                 height      AS Height,
                 weight      AS Weight
          FROM patients
          WHERE patient_id = @id",
        new { id });

    // Sin fila: 404 con mensaje. Con fila: 200 con el paciente en JSON
    return patient is null ? Results.NotFound(new { mensaje = "No existe el paciente" })
                           : Results.Ok(patient);
});

app.Run();   // Deja la API escuchando pedidos

// ---- Records: SIEMPRE al final del archivo ----
record Patient(
    long PatientId, string FirstName, string LastName, string Gender,
    string BirthDate, string? City, string ProvinceId, string? Allergies,
    int? Height, int? Weight);
```

```powershell
dotnet run
```

Salida esperada en la terminal (el puerto real lo indica la línea `Now listening on:`):

```text
Now listening on: http://localhost:5080
```

Probar desde otro terminal o desde el navegador:

```powershell
curl http://localhost:5080/patients/1
```

Salida esperada (los valores concretos dependen de la base del grupo):

```json
{"patientId":1,"firstName":"Ana","lastName":"Garcia","gender":"F","birthDate":"2001-03-14","city":"Toronto","provinceId":"ON","allergies":"Penicillin","height":165,"weight":58}
```

> En Windows PowerShell, `curl` puede ser un alias de `Invoke-WebRequest`: usar `curl.exe`.

### Paso 3 — Primer commit del trabajo final

```powershell
git add .
git commit -m "trabajo-final: proyecto base conectado a hospital.db"
git push
```

### Paso 4 — Crear el README de portada en la raíz del repo

Desde GitHub web: **Add file → Create new file**, nombrarlo exactamente `README.md` (en la raíz, no dentro de `trabajo-final/`), pegar la estructura de la teoría con los datos del grupo y confirmar con **Commit changes**. Después, desde el clon local:

```powershell
cd ..
git pull
```

Salida esperada: la página principal del repositorio muestra el README renderizado debajo de la lista de archivos.

> Es el último push directo a `main` del curso: a partir del próximo encuentro, `main` pasa por revisión y queda protegida.

### Paso 5 — Lectura guiada de la consigna

Recorrer los requisitos a-f con el grupo y anotarlos en la tabla de endpoints del README con estado `pendiente`. Preguntas guía: ¿qué tabla necesita cada requisito?, ¿qué códigos tiene que devolver?, ¿con qué lo probarían con `curl`?

## 5. Ejercicio independiente

**Consigna:** cada grupo completa su README inicial y lo sube al repositorio:

1. Título y descripción del proyecto.
2. Tabla de integrantes con nombre y usuario de GitHub.
3. Sección «Cómo clonar y correr» con los comandos exactos.
4. Tabla de endpoints con los siete previstos (el de prueba más los requisitos a-f), cada uno con método, ruta, qué hace y estado `pendiente`.
5. Commit y push del README actualizado.

**Pista:** seguir la estructura de la teoría paso por paso; los ejemplos curl de la tabla se completan cuando cada endpoint exista (no copiar comandos que todavía no funcionan). El ejemplo completo de README está en el anexo docente del encuentro.

## Extensión y consolidación

Para quienes completan la consigna base:

- Agregar al README las secciones «Tecnologías» (SDK de .NET 6, SQLite, Dapper) y «La base de datos» (`hospital.db`: tablas `province_names`, `doctors`, `patients`, `admissions`).
- Explorar el README de un proyecto real de código abierto en GitHub y anotar dos ideas que valga la pena imitar.
- Repasar los requisitos a-f y marcar cuáles el grupo ya sabría resolver hoy con lo aprendido en las unidades 2 y 3; ese autoinforme es el insumo del próximo encuentro.

Consolidación docente: puesta en común rápida de dos README proyectados, con corrección de estructura en vivo.

## 6. Cierre

### Qué te llevás

- El trabajo final es la API «Gestión hospitalaria» sobre `hospital.db`, en la carpeta `trabajo-final/` del repositorio del grupo, con todo el código en `Program.cs`.
- La consigna tiene seis requisitos obligatorios (a-f): JOIN triple, estadística con GROUP BY, búsqueda con LIKE validada, escritura validada, manejo de un dato sucio y README de portada.
- El README es la portada del repo: proyecto, integrantes, cómo clonar y correr, y tabla de endpoints con estado.
- El endpoint de prueba `/patients/{id}` confirma que la base está bien conectada antes de construir encima.
- Cada avance queda registrado con commits `trabajo-final: <lo hecho>` y push.

### Lo que viene

En el encuentro 28 el trabajo final se organiza como lo organiza un equipo profesional: cada requisito se convierte en un **issue** de GitHub y cada issue se trabaja en su propia **rama** `feature/<nombre>`, sin tocar `main` hasta que el trabajo esté revisado.

## 7. Errores comunes y trampas

| Error | Causa | Fix |
| --- | --- | --- |
| El proyecto se crea en el lugar equivocado | Ejecutar `dotnet new web` estando parado en la raíz del repo o en otra carpeta | Verificar la carpeta con `dir` antes de crear; usar siempre `dotnet new web -o trabajo-final` desde la raíz del repo |
| `no such table: patients` al probar el endpoint | `hospital.db` no quedó junto al `.csproj` (quedó en la raíz del repo o en otra carpeta) | Copiar la base dentro de `trabajo-final/` con `copy ..\tp-u3\hospital.db .` |
| El README aparece dentro de `trabajo-final/` | El archivo se creó desde el editor en la carpeta del proyecto | La portada es del repo: `README.md` va en la raíz; mover el archivo y commitear el cambio |
| El `push` rechaza el pedido | Un integrante actualizó el README desde GitHub web y el clon local quedó atrás | Primero `git pull`, después commitear y push |
| 500 al pedir un paciente | Record con id `int` en vez de `long` (el mapeo de Dapper falla) | Declarar los ids SIEMPRE `long`; leer el error completo en la terminal donde corre `dotnet run` |
| La conexión rota se descubre tarde | El grupo escribió varios endpoints antes de probar el primero | Probar siempre con un endpoint mínimo apenas se copia la base; recién después construir los requisitos |
