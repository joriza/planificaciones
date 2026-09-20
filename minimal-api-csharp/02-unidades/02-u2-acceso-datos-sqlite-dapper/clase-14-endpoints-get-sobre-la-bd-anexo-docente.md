# Anexo docente — Encuentro 14: Endpoints GET sobre la BD y cierre de la Unidad 2

> Material de uso interno docente. No se distribuye a estudiantes.
> Curso: Desarrollo de APIs con C# .NET 6 (Minimal API) · Unidad 2 — Acceso a datos con SQLite y Dapper

## Encuadre

| Campo | Detalle |
| --- | --- |
| Encuentro | 14 — «Endpoints GET sobre la BD / Migración de endpoints» + «Cierre de la Unidad 2 / Preparación del tp-u2» (planificación anual) |
| Ejercicio evaluado | Los tres endpoints de médicos del ejercicio independiente + estado del repositorio (commits y push) |
| Momento del bloque | Ejercicio independiente (55 min) + puesta en común y cierre (20 min) |
| Insumos | Proyecto `HospitalApi` de la clase 13 (continúa, no se crea uno nuevo), `hospital.db` en la raíz, mini-proyecto `AdmisionApi` de la clase 8 como referencia del patrón en memoria |

## Qué observar en la práctica guiada

- **Traducción sin ayuda:** quien pasa de `FirstOrDefault(x => x.Id == id)` a `WHERE patient_id = @Id` + `new { Id = id }` sin mirar la teoría está en condiciones firmes para el tp-u2.
- **Reutilización del DTO:** verificar que reutilizan `PatientWithProvince` (declarado en la clase 13) y solo agregan `AdmissionWithDoctor`. Quien vuelve a declarar el record existente obtiene el error CS0101 (tipo duplicado): momento para explicar por qué el archivo ya lo tiene.
- **Alias alineado:** mientras se escribe cada SELECT, pedir que nombren en voz alta columna → propiedad del record. Quien copia el SQL sin leer los alias es riesgo de defensa: no puede justificar qué mapea a qué.
- **404 real:** exigir la prueba con un Id inexistente (9999) antes de dar cada paso por cerrado; el camino feliz solo no basta.
- **Distinción clave:** preguntar explícitamente "un paciente existe pero no tiene ingresos: ¿404 o 200 con arreglo vacío?" y pedir justificación. Es pregunta probable de defensa.
- **Micro-rutina del SELECT verbalizada:** qué columnas → de qué tablas → qué filtro → qué alias. Si el grupo la recita sin ayuda, la migración quedó aprendida como método y no como copia.

## Solución del ejercicio independiente

Los endpoints se agregan al mismo `Program.cs` de la práctica guiada; los records van al final del archivo, junto a los otros DTO:

```csharp
// DTOs del recurso doctors (declaraciones al final del archivo, junto a los otros records).
record Doctor(long DoctorId, string FirstName, string LastName, string Specialty);
record PatientBrief(long PatientId, string FirstName, string LastName, string Gender);

// 1) Listado de medicos: mismo patron que /patients, cambia la tabla.
app.MapGet("/doctors", () =>
{
    using var connection = new SqliteConnection(connectionString);

    var doctors = connection.Query<Doctor>(@"
        SELECT doctor_id AS DoctorId,
               first_name AS FirstName,
               last_name AS LastName,
               specialty AS Specialty
        FROM doctors
        ORDER BY last_name, first_name").ToList();

    return Results.Ok(doctors);
});

// 2) Medico por Id: WHERE con parametro + 404 (identico al patron de patients).
app.MapGet("/doctors/{id:int}", (int id) =>
{
    using var connection = new SqliteConnection(connectionString);

    var doctor = connection.Query<Doctor>(@"
        SELECT doctor_id AS DoctorId,
               first_name AS FirstName,
               last_name AS LastName,
               specialty AS Specialty
        FROM doctors
        WHERE doctor_id = @Id",
        new { Id = id }).FirstOrDefault();

    return doctor is null ? Results.NotFound(new { mensaje = "No existe el medico" })
                          : Results.Ok(doctor);
});

// 3) Desafio: pacientes atendidos por el medico (JOIN + verificacion de existencia).
app.MapGet("/doctors/{id:int}/patients", (int id) =>
{
    using var connection = new SqliteConnection(connectionString);

    var exists = connection.Query<int?>(
        "SELECT doctor_id FROM doctors WHERE doctor_id = @Id",
        new { Id = id }).FirstOrDefault();

    if (exists is null)
    {
        return Results.NotFound(new { mensaje = "No existe el medico" });
    }

    // DISTINCT evita repetir al paciente que tuvo varios ingresos con el mismo medico.
    var patients = connection.Query<PatientBrief>(@"
        SELECT DISTINCT p.patient_id AS PatientId,
               p.first_name AS FirstName,
               p.last_name AS LastName,
               p.gender AS Gender
        FROM admissions a
        JOIN patients p ON p.patient_id = a.patient_id
        WHERE a.attending_doctor_id = @Id
        ORDER BY p.patient_id").ToList();

    // 200 con la lista, aunque venga vacia: el medico existe. 404 solo si no existe.
    return Results.Ok(patients);
});
```

Pruebas en el navegador (reemplazar `5080` por el puerto propio):

- `http://localhost:5080/doctors` → 200 con los 27 médicos, cada uno con `doctorId`, `firstName`, `lastName`, `specialty`, ordenados por apellido.
- `http://localhost:5080/doctors/1` → 200 con el médico; `http://localhost:5080/doctors/999` → 404 con `{"mensaje":"No existe el medico"}` (los Id reales van de 1 a 27).
- `http://localhost:5080/doctors/1/patients` → 200 con la lista de pacientes atendidos, sin repetidos gracias a `DISTINCT`.

Momento de discusión sugerido en la puesta en común: quitar `DISTINCT`, reiniciar y volver a probar. Los pacientes con más de un ingreso atendido por el mismo médico aparecen repetidos: conecta directo con la clave compuesta de `admissions` vista en la teoría del encuentro.

Distinción a evaluar en la defensa: médico existente sin pacientes asignados → 200 con arreglo vacío (no 404).

## Errores previsibles y gestión en el aula

| Error | Señal | Intervención |
| --- | --- | --- |
| Abrir la carpeta equivocada | No existe la variable `connectionString` o no aparecen los endpoints de la clase 13 | Trabajar sobre `HospitalApi`; `AdmisionApi` es solo referencia de lectura |
| `hospital.db` mal ubicado o ausente | `SqliteException`: "unable to open database file" o "no such table: patients" | Verificar que el archivo esté junto al `.csproj`; la ruta relativa se resuelve desde donde corre `dotnet run` |
| Re-declarar `PatientWithProvince` | Error CS0101 al compilar | El record ya existe desde la clase 13: reutilizarlo, declarar solo los nuevos |
| DTO con forma equivocada para `admissions` | Error al materializar la consulta o campos null en el JSON | Cada forma de resultado necesita su record; tipos acordes a SQLite (TEXT → `string`) |
| 404 devuelto cuando la lista viene vacía | Handler responde NotFound aunque el paciente/médico exista | Separar dos preguntas: ¿existe el recurso raíz? (404 si no) y ¿tiene datos? (200 con `[]`) |
| `DISTINCT` omitido en el desafío | Lista con pacientes repetidos | Comparar con y sin `DISTINCT`; aprovechar para repasar la clave compuesta (`patient_id` + `admission_date`) |

## Criterios de logro de cierre de unidad

Lista de verificación de objetivos mínimos de la Unidad 2 (base para el tp-u2 del Encuentro 15):

| # | Objetivo mínimo | Verificación en el proyecto |
| --- | --- | --- |
| 1 | Explica el esquema de hospital.db (4 tablas y relaciones) | Preguntas de defensa sobre patients, admissions, doctors y province_names |
| 2 | Conecta a la BD con `Microsoft.Data.Sqlite` (`Data Source=hospital.db`) | Program.cs con la conexión funcionando por endpoint |
| 3 | Consulta con Dapper `Query<T>` mapeando a record DTO con alias AS | `/patients` y `/doctors` responden JSON correcto |
| 4 | Filtra con `WHERE` + objeto anónimo (sin concatenar) y usa `LIKE` | GET por Id; búsquedas de la clase 12 |
| 5 | Resuelve un JOIN de dos tablas con alias cortos y columnas calificadas | `/patients/{id:int}/admissions` o `/doctors/{id:int}/patients` |
| 6 | Elige el código correcto: 200, 200 con `[]`, 404 | Pruebas con Id válido, Id inexistente y recurso sin datos |
| 7 | Distingue el patrón en memoria del patrón con BD y lo explica | Defensa: correspondencia `List<T>`/tabla, `FirstOrDefault`/`WHERE` |
| 8 | Versiona (commit por encuentro, push) y explica su código | Historial del repositorio + ensayo de defensa en la puesta en común |

## Sugerencia de agrupamiento

- **Duplas mixtas:** quien quedó firme en Dapper (clases 11 y 12) junto a quien quedó firme en JOIN (clase 13); la migración se completa por turnos en la misma máquina.
- **Grupos impares:** tríos con roles rotativos: quien escribe, quien dicta la traducción memoria → BD, quien verifica las salidas contra las esperadas.
- **No agrupar entre sí** a quienes arrastran dudas de la clase 13 (JOIN): necesitan un modelo cerca. Ubicarlos con un firme o con asistencia directa del docente.
- **Puesta en común:** cada dupla muestra un endpoint y anticipa el código de respuesta esperado antes de abrirlo en el navegador.

## Señales de riesgo para el tp-u2 (Encuentro 15)

Riesgo alto si un estudiante, al cierre del Encuentro 14:

- No tiene `/patients/{id:int}` con 404 real funcionando en su proyecto.
- Sigue concatenando valores dentro del SQL en lugar de usar el objeto anónimo.
- No puede explicar la correspondencia `List<T>` / tabla o `FirstOrDefault` / `WHERE`.
- No distingue 404 de 200 con arreglo vacío.
- No tiene commits de la unidad o nunca hizo push al remoto.

Acción sugerida: registrar los nombres, acordar un repaso dirigido antes del Encuentro 15 y dejar constancia en el seguimiento del curso. El tp-u2 exige repositorio funcionando (con `hospital.db` incluido) y git operativo: son requisitos de la entrega y de la defensa.

## Ajustes

- **Grupo que avanza rápido:** agregar `GET /patients/search/{term}` con `LIKE` sobre apellido (el patrón se arma en el valor, como en la clase 12: `@Pattern` + `new { Pattern = "%" + term + "%" }`) o un `LIMIT` en el listado para paginar los primeros N pacientes. Ambos reutilizan lo visto, sin contenido nuevo.
- **Grupo que necesita más apoyo:** consolidar en clase los dos primeros endpoints de la práctica guiada y hacer el de `admissions` paso a paso en el proyector; para el ejercicio independiente, los puntos 1 y 2 son el mínimo y el desafío queda opcional.
- **Puesta en común:** resolver en vivo los errores más frecuentes observados hoy, sobre el proyecto de algún estudiante (con su permiso).

## Recordatorio operativo

Al cierre: verificar en cada máquina que `dotnet run` levanta sin errores y que `/patients` y `/doctors` responden. Confirmar que cada estudiante hizo commit y push del proyecto completo (rutina desde el Encuentro 5): `git add .` → `git commit -m "Clase 14: migracion de endpoints GET a hospital.db (cierre U2)"` → `git push`. Verificar que `hospital.db` figura en el repositorio: la entrega del tp-u2 debe funcionar tras clonar en otra máquina.
