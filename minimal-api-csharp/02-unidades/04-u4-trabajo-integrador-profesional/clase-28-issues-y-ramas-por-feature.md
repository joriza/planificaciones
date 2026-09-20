# Encuentro 28 — Issues y ramas por feature

## 1. Metadatos del encuentro

| Campo | Detalle |
| --- | --- |
| Encuentro | 28 |
| Unidad | Unidad didáctica 4: Trabajo integrador profesional (encuentro 2 de 5) |
| Eje temático | Eje 5: Terminal, Git y GitHub |
| Carácter | Procedimental |
| Duración | 240 minutos: apertura y puente 20 · teoría mínima 40 · práctica guiada 70 · ejercicio independiente 50 · extensión y consolidación 45 · cierre 15 |
| Concepto nuevo | Issue con criterio de aceptación y etiquetas; rama `feature/<nombre>` por issue; flujo issue → rama → commits → push de la rama |
| Requisitos | Encuentro 27: carpeta `trabajo-final/` con el proyecto conectado a `hospital.db` y README de portada; git y GitHub del grupo operativos; consigna del trabajo final leída |
| Uso del celular | No permitido |
| Trabajo en equipo | Grupos: alumnos presentes ÷ equipos disponibles (mínimo posible); ningún equipo sin usar mientras haya alumnos sin equipo; rotación de integrantes |

## 2. Objetivos de aprendizaje

1. Crear issues en GitHub con título, descripción, criterios de aceptación y etiquetas, uno por requisito del trabajo final.
2. Crear ramas `feature/<nombre>` desde `main` actualizada, una por issue.
3. Desarrollar un feature completo dentro de su rama con commits que referencien el issue.
4. Empujar la rama a GitHub y verificarla desde la web.

## 3. Teoría mínima

### Apertura y puente (20 min)

Revisión rápida del README de cada grupo (proyectado desde GitHub): ¿la tabla de endpoints está con estados reales? Puente: «la semana pasada definimos QUÉ hay que construir; hoy definimos CÓMO se organiza la construcción». Se anuncia la regla de la unidad: a partir de hoy nadie programa sin issue y sin rama.

### El issue: un pedido de trabajo con condición de cierre

**Analogía — la mesa de entradas del hospital:** en un hospital cada pedido (un estudio, una receta) entra por mesa de entradas con un número, una descripción de qué se necesita y la condición que debe cumplir para darse por resuelto. Un issue de GitHub es exactamente eso: un número (`#1`, `#2`, ...), un título, una descripción y, lo más importante, el **criterio de aceptación**: la lista verificable de condiciones que cierran el issue. Un issue sin criterio de aceptación es un pedido que nadie sabe cuándo está listo.

Estructura de un issue del trabajo final:

- **Título:** una frase que diga qué feature se construye.
- **Descripción:** qué se pide y para qué sirve.
- **Criterios de aceptación:** lista de verificación (`- [ ]`) con los casos a probar, incluidos los códigos de respuesta.
- **Etiqueta:** categoría del trabajo (`endpoint`, `estadistica`, `documentacion`).

Se crean **un issue por requisito (a-f) de la consigna**: seis issues en total, más los extras que surjan.

### La rama feature: un camino paralelo

**Analogía — el quirófano:** operar en `main` directamente es operar en la sala de espera. Una rama es un quirófano aparte: ahí se hace el trabajo invasivo sin que nadie que pasa por la sala principal se entere, y solo cuando la operación termina y está verificada, el resultado vuelve a la sala (`main`). Convenio del curso: una rama por issue, con nombre `feature/<tema>` en minúsculas, sin tildes y con guiones (`feature/estadisticas`).

### El flujo completo del encuentro

```text
issue (#N)  ->  rama feature/<nombre>  ->  commits "(#N)"  ->  push de la rama
```

La rama nace SIEMPRE desde `main` actualizada (`git switch main` + `git pull` primero). El push de la rama es `git push -u origin <rama>`: el flag `-u` conecta la rama local con su par remoto la primera vez. En el próximo encuentro, esa rama se convertirá en un **pull request**: hoy solo la empujamos.

## 4. Práctica guiada

> Trabajo por grupos con rotación de roles: quien tiene la sesión de GitHub abierta, quien teclea en la terminal y quien prueba con `curl` cambian por paso. El docente modela cada paso en el proyector con un repo de demostración antes de que los grupos lo repliquen.

### Paso 1 — Crear las etiquetas (GitHub web)

**Issues → Labels → New label**, tres veces:

| Nombre | Uso |
| --- | --- |
| `endpoint` | Features de código (requisitos a, c, d, e) |
| `estadistica` | Features de estadística y agregaciones (requisito b) |
| `documentacion` | Features de README y documentación (requisito f) |

### Paso 2 — Crear los seis issues (GitHub web)

Por cada requisito de la consigna: **Issues → New issue**, título, descripción, criterios de aceptación como lista de verificación y etiqueta. Los números que asigna GitHub (`#1` a `#6`) dependen del orden de creación; los ejemplos usan el orden de la consigna.

Issue modelo (requisito c, el que se desarrolla en la práctica):

```markdown
Título: Búsqueda de pacientes por apellido (LIKE validada)
Etiqueta: endpoint

## Qué se pide
Endpoint GET /patients/search?term=... que busque pacientes por apellido
con LIKE, para encontrar un paciente sin saber su id.

## Criterios de aceptación
- [ ] GET /patients/search?term=gar responde 200 con la lista de coincidencias
- [ ] Sin term (o vacío) responde 400 con mensaje en español
- [ ] Sin coincidencias responde 404 con mensaje en español
- [ ] La consulta usa parámetro SQL (@filter), nunca concatena texto
```

Los otros cinco issues siguen la misma estructura, con los criterios tomados de la matriz de la consigna (anexo docente del encuentro 27).

### Paso 3 — Actualizar main y crear la rama

```powershell
git switch main
git pull
git switch -c feature/busqueda-pacientes
```

Verificar la rama activa antes de programar:

```powershell
git branch
```

Salida esperada (el asterisco marca la rama activa):

```text
* feature/busqueda-pacientes
  main
```

### Paso 4 — Desarrollar el feature dentro de la rama

Agregar el endpoint **antes** de `app.Run()` y el record **al final** del archivo:

```csharp
// GET /patients/search?term=gar: busca pacientes por apellido con LIKE
app.MapGet("/patients/search", (string? term) =>
{
    // Validacion manual: sin termino de busqueda no hay nada que buscar
    if (string.IsNullOrWhiteSpace(term))
    {
        return Results.BadRequest(new { mensaje = "Indique un termino de busqueda, por ejemplo ?term=gar" });
    }

    // using: la conexion se cierra sola al salir del handler
    using var connection = new SqliteConnection(connectionString);

    // LIKE con comodines: el patron SIEMPRE viaja como parametro @filter,
    // nunca se concatena el texto recibido con el SQL
    var filter = $"%{term}%";
    var patients = connection.Query<PatientSummary>(
        @"SELECT patient_id AS PatientId,
                 first_name AS FirstName,
                 last_name  AS LastName
          FROM patients
          WHERE last_name LIKE @filter
          ORDER BY last_name",
        new { filter });

    // Sin coincidencias: 404 con mensaje. Con coincidencias: 200 con la lista
    return patients.Count() == 0
        ? Results.NotFound(new { mensaje = "Ningun paciente coincide con la busqueda" })
        : Results.Ok(patients);
});
```

```csharp
// ---- Records: SIEMPRE al final, despues de app.Run() ----
record PatientSummary(long PatientId, string FirstName, string LastName);
```

Probar los tres casos de los criterios de aceptación:

```powershell
# 200: hay coincidencias
curl http://localhost:5080/patients/search?term=gar

# 400: falta el termino
curl -i http://localhost:5080/patients/search

# 404: nadie coincide
curl -i http://localhost:5080/patients/search?term=zzz
```

Salida esperada: la primera consulta devuelve un arreglo JSON; la segunda responde `400` con `{"mensaje":"Indique un termino de busqueda, por ejemplo ?term=gar"}`; la tercera responde `404` con `{"mensaje":"Ningun paciente coincide con la busqueda"}`.

Tildar los criterios cumplidos en el issue (GitHub web, lista de verificación).

### Paso 5 — Commits que referencian el issue

```powershell
git add .
git commit -m "trabajo-final: busqueda de pacientes por apellido (#3)"
```

La referencia `(#3)` en el mensaje deja rastro: desde el issue se puede saltar a los commits que lo trabajaron.

### Paso 6 — Empujar la rama

```powershell
git push -u origin feature/busqueda-pacientes
```

Salida esperada:

```text
branch 'feature/busqueda-pacientes' set up to track 'origin/feature/busqueda-pacientes'.
```

Verificar en GitHub web: el selector de ramas muestra la nueva rama y GitHub propone el botón **Compare & pull request** (es el tema del próximo encuentro: no abrirlo todavía).

## 5. Ejercicio independiente

**Consigna:** cada grupo aplica el flujo completo a su segundo feature:

1. Completar los seis issues si quedó alguno sin crear (título, descripción, criterios, etiqueta).
2. Desde `main` actualizada, crear la rama del siguiente issue de la consigna.
3. Desarrollar el feature, probar los criterios de aceptación con `curl` y commitear con la referencia `(#N)`.
4. Empujar la rama con `-u` y verificarla en GitHub web.
5. Actualizar el README: el endpoint trabajado pasa a estado `en desarrollo` (pasa a `listo` cuando se fusione en el próximo encuentro).

**Pista:** una rama por issue, siempre; antes de crear la rama, `git switch main` y `git pull`. Si los criterios de aceptación no se pueden probar, el issue está mal escrito: corregirlo antes de programar.

## Extensión y consolidación

Para quienes completan la consigna base:

- Asignar cada issue a un integrante (campo **Assignees**) y acordar por escrito el orden de trabajo del sprint del encuentro 30.
- Crear un issue extra de mejora elegido por el grupo (por ejemplo, estadística de ingresos por mes con `strftime`, o un segundo criterio de búsqueda por nombre).
- Enlazar los issues en el README con la sintaxis `#N`, para que la tabla de endpoints y el tablero de issues queden cruzados.

Consolidación docente: recorrida rápida por los repos (vista **Issues** de cada grupo) verificando que ningún issue carezca de criterios de aceptación.

## 6. Cierre

### Qué te llevás

- Cada requisito del trabajo final es un issue con título, descripción, criterios de aceptación verificables y etiqueta.
- Cada issue se trabaja en su propia rama `feature/<nombre>`, creada siempre desde `main` actualizada.
- El flujo del profesional: issue → rama → commits con la referencia `(#N)` → `git push -u origin <rama>`.
- Los criterios de aceptación se prueban con `curl` ANTES de commitear, no después.
- La columna Estado del README y los issues cuentan la misma historia: qué está listo, qué está en desarrollo, qué falta.

### Lo que viene

En el encuentro 29 las ramas empujadas se convierten en **pull requests**: otro integrante revisa el código con una checklist, aprueba, y recién ahí el trabajo se fusiona a `main`. Después de esa clase, nadie va a poder escribir directamente en `main`: va a estar protegida.

## 7. Errores comunes y trampas

| Error | Causa | Fix |
| --- | --- | --- |
| La rama hereda trabajo viejo o le faltan cambios | Se creó sin actualizar `main` | Antes de cada rama: `git switch main` y `git pull`; recién después `git switch -c feature/<nombre>` |
| Dos features en la misma rama | «Ya que estoy, hago también el otro» | Un issue, una rama; el otro feature espera su propia rama (ramas gigantes = revisión imposible) |
| `git push` rechaza con error de upstream | Primera subida de la rama sin `-u` | `git push -u origin <nombre-exacto-de-la-rama>` |
| Issue sin criterios de aceptación | Se escribió como idea, no como pedido verificable | Lista de verificación con casos concretos, incluidos los códigos 200/400/404; sin criterios no se programa |
| Espacios, mayúsculas o tildes en el nombre de la rama | Nombres improvisados tipo `Mi Feature Nueva` | Nombres cortos, minúsculas, sin tildes y con guiones: `feature/busqueda-pacientes` |
| Commits hechos sin darse cuenta en `main` | La rama activa era otra | Verificar con `git branch` (el asterisco) antes de cada commit; cambiar de rama con `git switch` |
