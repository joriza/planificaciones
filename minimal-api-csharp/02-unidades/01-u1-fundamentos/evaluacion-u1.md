# Evaluación de la Unidad 1 — Fundamentos de C#, Git/GitHub y Minimal API

## Metadatos de la instancia

| Campo | Detalle |
|---|---|
| Instancia | Evaluación de la Unidad 1 |
| Encuentro | 9 |
| Duración teórica | 4 h (240 minutos) |
| Carácter | Sumativo |
| TP obligatorio | tp-u1 |
| Destinatarios | Todos los grupos |
| Requisitos previos | Repositorio del grupo operativo; rutina de Git incorporada (commit con mensaje referente al cierre de cada encuentro) |

## Acuerdos de la instancia

- Ejercicio pequeño con contenidos de la Unidad 1, asignado por versión (A o B) al inicio del encuentro.
- Desarrollo en grupo, en el propio repositorio del grupo, dentro de la carpeta `tp-u1`.
- Entrega dentro del encuentro: commits con mensajes referentes y push al repositorio remoto.
- Defensa individual breve al cierre: cada estudiante explica sus decisiones y realiza una modificación menor sobre su código.
- La versión asignada no otorga ventaja ni habilita copia entre grupos: las versiones A y B son equivalentes en objetivos, requisitos y dificultad, y difieren solo en el dominio y los datos.

## Agenda teórica del encuentro 9 (240 minutos)

| Momento | Duración | Detalle |
|---|---|---|
| Apertura y asignación de versiones | 15' | Recordatorio de consigna, rúbrica y asignación de versión A o B por grupo |
| Desarrollo del ejercicio | 150' | Construcción del CRUD en memoria en Program.cs, con validaciones y códigos de estado |
| Commits y push final | 30' | Cierre de la entrega: commits con mensajes referentes y push a la carpeta tp-u1 |
| Defensas individuales | 30' | Defensas breves por estudiante, mientras el resto del grupo consolida su entrega |
| Cierre | 15' | Estado final de repositorios, registro de resultados y anticipación de la devolución |

## Criterios de logro mínimos de la Unidad 1

- Levantar y ejecutar un proyecto Minimal API desde cero (`dotnet new web`), en VS Code y terminal.
- Gestionar el ciclo completo de entrega con Git y GitHub (gitignore, init, add, commit con mensaje referente, remote, push) y sostener la rutina de un commit al cierre de cada encuentro.
- Leer e interpretar respuestas en formato JSON antes de su uso.
- Construir endpoints con rutas y parámetros (`MapGet`, `MapPost`, `MapDelete`).
- Implementar un CRUD en memoria con `List<T>` y `record`.
- Aplicar códigos de estado adecuados (Ok, Created, NotFound, NoContent) y validaciones mínimas.

## Rúbrica de evaluación (100 puntos)

| Criterio | Puntaje | Indicadores |
|---|---|---|
| API funcionando sin errores | 30 | El proyecto compila y se ejecuta; los endpoints responden según la consigna |
| Estructura y claridad del código en Program.cs | 20 | Código ordenado, nombres consistentes, comentarios que explican decisiones |
| Códigos de respuesta y validaciones correctos | 20 | 200/201/204 según el verbo; 404 cuando no existe; 400 con mensaje en la validación |
| Entrega por Git (carpeta tp-u1, commits referentes, push) | 15 | Carpeta tp-u1 creada, commits con mensajes referentes, push dentro del encuentro |
| Defensa individual | 15 | Explicación oral de decisiones y modificación menor del código por cada estudiante |
| **Total** | **100** | |

**Aprobación:** 60 puntos o más Y defensa individual realizada por el estudiante.

## Devolución

Devolución grupal e individual al inicio del encuentro 10, conforme a la rutina de retroalimentación oportuna prevista en la planificación anual.
