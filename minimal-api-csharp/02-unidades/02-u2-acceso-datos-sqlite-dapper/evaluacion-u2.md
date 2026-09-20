# Evaluación de la Unidad 2 — Acceso a datos con SQLite y Dapper

## Metadatos de la instancia

| Campo | Detalle |
|---|---|
| Instancia | Evaluación de la Unidad 2 |
| Encuentro | 15 |
| Duración teórica | 4 h (240 minutos) |
| Carácter | Sumativo |
| TP obligatorio | tp-u2 |
| Destinatarios | Todos los grupos |
| Requisitos previos | Proyecto `HospitalApi` de la clase 14 funcionando sobre `hospital.db`; rutina de Git incorporada (commit con mensaje referente al cierre de cada encuentro); devolución de la evaluación de la Unidad 1 disponible |

## Acuerdos de la instancia

- Trabajo práctico integrador con los contenidos de la Unidad 2: endpoints GET contra la base real `hospital.db`, asignado por versión (A o B) al inicio del encuentro.
- Desarrollo en grupo, en el propio repositorio del grupo, dentro de la carpeta `tp-u2`. El proyecto y el archivo `hospital.db` quedan incluidos en el repositorio: la entrega tiene que funcionar en otra máquina después de clonar.
- Entrega dentro del encuentro: commits con mensajes referentes y push al repositorio remoto. El historial de trabajo es parte de la entrega.
- Defensa individual breve al cierre: cada estudiante muestra un endpoint funcionando, explica una parte del código señalada por el docente, justifica las consultas SQL empleadas y refiere cómo incorporó las devoluciones recibidas en instancias previas.
- Registro de resultados y acuerdos de mejora al cierre del encuentro; la devolución se presenta al inicio del encuentro 16.
- La versión asignada no otorga ventaja ni habilita copia entre grupos: las versiones A y B son equivalentes en objetivos, técnicas exigidas y dificultad, y difieren solo en el dominio y las tablas involucradas.
- Celular: no permitido durante la instancia.

## Agenda teórica del encuentro 15 (240 minutos)

| Momento | Duración | Detalle |
|---|---|---|
| Apertura, consigna y asignación de versiones | 15' | Recordatorio de consigna, rúbrica y asignación de versión A o B por grupo |
| Desarrollo del TP tp-u2 | 150' | Construcción de los endpoints GET sobre hospital.db en Program.cs: listado, detalle por Id, filtro exacto, búsqueda con LIKE y endpoint integrador con JOIN |
| Commits y push final | 30' | Cierre de la entrega: commits con mensajes referentes y push a la carpeta tp-u2, con hospital.db incluido |
| Defensas individuales | 30' | Defensas breves por estudiante con el proyecto a la vista, mientras el resto del grupo consolida su entrega |
| Cierre | 15' | Estado final de repositorios, registro de resultados y acuerdos de mejora |

## Criterios de logro mínimos de la Unidad 2

- Conectar la API a `hospital.db` con `Microsoft.Data.Sqlite` y Dapper, con el archivo junto al `.csproj`.
- Escribir consultas `SELECT` mapeadas a records DTO con alias `AS` (mapeo por nombre) y tipos según SQLite: ids `long`, fechas y textos `string`.
- Filtrar con `WHERE` y parámetros mediante objetos anónimos (`new { Id = id }`), sin concatenar valores en el SQL, y buscar con `LIKE` armando el patrón `%` en el valor.
- Combinar dos tablas con `JOIN` (alias cortos, columnas calificadas y condición `ON` completa).
- Exponer endpoints GET con códigos adecuados: 200 con datos, 200 con arreglo vacío en búsquedas sin coincidencias, 404 con mensaje cuando el recurso no existe.
- Sostener la rutina de Git: carpeta `tp-u2`, commits referentes y push al cierre, con `hospital.db` incluido para que el proyecto funcione tras clonar.

## Rúbrica de evaluación (100 puntos)

| Criterio | Puntaje | Indicadores |
|---|---|---|
| API funcionando sobre hospital.db | 25 | El proyecto compila y se ejecuta tras clonar; los 5 endpoints responden con datos reales según la consigna |
| Consultas SQL correctas | 20 | `SELECT` con alias `AS`; `WHERE` con marcador `@` y objeto anónimo; `LIKE` con el patrón en el valor; `JOIN` con `ON` completo y columnas calificadas |
| DTOs y mapeo con Dapper | 15 | Records al final de Program.cs, una propiedad por alias `AS`, ids `long` y fechas `string`; DTO reutilizado cuando corresponde |
| Códigos de respuesta correctos | 10 | 200 con datos; 200 con arreglo vacío en búsquedas; 404 con mensaje cuando el recurso no existe |
| Entrega por Git (carpeta tp-u2, commits referentes, push) | 15 | Carpeta tp-u2 con el proyecto y hospital.db, commits con mensajes referentes y push dentro del encuentro |
| Defensa individual | 15 | Explica endpoints y consultas SQL con sus palabras, realiza una modificación menor y refiere devoluciones previas incorporadas |
| **Total** | **100** | |

**Aprobación:** 60 puntos o más Y defensa individual realizada por el estudiante.

## Devolución

Devolución grupal e individual al inicio del encuentro 16, conforme a la rutina de retroalimentación oportuna prevista en la planificación anual. El registro de resultados y los acuerdos de mejora quedan asentados en el anexo docente de cada versión.
