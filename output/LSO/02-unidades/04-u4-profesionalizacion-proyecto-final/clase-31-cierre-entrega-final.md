# Encuentro 31 — Cierre U4: entrega final

> Profesionalización y proyecto final

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 31 de 36 |
| Unidad | 4 — Profesionalización y proyecto final |
| Eje temático | 6 — Profesionalización y control de versiones |
| Carácter/Objetivo | Actitudinal |
| Estructura | cierre |
| Duración teórica | 240 minutos (4 horas reloj) |
| TP obligatorio | Trabajo final: API con Dapper |
| Concepto nuevo | Cierre U4: entrega final |
| Requisitos previos | Encuentro 30: plan del trabajo final y avance con commits por feature |
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

1. Realizar los últimos ajustes del trabajo final antes de la entrega.
2. Verificar que el repositorio cumple con todos los criterios de entrega profesional.
3. Entregar el trabajo final por GitHub con todo el historial de commits.
4. Prepararse para la defensa individual del trabajo integrador.

## 3. Apertura y motivación (20 min)

### Charla rápida

Entregar un trabajo final no es solo subir código a un repositorio: es presentar un producto terminado, documentado y revisado. En la industria del software, la entrega final de un proyecto incluye código funcional, documentación clara y un historial de desarrollo que muestre cómo se tomó cada decisión. Hoy es el día de la entrega: cada grupo va a verificar que su repositorio está listo y va a subir el trabajo final.

### Puente desde el trabajo anterior

En el encuentro anterior, cada grupo planificó el trabajo final y avanzó con commits por feature. Ahora queda el paso final: los últimos ajustes, la verificación de que todo funciona y la entrega por GitHub. Después de este encuentro, viene la defensa individual del trabajo integrador.

## 4. Desarrollo teórico-práctico (120 min)

### 4.1 — Últimos ajustes del trabajo final (40 min)

Cada grupo revisa su repositorio y realiza los últimos ajustes necesarios para que la entrega sea completa y profesional.

**Lista de verificación de últimos ajustes:**

1. **Código completo en `Program.cs`** — todos los endpoints funcionan, los records están al final del archivo (después de `app.Run()`), los tipos canónicos se respetan (`long` para IDs, `string` para fechas, `?` para nullable).
2. **`hospital.db` en la carpeta `trabajo-final/`** — la base de datos está junto al `.csproj` y la cadena de conexión es `"Data Source=hospital.db"`.
3. **`.gitignore` en la raíz** — incluye `bin/` y `obj/`.
4. **README de portada completo** — nombre del proyecto, descripción, tecnologías, cómo ejecutar, endpoints disponibles, estructura del repositorio.
5. **Issues organizados** — al menos las fases del trabajo final creadas como issues.
6. **Historial de commits limpio** — mensajes descriptivos en español, sin tildes, con el prefijo de la carpeta.
7. **PRs revisados y fusionados** — no hay cambios pendientes en ramas de feature abiertas.
8. **`main` protegida** — la rama principal está protegida y no recibe push directo.

**Práctica guiada:**

El docente muestra cómo hacer una revisión final del repositorio: verificar que `main` tiene todos los merges, que no hay ramas de feature abiertas innecesarias y que el README está completo.

**Ejercicio independiente:**

Cada grupo realiza los últimos ajustes en su repositorio: completa endpoints pendientes, corrige errores de tipos canónicos, actualiza el README y verifica que el historial de commits es limpio.

### 4.2 — Entrega por GitHub (40 min)

La entrega del trabajo final se realiza a través de GitHub. El repositorio del grupo debe estar en un estado donde cualquier persona que lo clone pueda ejecutar la API sin configuración adicional.

**Pasos para la entrega:**

1. **Fusionar todos los PRs pendientes** en `main`.
2. **Verificar que `main` tiene el código más reciente**:
   ```bash
   git checkout main
   git pull origin main
   ```
3. **Verificar que la API arranca correctamente**:
   ```bash
   dotnet run
   ```
4. **Verificar que los endpoints responden**:
   ```bash
   curl http://localhost:5000/patients
   ```
5. **Hacer un commit final de cierre**:
   ```bash
   git add .
   git commit -m "trabajo-final: entrega final, api completa con crud y joins"
   git push origin main
   ```
6. **Verificar que el repositorio está listo para la defensa**: README completo, issues organizados, historial de commits limpio, `main` protegida.

**Práctica guiada:**

El docente supervisa que cada grupo complete los pasos de entrega y verifica que la API arranca y responde correctamente en cada repositorio.

**Ejercicio independiente:**

Cada grupo completa la entrega por GitHub: fusiona PRs pendientes, verifica que la API arranca, hace el commit final de cierre y confirma que el repositorio está listo para la defensa.

### 4.3 — Preparación para la defensa individual (40 min)

La defensa individual del trabajo integrador es la instancia de evaluación final de la unidad. Cada grupo debe estar preparado para explicar y demostrar su API.

**Puntos que se evalúan en la defensa:**

- **Funcionalidad de la API** — todos los endpoints funcionan correctamente contra `hospital.db`.
- **Calidad del código** — sigue las convenciones del curso (tipos canónicos, consultas parametrizadas, records al final).
- **Flujo profesional de Git** — ramas por feature, PRs revisados, `main` protegida, commits limpios.
- **Documentación** — README de portada completo, issues organizados, README técnico (si se incluye la extensión).
- **Comprensión de los conceptos** — el grupo puede explicar por qué usa ciertos tipos, cómo funcionan los JOINs y por qué las consultas están parametrizadas.

**Práctica guiada:**

Cada grupo ensaya brevemente su defensa: uno de los integrantes presenta la API y los demás responden preguntas técnicas. El docente da retroalimentación sobre la preparación.

**Ejercicio independiente:**

Cada grupo prepara una presentación breve (5-10 min) que cubra: la arquitectura del proyecto, los endpoints disponibles, las decisiones de diseño y una demostración en vivo de la API funcionando.

## 5. Consolidación y cierre (20 min)

Revisión final del trabajo entregado:

- ¿Cada grupo tiene la API completa funcionando contra `hospital.db`?
- ¿El repositorio tiene README completo, issues organizados e historial de commits limpio?
- ¿`main` está protegida y todos los cambios pasaron por PRs revisados?
- ¿Cada grupo está preparado para la defensa individual?

El docente verifica los repositorios de cada grupo y confirma que están listos para la entrega.

## 6. Actividad complementaria (80 min)

### Trabajo en grupo: últimos ajustes y entrega final

Cada grupo completa las siguientes tareas:

1. **Revisión final del código** (20 min): verificar que todos los endpoints funcionan, que los tipos canónicos se respetan y que no hay errores de compilación.
2. **Pruebas de integración finales** (20 min): ejecutar los tests de integración básicos y verificar que todos pasan (200, 201, 204, 400, 404).
3. **Documentación final** (15 min): asegurar que el README de portada, el README técnico (si aplica) y los issues están completos y actualizados.
4. **Ensayo de la defensa** (15 min): cada grupo ensaya su presentación breve de la API y prepara respuestas para preguntas técnicas.
5. **Entrega final por GitHub** (10 min): hacer el commit final de cierre, push a `main` y confirmar que el repositorio está en estado de entrega.

La actividad de extensión incluye que los grupos que terminan temprano preparen preguntas de práctica para la defensa de otros grupos, simulando el rol de evaluadores.

## 7. Cierre (15 min)

### Qué te llevás

- Un repositorio profesional con README completo, issues organizados y flujo de Git con ramas por feature y PRs revisados.
- Una API Minimal completa con Dapper que funciona contra `hospital.db` con CRUD y JOINs.
- La experiencia de trabajar en equipo con control de versiones profesional.
- La preparación para la defensa individual del trabajo integrador.

## Lo que viene

Encuentro 32: Evaluación de la Unidad 4 — defensa individual del trabajo integrador.

## 8. Errores comunes y trampas

| ✔ | Error | Causa probable | Intervención |
| --- | --- | --- | --- |
| ☐ | API no arranca al clonar el repositorio | `hospital.db` no está en la carpeta correcta o la cadena de conexión es incorrecta | Verificar que `hospital.db` está en la carpeta `trabajo-final/` junto al `.csproj` y que la cadena es `"Data Source=hospital.db"` |
| ☐ | `InvalidOperationException` al ejecutar endpoints | Tipos canónicos incorrectos en el record (`int` en lugar de `long`, `DateTime` en lugar de `string`) | Verificar que los IDs usan `long`, las fechas usan `string` y los campos nullable usan `?` |
| ☐ | Commits de entrega con mensaje genérico | No dedicar tiempo al mensaje de commit | El mensaje final debe ser descriptivo: `trabajo-final: entrega final, api completa con crud y joins` |
| ☐ | RAMA de feature sin fusionar al momento de la entrega | PRs pendientes que no se fusionaron | Verificar que `main` tiene todos los cambios y que no hay ramas de feature abiertas innecesarias |
| ☐ | README incompleto o faltante | No dedicar tiempo a la documentación | El README de portada es parte de la entrega profesional y se evalúa |
| ☐ | Grupo no preparado para la defensa | No ensayar la presentación | Dedicar tiempo del ensayo a practicar la exposición y preparar respuestas para preguntas técnicas |
