# Criterios de aprobación — Minimal API con C# .NET 6

**Asignatura:** Minimal API con C# .NET 6
**Documento:** Criterios de aprobación (registro docente formal)
**Destinatarios:** Alumnos, familias y dirección
**Versión:** Fase 4

---

## 1. Identificación

Este documento establece las instancias de evaluación, los mínimos de aprobación por unidad y las condiciones generales de aprobación de la asignatura **Minimal API con C# .NET 6**. Se informa a los alumnos al inicio de la cursada y se consulta en cada instancia de evaluación y recuperación.

---

## 2. Objetivos generales del curso

La asignatura tiene como objetivo que los alumnos puedan:

- Disejar y construir APIs mínimas (Minimal API) con C# y .NET 6.
- Acceder y manipular datos en una base de datos SQLite mediante Dapper.
- Implementar operaciones completas de CRUD (Crear, Leer, Actualizar, Borrar) a través de endpoints HTTP.
- Trabajar con herramientas profesionales de control de versiones: Git y GitHub (ramas, pull requests, README de portada, protección de main).
- Presentar un proyecto final integrado que reúna todos los ejes del cursado.

---

## 3. Instancias de evaluación

### 3.1 Evaluaciones de unidad (4 instancias)

Cada unidad tiene un encuentro dedicado a la evaluación. La modalidad combina la **entrega del trabajo en GitHub** (carpeta correspondiente, un repositorio por grupo) con una **defensa individual** ante el docente. La devolución del resultado abre el encuentro siguiente.

| Unidad | Encuentro dedicado | Carpeta en el repo del grupo | Denominación del trabajo |
|--------|---------------------|------------------------------|--------------------------|
| U1 — Fundamentos de C# y Minimal API | E9 | `tp-u1` | TP-U1: Minimal API GET |
| U2 — Acceso a datos con SQLite y Dapper | E15 | `tp-u2` | TP-U2: SQLite y Dapper básico |
| U3 — CRUD completo con Dapper | E26 | `tp-u3` | TP-U3: CRUD completo |
| U4 — Profesionalización y proyecto final | E32 | `trabajo-final` | Trabajo final: API con Dapper |

### 3.2 Evaluaciones de momento (6 instancias)

Son evaluaciones que se realizan en encuentros específicos del año, con criterios particulares.

| Momento | Encuentros | Criterio |
|---------|-----------|----------|
| 02-03 | E2-E3 | Apto / No apto aún por objetivo mínimo |
| 17-18 | E17-E18 | Apto / No apto aún por objetivo mínimo (capa de recuperación) |
| 19-20 | E19-E20 | Rúbrica de 100 puntos |
| 34-35 | E34-E35 | Apto / No apto aún por objetivo mínimo (capa de recuperación) |
| Diciembre | Fuera del ciclo lectivo regular | Apto / No apto aún por objetivo mínimo |
| Marzo | Fuera del ciclo lectivo regular | Apto / No apto aún por objetivo mínimo (el estándar no baja respecto de diciembre) |

---

## 4. Mínimos de aprobación por unidad

Para aprobar cada unidad, el alumno debe cumplir **ambas** condiciones:

1. **Entrega del trabajo en el repositorio del grupo** (en la carpeta correspondiente: `tp-u1`, `tp-u2`, `tp-u3` o `trabajo-final`).
2. **Defensa individual** ante el docente.

Al cierre de cada unidad, el alumno debe poder:

- **U1:** Crear una Minimal API con .NET 6, definir endpoints GET con parámetros de ruta y cadena de consulta, y exponerla correctamente.
- **U2:** Conectar una base de datos SQLite desde C#, ejecutar consultas SELECT con WHERE, JOIN entre dos tablas y consultas parametrizadas con Dapper.
- **U3:** Implementar las cuatro operaciones CRUD (POST, GET, PUT, DELETE) mediante endpoints HTTP usando Dapper, incluyendo JOIN de tres tablas.
- **U4:** Publicar un repositorio profesional en GitHub con README de portada, issues, ramas por feature, pull requests y protección de la rama main; además, exponer una API completa con base de datos.

---

## 5. Regla de entrega incompleta y capas de recuperación

### 5.1 Entrega incompleta

Si el trabajo práctico de una unidad **no está completo** el día del encuentro dedicado, el alumno **no cumple el mínimo de aprobación** de esa unidad. No se considera aprobado parcialmente: se requiere la entrega completa más la defensa individual.

### 5.2 Capas de recuperación (en orden)

Las capas de recuperación se aplican en la siguiente secuencia:

| Orden | Momento | Encuentros | A quién aplica |
|-------|---------|-----------|----------------|
| 1.ª | Recuperación 1 | 17-18 | Alumnos que no aprobaron la evaluación de U1 o U2 |
| 2.ª | Recuperación 2 | 34-35 | Alumnos que no aprobaron la evaluación de U3 o U4 |
| 3.ª | Diciembre | Fuera del ciclo lectivo | Cualquier unidad no aprobada (evalúa el camino mínimo completo del curso) |
| 4.ª | Marzo | Fuera del ciclo lectivo | Cualquier unidad no aprobada (mismo estándar que diciembre; no baja respecto de diciembre) |

Cada capa de recuperación evalúa con criterio **Apto / No apto aún por objetivo mínimo**. El momento 19-20 (rúbrica de 100 puntos) no es capa de recuperación.

---

## 6. Condiciones de aprobación de la asignatura

La asignatura se aprueba cuando el alumno cumple con los **mínimos de aprobación de las 4 unidades** (entrega completa en GitHub + defensa individual en cada una). No existen evaluaciones cuatrimestrales ni de cierre con evaluación propia; los encuentros E16, E33 y E36 son cierres de síntesis y metacognición sin evaluación.

Adicionalmente:

- El **momento 19-20** se evalúa con rúbrica de 100 puntos y forma parte de la calificación del cursado.
- Los momentos de intensificación (17-18 y 34-35) y las instancias fuera del ciclo lectivo (diciembre y marzo) sirven como capas de recuperación y no modifican la condición de aprobación ya alcanzada por unidades.
- El celular **no está permitido** durante los encuentros de evaluación.
- Cada encuentro de evaluación dispone de **4 horas reloj**.

---

## 7. Tabla resumen de instancias

| N.º | Instancia | Momento del año | Modalidad | Criterio |
|-----|-----------|----------------|-----------|----------|
| 1 | Evaluación U1 | E9 (dentro del ciclo) | Entrega en GitHub (`tp-u1`) + defensa individual | Apto / No apto aún por objetivo mínimo |
| 2 | Evaluación U2 | E15 (dentro del ciclo) | Entrega en GitHub (`tp-u2`) + defensa individual | Apto / No apto aún por objetivo mínimo |
| 3 | Evaluación U3 | E26 (dentro del ciclo) | Entrega en GitHub (`tp-u3`) + defensa individual | Apto / No apto aún por objetivo mínimo |
| 4 | Evaluación U4 | E32 (dentro del ciclo) | Entrega en GitHub (`trabajo-final`) + defensa individual | Apto / No apto aún por objetivo mínimo |
| 5 | Momento 02-03 | Encuentros 2-3 | Evaluación presencial | Apto / No apto aún por objetivo mínimo |
| 6 | Momento 17-18 | Encuentros 17-18 | Evaluación presencial (capa de recuperación) | Apto / No apto aún por objetivo mínimo |
| 7 | Momento 19-20 | Encuentros 19-20 | Evaluación presencial con rúbrica | Rúbrica de 100 puntos |
| 8 | Momento 34-35 | Encuentros 34-35 | Evaluación presencial (capa de recuperación) | Apto / No apto aún por objetivo mínimo |
| 9 | Diciembre | Fuera del ciclo lectivo regular | Evaluación presencial (capa de recuperación) | Apto / No apto aún por objetivo mínimo |
| 10 | Marzo | Fuera del ciclo lectivo regular | Evaluación presencial (capa de recuperación) | Apto / No apto aún por objetivo mínimo (estándar no baja respecto de diciembre) |

---

*Documento de registro docente formal. Se entrega a alumnos, familias y dirección al inicio de la cursada.*
