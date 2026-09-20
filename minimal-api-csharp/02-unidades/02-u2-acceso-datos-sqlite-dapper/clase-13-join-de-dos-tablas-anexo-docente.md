# Anexo docente — Encuentro 13: JOIN de dos tablas y GET con datos reales

> Material de uso interno docente. No se distribuye a estudiantes.
> Curso: Desarrollo de APIs con C# .NET 6 (Minimal API) · Unidad 2 — Acceso a datos con SQLite y Dapper

## Encuadre

| Campo | Detalle |
| --- | --- |
| Encuentro | 13 — «JOIN de dos tablas / Consulta con relación» y «Pacientes y provincias / GET con datos reales» (planificación anual) |
| Ejercicio evaluado | `GET /provinces` (SELECT simple sobre la tabla de referencia) y `GET /patients/by-province-name?term=` (JOIN + LIKE sobre la tabla relacionada) |
| Momento del bloque | Ejercicio independiente (55 min) + puesta en común y cierre (20 min) |
| Insumos | Proyecto `HospitalApi` de la práctica guiada funcionando, con `hospital.db` en la raíz y los paquetes Microsoft.Data.Sqlite + Dapper instalados |

## Preparación previa (gestión del aula)

- Ejecutar antes de clase las consultas del encuentro y anotar cantidades reales: cuántos pacientes hay por provincia (especialmente Nova Scotia para `term=Nova`) y qué provincia corresponde al `patient_id = 1`, para validar salidas en vivo.
- Tener el esquema a mano (las 13 provincias y la relación `patients.province_id → province_names.province_id`): dibujarlo en el pizarrón como dos columnas unidas por una flecha antes de mostrar el SQL del JOIN.
- Verificar que los equipos arrancan con la clase 12 digerida: el ejercicio reutiliza el WHERE con parámetro y el LIKE. Detectar temprano quién arrastró la concatenación de strings de antes.

## Solución esperada

Ambos endpoints van en el `Program.cs` de la práctica. El punto 1 necesita su propio record, junto al `PatientWithProvince` del final del archivo:

```csharp
// DTO para la tabla de referencia: el codigo y el nombre de la provincia.
record Province(string ProvinceId, string ProvinceName);
```

Endpoint del punto 1 (sin JOIN: una sola tabla, 13 filas):

```csharp
// Solucion del ejercicio (1): la tabla de referencia completa.
app.MapGet("/provinces", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var provinces = connection.Query<Province>(@"
        SELECT province_id AS ProvinceId,
               province_name AS ProvinceName
        FROM province_names
        ORDER BY province_name").ToList();

    return Results.Ok(provinces);
});
```

Endpoint del punto 2 (JOIN de la práctica + LIKE de la clase 12 sobre la tabla relacionada):

```csharp
// Solucion del ejercicio (2): pacientes filtrando por el NOMBRE de la provincia.
app.MapGet("/patients/by-province-name", (string term) =>
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
        WHERE pn.province_name LIKE @Pattern
        ORDER BY p.last_name, p.first_name",
        // El patron se arma en el valor: el SQL sigue siendo fijo.
        new { Pattern = "%" + term + "%" }).ToList();

    return Results.Ok(patients);
});
```

Pedidos de prueba:

```http
### Las 13 provincias (esperar 200)
GET http://localhost:5080/provinces

### Pacientes de Nova Scotia (esperar 200 con las filas de NS)
GET http://localhost:5080/patients/by-province-name?term=Nova

### Termino sin coincidencias (esperar 200 con [])
GET http://localhost:5080/patients/by-province-name?term=Atlantis
```

Respuestas esperadas:

- `/provinces` → 200 con exactamente 13 filas (Alberta, British Columbia, Manitoba, New Brunswick, Newfoundland and Labrador, Northwest Territories, Nova Scotia, Nunavut, Ontario, Prince Edward Island, Quebec, Saskatchewan, Yukon). Es la salida más verificable del encuentro: 13 es 13.
- `/patients/by-province-name?term=Nova` → 200 solo con pacientes de "Nova Scotia" ("Newfoundland..." y "New Brunswick" no contienen "nova": el comodín exige el texto completo en cualquier posición). La cantidad de filas depende de los datos; anotarla en la preparación previa.
- `/patients/by-province-name?term=Atlantis` → 200 con `[]`: búsqueda válida, sin coincidencias.

Detalles clave de la solución:

- El punto 2 evalúa la integración de los tres conceptos del bloque U2: JOIN calificado (`pn.province_name`), patrón LIKE en el valor y DTO combinado reutilizado. Quien defina un DTO nuevo con propiedades repetidas está copiando sin entender.
- Si alguien pregunta por filtrar por código (`/patients/by-province/ON`), es el mismo endpoint cambiando el WHERE a `pn.province_id = @Code`: buen cierre para mostrar que filtrar por columna de la tabla relacionada es idéntico.

## Criterios de logro

| # | Criterio | Evidencia observable |
| --- | --- | --- |
| 1 | `GET /provinces` responde 200 con exactamente 13 filas | El conteo coincide con la tabla de referencia |
| 2 | DTO propio con alias AS correctos | El JSON muestra `provinceId` y `provinceName` completos (no nulos) |
| 3 | `GET /patients/by-province-name?term=Nova` devuelve el DTO combinado | Cada fila muestra datos del paciente + `provinceName: "Nova Scotia"` |
| 4 | El filtro usa JOIN calificado + patrón en el valor | `WHERE pn.province_name LIKE @Pattern` con `new { Pattern = "%" + term + "%" }` |
| 5 | Búsqueda sin coincidencias responde 200 con `[]` | `term=Atlantis` responde 200, no 404 |
| 6 | Cierre con rutina Git | `git log` muestra el commit "Clase 13: JOIN de dos tablas y GET con datos reales" y el push al remoto |

## Qué observar en el aula

- **El experimento de la columna ambigua (paso 7) es el corazón del encuentro.** Verlo ocurrir, leer el mensaje y corregirlo vale más que tres explicaciones. Verificar que TODOS lo provocan: es seguro (no toca datos) y enseña a diagnosticar errores del motor, no solo del compilador.
- **Verificación visual del JOIN en la práctica:** en `/patients/with-province`, pedir que comparen la fila del `patient_id = 1` con lo que muestra un navegador de SQLite. El `provinceName` de la API y el `province_id` de la tabla deben contar la misma historia: acá se "ve" la traducción del cuaderno de códigos.
- **Sondeo rápido:** ¿qué pasa si se borra el `ON`? (producto cruzado: 258 × 13 filas). ¿Qué columna es la ambigua y por qué? (`province_id`, existe en las dos tablas). ¿Dónde va el `%`? (en el valor, no en el SQL).
- **Señal de alerta:** respuesta con miles de filas o `provinceName: null` en todas las filas. La primera es producto cruzado (falta el `ON`); la segunda es alias AS faltante en la columna de la tabla relacionada.
- **No abrir el JOIN triple hoy.** Alguien va a preguntar "¿y tres tablas?". Responder que es la misma mecánica encadenada y que llega con la unidad siguiente; cortar ahí para no fragmentar la práctica.

## Errores previsibles y respuestas

- *`no such table: province_name`* → Nombre escrito de memoria. La tabla es `province_names` (plural). Volver al esquema: los nombres de tablas y columnas no se improvisan.
- *`ambiguous column name`* → Columna sin calificar dentro del JOIN. Regla del encuentro: todo identificador de columna lleva alias de tabla.
- *DTO combinado con `provinceName` en `null`* → Falta `pn.province_name AS ProvinceName` en el SELECT, o la propiedad no está en el record. El mapeo de Dapper es por nombre.
- *"¿Por qué el ejercicio 1 no lleva JOIN?"* → Porque `provinces` lee una sola tabla: el JOIN aparece cuando los datos pedidos viven en dos. Pregunta valiosa: revela si distinguen "consultar una tabla" de "combinar dos".
- *"¿El INNER JOIN descarta filas?"* → Sí: un paciente cuyo `province_id` no existiera en `province_names` no aparecería. En hospital.db no ocurre porque la clave foránea garantiza la correspondencia; mencionarlo y dejar la comparación con LEFT JOIN para más adelante.
- *"¿Dónde quedó el código 'ON' en el JSON?"* → El DTO decidió exponer la traducción. Para devolver ambos, agregar la columna calificada y la propiedad al record (mostrarlo en dos minutos, es la extensión natural del DTO).

## Ajustes

- **Si se traba con el JOIN:** volver al pizarrón, no al código: dos columnas (códigos de patients a la izquierda, códigos+nombre de province_names a la derecha), flechas por igualdad, y recién entonces relectura del SQL línea por línea. El alias `p`/`pn` confunde a veces: pueden renombrarse a `pa`/`prov` si ayuda, sin cambiar nada más.
- **Si avanza con facilidad:** agregar al endpoint por id una extensión del DTO con el código (`pn.province_id AS ProvinceId` + propiedad `ProvinceId`), o adelantar el enlace `admissions + doctors` (`attending_doctor_id → doctor_id`) en papel, que es la misma mecánica con otras tablas.
- **Error conceptual a vigilar:** creer que el JOIN "modifica las tablas". Es de solo lectura: combina filas en el resultado, no toca los datos. Si aparece la duda, mostrar que un navegador de SQLite hace el mismo JOIN sin que la base cambie.
- **Nota técnica pendiente (no abrir hoy):** si algún alumno agrega `birth_date` al DTO, mapear como `string` por ahora; el tipado fuerte de fechas (DateOnly) se retoma más adelante.

## Recordatorio operativo

Verificar que cada estudiante cierre con commit y push (rutina desde el Encuentro 5): `git add .` → `git commit -m "Clase 13: JOIN de dos tablas y GET con datos reales"` → `git push`.
