# Evaluación de la Unidad 4 — Encuentro 32 — Versión B

> Dominio de esta versión: patients/admissions (dominio u2-B). Duración: 90 minutos. Puntaje total: 100 puntos. Resolución individual, con computadora, sin celular. Las condiciones completas están en `evaluacion-u4.md`.

## Antes de empezar

- Realizar un ejercicio breve de profesionalización sobre flujo de ramas, PR y main protegida usando el dominio de pacientes/admissions de hospital.db.
- Resolver la prueba en un único archivo `Program.cs` si se requiere código.
- Usar las convenciones del curso: tipos canónicos, alias `AS`, consultas parametrizadas, `Results.*`.
- No se permite concatenar datos al SQL.
- El docente provee el esqueleto del ejercicio de profesionalización; el alumno completa las operaciones.
- Al terminar, detener la aplicación con `Ctrl+C` y dejar el proyecto en estado limpio.

## Objetivos de la prueba

1. Demostrar el flujo profesional de ramas por feature, PR revisada y main protegida.
2. Demostrar la API final funcionando con operaciones CRUD completas.
3. Demostrar que el README de portada contiene la información requerida.
4. Demostrar que los issues están creados y vinculados a las PR.

## Material provisto — Esqueleto del ejercicio de profesionalización

El docente provee un repositorio pre-configurado con las siguientes condiciones:
- Rama `main` protegida (sin permisos de push directo).
- Un issue abierto: "Implementar endpoint GET /patients".
- El alumno debe crear una rama por feature, resolver el issue, abrir una PR, y hacer merge a `main` siguiendo el flujo profesional.

## Parte 1 — Flujo de ramas y PR (40 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 1.1 | Crear una rama por feature llamada `feature/get-patients` partiendo de `main`. | 10 |
| 1.2 | Resolver el issue "Implementar endpoint GET /patients" en la rama de feature. | 10 |
| 1.3 | Abrir una PR desde `feature/get-patients` a `main` con descripción clara del cambio. | 10 |
| 1.4 | Realizar una revisión de la PR (al menos un comentario de revisión). | 10 |

## Parte 2 — Protección de main (25 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 2.1 | Configurar la protección de la rama `main` para requerir al menos 1 revisión de PR antes del merge. | 15 |
| 2.2 | Demostrar que no es posible hacer push directo a `main`. | 10 |

## Parte 3 — README de portada (20 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 3.1 | Redactar un README de portada que incluya: título del proyecto, descripción breve, instrucciones de instalación, uso de la API (endpoints principales), y convenciones del curso. | 20 |

## Parte 4 — Ítems conceptuales (15 puntos)

| Ítem | Pregunta | Puntos |
| --- | --- | --- |
| 4.1 | ¿Por qué se protege la rama `main`? (Respuesta: para evitar pushes directos que puedan romper la rama principal; toda changes debe pasar por revisión de PR.) | 8 |
| 4.2 | ¿Qué diferencia hay entre una rama por feature y trabajar directamente en `main`? (Respuesta: las ramas por feature aislán los cambios, permiten revisión, y facilitan la trazabilidad de cada mejora.) | 7 |

## Batería de verificación: salida esperada de cada prueba

| Prueba | Pedido | Salida esperada |
| --- | --- | --- |
| Verificar rama `feature/get-patients` | Rama creada desde `main` | Rama existente en el repositorio |
| Verificar PR abierta | PR con descripción clara | PR visible en GitHub con label y descripción |
| Verificar protección de `main` | Al menos 1 revisión requerida | Configuración de protección activa en GitHub |
| Verificar README | README con secciones requeridas | Archivo README.md con título, descripción, instalación, uso |
| Verificar issue vinculado | Issue creado y referenciado en PR | Issue existente y mencionado en la descripción de la PR |

## Al terminar

Dejar el repositorio en estado limpio con la PR mergeada a `main`. No hacer push de cambios adicionales después del merge. El docente verificará el flujo Git y la API durante la defensa.