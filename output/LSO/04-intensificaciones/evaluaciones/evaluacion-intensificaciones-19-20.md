# Evaluación — Momento integrador de las Unidades 1 y 2 (Encuentros 19–20)

## Metadatos

| Campo | Valor |
|---|---|
| Momento | Proyecto puente integrador de las Unidades 1 y 2 |
| Encuentros | 19 y 20 |
| Duración | 120 min (evaluación + defensa) |
| Tipo de evaluación | Rúbrica de 100 puntos |
| Cantidad de versiones | 2 (A y B) |
| Destinatarios | Totalidad del curso (una sola pista) |
| Requisitos | Haber participado de los encuentros 19 y 20; contar con proyecto funcional con endpoints GET, JOIN y Dapper |
| Lugar | Aula de informática con VS Code, SDK .NET 6, SQLite, Thunder Client y GitHub |

## Descripción general

Esta evaluación integradora verifica que cada estudiante puede construir una API de consulta completa sobre `hospital.db` combinando endpoints GET, JOIN con Dapper, consultas parametrizadas, mapeo a records y entrega profesional en GitHub. Se evalúa con rúbrica de 100 puntos.

Cada estudiante recibe la versión A o la versión B (mismos criterios, distinta tabla principal: `Patients`/`Doctors` y sus relaciones).

## Rúbrica de evaluación (100 puntos)

| Dimensión | Puntaje máximo | Indicadores de logro |
|---|---|---|
| Endpoints GET base | 30 pts | Endpoint de lista (`/patients` o `/doctors`) y endpoint por ID (`/{id}`) funcionan con JSON correcto y manejan `404` con `Results.NotFound`. |
| Consultas Dapper con JOIN | 25 pts | Endpoint con JOIN de 2 tablas que devuelve datos combinados; mapeo a record con alias `AS` en SQL; resultados verificables en Thunder Client. |
| Parámetros y filtros | 20 pts | Al menos un endpoint con parámetro de query string usando `@{param}` y `new { ... }` en Dapper. |
| Calidad del código | 15 pts | Consultas parametrizadas sin concatenación SQL; `using` correctos; nombres de endpoints en inglés y plural; registros posicionales después de `app.Run()`. |
| Entrega y defensa | 10 pts | Repositorio GitHub actualizado; commit con el proyecto completo; durante la defensa explica al menos un endpoint y muestra qué devuelve cuando el recurso no existe. |

### Escala de aprobación

| Rango | Resultado |
|---|---|
| 60 – 100 | Apto |
| 0 – 59 | No apto aún por objetivo mínimo (se detallan las dimensiones no alcanzadas) |

## Guía de corrección (docente)

**Versión A — tabla Patients.**
**Versión B — tabla Doctors (con Admissions como tabla de relación).**

Verificar en el código fuente:
1. Los endpoints usan `app.MapGet`, `app.MapPost`, etc. según corresponda. La versión integradora solo exige GET, pero si el estudiante incluyó POST/PUT/DELETE no se descuenta.
2. El JOIN usa `INNER JOIN` (o `LEFT JOIN` si corresponde al dominio) con alias en cada columna del SELECT.
3. El record de mapeo tiene propiedades en el orden y con los tipos exactos del constructor.
4. La consulta con query string usa `WHERE columna = @param` o `LIKE @param`.
5. No hay cadenas SQL armadas con `+` ni interpolación de variables en el SQL.
6. Los records están después de `app.Run()`.

Puntaje por dimensión: evaluar cada indicador de forma binaria (cumple = puntaje completo, no cumple = 0 en ese indicador). Si un indicador se cumple parcialmente, asignar la mitad del puntaje de esa dimensión y anotar el motivo.