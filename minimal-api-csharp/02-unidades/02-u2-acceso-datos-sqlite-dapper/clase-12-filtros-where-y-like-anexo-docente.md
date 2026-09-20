# Anexo docente — Encuentro 12: Filtros WHERE y búsquedas con LIKE

> Material de uso interno docente. No se distribuye a estudiantes.
> Curso: Desarrollo de APIs con C# .NET 6 (Minimal API) · Unidad 2 — Acceso a datos con SQLite y Dapper

## Encuadre

| Campo | Detalle |
| --- | --- |
| Encuentro | 12 — «Filtros WHERE / Parámetros con objeto anónimo» y «Búsquedas con LIKE / Endpoints de búsqueda» (planificación anual) |
| Ejercicio evaluado | `GET /patients/by-province/{provinceId}` (filtro exacto con parámetro) y `GET /patients/search-allergy?term=` (búsqueda parcial con LIKE) |
| Momento del bloque | Ejercicio independiente (55 min) + puesta en común y cierre (20 min) |
| Insumos | Proyecto `BusquedasApi` de la práctica guiada funcionando, con `hospital.db` en la raíz y los paquetes Microsoft.Data.Sqlite + Dapper instalados |

## Preparación previa (gestión del aula)

- Ejecutar antes de clase las consultas del encuentro y anotar las cantidades reales (pacientes en Toronto, apellidos que contienen "son", alérgicos a Penicillin, pacientes por provincia): permite validar las salidas de los alumnos sin improvisar y detectar quién hardcodeó resultados.
- Tener abierto un navegador de SQLite (DB Browser / DBeaver) con hospital.db, o la CLI `sqlite3`, para mostrar en paralelo la misma consulta en SQL puro y su resultado: la API solo envuelve la consulta, el filtro vive en la base.
- Verificar al inicio que cada equipo conserva `hospital.db` (clase 10) y los paquetes de las clases 10-11. Un equipo sin el archivo va a recibir `SQLite Error 1: 'no such table: patients'` al primer pedido.

## Solución esperada

Ambos endpoints van en el `Program.cs` de la práctica, junto a los otros dos (mismo DTO `PatientCard` declarado al final del archivo):

```csharp
// Solucion del ejercicio (a): filtro exacto por codigo de provincia.
app.MapGet("/patients/by-province/{provinceId}", (string provinceId) =>
{
    using var connection = new SqliteConnection(connectionString);

    var patients = connection.Query<PatientCard>(@"
        SELECT patient_id AS PatientId,
               first_name AS FirstName,
               last_name AS LastName,
               city AS City,
               allergies AS Allergies
        FROM patients
        WHERE province_id = @ProvinceId
        ORDER BY last_name, first_name",
        new { ProvinceId = provinceId }).ToList();

    return Results.Ok(patients);
});

// Solucion del ejercicio (b): busqueda parcial por alergia.
app.MapGet("/patients/search-allergy", (string term) =>
{
    using var connection = new SqliteConnection(connectionString);

    var patients = connection.Query<PatientCard>(@"
        SELECT patient_id AS PatientId,
               first_name AS FirstName,
               last_name AS LastName,
               city AS City,
               allergies AS Allergies
        FROM patients
        WHERE allergies LIKE @Pattern
        ORDER BY last_name, first_name",
        // El patron se arma en el valor: el SQL sigue siendo fijo.
        new { Pattern = "%" + term + "%" }).ToList();

    return Results.Ok(patients);
});
```

Pedidos de prueba en `requests.http`:

```http
### Pacientes de Ontario (esperar 200 con muchas filas: ~95% de los 258)
GET http://localhost:5080/patients/by-province/ON

### Codigo inexistente (esperar 200 con [])
GET http://localhost:5080/patients/by-province/ZZ

### Alergia a Penicillin (esperar 200)
GET http://localhost:5080/patients/search-allergy?term=penicil

### Sin alergia registrada, nadie nuevo (esperar 200 con [])
GET http://localhost:5080/patients/search-allergy?term=
```

Respuestas esperadas:

- `/patients/by-province/ON` → 200 con la mayoría de los pacientes (la distribución real se anota en la preparación previa). Con un código válido sin pacientes, también 200 pero con `[]`.
- `/patients/by-province/ZZ` → 200 con `[]`: búsqueda sin coincidencias, no 404.
- `/patients/search-allergy?term=penicil` → 200 con los pacientes cuya alergia incluye "Penicillin" (LIKE no distingue mayúsculas).
- `/patients/search-allergy?term=` → 200 con `[]`: los pacientes con `allergies` NULL no coinciden con LIKE (un NULL nunca matchea); el patrón `%%` solo encontraría alergias registradas no vacías.

Detalles clave de la solución:

- El patrón LIKE se arma **en el valor** (`"%" + term + "%"`) y no en el SQL. Es el punto de control principal del ejercicio.
- La lista vacía con 200 es una decisión de diseño deliberada: "no hay coincidencias" es un resultado válido de una búsqueda. Retomar la distinción con el `GET /pacientes/99` → 404 de la Unidad 1: ahí el recurso individual no existía; acá la búsqueda funcionó y el resultado es vacío.

## Criterios de logro

| # | Criterio | Evidencia observable |
| --- | --- | --- |
| 1 | Rutas del ejercicio definidas con los nombres pedidos | `GET /patients/by-province/ON` y `GET /patients/search-allergy?term=penicil` responden 200 |
| 2 | Filtro exacto con parámetro, sin concatenación | El handler pasa `new { ProvinceId = provinceId }`; no hay `+` armando el texto SQL |
| 3 | Patrón LIKE armado en el valor | El código muestra `new { Pattern = "%" + term + "%" }` |
| 4 | Alias AS en cada columna hacia el DTO | El JSON muestra `patientId`, `firstName`, `lastName`, `city`, `allergies` (no propiedades nulas) |
| 5 | Búsqueda vacía responde 200 con `[]` | Los códigos inexistentes o términos sin coincidencias devuelven 200, no 404 |
| 6 | Cierre con rutina Git | `git log` muestra el commit "Clase 12: filtros WHERE con parámetros y búsquedas con LIKE" y el push al remoto |

## Qué observar en el aula

- **El punto frágil del encuentro es la concatenación.** Un estudiante que arma el SQL con `+` "porque así se imprime en consola" no incorporó el concepto central. Al detectarlo, volver a la charla de la recepcionista: el visitante aporta el dato, no la pregunta. Mostrar en papel (no ejecutarlo contra la BD real) qué queda armado cuando llega `Toronto' OR '1'='1`.
- **Sondeo rápido de comprensión:** ¿dónde se escribe el `%`? (en el valor). ¿Qué devuelve una búsqueda sin resultados? (200 con `[]`). ¿Qué diferencia hay entre `= 'Toronto'` y `LIKE '%Toronto%'`? (exacto y con mayúsculas exactas vs. parcial e insensible a mayúsculas).
- **Pedir anticipación:** antes de ejecutar cada pedido, que escriban en el `.http` o en papel la forma esperada del JSON. Los que ejecutan para "ver qué sale" suelen tener los alias AS a medias.
- **Verificar el 400 del parámetro faltante en la práctica:** es la primera vez que el binding de query string devuelve 400 solo; aprovechar para conectarlo con las validaciones de la Unidad 1 (la API avisa antes de tocar la base).
- **Señal de alerta:** lista con propiedades `null` en el JSON. Falta el alias AS (Dapper mapea por nombre y `first_name` no coincide con `FirstName`). Es el error de mapeo más frecuente del encuentro.

## Errores previsibles y respuestas

- *"¿Por qué me da 400 si el endpoint está bien?"* → Falta el parámetro de query string en la URL. El binding exige `?term=...`; sin valor no hay pedido válido.
- *"Must declare the scalar variable @city"* → La clave del objeto anónimo no coincide con el marcador. El emparejamiento de Dapper no distingue mayúsculas pero sí el nombre.
- *"¿Y si quiero que el % dependa del usuario? ¿Lo pego en el SQL?"* → Nunca en el SQL: el patrón completo es un valor (`"%" + term + "%"`). Si el criterio no cambia nunca (búsqueda fija), puede escribirse literal en el SQL (`LIKE 'Pen%'`) porque no hay dato del cliente involucrado.
- *"¿Por qué no aparecen los pacientes sin alergias en la búsqueda?"* → `allergies` es NULL en esas filas y NULL nunca coincide con LIKE. Es el comportamiento deseado: sin alergia no hay alergia que buscar.
- *"¿Los parámetros qué son por dentro?"* → Comandos parametrizados (prepared statements): el SQL llega fijo a la base y los valores por un canal separado. Con ese nivel alcanza; no hace falta profundizar en el protocolo de SQLite.

## Ajustes

- **Si se traba con la query string:** versión equivalente por ruta, `GET /patients/search/{lastName}` con firma `(string lastName)`, mismo handler. Validar el resto igual y retomar la query string en la puesta en común (es el formato que más van a usar para búsquedas).
- **Si avanza con facilidad:** filtro combinado en un solo endpoint, `WHERE city = @City AND last_name LIKE @Pattern` con `new { City = city, Pattern = "%" + term + "%" }` (dos parámetros en el mismo objeto anónimo). Otra extensión: agregar `LIMIT 10` y discutir por qué devolver 258 filas crudo no es una buena API.
- **Error conceptual a vigilar:** creer que el objeto anónimo "arma el SQL". No lo arma: completa marcadores. El texto SQL es siempre el mismo, venga el valor que venga.
- **Nota técnica pendiente (no abrir hoy):** si algún alumno agrega `birth_date` al DTO, mapear como `string` por ahora; el tipado fuerte de fechas (DateOnly) se retoma más adelante. Evitar que se frustren con un error de mapeo fuera del alcance del encuentro.

## Recordatorio operativo

Verificar que cada estudiante cierre con commit y push (rutina desde el Encuentro 5): `git add .` → `git commit -m "Clase 12: filtros WHERE con parámetros y búsquedas con LIKE"` → `git push`.
