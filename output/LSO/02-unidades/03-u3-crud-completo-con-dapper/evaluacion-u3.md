# Evaluación de la Unidad 3 — CRUD completo con Dapper

## Metadatos

| Campo | Valor |
|---|---|
| Asignatura | Minimal API con C# .NET 6 |
| Unidad | U3: CRUD completo con Dapper |
| Encuentro de evaluación | 26 (dedicado) |
| Tipo | Entrega grupal por GitHub + defensa individual |
| Modalidad | Grupal (2-3 integrantes), defensa individual |
| Duración del encuentro | 240 minutos |
| Duración de la defensa | Hasta 10 minutos por integrante |
| Criterio de aprobación | 60/100 en la entrega + defensa satisfactoria |

## Objetivos de evaluación

- Implementar los cuatro verbos HTTP (GET, POST, PUT, DELETE) sobre una tabla de la base `hospital.db`.
- Validar datos de entrada y devolver `400 Bad Request` con mensaje en español cuando corresponda.
- Verificar existencia del recurso antes de actualizar o eliminar, devolviendo `404` cuando no existe.
- Usar `ExecuteScalar<long>` para INSERT con devolución del ID generado.
- Usar `Execute` para UPDATE y DELETE con control de filas afectadas.
- Implementar un endpoint con JOIN triple para combinar tres tablas.
- Mantener los tipos canónicos y la estructura de `Program.cs` establecidas en las unidades anteriores.
- Publicar en GitHub con la carpeta `tp-u3/`, `.gitignore` y commit semántico.
- Explicar y defender el código durante la defensa individual.

## Formato de entrega

1. **Antes de la defensa (encuentro 26):** cada grupo debe tener en GitHub la carpeta `tp-u3/` con el proyecto completo y funcional.
2. **Defensa individual:** cada integrante ejecuta la API, prueba endpoints de escritura y lectura, y explica el flujo de un POST o un JOIN triple.
3. **Devolución:** el encuentro siguiente (encuentro 27, inicio de U4) abre con devolución.

## Rúbrica de evaluación (100 puntos)

### Funcionalidad técnica (55 puntos)

| Criterio | Puntos | Descripción |
|---|---|---|
| GET /list (lista completa) | 5 | Devuelve todos los registros |
| GET /list/{id:long} (búsqueda por ID) | 5 | 200 si existe, 404 si no |
| POST /list (crear) | 12 | Crea con validación, devuelve 201 con URL |
| PUT /list/{id:long} (actualizar) | 12 | Actualiza si existe, 404 si no, 204 si ok |
| DELETE /list/{id:long} (eliminar) | 6 | Elimina si existe, 404 si no, 204 si ok |
| GET /relation/{id:long} (JOIN triple) | 15 | Endpoint de lectura con JOIN entre tres tablas |

### Calidad del código (25 puntos)

| Criterio | Puntos | Descripción |
|---|---|---|
| IDs como `long` | 5 | Sin `int` en ningún record |
| Fechas como `string` | 3 | Sin `DateTime` ni `DateOnly` |
| Nulables con `?` | 3 | `string?`, `long?` donde corresponda |
| Alias `AS` en todas las columnas | 4 | Todas las columnas tienen alias PascalCase |
| Registros después de `app.Run()` | 3 | Sin tipos antes del código ejecutable |
| `Results.Created` en POST | 2 | Código 201 con URL del recurso creado |
| `Results.NoContent` en PUT/DELETE | 2 | Código 204 (no 200) |
| `using` en cada conexión | 3 | Conexiones dentro del bloque del endpoint |

### Git y entrega (20 puntos)

| Criterio | Puntos | Descripción |
|---|---|---|
| Carpeta `tp-u3/` | 5 | Proyecto en `tp-u3/` |
| `.gitignore` | 5 | Incluye `bin/` y `obj/` |
| Commit semántico | 5 | `"tp-u3: CRUD completo con Dapper"` |
| Push exitoso | 5 | Commit en GitHub |

### Defensa individual (aprobación aparte)

Obligatoria. Requisito: 60/100 + defensa satisfactoria.

## Criterio de aprobación

- **Nota de entrega:** puntaje sobre 100 según rúbrica.
- **Aprobación:** 60 puntos o más **y** defensa satisfactoria.
- **Recuperación:** instancias de intensificación (encuentros 34-35 y diciembre/marzo).