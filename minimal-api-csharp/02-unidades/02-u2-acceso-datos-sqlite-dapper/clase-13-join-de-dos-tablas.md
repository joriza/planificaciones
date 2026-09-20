# Encuentro 13 — JOIN de dos tablas y GET con datos reales

> Unidad 2 — Acceso a datos con SQLite y Dapper

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 13 |
| Unidad | 2 — Acceso a datos con SQLite y Dapper |
| Duración teórica | 4 horas reloj (240 minutos) |
| Concepto nuevo | JOIN de dos tablas (`INNER JOIN ... ON`), alias de tabla y DTO combinado con alias AS |
| Requisitos previos | Clase 12 completada (WHERE con parámetros y objeto anónimo, LIKE, endpoints de búsqueda; proyecto `BusquedasApi` con hospital.db funcionando) |
| Uso de celular | No permitido |
| Planificación anual | Encuentro 13: «JOIN de dos tablas / Consulta con relación» y «Pacientes y provincias / GET con datos reales» |

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

**Apertura y puente (30 min).** El endpoint de la clase anterior puede devolver el paciente completo, pero muestra `"provinceId": "ON"`. Pregunta disparadora: ¿quién es "ON"? El cliente quiere leer "Ontario", no descifrar códigos. El código vive en `patients` y el nombre vive en otra tabla: `province_names`. ¿Cómo junta la API las dos para responder con datos reales? Hoy se resuelve con el JOIN, la operación que lee dos tablas al mismo tiempo y las empareja por su relación.

Al finalizar el encuentro, cada estudiante puede:

1. Explicar la relación entre `patients.province_id` y `province_names.province_id` (clave foránea que referencia la tabla de referencia).
2. Escribir un `JOIN` de dos tablas con alias cortos (`p`, `pn`) y calificar las columnas para evitar la ambigüedad.
3. Definir un record DTO combinado (propiedades de las dos tablas) y mapear cada columna con alias AS.
4. Implementar endpoints GET que devuelven datos de las dos tablas, filtrando por columna de cualquiera de ellas.
5. Aplicar la regla de los parámetros con objeto anónimo también en consultas con JOIN.

## 3. Teoría mínima (45 min)

### Charla rápida: el cuaderno de códigos

La recepcionista lee la ficha: "provincia: ON". Nadie en recepción habla en códigos: mira el cuaderno de códigos pegado al mostrador y lee en voz alta "Ontario". La ficha nunca repite el nombre completo: guarda el código, y el cuaderno hace de traductor. El JOIN es exactamente eso: leer la ficha (`patients`) y, por cada código, consultar el cuaderno (`province_names`) para traer el nombre. La traducción es posible porque la relación ya está grabada: el `province_id` de la ficha debe coincidir con el `province_id` del cuaderno.

### Lo mínimo indispensable

**La relación (clave foránea).** El esquema de hospital.db ya la define:

```
patients.province_id  ── referencia ──>  province_names.province_id
 (el código en la ficha)                (el código + el nombre en el cuaderno)
```

`patients` tiene 258 filas; `province_names`, 13. Cada paciente apunta a exactamente una provincia.

**El JOIN.** Tres piezas:

```sql
FROM patients p
JOIN province_names pn ON p.province_id = pn.province_id
```

| Pieza | Qué hace |
| --- | --- |
| `FROM patients p` | Tabla base, con alias corto `p` |
| `JOIN province_names pn` | Tabla relacionada, con alias corto `pn` |
| `ON p.province_id = pn.province_id` | Condición de enlace: qué filas de las dos tablas corresponden |

Por cada fila de `patients`, SQLite busca en `province_names` la fila con el mismo `province_id` y devuelve las dos combinadas. Sin la condición del `ON` (o con una condición equivocada), cada ficha se combina con las 13 provincias: un producto cruzado de 258 × 13 filas sin sentido.

**Nombres repetidos y calificación.** La columna `province_id` existe en las dos tablas. Escrita sin calificación, SQLite no sabe cuál tomar y corta con el error `ambiguous column name: province_id`. Regla: dentro de un JOIN, calificar SIEMPRE las columnas con el alias de tabla.

| Columna | Cómo se escribe |
| --- | --- |
| Datos del paciente | `p.patient_id`, `p.first_name`, `p.city`, ... |
| Datos de la provincia | `pn.province_name` |
| El código del enlace | `p.province_id = pn.province_id` |

**El DTO combinado.** El resultado mezcla columnas de las dos tablas: necesita un record con todas las propiedades que el SELECT devuelve, y un alias AS por columna:

```csharp
// Columnas de patients + la traduccion que vive en province_names.
record PatientWithProvince(int PatientId, string FirstName, string LastName, string? City, string ProvinceName);
```

Decisión de diseño que el DTO refleja: el JSON expone la traducción (`ProvinceName`), no la clave interna (`province_id`). El endpoint decide qué muestra; la base guarda los códigos.

**Los parámetros no cambian.** Filtrar sobre un JOIN usa exactamente la regla de la clase 12: marcador en el SQL fijo + objeto anónimo.

```sql
WHERE p.patient_id = @Id
```

```csharp
new { Id = id }
```

## 4. Práctica guiada (90 min)

### Paso 1 — Crear el proyecto

```powershell
dotnet new web -n HospitalApi
cd HospitalApi
code .
```

### Paso 2 — Agregar los paquetes

```powershell
dotnet add package Microsoft.Data.Sqlite
dotnet add package Dapper
```

### Paso 3 — Copiar hospital.db a la raíz del proyecto

El mismo archivo de las clases 10 a 12. Verificar que `hospital.db` queda en la raíz, junto al `.csproj`.

### Paso 4 — Reemplazar Program.cs

Abrir `Program.cs`, borrar todo su contenido y pegar este código completo:

```csharp
using Dapper;
using Microsoft.Data.Sqlite;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Cadena de conexion: el archivo hospital.db vive en la raiz del proyecto.
var connectionString = "Data Source=hospital.db";

// GET /patients/with-province: JOIN de patients + province_names (las 258 filas).
app.MapGet("/patients/with-province", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var patients = connection.Query<PatientWithProvince>(@"
        SELECT p.patient_id AS PatientId,
               p.first_name AS FirstName,
               p.last_name AS LastName,
               p.city AS City,
               pn.province_name AS ProvinceName
        FROM patients p
        JOIN province_names pn ON p.province_id = pn.province_id
        ORDER BY p.last_name, p.first_name").ToList();

    return Results.Ok(patients);
});

// GET /patients/{id:int}/with-province: JOIN + filtro con parametro (regla de la clase 12).
app.MapGet("/patients/{id:int}/with-province", (int id) =>
{
    using var connection = new SqliteConnection(connectionString);

    var patient = connection.Query<PatientWithProvince>(@"
        SELECT p.patient_id AS PatientId,
               p.first_name AS FirstName,
               p.last_name AS LastName,
               p.city AS City,
               pn.province_name AS ProvinceName
        FROM patients p
        JOIN province_names pn ON p.province_id = pn.province_id
        WHERE p.patient_id = @Id",
        // Objeto anonimo: la clave Id completa el marcador @Id.
        new { Id = id }).FirstOrDefault();

    return patient is null ? Results.NotFound(new { mensaje = "No existe el paciente" })
                           : Results.Ok(patient);
});

app.Run();

// Los tipos (records) se declaran al final del archivo cuando el programa
// usa instrucciones de nivel superior: es una regla de C#.
// DTO combinado: propiedades de las dos tablas, en PascalCase gracias a los alias AS.
record PatientWithProvince(int PatientId, string FirstName, string LastName, string? City, string ProvinceName);
```

### Paso 5 — Levantar la API

```powershell
dotnet run
```

Anotar el puerto de la línea `Now listening on:` (en los ejemplos se usa `http://localhost:5080`; reemplazar por el puerto propio).

### Paso 6 — Probar los dos endpoints en el navegador

- `http://localhost:5080/patients/with-province` → 200 con las 258 filas combinadas; cada fila muestra `provinceName`, no el código.
- `http://localhost:5080/patients/1/with-province` → 200 con un solo objeto combinado.
- `http://localhost:5080/patients/9999/with-province` → 404 con mensaje en JSON.

### Paso 7 — Experimento: provocar la columna ambigua

El error de ambigüedad es seguro de provocar: no toca los datos, solo corta la consulta.

1. En el primer endpoint, reemplazar el enlace `ON p.province_id = pn.province_id` por `ON province_id = pn.province_id`.
2. Reiniciar (`dotnet run`) y pedir `http://localhost:5080/patients/with-province` → 500. En la terminal donde corre la API aparece la causa exacta: `SQLite Error 1: 'ambiguous column name: province_id'`.
3. Leerlo: hay dos columnas con ese nombre (una por tabla) y SQLite no adivina. Devolver la calificación `p.province_id` y verificar que todo vuelve a funcionar.

### Salidas esperadas

**GET /patients/with-province** → 200 con 258 filas (respuesta similar a; los valores concretos dependen de los datos):

```json
[
  {
    "patientId": 12,
    "firstName": "Emily",
    "lastName": "Watson",
    "city": "Toronto",
    "provinceName": "Ontario"
  }
]
```

**GET /patients/1/with-province** → 200 con un objeto con la misma estructura.

**GET /patients/9999/with-province** → 404:

```json
{
  "mensaje": "No existe el paciente"
}
```

Observación sobre la respuesta combinada: el código `ON` desaparece del JSON. El DTO decidió exponer `ProvinceName`; si el día de mañana un cliente necesita también el código, se agrega la columna `pn.province_id AS ProvinceId` y la propiedad al record — el endpoint se adapta ampliando el SELECT y el DTO.

## 5. Ejercicio independiente (55 min)

### Consigna

Agregar al mismo proyecto dos endpoints nuevos:

1. `GET /provinces`: la tabla de referencia completa — los 13 registros de `province_names`, ordenados por nombre. Necesita un DTO propio (record `Province` con propiedades `ProvinceId` y `ProvinceName`). No requiere JOIN: es una sola tabla.
2. `GET /patients/by-province-name?term=xxx`: los pacientes cuya provincia contenga el término en el nombre — búsqueda parcial con LIKE sobre la tabla relacionada. Por ejemplo `term=Nova` devuelve los pacientes de "Nova Scotia". Devuelve el mismo DTO combinado `PatientWithProvince` de la práctica. Respuesta: 200 con la lista, incluso vacía.

### Pista

El punto 1 es un SELECT simple con alias AS, como los de la clase 11. El punto 2 es el JOIN de la práctica más el WHERE con LIKE de la clase 12, apuntando a la columna de la tabla relacionada: `WHERE pn.province_name LIKE @Pattern` — calificada con `pn.`, y con el patrón armado en el valor. Reutilizar el record `PatientWithProvince`. La solución completa está en el anexo docente.

## 6. Cierre (20 min)

### Qué te llevás

- El JOIN lee dos tablas al mismo tiempo y las empareja por la condición del `ON` — la relación ya está definida por la clave foránea.
- Con alias cortos (`p`, `pn`) y columnas calificadas se evita el error de columna ambigua.
- El DTO combinado define el JSON: una propiedad por columna, cada columna con su alias AS.
- Los parámetros con objeto anónimo se usan igual que en la clase 12: `WHERE p.patient_id = @Id` + `new { Id = id }`.
- El endpoint expone la traducción (`ProvinceName`), no la clave interna; ampliar el SELECT y el DTO es la vía para exponer más.

### Lo que viene

Encuentro 14: «Endpoints GET sobre la BD / Migración de endpoints» y «Cierre de la Unidad 2 / Preparación del tp-u2». Con WHERE, LIKE y JOIN en caja de herramientas, todo lo visto se integra en una sola API: los endpoints del mini-proyecto en memoria migran a consultas reales sobre hospital.db y los datos dejan de volar cuando se detiene la app.

### Recordatorio de commit (rutina desde el Encuentro 5)

Con los endpoints funcionando y el ejercicio terminado, al cierre del encuentro:

```powershell
git add .
git commit -m "Clase 13: JOIN de dos tablas y GET con datos reales"
git push
```

## 7. Errores comunes y trampas

| Trampa | Causa | Cómo se resuelve |
| --- | --- | --- |
| `ambiguous column name: province_id` | La columna existe en las dos tablas y quedó sin calificar | Calificar SIEMPRE con el alias de tabla: `p.province_id`, `pn.province_name` |
| Respuesta con miles de filas absurdas | Falta el `ON` o la condición está incompleta: se arma el producto cruzado (258 × 13) | Escribir el enlace completo: `JOIN province_names pn ON p.province_id = pn.province_id` |
| DTO combinado con propiedades nulas o en 0 | El SELECT trae menos columnas que propiedades tiene el record, o falta un alias AS | Una columna con alias AS por cada propiedad del DTO: el mapeo de Dapper es por nombre |
| Concatenar valores en el SQL ahora que hay más texto | Creer que el JOIN "justifica" armar el string a mano | La regla no cambia con JOIN: marcador `@` + objeto anónimo |
| `no such table: province_name` (o `provinces`) | Nombre de tabla escrito de memoria | El nombre exacto es `province_names` (en plural); verificar contra el esquema |
| Esperar el código de provincia en el JSON | Confundir lo que la base guarda con lo que el endpoint expone | El DTO decidió exponer `ProvinceName`; para el código, agregar `pn.province_id AS ProvinceId` y la propiedad al record |
