# Continuidad pedagógica 2 — Tras la evaluación de la Unidad 1

> Documento de continuidad pedagógica de la asignatura «Minimal API con C# .NET 6» (documento 2 de 4). Se entrega a la administración para los casos de ausencia del docente: contiene actividades de repaso y fijación realizables **sin presencia docente**. Las soluciones completas y los criterios de corrección se encuentran en el documento docente separado `continuidad-02-tras-evaluacion-u1-anexo-docente.md`, que no se entrega a los alumnos.

## 1. Datos de referencia

| Campo | Detalle |
| --- | --- |
| Asignatura | Minimal API con C# .NET 6 |
| Documento | Continuidad pedagógica 2 — repaso y fijación de la Unidad 1 |
| Momento de uso | Tras la evaluación de la Unidad 1: aplicable desde el Encuentro 10 en adelante, antes de iniciar contenido nuevo. Repasa los núcleos de los Encuentros 4 a 9 |
| Contenidos que repasa | Crear y correr una Minimal API; endpoint con parámetro de ruta; verbos HTTP y códigos de respuesta (200, 201, 204, 400, 404); CRUD completo en memoria; git local (`init`, `add`, `commit`) y ciclo completo de entrega por GitHub |
| Duración teórica | 240 minutos (4 horas reloj) |
| Requisitos | Aula-taller con una PC por grupo (o por alumno, según equipos disponibles); SDK de .NET 6, VS Code y git instalados y verificados; terminal y navegador disponibles; este documento impreso (uno por grupo). Sin uso de celular |
| Organización de la resolución | En forma habitual: por lo general, en grupo, con rotación al teclado; la presentación es individual y manuscrita (ver nota de registro académico) |
| Actividades | Seis actividades puntuadas sobre 100 cuyos tiempos suman 240 minutos |

## 2. Propósito e instrucciones para la resolución

**Propósito (registro docente formal).** Este documento consolida los núcleos de la Unidad 1 antes de incorporar la base de datos en la Unidad 2: el ciclo completo de una Minimal API en memoria (crear, correr, rutas con parámetros, verbos, códigos y CRUD), la validación con códigos 400 y 404, y la rutina de git local junto con el ciclo de entrega por GitHub. Las tareas de programación se realizan en la computadora, siempre en memoria y sin base de datos; las respuestas que se presentan se escriben a mano.

**Instrucciones para el grupo (sin docente):**

1. Leer primero el documento completo: la tabla de actividades indica puntos y tiempo sugerido de cada una.
2. Trabajar en los grupos habituales con rotación al teclado: cada integrante escribe un bloque distinto de la actividad de programación.
3. Cada integrante escribe **sus propias respuestas a mano** en el cuaderno: lo que se presenta al inicio de la próxima clase es individual y manuscrito, aunque el código se haya probado en grupo.
4. Las consignas usan las «Fichas de trabajo» (sección 5); ante una duda de sintaxis, consultar el cuadro de referencia de verbos y códigos de la Unidad 1 o los comentarios del propio código.
5. El tiempo de cada actividad es una guía: si un grupo avanza más rápido, usa el sobrante en completar la batería de pruebas o revisar el checklist de la actividad 4.
6. No se usa celular en ningún momento.
7. Al terminar la actividad 6, cada alumno ordena sus respuestas numeradas para presentarlas manuscritas al inicio de la próxima clase.

## 3. Objetivos

Al trabajar este documento, cada estudiante puede:

1. Crear y correr un proyecto Minimal API desde la terminal con `dotnet new web` y `dotnet run`.
2. Escribir endpoints con rutas y parámetros (`{nombre}`, `{id:long}`) y predecir sus respuestas, incluida la 404.
3. Asociar cada verbo HTTP (GET, POST, PUT, DELETE) con su operación de CRUD y responder con el código correcto (200, 201, 204, 400, 404) mediante la clase `Results`.
4. Implementar un CRUD completo en memoria con validación de campos vacíos, id inexistente y `Results`, todo en `Program.cs`.
5. Sostener la rutina de git local (`git init`, `git add`, `git commit`) y describir el ciclo completo de entrega por GitHub.

## 4. Actividades

| N.º | Actividad | Consigna completa | Puntos | Tiempo |
| --- | --- | --- | --- | --- |
| 1 | La receta de la Minimal API | Escribir las cuatro partes de todo `Program.cs` con su instrucción correspondiente; anotar los comandos de terminal para crear, correr y detener un proyecto; responder qué hay que hacer para que valga un cambio en el código y qué responde la API ante una ruta no definida; y en la PC, crear el proyecto `RepasoApi` con un endpoint `/estado` que devuelva texto, correrlo y anotar el texto obtenido en el navegador. | 15 | 35 min |
| 2 | Rutas que preguntan | Explicar qué toma el parámetro de una ruta como `/hello/{name}` y qué exige el filtro `{id:long}`; completar la tabla de predicciones de la ficha 2 (qué responde cada URL y por qué); y en la PC, agregar al proyecto de la actividad 1 un endpoint con parámetro de texto, probarlo con dos valores y anotar las respuestas, incluyendo la prueba de la ruta sin el parámetro. | 15 | 40 min |
| 3 | Verbos y códigos: el mapa del CRUD | Completar la tabla verbo → letra de CRUD → acción; emparejar los diez casos de la ficha 3 con su código (200, 201, 204, 400 o 404) y su método `Results`; y responder las cuatro preguntas cortas sobre el orden de chequeos del PUT, el cuerpo del 204, dónde y en qué idioma van los mensajes, y por qué los records no se editan. | 15 | 35 min |
| 4 | Mini CRUD en memoria | En la PC del grupo, crear el proyecto `RepasoCrudApi` y construir el CRUD completo en memoria de una entidad elegida: cinco endpoints, record de entrada (DTO) sin id, contador de ids, validación de campos vacíos con 400 y mensaje en español, 404 con mensaje, códigos siempre con `Results`; comentar el código, ejecutar la batería de diez pruebas de la ficha 4 anotando el código obtenido en cada una y cerrar con `git add` y `git commit`. | 35 | 85 min |
| 5 | El cuaderno de git y el ciclo de entrega | Anotar qué comando de git cumple cada acción (iniciar, ver estado, preparar, registrar, leer historial) y qué es el `.gitignore` con qué carpetas lista siempre; numerar en orden los seis pasos del ciclo completo de entrega de la ficha 5; corregir los cuatro errores planteados; y en la PC, dejar el proyecto de la actividad 4 con su repositorio iniciado, `.gitignore` incluido y un commit con mensaje referente, anotando la salida de `git log --oneline`. | 15 | 30 min |
| 6 | Autoevaluación final | Completar la autoevaluación de la sección 6: marcar el nivel de logro de cada objetivo, responder las dos preguntas de reflexión y ordenar las respuestas manuscritas para la presentación. | 5 | 15 min |
| **Total** | — | — | **100** | **240 min** |

## 5. Fichas de trabajo

### Ficha 1 — La receta de la Minimal API (actividad 1)

Responder en el cuaderno:

- **(a)** Las cuatro partes de todo `Program.cs` de este curso, en orden, con la instrucción que las escribe (la primera es «preparar», con `WebApplication.CreateBuilder(args)`).
- **(b)** Los comandos de terminal: crear un proyecto nuevo llamado `RepasoApi`, entrar a su carpeta, correrlo y detenerlo.
- **(c)** Se editó `Program.cs` y se guardó con `Ctrl+S`: ¿qué hay que hacer para que el cambio valga en el navegador? Explicar por qué no alcanza con recargar la página.
- **(d)** ¿Qué responde la API cuando se pide una ruta que nadie definió? ¿Eso significa que el programa está roto?

Y en la PC del grupo:

- **(e)** Crear el proyecto `RepasoApi` con `dotnet new web`, escribir un endpoint `/estado` que devuelva un texto breve, correr con `dotnet run` y probar en el navegador. Anotar el texto obtenido y el puerto que informó la terminal.

**Pista.** La rutina de siempre: guardar con `Ctrl+S`, cortar con `Ctrl+C` y volver a correr con `dotnet run`. El puerto lo informa la línea `Now listening on:` de la terminal.

### Ficha 2 — Rutas que preguntan (actividad 2)

Este es el `Program.cs` de referencia para las predicciones:

```csharp
// Program.cs de referencia: rutas con parametros

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// {name} toma el trozo variable de la URL y lo entrega al handler
app.MapGet("/hello/{name}", (string name) =>
{
    return $"Hola, {name}!";
});

// {id:long} exige ademas que el valor sea un numero entero
app.MapGet("/patients/{id:long}", (long id) =>
{
    return new { patientId = id, firstName = "Ana" };
});

app.Run();
```

**Inciso (a).** Explicar con palabras propias qué toma `{name}` y cómo llega al endpoint.

**Inciso (b).** ¿Qué exige el filtro `{id:long}`? ¿Qué responde la API si el trozo de la URL no es un número? ¿Por qué?

**Inciso (c).** Completar la tabla de predicciones **sin correr la API** y justificar cada respuesta:

| URL | ¿Qué responde? | ¿Por qué? |
| --- | --- | --- |
| `http://localhost:5080/hello/Ana` | | |
| `http://localhost:5080/hello` | | |
| `http://localhost:5080/patients/25` | | |
| `http://localhost:5080/patients/abc` | | |
| `http://localhost:5080/hola/Juan` | | |

**Inciso (d).** En la PC: agregar al proyecto `RepasoApi` un endpoint `/salas/{name}` que devuelva un texto usando el nombre recibido (por ejemplo, `Sala asignada: ` + nombre). Probarlo con dos valores distintos y anotar las respuestas; después probar `http://localhost:5080/salas` sin valor y anotar qué pasó.

### Ficha 3 — Verbos y códigos: el mapa del CRUD (actividad 3)

**Inciso (a).** Completar: cada verbo HTTP con su letra de CRUD y su acción.

| Verbo | Letra de CRUD | Acción |
| --- | --- | --- |
| GET | | |
| POST | | |
| PUT | | |
| DELETE | | |

**Inciso (b).** Emparejar cada caso con su código (200, 201, 204, 400 o 404) y su método `Results`:

| Caso | Código | Método `Results` |
| --- | --- | --- |
| 1. GET `/doctors` y la lista tiene datos | | |
| 2. GET `/doctors/2` y el doctor 2 existe | | |
| 3. GET `/doctors/99` y ese id no existe | | |
| 4. POST `/doctors` sin la especialidad | | |
| 5. POST `/doctors` con todos los campos | | |
| 6. PUT `/doctors/1` con datos completos | | |
| 7. PUT `/doctors/99` y ese id no existe | | |
| 8. PUT `/doctors/2` con el nombre vacío | | |
| 9. DELETE `/doctors/3` y el doctor 3 existe | | |
| 10. DELETE `/doctors/3` otra vez, ya borrado | | |

**Inciso (c).** Responder en una o dos líneas cada pregunta:

1. En un PUT, ¿qué se chequea primero: que exista el recurso o que los datos sean válidos? ¿Por qué?
2. ¿Por qué la respuesta del DELETE correcto no lleva cuerpo?
3. ¿Dónde van los mensajes de los códigos 400 y 404 y en qué idioma se escriben?
4. Los records no se editan: en un PUT correcto, ¿qué se construye y qué se reemplaza?

**Pista.** El cuadro de referencia rápida de la Unidad 1 es el mapa completo: cada caso tiene un único código correcto.

### Ficha 4 — Mini CRUD en memoria (actividad 4)

En la PC del grupo, crear el proyecto con `dotnet new web -n RepasoCrudApi` y construir el CRUD completo **en memoria** (sin base de datos) de una entidad elegida por el grupo: películas, libros, canciones, videojuegos, jugadores, lo que el grupo pueda llenar de datos propios.

**Requisitos obligatorios:**

1. Todo el código en `Program.cs`; los records al final del archivo, después de `app.Run()`.
2. Entidad con id `long` + tres o cuatro campos; si hay fecha, `string` en ISO `yyyy-MM-dd`.
3. Rutas en inglés y en plural, con el filtro `{id:long}` donde va el id.
4. Los cinco endpoints: GET todos, GET uno, POST, PUT uno, DELETE uno.
5. Record de entrada (DTO) para POST y PUT, sin id: el id lo asigna la API con un contador `long`.
6. Validación: campos vacíos con `string.IsNullOrWhiteSpace` → 400 con mensaje en español; id inexistente → 404 con mensaje.
7. Códigos siempre con `Results`: 200, 201 con la ruta del recurso nuevo, 204, 400, 404.
8. Comentarios abundantes en el código (sin tildes en los comentarios).
9. Batería de pruebas ejecutada y anotada en la tabla de abajo: navegador para los GET, `curl.exe` para el resto.
10. Cierre con la rutina de git: `git add .` + `git commit -m "repaso: crud en memoria"`.

**Ejemplos canónicos** (la solución de referencia del docente usa libros, pero cada grupo adapta entidad, campos y mensajes):

```csharp
// Entidad de ejemplo: id SIEMPRE long, fecha SIEMPRE string ISO
record Book(long BookId, string Title, string Author, string PublicationDate);

// DTO de entrada para POST y PUT: sin id, el id lo asigna la API
record BookInput(string Title, string Author, string PublicationDate);
```

```powershell
# POST de ejemplo con curl: comillas internas escapadas con \"
curl.exe -i -X POST http://localhost:5080/books -H "Content-Type: application/json" -d "{\"title\":\"El halo\",\"author\":\"R. Bach\",\"publicationDate\":\"2019-04-11\"}"
```

**Batería de pruebas (anotar el código obtenido en cada fila):**

| Pedido | Código obtenido |
| --- | --- |
| GET de todos los recursos (navegador) | |
| GET de un id que existe (navegador) | |
| GET de un id que no existe (navegador) | |
| POST con todos los campos | |
| POST con un campo vacío | |
| PUT de un id existente, con datos completos | |
| PUT de un id que no existe | |
| PUT con un campo vacío | |
| DELETE de un id que existe | |
| DELETE del mismo id, otra vez | |

**Checklist de defectos frecuentes** (marcar cada fila antes de declarar terminada la actividad):

| ✔ | Defecto | Corrección |
| --- | --- | --- |
| ☐ | Id declarado `int` | En este curso los ids SIEMPRE son `long` |
| ☐ | Fecha declarada con otro tipo o formato | Fechas SIEMPRE `string` en ISO `yyyy-MM-dd` |
| ☐ | Endpoint en español (`/libros`) | Rutas en inglés y plural: `/books` |
| ☐ | Código sin comentarios | Comentar cada acción |
| ☐ | Record declarado antes de `app.Run()` | Records siempre al final del archivo |
| ☐ | 400 o 404 sin cuerpo con mensaje | `new { mensaje = "..." }` siempre, en español |
| ☐ | Lista declarada dentro de un handler | La lista vive UNA vez, arriba, compartida por todos los pedidos |

### Ficha 5 — El cuaderno de git y el ciclo de entrega (actividad 5)

**Inciso (a).** Anotar qué comando de git cumple cada acción:

| Acción | Comando |
| --- | --- |
| Iniciar el repositorio (una sola vez por proyecto) | |
| Ver qué archivos cambiaron | |
| Preparar todo lo nuevo o modificado | |
| Registrar los cambios con un mensaje | |
| Leer el historial de commits en una línea por commit | |

**Inciso (b).** ¿Qué es el `.gitignore`? ¿Qué dos carpetas lista siempre este curso y por qué nunca se versionan?

**Inciso (c).** Estos son los pasos del ciclo completo de entrega por GitHub, desordenados. Numerarlos del 1 al 6 en el orden correcto:

```text
( ) git add .
( ) Crear el repositorio remoto en GitHub desde el navegador.
( ) git commit -m "tp-u1: primera entrega"
( ) git remote add origin https://github.com/usuario/repo-del-grupo.git
( ) git init y crear el .gitignore con bin/ y obj/
( ) git push -u origin main
```

**Inciso (d).** Corregir cada error:

1. Un grupo hace `git push` sin haber hecho nunca `git add` ni `git commit`. ¿Qué faltó? ¿Qué publica ese push?
2. Otro grupo corre `git init` al comienzo de cada clase. ¿Está bien? ¿Cuántas veces se corre ese comando por proyecto?
3. Un commit dice `cambios`. ¿Qué le falta al mensaje? Escribir cómo sería un mensaje correcto para el proyecto de la actividad 4.
4. Un grupo hace `git add .` sin haber creado el `.gitignore`. ¿Qué carpetas quedan versionadas? ¿Qué había que crear antes?

**Inciso (e).** En la PC: sobre la carpeta del proyecto `RepasoCrudApi`, iniciar el repositorio si no está iniciado, crear el `.gitignore` con `bin/` y `obj/`, correr `git add .` y `git commit -m "repaso: crud en memoria"`, y anotar cuántos commits muestra `git log --oneline` con qué mensajes.

### Ficha 6 — Autoevaluación (actividad 6)

La autoevaluación está en la sección 6 de este documento.

## 6. Autoevaluación del alumno

Al finalizar las actividades, completar la siguiente tabla marcando una columna por fila, con honestidad: sirve para saber qué conviene repasar antes de la Unidad 2.

| Objetivo | Lo hice solo | Lo hice con ayuda | No pude todavía |
| --- | --- | --- | --- |
| 1. Crear y correr un proyecto Minimal API desde la terminal. | | | |
| 2. Escribir rutas con parámetros y predecir sus respuestas. | | | |
| 3. Asociar cada verbo HTTP con su operación CRUD y su código de respuesta. | | | |
| 4. Implementar un CRUD completo en memoria con validación y códigos con `Results`. | | | |
| 5. Sostener la rutina de git local y describir el ciclo de entrega por GitHub. | | | |

**Preguntas de reflexión:**

1. ¿Qué parte del CRUD me salió más fluida y cuál me costó más?
2. ¿Qué voy a repasar antes de empezar la Unidad 2 con la base de datos?

## 7. Presentación y nota de registro académico

La presentación se realiza **en forma individual y manuscrita**, al inicio de la próxima clase: cada alumno presenta sus respuestas numeradas por actividad, el esqueleto de su CRUD (rutas, verbos y códigos), la batería de pruebas con los códigos obtenidos y la autoevaluación completa. Es una actividad más de la asignatura y forma parte del proceso de evaluación.

**Nota (registro académico).** La resolución se realiza en forma habitual (por lo general, en grupo); las tareas de programación requieren el uso de la computadora; la presentación es individual y manuscrita, al inicio de la próxima clase, y constituye una actividad más de la asignatura que forma parte del proceso de evaluación.
