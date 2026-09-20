# Anexo docente — Encuentro 31: Cierre U4: entrega final

---

## Preguntas guía para la apertura

1. "¿Qué fue lo más difícil de aprender en este curso?"
2. "¿En qué momento sintieron que 'hacía clic' la conexión entre C#, la base de datos y la API?"
3. "Si tuvieran que recomendarle este curso a alguien, ¿qué le dirían que se va a encontrar?"

---

## Guía de preguntas para la defensa individual

El docente asigna **una pregunta de código** al azar cuando el alumno llega al frente, y luego elige **2-3 preguntas conceptuales** según el desempeño.

### Preguntas de código (para asignar una por alumno)

| Pregunta | Lo que debe explicar |
|---|---|
| "Explique el record de Patient" | Tipos `long` para IDs, `string` para fechas, `string?`/`long?` para nulables, posición después de `app.Run()`. |
| "Explique el endpoint GET /patients/count-by-province" | LEFT JOIN, COUNT, GROUP BY, alias en snake_case, `Results.Ok()`. |
| "Explique el bloque de validacion del POST" | `string.IsNullOrWhiteSpace()`, `Results.BadRequest()`, devolución temprana. |
| "Explique la proteccion de main en Git" | Branch protection rule, PR requerido, 1 approval, push directo bloqueado. |
| "Explique el flujo de un PR" | Issue -> rama feature -> commit -> push -> PR -> revision -> merge -> borrar rama. |
| "Explique por que la conexion se abre con `using`" | IDisposable, cierre automático, pool de conexiones SQLite. |

### Preguntas conceptuales (elegir 2-3 por alumno)

- ¿Por qué los IDs se declaran como `long` y no `int`?
- ¿Qué hace `ExecuteScalar<long>` y por qué se usa en el POST?
- ¿Cuál es la diferencia entre `Results.Ok`, `Results.Created` y `Results.NoContent`?
- ¿Por qué usamos alias `AS` en el SELECT?
- ¿Qué protege la regla de branch protection en main?
- ¿Qué pasa si no cerramos la conexión con `using`?
- ¿Cuándo usarías LEFT JOIN en lugar de INNER JOIN?
- ¿Por qué las fechas son `string` en los records en lugar de `DateTime`?
- ¿Cuál es la diferencia entre `Query<T>` y `QueryFirstOrDefault<T>`?
- ¿Qué devuelve `Execute` en un DELETE?

---

## Escala de evaluacion para la defensa individual

| Dimensión | Excelente (4 pts) | Bien (3 pts) | Suficiente (2 pts) | Insuficiente (1 pt) |
|---|---|---|---|---|
| Claridad al exponer | Explica de forma clara y estructurada, usa vocabulario técnico preciso | Explica con claridad pero omite algún detalle | Se nota inseguro, salta entre conceptos | No logra explicar el proyecto |
| Demostración técnica | Ejecuta y prueba endpoints sin problemas | Prueba endpoints con ayuda menor | Tiene dificultad para ejecutar | No puede mostrar la API funcionando |
| Explicación de código | Explica línea por línea con precisión | Explica el bloque general pero omite detalles | Muestra el código sin explicarlo | No reconoce su propio código |
| Preguntas conceptuales | Responde correctamente 3 preguntas | Responde correctamente 2 preguntas | Responde correctamente 1 pregunta | No responde ninguna |
| Git profesional | Muestra PR, ramas y main protegida | Muestra PR pero falta algún elemento | Tiene Git pero sin PR | Sin evidencia de Git profesional |

---

## Planilla de evaluacion del trabajo final (para completar por grupo)

| Grupo: _______________ | Puntaje max | Puntaje obtenido |
|---|---|---|
| **Funcionalidad tecnica (30%)** | | |
| `GET /patients` funciona | 3 | |
| `GET /patients/{id}` funciona | 3 | |
| `GET /patients/with-province` funciona | 4 | |
| `GET /patients/count-by-province` funciona | 4 | |
| `POST /patients` con validacion | 5 | |
| `PUT /patients/{id}` con chequeo de existencia | 4 | |
| `DELETE /patients/{id}` con chequeo de existencia | 4 | |
| `GET /doctors/{id}` con conteo | 3 | |
| Subtotal funcionalidad | 30 | |
| **Calidad del codigo (20%)** | | |
| Tipos canonicos correctos (long, string, ?) | 5 | |
| Alias AS en SELECT | 4 | |
| `using` en conexiones | 4 | |
| `Results.*` en todas las respuestas | 4 | |
| Records despues de `app.Run()` | 3 | |
| Subtotal calidad | 20 | |
| **Git profesional (20%)** | | |
| Issues creados y cerrados | 5 | |
| Ramas feature con nombre correcto | 5 | |
| PR con revision entre pares | 5 | |
| Main protegida activa | 5 | |
| Subtotal Git | 20 | |
| **README (10%)** | | |
| Nombre y descripcion | 2 | |
| Instalacion y requisitos | 2 | |
| Estructura del repositorio | 2 | |
| Tecnologias | 2 | |
| Integrantes | 2 | |
| Subtotal README | 10 | |
| **Defensa individual (20%)** | 20 | |
| **TOTAL** | **100** | |

---

## Notas para el docente

### Logistica de la defensa

- Si el curso tiene muchos alumnos, la defensa puede extenderse más de 130 minutos. Preparar un cronómetro visible y ser estricto con los 8 minutos por alumno.
- Si algún alumno no termina su defensa en el tiempo asignado, cortar y asignar los puntos de "explicación de código" y "preguntas" como pendientes para una breve entrevista individual al final.
- Para grupos grandes, considerar defensas simultáneas: mientras un alumno presenta, otro prepara su computadora.

### Que hacer si un grupo no completo el trabajo final

- Si un grupo no tiene el trabajo final funcionando, permitirle presentar lo que tiene y evaluar sobre eso. El README y el flujo Git se evalúan igual.
- Si un alumno faltó a encuentros anteriores pero su grupo completo el trabajo, evaluar su comprensión individual con más preguntas conceptuales.

### Cierre emocional del curso

Destacar el logro: pasaron de no saber C# a tener una API REST funcional conectada a una base de datos real, con control de versiones profesional. Ese es un salto enorme en 31 encuentros.

### Despues del encuentro

Una vez cerradas las notas, subir las calificaciones al sistema de la institución y archivar los repositorios de los grupos como evidencia de la cursada.

---

## Material complementario para quienes quieran seguir aprendiendo

Para los alumnos que quieran continuar después del curso:

- **Entity Framework Core** — el ORM oficial de .NET, reemplaza a Dapper en proyectos más grandes.
- **Autenticacion con JWT** — asegurar los endpoints con tokens.
- **Minimal API avanzada** — grupos de rutas, filtros, validación con FluentValidation.
- **Testing de integracion** — `Microsoft.AspNetCore.Mvc.Testing` para probar la API automáticamente.
- **Deploy** — publicar en Azure, Railway o Render.