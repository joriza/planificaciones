# Encuentro 4 — Primer proyecto Minimal API

> Unidad 1 — Fundamentos de C#, Git/GitHub y Minimal API

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 4 |
| Unidad | 1 — Fundamentos de C#, Git/GitHub y Minimal API |
| Duración teórica | 4 horas reloj (240 minutos) |
| Concepto nuevo | Primer proyecto Minimal API y su ejecución |
| Requisitos previos | Terminal básica (vista en encuentros 2 y 3), VS Code, SDK .NET 6 instalado |
| Uso de celular | No permitido |
| Planificación anual | Encuentro 4: «Primer proyecto Minimal API» |

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

Al finalizar el encuentro, cada estudiante puede:

1. Crear un proyecto Minimal API desde la terminal con `dotnet new web`.
2. Reconocer las cuatro partes mínimas de `Program.cs`: preparar, construir, definir rutas y ejecutar.
3. Ejecutar la API con `dotnet run` y consultarla desde el navegador.
4. Agregar un endpoint propio con `MapGet`, cambiando ruta y texto de respuesta.
5. Detectar y corregir errores típicos: carpeta equivocada, ruta mal escrita, archivo sin guardar.

## 3. Teoría mínima (45 min)

### Charla rápida: la API como la recepción del hospital

Imaginen la recepción de un hospital. Una persona llega a la ventanilla y pide algo concreto: "¿Dónde queda Farmacia?". La recepción escucha el pedido y contesta exactamente eso, ni más ni menos. Una API web funciona igual: el cliente (un navegador, otra aplicación) hace un **pedido** en una **ruta** (la ventanilla) y la API devuelve una **respuesta** (lo que la recepción contesta). Hoy construimos esa recepción: pequeña, pero real y funcionando.

### Lo mínimo indispensable

- Una **API web** es un programa que recibe **pedidos** (requests) y devuelve **respuestas** (responses).
- Cada pedido apunta a una **ruta**: `/hola`, `/estado`. La ruta se escribe después del dominio: `http://localhost:5137/hola`.
- **Minimal API** es la forma más corta de crear una API con .NET 6: todo el programa vive en un único archivo, `Program.cs`.
- El ciclo completo es: pedido → la API busca la ruta → responde. Si nadie definió esa ruta, responde `404 - Not Found`: esa ventanilla no existe.

## 4. Práctica guiada (90 min)

### Paso 1 — Crear el proyecto desde la terminal

Abrir la terminal y ejecutar:

```powershell
dotnet new web -n HospitalApi
cd HospitalApi
```

`dotnet new web` crea la carpeta `HospitalApi` con el proyecto más pequeño de ASP.NET Core. Salida esperada (resumida):

```text
The template "ASP.NET Core Empty" was created successfully.
...
Restore succeeded.
```

### Paso 2 — Abrir el proyecto en VS Code

```powershell
code .
```

Abrir el archivo `Program.cs`: contiene apenas unas líneas y es el punto de entrada del programa.

### Paso 3 — Reemplazar el contenido de Program.cs

Borrar todo el contenido y dejar solo esto. Guardar con `Ctrl+S`:

```csharp
// Program.cs — la primera Minimal API
// Una Minimal API es un programa que espera pedidos (requests) y responde (responses).

var builder = WebApplication.CreateBuilder(args); // prepara el programa
var app = builder.Build();                        // crea la API

// MapGet: "cuando alguien pida la ruta /hola, responde este texto".
// Los paréntesis vacíos () indican que esta respuesta no necesita datos de entrada.
// La flecha => significa "devuelve lo que está a la derecha": una función muy corta.
app.MapGet("/hola", () => "¡Hola desde la API del hospital!");

app.Run(); // deja la API escuchando pedidos (Ctrl+C la detiene)
```

¿Y esa flecha `=>`? Se llama **expresión lambda**: una función escrita en una sola línea y sin nombre. Por ahora alcanza con leerla como "cuando llegue un pedido a esta ruta, devuelve lo que sigue de la flecha". Volveremos sobre esto más adelante en la unidad.

### Paso 4 — Ejecutar la API

```powershell
dotnet run
```

Salida esperada en la terminal:

```text
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5137
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
```

El número de puerto puede variar en cada máquina: usar siempre la URL exacta que muestre la consola. Mientras la API está corriendo, la terminal queda ocupada por ella; se detiene con `Ctrl+C`.

### Paso 5 — Consultar la API desde el navegador

Abrir en el navegador la URL que muestra la consola y agregar la ruta `/hola`:

```text
http://localhost:5137/hola   (usar el puerto de cada máquina)
```

Salida esperada en el navegador:

```text
¡Hola desde la API del hospital!
```

## 5. Ejercicio independiente (55 min)

**Consigna.** Agregar a la API un segundo endpoint: la ruta `/bienvenida`, que responda un texto distinto al de `/hola`. Probar en el navegador que ambos endpoints funcionan.

**Pista.** Copiar la línea de `MapGet` que ya funciona y cambiar dos cosas: la ruta (`"/bienvenida"`) y el texto de respuesta. Recordar guardar el archivo y detener la API con `Ctrl+C` antes de volver a ejecutar `dotnet run`.

## 6. Cierre

### Qué te llevás

- `dotnet new web` crea el proyecto, `dotnet run` lo ejecuta y `Ctrl+C` lo detiene.
- `Program.cs` tiene cuatro momentos: preparar (`builder`), construir (`Build()`), definir rutas (`MapGet`) y escuchar (`Run()`).
- Un endpoint es una ruta más una respuesta: con eso ya hay una API real.
- Ante una respuesta inesperada, revisar en orden: ¿guardé?, ¿ejecuté en la carpeta correcta?, ¿la ruta está escrita igual que en el código?

### Lo que viene

En el próximo encuentro (Encuentro 5: «Git y GitHub: primer repo») el proyecto gana historial y sale a la web: guardaremos cada avance con Git y publicaremos el proyecto en GitHub.

## 7. Errores comunes y trampas

| Error o trampa | Causa | Fix |
| --- | --- | --- |
| `dotnet run` falla y no encuentra el proyecto | La terminal está parada en otra carpeta (por ejemplo, en la carpeta que contiene `HospitalApi`) | Ubicarse dentro de la carpeta del proyecto con `cd HospitalApi` y volver a ejecutar |
| El navegador muestra "404" o una página vacía | Falta la ruta en la URL o está mal escrita (por ejemplo, se abrió la URL sin `/hola`) | Escribir la ruta completa y exacta después del puerto |
| Se escribió `/Hola` y la API no responde | Las rutas distinguen mayúsculas de minúsculas: `/Hola` no es `/hola` | Usar la ruta tal cual quedó definida en `MapGet` |
| La API no arranca y el error menciona el puerto | Otra instancia de la API sigue corriendo y ocupa el puerto | Detener la instancia previa con `Ctrl+C` (o cerrar esa terminal) y ejecutar de nuevo |
| El programa no compila y la terminal marca una línea | Error de tipeo: falta punto y coma, un paréntesis o una comilla | Leer el número de línea que indica el error y comparar esa línea con el código modelo |
| La API responde el texto viejo después de editar | Se modificó el archivo pero no se guardó antes de ejecutar | Guardar con `Ctrl+S` y reiniciar con `dotnet run` |
