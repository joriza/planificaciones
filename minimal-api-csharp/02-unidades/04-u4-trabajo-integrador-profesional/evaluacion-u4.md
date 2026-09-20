# Evaluación de la Unidad 4 — Defensa del trabajo integrador

> Evaluación del Encuentro 32 — Unidad didáctica 4 · Curso: Minimal API con C# .NET 6. Registro docente formal: metadatos y acuerdos de la instancia. Este documento se entrega junto con la versión asignada (A o B) de la prueba práctica. La solución completa y los criterios de corrección viven en los anexos docentes de cada versión.

## 1. Identificación

| Campo | Detalle |
| --- | --- |
| Instancia | Encuentro 32 — Evaluación de la Unidad 4 (encuentro dedicado) |
| Clímax | Defensa oral del trabajo integrador |
| Destinatarios | Todo el curso: entrega y prueba práctica por grupos; defensa por integrante |
| Alcance | Unidad 4: consigna canónica del trabajo final (requisitos a-f, encuentro 27) + flujo profesional de GitHub (encuentros 28 y 29) |
| Modalidad | Verificación de entrega por GitHub + defensa oral individual + prueba práctica breve A/B con computadora sobre el repositorio del grupo |
| Duración | 240 minutos: entrega y verificación GitHub 30 · defensas individuales 90 · prueba práctica A/B 90 · cierre 30 |
| Puntaje | Defensa individual sobre 100 (rúbrica) y prueba práctica sobre 100; la calificación de la unidad se compone al 50 % y 50 % (sección 4) |
| Uso de celular | No permitido |
| Material consultable | El repositorio del grupo (código, README, issues y PRs) y la API corriendo: son las dos fuentes de verdad de la evaluación. No se consultan apuntes ni material externo |

**Regla canónica de la instancia:** la entrega del trabajo final por GitHub y la defensa individual se realizan en este encuentro; el encuentro 33 (Cierre integrador del cuatrimestre 2) abre con su devolución.

## 2. Objeto de la evaluación

La Unidad 4 profesionaliza el repositorio del grupo y culmina en un producto integrador: la API «Gestión hospitalaria» con los requisitos a-f de la consigna canónica (encuentro 27), organizada con issues, ramas por feature, pull requests revisados y `main` protegida (encuentros 28 y 29). Esta evaluación verifica el producto entregado y la apropiación individual del trabajo mediante la defensa, y completa la verificación con un ejercicio breve que ejecuta el flujo profesional en vivo.

### Objetivos evaluados

1. Presentar el trabajo integrador consolidado: `main` con los requisitos a-f fusionados, README completo, issues cerrados y sin PRs abiertos (entrega verificada en el bloque 1).
2. Defender individualmente el trabajo con el guion de 5 a 7 minutos: portada, demo guiada por requisito y cierre con una decisión técnica propia, respondiendo del banco de preguntas.
3. Ejecutar en vivo el flujo profesional completo sobre el repositorio del grupo: issue con criterio de aceptación → rama `feature/` → commits referentes → push → PR con `Closes #N` → revisión de un par → merge sobre `main` protegida.
4. Construir un mini endpoint adicional de estadística sobre `hospital.db` respetando el canon del curso.
5. Explicar los conceptos del flujo: qué protege `main` y qué registra cada pieza (issue y pull request).

### Alineación con la unidad

- La **consigna canónica** evaluada es la del encuentro 27: requisitos a-f con sus endpoints y códigos esperados (`/admissions/details`, `/stats/specialties`, `/patients/search`, `POST`/`DELETE /patients`, `/admissions/dirty-dates`, README). Ningún requisito cambia para la evaluación.
- La **rúbrica de la defensa** aplica los cuatro bloques y ocho criterios anticipados al grupo en el encuentro 31 (anexo docente del encuentro): entrega, flujo profesional, requisitos a-f y defensa individual. Los anexos de esta evaluación agregan únicamente la columna de puntaje para calificar.
- Las **preguntas de la defensa** salen del banco anticipado en el anexo docente del encuentro 31, más los ítems conceptuales de la prueba práctica.

## 3. Estructura del encuentro (240 minutos)

| Bloque | Tiempo | Qué ocurre |
| --- | --- | --- |
| 1. Entrega y verificación final por GitHub | 30 min | El docente recorre el repositorio de cada grupo con la checklist de entrega del encuentro 31: `main` con los requisitos a-f y sin PRs abiertos, README con ejemplos probados, issues cerrados o explicables, historial con la convención `trabajo-final: ...` y canon del código (`Program.cs` único, records al final, parametrización, `Results.*`, ids `long`, fechas `string`). El resultado alimenta el bloque Entrega de la rúbrica. |
| 2. Defensas individuales | 90 min | Cada integrante defiende con el guion: portada (~1 min), demo guiada por requisito con `curl` preparado (3 a 5 min) y cierre con una decisión técnica (~1 min), más preguntas del banco. Se defiende grupo por grupo, con el grupo presente. Si un comando falla en vivo, leer el error en voz alta y razonarlo también puntúa. |
| 3. Prueba práctica breve A/B | 90 min | Cada grupo ejecuta sobre su repositorio el flujo profesional completo con un endpoint adicional pequeño (versión A o B, sección 5) y responde en forma individual dos ítems conceptuales por escrito. Estructura completa y puntaje en las versiones. |
| 4. Cierre | 30 min | Registro de resultados en la planilla, balance oral breve por grupo (qué consolidó la unidad y qué queda pendiente) y anuncio: el encuentro 33 abre con la devolución. |

## 4. Instrumentos y criterios de calificación

### 4.1 Defensa individual (sobre 100)

Rúbrica de cuatro bloques y ocho criterios, con los mismos criterios anticipados en el encuentro 31 y calificación agregada en los anexos docentes de las versiones:

| Bloque | Criterios | Puntos |
| --- | --- | --- |
| Entrega | Repositorio empujado con `main` completa y clon fresco que corre con el README · README íntegro con ejemplos curl probados | 20 |
| Flujo profesional | Trazabilidad issue → rama → PR → merge en la mayoría de los features · revisión entre pares con aprobación ajena y sin push directo a `main` protegida | 30 |
| Requisitos a-f | Los seis requisitos responden según su criterio de aceptación (códigos incluidos) · canon del código respetado | 30 |
| Defensa individual | Demo guiada por requisito con comandos preparados · explicación del código propio y de las decisiones técnicas | 20 |

Cada criterio se observa como logrado, en proceso o no logrado (desglose ítem por ítem en los anexos). Ante silencio se baja la pregunta de nivel; la corrección docente nunca reemplaza el intento del alumno.

### 4.2 Prueba práctica A/B (sobre 100)

| Bloque | Contenido | Puntos |
| --- | --- | --- |
| 1 | Issue con criterio de aceptación y etiqueta | 15 |
| 2 | Rama `feature/` + commits referentes + push de la rama | 20 |
| 3 | PR con `Closes #N` + revisión de un par + merge sobre `main` protegida | 25 |
| 4 | Mini endpoint adicional de estadística según versión | 30 |
| 5 | Ítems conceptuales individuales por escrito | 10 |
| **Total** | | **100** |

### 4.3 Composición de la calificación de la unidad

- **Calificación de U4 = 50 % defensa individual + 50 % prueba práctica A/B.**
- La entrega por GitHub (bloque 1 del encuentro) no puntúa aparte: se califica dentro del bloque Entrega de la rúbrica de la defensa.
- En la prueba práctica, los bloques 1 a 4 (90 puntos) son producto del grupo con roles rotativos y observables; los 10 puntos del bloque 5 son individuales. El puntaje individual de la prueba es el del grupo más el propio de los ítems conceptuales.
- Los umbrales de acreditación y las capas de recuperación son los definidos en `06-aprobacion/criterios-aprobacion.md`.

## 5. Regla de equivalencia entre las versiones A y B

- **Misma estructura:** mismos cinco bloques, mismos objetivos y requisitos, mismo puntaje ítem por ítem.
- **Distinto dominio en el mini endpoint:** la versión A construye la estadística de **médicos por especialidad** (`GET /stats/doctors`, tabla `doctors`); la versión B la de **pacientes por provincia** (`GET /stats/provinces`, tablas `patients` + `province_names`). Ambos endpoints usan el mismo molde: `COUNT(*)` con `GROUP BY`, orden descendente por cantidad, record de dos campos con alias y verificación con `curl`. Ninguno duplica un requisito a-f: son estadísticas adicionales a la consigna.
- El flujo profesional (bloques 1 a 3), la estructura de puntos y los ítems conceptuales son idénticos en ambas versiones; la diferencia de tablas es la única variación de datos, y ninguna versión tiene una regla que la otra no tenga.
- El propósito de la equivalencia es que la versión asignada no otorgue ventaja ni habilite la copia entre grupos.

## 6. Mecánica de asignación de versiones

- La versión (A o B) se asigna **por grupo**, con criterio alternado definido por el docente al iniciar la prueba (por ejemplo, grupos impares A y pares B), y se registra en la planilla (grupo → versión).
- Todos los integrantes de un grupo trabajan la misma versión: el flujo es colaborativo sobre el repositorio del grupo, a diferencia de las pruebas individuales de otras instancias.
- La defensa individual no tiene versión: es común a todo el curso.

## 7. Condiciones de resolución

- **Sin celular** en ningún momento del encuentro.
- **Roles rotativos y observables:** cada integrante ejecuta al menos un paso visible del flujo (crear el issue, conducir los comandos de rama y push, abrir el PR o revisarlo); quien escribe un PR nunca es su revisor (regla de la unidad).
- El repositorio parte del estado de entrega verificado en el bloque 1; el endpoint nuevo se construye siempre en rama y entra a `main` por PR revisado. **Nada se pushea directo a `main`**: si un push directo es rechazado (GH006), es la protección funcionando, no un error del grupo.
- Los ítems conceptuales se responden individualmente y por escrito, con las propias palabras y sin computadora.
- El tiempo agotado no invalida la prueba: se registra la evidencia parcial alcanzada (issue creado, rama empujada, PR abierto o fusionado).

## 8. Registro y devolución

- **Planilla de resultados:** por grupo, versión asignada y puntaje por bloque de la prueba; por integrante, los ocho criterios de la rúbrica, la nota de defensa, el puntaje conceptual individual y la composición final 50/50.
- **Devolución:** al inicio del encuentro 33 (Cierre integrador del cuatrimestre 2), con resultados generales del curso, comentarios por grupo (entrega y flujo) y comentarios individuales (defensa e ítems conceptuales).
- Los núcleos no alcanzados se traducen en pistas para los encuentros 34 y 35 de recuperación y profundización (Unidades 3 y 4).
