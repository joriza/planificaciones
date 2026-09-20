# Encuentro 30 — Sprint de desarrollo mentorizado

## 1. Metadatos del encuentro

| Campo | Detalle |
| --- | --- |
| Encuentro | 30 |
| Unidad | Unidad didáctica 4: Trabajo integrador profesional (encuentro 4 de 5) |
| Eje temático | Eje 4: Trabajo integrador profesional |
| Carácter | Procedimental |
| Duración | 240 minutos: apertura y puente 20 · teoría mínima 40 · práctica guiada 70 · ejercicio independiente 50 · extensión y consolidación 45 · cierre 15 |
| Concepto nuevo | Sprint de desarrollo con integración continua vía PRs; endpoint con subconsulta aplicado al trabajo final; acompañamiento docente decreciente |
| Requisitos | Encuentros 27 a 29: consigna leída, issues con criterios, flujo issue → rama → PR → merge dominado, `main` protegida |
| Uso del celular | No permitido |
| Trabajo en equipo | Grupos: alumnos presentes ÷ equipos disponibles (mínimo posible); ningún equipo sin usar mientras haya alumnos sin equipo; rotación de integrantes |

## 2. Objetivos de aprendizaje

1. Interpretar el modelado en vivo de un endpoint nuevo con subconsulta y replicar el ciclo completo (issue → rama → PR → merge).
2. Resolver en equipo los issues abiertos del trabajo final respetando criterios de aceptación y protección de `main`.
3. Mantener la integración continua del grupo: ramas cortas, PRs revisados y `main` siempre funcionando.
4. Autogestionar el sprint con acompañamiento docente decreciente (de la pregunta guía al desbloqueo puntual).

## 3. Teoría mínima

### Apertura y puente (20 min)

Tablero de cada grupo proyectado: issues cerrados, abiertos y ramas sin fusionar. Puente: «hoy es un día de construcción: un endpoint lo muestra el docente, el resto lo construyen ustedes con el flujo completo». Se acuerda el objetivo del sprint: al cierre del encuentro, cada grupo con todos sus PRs del día fusionados y `main` corriendo la API completa.

### El sprint: un turno de trabajo con objetivo claro

**Analogía — la guardia del hospital:** la guardia tiene una lista de pacientes asignados, se atiende por orden de necesidad y, al cambio de turno, pasa revisión. Un sprint es un bloque corto de trabajo con una lista de issues asignados y una revisión al final (los PRs fusionados). Dos reglas de guardia valen para el sprint:

- **Integración continua:** fusionar por PR seguido, no acumular; `main` tiene que funcionar en todo momento, porque todos construyen encima.
- **Acompañamiento decreciente:** el docente arranca mostrando (yo hago), sigue sosteniendo (hacemos), y termina desbloqueando solo lo trabado (hacés vos).

### El endpoint modelado: estadías largas con subconsulta

El docente modela en vivo un endpoint extra del trabajo final: `GET /admissions/long-stays?days=10`, los ingresos largos (de `days` días o más) de pacientes con más de un ingreso en su historial. Dos ideas nuevas en una sola consulta:

- **Subconsulta:** el `IN (SELECT patient_id ...)` filtra primero los pacientes con más de un ingreso, y después el JOIN arma el detalle.
- **Cálculo de estadía:** `julianday(fecha)` convierte una fecha ISO en número de días; la resta da los días internado. El canon se mantiene: las fechas viajan como `string`, el cálculo ocurre recién en la consulta.

Ojo con el dato sucio: las altas imposibles (requisito e) salen naturalmente del estadístico porque su estadía da negativa; y los ingresos sin alta se excluyen con `discharge_date IS NOT NULL`.

## 4. Práctica guiada — modelado en vivo (yo hago)

> El docente realiza el ciclo completo frente al grupo, narrando cada decisión. Los grupos replican el ciclo con SUS issues después, en el ejercicio independiente. Rotación: en cada grupo, un integrante distinto toma el rol de tester en cada replicación.

### Paso 1 — El issue primero

Crear en vivo el issue `#7` (número de ejemplo): título «Estadías largas de pacientes con reingresos», etiqueta `estadistica`, criterios de aceptación:

```markdown
## Criterios de aceptación
- [ ] GET /admissions/long-stays?days=10 responde 200 con la lista
- [ ] Solo incluye pacientes con más de un ingreso (subconsulta)
- [ ] Solo incluye estadías de `days` días o más, ordenadas desc
- [ ] Sin `days` (o con `days` menor o igual a 0) responde 400 con mensaje
```

### Paso 2 — La rama

```powershell
git switch main
git pull
git switch -c feature/estadias-largas
```

### Paso 3 — El endpoint

Agregar **antes** de `app.Run()`:

```csharp
// GET /admissions/long-stays?days=10: ingresos largos de pacientes con reingresos
app.MapGet("/admissions/long-stays", (int? days) =>
{
    // Validacion manual del parametro: sin days (o no positivo) no hay estadistica
    if (days is null || days <= 0)
    {
        return Results.BadRequest(new { mensaje = "Indique una cantidad de dias positiva, por ejemplo ?days=10" });
    }

    // using: la conexion se cierra sola al salir del handler
    using var connection = new SqliteConnection(connectionString);

    // Subconsulta: solo pacientes con MAS de un ingreso en su historial.
    // julianday convierte las fechas ISO en numeros de dias: la resta es la estadia.
    // discharge_date IS NOT NULL excluye ingresos que todavia no tienen alta.
    var stays = connection.Query<LongStay>(
        @"SELECT p.first_name || ' ' || p.last_name AS PatientName,
                 a.admission_date AS AdmissionDate,
                 a.discharge_date AS DischargeDate,
                 CAST(julianday(a.discharge_date) - julianday(a.admission_date) AS int) AS StayDays
          FROM admissions a
          JOIN patients p ON a.patient_id = p.patient_id
          WHERE a.patient_id IN (
                    SELECT patient_id FROM admissions
                    GROUP BY patient_id
                    HAVING COUNT(*) > 1)
            AND a.discharge_date IS NOT NULL
            AND (julianday(a.discharge_date) - julianday(a.admission_date)) >= @days
          ORDER BY StayDays DESC",
        new { days });

    // Siempre con lista: la estadistica responde 200 aunque venga vacia
    return Results.Ok(stays);
});
```

Agregar **al final** del archivo:

```csharp
// ---- Records: SIEMPRE al final, despues de app.Run() ----
record LongStay(string PatientName, string AdmissionDate, string? DischargeDate, int StayDays);
```

Probar los criterios:

```powershell
# 200 con la lista de estadias largas
curl "http://localhost:5080/admissions/long-stays?days=10"

# 400 sin parametro
curl -i http://localhost:5080/admissions/long-stays

# 400 con parametro invalido
curl -i "http://localhost:5080/admissions/long-stays?days=0"
```

Salida esperada (los valores concretos dependen de la base; el orden es por estadía descendente):

```json
[{"patientName":"Grace Walker","admissionDate":"2018-09-12","dischargeDate":"2018-10-20","stayDays":38}]
```

Las consultas sin `days` o con `days=0` responden `400` con `{"mensaje":"Indique una cantidad de dias positiva, por ejemplo ?days=10"}`.

### Paso 4 — El ciclo completo a velocidad de sprint

```powershell
git add .
git commit -m "trabajo-final: estadisticas de estadias largas (#7)"
git push -u origin feature/estadias-largas
```

Y en GitHub web: PR con `Closes #7`, revisión con la checklist (compila, criterios, legibilidad, secretos), aprobación por un integrante distinto, merge, borrado de la rama, `git switch main` + `git pull`. Narrar el tiempo: un ciclo issue → merge completo toma minutos, no días: esa es la integración continua.

## 5. Ejercicio independiente — el sprint (hacés vos)

**Consigna:** cada grupo resuelve el resto de sus issues abiertos con el flujo completo:

1. Ordenar el tablero: qué issues entran hoy (criterio: primero los que bloquean a otros; el README se cierra al final).
2. Por cada issue: rama nueva desde `main` actualizada → desarrollo → criterios probados con `curl` → commit con `(#N)` → push → PR → revisión entre pares → merge.
3. Mantener `main` viva: después de cada merge, `git pull` y una pasada de humo por los endpoints ya fusionados (que todo siga respondiendo).
4. Actualizar el README a medida que los endpoints pasan a `listo`.

**Pista:** rama corta, PR chico, merge rápido. Si un issue se traba más de 15 minutos, se anota la pregunta exacta (qué se intentó, qué error dice la terminal) y se consulta en la próxima ronda de mentoría.

## Extensión y consolidación — mentoría decreciente (hacemos / hacés vos)

El rol docente se ajusta en tres rondas durante el bloque:

1. **Ronda 1 (primer tercio):** preguntas guía antes de responder («¿qué dice el criterio de aceptación?», «¿qué error exacto te da la terminal?»).
2. **Ronda 2 (segundo tercio):** revisión de avance: cada grupo muestra un PR fusionado y explica una decisión técnica; correcciones solo por muestra.
3. **Ronda 3 (último tercio):** desbloqueo puntual de trabas reales; el docente no toca el teclado del grupo.

Para quienes completan antes: revisar el PR de otro grupo con la checklist (revisión cruzada), o incorporar el issue extra del sprint (por ejemplo, ingresos por mes con `strftime('%Y-%m', admission_date)` agrupado).

Consolidación docente: al cierre del bloque, tablero colectivo: cuántos issues cerró cada grupo y cuántos PRs fusionó; anunciar que lo que quede abierto se resuelve en el encuentro 31, que es el último de la unidad.

## 6. Cierre

### Qué te llevás

- El sprint es un turno de construcción: issues ordenados, ramas cortas, PRs revisados y `main` funcionando en todo momento.
- Una subconsulta (`IN (SELECT ...)`) resuelve preguntas de dos pasos: primero el conjunto (pacientes con reingresos), después el detalle.
- `julianday` permite calcular estadías desde fechas ISO que viajan como `string`: el cálculo se hace en la consulta, el record sigue con `string`.
- El ciclo issue → rama → PR → merge se vuelve rápido: minutos por feature, no encuentros.
- El acompañamiento docente baja de intensidad a propósito: la meta es que el grupo resuelva con sus propias herramientas.

### Lo que viene

Encuentro 31: el último de la unidad. Consolidación final (todo fusionado, README completo, issues cerrados), entrega del trabajo-final y preparación de la **defensa individual**: guion de demo en vivo de 5 a 7 minutos, preguntas anticipadas y rúbrica.

## 7. Errores comunes y trampas

| Error | Causa | Fix |
| --- | --- | --- |
| El sprint arranca con ramas viejas | El grupo no actualizó `main` antes de crear ramas | Ritual de arranque: `git switch main` + `git pull` antes de CADA rama |
| Un PR deja `main` rota | Se fusionó sin probar en local | Probar el feature en local antes del push; si `main` quedó rota, issue de hotfix inmediato en rama nueva y PR urgente |
| Subconsulta con error de sintaxis o GROUP BY mal puesto | SQL escrita de una sola vez sin probar | Probar la consulta por partes: primero la subconsulta, después el JOIN completo; el error exacto se lee en la terminal de `dotnet run` |
| Estadías con números raros (negativas o enormes) | `julianday` sobre altas imposibles o faltantes | Filtrar `discharge_date IS NOT NULL` y conectar con el requisito (e): la suciedad también enseña |
| Dos ramas tocan el mismo endpoint | Reparto de issues sin coordinación | Un endpoint por issue; si el conflicto existe, resolverlo en el PR con el docente antes del merge |
| Ignorar un 500 y «probar otra cosa» | Costumbre de adivinar en vez de leer | Regla de guardia: ante 500, leer el error completo de la terminal; el mensaje dice la línea y la causa |
