# Encuentro 8 — Mini-proyecto y cierre de la Unidad 1

> Unidad 1 — Fundamentos de C#, Git/GitHub y Minimal API

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 8 |
| Unidad | 1 — Fundamentos de C#, Git/GitHub y Minimal API (cierre de unidad) |
| Duración teórica | 4 horas reloj (240 minutos) |
| Concepto nuevo | Integración de los contenidos de la unidad (sin contenido nuevo: consolida y sistematiza) |
| Requisitos previos | Clases 4 a 7 completadas (primera API; git; JSON y rutas; CRUD en memoria con `PacientesApi`) |
| Uso de celular | No permitido |
| Planificación anual | Encuentro 8: «Mini-proyecto y cierre U1» |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y puente | 30 min |
| Teoría mínima | 45 min |
| Práctica guiada | 90 min |
| Ejercicio independiente | 55 min |
| Puesta en común y cierre | 20 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

**Apertura y puente (30 min).** Dibujar en el pizarrón el mapa de la unidad: Encuentro 4 proyecto (primera API con `MapGet`) → Encuentro 5 git (versionado y entrega) → Encuentro 6 JSON y rutas → Encuentro 7 verbos y CRUD → hoy, Encuentro 8: todo junto en un solo proyecto. Pregunta disparadora: ¿pueden armar, sin mirar la clase 7, el esqueleto completo de una API que registra ingresos?

Al finalizar el encuentro, cada estudiante puede:

1. Reconstruir el esqueleto de una API CRUD: proyecto, `record`, `List<T>` en memoria y endpoints.
2. Completar el PUT de un recurso siguiendo el patrón visto (`FindIndex` + `with`).
3. Validar una regla simple y responder 400 Bad Request con mensaje (Id repetido en el POST).
4. Usar el cuadro de referencia rápida de verbos y códigos como material de consulta.
5. Dejar el repositorio listo para la evaluación: proyecto funcionando y commits al día.

## 3. Teoría mínima (45 min)

### Mapa de la unidad

Sin contenido nuevo: hoy se reorganiza lo visto.

| Encuentro | Contenido | Que hoy se usa para... |
| --- | --- | --- |
| 4 | Primera API: `MapGet` y texto | La estructura mínima de todo proyecto (`builder`, `app`, `MapGet`, `Run`) |
| 5 | Git: `init`, `commit`, `remote`, `push` | Versionar el mini-proyecto y dejarlo defendible |
| 6 | JSON, parámetros de ruta y query string | Devolver objetos y recibir valores por URL |
| 7 | Verbos HTTP y CRUD en memoria | El patrón completo de los endpoints |
| 8 | Integración (hoy) | El mini-proyecto «Admisión de pacientes» |

### Referencia rápida: verbos HTTP y códigos de respuesta

Cuadro de consulta para toda la unidad y para la evaluación del Encuentro 9.

Verbos:

| Verbo | Uso típico |
| --- | --- |
| GET | Pedir datos: listar todos u obtener uno por Id |
| POST | Crear un recurso nuevo (los datos viajan en el cuerpo) |
| PUT | Reemplazar o actualizar un recurso existente |
| DELETE | Borrar un recurso |

Códigos:

| Código | Nombre | Cuándo se usa |
| --- | --- | --- |
| 200 | Ok | Pedido atendido con contenido en la respuesta |
| 201 | Created | Recurso creado (POST exitoso) |
| 204 | No Content | Acción atendida sin contenido para devolver (DELETE exitoso) |
| 400 | Bad Request | Pedido inválido: se rechaza con mensaje (ej.: Id repetido) |
| 404 | NotFound | El recurso buscado no existe |

### Charla rápida: el recorrido de ventanillas

El alta completa de un paciente recorre todas las ventanillas del hospital: admisión, ficha, corrección de datos, alta o baja. Ninguna ventanilla sola es "el hospital": el recorrido completo sí. El mini-proyecto es ese recorrido: usa todos los contenidos de la unidad dentro de un único sistema.

## 4. Práctica guiada (90 min)

Hoy el código se arma juntos: los endpoints marcados con «siguiendo el patrón visto» se reconstruyen recordando la clase 7, con el docente guiando y el cuadro de referencia a la vista.

### Paso 1 — Crear el proyecto

```powershell
dotnet new web -n AdmisionApi
cd AdmisionApi
code .
```

### Paso 2 — Esqueleto de Program.cs

Abrir `Program.cs`, borrar todo su contenido y pegar este esqueleto (los endpoints a completar quedan marcados):

```csharp
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Modelo del mini-proyecto: un ingreso de admision.
// Mismo patron de la clase 7: record inmutable que se reemplaza con with.
record Ingreso(int Id, string Paciente, string Motivo);

// "Base de datos" en memoria, con dos ingresos iniciales.
var ingresos = new List<Ingreso>
{
    new(1, "Ana Torres", "Control de rutina"),
    new(2, "Luis Gomez", "Dolor abdominal")
};

// GET: listar todos los ingresos
app.MapGet("/ingresos", () => ingresos);

// GET: un ingreso por Id
// ...siguiendo el patron visto (FirstOrDefault + NotFound / Ok)
app.MapGet("/ingresos/{id:int}", (int id) =>
{
    // ...siguiendo el patron visto
});

// POST: alta de ingreso
// ...siguiendo el patron visto (Add + Created)
// (la validacion de Id repetido se pide en el ejercicio)
app.MapPost("/ingresos", (Ingreso nuevo) =>
{
    // ...siguiendo el patron visto
});

// DELETE: baja de un ingreso
// ...siguiendo el patron visto (FirstOrDefault + Remove + NoContent)
app.MapDelete("/ingresos/{id:int}", (int id) =>
{
    // ...siguiendo el patron visto
});

app.Run();
```

### Paso 3 — Completar juntos los tres endpoints

Primero el GET por Id, después el POST, después el DELETE. Guía común: cada uno arranca buscando el recurso; si no está, 404; si está, la acción del verbo; y el código final según el cuadro de referencia.

### Paso 4 — Levantar y verificar lo mínimo

```powershell
dotnet run
```

Probar en el navegador `GET /ingresos` (lista completa) y `GET /ingresos/1` (un ingreso). Anotar el puerto propio (en los ejemplos se usa `http://localhost:5080`).

### Paso 5 — Probar POST y DELETE con REST Client

Crear `requests.http` en la raíz del proyecto:

```http
### Alta de ingreso (esperar 201)
POST http://localhost:5080/ingresos
Content-Type: application/json

{
  "id": 3,
  "paciente": "Marta Diaz",
  "motivo": "Estudios de sangre"
}

### Baja del ingreso 2 (esperar 204)
DELETE http://localhost:5080/ingresos/2
```

### Salidas esperadas

- **GET /ingresos** → 200 con el arreglo de los dos ingresos iniciales (mismo formato JSON de la clase 7, con claves `id`, `paciente` y `motivo`).
- **POST** → 201 Created, con el ingreso creado en el cuerpo y encabezado `Location` apuntando a `/ingresos/3`. Después, `GET /ingresos` muestra tres ingresos.
- **DELETE /ingresos/2** → 204 No Content, sin cuerpo. Un DELETE repetido responde 404.

## 5. Ejercicio independiente (55 min)

### Consigna

Completar el mini-proyecto con dos agregados:

1. `PUT /ingresos/{id:int}`: reemplazo completo del ingreso siguiendo el patrón de la clase 7. Si no existe, 404 con mensaje; si existe, 200 con el reemplazo y el Id de la ruta.
2. Validación en el POST: si llega un Id que ya existe, rechazar con 400 Bad Request y un mensaje en JSON (`"Ya existe un ingreso con ese Id"`); si el Id está libre, crear con 201 como hasta ahora.

### Pista

Para el PUT: `FindIndex` + `with`, igual que en la clase 7. Para la validación: buscar antes de agregar y mirar el cuadro de referencia para elegir el código (no es 404: el pedido llegó bien, pero no se puede cumplir). La solución está en el anexo docente.

## 6. Cierre (20 min)

### Qué te llevás (cierre de la Unidad 1)

- Crear y correr una API: `dotnet new web`, `MapGet`, `app.Run` (Encuentro 4).
- Versionar el trabajo con git: `init`, `commit`, `remote`, `push` (Encuentro 5).
- Responder JSON y leer valores de la URL: rutas con parámetro y query string (Encuentro 6).
- Un CRUD completo en memoria con `List<T>`, `record`, `with` y códigos HTTP correctos (Encuentros 7 y 8).
- El cuadro de referencia rápida: material de consulta para la evaluación.

### Lo que viene

- Encuentro 9: evaluación de la Unidad 1 con el **tp-u1**.
- Qué es el tp-u1: trabajo práctico integrador sobre el proyecto `AdmisionApi`: completar y sostener el CRUD, explicar el código y justificar los códigos de respuesta.
- Cómo es la defensa: individual y oral, breve. Se muestran los endpoints funcionando, se explica una parte del código señalada por el docente y se responden preguntas con el propio proyecto a la vista.
- Qué llevar: el repositorio con el proyecto funcionando, git operativo (remoto configurado y push al día) y los commits de cada encuentro como historial de trabajo.

### Recordatorio de commit (rutina desde el Encuentro 5)

Con el mini-proyecto completo, al cierre del encuentro:

```powershell
git add .
git commit -m "Clase 8: mini-proyecto AdmisionApi (cierre U1)"
git push
```

## 7. Errores comunes y trampas (repaso de la unidad)

| Trampa | Causa | Cómo se resuelve |
| --- | --- | --- |
| Texto plano en lugar de JSON | El handler devuelve `string` cuando el cliente necesita estructura | Devolver un objeto (anónimo o `record`): la API lo convierte a JSON |
| Ruta sin restricción `:int` | `/ingresos/abc` entra a la ruta y la conversión a `int` falla | Declarar `{id:int}`: el texto en el Id responde 404 |
| Probar POST / PUT / DELETE desde el navegador | El navegador solo envía GET | `requests.http` con REST Client: verbo, cuerpo y `Content-Type: application/json` |
| Todo responde 200 | No se distingue resultado exitoso de recurso inexistente o pedido inválido | 201 al crear, 204 al borrar, 404 si no existe, 400 si el pedido no se puede cumplir |
| Esperar persistencia tras reiniciar | La `List<T>` vive en memoria | Aceptar el reinicio de los datos iniciales; la base real llega en la Unidad 2 |
| Trabajar sin commit | Avanzar sin versionar pierde el historial que la defensa exige | Commit al cierre de cada encuentro: es parte del trabajo, no un extra |
