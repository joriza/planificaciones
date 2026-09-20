# Encuentro 5 — Rutas, parámetros y git local

> Unidad 1 — Fundamentos de Minimal API con C#

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 5 de 36 |
| Unidad | 1 — Fundamentos de Minimal API con C# |
| Eje temático | 1 — Fundamentos de Minimal API (con el saber transversal 5: Terminal, Git y GitHub) |
| Carácter/Objetivo | Procedimental |
| Duración teórica | 240 minutos (4 horas reloj) |
| Concepto nuevo | Parámetros de ruta (`{nombre}`, `{id:long}`), objetos anónimos con JSON automático y git local como herramienta de trabajo (`git init`, `.gitignore`, `git add`, `git commit`, `git log`) |
| Requisitos previos | Encuentro 4: proyecto creado, anatomía de `Program.cs`, `dotnet run`, primer endpoint GET probado en navegador |
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

1. Escribir rutas con parámetros (`{nombre}` y `{id:long}`) y usar el valor recibido dentro del endpoint.
2. Devolver objetos anónimos y leer la respuesta JSON automática de la API en el navegador.
3. Iniciar un repositorio local con `git init`, ignorar `bin/` y `obj/` con `.gitignore`, y registrar cambios con `git add` + `git commit`.
4. Adoptar la rutina del curso: un commit con mensaje referente al cierre de cada clase.
5. Recuperarse de los errores típicos de git (identidad sin configurar, carpeta equivocada, `.gitignore` ausente).

## 3. Teoría mínima (40 min)

### Charla rápida: la ventanilla que pregunta el nombre

En el hotel, la recepción no contesta siempre lo mismo: según quién pregunta, la respuesta cambia. «Buenos días, ¿me decís tu nombre?» — y con ese dato arma la respuesta. Las rutas con parámetros funcionan así: la ruta tiene una parte fija (`/hello/`) y una parte variable (`{name}`) que la API toma de la propia URL. Un solo endpoint, infinitas respuestas.

Y una segunda escena: el cuaderno de la recepción. Cada vez que pasa algo importante, el recepcionista escribe una línea con fecha: qué cambió y por qué. Ese cuaderno es **git**: una máquina del tiempo del proyecto donde cada anotación se llama **commit** y lleva un mensaje que explica el cambio.

### Lo mínimo indispensable

- Un **parámetro de ruta** se escribe entre llaves en la ruta y llega al endpoint como un dato más: `/hello/{name}` entrega `name` al handler, que lo declara como `(string name)`.
- El filtro de tipo restringe la ruta: `/patients/{id:long}` solo coincide cuando el trozo de URL es un número entero. En este curso **los ids siempre son `long`**.
- Un **objeto anónimo** (`new { ... }`) se escribe en el momento, sin declarar un record. La API lo convierte sola a **JSON** (JSON automático), con los nombres de propiedad tal cual se escribieron.
- **Git** guarda el historial del proyecto en una carpeta oculta `.git`, dentro de la carpeta del proyecto. `git init` se ejecuta **una sola vez** por proyecto.
- **`.gitignore`** es la lista de lo que NO se versiona: las carpetas `bin/` y `obj/` se regeneran solas al compilar, así que fuera del cuaderno.
- **Rutina del curso:** al cierre de cada clase, `git add .` + `git commit -m "u1-clase-NN: resumen"`. El mensaje es referente, en minúsculas y sin tildes.

## 4. Práctica guiada (70 min)

Se continúa con el proyecto `HospitalApi` del encuentro 4. Rotación de teclado por paso.

### Parte A — Parámetros de ruta y JSON automático (pasos 1 a 3)

#### Paso 1 — Reemplazar Program.cs

```csharp
// Program.cs - Encuentro 5: rutas con parametros y JSON automatico

// 1) Prepara el programa
var builder = WebApplication.CreateBuilder(args);

// 2) Construye la aplicacion
var app = builder.Build();

// 3) Endpoints

// {name} es un parametro de ruta: toma el trozo variable de la URL
// y lo entrega al handler, que lo declara como (string name)
app.MapGet("/hello/{name}", (string name) =>
{
    // El texto de respuesta puede usar el parametro recibido
    return $"Hola, {name}! Esta respuesta salio de una ruta con parametro.";
});

// {id:long} agrega un filtro: la ruta SOLO coincide si el valor es un numero.
// El parametro se declara long: los ids SIEMPRE son long en este curso
app.MapGet("/patients/{id:long}", (long id) =>
{
    // Objeto anonimo: se escribe en el momento y la API lo convierte sola
    // a JSON (JSON automatico). Las propiedades viajan con el nombre
    // exacto que se escribe aca.
    return new
    {
        patientId = id,
        firstName = "Ana",
        lastName = "Garcia",
        birthDate = "2001-03-14"   // fechas: SIEMPRE string en ISO yyyy-MM-dd
    };
});

// Otro objeto anonimo, con la forma corta: propiedad = variable del mismo nombre
app.MapGet("/doctors/{id:long}", (long id) =>
{
    long doctorId = id;              // el id llega como long
    string specialty = "Pediatria";  // dato de ejemplo fijo por ahora

    return new { doctorId, specialty };
});

// 4) Deja la API escuchando pedidos
app.Run();
```

Guardar con `Ctrl+S`, reiniciar con `Ctrl+C` + `dotnet run`.

#### Paso 2 — Probar los parámetros en el navegador

| URL | Respuesta esperada |
| --- | --- |
| `http://localhost:5080/hello/Ana` | `Hola, Ana! Esta respuesta salio de una ruta con parametro.` |
| `http://localhost:5080/hola/Juan` (ruta vieja del encuentro 4) | `HTTP ERROR 404`: esa ruta ya no existe en este `Program.cs` |
| `http://localhost:5080/patients/25` | JSON (ver abajo) |
| `http://localhost:5080/doctors/7` | JSON (ver abajo) |

```json
{"patientId":25,"firstName":"Ana","lastName":"Garcia","birthDate":"2001-03-14"}
```

```json
{"doctorId":7,"specialty":"Pediatria"}
```

Cambia el número en la URL, cambia el JSON: el parámetro vive en la ruta.

#### Paso 3 — El filtro `:long` en acción

Probar `http://localhost:5080/patients/abc`: el navegador responde `HTTP ERROR 404`. Con el filtro `{id:long}`, una URL cuyo valor no es un número **no coincide con la ruta** y la API responde que no la conoce. Sin el filtro, la ruta aceptaría cualquier texto y el valor podría no convertirse. Conclusión: en rutas de id, el filtro siempre va.

### Parte B — Git local (pasos 4 a 8)

#### Paso 4 — Verificar git y configurar la identidad

Dentro de la carpeta `HospitalApi`:

```powershell
git --version
```

Salida esperada: `git version 2.x.x` (cualquier versión 2 sirve). Si no está instalado, avisar al docente.

La identidad se configura **una sola vez por computadora**:

```powershell
git config --global user.name "Grupo 1"
git config --global user.email "grupo1@escuela.edu.ar"
```

Sin estos datos, el primer `git commit` falla pidiendo quién sos: git firma cada anotación del cuaderno.

#### Paso 5 — Iniciar el repositorio

```powershell
git init
```

Salida esperada:

```text
Initialized empty Git repository in D:/cursos/HospitalApi/.git/
```

El repositorio es la carpeta oculta `.git` dentro de `HospitalApi`. Se creó una vez; no se vuelve a ejecutar en este proyecto.

#### Paso 6 — Crear el .gitignore

Crear el archivo `.gitignore` en la raíz del proyecto (misma carpeta que `HospitalApi.csproj`), con VS Code, con este contenido:

```text
bin/
obj/
```

Después comparar los dos estados:

```powershell
git status
```

Antes del `.gitignore`, la lista de archivos sin seguimiento incluía `bin/` y `obj/`; después desaparecen de la lista. Esas carpetas se regeneran solas en cada compilación: nunca se versionan.

#### Paso 7 — El primer commit

```powershell
git add .
git commit -m "u1-clase-05: rutas con parametros y json automatico"
```

Salida esperada (resumida):

```text
[main (root-commit) 3f2a1b9] u1-clase-05: rutas con parametros y json automatico
 4 files changed, ...
 create mode 100644 .gitignore
 create mode 100644 Program.cs
 ...
```

`git add .` prepara todo lo nuevo o modificado; `git commit` pega la foto en el cuaderno con su mensaje referente.

#### Paso 8 — Leer el historial

```powershell
git log --oneline
```

Salida esperada:

```text
3f2a1b9 (HEAD -> main) u1-clase-05: rutas con parametros y json automatico
```

Un solo commit, por ahora. Esta lista va a crecer una línea por clase: es la bitácora del cuatrimestre.

## 5. Ejercicio independiente (50 min)

**Consigna.** Cada grupo agrega al `Program.cs` del proyecto:

1. Un endpoint `/appointments/{id:long}` que devuelva un objeto anónimo con `appointmentId`, `doctorId` y `date` (la fecha como string ISO, por ejemplo `"2024-09-12"`).
2. Un endpoint `/wards/{name}` que devuelva un texto usando el nombre recibido (por ejemplo: `"Sala asignada: " + name`).
3. Prueba en el navegador de los dos endpoints: uno con un número, uno con un texto, y uno con un texto donde va el número (`/appointments/abc`) para verificar el filtro.
4. **Cierre con la rutina del curso:** `git add .` + `git commit -m "u1-clase-05: ejercicio de rutas con parametros"`.

**Pista.** El endpoint de turnos es una copia de `/patients/{id:long}` con otras propiedades; el de salas es una copia de `/hello/{name}`. Antes de commitear, correr `git status`: tiene que mostrar `Program.cs` como modificado y **nada** de `bin/` ni `obj/`. Si aparecen, el `.gitignore` quedó en otra carpeta.

## 6. Extensión y consolidación (45 min)

Para los grupos que terminan la base. Rotación: un ítem por integrante.

1. **Ruta con dos parámetros:** `/full-name/{name}/{surname}` que devuelva un texto con los dos valores. El orden de los parámetros en la ruta y en el handler tiene que coincidir.
2. **Objeto anónimo propio:** un endpoint `/patients/{id:long}` «mejorado» que agregue `gender` y `city` al JSON, respetando que la fecha siga siendo string ISO.
3. **Lectura del historial:** correr `git log --oneline` y leer en voz alta los mensajes del grupo. ¿Se entiende qué hizo cada commit sin abrir el código? Si no, corregir el hábito ahora: el mensaje se escribe para el que lee mañana.
4. **Simulacro de recuperación:** un integrante cierra VS Code y la terminal; otro abre la carpeta del proyecto, corre `dotnet run` y comprueba que todo sigue funcionando. El repositorio y el código viven en la carpeta, no en la sesión.

## 7. Cierre (15 min)

### Qué te llevás

- `{nombre}` toma el trozo variable de la URL; `{id:long}` además exige que sea número: con texto responde 404.
- Un objeto anónimo `new { ... }` sale por el navegador como JSON automático, con los nombres de propiedad tal cual se escribieron.
- Los ids siempre son `long`; las fechas, siempre string ISO `yyyy-MM-dd`.
- Git: `git init` una vez por proyecto; `.gitignore` con `bin/` y `obj/` desde el primer día; identidad configurada una vez por computadora.
- Rutina del curso: al cierre de cada clase, `git add .` + `git commit -m "u1-clase-NN: resumen"`, y `git log --oneline` para releer la bitácora.

### Lo que viene

En el Encuentro 6 la API deja de ser solo lectura: los verbos HTTP POST, PUT y DELETE para crear, reemplazar y borrar sobre una lista compartida en memoria, la clase `Results` para responder con el código correcto (200, 201, 204, 400, 404) y el cuadro de referencia rápida de verbos y códigos.

## 8. Errores comunes y trampas

1. **`git init` en la carpeta equivocada** (una carpeta arriba del proyecto). Causa: lanzar el comando sin mirar dónde está parada la terminal. Fix: el repo tiene que quedar junto al `.csproj`; verificar con `git status` desde la carpeta del proyecto: si no lista `Program.cs`, estás en otra carpeta (avisar al docente antes de mover nada).
2. **Olvidar el `.gitignore` antes del primer `git add`.** Causa: `bin/` y `obj/` quedan versionados y ensucian el historial. Fix: crear el `.gitignore` en la raíz **antes** del primer `add`; si ya pasó, pedir acompañamiento docente para sacarlo del índice.
3. **Primer `git commit` rechazado pidiendo identidad.** Causa: `user.name`/`user.email` sin configurar en esa computadora. Fix: los dos comandos `git config --global` del paso 4, una sola vez.
4. **Esperar que `{id}` sin filtro limite el tipo.** Causa: confundir el parámetro con su validación. Fix: `{id:long}` en la ruta y `long id` en el handler, siempre juntos.
5. **Mensajes de commit vagos o con tildes** (`"cambios"`, `"arreglo del día"`). Causa: escribir el mensaje a las apuradas; la consola trata mal las tildes. Fix: convención del curso `u1-clase-NN: resumen en minúsculas y sin tildes`.
6. **Concluir que el JSON «no funciona» por el 404 de `/patients/abc`.** Causa: leer el 404 del filtro como un error propio. Fix: es el comportamiento correcto del filtro `:long`; probar con un número para ver el JSON.
