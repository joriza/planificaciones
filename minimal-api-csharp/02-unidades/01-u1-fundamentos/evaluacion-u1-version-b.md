# Evaluación de la Unidad 1 — Versión B

> Dominio de esta versión: biblioteca — libros. Mini API **en memoria**, sin base de datos. Duración: 90 minutos. Puntaje total: 100 puntos. Resolución individual, con computadora, sin celular. Las condiciones completas están en `evaluacion-u1.md`.

## Antes de empezar

- Creás el proyecto con `dotnet new web` y reemplazás **todo** el contenido de `Program.cs` por el esqueleto de abajo: trae la lista base, el contador de ids y los records, y **no se modifican**. Solo agregás los endpoints pedidos, en los lugares marcados.
- Todo el código en `Program.cs`; records siempre al final del archivo.
- Convenciones del curso: rutas en inglés y plural, ids `long`, fechas `string` ISO (`yyyy-MM-dd`), respuestas siempre con `Results`, comentarios en el código.
- Los mensajes de 400 y 404 van dentro de `new { mensaje = "..." }`, en español. Esta prueba propone los de cada consigna; un mensaje equivalente que nombre el dato que falta también puntúa.
- Al terminar, dejás el `Program.cs` guardado en la carpeta indicada y avisás al docente.

Tiempo sugerido: Parte 1, 25 min · Parte 2, 30 min · Parte 3, 20 min · Parte 4, 10 min · revisión final, 5 min.

## Material provisto — Esqueleto de `Program.cs`

```csharp
// Program.cs - Evaluacion de la Unidad 1 - Version B
// Mini API de libros de una biblioteca en memoria (sin base de datos)

// 1) Prepara el programa
var builder = WebApplication.CreateBuilder(args);

// 2) Construye la aplicacion
var app = builder.Build();

// Lista compartida: datos iniciales provistos, NO se modifican
var books = new List<Book>
{
    new Book(1, "El principito", "Antoine de Saint-Exupery", "1943-04-06"),
    new Book(2, "Martin Fierro", "Jose Hernandez", "1872-11-30"),
    new Book(3, "Rayuela", "Julio Cortazar", "1963-06-28")
};

// Contador de ids: arranca despues del ultimo id de la lista
long nextBookId = 4;

// ===== Parte 1: completar a partir de aqui =====
// b) GET /books -> 200 con la lista completa (7 puntos)
// c) GET /books/{id:long} -> 200 con el libro o 404 con mensaje (9 + 10 puntos)

// ===== Parte 2: completar a partir de aqui =====
// POST /books -> valida y responde 400 o 201 (30 puntos)

// ===== Parte 3: completar a partir de aqui =====
// DELETE /books/{id:long} -> 404 o 204 (25 puntos)

app.Run();   // Deja la API escuchando pedidos

// ---- Records: provistos, SIEMPRE al final del archivo ----
record Book(long BookId, string Title, string Author, string PublishedDate);
record BookInput(string Title, string Author, string PublishedDate);
```

## Parte 1 — Consulta de libros (30 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| a | Crear el proyecto con `dotnet new web`, pegar el esqueleto y correr la API con `dotnet run` | 4 |
| b | Endpoint `GET /books`: responde `200` con la lista completa de libros | 7 |
| c | Endpoint `GET /books/{id:long}` con parámetro de ruta tipado `long id`: responde `200` con el libro cuyo id llega por la ruta | 9 |
| d | En ese mismo endpoint, si el id no existe: `404` con `{"mensaje":"No existe el libro"}` | 10 |

## Parte 2 — Alta con validación (30 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| a | Endpoint `POST /books` que lee el cuerpo con el record de entrada `BookInput` (sin id: el id lo asigna la API) | 5 |
| b | Validación en orden, con `string.IsNullOrWhiteSpace`: falta `Title` → `400` `{"mensaje":"Falta el titulo del libro"}`; falta `Author` → `400` `{"mensaje":"Falta el autor"}`; falta `PublishedDate` → `400` `{"mensaje":"Falta la fecha de publicacion"}` | 10 |
| c | Alta correcta: el libro nuevo sale con el id del contador (`nextBookId`, que después suma 1), se agrega a la lista y responde `201` con la URL del recurso nuevo (`Results.Created`) | 12 |
| d | Verificación: el `GET /books/4` del libro recién creado responde `200` | 3 |

## Parte 3 — Baja (25 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| a | Endpoint `DELETE /books/{id:long}` con parámetro de ruta tipado `long id` | 5 |
| b | Si el id no existe: `404` con `{"mensaje":"No existe el libro"}` | 8 |
| c | Si existe: quita el libro de la lista y responde `204` sin cuerpo (`Results.NoContent`) | 7 |
| d | Verificación: después del borrado, el `GET` de ese mismo id responde `404` (el libro ya no está) | 5 |

## Parte 4 — Ítems conceptuales (15 puntos)

Responder por escrito, con tus palabras.

### C1. Verbos y códigos de respuesta (8 puntos)

Para cada situación, indicar el verbo HTTP y el código de estado que corresponde:

| Situación | Verbo | Código |
| --- | --- | --- |
| El navegador pide el detalle de un libro y ese id no existe | | |
| Se da de alta un libro con todos los campos válidos | | |
| Llega un `POST` de libro sin título y la API lo rechaza | | |
| Se borra un libro existente | | |

### C2. Mensaje de commit referente (7 puntos)

a) Escribí un mensaje de commit referente para esta prueba, siguiendo la convención del curso (3 puntos).

b) Ordená los comandos de una entrega ya conectada al remoto: `git push`, `git add .`, `git commit -m "..."` (2 puntos).

c) ¿Qué carpetas ignora el `.gitignore` del curso y por qué? (2 puntos)

## Batería de verificación: salida esperada de cada prueba

Con la API corriendo (`dotnet run`): el navegador solo envía GET; el resto, con `curl.exe` en otra terminal. Los ejemplos usan el puerto `5080`: reemplazá por el de tu línea `Now listening on:`.

| Prueba | Pedido | Salida esperada |
| --- | --- | --- |
| 1 | Navegador: `http://localhost:5080/books` | `200` con el array de los tres libros |
| 2 | Navegador: `http://localhost:5080/books/2` | `200` con `{"bookId":2,"title":"Martin Fierro","author":"Jose Hernandez","publishedDate":"1872-11-30"}` |
| 3 | Navegador: `http://localhost:5080/books/99` | `404` con `{"mensaje":"No existe el libro"}` |
| 4 | `POST /books` con los tres campos completos | `201` con `Location: /books/4` y el libro creado |
| 5 | `POST /books` sin `title` | `400` con `{"mensaje":"Falta el titulo del libro"}` |
| 6 | `POST /books` sin `author` | `400` con `{"mensaje":"Falta el autor"}` |
| 7 | `POST /books` sin `publishedDate` | `400` con `{"mensaje":"Falta la fecha de publicacion"}` |
| 8 | `DELETE /books/3` | `204` sin cuerpo |
| 9 | `DELETE /books/3` de nuevo | `404` con `{"mensaje":"No existe el libro"}` (ya no existe) |
| 10 | Navegador: `http://localhost:5080/books/3` después del borrado | `404` con el mismo mensaje |

Comandos `curl` de ejemplo (una línea cada uno; las variantes de las pruebas 6, 7 y 9 se obtienen cambiando el JSON o el id):

```powershell
curl.exe -i -X POST http://localhost:5080/books -H "Content-Type: application/json" -d "{\"title\":\"El aleph\",\"author\":\"Jorge Luis Borges\",\"publishedDate\":\"1949-06-11\"}"
curl.exe -i -X POST http://localhost:5080/books -H "Content-Type: application/json" -d "{\"title\":\"\",\"author\":\"Jorge Luis Borges\",\"publishedDate\":\"1949-06-11\"}"
curl.exe -i -X DELETE http://localhost:5080/books/3
```

## Al terminar

- Haber ejecutado la batería completa y observado cada código.
- Dejar el `Program.cs` guardado en la carpeta indicada y avisar al docente.
