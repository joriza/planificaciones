# Encuentro 25 — Cierre U3: repaso y TP

## Metadatos de bloque

| Campo | Valor |
|---|---|
| **Duracion** | 240 minutos |
| **Unidad** | 3 — CRUD completo con Dapper |
| **Eje** | 5 — CRUD con Dapper |
| **Tipo** | Actitudinal — cierre de unidad |
| **Requiere** | Unidad 3 completa (encuentros 21-24): POST, DELETE, PUT, JOIN triple |
| **Produccion** | TP-U3: API completa con CRUD sobre dos tablas relacionadas |

## Reparto de tiempos (240 minutos)

| Bloque | Duracion |
|---|---|
| Apertura y motivacion | 20 min |
| Repaso teorico-practico | 50 min |
| Trabajo en el TP-U3 | 120 min |
| Puesta en comun y cierre de unidad | 30 min |
| Cierre | 20 min |

## Objetivos de aprendizaje

- Integrar los cuatro verbos CRUD en una sola API funcional con Dapper y SQLite.
- Implementar un endpoint con JOIN triple que combine `admissions`, `doctors` y `patients`.
- Aplicar la checklist de defectos frecuentes para verificar el codigo antes de la entrega.
- Publicar el TP-U3 en GitHub dentro de la carpeta `tp-u3/` del repositorio grupal.

## Charla rapida / analogia

Imaginate que terminaste de construir tu primera herramienta profesional: una API que puede **crear**, **leer**, **actualizar** y **eliminar** datos de un hospital. Es como tener tu propia llave maestra del sistema de salud digital. Hoy repasamos todo lo que aprendiste, corregimos los errores tipicos y armas la entrega final de la Unidad 3: el TP-U3.

## Repaso de los conceptos de la unidad

### Los cuatro verbos HTTP y sus metodos Dapper

| Verbo | Metodo C# | Metodo Dapper | Respuesta | Record de entrada |
|---|---|---|---|---|
| GET (lista) | `MapGet` | `Query<T>` con `.ToList()` | `200 Ok` | Ninguno |
| GET (uno) | `MapGet` con parametro `{id:long}` | `QueryFirstOrDefault<T>` | `200 Ok` o `404` | Ninguno |
| POST | `MapPost` | `ExecuteScalar<long>` con `last_insert_rowid()` | `201 Created` | `Input` (sin ID) |
| PUT | `MapPut` | `Execute` con existencia previa | `204 NoContent` | `Input` (todos los campos) |
| DELETE | `MapDelete` | `Execute` verificando filas afectadas | `204 NoContent` | Ninguno |

### Los tipos canonicos que no se negocian

| Columna BD | Tipo en C# |
|---|---|
| INTEGER (PK) | `long` (nunca `int`) |
| TEXT (fecha) | `string` (nunca `DateTime`) |
| TEXT nullable | `string?` |
| INTEGER nullable | `long?` |

### Estructura del Program.cs

```
using Dapper;
using Microsoft.Data.Sqlite;

var connectionString = "Data Source=hospital.db";
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// todos los endpoints MapGet / MapPost / MapPut / MapDelete
// ...

app.Run();

// todos los records posicionales aca abajo
```

## Checklist de verificacion pre-entrega

Antes de subir el TP, revisa cada punto:

- [ ] Los records usan `long` para IDs, nunca `int`.
- [ ] Las fechas son `string`, nunca `DateTime` ni `DateOnly`.
- [ ] Todos los SELECT tienen alias `AS` con PascalCase.
- [ ] Todas las consultas usan parametros `@nombre` con `new { ... }`, nunca concatenacion.
- [ ] Los records estan **despues** de `app.Run()`.
- [ ] `Results.Created()` se usa en POST, `Results.NoContent()` en PUT y DELETE sobre BD.
- [ ] Los mensajes de error estan en espanol dentro de `new { mensaje = "..." }`.
- [ ] El proyecto tiene `.gitignore` con `bin/` y `obj/`.
- [ ] El codigo esta en la carpeta `tp-u3/` del repositorio del grupo.

## TP-U3: CRUD completo

### Consigna

Crear una API en `Program.cs` que implemente CRUD completo sobre dos tablas relacionadas de la base `hospital.db`. La API debe incluir al menos:

1. **GET /doctors** — listar todos los doctores.
2. **GET /doctors/{id:long}** — obtener un doctor por ID.
3. **POST /doctors** — crear un nuevo doctor (validar que `first_name` no este vacio).
4. **PUT /doctors/{id:long}** — actualizar un doctor existente.
5. **DELETE /doctors/{id:long}** — eliminar un doctor.
6. **GET /admissions/{id:long}** — obtener una admision con JOIN triple que incluya:
   - Datos de la admision (`admission_id`, `admission_date`, `diagnosis`, `discharge_date`)
   - Nombre del doctor (`DoctorFirstName`, `DoctorLastName`)
   - Nombre del paciente (`PatientFirstName`, `PatientLastName`)

### Criterios de aprobacion

- El codigo compila y corre sin errores.
- Todos los endpoints responden con el codigo HTTP correcto segun el canon.
- Los mensajes de error estan en espanol.
- Los records usan los tipos canonicos (IDs como `long`, fechas como `string`).
- Todos los SELECT usan alias `AS`.
- No hay carpetas `Models/`, `Services/` ni `Controllers/`.

### Pistas

- Revisa los ejemplos de los encuentros 21 a 24. El endpoint GET /doctors/{id} es similar al GET /patients/{id} de la Unidad 2.
- Para el JOIN triple de admissions, usa el record `AdmissionDetail` del encuentro 24.
- La validacion de cada POST y PUT debe verificar que `FirstName` no sea vacio o nulo.

## Cierre de la unidad

### Que te llevas de la Unidad 3

- POST crea recursos y devuelve `201 Created`.
- DELETE elimina recursos y devuelve `204 No Content`.
- PUT actualiza recursos existentes y devuelve `204 No Content`.
- JOIN triple cruza tres tablas usando alias en las columnas.
- `ExecuteScalar<long>` para INSERT con retorno de ID, `Execute` para UPDATE y DELETE.
- Record de entrada separado del record completo para evitar que el cliente envie IDs.

### Lo que viene

En la Unidad 4 vas a profesionalizar el repositorio: README, ramas por feature, pull requests, main protegida, y el trabajo final integrador.

### Entrega

```bash
# Desde la carpeta del repositorio grupal
mkdir -p tp-u3
# Copiar Program.cs a tp-u3/
git add .
git commit -m "tp-u3: CRUD completo con Dapper"
git push
```

## Errores comunes y trampas

| Error | Causa | Solucion |
|---|---|---|
| El TP no compila | Error de sintaxis, record mal ubicado, falta `using`. | Revisar la estructura con la checklist pre-entrega. |
| Falta el alias en una columna del JOIN triple | Dapper no puede construir el record. | Cada columna del SELECT debe tener `AS NombreParametro`. |
| El DELETE devuelve `200` en lugar de `204` | Usar `Results.Ok()` en lugar de `Results.NoContent()`. | Recordar: DELETE con BD devuelve `204`. |
| El POST devuelve `200` en lugar de `201` | Usar `Results.Ok()` en lugar de `Results.Created()`. | POST correcto devuelve `201 Created` con URL. |
| Olvidar `.gitignore` en el repositorio | Los archivos `bin/` y `obj/` se suben. | Agregar `.gitignore` con `bin/` y `obj/`. |