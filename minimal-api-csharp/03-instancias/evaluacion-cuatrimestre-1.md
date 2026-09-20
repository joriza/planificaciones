# Evaluación integradora del cuatrimestre 1

> Evaluación del Encuentro 16 — Cierre integrador del cuatrimestre 1 · Curso: Minimal API con C# .NET 6. Este documento se entrega junto con la versión asignada (A o B). Leerlo completo antes de comenzar.

## 1. Identificación

| Campo | Detalle |
| --- | --- |
| Instancia | Encuentro 16 — Cierre integrador del cuatrimestre 1 |
| Destinatarios | Todo el curso |
| Alcance | Unidades 1 y 2 + saberes transversales de terminal, git y GitHub |
| Modalidad | Prueba práctica individual con computadora + ítems conceptuales breves |
| Duración | 120 minutos de resolución, dentro del encuentro de 240 minutos |
| Puntaje total | 100 puntos |
| Uso de celular | No permitido |
| Material consultable | Solo el provisto con la prueba: enunciado, esqueleto de `Program.cs` y columnas de las tablas |

## 2. Objetivos evaluados

1. Construir endpoints de una Minimal API sobre una lista en memoria con rutas, parámetros, verbos y códigos de respuesta adecuados (Unidad 1).
2. Consultar `hospital.db` con Dapper mediante SELECT parametrizados con WHERE y LIKE, y consultas con JOIN de dos tablas mapeadas a records (Unidad 2).
3. Implementar escritura parametrizada sobre la base con validación manual y códigos de estado correctos (Unidad 2).
4. Sostener las convenciones del curso: rutas en inglés y plural, ids `long`, respuestas con `Results`, consultas parametrizadas, comentarios en el código.
5. Explicar el ciclo de trabajo y de entrega con git y GitHub (saber transversal).

## 3. Alcance por unidad

| Unidad | Núcleos incluidos | Núcleos excluidos |
| --- | --- | --- |
| Unidad 1 | API en memoria: lista estática, GET con parámetro de ruta, POST con validación manual, `Results.Ok`/`NotFound`/`BadRequest`/`Created`, JSON automático | Nada de la unidad queda excluido del alcance teórico; la prueba evalúa los núcleos listados |
| Unidad 2 | Conexión a `hospital.db`, SELECT con alias de columnas, WHERE y LIKE parametrizados, query string, JOIN de dos tablas con record compuesto, INSERT con `ExecuteScalar<long>`, códigos 200/201/400/404 | JOIN de tres tablas, agregaciones, GROUP BY, subconsultas (Unidad 3) |
| Transversal | Terminal, `.gitignore`, rutina de commit, ciclo de entrega por GitHub | Issues, ramas por feature y pull requests (Unidad 4) |

## 4. Estructura de la prueba y puntaje

| Parte | Contenido | Unidad | Puntos |
| --- | --- | --- | --- |
| Parte 1 | API en memoria: GET por id con 200/404 y POST con 201/400 | 1 | 25 |
| Parte 2 | Consultas a la base: búsqueda con LIKE parametrizado (15) + JOIN de dos tablas (20) | 2 | 35 |
| Parte 3 | Escritura: INSERT parametrizado con validación, 201 y 400 | 2 | 20 |
| Parte 4 | Ítems conceptuales: memoria y persistencia (5), verbos y códigos (8), ciclo de entrega con git (7) | 1 + transversal | 20 |
| **Total** | | | **100** |

Tiempo sugerido: Parte 1, 30 min · Parte 2, 45 min · Parte 3, 20 min · Parte 4, 20 min · revisión final, 5 min.

## 5. Condiciones de resolución

- Resolución estrictamente individual, con computadora.
- Sin celular en ningún momento del encuentro.
- Material consultable: únicamente el provisto con la prueba. No se consultan apuntes, repos propios, la web ni material de clases anteriores.
- Todo el código va en `Program.cs`; el esqueleto provisto ya trae los `using`, la cadena de conexión, la lista base y todos los records: no se modifican, solo se agregan los endpoints pedidos.
- Convenciones obligatorias del curso: rutas en inglés y plural, ids `long`, fechas `string` ISO, respuestas siempre con `Results` (nunca el objeto crudo), consultas siempre parametrizadas.
- Entrega: al finalizar (o al agotarse el tiempo), el `Program.cs` queda guardado en la carpeta indicada de la máquina y el docente lo verifica y registra in situ. El tiempo agotado no invalida la prueba: se registra la evidencia parcial alcanzada.

## 6. Criterios de calificación

| Criterio | Qué se observa |
| --- | --- |
| Funcionalidad | Los endpoints responden lo pedido con el código de estado correcto, verificados en el navegador y con `curl` |
| Convenciones del curso | Rutas en inglés plural, ids `long`, `Results` explícito, records al final del archivo |
| Acceso a datos | Consultas SQL parametrizadas (nunca concatenadas), alias de columnas `snake_case` → `PascalCase`, conexión con `using` dentro del handler |
| Validación manual | Los datos requeridos se validan antes de responder; `400` con mensaje en español |
| Claridad | El código conserva y amplía los comentarios; los nombres siguen las convenciones |

El resultado se expresa sobre 100 puntos, con el desglose ítem por ítem que figura en cada versión. Los umbrales de acreditación y las capas de recuperación son los definidos en `06-aprobacion/criterios-aprobacion.md`.

## 7. Regla de equivalencia entre las versiones A y B

- Misma estructura: mismas partes, mismos objetivos, mismos requisitos y mismo puntaje ítem por ítem.
- Distinto dominio: la versión A trabaja sobre médicos y especialidades (tablas `doctors` y `admissions`); la versión B sobre pacientes y ciudades (tablas `patients` y `province_names`).
- Ninguna regla que una tenga y la otra no: los datos obligatorios que difieren en cantidad (tres columnas en `doctors`, cinco en `patients`) son los que fija cada tabla, y la regla validada es idéntica en ambas (campos obligatorios no vacíos).
- El propósito de la equivalencia es que la versión asignada no otorgue ventaja ni habilite la copia entre compañeros.

## 8. Mecánica de asignación de versiones

- La versión (A o B) se asigna por grupo o por posición en el aula, según lo defina el docente al iniciar la prueba (por ejemplo, filas alternadas de máquinas).
- La asignación se comunica al comenzar y se registra en la planilla de resultados (alumno → versión).
- La prueba es individual: alumnos de un mismo grupo de trabajo pueden tener versiones distintas; eso no afecta la prueba ni el grupo.

## 9. Devolución

- La corrección se devuelve al inicio del encuentro 17, con comentario escrito individual y comentarios generales al curso.
- Los núcleos no alcanzados se trabajan en los encuentros especiales 17 y 18 de recuperación y profundización, con resultado aún provisorio de Apto o No apto.
