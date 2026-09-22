# Evaluación de la Unidad 4 — Profesionalización y proyecto final

## Metadatos

| Campo | Valor |
|---|---|
| Asignatura | Minimal API con C# .NET 6 |
| Unidad | U4: Profesionalización y proyecto final |
| Encuentro de evaluación | 32 (dedicado) |
| Tipo | Trabajo final integrador con defensa individual |
| Modalidad | Grupal (2-3 integrantes), defensa individual |
| Duración del encuentro | 240 minutos |
| Duración de la defensa | Hasta 10 minutos por integrante |
| Criterio de aprobación | 60/100 en el trabajo final + defensa satisfactoria |

## Objetivos de evaluación

- Integrar todo el contenido del curso en una API completa: CRUD, JOIN, Dapper, tipos canónicos y respuestas HTTP.
- Aplicar flujo Git profesional: issues, ramas por feature, pull requests, main protegida.
- Redactar un README profesional con instrucciones de instalación, endpoints y tecnologías.
- Presentar y defender individualmente el trabajo final ante el docente.
- Demostrar comprensión conceptual de las decisiones técnicas tomadas.

## Formato de entrega

1. **Antes del encuentro 32:** cada grupo debe tener el repositorio finalizado con la carpeta `trabajo-final/`, README.md, main protegida, y al menos 2 PR mergeados durante la unidad.
2. **Defensa individual (encuentro 32):** cada integrante pasa al frente, muestra el repositorio en GitHub, ejecuta la API, prueba dos endpoints, explica un fragmento de código asignado por el docente y responde preguntas conceptuales.
3. **Devolución:** el encuentro siguiente (encuentro 34, intensificación de U3-U4) abre con devolución y entrega de notas.

## Rúbrica de evaluación (100 puntos)

### Funcionalidad técnica (30 puntos)

| Criterio | Puntos | Descripción |
|---|---|---|
| GET (lista) sobre tabla principal | 3 | Devuelve todos los registros |
| GET /{id} sobre tabla principal | 3 | 200 si existe, 404 si no |
| GET con JOIN (dos tablas) | 4 | Cruza dos tablas con alias AS |
| GET con JOIN y agregación | 4 | LEFT JOIN + COUNT + GROUP BY |
| POST con validación | 5 | Crea registro, valida campo obligatorio, 201 |
| PUT con verificación de existencia | 4 | Actualiza, 204, 404 si no existe |
| DELETE con verificación de existencia | 4 | Elimina, 204, 404 si no existe |
| GET /{id} sobre segunda tabla | 3 | Endpoint adicional de lectura |

### Calidad del código (20 puntos)

| Criterio | Puntos | Descripción |
|---|---|---|
| Tipos canónicos correctos | 5 | `long` para IDs, `string` para fechas, `?` para nulables |
| Alias `AS` en todos los SELECT | 4 | Snake_case → PascalCase |
| Conexiones con `using` | 4 | Cada endpoint abre y cierra conexión |
| `Results.*` en todas las respuestas | 4 | Ok, Created, NoContent, NotFound, BadRequest |
| Records después de `app.Run()` | 3 | Sin tipos antes del código ejecutable |

### Git profesional (20 puntos)

| Criterio | Puntos | Descripción |
|---|---|---|
| Issues creados y cerrados | 5 | Al menos 2 issues en el repositorio |
| Ramas feature con nombre correcto | 5 | `feature/nombre-descripcion` |
| Pull requests con revisión entre pares | 5 | Al menos 2 PR mergeados con comentarios |
| Rama `main` protegida | 5 | Branch protection activa, requiere PR para merge |

### README profesional (10 puntos)

| Criterio | Puntos | Descripción |
|---|---|---|
| Nombre y descripción del proyecto | 2 | Título y párrafo de qué hace |
| Requisitos e instalación | 2 | SDK, paquetes, cómo clonar y ejecutar |
| Estructura del repositorio | 2 | Carpetas y su propósito |
| Tecnologías utilizadas | 2 | .NET 6, Dapper, SQLite |
| Integrantes del grupo | 2 | Listado de integrantes con nombre completo |

### Defensa individual (20 puntos)

| Criterio | Puntos | Descripción |
|---|---|---|
| Claridad al exponer | 4 | Explica de forma clara y estructurada |
| Demostración técnica | 4 | Ejecuta y prueba endpoints sin problemas |
| Explicación de código | 4 | Explica con precisión el bloque asignado |
| Preguntas conceptuales | 4 | Responde correctamente 2-3 preguntas |
| Git profesional | 4 | Muestra PRs, ramas y main protegida |

## Criterio de aprobación

- **Nota del trabajo final:** puntaje sobre 100 según rúbrica.
- **Aprobación:** 60 puntos o más **y** defensa individual satisfactoria.
- **Trabajo incompleto:** si faltan endpoints obligatorios (POST, PUT, DELETE, JOIN), el puntaje máximo es 50.
- **Recuperación:** instancias de intensificación de U3-U4 (encuentros 34-35, diciembre y marzo).

## Cierre de la evaluación

La Unidad 4 es el trabajo final integrador del curso. Una vez aprobada, el alumno acredita la materia completa. Para quienes no alcancen los 60 puntos o la defensa satisfactoria, las instancias de intensificación evalúan el camino mínimo completo del curso.