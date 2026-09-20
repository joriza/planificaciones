# Encuentro 6 — Formato JSON y rutas

> Unidad 1 — Fundamentos de C#, Git/GitHub y Minimal API

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 6 |
| Unidad | 1 — Fundamentos de C#, Git/GitHub y Minimal API |
| Duración teórica | 4 horas reloj (240 minutos) |
| Concepto nuevo | Formato JSON, parámetros de ruta y de consulta (query string) |
| Requisitos previos | Clases 4 y 5 completadas (primera API con `MapGet`; repo con `init`, `commit`, `remote`, `push`) |
| Uso de celular | No permitido |
| Planificación anual | Encuentro 6: «Formato JSON y rutas» |

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

**Apertura y puente (30 min).** En el Encuentro 4 la API respondió texto plano: un humano lo lee sin problema, pero otro programa no sabe dónde termina el nombre y dónde empieza la edad. Pregunta disparadora para abrir: ¿cómo se mandan datos entre dos programas sin que se malinterpreten? La respuesta de hoy es doble: un formato de intercambio que todos respetan y rutas que aceptan valores variables.

Al finalizar el encuentro, cada estudiante puede:

1. Reconocer los elementos de un documento JSON: pares clave-valor, tipos de datos, arreglos y objetos.
2. Escribir un endpoint que devuelva un objeto anónimo convertido a JSON por la API.
3. Definir una ruta con parámetro (`{id:int}`) y usar ese valor dentro del handler.
4. Leer un parámetro de consulta desde la URL (`?nombre=Ana`).
5. Distinguir una respuesta de texto plano de una respuesta JSON.

## 3. Teoría mínima (45 min)

### Charla rápida: la ficha uniforme de admisión

En los hospitales existe la ficha uniforme de admisión: todos llenan los mismos campos, con el mismo formato, en el mismo lugar de la hoja. Cualquier recepcionista, de cualquier hospital, la lee sin preguntar nada. JSON es exactamente eso entre programas: una ficha estándar donde cada dato ocupa un lugar predecible, así cualquier sistema puede leerla, aunque esté escrito en otro lenguaje.

### Lo mínimo indispensable

**JSON** (JavaScript Object Notation) es el idioma de intercambio entre programas: texto simple y predecible que cualquier lenguaje sabe leer y escribir. Sus reglas:

- Cada dato es un **par clave-valor**, separado por dos puntos: `"nombre": "Ana Torres"`. Los pares se separan con comas.
- **Tipos de datos:** el texto va entre comillas dobles, los números van sin comillas, los booleanos son `true` o `false`, y `null` indica valor ausente.
- Los **arreglos** van entre corchetes `[ ]`: listas ordenadas de valores.
- Los **objetos** van entre llaves `{ }`: conjuntos de pares clave-valor. Todo el documento de ejemplo es un objeto.

Ejemplo: la ficha de una paciente con su lista de alergias.

```json
{
  "nombre": "Ana Torres",
  "edad": 34,
  "internada": false,
  "telefono": null,
  "alergias": ["Penicilina", "Ibuprofena"]
}
```

Cuando una API escrita en C# devuelve un objeto, el framework lo convierte a JSON automáticamente: el programa piensa en objetos y la red transporta texto. Por eso en esta unidad el orden es: primero entender el formato (hoy) y recién después usarlo en las respuestas (práctica de este mismo encuentro).

## 4. Práctica guiada (90 min)

### Paso 1 — Crear el proyecto

```powershell
dotnet new web -n FichasApi
cd FichasApi
code .
```

### Paso 2 — Reemplazar Program.cs

Abrir `Program.cs`, borrar todo su contenido y pegar este código completo:

```csharp
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Cuando una respuesta devuelve un OBJETO (no un texto plano),
// la API lo convierte automaticamente a JSON.
// Un objeto anonimo: new { campo = valor, ... }
app.MapGet("/ficha", () => new
{
    Nombre = "Ana Torres",          // texto: entre comillas
    Edad = 34,                       // numero: sin comillas
    Alergias = new[] { "Penicilina" } // arreglo de textos
});

// Ruta con parametro: {id} viaja en la URL y entra como argumento int
app.MapGet("/expediente/{id:int}", (int id) => new
{
    Id = id,
    Paciente = "Expediente papel aun no digitalizado"
});

// Parametro de consulta (query string): /saludo?nombre=Ana
app.MapGet("/saludo", (string nombre) => $"Hola, {nombre}");

app.Run();
```

### Paso 3 — Levantar la API

```powershell
dotnet run
```

Anotar el puerto de la línea `Now listening on:` (en los ejemplos de abajo se usa `http://localhost:5080`; reemplazar por el puerto propio).

### Paso 4 — Probar las tres rutas en el navegador

- `http://localhost:5080/ficha`
- `http://localhost:5080/expediente/7`
- `http://localhost:5080/saludo?nombre=Ana`

### Paso 5 — Comparar las salidas

`/ficha` y `/expediente/7` devuelven JSON (llaves, claves entre comillas); `/saludo?nombre=Ana` devuelve texto plano. Comentar la diferencia en conjunto antes del ejercicio independiente.

### Salidas esperadas

**GET /ficha** → 200:

```json
{
  "nombre": "Ana Torres",
  "edad": 34,
  "alergias": ["Penicilina"]
}
```

Observación: las claves llegan en minúscula inicial (`nombre`, no `Nombre`). El serializador JSON de ASP.NET Core aplica la convención web camelCase: en C# las propiedades se escriben en PascalCase y en el JSON viajan en camelCase. Mismo dato, distinta escritura.

**GET /expediente/7** → 200:

```json
{
  "id": 7,
  "paciente": "Expediente papel aun no digitalizado"
}
```

Prueba adicional: `/expediente/abc` no coincide con la ruta por la restricción `:int`, y responde 404 (para ese valor la ruta no existe).

**GET /saludo?nombre=Ana** → 200, texto plano:

```text
Hola, Ana
```

Observación: sin llaves ni comillas. Un `string` viaja tal cual: es el contraste clave con los dos endpoints anteriores.

## 5. Ejercicio independiente (55 min)

### Consigna

Agregar al mismo proyecto un endpoint `GET /recepcion/{paciente}` que devuelva un objeto JSON con exactamente tres campos:

- `Nombre`: el valor recibido como parámetro de ruta.
- `Sala`: el texto fijo `"Admisión"`.
- `Prioridad`: el número `1`.

Verificar en el navegador con `/recepcion/Ana` que la respuesta sea JSON (con llaves), no texto plano.

### Pista

Combinar un parámetro de ruta de texto (como `/expediente/{id:int}`, pero sin la restricción numérica) con un objeto anónimo (como `/ficha`). El nombre del parámetro en la ruta y en la firma del handler deben coincidir. La solución no está en este documento: se corrige con el anexo docente en la puesta en común.

## 6. Cierre (20 min)

### Qué te llevás

- JSON es el idioma de intercambio entre programas: pares clave-valor, texto entre comillas dobles, números sin comillas, booleanos, `null`, arreglos entre corchetes y objetos entre llaves.
- Si el handler devuelve un objeto, la API lo convierte a JSON automáticamente; si devuelve `string`, viaja texto plano.
- `{id:int}` trae un valor desde la ruta; `?nombre=Ana` lo trae desde la query string.
- Las claves del JSON viajan en camelCase aunque el código C# use PascalCase.

### Lo que viene

- Encuentro 7: «Verbos HTTP y CRUD en memoria». La API deja de solo informar: empieza a registrar altas, correcciones y bajas.

### Recordatorio de commit (rutina desde el Encuentro 5)

Con la API funcionando y el ejercicio terminado, al cierre del encuentro:

```powershell
git add .
git commit -m "Clase 6: formato JSON y rutas con parametros"
git push
```

## 7. Errores comunes y trampas

| Trampa | Causa | Cómo se resuelve |
| --- | --- | --- |
| Comillas dobles dentro del texto | Escribir `Nombre = ""Ana""` creyendo que así se escribe el JSON | Las comillas del valor van solo en los bordes (`"Ana"`); las comillas del JSON de salida las agrega el serializador |
| Confundir arreglo `[ ]` con objeto `{ }` | No queda claro cuándo hay lista y cuándo hay claves | Arreglo: lista de valores (`Alergias`). Objeto: conjunto de claves con valor (la ficha completa) |
| Poner comillas a los números | `Edad = "34"` guarda texto, no número | Los números van sin comillas: `Edad = 34` |
| Olvidar `:int` y mandar texto en `{id}` | Sin la restricción, `/expediente/abc` entra a la ruta y la conversión a `int` falla (400) | Declarar `{id:int}`: si el valor no es número, la ruta no coincide y responde 404 |
| Escribir mal la query string | El primer parámetro va con `?` y los siguientes con `&` | `/saludo?nombre=Ana`; si hubiera dos parámetros: `/ruta?a=1&b=2`. No omitir ni duplicar símbolos |
| Esperar texto plano y recibir JSON | El handler devuelve un objeto y aparecen llaves y comillas en el navegador | Leer la salida como JSON: es el formato pensado para programas, no para lectura directa |
