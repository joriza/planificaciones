# Evaluación de la Unidad 4 — Versión B

> Dominio de esta versión: estadística de **pacientes por provincia** (tablas `patients` y `province_names` de `hospital.db`). Prueba práctica breve, complementaria de la defensa individual: se resuelve **por grupo**, sobre el repositorio del grupo (carpeta `trabajo-final/`). Duración: 90 minutos dentro del encuentro. Puntaje total: 100 puntos. Sin celular. Las condiciones completas están en `evaluacion-u4.md`.

## Antes de empezar

- El repositorio del grupo ya está en estado de entrega: `main` con los requisitos a-f fusionados, `main` protegida, README completo e issues cerrados. Sobre ese estado se trabaja: **el endpoint de esta prueba es adicional, no modifica ningún requisito a-f**.
- Leé el Bloque 4 completo **antes** de crear la rama: el endpoint que ahí se define es el contenido de los commits y del pull request.
- Repartan los roles visibles del flujo: quien crea el issue, quien conduce los comandos de rama y push, quien abre el PR y quien lo revisa. **Quien abre un PR nunca es su revisor.** Cada integrante tiene que ejecutar al menos un paso.
- Canon del curso: rutas en inglés y plural, respuestas siempre con `Results`, consultas sin concatenar datos recibidos, records al final del archivo, comentarios en el código.
- La evidencia es el propio repositorio: al terminar, todo queda en GitHub (issue cerrado, rama fusionada, endpoint en `main`). No se entrega nada aparte; los ítems conceptuales del Bloque 5 se responden por escrito, individualmente.
- Tiempo sugerido: instrucciones 5 · Bloque 1, 10 · Bloque 2, 25 · Bloque 3, 20 · Bloque 4, 20 · Bloque 5, 10.

## Bloque 1 — Issue con criterio de aceptación (15 puntos)

Crear en GitHub el issue que pide el feature (pestaña **Issues → New issue**), con la etiqueta `estadistica` (creada en el encuentro 28):

```markdown
Título: Estadística de pacientes por provincia
Etiqueta: estadistica

## Qué se pide
Endpoint GET /stats/provinces que devuelva la cantidad de pacientes por
provincia, para completar el panel de estadísticas del hospital.

## Criterios de aceptación
- [ ] GET /stats/provinces responde 200 con la lista de estadísticas en JSON
- [ ] Cada fila tiene exactamente dos campos: provincia y cantidad de pacientes
- [ ] La consulta usa COUNT(*) con GROUP BY por provincia y ordena por cantidad descendente
- [ ] Las columnas llevan alias para el record; no se concatena ningún dato recibido
- [ ] El endpoint está probado con curl y los criterios verificados en el PR
```

El issue es el pedido de trabajo con su condición de cierre: es lo primero del flujo y su número (`#N`) se usa en los bloques siguientes.

## Bloque 2 — Rama feature, commits y push (20 puntos)

Sobre el clon local del repositorio del grupo:

1. Actualizar `main` **antes** de ramificar (`git switch main` + `git pull`).
2. Crear la rama del feature desde `main` actualizada: `feature/stats-provinces`.
3. Desarrollar el endpoint dentro de la rama (especificación en el Bloque 4) y verificarlo corriendo (`dotnet run` + `curl`).
4. Commitear con al menos un commit referente que mencione el issue, con la convención del curso y sin tildes en el mensaje:

```powershell
git add .
git commit -m "trabajo-final: estadistica de pacientes por provincia (#N)"
git push -u origin feature/stats-provinces
```

## Bloque 3 — Pull request, revisión y merge (25 puntos)

En GitHub web, con `main` protegida:

1. Abrir el PR: **Pull requests → New pull request**, verificando la dirección `base: main` ← `compare: feature/stats-provinces`.
2. Descripción del PR: qué hace, cómo probarlo (los comandos `curl` del Bloque 4) y `Closes #N` en el cuerpo, para que el issue se cierre solo al fusionar.
3. Revisión de un par (distinto del autor) con la pestaña **Files changed** y la checklist del curso: compila y corre · cumple los criterios de aceptación · código legible y comentado · sin secretos. Aprobar con **Review changes → Approve** diciendo qué se probó.
4. Fusionar con **Merge pull request → Confirm merge**, verificar que el issue `#N` se cerró automáticamente, borrar la rama remota (**Delete branch**) y volver a `main` en el clon (`git switch main` + `git pull`).

## Bloque 4 — El mini endpoint de estadística (30 puntos)

### Especificación

| Campo | Detalle |
| --- | --- |
| Endpoint | `GET /stats/provinces` |
| Qué devuelve | `200` con la cantidad de pacientes por provincia, en JSON |
| Consulta | `COUNT(*)` con `GROUP BY` por provincia, ordenada por cantidad descendente, con `JOIN` a `province_names` para mostrar el nombre (el paciente guarda solo el código) |
| Record | `ProvinceCount` con dos campos: provincia y cantidad (`int`, es conteo, no id) |
| Ubicación | El endpoint va **antes** de `app.Run()`; el record, **al final** del archivo con los demás |

### Esqueleto (guía de inserción en el `Program.cs` del grupo)

```csharp
// ===== Bloque 4: completar a partir de aqui (antes de app.Run()) =====
// GET /stats/provinces: estadistica de pacientes por provincia (Issue #N)
// - Conexion canonica con using dentro del handler
// - JOIN de dos tablas: patients + province_names (el paciente guarda
//   el codigo, el nombre completo vive en province_names)
// - Consulta con COUNT(*) y GROUP BY por provincia,
//   ordenada por cantidad descendente (ORDER BY ... DESC)
// - Columnas con alias (AS) para encajar en el record ProvinceCount
// - Responder 200 con Results.Ok

// ---- Record de la estadistica: agregar al final del archivo ----
record ProvinceCount(string ProvinceName, int Patients);
```

### Salidas esperadas

Con la API corriendo (`dotnet run`, puerto informado por la terminal; los ejemplos usan `5080`):

```powershell
curl http://localhost:5080/stats/provinces
```

```json
[{"provinceName":"Ontario","patients":180},{"provinceName":"British Columbia","patients":30},{"provinceName":"Nova Scotia","patients":20}]
```

La forma de la salida es exactamente esa (lista JSON con pares provincia/cantidad, de más a menos); los valores concretos dependen de la base del grupo. Después del merge, repetir la prueba desde `main` actualizada: el endpoint tiene que responder igual desde la rama fusionada.

## Bloque 5 — Ítems conceptuales (10 puntos)

Responder **individualmente y por escrito**, con tus propias palabras y sin computadora.

### C1. `main` protegida (5 puntos)

¿Qué significa que `main` esté protegida, qué cambia para subir un cambio al repositorio y qué responde GitHub si alguien intenta hacer push directo?

### C2. Issue y pull request (5 puntos)

¿Qué registra cada uno y en qué momento del flujo actúa? Explicar la diferencia con una frase por pieza.
