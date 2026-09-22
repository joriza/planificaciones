# Encuentro 28 — README de portada y más

> Profesionalización y proyecto final

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 28 de 36 |
| Unidad | 4 — Profesionalización y proyecto final |
| Eje temático | 6 — Profesionalización y control de versiones |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 240 minutos (4 horas reloj) |
| Concepto nuevo | README de portada y más |
| Requisitos previos | Encuentro 27: flujo de ramas y PRs configurado en el repositorio del grupo |
| Uso de celular | No permitido |
| Organización del trabajo | Grupos de trabajo (presentes ÷ equipos disponibles); cada grupo opera su propio repositorio |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y motivación | 20 min |
| Desarrollo teórico-práctico | 120 min |
| Consolidación y cierre | 20 min |
| Actividad complementaria | 80 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

1. Escribir un README de portada que comunique el proyecto de forma clara y profesional.
2. Crear issues de GitHub para organizar el trabajo del proyecto final.
3. Verificar que la rama `main` permanezca protegida durante todo el flujo.
4. Documentar el proyecto con el mismo cuidado con el que se escribe código.

## 3. Apertura y motivación (20 min)

### Charla rápida

Un README de portada es como la fachada de un local comercial: si está limpia, ordenada y explica lo que se ofrece, la gente entra con confianza. Si está vacía o confusa, la gente se va y no vuelve. En el mundo del software, el README es la primera impresión que tiene cualquier persona que llega al repositorio — incluyendo el docente que va a evaluar el trabajo final.

### Puente desde el trabajo anterior

En el encuentro anterior, cada grupo configuró su flujo profesional con ramas de feature, PRs revisados y `main` protegida. Ahora falta un paso clave: documentar el proyecto. Un repositorio profesional no solo tiene código que funciona, sino que alguien que llega por primera vez entiende qué es el proyecto, cómo ejecutarlo y qué hace. Hoy van a armar el README de portada y van a organizar el trabajo con issues de GitHub.

## 4. Desarrollo teórico-práctico (120 min)

### 4.1 — README de portada del repositorio (40 min)

Un README de portada debe contener como mínimo:

1. **Nombre del proyecto** — claro y descriptivo.
2. **Descripción breve** — qué hace la API, en una o dos oraciones.
3. **Tecnologías utilizadas** — C# .NET 6, Minimal API, Dapper, SQLite.
4. **Cómo ejecutar el proyecto** — pasos para clonar, restaurar paquetes y ejecutar.
5. **Endpoints disponibles** — lista de rutas con método HTTP y descripción breve.
6. **Estructura del repositorio** — carpeta `trabajo-final/` con `Program.cs` y `hospital.db`.

**Práctica guiada:**

El docente muestra un ejemplo de README bien escrito en pantalla y analiza cada sección. Luego, cada grupo empieza a redactar el suyo propio.

**Ejemplo de sección de endpoints:**

```
## Endpoints

| Método | Ruta | Descripción |
| --- | --- | --- |
| GET | /patients | Listar todos los pacientes |
| GET | /patients/{id:long} | Obtener un paciente por ID |
| POST | /patients | Crear un nuevo paciente |
| PUT | /patients/{id:long} | Actualizar un paciente existente |
| DELETE | /patients/{id:long} | Eliminar un paciente |
```

**Ejercicio independiente:**

Cada grupo redacta las secciones del README de portada en un archivo `README.md` en la raíz de su repositorio. El README debe estar en español y cubrir al menos los 6 puntos de la lista.

### 4.2 — Issues para organizar el trabajo (40 min)

Los issues de GitHub son la forma de rastrear tareas, errores y mejoras en un proyecto. En el contexto del trabajo final, cada grupo debe crear issues que descompongan el trabajo en partes manejables.

**Ejemplos de issues para el trabajo final:**

- `feature/endpoint-pacientes` — Implementar CRUD completo de pacientes.
- `feature/endpoint-doctorados` — Agregar endpoints para doctores con JOINs.
- `feature/endpoint-pacientes-con-admisiones` — Endpoint que muestre pacientes con sus admisiones usando JOIN.
- `docs/readme-portada` — README de portada del repositorio.
- `test/integracion-basica` — Tests de integración básicos con la API.

**Práctica guiada:**

El docente muestra cómo:
1. Crear un issue desde GitHub (botón "New issue").
2. Usar labels para categorizar (feature, docs, test, bug).
3. Asignar el issue a un integrante del grupo.
4. Vincular un issue a un PR con `Closes #N`.

**Ejercicio independiente:**

Cada grupo crea al menos 3 issues que descompongan el trabajo final en tareas concretas. Cada issue tiene un título descriptivo y una breve descripción de lo que implica.

### 4.3 — Main protegida: verificación y mantenimiento (40 min)

La rama `main` protegida configurada en el encuentro anterior debe mantenerse así durante todo el desarrollo. Hoy se verifica que el flujo funciona correctamente y se refuerza la disciplina.

**Práctica guiada:**

Cada grupo:
1. Verifica que `main` está protegida (Settings → Branches).
2. Intenta hacer push directo a `main` y confirma que GitHub lo bloquea.
3. Abre un PR desde una rama de feature existente hacia `main`.
4. Asigna revisión a un compañero y espera la aprobación.

**Ejercicio independiente:**

Cada grupo completa al menos un ciclo completo de rama → PR → revisión → merge → borrar rama, verificando que `main` no recibe cambios directos.

## 5. Consolidación y cierre (20 min)

Revisión rápida de lo trabajado:

- ¿Cada grupo tiene un README de portada con al menos las 6 secciones?
- ¿Se crearon issues para organizar el trabajo final?
- ¿`main` está protegida y los PRs se están fusionando por la vía correcta?

El docente verifica en pantalla los repositorios de cada grupo y da retroalimentación inmediata sobre el README y los issues.

## 6. Actividad complementaria (80 min)

### Trabajo en grupo: README + Issues + Flujo de PRs

Cada grupo completa las siguientes tareas:

1. **Finalizar el README de portada** (20 min): completar todas las secciones pendientes, incluyendo la lista de endpoints y la estructura del repositorio.
2. **Crear y organizar issues** (15 min): al menos 3 issues con labels y asignación a integrantes.
3. **Completar un ciclo de PR completo** (25 min): crear una rama de feature, hacer un cambio documentado en el README o en código, abrir PR, revisar con compañero, fusionar y borrar rama.
4. **Verificar que `main` está limpia** (10 min): confirmar que no hay commits directos a `main` y que todas las fusiones pasaron por PR.
5. **Preparar la estructura del trabajo final** (10 min): asegurar que la carpeta `trabajo-final/` existe en el repositorio con `Program.cs` y `hospital.db` listos para el próximo encuentro.

La actividad de extensión incluye que los grupos que terminan temprano agreguen una sección de "Contribución" al README con las instrucciones para que otros grupos puedan clonar y ejecutar su API.

## 7. Cierre (15 min)

### Qué te llevás

- Un README de portada es la carta de presentación del proyecto: debe ser claro, completo y profesional.
- Los issues organizan el trabajo en tareas concretas y permiten跟踪 el progreso del equipo.
- La rama `main` protegida se mantiene como barrera de seguridad durante todo el desarrollo.
- El flujo de PRs con revisión interna del grupo es la práctica estándar en equipos profesionales.

## Lo que viene

Encuentro 29: Consolidación CRUD con JOINs — van a consolidar el CRUD completo sobre `hospital.db` y a agregar endpoints que usen JOINs para relacionar tablas.

## 8. Errores comunes y trampas

| ✔ | Error | Causa probable | Intervención |
| --- | --- | --- | --- |
| ☐ | README vacío o con solo el nombre del proyecto | No dedicar tiempo a documentar | Recordar que el README es la primera impresión del repositorio y debe cubrir al menos 6 secciones |
| ☐ | Issues sin descripción o con títulos vagos | No entender que el issue es una tarea concreta | Orientar a que cada issue tenga un título descriptivo y una breve descripción de lo que implica |
| ☐ | Hacer push directo a `main` después de configurar la protección | Confusión sobre el flujo de trabajo | Verificar que el grupo entiende que todo cambio pasa por una rama de feature y un PR |
| ☐ | PR fusionado sin revisión del grupo | Prisa por terminar | Recordar que la revisión entre pares es obligatoria antes de fusionar |
| ☐ | README en inglés | Convención del curso exige español en textos visibles | Los textos visibles al usuario y la documentación deben estar en español |
