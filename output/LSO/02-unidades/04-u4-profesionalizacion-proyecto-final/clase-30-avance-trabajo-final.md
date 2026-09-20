# Encuentro 30 — Avance trabajo final

**Unidad 4:** Profesionalización y proyecto final
**Carácter:** Procedimental
**Duración:** 240 minutos

---

## Objetivos de aprendizaje

- Integrar todos los endpoints del CRUD completo con JOINs en el trabajo final.
- Implementar funcionalidades faltantes según el alcance definido por cada grupo.
- Verificar el funcionamiento de cada endpoint con pruebas manuales.
- Preparar la defensa individual del trabajo final.

---

## Reparto de tiempos (240 minutos)

| Bloque | Minutos |
|---|---|
| Apertura y motivación | 20 |
| Desarrollo teórico-práctico | 120 |
| Consolidación y cierre | 20 |
| Actividad complementaria / trabajo final | 80 |
| **Total** | **240** |

---

## Teoría mínima

### El trabajo final: alcance mínimo

Cada grupo debe tener, al finalizar este encuentro, un proyecto funcional en `trabajo-final/` que incluya:

| Endpoint | Descripción | Estado ideal |
|---|---|---|
| `GET /patients` | Listar todos los pacientes | Funcional |
| `GET /patients/{id:long}` | Obtener paciente por ID | Funcional |
| `GET /patients/with-province` | Pacientes con nombre de provincia | Funcional |
| `GET /patients/count-by-province` | Conteo de pacientes por provincia | Funcional |
| `POST /patients` | Crear paciente | Funcional |
| `PUT /patients/{id:long}` | Actualizar paciente | Funcional |
| `DELETE /patients/{id:long}` | Eliminar paciente | Funcional |
| `GET /doctors/{id:long}` | Doctor con conteo de admisiones | Funcional |
| `GET /admissions/with-doctors-patients` | Admisiones con datos completos | Funcional (ideal) |
| `GET /doctors` | Listar todos los doctores | Deseable |
| `GET /admissions` | Listar todas las admisiones | Deseable |

### Verificación sistemática

Cada endpoint se verifica con la siguiente rutina:

1. Probar el endpoint con `curl` o Thunder Client.
2. Confirmar el código HTTP (200, 201, 204, 400, 404).
3. Confirmar la estructura del JSON de respuesta.
4. Si falla, leer el mensaje de error en la terminal y corregir.

### Preparación de la defensa

En el encuentro 31, cada integrante debe:

- Explicar qué hace cada endpoint de su trabajo final.
- Mostrar el código de al menos dos endpoints (GET con JOIN y POST con validación).
- Responder preguntas conceptuales sobre Dapper, tipos canónicos y HTTP.
- Demostrar el flujo Git profesional (ramas, PR, main protegida).

---

## Práctica guiada

### Paso 1: Inventario del trabajo final

Cada grupo revisa su repositorio y verifica qué endpoints tiene implementados en `trabajo-final/`. Usar la tabla anterior como checklist.

### Paso 2: Implementar endpoints faltantes

Para los endpoints que falten, los grupos toman el código de los encuentros anteriores y lo adaptan a su `Program.cs`. El docente circula para ayudar.

### Paso 3: Verificar cada endpoint

Cada grupo ejecuta `dotnet run` y prueba cada endpoint con `curl`:

```bash
# Listar pacientes
curl http://localhost:5000/patients

# Paciente por ID
curl http://localhost:5000/patients/1

# Pacientes con provincia
curl http://localhost:5000/patients/with-province

# Conteo por provincia
curl http://localhost:5000/patients/count-by-province

# Crear paciente
curl -X POST http://localhost:5000/patients \
  -H "Content-Type: application/json" \
  -d '{"firstName":"Maria","lastName":"Garcia","gender":"F","birthDate":"1992-08-25","city":"Cordoba","provinceId":2}'

# Actualizar paciente
curl -X PUT http://localhost:5000/patients/1 \
  -H "Content-Type: application/json" \
  -d '{"firstName":"John","lastName":"Smith","gender":"M","birthDate":"1963-02-12","city":"Buenos Aires","provinceId":1,"allergies":"Penicilina"}'

# Eliminar paciente
curl -X DELETE http://localhost:5000/patients/999

# Doctor con conteo
curl http://localhost:5000/doctors/1
```

Cada fallo se anota y se corrige inmediatamente.

### Paso 4: Consolidar en main

Cuando el trabajo final está completo y verificado, se sube a `main` siguiendo el flujo profesional:

```bash
git checkout main
git pull origin main
git checkout -b feature/trabajo-final-completo
# copiar o asegurar que trabajo-final/ tiene el Program.cs actualizado
git add .
git commit -m "trabajo-final: version completa con CRUD y JOINs"
git push origin feature/trabajo-final-completo
```

Abrir PR, asignar revisor, mergear.

---

## Ejercicio independiente

Cada grupo elige y completa **dos funcionalidades adicionales** de las siguientes:

1. `GET /doctors` — listar todos los doctores con su especialidad.
2. `GET /admissions` — listar todas las admisiones con JOIN completo.
3. `GET /patients?search={texto}` — filtrar pacientes por apellido usando `LIKE`.
4. `GET /patients/{id:long}/admissions` — historial de admisiones de un paciente.

**Pista:** el filtro por apellido usa SQL parametrizado con `LIKE`:

```csharp
app.MapGet("/patients", (string? search) =>
{
    using var connection = new SqliteConnection(connectionString);
    if (string.IsNullOrWhiteSpace(search))
    {
        var all = connection.Query<Patient>(...).ToList();
        return Results.Ok(all);
    }
    var filtered = connection.Query<Patient>(@"
        SELECT patient_id AS PatientId, first_name AS FirstName, ...
        FROM patients
        WHERE last_name LIKE @pattern", new { pattern = $"%{search}%" }).ToList();
    return Results.Ok(filtered);
});
```

**Solución esperada:** al menos dos endpoints adicionales funcionando, probados e integrados en `main` mediante PR.

---

## Cierre

**Qué te llevás:** el trabajo final es la integración de todo lo aprendido: una API REST completa con cuatro tablas, CRUD, JOINs y flujo Git profesional. En este encuentro se consolidan las funcionalidades y se deja todo listo para la defensa.

**Lo que viene:** en el encuentro 31 es la entrega y defensa final. Cada integrante presenta su trabajo individualmente y responde preguntas. El README debe estar completo y el repositorio profesional.

---

## Errores comunes y trampas

| Error | Causa | Solución |
|---|---|---|
| Endpoint devuelve 500 porque la base no se copió | `hospital.db` no está junto al `.csproj` | Copiar la base a la carpeta del proyecto y verificar la ruta. |
| POST devuelve 400 por validación | Falta el `if` de `string.IsNullOrWhiteSpace` | Agregar la validación antes de ejecutar el INSERT. |
| PUT no actualiza nada | El UPDATE no encuentra el registro o el SQL está mal | Verificar que el `WHERE patient_id = @id` coincida con el parámetro enviado. |
| DELETE devuelve 204 aunque el recurso no exista | Falta la verificación con `QueryFirstOrDefault` | Agregar el chequeo de existencia antes de borrar. |
| Conflictos al mergear el PR | Dos integrantes modificaron el mismo `Program.cs` en paralelo | Comunicarse antes de pushear; resolver conflictos localmente si ocurren. |
| No se puede defender porque el código no está en main | Los cambios quedaron en una rama sin mergear | Verificar que `main` tenga la última versión antes del encuentro 31. |