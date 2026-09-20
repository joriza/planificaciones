# Criterios de aprobación — Minimal API con C# .NET 6

> Documento formal para alumnos, familias y dirección.
> Registro docente: criterios objetivos y públicos de evaluación, recuperación y acreditación.

---

## 1. Qué se evalúa

La asignatura se aprueba por **evaluación continua a través de trabajos prácticos**.  
No hay exámenes cuatrimestrales ni examen final: el alumno acredita cursando y aprobando cada unidad en sus encuentros dedicados.

### 1.1 Evaluaciones de unidad (4 encuentros dedicados)

Cada unidad didáctica tiene **un encuentro de evaluación exclusivo**, en el que se entrega el trabajo práctico por GitHub y se realiza la defensa individual.

| Unidad | Encuentro | Evaluación |
|---|---|---|
| U1 — Fundamentos de C# y Minimal API | 9 | Entrega grupal por GitHub + defensa individual |
| U2 — Acceso a datos con SQLite y Dapper | 15 | Entrega grupal por GitHub + defensa individual |
| U3 — CRUD completo con Dapper | 26 | Entrega grupal por GitHub + defensa individual |
| U4 — Profesionalización y proyecto final | 32 | Trabajo final integrador + defensa individual |

Todas las evaluaciones de unidad se puntúan sobre **100 puntos** y requieren **defensa individual satisfactoria**.

### 1.2 Evaluaciones de intensificación y fortalecimiento

Los momentos de recuperación (encuentros 17-20, 34-35, diciembre y marzo) se evalúan con criterio **Apto / No apto aún por objetivo mínimo**.  
El momento integrador (encuentros 19-20, proyecto puente) usa rúbrica de 100 puntos.

---

## 2. Mínimos por unidad (objetivos irrenunciables)

Para aprobar una unidad, el alumno debe demostrar dominio de **todos** estos objetivos en la entrega y la defensa:

### U1 — Fundamentos de C# y Minimal API
- Crear un proyecto `dotnet new web` con `Program.cs` de archivo único.
- Implementar endpoints GET con `MapGet` y parámetros de ruta (`{id:long}`).
- Devolver respuestas HTTP canónicas (`Results.Ok`, `Results.NotFound`).
- Declarar records posicionales con `long` para IDs y `string` para fechas, después de `app.Run()`.
- Subir el proyecto a GitHub en la carpeta `tp-u1/` con `.gitignore` y commit semántico.
- Explicar y ejecutar la API durante la defensa individual.

### U2 — Acceso a datos con SQLite y Dapper
- Conectar SQLite desde C# con `Microsoft.Data.Sqlite` y cadena de conexión.
- Ejecutar consultas `SELECT` con Dapper (`Query<T>`, `QueryFirstOrDefault<T>`).
- Usar alias `AS` en SQL para mapear snake_case a PascalCase.
- Escribir consultas parametrizadas con `@param` y objetos anónimos (nunca concatenar).
- Implementar al menos un `JOIN` entre dos tablas.
- Subir el proyecto a GitHub en `tp-u2/` con `.gitignore` y commit semántico.

### U3 — CRUD completo con Dapper
- Implementar `POST` con `ExecuteScalar<long>` y devolución `201 Created`.
- Implementar `PUT` con `Execute` y verificación de existencia previa.
- Implementar `DELETE` con `Execute` y código `204 No Content`.
- Validar entrada en POST y devolver `400 Bad Request` si falta un campo obligatorio.
- Implementar al menos un `JOIN` de tres tablas.
- Mantener tipos canónicos (`long`, `string` para fechas, `?` para nulables).
- Subir el proyecto a GitHub en `tp-u3/`.

### U4 — Profesionalización y proyecto final
- Integrar las cuatro operaciones CRUD en una misma API.
- Aplicar flujo Git profesional: issues, ramas `feature/`, pull requests y main protegida.
- Redactar un `README.md` de portada con descripción, instalación, tecnologías y endpoints.
- Defender individualmente el trabajo final ante el docente.
- Demostrar comprensión conceptual de las decisiones técnicas del proyecto.

---

## 3. Regla de entrega incompleta

Si en el encuentro de evaluación el grupo entrega el trabajo práctico pero **falta alguno de los endpoints obligatorios** definidos en la rúbrica de la unidad, la entrega se considera **incompleta** y el puntaje máximo posible es **50/100**, incluso si el resto del trabajo está correcto.

| Situación | Consecuencia |
|---|---|
| Entrega completa + defensa satisfactoria | Nota según rúbrica (0 a 100) |
| Entrega incompleta (falta endpoint obligatorio) | Puntaje máximo 50, aunque el resto esté bien |
| Sin entrega en el encuentro dedicado | No se reciben trabajos fuera del encuentro; el alumno pasa directo a instancia de recuperación |
| Defensa insatisfactoria | La unidad no se aprueba, aunque la entrega tenga 60 o más |

Los endpoints obligatorios se listan en la rúbrica de cada evaluación de unidad y son públicos desde el inicio del curso.

---

## 4. Capas de recuperación

El alumno que no apruebe una unidad (nota menor a 60 o defensa insatisfactoria) tiene las siguientes instancias de recuperación, todas con **el mismo estándar** que la evaluación original. Lo que cambia es el tiempo disponible para prepararse.

### 4.1 Primera instancia — Intensificación en el ciclo lectivo

| Instancia | Encuentros | Alcance |
|---|---|---|
| Intensificación de U1 y U2 | 17-18 | Solo alumnos con U1 y/o U2 desaprobadas |
| Momento integrador (proyecto puente) | 19-20 | Recuperación ampliada con rúbrica de 100 puntos |
| Intensificación de U3 y U4 | 34-35 | Solo alumnos con U3 y/o U4 desaprobadas |

En estas instancias el alumno trabaja en **pista diferenciada** según su condición: intensificación (recuperar objetivos mínimos) o fortalecimiento (profundizar).  
La evaluación usa criterio **Apto / No apto aún por objetivo mínimo** para cada objetivo irrenunciable.

### 4.2 Segunda instancia — Diciembre (fuera del ciclo lectivo)

- **Cuándo:** Diciembre, finalizada la cursada.
- **Destinatarios:** Alumnos que no alcanzaron los objetivos mínimos del curso durante el ciclo lectivo.
- **Contenido:** Camino mínimo completo (los 9 objetivos irrenunciables de las cuatro unidades).
- **Formato:** Dos encuentros intensivos de 240 minutos cada uno.
- **Evaluación:** Apto / No apto aún por objetivo mínimo. El alumno reconstruye el proyecto desde cero siguiendo una guía, y el docente verifica cada objetivo contra el repositorio en GitHub.

### 4.3 Tercera instancia — Marzo (fuera del ciclo lectivo)

- **Cuándo:** Marzo, antes del nuevo ciclo lectivo.
- **Destinatarios:** Alumnos que no alcanzaron los objetivos en diciembre.
- **Estándar:** **Idéntico al de diciembre** (camino mínimo completo). No baja el nivel.
- **Diferencia:** El alumno tuvo más tiempo para prepararse (diciembre a marzo). La evaluación es la misma: Apto / No apto aún por objetivo mínimo.

---

## 5. Condición de aprobación final

Para acreditar la asignatura **Minimal API con C# .NET 6**, el alumno debe cumplir **todas** las siguientes condiciones:

| Condición | Detalle |
|---|---|
| **Todas las unidades ≥ 60 puntos** | U1, U2, U3 y U4, cada una con nota de entrega igual o superior a 60/100 |
| **Defensa individual satisfactoria en cada unidad** | Defensa aprobada en los cuatro encuentros de evaluación (9, 15, 26 y 32) |
| **Camino mínimo completo** | Todos los objetivos irrenunciables de las cuatro unidades están cumplidos (ver sección 2) |

Si el alumno cumple las tres condiciones, la asignatura está **aprobada**.

Si el alumno no cumple alguna condición al finalizar el ciclo lectivo, puede recuperar en las instancias de diciembre y marzo (secciones 4.2 y 4.3). Una vez aprobado el camino mínimo completo en cualquiera de esas instancias, la asignatura se considera acreditada.

---

## 6. Resumen para familias y dirección

| Pregunta | Respuesta |
|---|---|
| ¿Cómo se aprueba la materia? | Aprobando las 4 evaluaciones de unidad con nota 60 o más y defensa oral individual. |
| ¿Hay examen final? | No. La materia se aprueba por trabajos prácticos durante el año. |
| ¿Qué pasa si un alumno no llega al 60? | Tiene recuperaciones en los encuentros 17-20 (primer cuatrimestre), 34-35 (segundo cuatrimestre), diciembre y marzo. |
| ¿El estándar baja en diciembre o marzo? | No. Es el mismo estándar; cambia el tiempo de preparación. |
| ¿Qué pasa si falta al encuentro de evaluación? | No se reciben trabajos fuera de la fecha. Pasa directo a recuperación. |
| ¿Qué es la defensa individual? | El alumno explica su código y responde preguntas del docente, hasta 10 minutos por persona. Sin defensa no se aprueba la unidad. |
| ¿Qué necesita un alumno para prepararse? | Una computadora con VS Code, SDK .NET 6, Git y GitHub (gratuito). Todo el software es libre. |
| ¿Cómo se entregan los trabajos? | Por GitHub, en carpetas específicas por unidad (`tp-u1/`, `tp-u2/`, `tp-u3/`, `trabajo-final/`). |
| ¿Qué es el camino mínimo? | El conjunto de habilidades indispensables que todo alumno debe demostrar: crear endpoints GET, conectar base de datos, hacer consultas, implementar CRUD completo y usar Git profesionalmente. |