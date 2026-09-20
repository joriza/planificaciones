# Evaluación integradora del cuatrimestre 2

> Evaluación del Encuentro 33 — Cierre integrador del cuatrimestre 2 · Curso: Minimal API con C# .NET 6. Este documento se entrega junto con la versión asignada (A o B). Leerlo completo antes de comenzar.

## 1. Identificación

| Campo | Detalle |
| --- | --- |
| Instancia | Encuentro 33 — Cierre integrador del cuatrimestre 2 |
| Destinatarios | Todo el curso |
| Alcance | Año completo (Unidades 1 a 4 + saberes transversales), con énfasis en las Unidades 3 y 4 |
| Modalidad | Prueba práctica individual con computadora + ítems conceptuales breves |
| Duración | 120 minutos de resolución, dentro del encuentro de 240 minutos |
| Puntaje total | 100 puntos |
| Uso de celular | No permitido |
| Material consultable | Solo el provisto con la prueba: enunciado, esqueleto de `Program.cs` y columnas de las tablas |

## 2. Objetivos evaluados

1. Construir estadísticas sobre `hospital.db` con agregaciones `COUNT` y `GROUP BY` sobre un JOIN, expuestas en un endpoint (Unidad 3).
2. Resolver una consulta integrada con JOIN de tres tablas, filtro parametrizado, nombres armados con `||` y orden estable, mapeada a un record compuesto (Unidad 3).
3. Detectar núcleos sin correspondencia con subconsultas (`IN` / `NOT IN`) y tratar datos sucios reales (`NULL`, fechas imposibles) con `IS NULL` y `COALESCE` (Unidad 3).
4. Explicar la configuración de la cadena de conexión en `appsettings.json` y la publicación con `dotnet publish` (Unidad 3).
5. Explicar el flujo profesional del repositorio: issues, ramas por feature, pull requests con `Closes #N`, revisión entre pares y `main` protegida (Unidad 4 + transversal).
6. Sostener las convenciones del curso: rutas en inglés y plural, ids `long`, respuestas con `Results`, consultas parametrizadas, comentarios en el código.

## 3. Alcance por unidad

| Unidad | Núcleos incluidos | Núcleos excluidos |
| --- | --- | --- |
| Unidad 1 | Memoria vs. persistencia y verbos/códigos de respuesta, como sostén conceptual de los ítems C1 | Sin ejercicios dedicados de CRUD en memoria (ya evaluados en el cuatrimestre 1) |
| Unidad 2 | Consultas SELECT parametrizadas con alias, LIKE y JOIN de dos tablas, como base técnica de todas las partes prácticas | Sin ejercicios dedicados de escritura (INSERT/UPDATE/DELETE) |
| Unidad 3 (énfasis) | JOIN de tres tablas, COUNT con GROUP BY, `strftime` por mes, subconsultas `IN`/`NOT IN`, datos sucios (`NULL`, `COALESCE`, fechas imposibles), configuración en `appsettings.json`, publicación con `dotnet publish` | Escritura parametrizada de recursos (evaluada en el trabajo-final) |
| Unidad 4 (énfasis) | Flujo profesional de GitHub: issues, ramas `feature/*`, pull requests con revisión, `Closes #N`, `main` protegida | README de portada y defensa del trabajo (evaluados en el encuentro 32) |
| Transversal | Terminal, rutina de commit, ciclo de entrega por GitHub como sostén de los ítems conceptuales | — |

## 4. Estructura de la prueba y puntaje

| Parte | Contenido | Unidad | Puntos |
| --- | --- | --- | --- |
| Parte 1 | Estadística con COUNT y GROUP BY sobre un JOIN | 3 | 30 |
| Parte 2 | Consulta integrada: JOIN de tres tablas + filtro parametrizado + orden | 3 | 30 |
| Parte 3 | Consulta con subconsulta (núcleo sin correspondencia) | 3 | 15 |
| Parte 4 | Ítems conceptuales: año completo, datos sucios y NULL (10) · configuración y publicación (8) · flujo profesional GitHub (7) | 1–4 + transversal | 25 |
| **Total** | | | **100** |

Tiempo sugerido: Parte 1, 25 min · Parte 2, 40 min · Parte 3, 20 min · Parte 4, 25 min · revisión final, 10 min.

## 5. Condiciones de resolución

- Resolución estrictamente individual, con computadora.
- Sin celular en ningún momento del encuentro.
- Material consultable: únicamente el provisto con la prueba. No se consultan apuntes, repos propios, la web ni material de clases anteriores.
- Todo el código va en `Program.cs`; el esqueleto provisto ya trae los `using`, la cadena de conexión y todos los records: no se modifican, solo se agregan los endpoints pedidos.
- Convenciones obligatorias del curso: rutas en inglés y plural, ids `long`, fechas `string` ISO, respuestas siempre con `Results` (nunca el objeto crudo), consultas siempre parametrizadas.
- Entrega: al finalizar (o al agotarse el tiempo), el `Program.cs` queda guardado en la carpeta indicada de la máquina y el docente lo verifica y registra in situ. El tiempo agotado no invalida la prueba: se registra la evidencia parcial alcanzada.

## 6. Criterios de calificación

| Criterio | Qué se observa |
| --- | --- |
| Funcionalidad | Los endpoints responden lo pedido con el código de estado correcto, verificados en el navegador y con `curl` |
| Convenciones del curso | Rutas en inglés plural, `Results` explícito, records al final del archivo, ids `long` |
| Acceso a datos | Consultas SQL parametrizadas (nunca concatenadas), alias de columnas `snake_case` → `PascalCase`, JOIN con sus `ON` correctos, conexión con `using` dentro del handler |
| Robustez | Los datos sucios se detectan y tratan (`IS NULL`, `COALESCE`, comparación de fechas ISO); las entradas requeridas se validan antes de responder con `400` y mensaje en español |
| Claridad | El código conserva y amplía los comentarios; los nombres siguen las convenciones |

El resultado se expresa sobre 100 puntos, con el desglose ítem por ítem que figura en cada versión. Los umbrales de acreditación y las capas de recuperación son los definidos en `06-aprobacion/criterios-aprobacion.md`.

## 7. Regla de equivalencia entre las versiones A y B

- Misma estructura: mismas partes, mismos objetivos, mismos requisitos y mismo puntaje ítem por ítem.
- Distinto dominio: la versión A trabaja sobre estadísticas por especialidad (tablas `doctors` y `admissions`); la versión B sobre estadísticas por provincia y por mes (tablas `province_names`, `patients` y `admissions` con `strftime`).
- Ninguna regla que una tenga y la otra no: las técnicas evaluadas son idénticas en ambas (agregación con GROUP BY sobre JOIN, JOIN de tres tablas con filtro parametrizado y validación `400`, subconsulta `NOT IN`); solo cambian las tablas, las columnas de agrupación y el filtro.
- El propósito de la equivalencia es que la versión asignada no otorgue ventaja ni habilite la copia entre compañeros.

## 8. Mecánica de asignación de versiones

- La versión (A o B) se asigna por grupo o por posición en el aula, según lo defina el docente al iniciar la prueba (por ejemplo, filas alternadas de máquinas).
- La asignación se comunica al comenzar y se registra en la planilla de resultados (alumno → versión).
- La prueba es individual: alumnos de un mismo grupo de trabajo pueden tener versiones distintas; eso no afecta la prueba ni el grupo.

## 9. Devolución

- La corrección se devuelve al inicio del encuentro 34, con comentario escrito individual y comentarios generales al curso.
- Los núcleos no alcanzados se trabajan en los encuentros especiales 34 y 35 de recuperación y profundización, con resultado aún provisorio de Apto o No apto.
