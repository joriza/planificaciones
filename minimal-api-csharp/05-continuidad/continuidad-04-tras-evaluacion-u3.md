# Continuidad pedagógica 4 — Repaso acumulativo tras la evaluación de la Unidad 3

> Curso «Minimal API con C# .NET 6». Documento de continuidad pedagógica: actividades de repaso y fijación para una clase sin presencia docente. Se entrega a la administración junto con su anexo docente (`continuidad-04-tras-evaluacion-u3-anexo-docente.md`), de uso exclusivo docente.

## 1. Datos de referencia

| Campo | Detalle |
| --- | --- |
| Curso | Minimal API con C# .NET 6 |
| Documento | Continuidad pedagógica 4 de 4 |
| Momento de uso | Tras la evaluación de la Unidad 3 (aplicable desde el encuentro 27). Repaso acumulativo con énfasis en la Unidad 3 y repaso liviano de la Unidad 2 |
| Duración teórica | 240 minutos (4 horas reloj) |
| Condiciones | Sin presencia docente; resolución en los grupos de trabajo habituales; presentación individual y manuscrita al inicio de la próxima clase |
| Requisitos | PC por grupo con SDK de .NET 6 y VS Code; terminal; navegador; archivo `hospital.db` (copia de la institución o del grupo); papel y lápiz para la presentación manuscrita |
| Uso del celular | No permitido |
| Contenidos que repasa | Unidad 3: JOIN triple, agregaciones COUNT/AVG/SUM con GROUP BY, subconsulta escalar correlacionada, datos sucios (`NULL` = aún internado, typos de diagnóstico, alta errónea de 1971), `appsettings.json` y publicación con `dotnet publish`. Unidad 2 (repaso liviano): conexión, SELECT con alias `AS`, parametrización y patrón de existencia con 404 |
| Registro | Docente formal (documento institucional) |

## 2. Objetivos

Al finalizar la jornada, cada estudiante puede:

1. Reconstruir el entorno de trabajo de la unidad y el patrón de lectura por id con 404 con mensaje (repaso de la Unidad 2).
2. Construir endpoints compuestos con JOIN triple, DTO compuesto y verificación previa de existencia.
3. Responder preguntas de números con COUNT, AVG y SUM sobre GROUP BY, con orden y corte sobre el agregado.
4. Escribir una subconsulta escalar correlacionada y tratar los datos sucios de la base con `IS NULL`, `COALESCE` y filtros de auditoría.
5. Externalizar la cadena de conexión a `appsettings.json`, publicar la API con `dotnet publish` y verificar el despliegue local.

## 3. Actividades (100 puntos; 240 minutos)

Las actividades se resuelven en grupo sobre una única API que crece por hitos dentro de un mismo proyecto. El puntaje de cada actividad se obtiene por verificación de funcionamiento y por lo presentado en la entrega manuscrita individual. Si un grupo no completa todas las actividades, presenta lo alcanzado: cada actividad se corrige por separado.

| Nº | Actividad | Consigna | Puntos | Tiempo |
| --- | --- | --- | --- | --- |
| 1 | Puesta a punto y repaso liviano de la Unidad 2 | En una carpeta nueva `continuidad-u3` (no hace falta estar dentro del repositorio del grupo): crear el proyecto con `dotnet new web`, copiar `hospital.db` junto al `.csproj` y agregar los paquetes `Microsoft.Data.Sqlite` y `Dapper` con `dotnet add package`. Construir el patrón de lectura de la Unidad 2: `GET /patients/{id:long}` con `QueryFirstOrDefault` mapeado al record `Patient`, SELECT con los alias `AS`, consulta parametrizada (`WHERE patient_id = @id` + `new { id }`) y 404 con mensaje si el id no existe. Probar un id real y uno inexistente (por ejemplo 9999). Presentación manuscrita: las dos respuestas obtenidas y, en dos líneas, por qué el id se declara `long` y la fecha `string`. | 10 | 30 min |
| 2 | JOIN triple y endpoints compuestos | Agregar `GET /admissions/full`: JOIN triple `FROM admissions a JOIN patients p ON a.patient_id = p.patient_id JOIN doctors d ON a.attending_doctor_id = d.doctor_id`, con cada columna calificada por su alias de tabla, los nombres del paciente y del médico armados en el SELECT concatenando nombre, un espacio y apellido (el nombre completo viaja como una columna más, con su alias `AS`), y el record compuesto `AdmissionDetail` con una propiedad por columna. Ordenar por `a.admission_date DESC`. Después agregar `GET /doctors/{id:long}/admissions`: primero verificar que el médico exista con `ExecuteScalar` sobre su id (404 con mensaje si devuelve 0) y solo entonces el mismo JOIN triple filtrado por `a.attending_doctor_id = @id`. Presentación manuscrita: la cadena de relaciones escrita a mano (dos flechas desde `admissions` hacia `patients` y `doctors`, con las columnas de cada `ON`) y el record `AdmissionDetail` copiado. | 20 | 45 min |
| 3 | Agregaciones con GROUP BY | Agregar tres endpoints de estadística: (1) `GET /stats/admissions-by-specialty` con `COUNT(*) AS TotalAdmissions` y `GROUP BY d.specialty`, ordenado por el total descendente; (2) `GET /stats/top-doctors/{top:int}` con `GROUP BY d.doctor_id`, `ORDER BY TotalAdmissions DESC` y `LIMIT @top` parametrizado; (3) `GET /stats/stay` con `COUNT(*)`, `ROUND(AVG(...), 1)` y `SUM` sobre `julianday(discharge_date) - julianday(admission_date)`, excluyendo los ingresos sin alta con `WHERE discharge_date IS NOT NULL`. Completar el Cuadro 1 de la sección 4.3. Presentación manuscrita: el cuadro completo y la consulta del endpoint del promedio. | 20 | 50 min |
| 4 | Subconsulta simple | Agregar `GET /patients/multiple-admissions/{min:int}`: por cada paciente, una subconsulta escalar correlacionada cuenta SUS ingresos (`SELECT COUNT(*) FROM admissions a WHERE a.patient_id = p.patient_id`); ese conteo viaja como columna (`AS AdmissionCount`) y como filtro comparando ese conteo con el valor de la ruta (`@min`), con el resultado ordenado por el conteo descendente. Probar con `/patients/multiple-admissions/2`. Presentación manuscrita: la consulta completa copiada y, en dos líneas, la explicación de por qué la subconsulta es «correlacionada». | 15 | 35 min |
| 5 | Datos sucios de la base real | Agregar dos endpoints de auditoría y control de calidad: (1) `GET /admissions/open` con `WHERE a.discharge_date IS NULL` (los pacientes aún internados) y `COALESCE(a.diagnosis, 'Sin diagnostico')` para no exponer diagnósticos nulos, con el nombre del paciente concatenado en el SELECT con el operador de concatenación de SQL; (2) `GET /admissions/strange-discharges` con `WHERE a.discharge_date IS NOT NULL` y la condición de alta imposible expresada en el WHERE: fecha de alta anterior a la de ingreso, o alta con fecha de 1971 (`LIKE '1971-%'`). Completar el Cuadro 2 de la sección 4.3. Presentación manuscrita: el cuadro completo y las respuestas a: ¿qué significa que `discharge_date` sea `NULL`?; ¿por qué una alta de 1971 no puede ser un dato verdadero? | 20 | 45 min |
| 6 | Configuración y publicación | Mover la cadena de conexión a `appsettings.json` (sección `ConnectionStrings`, clave `Hospital`) y leerla con `builder.Configuration["ConnectionStrings:Hospital"] ?? "Data Source=hospital.db"` antes de `builder.Build()`. Publicar con `dotnet publish -c Release`, copiar `hospital.db` a la carpeta publish, correr la API publicada con `dotnet ./continuidad-u3.dll` y probar los endpoints en el puerto que informe `Now listening on:` (nunca asumir el de desarrollo). Presentación manuscrita: la secuencia completa de comandos de publicación tal como se ejecutaron, el archivo `appsettings.json` completo y el checklist de despliegue con cada verificación marcada. | 15 | 35 min |
| | **Total** | | **100** | **240 min** |

## 4. Material de apoyo para las actividades

### 4.1 Recordatorios del canon del curso

| Tema | Regla del curso |
| --- | --- |
| Respuestas | Siempre con `Results`: `Results.Ok(...)` (200) y `Results.NotFound(new { mensaje = ... })` (404); con tres tablas, la calificación con alias (`a.`, `p.`, `d.`) es obligatoria |
| Tipos | Ids `long`; fechas `string` en ISO `yyyy-MM-dd`; conteos `int`; promedios `double` |
| Mapeo | Cada columna del SELECT con su alias `AS` hacia la propiedad del record; los records van SIEMPRE al final, después de `app.Run()` |
| Parametrización | Hueco `@nombre` en el SQL + `new { ... }`; también el `LIMIT` se parametriza |
| Agregaciones | El SELECT de una agregación solo lleva la columna del `GROUP BY` y agregados (`COUNT`, `AVG`, `SUM`); el orden por el agregado es `ORDER BY TotalAdmissions DESC` |
| NULL | No es cero ni texto vacío: se busca con `IS NULL` / `IS NOT NULL` y se reemplaza al exponer con `COALESCE` |
| Configuración | La cadena de conexión es configuración, no lógica: vive en `appsettings.json` y se lee con `??` como valor por defecto |
| Comentarios | En español, sin tildes ni eñes, explicando cada acción |

### 4.2 Configuración y comandos de publicación

`appsettings.json` queda con la sección `ConnectionStrings` al principio (las comas separan las secciones):

```json
{
  "ConnectionStrings": {
    "Hospital": "Data Source=hospital.db"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*"
}
```

Secuencia de publicación (parados en la carpeta del proyecto, donde está el `.csproj`; `Copy-Item` sube cuatro niveles hasta la raíz del proyecto, donde está `hospital.db`):

```powershell
dotnet publish -c Release
cd bin\Release\net6.0\publish
Copy-Item ..\..\..\..\hospital.db .
dotnet ./continuidad-u3.dll
```

Leer la línea `Now listening on:` del proceso publicado (típicamente el puerto 5000) y probar los endpoints contra ese puerto.

### 4.3 Cuadros para completar a mano

**Cuadro 1 — Actividad 3: agregaciones.**

| Pregunta del hospital | Función de agregación | GROUP BY |
| --- | --- | --- |
| ¿Cuántos ingresos hubo por especialidad? | | |
| ¿Qué médicos atendieron más ingresos? (Top N) | | |
| ¿Cuánto dura en promedio una internación con alta? | | |
| ¿Cuántos pacientes hay por sexo? | | |

**Cuadro 2 — Actividad 5: datos sucios.**

| Hallazgo en la base | Herramienta SQL | Qué significa para el paciente |
| --- | --- | --- |
| Ingreso sin fecha de alta (`NULL`) | | |
| Diagnóstico mal tipeado («Stomache Pain») | | |
| Alta en 1971 o previa al ingreso | | |

## 5. Autoevaluación del alumno

Cada estudiante completa esta autoevaluación al cierre de la jornada y la adjunta a su presentación manuscrita. Marcar una sola columna por fila; las filas en «Todavía no» son la consulta prioritaria para la próxima clase.

| Nº | Puedo... | Con confianza | Con dudas | Todavía no |
| --- | --- | --- | --- | --- |
| 1 | Reconstruir el proyecto con `hospital.db` y el patrón de lectura por id con 404 | | | |
| 2 | Escribir un JOIN triple con alias calificados y armar los nombres en el SELECT | | | |
| 3 | Responder preguntas de números con COUNT, AVG y GROUP BY, con orden y corte | | | |
| 4 | Escribir una subconsulta escalar correlacionada y explicar qué hace | | | |
| 5 | Tratar `NULL` con `IS NULL` y `COALESCE`, y nombrar los datos sucios de la base | | | |
| 6 | Pasar la cadena de conexión a `appsettings.json` y leerla con `??` | | | |
| 7 | Publicar con `dotnet publish`, copiar la base y correr la API publicada | | | |
| 8 | Completar el checklist de despliegue sin saltear ninguna verificación | | | |

Preguntas de cierre (respuestas breves, a mano):

1. ¿Qué actividad me costó más y por qué?
2. ¿Qué dato sucio de la base me sorprendió más y por qué?
3. ¿Qué quiero consultarle al docente cuando vuelva a clase?

## 6. Nota

**Nota (registro académico).** La resolución se realiza en forma habitual (por lo general, en grupo); las tareas de programación requieren el uso de la computadora; la presentación es individual y manuscrita, al inicio de la próxima clase, y constituye una actividad más de la asignatura que forma parte del proceso de evaluación.

Las soluciones completas y los criterios de corrección de esta continuidad constan únicamente en el anexo docente separado (`continuidad-04-tras-evaluacion-u3-anexo-docente.md`), de uso exclusivo docente.
