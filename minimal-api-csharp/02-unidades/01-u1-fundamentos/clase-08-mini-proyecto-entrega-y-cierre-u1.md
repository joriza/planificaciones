# Encuentro 8 — Mini proyecto (TP-u1), entrega y cierre de la Unidad 1

> Unidad 1 — Fundamentos de Minimal API con C# · Encuentro de cierre de unidad

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 8 de 36 |
| Unidad | 1 — Fundamentos de Minimal API con C# (cierre de unidad) |
| Eje temático | 5 — Terminal, Git y GitHub (con el eje 1 como contenido técnico) |
| Carácter/Objetivo | Procedimental |
| Duración teórica | 240 minutos (4 horas reloj) |
| Concepto nuevo | Ciclo completo de entrega, que se enseña una sola vez en el curso: repo remoto en GitHub (web), `git remote add origin`, `git push -u origin main`, con la carpeta `tp-u1/` en la raíz del repositorio del grupo. El TP-u1 se desarrolla en clase |
| Requisitos previos | Toda la Unidad 1 (encuentros 4 a 7): proyecto, rutas con parámetros, CRUD en memoria con `Results`, validación 400/404 y repositorio local con la rutina de commits al día |
| Uso de celular | No permitido (la creación del repo en GitHub se hace desde el navegador de la PC del grupo) |
| Organización del trabajo | El TP se hace por grupos: alumnos presentes ÷ equipos disponibles (mínimo posible); ningún equipo queda sin usar; rotación de integrantes por endpoint |

### Reparto de tiempos teóricos (plantilla de cierre de unidad)

| Momento | Tiempo teórico |
| --- | --- |
| Apertura | 15 min |
| Consolidación | 75 min |
| Trabajo del TP | 90 min |
| Ciclo de entrega | 45 min |
| Cierre | 15 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

Al finalizar el encuentro, cada estudiante puede:

1. Desarrollar en clase una mini API en memoria con temática elegida por el grupo: CRUD completo, validación y códigos correctos, todo en `Program.cs`.
2. Completar por primera vez el ciclo de entrega: crear el repo remoto en GitHub desde el navegador, conectarlo con `git remote add origin` y publicar con `git push -u origin main`.
3. Estructurar el repositorio del grupo según el estándar del año: `.gitignore` en la raíz y una carpeta por trabajo, empezando por `tp-u1/`.
4. Verificar la propia entrega contra el checklist antes de declararla terminada.
5. Reconstruir el mapa completo de la Unidad 1: qué sabía el grupo en el encuentro 4 y qué puede hacer hoy.

## 3. Apertura y puente (15 min)

### Charla rápida: la primera entrega real

Toda la unidad fue el entrenamiento: primero la ventanilla, después las rutas que preguntan, después el cuaderno con sus cuatro verbos, y ayer el ensayo general. Hoy se juega el partido: cada grupo construye **su propia** API con la temática que elija y la entrega a un repositorio remoto de GitHub, igual que se entregará el tp-u2, el tp-u3 y el trabajo final. El ciclo de entrega de hoy se usa una sola vez como clase; después, cada entrega es repetirlo con otra carpeta.

## 4. Consolidación (75 min)

Antes de escribir el TP, el esqueleto completo se repasa y el trabajo se diseña. Rotación de integrantes en cada bloque.

### Bloque A — Repaso guiado de la mini API de pacientes (25 min)

Con la guía del docente, el grupo re-corre la batería de pruebas del encuentro 7 sobre `PatientsApi`: la tabla completa, código por código. El docente proyecta la resolución de los errores típicos (record antes de `app.Run()`, lista adentro de un handler, POST sin `Content-Type`). Objetivo: que nadie llegue al TP con una duda del esqueleto.

### Bloque B — Checklist de defectos frecuentes (20 min)

Cada grupo revisa su propio `Program.cs` del día contra esta lista, marcando cada fila:

| ✔ | Defecto | Corrección |
| --- | --- | --- |
| ☐ | Id declarado `int` | En este curso los ids SIEMPRE son `long` |
| ☐ | Fecha declarada con otro tipo o formato | Fechas SIEMPRE `string` en ISO `yyyy-MM-dd` |
| ☐ | Endpoint en español (`/pacientes`) | Rutas en inglés y plural: `/patients` |
| ☐ | Código sin comentarios | Comentar cada acción: la defensa individual lo exige |
| ☐ | Record declarado antes de `app.Run()` | Records siempre al final del archivo (CS8803) |
| ☐ | 400 o 404 sin cuerpo con mensaje | `new { mensaje = "..." }` siempre, en español |
| ☐ | Lista declarada dentro de un handler | La lista vive una vez, arriba, compartida |

### Bloque C — Diseño del TP (30 min)

Cada grupo completa la ficha de diseño en el cuaderno **antes** de tocar el teclado:

1. **Temática elegida** (ver consigna) y nombre del recurso en inglés, en plural.
2. **Record de la entidad:** id `long` + tres o cuatro campos (uno puede ser fecha string ISO).
3. **Las cinco rutas:** GET todos, GET uno, POST, PUT, DELETE.
4. **Los mensajes 400** del grupo, escritos en español y sin tildes.
5. **La batería de pruebas prevista:** al menos ocho filas con el código esperado de cada una.

El docente aprueba cada ficha antes de habilitar el teclado. Un diseño revisado ahorra media hora de código perdido.

## 5. Trabajo del TP-u1 (90 min)

### Consigna: Trabajo práctico tp-u1 — Mini API en memoria

Cada grupo desarrolla una **mini API en memoria** con la temática que elija. Ideas de temática: películas, series, videojuegos, libros, discos, recetas, jugadores de un deporte, cursos de la escuela. Lo que importa es que el grupo pueda llenar la lista con datos propios y explicarla en la defensa.

**Requisitos obligatorios:**

1. Proyecto Minimal API en .NET 6 creado con `dotnet new web`. **Todo el código en `Program.cs`**, records al final del archivo.
2. Entidad con id `long` + tres o cuatro campos; si hay fecha, `string` en ISO `yyyy-MM-dd`.
3. Rutas en inglés y en plural, con el filtro `{id:long}` donde va el id.
4. CRUD completo: GET todos, GET uno, POST, PUT uno, DELETE uno.
5. Record de entrada (DTO) para POST y PUT, sin id: el id lo asigna la API con un contador.
6. Validación: campos vacíos → 400 con mensaje en español; id inexistente → 404 con mensaje.
7. Códigos correctos en todos los casos: 200, 201 con `Location`, 204, 400, 404 (siempre con `Results`).
8. Comentarios abundantes en el código, sin tildes.
9. Batería de pruebas ejecutada y anotada: navegador para los GET, `curl.exe` para el resto.
10. Commits de avance con mensajes `tp-u1: resumen de lo hecho`.

**Paso 1 — Crear la carpeta del repositorio del grupo y el proyecto dentro:**

```powershell
cd ..\
mkdir repo-grupo
cd repo-grupo
dotnet new web -o tp-u1
cd tp-u1
code ..
```

`dotnet new web -o tp-u1` crea la carpeta `tp-u1` con el proyecto adentro. La carpeta `repo-grupo` es la **raíz del repositorio del grupo**: el estándar del año es un solo repo, con una carpeta por trabajo (`tp-u1`, más adelante `tp-u2`, `tp-u3` y `trabajo-final`). Los proyectos de práctica de los encuentros anteriores quedan como están: fueron entrenamiento, la entrega vive acá.

**Paso 2 — Escribir la API** siguiendo la ficha de diseño aprobada. Esqueleto de referencia (los comentarios marcan lo que cada grupo completa):

```csharp
// Program.cs - TP-u1: mini API en memoria del grupo N
// Tematica elegida: <nombre del recurso, en ingles y plural>

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Lista compartida: los datos propios del grupo (5 o 6 elementos iniciales)
var movies = new List<Movie>
{
    new Movie(1, "El halo", "SciFi", "2019-04-11"),
    new Movie(2, "Ruta 40", "Accion", "2021-09-03")
};

// Contador de ids: arranca despues del ultimo id de la lista
long nextMovieId = 3;

// GET /movies: toda la lista -> 200
app.MapGet("/movies", () =>
{
    return Results.Ok(movies);
});

// GET /movies/{id:long}: uno o 404
app.MapGet("/movies/{id:long}", (long id) =>
{
    var movie = movies.Find(m => m.MovieId == id);

    return movie is null
        ? Results.NotFound(new { mensaje = "No existe la movie" })
        : Results.Ok(movie);
});

// POST /movies: alta con validacion -> 400 o 201
app.MapPost("/movies", (MovieInput input) =>
{
    if (string.IsNullOrWhiteSpace(input.Title) ||
        string.IsNullOrWhiteSpace(input.Genre))
    {
        return Results.BadRequest(new { mensaje = "Faltan datos de la movie" });
    }

    if (string.IsNullOrWhiteSpace(input.ReleaseDate))
    {
        return Results.BadRequest(new { mensaje = "Falta la fecha de estreno" });
    }

    var movie = new Movie(nextMovieId, input.Title, input.Genre, input.ReleaseDate);
    nextMovieId++;

    movies.Add(movie);

    return Results.Created($"/movies/{movie.MovieId}", movie);
});

// PUT /movies/{id:long}: reemplazo con chequeos 404 -> 400 -> proceso -> 200
app.MapPut("/movies/{id:long}", (long id, MovieInput input) =>
{
    var movie = movies.Find(m => m.MovieId == id);

    if (movie is null)
    {
        return Results.NotFound(new { mensaje = "No existe la movie" });
    }

    if (string.IsNullOrWhiteSpace(input.Title) ||
        string.IsNullOrWhiteSpace(input.Genre))
    {
        return Results.BadRequest(new { mensaje = "Faltan datos de la movie" });
    }

    if (string.IsNullOrWhiteSpace(input.ReleaseDate))
    {
        return Results.BadRequest(new { mensaje = "Falta la fecha de estreno" });
    }

    var updated = new Movie(movie.MovieId, input.Title, input.Genre, input.ReleaseDate);
    movies[movies.IndexOf(movie)] = updated;

    return Results.Ok(updated);
});

// DELETE /movies/{id:long}: baja -> 404 o 204
app.MapDelete("/movies/{id:long}", (long id) =>
{
    var movie = movies.Find(m => m.MovieId == id);

    if (movie is null)
    {
        return Results.NotFound(new { mensaje = "No existe la movie" });
    }

    movies.Remove(movie);

    return Results.NoContent();
});

app.Run();   // Deja la API escuchando pedidos

// ---- Records: SIEMPRE al final del archivo ----
record Movie(long MovieId, string Title, string Genre, string ReleaseDate);
record MovieInput(string Title, string Genre, string ReleaseDate);
```

El código de ejemplo usa movies como temática ilustrativa: **cada grupo escribe el suyo** con su recurso, sus campos y sus mensajes. Copiar el ejemplo con la temática movies no es entrega propia.

**Paso 3 — Probar la batería completa** (navegador + `curl.exe`) y anotar los códigos observados. La API está terminada cuando la tabla pasó entera.

### Si el TP queda terminado antes de tiempo (actividades de extensión)

Para los grupos que completaron los requisitos obligatorios y pasaron la batería completa. Cada ítem se commitea por separado con la rutina del curso:

1. **`GET <recurso>/count`:** la cantidad de elementos de la lista como JSON (`{"total":...}`).
2. **`GET <recurso>/by-<campo>/{valor}:** filtro por un campo de texto del recurso, comparando en minúsculas los dos lados (`FindAll` + `ToLower`).
3. **Validación de fecha reforzada:** si el campo fecha no se interpreta como fecha (`DateTime.TryParse`), responder 400 con mensaje propio. La fecha sigue viajando como string ISO.
4. **Revisión cruzada:** intercambiar repos con el grupo vecino y revisar su entrega con el checklist del ciclo completo (estructura, `.gitignore`, códigos, mensajes de commit). Cada hallazgo se comunica como sugerencia, no se corrige ajeno.

## 6. Ciclo completo de entrega (45 min)

El ciclo que hoy se aprende es **el mismo para todas las entregas del año**: cambia el nombre de la carpeta, no el ciclo. Un integrante maneja la terminal del grupo; el resto sigue la salida paso a paso.

### Paso 1 — Crear el repositorio remoto en GitHub (navegador, una vez por grupo)

1. En el navegador de la PC del grupo, entrar a `github.com` e iniciar sesión con la cuenta del grupo.
2. Botón **New repository** (el símbolo `+` arriba a la derecha).
3. Repository name: `minimal-api-grupo-1` (ajustar el número de grupo). Visibilidad: **Public**.
4. **No** marcar «Add a README», **no** agregar `.gitignore` ni licencia: el repo se crea **vacío**, para que el primer push no choque con nada.
5. **Create repository**. GitHub muestra una página con la URL del repo: copiar la dirección `https://github.com/<usuario>/minimal-api-grupo-1.git`.

### Paso 2 — Preparar el repositorio local (raíz del repo del grupo)

Volver a la terminal, **en la carpeta `repo-grupo`** (la raíz, un nivel arriba de `tp-u1`):

```powershell
cd ..
```

Crear el `.gitignore` en la **raíz** del repositorio, junto a la carpeta `tp-u1`, con este contenido:

```text
bin/
obj/
```

```powershell
git init
```

Salida esperada:

```text
Initialized empty Git repository in D:/cursos/repo-grupo/.git/
```

```powershell
git status
```

Tiene que listar la carpeta `tp-u1/` (y **no** tiene que aparecer ningún `bin/` ni `obj/`; si aparecen, el `.gitignore` quedó en otra carpeta).

### Paso 3 — Primer commit del repositorio del grupo

```powershell
git add .
git commit -m "tp-u1: primera version del trabajo practico"
```

Salida esperada (resumida):

```text
[main (root-commit) 8c1d4e2] tp-u1: primera version del trabajo practico
 5 files changed, ...
```

### Paso 4 — Conectar el remoto y publicar

```powershell
git branch -M main
git remote add origin https://github.com/<usuario>/minimal-api-grupo-1.git
git push -u origin main
```

`git branch -M main` garantiza que la rama local se llame `main` (el estándar del curso es mono-rama main). `git remote add origin ...` conecta el repo local con el remoto: **se hace una sola vez por repositorio**. La primera vez que el grupo hace `push`, GitHub abre una ventana de inicio de sesión en el navegador: autorizar y volver a la terminal.

Salida esperada:

```text
Enumerating objects: 9, done.
...
To https://github.com/<usuario>/minimal-api-grupo-1.git
 * [new branch]      main -> main
branch 'main' set up to track 'origin/main'.
```

### Paso 5 — Verificar la entrega

Abrir `https://github.com/<usuario>/minimal-api-grupo-1` en el navegador y verificar: la carpeta `tp-u1/` está en la raíz, `Program.cs` está adentro, el `.gitignore` está en la raíz, `bin/` y `obj/` **no** aparecen, y la pestaña Commits muestra el mensaje `tp-u1: primera version del trabajo practico`.

### Checklist de entrega del tp-u1

| ✔ | Ítem |
| --- | --- |
| ☐ | La carpeta `tp-u1/` está en la raíz del repositorio del grupo, con el proyecto adentro |
| ☐ | El proyecto compila y corre con `dotnet run` desde `tp-u1/` |
| ☐ | CRUD completo probado: GET todos, GET uno, POST, PUT, DELETE, con códigos anotados |
| ☐ | Campos vacíos devuelven 400 con mensaje en español; id inexistente, 404 con mensaje |
| ☐ | `.gitignore` en la raíz con `bin/` y `obj/`, y ninguno de los dos visible en GitHub |
| ☐ | Al menos un commit con mensaje `tp-u1: ...` |
| ☐ | `git push` hecho y la entrega visible en `github.com` |
| ☐ | Cada integrante puede explicar al menos un endpoint del TP |

## 7. Cierre (15 min)

### Qué te llevás

- La Unidad 1 completa: crear y correr una Minimal API, rutas con parámetros, JSON automático, CRUD en memoria con `Results`, validación 400/404 y git local con rutina de commits.
- El ciclo completo de entrega, que sirve para todo el año: repo remoto en GitHub (creado una vez), `.gitignore` en la raíz, `git init` + `git add` + `git commit`, `git remote add origin`, `git push -u origin main`, y la verificación en el navegador.
- El estándar del repositorio del grupo: un solo repo, una carpeta por trabajo, empezando por `tp-u1/`; commits con mensaje `<trabajo>: resumen`.
- La batería de pruebas como criterio de terminación: una API está lista cuando su tabla pasó completa.

### Lo que viene

En el Encuentro 9 se evalúa la Unidad 1: el docente verifica la entrega del tp-u1 por GitHub, cada integrante defiende individualmente una parte de la mini API del grupo, y cada estudiante resuelve una prueba práctica individual en versiones A y B equivalentes. La devolución de los resultados llega al inicio del Encuentro 10, donde arranca la Unidad 2 con `hospital.db` y Dapper.

## 8. Errores comunes y trampas

1. **Repo remoto creado con README inicial.** Causa: marcar «Add a README» por las dudas. Fix: el repo se crea vacío; si ya se creó con README, avisar al docente antes de intentar ningún push.
2. **Ejecutar los comandos de git dentro de `tp-u1`.** Causa: quedarse en la carpeta del proyecto. Fix: todo el ciclo de entrega corre en la **raíz** `repo-grupo`; `git status` lo delata: si lista `Program.cs` suelto, estás adentro; si lista `tp-u1/`, estás en la raíz.
3. **`git remote add origin` repetido.** Causa: reintentar el paso sin leer el error. Fix: `remote origin already exists` significa que ya está conectado; revisar la URL con `git remote -v` y, si estaba mal, corregirla con `git remote set-url origin <url>`.
4. **Commit sin push.** Causa: cerrar la clase después del `git commit`. Fix: el commit vive solo en la PC del grupo; la entrega existe cuando el push terminó y se vio en GitHub. Rutina: push al cierre de cada bloque de trabajo.
5. **URL del remoto mal escrita.** Causa: tipearla en lugar de copiarla de la página de GitHub. Fix: `git push` falla con `repository not found`; copiar la URL exacta (termina en `.git`) y corregir con `git remote set-url origin <url>`.
6. **Ventana de login de GitHub cerrada o vencida.** Causa: primera autenticación interrumpida. Fix: repetir `git push`; la ventana del navegador (Git Credential Manager) vuelve a abrirse y, una vez autorizada, no vuelve a pedir en esa PC.
7. **`.gitignore` creado adentro de `tp-u1`.** Causa: guardarlo donde estaba abierta la terminal. Fix: el `.gitignore` va en la **raíz** del repositorio, junto a la carpeta `tp-u1/`; `git status` es la verificación: `bin/` y `obj/` no tienen que aparecer.
