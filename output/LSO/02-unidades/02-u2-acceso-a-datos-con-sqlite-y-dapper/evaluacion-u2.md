# Evaluación de la Unidad 2 — Acceso a datos con SQLite y Dapper

## Metadatos

| Campo | Valor |
|---|---|
| Asignatura | Minimal API con C# .NET 6 |
| Unidad | U2: Acceso a datos con SQLite y Dapper |
| Encuentro de evaluación | 15 (dedicado) |
| Tipo | Entrega grupal por GitHub + defensa individual |
| Modalidad | Grupal (2-3 integrantes), defensa individual |
| Duración del encuentro | 240 minutos |
| Duración de la defensa | Hasta 10 minutos por integrante |
| Criterio de aprobación | 60/100 en la entrega + defensa satisfactoria |

## Objetivos de evaluación

- Construir endpoints GET que consulten la base `hospital.db` usando Dapper y records posicionales.
- Aplicar correctamente alias `AS` en SELECT para mapear snake_case a PascalCase.
- Escribir consultas parametrizadas con `@` y objetos anónimos (nunca concatenar).
- Usar `Query<T>` para listas y `QueryFirstOrDefault<T>` para búsqueda individual.
- Implementar filtros con `LIKE` y búsqueda de texto parcial.
- Realizar JOIN entre dos tablas para combinar datos relacionados.
- Usar los tipos canónicos (`long` para IDs, `string` para fechas, `?` para nulables).
- Publicar el trabajo en GitHub con la carpeta `tp-u2/`, `.gitignore`, y commit semántico.
- Explicar y defender el código durante la defensa individual.

## Formato de entrega

1. **Antes de la defensa (encuentro 15):** cada grupo debe tener su repositorio GitHub actualizado con la carpeta `tp-u2/` conteniendo el proyecto completo (`Program.cs`, `hospital.db` junto al `.csproj`, `.gitignore`). La base `hospital.db` se copia al lado del `.csproj`; no se sube la base al repositorio (se gitignora o se copia manualmente).
2. **Defensa individual:** cada integrante ejecuta la API, prueba dos endpoints asignados y explica un fragmento de código.
3. **Devolución:** el encuentro siguiente (encuentro 17, inicio de intensificación) abre con la devolución de resultados.

## Estructura general de la evaluación

El docente asigna a cada grupo una versión (A o B). Ambas tienen los mismos requisitos de endpoints, puntaje y complejidad; cambia el dominio de datos (A: pacientes con JOIN a provincias; B: doctores con JOIN a admisiones).

### Requisitos comunes (ambas versiones)

- Usar Dapper y `Microsoft.Data.Sqlite`.
- Conexión con `using var connection = new SqliteConnection("Data Source=hospital.db")`.
- Todas las consultas parametrizadas con `@param` y `new { param = valor }`.
- Alias `AS` obligatorios en todas las columnas del SELECT.
- Registros posicionales con tipos canónicos: `long` para PK, `string` para fechas, `?` para nulables.
- Registros después de `app.Run()`.
- Respuestas con `Results.Ok`, `Results.NotFound` y `new { mensaje = "..." }`.
- Proyecto en carpeta `tp-u2/`.
- `.gitignore` con `bin/` y `obj/`.

## Rúbrica de evaluación (100 puntos)

### Funcionalidad técnica (55 puntos)

| Criterio | Puntos | Descripción |
|---|---|---|
| GET /list (lista completa) | 10 | Devuelve 200 con todos los registros ordenados |
| GET /list/{id:long} (búsqueda por ID) | 10 | 200 si existe, 404 con mensaje si no |
| GET /list/by-field/{valor} (búsqueda LIKE) | 10 | Filtra por campo textual con LIKE %valor% |
| GET /list/with-relation (JOIN) | 15 | Cruza con otra tabla usando JOIN |
| GET /resource/{id:long} (recurso relacionado) | 10 | Endpoint sobre la segunda tabla con búsqueda por ID |

### Calidad del código (25 puntos)

| Criterio | Puntos | Descripción |
|---|---|---|
| IDs como `long` | 5 | Sin `int` en ningún record |
| Fechas como `string` | 5 | Sin `DateTime` ni `DateOnly` |
| Campos nulables con `?` | 5 | `string?`, `long?` donde corresponda |
| Alias `AS` en todas las columnas | 5 | Todas las columnas tienen alias PascalCase |
| Registros después de `app.Run()` | 5 | Sin tipos antes del código ejecutable |

### Git y entrega (20 puntos)

| Criterio | Puntos | Descripción |
|---|---|---|
| Carpeta `tp-u2/` en el repositorio | 5 | Proyecto dentro de `tp-u2/` |
| `.gitignore` presente | 5 | Incluye `bin/` y `obj/` |
| Commit semántico | 5 | `"tp-u2: consultas con Dapper y SQLite"` |
| Push exitoso en GitHub | 5 | El commit aparece en el remoto |

### Defensa individual (aprobación aparte)

Ídem U1: obligatoria, satisfactoria/insatisfactoria. Se requiere 60/100 + defensa satisfactoria para aprobar.

## Criterio de aprobación

- **Nota de entrega:** puntaje sobre 100 según rúbrica.
- **Aprobación:** 60 puntos o más en la entrega **y** defensa individual satisfactoria.
- **Entrega incompleta:** si falta alguno de los endpoints obligatorios (lista general, búsqueda por ID, LIKE, JOIN), el puntaje máximo es 50.
- **Recuperación:** instancias de intensificación (encuentros 17-18 y diciembre/marzo).