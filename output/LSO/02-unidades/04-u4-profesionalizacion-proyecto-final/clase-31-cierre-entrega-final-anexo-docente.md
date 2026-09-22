# Anexo docente — Encuentro 31: Cierre U4: entrega final

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

### Solución: Últimos ajustes del trabajo final

**Verificación final del repositorio:**

1. **Código en `Program.cs`:**
   - Todos los endpoints CRUD funcionan para `patients`, `doctors` y `admissions`.
   - Los JOINs funcionan para `/patients-with-admissions` y `/doctors-with-patients`.
   - Los records están al final del archivo, después de `app.Run()`.
   - Los tipos canónicos se respetan: `long` para IDs, `string` para fechas, `?` para nullable.
   - Todas las consultas están parametrizadas.

2. **`hospital.db` en la carpeta `trabajo-final/`:**
   - La base de datos está junto al `.csproj`.
   - La cadena de conexión es `"Data Source=hospital.db"`.

3. **`.gitignore` en la raíz:**
   - Incluye `bin/` y `obj/`.

4. **README de portada completo:**
   - Nombre del proyecto, descripción, tecnologías, cómo ejecutar, endpoints disponibles, estructura del repositorio.

5. **Issues organizados:**
   - Al menos las fases del trabajo final creadas como issues.

6. **Historial de commits limpio:**
   - Mensajes descriptivos en español, sin tildes, con el prefijo de la carpeta.

7. **PRs revisados y fusionados:**
   - No hay cambios pendientes en ramas de feature abiertas.

8. **`main` protegida:**
   - La rama principal está protegida y no recibe push directo.

### Solución: Entrega por GitHub

**Comando de commit final de cierre:**

```bash
# Verificar que estamos en main y que tiene los ultimos cambios
git checkout main
git pull origin main

# Verificar que la API arranca
dotnet run
# En otra terminal: curl http://localhost:5000/patients

# Commit final de cierre
git add .
git commit -m "trabajo-final: entrega final, api completa con crud y joins"
git push origin main
```

**Resultado esperado:** El repositorio está en estado de entrega: `main` tiene el código más reciente, la API arranca sin errores, el README está completo y el historial de commits es limpio.

### Solución: Preparación para la defensa individual

**Guía de presentación sugerida (5-10 min):**

1. **Arquitectura del proyecto** (1 min): explicar que es una Minimal API con Dapper, un solo archivo `Program.cs`, base de datos SQLite `hospital.db`.
2. **Endpoints disponibles** (2 min): mostrar la tabla de endpoints y explicar qué hace cada uno.
3. **Decisiones de diseño** (2 min): explicar por qué se usan tipos canónicos (`long` para IDs, `string` para fechas), por qué las consultas están parametrizadas y por qué los records van al final.
4. **Demostración en vivo** (3-5 min): mostrar la API funcionando con `curl` o Thunder Client.
5. **Flujo profesional de Git** (1 min): explicar las ramas por feature, los PRs revisados y `main` protegida.

## 2. Solución de la actividad de extensión

### Tests de integración finales

Los tests de integración finales verifican que todos los endpoints responden correctamente:

```csharp
// Test: GET /patients devuelve 200
using var client = new HttpClient();
var response = await client.GetAsync("http://localhost:5000/patients");
Assert.Equal(HttpStatusCode.OK, response.StatusCode);

// Test: GET /patients/1 devuelve 200
response = await client.GetAsync("http://localhost:5000/patients/1");
Assert.Equal(HttpStatusCode.OK, response.StatusCode);

// Test: GET /patients/99999 devuelve 404
response = await client.GetAsync("http://localhost:5000/patients/99999");
Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);

// Test: POST /patients con datos validos devuelve 201
var json = "{ \"firstName\": \"Ana\", \"lastName\": \"Lopez\", \"gender\": \"F\", \"birthDate\": \"1990-01-15\" }";
var content = new StringContent(json, Encoding.UTF8, "application/json");
response = await client.PostAsync("http://localhost:5000/patients", content);
Assert.Equal(HttpStatusCode.Created, response.StatusCode);

// Test: POST /patients con nombre vacio devuelve 400
json = "{ \"firstName\": \"\", \"lastName\": \"Lopez\" }";
content = new StringContent(json, Encoding.UTF8, "application/json");
response = await client.PostAsync("http://localhost:5000/patients", content);
Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
```

### Preguntas de práctica para la defensa (simulacro de evaluadores)

Los grupos que terminan temprano pueden preparar preguntas de práctica para la defensa de otros grupos:

1. ¿Por qué usas `long` en lugar de `int` para los IDs?
2. ¿Qué pasa si concatenas un valor al SQL en lugar de usar un parámetro?
3. ¿Por qué los records van después de `app.Run()`?
4. ¿Cómo funciona un JOIN entre `patients` y `admissions`?
5. ¿Qué es `splitOn` en Dapper y por qué lo necesitas?
6. ¿Por qué la rama `main` está protegida?
7. ¿Qué es un pull request y por qué se revisa entre pares?

## 3. Respuesta esperada del ejercicio

| Tarea | Resultado esperado |
| --- | --- |
| Últimos ajustes | API completa funcionando, tipos canónicos correctos, README completo, commits limpios |
| Entrega por GitHub | Commit final de cierre con mensaje descriptivo, push a `main`, repositorio en estado de entrega |
| Preparación para la defensa | Presentación breve lista, demostración en vivo funcionando, respuestas a preguntas técnicas preparadas |
| Tests de integración finales | Al menos 5 tests que verifican 200, 201, 204, 400, 404 pasan contra la API |
| Preguntas de práctica (extensión) | Al menos 5 preguntas de práctica para la defensa de otros grupos |

## 4. Criterios de corrección (lista de verificación)

- ☐ API completa funcionando: todos los endpoints CRUD para `patients`, `doctors` y `admissions` responden correctamente.
- ☐ JOINs funcionales: `/patients-with-admissions` y `/doctors-with-patients` devuelven datos relacionados.
- ☐ Tipos canónicos correctos: `long` para IDs, `string` para fechas, `?` para nullable.
- ☐ Consultas parametrizadas: ninguna concatenación de valores en SQL.
- ☐ Records al final del archivo, después de `app.Run()`.
- ☐ `hospital.db` en la carpeta `trabajo-final/` junto al `.csproj`.
- ☐ `.gitignore` en la raíz con `bin/` y `obj/`.
- ☐ README de portada completo con al menos 6 secciones.
- ☐ Issues organizados con al menos las fases del trabajo final.
- ☐ Historial de commits limpio con mensajes descriptivos en español.
- ☐ `main` protegida y sin commits directos.
- ☐ PRs revisados y fusionados antes de la entrega.
- ☐ Commit final de cierre con mensaje descriptivo.
- ☐ Grupo preparado para la defensa individual (presentación y demostración).

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| API no arranca al clonar el repositorio | `hospital.db` no está en la carpeta correcta o cadena de conexión incorrecta | Verificar que `hospital.db` está en `trabajo-final/` junto al `.csproj` y que la cadena es `"Data Source=hospital.db"` |
| `InvalidOperationException` al ejecutar endpoints | Tipos canónicos incorrectos en el record | Verificar que los IDs usan `long`, las fechas usan `string` y los campos nullable usan `?` |
| Commit de entrega con mensaje genérico | No dedicar tiempo al mensaje de commit | El mensaje final debe ser descriptivo: `trabajo-final: entrega final, api completa con crud y joins` |
| Rama de feature sin fusionar al momento de la entrega | PRs pendientes que no se fusionaron | Verificar que `main` tiene todos los cambios y que no hay ramas de feature abiertas innecesarias |
| README incompleto o faltante | No dedicar tiempo a la documentación | El README de portada es parte de la entrega profesional y se evalúa |
| Grupo no preparado para la defensa | No ensayar la presentación | Dedicar tiempo del ensayo a practicar la exposición y preparar respuestas para preguntas técnicas |
| Tests de integración fallan | API no está corriendo o puerto incorrecto | Verificar que `dotnet run` está ejecutándose y el puerto es el correcto |
| `main` recibe push directo | Branch protection no configurada correctamente | Verificar que la regla de protección está activa para `main` y que requiere PR |

## 6. Registro de la clase

| Grupo | API completa | Tipos canónicos correctos | Consultas parametrizadas | README completo | Commits limpios | Main protegida | PRs fusionados | Listo para defensa | Observaciones |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Grupo 1 | | | | | | | | | |
| Grupo 2 | | | | | | | | | |
| Grupo 3 | | | | | | | | | |
| Grupo 4 | | | | | | | | | |

**Notas para evaluación de proceso:** verificar que cada grupo tenga la API completa funcionando, el repositorio en estado de entrega y esté preparado para la defensa individual. Registrar qué grupos necesitan acompañamiento adicional antes de la defensa.
