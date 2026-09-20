# Encuentro 4 — Primer proyecto Minimal API

> Unidad 1 — Fundamentos de Minimal API con C#

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 4 de 36 |
| Unidad | 1 — Fundamentos de Minimal API con C# |
| Eje temático | 1 — Fundamentos de Minimal API |
| Carácter/Objetivo | Procedimental |
| Duración teórica | 240 minutos (4 horas reloj) |
| Concepto nuevo | Primer proyecto Minimal API: creación con `dotnet new web`, anatomía de `Program.cs`, ejecución con `dotnet run` y primer endpoint GET |
| Requisitos previos | Encuentros 2 y 3: terminal y carpetas, URL, ciclo de petición/respuesta y JSON básico. SDK de .NET 6 instalado y verificado |
| Uso de celular | No permitido |
| Organización del trabajo | Grupos: alumnos presentes ÷ equipos disponibles (mínimo posible); ningún equipo queda sin usar; rotación de integrantes en cada actividad |

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

Al finalizar el encuentro, cada estudiante puede:

1. Crear un proyecto Minimal API desde la terminal con `dotnet new web` y abrirlo en VS Code.
2. Reconocer las cuatro partes de `Program.cs`: preparar, construir, definir endpoints y ejecutar.
3. Ejecutar la API con `dotnet run`, consultarla desde el navegador y detenerla con `Ctrl+C`.
4. Agregar endpoints propios con `MapGet`, cambiando la ruta y el texto de respuesta.
5. Explicar, con sus palabras, qué hace la flecha `=>` en un endpoint.

## 3. Teoría mínima (40 min)

### Charla rápida: la API como la recepción del hotel

Imaginen la recepción de un hotel. Un huésped llega a la ventanilla y pide algo concreto: «¿A qué hora es el desayuno?». El recepcionista no lo manda a la cocina ni le muestra todo el edificio: escucha el pedido y contesta exactamente eso. Una API web funciona igual: el cliente (un navegador, por ahora) hace un **pedido** contra una **ruta** (la ventanilla) y la API devuelve una **respuesta** (lo que contesta la recepción). Nadie entra a la cocina: solo se habla por la ventanilla. Hoy van a construir esa recepción: chiquita, pero real y funcionando.

### Lo mínimo indispensable

- Una **API web** es un programa que recibe **pedidos** (requests) y devuelve **respuestas** (responses).
- Cada pedido apunta a una **ruta**: `/hola`, `/estado`. La ruta se escribe después del dominio: `http://localhost:5080/hola`.
- **Minimal API** es la forma más corta de crear una API con .NET 6: todo el programa vive en un único archivo, `Program.cs`. No hay carpetas `Models/` ni `Controllers/`: en este curso, una sola hoja.
- El ciclo completo es: pedido → la API busca la ruta → respuesta. Si nadie definió esa ruta, la API responde `404 - Not Found`: esa ventanilla no existe.
- Las cuatro partes de todo `Program.cs` de este curso: **preparar** (`CreateBuilder`), **construir** (`Build`), **definir endpoints** (`MapGet`) y **ejecutar** (`Run`).

## 4. Práctica guiada (70 min)

Todo el trabajo se hace en la PC del grupo, con la terminal y VS Code. Un integrante maneja la computadora y la consigna va rotando: cuando termina un paso, cambia la persona al teclado.

### Paso 1 — Crear el proyecto desde la terminal

Abrir la terminal en la carpeta del curso y ejecutar:

```powershell
dotnet new web -n HospitalApi
cd HospitalApi
```

`dotnet new web` crea la carpeta `HospitalApi` con el proyecto más chico de ASP.NET Core: dos archivos que importan. Salida esperada (resumida):

```text
The template "ASP.NET Core Empty" was created successfully.
Restore succeeded.
```

### Paso 2 — Abrir el proyecto en VS Code

```powershell
code .
```

Abrir `Program.cs`. La plantilla trae apenas estas líneas: son las cuatro partes anunciadas en la teoría.

```csharp
var builder = WebApplication.CreateBuilder(args);   // 1) prepara el programa
var app = builder.Build();                          // 2) construye la aplicacion

app.MapGet("/", () => "Hello World!");              // 3) define un endpoint

app.Run();                                          // 4) ejecuta y escucha pedidos
```

### Paso 3 — Escribir la primera API propia

Reemplazar **todo** el contenido de `Program.cs` por esto y guardar con `Ctrl+S`:

```csharp
// Program.cs - Encuentro 4: la primera Minimal API
// Una API web es un programa que recibe pedidos y devuelve respuestas.

// 1) Prepara el programa: lee la configuracion de arranque
var builder = WebApplication.CreateBuilder(args);

// 2) Construye la aplicacion con esa configuracion
var app = builder.Build();

// 3) Endpoints: cada MapGet dice "cuando pidan ESTA ruta, responde ESTO".
//    La flecha => es una expresion lambda: una funcion corta y sin nombre.
//    Por ahora alcanza con leerla asi: "cuando llegue un pedido a la ruta,
//    devuelve lo que esta a la derecha de la flecha". Vamos a volver sobre
//    esto mas adelante; por ahora no hay que saber nada mas.
app.MapGet("/hola", () => "Hola desde la primera Minimal API!");

// Segundo endpoint: el estado de la API, tambien como texto
app.MapGet("/estado", () => "La API esta funcionando");

// 4) Deja la API escuchando pedidos hasta que se corta con Ctrl+C
app.Run();
```

¿Y esa flecha `=>`? Se llama **expresión lambda**: una función escrita en una línea y sin nombre. En los endpoints de hoy significa «recibido el pedido, devolvé lo que sigue de la flecha». No hay que estudiarla hoy: basta con reconocerla cada vez que aparece.

### Paso 4 — Ejecutar la API

```powershell
dotnet run
```

Salida esperada (el puerto puede cambiar):

```text
Building...
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5080
```

La línea `Now listening on:` es la dirección de la ventanilla. **Ese es el puerto de esta ejecución**: si dice `5080` se usa `5080`; si dice otro número, se usa ese.

### Paso 5 — Probar en el navegador

Abrir en el navegador (el navegador solo envía GET, justo lo que necesitamos hoy):

```text
http://localhost:5080/hola
http://localhost:5080/estado
```

Salida esperada en el navegador, como texto plano:

```text
Hola desde la primera Minimal API!
```

```text
La API esta funcionando
```

Ahora probar una ruta que no existe, por ejemplo `http://localhost:5080/chau`: el navegador muestra su página de error `HTTP ERROR 404`. No es un error del programa: es la API contestando «esa ventanilla no existe».

### Paso 6 — Modificar y reiniciar

Cambiar el texto de `/hola` por otro mensaje, guardar con `Ctrl+S` y recargar el navegador **sin reiniciar la API**: sigue respondiendo lo viejo. La API ya cargó el programa en memoria; para que un cambio valga hay que pararla con `Ctrl+C` y volver a ejecutar `dotnet run`. Recién entonces el navegador muestra el texto nuevo. Esta rutina — guardar, cortar, correr — se usa en todos los encuentros del curso.

### Paso 7 — Detener la API

Volver a la terminal y presionar `Ctrl+C`. El proceso termina y la terminal vuelve a aceptar comandos.

## 5. Ejercicio independiente (50 min)

**Consigna.** Cada grupo agrega a `Program.cs` tres endpoints propios, todos con `MapGet` y respuesta de texto:

1. `/equipo`: los nombres de los integrantes del grupo, separados por coma.
2. `/escuela`: el nombre de la escuela y la especialidad que cursan.
3. `/frase`: una frase elegida por el grupo (puede ser del aula, de una canción o de un libro).

Después de escribirlos: guardar, reiniciar con `Ctrl+C` + `dotnet run`, y probar los tres en el navegador. Al terminar, cada integrante explica un endpoint propio: qué ruta responde y qué devuelve.

**Pista.** Copiar el patrón de `/estado` y cambiar dos cosas: el texto entre paréntesis de la ruta y el string que va a la derecha de la flecha `=>`. Un endpoint por línea `MapGet`. Si algo no responde, revisar dos sospechosos de siempre: ¿guardaste con `Ctrl+S`? ¿reiniciaste con `Ctrl+C` + `dotnet run`?

## 6. Extensión y consolidación (45 min)

Actividades para los grupos que terminan la consigna base. La rotación de integrantes sigue: cada ítem lo escribe una persona distinta.

1. **Endpoint `/version`** que devuelva un texto con la versión de la API del grupo (por ejemplo `v1.0 - clase 4`).
2. **Recorrida de 404:** probar tres rutas inexistentes y anotar qué responde el navegador. Conclusión esperada: el 404 es la API viva diciendo que la ruta no está definida.
3. **Experimento de memoria:** parar la API con `Ctrl+C` y volver a correr `dotnet run`. Comprobar que los endpoints siguen respondiendo igual: lo que persiste es el código en `Program.cs`, no lo que estaba corriendo.
4. **Lectura en voz alta:** un integrante lee el `Program.cs` del grupo de arriba hacia abajo y otro va nombrando las cuatro partes (preparar, construir, endpoints, ejecutar). Corregir el orden si algo quedó fuera de lugar.

## 7. Cierre (15 min)

### Qué te llevás

- `dotnet new web` crea el proyecto mínimo; `dotnet run` lo levanta; `Ctrl+C` lo detiene.
- Todo el programa vive en `Program.cs`, con sus cuatro partes: preparar, construir, definir endpoints, ejecutar.
- Un endpoint `MapGet` es una ventanilla: ruta a la izquierda, respuesta a la derecha de la flecha `=>` (expresión lambda: función corta y sin nombre).
- Tras editar el archivo: `Ctrl+S` para guardar y `Ctrl+C` + `dotnet run` para que el cambio valga.
- Una ruta sin definir responde `404`: no es un programa roto, es la API contestando que no conoce esa ventanilla.

### Lo que viene

En el Encuentro 5 las rutas aprenden a recibir datos: parámetros de ruta como `{nombre}` y `{id:long}`, respuestas en JSON automático con objetos anónimos, y el primer bloque de git local: `git init`, `.gitignore`, `git add`, `git commit` y la rutina de un commit de cierre por clase.

## 8. Errores comunes y trampas

1. **`dotnet new web` corrido en la carpeta equivocada.** Causa: lanzar el comando dentro de otro proyecto (quedan proyectos anidados). Fix: mirar siempre la carpeta actual con `pwd` (o `cd` sin argumentos) antes de crear, y crear solo en la carpeta del curso.
2. **Editar sin guardar, o guardar sin reiniciar.** Causa: la API ya cargó el programa en memoria; `Ctrl+S` escribe el archivo pero no reemplaza el proceso. Fix: `Ctrl+S` y después `Ctrl+C` + `dotnet run`, siempre.
3. **El puerto del compañero no funciona en mi PC.** Causa: cada ejecución puede elegir otro puerto. Fix: usar el que muestra TU línea `Now listening on:`.
4. **Ruta mal escrita en el navegador** (`/Holaa`, `/hola ` con espacio). Causa: las rutas distinguen el texto exacto. Fix: copiar la ruta tal como está en el `MapGet`.
5. **Cerrar la ventana de la terminal creyendo que eso detiene la API.** Causa: el proceso puede quedar vivo. Fix: detener con `Ctrl+C` antes de cerrar; si el puerto quedó ocupado, volver a correr y usar el puerto nuevo que informe.
6. **Buscar la API «dentro» de VS Code.** Causa: confundir el editor con el servidor. Fix: la API corre en la terminal (`dotnet run`); el navegador y VS Code solo la consultan o la editan.
