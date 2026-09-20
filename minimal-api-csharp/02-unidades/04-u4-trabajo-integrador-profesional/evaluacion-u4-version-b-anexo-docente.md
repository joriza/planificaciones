# Anexo docente — Evaluación de la Unidad 4 — Versión B

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión B (estadística de pacientes por provincia), el recorrido esperado del flujo GitHub, las respuestas esperadas de los ítems conceptuales, los criterios de corrección ítem por ítem, la rúbrica de defensa individual con calificación y la pauta de devolución.

| Campo | Detalle |
| --- | --- |
| Instancia | Encuentro 32 — Evaluación de la Unidad 4 · prueba práctica breve, versión B |
| Dominio | Tablas `patients` + `province_names`: estadística de pacientes por provincia (`GET /stats/provinces`) |
| Referencias | Consigna canónica y rúbrica anticipada: encuentros 27 y 31 (`clase-27-trabajo-final-y-readme.md`, `clase-31-consolidacion-cierre-u4-y-defensa-anexo-docente.md`) |

## 1. Solución completa del endpoint (`Program.cs`)

Inserción canónica sobre el `Program.cs` del grupo: el endpoint va **antes** de `app.Run()` y el record, **al final** del archivo. La versión B agrupa los pacientes por provincia: el paciente guarda solo el código (`province_id`) y el nombre completo vive en la tabla de referencia, por lo que la consulta lleva un `JOIN` de dos tablas (contenido del encuentro 13):

```csharp
// GET /stats/provinces: estadistica de pacientes por provincia (Issue #N)
app.MapGet("/stats/provinces", () =>
{
    // using: la conexion se cierra sola al salir del handler
    using var connection = new SqliteConnection(connectionString);

    // El paciente guarda el codigo (province_id); el nombre completo
    // vive en province_names: el JOIN lo trae. COUNT(*) cuenta los
    // pacientes de cada grupo; GROUP BY parte por provincia.
    // ORDER BY Patients DESC ordena de mas a menos; los alias AS
    // hacen que las columnas encajen en el record ProvinceCount
    var stats = connection.Query<ProvinceCount>(
        @"SELECT pn.province_name AS ProvinceName,
                 COUNT(*)         AS Patients
          FROM patients p
          JOIN province_names pn ON p.province_id = pn.province_id
          GROUP BY pn.province_name
          ORDER BY Patients DESC");

    // 200 con la estadistica serializada a JSON (lista, de mas a menos)
    return Results.Ok(stats);
});

app.Run();   // Deja la API escuchando pedidos

// ---- Records: SIEMPRE al final, despues de las instrucciones ----
record ProvinceCount(string ProvinceName, int Patients);
```

Aceptaciones válidas menores: `ORDER BY COUNT(*) DESC` en lugar de ordenar por el alias (SQLite acepta ambas formas); agrupar por el código con el nombre en el SELECT (`GROUP BY p.province_id`) — el resultado es el mismo conjunto de filas porque cada código corresponde a una provincia; `Results.Ok(connection.Query<ProvinceCount>(...))` sin variable intermedia; el JOIN puede escribirse también con `INNER JOIN`. **No se acepta** `TypedResults` (canon: `Results` en .NET 6), devolver el código `province_id` en lugar del nombre (el criterio pide la provincia) ni ordenar por provincia en lugar del conteo.

## 2. Recorrido esperado del flujo GitHub (comandos y pantallas)

Estado de partida esperado (verificado en el bloque 1 del encuentro): `main` con los requisitos a-f, sin PRs abiertos, `main` protegida desde el encuentro 29.

### Paso 1 — Issue (GitHub web)

- Pantalla: **Issues → New issue**. Título «Estadística de pacientes por provincia», etiqueta `estadistica`, descripción y los cinco criterios como lista de verificación (`- [ ]`).
- Al crear: GitHub asigna el número `#N`. Anotarlo: se usa en el commit, en el PR y en `Closes #N`.

### Paso 2 — Rama, desarrollo, commit y push (terminal)

```powershell
git switch main
git pull
git switch -c feature/stats-provinces
git branch
```

Salida esperada de `git branch` (el asterisco marca la rama activa):

```text
* feature/stats-provinces
  main
```

Con la rama activa, agregar el endpoint (sección 1), correr y probar:

```powershell
dotnet run
curl http://localhost:5080/stats/provinces
```

```powershell
git add .
git commit -m "trabajo-final: estadistica de pacientes por provincia (#N)"
git push -u origin feature/stats-provinces
```

Salida esperada del push: la rama se crea en GitHub y queda conectada (`Branch 'feature/stats-provinces' set up to track remote branch`). GitHub muestra el aviso **recent pushes** con el botón para abrir el pull request.

### Paso 3 — Pull request (GitHub web)

- Pantalla: **Pull requests → New pull request**. Verificar `base: main` ← `compare: feature/stats-provinces` (dirección correcta; invertida es defecto).
- Cuerpo del PR: qué hace, cómo probarlo con `curl`, y `Closes #N`. Al crearlo, la barra lateral del PR muestra el issue vinculado.

### Paso 4 — Revisión de un par (GitHub web)

- El revisor (distinto del autor) abre **Files changed** y recorre la checklist: compila y corre (probó en local), criterios de aceptación (repitió los `curl`), legibilidad y comentarios, sin secretos.
- Pantalla: **Review changes → Approve**, con comentario de qué se probó. La aprobación queda registrada en el PR.

### Paso 5 — Merge sobre `main` protegida (GitHub web)

- Pantalla: **Merge pull request → Confirm merge** (habilitado solo con la aprobación: es la protección trabajando).
- Verificaciones en el momento: el badge cambia a **Merged**; el issue `#N` aparece **cerrado automáticamente** (gracias a `Closes #N`); el botón **Delete branch** borra la rama remota.

### Paso 6 — Vuelta a `main` y verificación final (terminal)

```powershell
git switch main
git pull
curl http://localhost:5080/stats/provinces
```

Salida esperada: `main` actualizada con el endpoint, que responde igual que en la rama. La rama local ya fusionada puede eliminarse (`git branch -d feature/stats-provinces`).

### Observación prevista (no es error)

Un intento de `git push` directo a `main` es rechazado con `GH006: Protected branch update failed`. Esa salida es la protección funcionando: el flujo correcto es issue → rama → PR → merge, y es lo que se evalúa.

## 3. Respuestas esperadas — ítems conceptuales

| Ítem | Respuesta esperada | Puntos |
| --- | --- | --- |
| C1 | `main` protegida = regla de protección de rama: exige pull request con una aprobación para fusionar y rechaza el push directo (GH006). Para subir un cambio ya no se pushea a `main`: se crea issue, rama `feature/`, commits y PR revisado por otro integrante. Nadie integra sin revisión (2 pts la definición, 2 pts el cambio de flujo, 1 pt el rechazo GH006) | 5 |
| C2 | El **issue** registra el pedido de trabajo: qué hay que hacer y su criterio de aceptación; actúa al inicio, organiza y traza el feature. El **pull request** registra el pedido de integración: muestra el diff de lo hecho y recibe la revisión antes del merge; actúa al final, cuando el trabajo está listo para entrar a `main` (2 pts por pieza + 1 pt la secuencia issue primero / PR después) | 5 |

## 4. Criterios de corrección ítem por ítem

### Bloque 1 — Issue (15 puntos)

| Ítem | Qué se observa | Puntos |
| --- | --- | --- |
| 1 | Título claro del feature y etiqueta `estadistica` aplicada | 5 |
| 1 | Descripción breve de qué se pide y para qué | 4 |
| 1 | Los cinco criterios de aceptación como lista de verificación (`- [ ]`) | 6 |

### Bloque 2 — Rama, commits y push (20 puntos)

| Ítem | Qué se observa | Puntos |
| --- | --- | --- |
| 2 | `main` actualizada antes de ramificar (`git switch main` + `git pull`) | 4 |
| 2 | Rama `feature/stats-provinces` creada desde `main` actualizada | 4 |
| 2 | Commit referente con la convención `trabajo-final: ...` y mención `(#N)`, mensaje sin tildes | 6 |
| 2 | Push de la rama con `-u origin` y rama visible en GitHub | 6 |

### Bloque 3 — Pull request, revisión y merge (25 puntos)

| Ítem | Qué se observa | Puntos |
| --- | --- | --- |
| 3 | PR con dirección correcta `base: main` ← `compare: feature/stats-provinces` | 5 |
| 3 | Descripción con qué hace y cómo probarlo (comandos `curl`) | 5 |
| 3 | `Closes #N` en el cuerpo del PR | 5 |
| 3 | Revisión real de un par distinto del autor, con la checklist y aprobación registrada | 5 |
| 3 | Merge a `main`, cierre automático del issue y rama remota borrada | 5 |

### Bloque 4 — Mini endpoint (30 puntos)

| Ítem | Qué se observa | Puntos |
| --- | --- | --- |
| 4 | `GET /stats/provinces` responde `200` con la lista JSON (`Results.Ok`) | 6 |
| 4 | Cada fila tiene exactamente dos campos con alias correctos (`ProvinceName`, `Patients`), con el nombre de la provincia (no el código) | 5 |
| 4 | `COUNT(*)` con `GROUP BY` por provincia | 6 |
| 4 | `JOIN patients` + `province_names` con `ON` correcto | 4 |
| 4 | `ORDER BY Patients DESC` (de más a menos) | 3 |
| 4 | Canon: `Results` (nunca `TypedResults`), record `ProvinceCount` al final, comentarios en el código, conexión con `using` y sin concatenar datos | 6 |

### Bloque 5 — Ítems conceptuales (10 puntos)

Desglose en la sección 3.

**Total: 100 puntos.** Los bloques 1 a 4 (90) son producto del grupo con roles rotativos y observables; el bloque 5 (10) es individual. Se tolera un endpoint funcional con una convención desviada si el criterio puntual lo penaliza una sola vez: no se duplican descuentos por el mismo defecto en ítems distintos.

## 5. Rúbrica de defensa individual con calificación (100 puntos)

Los criterios son exactamente los anticipados al grupo en el encuentro 31; se agrega únicamente la columna de puntaje. Valores por criterio: **logrado** = puntaje completo · **en proceso** = la mitad, redondeada hacia arriba · **no logrado** = 0. La defensa es individual con el trabajo grupal de fondo (duración: 5 a 7 minutos por integrante, según el guion del encuentro 31: portada ~1 min, demo por requisito 3 a 5 min, cierre con decisión técnica ~1 min).

| Bloque | Criterio (anticipado en encuentro 31) | Logrado | En proceso | No logrado | Puntos |
| --- | --- | --- | --- | --- | --- |
| Entrega | Repositorio empujado, `main` completa; un clon fresco corre con el README | 10 | 5 | 0 | 10 |
| Entrega | README completo con ejemplos curl probados | 10 | 5 | 0 | 10 |
| Flujo profesional | Issues con criterios de aceptación y trazabilidad issue → rama → PR → merge | 15 | 8 | 0 | 15 |
| Flujo profesional | Revisión entre pares con aprobación ajena; sin push directo a `main` protegida | 15 | 8 | 0 | 15 |
| Requisitos a-f | Cada requisito responde según su criterio de aceptación (códigos incluidos) | 15 | 8 | 0 | 15 |
| Requisitos a-f | Canon del código: `Program.cs` único, records al final, parametrización, `Results.*`, ids `long`, fechas `string` | 15 | 8 | 0 | 15 |
| Defensa individual | Demo guiada por requisito con comandos preparados (si falla: leer el error y razonar también puntúa) | 10 | 5 | 0 | 10 |
| Defensa individual | Explicación del código propio y de las decisiones técnicas | 10 | 5 | 0 | 10 |
| **Total** | | | | | **100** |

**Preguntas para la defensa:** del banco anticipado en el anexo docente del encuentro 31, dos o tres por integrante, mezclando un requisito que programó y uno del grupo; las transversales de flujo (rama de features, protección de `main`) conectan la defensa con la prueba práctica del día. Ante silencio, bajar la pregunta de nivel («¿qué línea del JOIN trae el nombre de la provincia?»); ante un error no detectado, mostrar la salida y pedir la lectura. La corrección docente nunca reemplaza el intento del alumno.

## 6. Errores previstos y criterio de intervención

| Error observable | Causa probable | Criterio |
| --- | --- | --- |
| Push directo a `main` rechazado (GH006) | Intentó saltarse el PR | No descuenta por el rechazo: es la protección. Descuenta solo si después saltea la revisión (PR sin aprobador distinto) |
| PR con dirección invertida | Compare armado al revés | Descuenta el ítem de dirección del PR; cerrarlo y reabrirlo bien recupera el resto del bloque |
| `500` al pedir el endpoint | Falta el `GROUP BY`, alias que no coincide con el record o `JOIN` con la columna de unión equivocada | Descuenta el ítem correspondiente; leer el error en la terminal de `dotnet run` es parte de la corrección |
| Salida con el código de provincia en lugar del nombre | Agrupó sin el `JOIN` a `province_names` | Descuenta el ítem de JOIN/alias; el conteo correcto puntúa parcialmente según el criterio de campos |
| Salida ordenada por provincia y no por cantidad | `ORDER BY pn.province_name` | Descuenta el ítem de orden; el resto del endpoint puntúa |
| `TypedResults` en la respuesta | Confusión de versión | Defecto de versión (canon: `Results` en .NET 6): descuenta en el ítem de canon |
| Commit sin mención `(#N)` o con tildes en el mensaje | Convención de la unidad olvidada | Descuenta el ítem de commit referente |
| El propio autor aprueba su PR | Revisión simbólica | La protección debería impedirlo; si el repo no la aplica, descuenta revisión y deja constancia en la planilla |
| Endpoint en español (`/estadisticas`) | Canon de rutas incumplido | Descuenta el ítem de ruta |

## 7. Pauta de devolución (encuentro 33)

- El encuentro 33 (Cierre integrador del cuatrimestre 2) abre con la devolución: resultados generales del curso, comentarios por grupo (entrega y flujo profesional) y comentarios individuales (defensa e ítems conceptuales).
- **Planilla:** grupo → versión B y puntaje por bloque de la prueba (15/20/25/30 + conceptuales); integrante → los ocho criterios de la rúbrica con su valor, nota de defensa, puntaje conceptual individual y composición final: 50 % defensa + 50 % prueba.
- Comentarios generales sugeridos: qué consolidó la unidad (flujo completo con trazabilidad, producto integrador) y los errores más vistos en la prueba (dirección del PR, JOIN sin la tabla de referencia, convención de commits).
- Los criterios no logrados se traducen en pistas concretas para los encuentros 34 y 35 (recuperación y profundización U3-U4): por ejemplo, reconstruir el flujo completo sobre un issue nuevo, o el molde de estadística con `GROUP BY` y `JOIN`.
- La versión A es equivalente: misma estructura, mismo puntaje y mismas respuestas esperadas para los ítems conceptuales; el dominio cambia a `doctors` (ver `evaluacion-u4-version-a-anexo-docente.md`).
