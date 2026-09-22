# Anexo docente — Encuentro 30: Avance trabajo final

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

### Solución: Plan del trabajo final

**Plan de fases sugerido para el trabajo final:**

| Fase | Ramas de feature | Entregable | Criterio de éxito |
| --- | --- | --- | --- |
| Fase 1: Setup | `feature/setup-project` | `Program.cs` con using directives, builder, app.Run(), records; `hospital.db` en la carpeta `trabajo-final/`; `.gitignore` con `bin/` y `obj/` | API arranca sin errores |
| Fase 2: CRUD Pacientes | `feature/crud-pacientes` | 5 endpoints para pacientes (GET list, GET by id, POST, PUT, DELETE) | Todos los endpoints responden con los códigos HTTP correctos |
| Fase 3: CRUD Doctores | `feature/crud-doctorados` | 5 endpoints para doctores | Todos los endpoints responden con los códigos HTTP correctos |
| Fase 4: CRUD Admisiones | `feature/crud-admisiones` | 5 endpoints para admisiones | Todos los endpoints responden con los códigos HTTP correctos |
| Fase 5: JOIN Pacientes-Admisiones | `feature/join-pacientes-admisiones` | Endpoint `/patients-with-admissions` con JOIN | Devuelve pacientes con sus admisiones agrupadas |
| Fase 6: JOIN Doctores-Pacientes | `feature/join-doctorados-pacientes` | Endpoint `/doctors-with-patients` con JOIN | Devuelve doctores con sus pacientes agrupados |
| Fase 7: Tests de integración | `feature/test-integracion` | Tests básicos que verifican 200, 201, 204, 400, 404 | Tests pasan contra la API en ejecución |
| Fase 8: README técnico | `feature/readme-tecnico` | README con arquitectura, endpoints, decisiones de diseño e instrucciones de ejecución | README completo y en español |

### Solución: Avance con commits por feature

**Ejemplo de ciclo completo para Fase 2 (CRUD Pacientes):**

```bash
# 1. Crear rama de feature
git checkout -b feature/crud-pacientes

# 2. Codificar los 5 endpoints de pacientes en Program.cs
# (GET list, GET by id, POST, PUT, DELETE con Dapper y hospital.db)

# 3. Probar localmente
dotnet run
# curl http://localhost:5000/patients
# curl http://localhost:5000/patients/1

# 4. Commitear con mensaje descriptivo
git add .
git commit -m "trabajo-final: crud completo de pacientes con endpoints get post put delete"

# 5. Push de la rama
git push origin feature/crud-pacientes

# 6. Abrir PR en GitHub desde feature/crud-pacientes a main
# Asignar revisor (compañero del grupo)

# 7. Esperar revision y fusionar
# Borrar rama despues de fusionar
git branch -d feature/crud-pacientes
```

## 2. Solución de la actividad de extensión

### README técnico del trabajo final

El README técnico debe contener como mínimo:

```markdown
# Trabajo Final — API de Hospital con Dapper

## Arquitectura

Proyecto de Minimal API con C# .NET 6 que expone endpoints CRUD contra la base de datos SQLite `hospital.db`. Todo el código vive en un único archivo `Program.cs` con top-level statements. Dapper se usa para el acceso a datos y las conexiones se abren con `using var` dentro de cada handler.

## Endpoints disponibles

| Método | Ruta | Descripción |
| --- | --- | --- |
| GET | /patients | Listar todos los pacientes |
| GET | /patients/{id:long} | Obtener un paciente por ID |
| POST | /patients | Crear un nuevo paciente |
| PUT | /patients/{id:long} | Actualizar un paciente existente |
| DELETE | /patients/{id:long} | Eliminar un paciente |
| GET | /patients-with-admissions | Listar pacientes con sus admisiones (JOIN) |
| GET | /doctors | Listar todos los doctores |
| GET | /doctors/{id:long} | Obtener un doctor por ID |
| POST | /doctors | Crear un nuevo doctor |
| PUT | /doctors/{id:long} | Actualizar un doctor existente |
| DELETE | /doctors/{id:long} | Eliminar un doctor |
| GET | /admissions | Listar todas las admisiones |
| GET | /admissions/{id:long} | Obtener una admision por ID |
| POST | /admissions | Crear una nueva admision |
| PUT | /admissions/{id:long} | Actualizar una admision existente |
| DELETE | /admissions/{id:long} | Eliminar una admision |
| GET | /doctors-with-patients | Listar doctores con sus pacientes (JOIN) |

## Decisiones de diseño

- **Un solo archivo:** todo el código vive en `Program.cs` con top-level statements.
- **Records posicionales al final:** despues de `app.Run()` para evitar CS8803.
- **Tipos canonicos:** `long` para IDs INTEGER, `string` para fechas, `?` para campos nullable.
- **Consultas parametrizadas:** siempre con `@param` y `new { param }`.
- **Sin abstracciones:** no se usa patron repositorio, inyeccion de dependencias ni carpetas Models/Services/Controllers.

## Como ejecutar

```bash
git clone <url-del-repo>
cd trabajo-final
dotnet run
```

La API queda disponible en `http://localhost:5000` (o el puerto asignado por .NET).
```

## 3. Respuesta esperada del ejercicio

| Tarea | Resultado esperado |
| --- | --- |
| Plan de fases | Tabla con al menos 5 fases, cada una con nombre de rama de feature y entregable |
| Issues creados | Al menos un issue por fase del plan |
| Commits por feature | Al menos un commit atómico por feature con mensaje descriptivo en español |
| PRs revisados | Al menos un PR fusionado con revisión de compañero |
| `main` limpia | Sin commits directos, solo fusiones por PR |
| README técnico (extensión) | Arquitectura, endpoints, decisiones de diseño e instrucciones de ejecución |

## 4. Criterios de corrección (lista de verificación)

- ☐ El plan del trabajo final tiene al menos 5 fases con nombres de ramas de feature.
- ☐ Cada fase tiene un issue correspondiente en el repositorio.
- ☐ Los commits siguen la convención del curso (español, sin tildes, minúsculas tras los dos puntos).
- ☐ Cada commit es atómico y corresponde a una sola fase o cambio lógico.
- ☐ Los PRs tienen revisión de al menos un compañero del grupo.
- ☐ `main` no tiene commits directos durante el desarrollo.
- ☐ `Program.cs` tiene el código más reciente con todas las fases completadas.
- ☐ `hospital.db` está en la carpeta `trabajo-final/` junto al `.csproj`.
- ☐ El `.gitignore` ignora `bin/` y `obj/`.
- ☐ El README técnico (extensión) cubre al menos arquitectura, endpoints y decisiones de diseño.

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| Commits en `main` en lugar de en rama de feature | No crear la rama antes de empezar a codear | Verificar que el grupo crea la rama `feature/<nombre>` antes de cualquier cambio |
| Mensajes de commit en inglés o con tildes | No seguir la convención del curso | Recordar que los mensajes deben estar en español, sin tildes, con minúsculas después de los dos puntos |
| PR fusionado sin revisión | Prisa por avanzar | Recordar que la revisión entre pares es obligatoria antes de fusionar |
| No hay plan de fases | No planificar antes de implementar | Orientar a que el plan con issues es la base del trabajo profesional |
| `main` tiene commits directos | Confusión sobre el flujo de trabajo | Verificar que `main` está protegida y que todos los cambios pasan por PR |
| Commits con cambios mezclados de varias fases | No hacer commits atómicos por feature | Cada commit debe reflejar una sola fase o cambio lógico |
| README técnico faltante o incompleto | No dedicar tiempo a la documentación | Enfatizar que el README técnico es parte del trabajo profesional y se evalúa |

## 6. Registro de la clase

| Grupo | Fases completadas | Commits por feature | PRs revisados | `main` limpia | Observaciones |
| --- | --- | --- | --- | --- | --- |
| Grupo 1 | | | | | |
| Grupo 2 | | | | | |
| Grupo 3 | | | | | |
| Grupo 4 | | | | | |

**Notas para evaluación de proceso:** verificar que cada grupo tenga un plan de fases, commits atómicos por feature y PRs revisados. Registrar qué grupos necesitan acompañamiento adicional en planificación o en el flujo de Git.
