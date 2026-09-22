# Encuentro 30 — Avance trabajo final

> Profesionalización y proyecto final

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 30 de 36 |
| Unidad | 4 — Profesionalización y proyecto final |
| Eje temático | 6 — Profesionalización y control de versiones |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 240 minutos (4 horas reloj) |
| Concepto nuevo | Avance trabajo final |
| Requisitos previos | Encuentro 29: CRUD completo con JOINs funcionando contra hospital.db |
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

1. Planificar el trabajo final como un proyecto con fases y entregables.
2. Avanzar el trabajo final con commits por feature siguiendo el flujo profesional.
3. Verificar que cada feature se integra correctamente en `main` a través de PRs revisados.
4. Preparar la documentación del trabajo final (README técnico, instrucciones de ejecución).

## 3. Apertura y motivación (20 min)

### Charla rápida

Construir un proyecto final no es solo escribir código que funciona: es planificar el trabajo, avanzar en etapas claras y dejar un historial de cada decisión en los commits. Un buen flujo de trabajo profesional es como un cuaderno de notas bien organizado: cada página tiene una fecha, un propósito y un resultado. Los commits por feature son esas páginas: cada uno registra un paso concreto del proyecto.

### Puente desde el trabajo anterior

En el encuentro anterior, cada grupo consolidó el CRUD completo y los JOINs contra `hospital.db`. Ahora es momento de poner todo junto: planificar el trabajo final, avanzar con commits por feature y verificar que el flujo profesional de Git funciona de principio a fin. El trabajo final es la API con Dapper que va a defender cada grupo en el próximo encuentro.

## 4. Desarrollo teórico-práctico (120 min)

### 4.1 — Plan del trabajo final (40 min)

El trabajo final consiste en una API Minimal completa con Dapper que expone endpoints CRUD contra `hospital.db`. Antes de empezar a codificar, cada grupo debe planificar el trabajo en fases.

**Estructura sugerida del plan:**

| Fase | Descripción | Ramas de feature esperadas |
| --- | --- | --- |
| Fase 1 | Configuración del proyecto y README técnico | `feature/setup-project` |
| Fase 2 | CRUD completo de pacientes | `feature/crud-pacientes` |
| Fase 3 | CRUD completo de doctores | `feature/crud-doctorados` |
| Fase 4 | CRUD completo de admisiones | `feature/crud-admisiones` |
| Fase 5 | JOINs: pacientes con admisiones | `feature/join-pacientes-admisiones` |
| Fase 6 | JOINs: doctores con pacientes | `feature/join-doctorados-pacientes` |
| Fase 7 | Tests de integración básicos | `feature/test-integracion` |
| Fase 8 | README técnico y documentación final | `feature/readme-tecnico` |

**Práctica guiada:**

Cada grupo:
1. Abre un issue por cada fase del plan.
2. Asigna las fases a los integrantes del grupo.
3. Verifica que `main` está protegida y que el flujo de PRs está funcionando.

**Ejercicio independiente:**

Cada grupo completa la planificación del trabajo final: crea los issues, asigna las fases y define el orden de trabajo.

### 4.2 — Avance con commits por feature (40 min)

Ahora cada grupo empieza a trabajar en las primeras fases del plan, usando el flujo profesional de Git que aprendieron en los encuentros anteriores.

**Flujo de commits por feature:**

1. Crear rama de feature: `git checkout -b feature/<nombre>`.
2. Codificar la funcionalidad en `Program.cs`.
3. Probar localmente que funciona.
4. Commitear con mensaje descriptivo: `git commit -m "trabajo-final: <descripcion en espanol, sin tildes>"`
5. Push de la rama a GitHub.
6. Abrir PR hacia `main`.
7. Revisión por un compañero del grupo.
8. Fusionar y borrar la rama.

**Ejemplo de ciclo de commit:**

```bash
# Crear rama para la fase 1
git checkout -b feature/setup-project

# Realizar cambios en Program.cs
# ... agregar configuracion inicial, using directives, builder, app.Run(), records ...

# Commitear
git add .
git commit -m "trabajo-final: configuracion inicial del proyecto con using directives"

# Push y PR
git push origin feature/setup-project
# Abrir PR en GitHub, asignar revisor, fusionar
```

**Práctica guiada:**

El docente supervisa que cada grupo:
- Está usando ramas de feature y no trabajando en `main`.
- Los mensajes de commit siguen la convención del curso.
- Los PRs tienen revisión de un compañero antes de fusionar.

**Ejercicio independiente:**

Cada grupo completa al menos una fase del plan (recomendado: Fase 1 o Fase 2) con el ciclo completo de rama → commit → push → PR → revisión → merge.

### 4.3 — Revisión de avance entre grupos (40 min)

Cada grupo presenta brevemente su avance al resto de la clase:

- ¿Qué fases completó?
- ¿Qué ramas de feature tiene abiertas?
- ¿Cuántos PRs fueron fusionados?
- ¿Qué dificultades encontró?

**Práctica guiada:**

El docente facilita una ronda de presentaciones breves (3-5 min por grupo) y da retroalimentación sobre el flujo de Git y la calidad de los commits.

**Ejercicio independiente:**

Cada grupo actualiza su tabla de avance del trabajo final con el estado de cada fase y la marca los que completó.

## 5. Consolidación y cierre (20 min)

Revisión del avance del trabajo final:

- ¿Cada grupo tiene un plan con fases claras?
- ¿Los commits siguen la convención del curso (español, sin tildes, minúsculas tras los dos puntos)?
- ¿Los PRs se están fusionando con revisión de compañeros?
- ¿`main` permanece limpia durante todo el desarrollo?

El docente verifica el estado de los repositorios de cada grupo y da retroalimentación sobre el plan y el avance.

## 6. Actividad complementaria (80 min)

### Trabajo en grupo: avance del trabajo final con commits por feature

Cada grupo completa las siguientes tareas:

1. **Finalizar la planificación** (15 min): completar la tabla de fases, crear los issues restantes y asignar responsabilidades.
2. **Avanzar en las fases pendientes** (40 min): completar al menos una fase más del trabajo final con el ciclo completo de rama → commit → push → PR → revisión → merge.
3. **Verificar la integridad del flujo** (15 min): confirmar que `main` tiene solo fusiones por PR, que no hay commits directos y que cada PR tiene evidencia de revisión.
4. **Preparar el estado del repositorio** (10 min): asegurar que `Program.cs` tiene el código más reciente, que `hospital.db` está en la carpeta `trabajo-final/` y que el `.gitignore` está configurado correctamente.

La actividad de extensión incluye que los grupos que terminan temprano escriban un README técnico del trabajo final que documente: la arquitectura del proyecto, los endpoints disponibles, las decisiones de diseño tomadas y las instrucciones de ejecución paso a paso.

## 7. Cierre (15 min)

### Qué te llevás

- Un plan de trabajo final con fases claras y issues organizados.
- La práctica de commits por feature deja un historial limpio y trazable del desarrollo.
- El flujo profesional de Git (rama → PR → revisión → merge) se aplica de forma consistente durante todo el proyecto.
- `main` protegida garantiza que solo código revisado se integra.

## Lo que viene

Encuentro 31: Cierre U4: entrega final — van a realizar los últimos ajustes del trabajo final y a entregar por GitHub.

## 8. Errores comunes y trampas

| ✔ | Error | Causa probable | Intervención |
| --- | --- | --- | --- |
| ☐ | Commits en `main` en lugar de en rama de feature | No crear la rama antes de empezar a codear | Verificar que el grupo crea la rama `feature/<nombre>` antes de cualquier cambio |
| ☐ | Mensajes de commit en inglés o con tildes | No seguir la convención del curso | Recordar que los mensajes deben estar en español, sin tildes, con minúsculas después de los dos puntos |
| ☐ | PR fusionado sin revisión | Prisa por avanzar | Recordar que la revisión entre pares es obligatoria antes de fusionar |
| ☐ | No hay plan de fases, se empieza a codear sin orden | No planificar antes de implementar | Orientar a que el plan con issues es la base del trabajo profesional |
| ☐ | `main` tiene commits directos | Confusión sobre el flujo de trabajo | Verificar que `main` está protegida y que todos los cambios pasan por PR |
| ☐ | Commits con cambios mezclados de varias fases | No hacer commits atómicos por feature | Cada commit debe reflejar una sola fase o cambio lógico |
