# Anexo docente — Encuentro 28: issues y ramas por feature

> Registro docente formal. Documento interno del docente: no se entrega a los alumnos.

| Campo | Detalle |
| --- | --- |
| Encuentro | 28 — Unidad didáctica 4 (2 de 5) |
| Contenido | Issues con criterio de aceptación; ramas `feature/<nombre>`; flujo issue → rama → commits → push |
| Insumos | Consigna canónica (encuentro 27); `convenciones-tecnicas.md` |

## 1. Solución de referencia: los seis issues modelo

Los números `#1` a `#6` corresponden al orden de creación siguiendo la consigna; usar los números reales de cada repo. Cada issue lleva etiqueta según la clase de trabajo.

### Issue #1 — requisito (a) · etiqueta `endpoint`

```markdown
Título: Admisiones con detalle de paciente y médico (JOIN triple)

## Qué se pide
Endpoint GET /admissions/details que liste cada ingreso con fecha de
ingreso, fecha de alta, diagnóstico, paciente, médico y especialidad.

## Criterios de aceptación
- [ ] Responde 200 con el JOIN de admissions + patients + doctors
- [ ] Cada fila muestra paciente, médico y especialidad resueltos por nombre
- [ ] Orden descendente por fecha de ingreso
- [ ] Columnas snake_case renombradas con AS para coincidir con el record
```

### Issue #2 — requisito (b) · etiqueta `estadistica`

```markdown
Título: Estadística de ingresos por especialidad (GROUP BY)

## Qué se pide
Endpoint GET /stats/specialties con la cantidad de ingresos por especialidad.

## Criterios de aceptación
- [ ] Responde 200 con una fila por especialidad
- [ ] Usa COUNT(*) con GROUP BY d.specialty
- [ ] Ordenado por cantidad descendente
- [ ] El conteo usa int (canon: int solo para conteos, nunca para ids)
```

### Issue #3 — requisito (c) · etiqueta `endpoint`

```markdown
Título: Búsqueda de pacientes por apellido (LIKE validada)

## Qué se pide
Endpoint GET /patients/search?term=... que busque pacientes por apellido.

## Criterios de aceptación
- [ ] GET /patients/search?term=gar responde 200 con la lista de coincidencias
- [ ] Sin term (o vacío) responde 400 con mensaje en español
- [ ] Sin coincidencias responde 404 con mensaje en español
- [ ] La consulta usa parámetro SQL (@filter), nunca concatena texto
```

### Issue #4 — requisito (d) · etiqueta `endpoint`

```markdown
Título: Alta y baja de paciente con validación (201/204/400/404)

## Qué se pide
POST /patients para crear un paciente validado y DELETE /patients/{id}
para darlo de baja con sus reglas.

## Criterios de aceptación
- [ ] POST con datos válidos responde 201
- [ ] POST con dato faltante, género distinto de M/F, fecha no ISO o
      provincia inexistente responde 400 con mensaje en español
- [ ] DELETE de un id inexistente responde 404
- [ ] DELETE de un paciente con ingresos registrados responde 400
- [ ] DELETE de un paciente sin ingresos responde 204
```

### Issue #5 — requisito (e) · etiqueta `endpoint`

```markdown
Título: Detección del dato sucio: altas anteriores al ingreso

## Qué se pide
Endpoint GET /admissions/dirty-dates que liste los ingresos cuya fecha de
alta es anterior a la de ingreso (caso real: alta '1971-01-05').

## Criterios de aceptación
- [ ] Responde 200 con paciente, fecha de ingreso y fecha de alta
- [ ] La comparación usa las fechas ISO como texto (discharge < admission)
- [ ] El grupo puede explicar en la defensa por qué es dato sucio
```

### Issue #6 — requisito (f) · etiqueta `documentacion`

```markdown
Título: README de portada completo con ejemplos curl

## Qué se pide
Cerrar el README del repo: descripción, integrantes, cómo clonar y correr,
y tabla de endpoints con un ejemplo curl REAL por endpoint.

## Criterios de aceptación
- [ ] Cada endpoint de la tabla tiene un comando curl probado
- [ ] Un lector nuevo puede clonar y correr la API siguiendo solo el README
- [ ] La columna Estado refleja el estado final de todos los endpoints
```

## 2. Solución: secuencia completa del flujo (issue → rama → commits → push)

Secuencia de referencia para el feature modelado (issue `#3`), desde el clon del grupo:

```powershell
git switch main
git pull
git switch -c feature/busqueda-pacientes
# ... desarrollar el endpoint (práctica guiada de la clase) ...
git add .
git commit -m "trabajo-final: busqueda de pacientes por apellido (#3)"
git push -u origin feature/busqueda-pacientes
```

Verificación final del ejercicio independiente, por grupo:

1. Vista **Issues** del repo: seis issues con criterios y etiquetas; los criterios cumplidos están tildados.
2. Selector de ramas: al menos dos `feature/*` empujadas además de `main`.
3. Vista de commits de cada rama: mensajes con la convención `trabajo-final: ... (#N)`.
4. README actualizado con estados reales.

## 3. Criterios de observación de la clase

| Criterio | Se observa cuando |
| --- | --- |
| Calidad de los issues | Criterios de aceptación con casos concretos y códigos de respuesta; no hay issues-idea |
| Disciplina de rama | `git branch` antes de programar; una rama por issue; ramas nacidas de `main` actualizada |
| Prueba antes del commit | Los tres casos del issue (200/400/404) probados con `curl` antes del `git add` |
| Trazabilidad | El mensaje de commit referencia el issue; los criterios tildados coinciden con lo realmente probado |
| Rotación de roles | La sesión de GitHub, la terminal y las pruebas de `curl` pasan por manos distintas |

## 4. Errores esperados e intervención

| Error esperado | Intervención docente |
| --- | --- |
| Issues escritos como frases sueltas («hacer la búsqueda») | Preguntar «¿cómo sabés que está listo?» hasta que aparezca el criterio verificable; reescribir un issue juntos como modelo |
| Rama creada desde un clon desactualizado | Detectarlo temprano con la vista de ramas de GitHub; el grupo vuelve a `main`, `pull`, recrea la rama y rehace el paso; es el costo didáctico del atajo |
| El grupo programa primero y crea el issue después | Regla explícita de la unidad: sin issue abierto no se programa; el issue es el ticket que autoriza la rama |
| `?term=gar` probado solo en el navegador | El navegador solo envía GET y no muestra códigos: exigir `curl -i` para 400 y 404 |
| Un integrante monopoliza la terminal | Rotación cronometrada: 15 minutos por rol; el docente pregunta a quien no teclea qué viene después |
| Confusión `#N` en commit vs. `Closes #N` | Aclarar que hoy solo se REFERENCIA el issue en el mensaje; la palabra que lo cierra automáticamente llega con los pull requests |
