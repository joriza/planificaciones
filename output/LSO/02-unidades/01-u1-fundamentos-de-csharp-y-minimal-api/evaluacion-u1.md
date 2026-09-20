# Evaluación de la Unidad 1 — Fundamentos de C# y Minimal API

## Metadatos

| Campo | Valor |
|---|---|
| Asignatura | Minimal API con C# .NET 6 |
| Unidad | U1: Fundamentos de C# y Minimal API |
| Encuentro de evaluación | 9 (dedicado) |
| Tipo | Entrega grupal por GitHub + defensa individual |
| Modalidad | Grupal (2-3 integrantes), defensa individual |
| Duración del encuentro | 240 minutos |
| Duración de la defensa | Hasta 10 minutos por integrante |
| Criterio de aprobación | 60/100 en la entrega + defensa satisfactoria |

## Objetivos de evaluación

- Construir una Minimal API funcional con endpoints GET sobre una lista en memoria.
- Aplicar correctamente la estructura canónica de `Program.cs` (top-level statements, registros al final).
- Manejar parámetros de ruta y query string para filtrar resultados.
- Devolver respuestas HTTP canónicas (`Results.Ok`, `Results.NotFound`) con mensajes en español.
- Publicar el trabajo en GitHub con la carpeta `tp-u1/`, `.gitignore`, y un commit semántico.
- Explicar y defender el código producido durante la defensa individual.

## Formato de entrega

1. **Antes de la defensa (encuentro 9):** cada grupo debe tener su repositorio GitHub actualizado con la carpeta `tp-u1/` conteniendo el proyecto completo (`Program.cs`, `.gitignore`, `.csproj`). La base `hospital.db` no aplica a la U1.
2. **Defensa individual:** cada integrante (hasta 10 minutos) ejecuta la API, prueba dos endpoints asignados por el docente, y explica una sección de código elegida al momento.
3. **Devolución:** el encuentro siguiente (encuentro 10) abre con la devolución de resultados.

## Estructura general de la evaluación

El docente asigna a cada grupo una versión (A o B) al inicio del encuentro 9. Ambas versiones tienen los mismos requisitos y puntaje; cambia únicamente el dominio de datos (una versión trabaja sobre pacientes, la otra sobre doctores). Ninguna versión tiene reglas que la otra no tenga.

### Requisitos comunes (ambas versiones)

- Proyecto creado con `dotnet new web`.
- Archivo único `Program.cs` con top-level statements.
- Lista de datos en memoria (mínimo 6 registros).
- Los registros (records posicionales) al final del archivo, después de `app.Run()`.
- Todos los IDs declarados como `long` (nunca `int`).
- Todas las fechas como `string` (nunca `DateTime` ni `DateOnly`).
- Campos nulables declarados con `?` (`string?`, `long?`).
- Respuestas con `Results.Ok`, `Results.NotFound` y `new { mensaje = "..." }`.
- Archivo `.gitignore` con `bin/` y `obj/`.
- Commit con mensaje semántico en español sin tildes.

## Rúbrica de evaluación (100 puntos)

### Funcionalidad técnica (55 puntos)

| Criterio | Puntos | Descripción |
|---|---|---|
| GET /list (lista completa) | 10 | Devuelve 200 con la lista completa de elementos |
| GET /list?gender=X (filtro por género) | 10 | Filtra correctamente por el parámetro query string |
| GET /list/{id:long} (búsqueda por ID) | 10 | Devuelve 200 con el elemento o 404 con mensaje si no existe |
| GET /list/count (conteo total) | 5 | Devuelve JSON con el total de elementos |
| GET /list/older-than?age=N (filtro por edad) | 10 | Filtra por edad calculada desde la fecha de nacimiento |
| Endpoint extra a elección del grupo | 10 | Endpoint adicional que demuestre comprensión (ordenado por apellido, filtro por especialidad, etc.) |

### Calidad del código (25 puntos)

| Criterio | Puntos | Descripción |
|---|---|---|
| IDs como `long` en los records | 5 | Todos los IDs son `long`, ningún `int` |
| Fechas como `string` en los records | 5 | Todas las fechas son `string`, ningún `DateTime` |
| Campos nulables con `?` | 5 | `string?` y `long?` donde corresponda |
| Records después de `app.Run()` | 5 | Ningún record antes de `app.Run()` |
| Respuestas con `Results.*` | 5 | Todos los endpoints envuelven la respuesta con `Results.Ok()` o `Results.NotFound()` |

### Git y entrega (20 puntos)

| Criterio | Puntos | Descripción |
|---|---|---|
| Carpeta `tp-u1/` en el repositorio | 5 | El proyecto está en `tp-u1/`, no en la raíz ni en otra ubicación |
| `.gitignore` presente | 5 | Incluye `bin/` y `obj/` |
| Commit con mensaje semántico | 5 | Mensaje en español sin tildes: `"tp-u1: <resumen>"` |
| Push exitoso | 5 | El commit aparece en GitHub |

### Defensa individual (punto de aprobación aparte)

La defensa es obligatoria y se evalúa como **satisfactoria / insatisfactoria**. Para aprobar la unidad, el alumno debe obtener **60/100 o más** en la entrega **y** una defensa satisfactoria. Una defensa insatisfactoria no se compensa con puntos de la entrega.

| Aspecto | Satisfactorio | Insatisfactorio |
|---|---|---|
| Ejecución de la API | Puede ejecutar `dotnet run` y probar endpoints en vivo | No logra ejecutar o probar la API |
| Explicación del código | Explica el bloque asignado (record, endpoint, filtro) con precisión técnica | No reconoce su propio código o no puede explicarlo |
| Preguntas conceptuales | Responde correctamente al menos 2 preguntas del docente | Responde 0-1 preguntas |

## Criterio de aprobación

- **Nota de entrega:** puntaje sobre 100 según la rúbrica.
- **Aprobación:** 60 puntos o más en la entrega **y** defensa individual satisfactoria.
- **Entrega incompleta:** si el grupo entrega pero falta alguno de los endpoints obligatorios (GET /list, GET /list/{id}, GET /list/count), la entrega se considera incompleta y el puntaje máximo es 50.
- **Recuperación:** los alumnos que no aprueben la U1 tienen las instancias de intensificación (encuentros 17-18 y diciembre/marzo) para recuperar los objetivos mínimos.