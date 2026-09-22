# Anexo docente — Encuentro 27: Git profesional: ramas y PR

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

### Ejercicio: Crear rama de feature y abrir PR

**Solución paso a paso:**

1. Desde la terminal, en la carpeta del repositorio del grupo:
   ```bash
   git checkout main
   git pull origin main
   git checkout -b feature/crud-completo
   ```
2. Realizar un cambio en `Program.cs` (por ejemplo, agregar un nuevo endpoint o mejorar uno existente).
3. Commitear:
   ```bash
   git add .
   git commit -m "trabajo-final: agregar endpoint de pacientes"
   git push origin feature/crud-completo
   ```
4. Desde GitHub, abrir un PR de `feature/crud-completo` a `main`.
5. Asignar como revisor a otro integrante del grupo.

**Resultado esperado:** La rama `feature/crud-completo` existe en el repositorio remoto, el PR está abierto con al menos un revisor asignado, y `main` no recibió cambios directos.

## 2. Solución de la actividad de extensión

### Flujo profesional completo

**Pasos esperados para cada grupo:**

1. `main` protegida configurada (Settings → Branches → Branch protection rules → `main` → Require pull request, Require 1 approval).
2. Rama `feature/readme-portada` creada, README de portada preparado y commiteado.
3. Rama `feature/issues` creada, issues del repositorio llenados con las tareas del trabajo final.
4. Rama `feature/crud-completo` creada, CRUD completo verificado contra `hospital.db`.
5. Tres PRs abiertos (uno por feature), cada uno con al menos una revisión aprobada por un compañero.
6. PRs fusionados en orden lógico (readme primero, luego issues, luego crud).
7. Ramas de feature borradas después de fusionar.

**Criterio de éxito:** `main` tiene los tres merges, no hay commits directos a `main`, y cada PR tiene evidencia de revisión.

## 3. Respuesta esperada del ejercicio

| Pregunta de consolidación | Respuesta esperada |
| --- | --- |
| ¿Qué es una rama de feature? | Una copia aislada de `main` donde se desarrolla una funcionalidad sin afectar al resto del equipo |
| ¿Por qué `main` está protegida? | Para evitar que cambios sin revisar se integren directamente en la línea principal |
| ¿Quién revisa un PR? | Otro integrante del mismo grupo (revisión entre pares) |
| ¿Qué mensaje de commit se espera? | En español, minúsculas después de los dos puntos, sin tildes, con el prefijo de la carpeta |

## 4. Criterios de corrección (lista de verificación)

- ☐ Cada grupo tiene al menos una rama de feature creada y push al remoto.
- ☐ Al menos un PR está abierto desde una rama de feature hacia `main`.
- ☐ El PR tiene al menos un revisor asignado del mismo grupo.
- ☐ `main` está protegida (no se puede hacer push directo).
- ☐ Los mensajes de commit siguen la convención del curso (español, sin tildes, minúsculas tras los dos puntos).
- ☐ No hay commits directos a `main` durante el encuentro.

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| Push directo a `main` rechazado | Branch protection no configurada o mal configurada | Verificar que la regla de protección esté activa y que "Require a pull request" esté marcado |
| PR sin revisor asignado | No se asignó revisor al abrir el PR | Indicar que el PR debe tener al menos un revisor del mismo grupo antes de fusionar |
| Commit con tildes o en inglés | No se siguió la convención del curso | Recordar que los mensajes deben estar en español, sin tildes, con minúsculas después de los dos puntos |
| Cambios en `main` en lugar de en rama de feature | No se creó la rama antes de empezar a codear | Orientar al grupo a crear `git checkout -b feature/<nombre>` antes de cualquier cambio |
| PR fusionado sin revisión | Se saltearon el paso de revisión | Recordar que el flujo requiere al menos una aprobación antes de merge |

## 6. Registro de la clase

| Grupo | Ramas creadas | PRs abiertos | PRs revisados | Main protegida | Observaciones |
| --- | --- | --- | --- | --- | --- |
| Grupo 1 | | | | | |
| Grupo 2 | | | | | |
| Grupo 3 | | | | | |
| Grupo 4 | | | | | |

**Notas para evaluación de proceso:** verificar que cada grupo tenga al menos un PR con revisión aprobada y que `main` esté protegida. Registrar qué grupos completaron el flujo completo y cuáles necesitan acompañamiento adicional.
