# Encuentro 4 — Introducción a .NET y C#

> Unidad 1 — Fundamentos de C# y Minimal API

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 4 de 36 |
| Unidad | 1 — Fundamentos de C# y Minimal API |
| Eje temático | 1 — Introducción a C# y .NET 6 |
| Carácter/Objetivo | Conceptual |
| Estructura | clase |
| Duración teórica | 240 minutos (4 horas reloj) |
| Uso de celular | No permitido |
| Concepto nuevo | Introducción a .NET y C# |
| Requisitos previos | Ninguno; es el primer encuentro de la unidad |
| Organización del trabajo | Grupos de 3-4 personas; un repositorio compartido por grupo para todo el curso |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y motivación | 20 min |
| Desarrollo teórico-práctico | 120 min |
| Consolidación y cierre | 20 min |
| Actividad complementaria | 80 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

1. Distinguir qué es .NET y qué rol cumple C# dentro del ecosistema.
2. Identificar la estructura básica de un proyecto .NET 6 (archivo `.csproj`, `Program.cs`).
3. Declarar variables con los tipos fundamentales (`string`, `int`, `long`, `bool`, `double`) y explicar la diferencia entre valor y referencia.
4. Ejecutar un proyecto con `dotnet run` y leer la salida en la terminal.
5. Describir la diferencia entre un proyecto de consola y un proyecto web (`dotnet new web`).

## 3. Apertura y motivación (20 min)

### Charla rápida: ¿Qué hay adentro de una app?

Imaginen que abren una aplicación en el celular: hay botones, pantallas, datos que se cargan y se muestran. Todo eso está construido con un lenguaje de programación y un entorno que lo ejecuta. Hoy vamos a conocer el entorno: .NET. Y el lenguaje con el que vamos a programar: C#.

### Diagnóstico de saberes previos

- ¿Alguna vez escribieron un programa? ¿En qué lenguaje?
- ¿Qué saben sobre la diferencia entre un compilador y un intérprete?
- ¿Qué significa "variable" en matemática? ¿Se parece a una variable en programación?

Se toman 5 minutos para que cada grupo comparta una respuesta breve. No se corrige; se anota qué saberes traen.

## 4. Desarrollo teórico-práctico (120 min)

### 4.1 ¿Qué es .NET? (15 min)

.NET es una plataforma de desarrollo de Microsoft que permite crear aplicaciones web, de escritorio, móviles y de consola. Usa C# como lenguaje principal. .NET 6 es una versión de soporte a largo plazo (LTS) que unifica las plataformas en un solo SDK.

**Punto clave:** .NET incluye un runtime (CLR), una biblioteca estándar (FCL) y herramientas de línea de comandos (`dotnet`).

### 4.2 Crear el primer proyecto (25 min)

Desde la terminal, en la carpeta del proyecto:

```bash
# Crear un proyecto web vacío (Minimal API)
dotnet new web -n MiPrimeraApi

# Entrar a la carpeta
cd MiPrimeraApi

# Ver la estructura que se crea
dir
```

La carpeta contiene:
- `MiPrimeraApi.csproj` — archivo de proyecto con las referencias y configuración.
- `Program.cs` — archivo único donde vive todo el código.
- `appsettings.json` — configuración de la aplicación.
- `wwwroot/` — archivos estáticos (HTML, CSS, JS) si los hubiera.

### 4.3 Estructura de Program.cs (20 min)

Abrir `Program.cs`. En .NET 6, todo el código vive en un solo archivo con *top-level statements* (sentencias de nivel superior). No hace falta envolver todo en una clase `Main`.

```csharp
// Program.cs — punto de entrada de la aplicacion
// Las sentencias de nivel superior se ejecutan en orden

var builder = WebApplication.CreateBuilder(args);
// Crear el constructor de la aplicacion web

var app = builder.Build();
// Compilar la aplicacion y preparar el servidor

app.Run();
// Iniciar el servidor y escuchar peticiones HTTP
```

### 4.4 Tipos de datos y variables (30 min)

C# es un lenguaje tipado: cada variable tiene un tipo que define qué valores puede guardar.

| Tipo | Significado | Ejemplo |
| --- | --- | --- |
| `string` | Texto | `"Hola mundo"` |
| `int` | Entero (32 bits) | `42` |
| `long` | Entero (64 bits) | `10000000000` |
| `bool` | Verdadero o falso | `true` |
| `double` | Número decimal | `3.14` |

```csharp
// Declarar una variable de tipo string
string saludo = "Bienvenidos a C#";

// Declarar una variable numerica entera
int cantidadEstudiantes = 28;

// Declarar una variable booleana
bool cursoActivo = true;

// Declarar un numero decimal
double notaPromedio = 7.5;

// Mostrar un valor en consola
Console.WriteLine(saludo);
Console.WriteLine($"Hay {cantidadEstudiantes} estudiantes");
```

**Ejercicio guiado:** En la consola del IDE (o terminal), ejecutar `dotnet run` en el proyecto creado. Observar que la app arranca pero no muestra nada porque no hay endpoints todavía. Luego agregar una línea `Console.WriteLine("App iniciada")` antes de `app.Run()` y volver a ejecutar para ver la salida.

### 4.5 Proyecto de consola vs proyecto web (30 min)

Un proyecto de consola (`dotnet new console`) ejecuta código secuencial y termina. Un proyecto web (`dotnet new web`) levanta un servidor que escucha peticiones HTTP y responde de forma continua.

```bash
# Crear un proyecto de consola para comparar
dotnet new console -n MiConsola
cd MiConsola
dotnet run
```

La diferencia fundamental: en un proyecto web, el código se ejecuta cuando llega una solicitud HTTP. No hay un `Main` explícito; el framework lo genera automáticamente.

## 5. Consolidación y cierre (20 min)

- Repasar con los grupos: ¿qué es .NET? ¿Qué es C#? ¿Cuál es la diferencia entre `dotnet new console` y `dotnet new web`?
- Cada grupo escribe en un papel: 3 conceptos clave que aprendieron hoy.
- Se comparten 3 papeles al plenario.

## 6. Actividad complementaria (80 min)

### Exploración guiada: más verbos HTTP y tipos de respuesta

Sin usar base de datos, explorar qué otros verbos HTTP existen más allá de GET. El objetivo es que cada grupo:

1. Lea la documentación de Minimal API en la ruta del curso.
2. Identifique los verbos disponibles: `MapGet`, `MapPost`, `MapPut`, `MapDelete`.
3. Escriba un ejemplo mínimo de cada verbo en `Program.cs` (sin necesidad de ejecutarlos todos).
4. Prepare un cuadro comparativo: verbo → verbo HTTP → qué hace típicamente.

**Pista:** `MapGet` responde a solicitudes GET; los otros verbos siguen el mismo patrón pero cambian el prefijo.

### Entrega del TP-U1 en GitHub

- Crear (o verificar) el repositorio del grupo en GitHub.
- Asegurarse de que `.gitignore` en la raíz contenga `bin/` y `obj/`.
- Hacer el primer commit con mensaje: `tp-u1: primer proyecto dotnet new web creado`.
- Subir el commit con `git push`.

## 7. Cierre (15 min)

### Qué te llevás

- .NET es la plataforma y C# es el lenguaje para programar sobre ella.
- Un proyecto .NET 6 Minimal API tiene `Program.cs` como archivo único con top-level statements.
- Las variables se declaran con tipo explícito: `string`, `int`, `long`, `bool`, `double`.
- `dotnet run` compila y ejecuta la aplicación.
- La diferencia entre proyecto de consola y proyecto web es el tipo de servidor que levantan.

### Lo que viene

**Encuentro 5: Estructuras de control y métodos** — Aprenderán condicionales (`if`/`else`), bucles (`for`, `foreach`) y cómo definir métodos reutilizables en C#.

## 8. Errores comunes y trampas

1. **Confundir `dotnet new web` con `dotnet new console`** — Ambos crean un proyecto, pero el primero levanta un servidor web y el segundo ejecuta código secuencial. Verificar el tipo de proyecto mirando el archivo `.csproj`.
2. **Olvidar `app.Run()`** — Sin esta línea, el servidor no arranca y la aplicación termina inmediatamente. Siempre debe estar al final de `Program.cs`.
3. **Usar `int` en lugar de `long` para IDs** — En C#, `int` es de 32 bits. Para IDs que puedan crecer, usar `long` (64 bits) desde el inicio.
4. **Escribir comentarios con tildes o eñes dentro del código** — Los comentarios en el código fuente no llevan tildes ni eñes. Usar `e` o `ee` como reemplazo (ejemplo: `conexion`, no `conexión`).
5. **No hacer commit al final del encuentro** — El hábito de commit al cerrar cada sesión asegura que el trabajo esté respaldado y versionado.
