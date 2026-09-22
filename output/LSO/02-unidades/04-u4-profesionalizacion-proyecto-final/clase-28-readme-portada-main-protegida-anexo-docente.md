# Anexo docente — Encuentro 28: README de portada y más

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

### Solución: README de portada

**Estructura mínima del README.md:**

```markdown
# API de Hospital — Minimal API con C# .NET 6

API Minimal que expone endpoints CRUD para gestionar pacientes, doctores y admisiones de un hospital. Utiliza Dapper para el acceso a datos y SQLite como base de datos (`hospital.db`).

## Tecnologías

- C# .NET 6
- Minimal API
- Dapper
- SQLite

## Cómo ejecutar

```bash
git clone <url-del-repo>
cd trabajo-final
dotnet run
```

La API queda disponible en `http://localhost:5000` (o el puerto asignado por .NET).

## Endpoints

| Método | Ruta | Descripción |
| --- | --- | --- |
| GET | /patients | Listar todos los pacientes |
| GET | /patients/{id:long} | Obtener un paciente por ID |
| POST | /patients | Crear un nuevo paciente |
| PUT | /patients/{id:long} | Actualizar un paciente existente |
| DELETE | /patients/{id:long} | Eliminar un paciente |
| GET | /patients-with-admissions | Listar pacientes con sus admisiones (JOIN) |

## Estructura del repositorio

```
trabajo-final/
├── Program.cs          # Código completo de la API
├── hospital.db         # Base de datos SQLite
├── .gitignore          # Ignora bin/ y obj/
└── README.md           # Este archivo
```
```

**Resultado esperado:** El README cubre las 6 secciones mínimas, está en español, y se encuentra en la raíz del repositorio.

### Solución: Issues para organizar el trabajo

**Ejemplo de issue 1 — `feature/endpoint-pacientes`:**
- Título: `feature/endpoint-pacientes`
- Descripción: Implementar CRUD completo de pacientes con endpoints GET, POST, PUT y DELETE contra `hospital.db`.
- Label: `feature`
- Asignado a: integrante responsable del CRUD.

**Ejemplo de issue 2 — `feature/endpoint-joins`:**
- Título: `feature/endpoint-joins`
- Descripción: Agregar endpoints que muestren datos de múltiples tablas usando JOINs (pacientes con admisiones, doctores con pacientes).
- Label: `feature`
- Asignado a: integrante responsable de los JOINs.

**Ejemplo de issue 3 — `test/integracion-basica`:**
- Título: `test/integracion-basica`
- Descripción: Agregar tests de integración básicos que verifiquen que los endpoints responden con los códigos HTTP esperados (200, 201, 204, 400, 404).
- Label: `test`
- Asignado a: integrante responsable de tests.

## 2. Solución de la actividad de extensión

### README con sección de contribución

Los grupos que terminan temprano pueden agregar una sección de "Contribución" al README:

```markdown
## Contribución

1. Fork del repositorio.
2. Crear una rama de feature: `git checkout -b feature/<nombre>`.
3. Realizar los cambios y commitear con mensaje descriptivo.
4. Abrir un pull request hacia `main`.
5. Esperar la revisión de un compañero antes de fusionar.
```

### Checklist de flujo de PRs

- ☐ `main` está protegida (no se puede hacer push directo).
- ☐ Cada cambio se hace en una rama de feature.
- ☐ Cada PR tiene al menos un revisor del mismo grupo.
- ☐ El PR incluye una descripción de los cambios realizados.
- ☐ El PR es aprobado y fusionado.
- ☐ La rama de feature se borra después de fusionar.

## 3. Respuesta esperada del ejercicio

| Tarea | Resultado esperado |
| --- | --- |
| README de portada | Archivo `README.md` en la raíz con al menos 6 secciones: nombre, descripción, tecnologías, ejecución, endpoints, estructura |
| Issues | Al menos 3 issues con títulos descriptivos, labels y asignación a integrantes |
| Ciclo de PR | Al menos un PR fusionado con revisión aprobada, sin commits directos a `main` |
| `main` protegida | Branch protection rule activa para `main` con "Require pull request" y "Require 1 approval" |

## 4. Criterios de corrección (lista de verificación)

- ☐ README de portada presente en la raíz del repositorio con al menos 6 secciones completas.
- ☐ README está en español (textos visibles y documentación).
- ☐ Se crearon al menos 3 issues con títulos descriptivos.
- ☐ Los issues tienen labels para categorización.
- ☐ `main` está protegida y no recibe push directo.
- ☐ Al menos un PR fue revisado y fusionado por un compañero del grupo.
- ☐ No hay commits directos a `main` durante el encuentro.

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| README en inglés o con textos en inglés | Convención del curso exige español en textos visibles | Recordar que el README es documentación del proyecto y debe estar en español |
| Issues sin descripción o con títulos tipo "cambios" | No entender que el issue es una tarea concreta | Orientar a escribir títulos descriptivos que indiquen qué funcionalidad se implementa |
| PR fusionado sin revisión | Prisa o confusión sobre el flujo | Verificar que el grupo entiende que la revisión entre pares es obligatoria antes de merge |
| Push directo a `main` exitoso | Branch protection mal configurada | Verificar que la regla incluya "Require a pull request" y "Include administrators" |
| README faltante o vacío | No dedicar tiempo a la documentación | Enfatizar que el README es parte del trabajo profesional y se evalúa |

## 6. Registro de la clase

| Grupo | README completo | Issues creados | PRs revisados | Main protegida | Observaciones |
| --- | --- | --- | --- | --- | --- |
| Grupo 1 | | | | | |
| Grupo 2 | | | | | |
| Grupo 3 | | | | | |
| Grupo 4 | | | | | |

**Notas para evaluación de proceso:** verificar que cada grupo tenga README completo, issues organizados y al menos un PR fusionado con revisión. Registrar qué grupos necesitan acompañamiento adicional en documentación o en el flujo de PRs.
