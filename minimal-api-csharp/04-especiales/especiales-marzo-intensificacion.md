# Especial de marzo — Intensificación del camino mínimo completo

> Momento especial de recuperación pedagógica **fuera de la planificación anual** (ver `encuentros-especiales.md`): se dicta en marzo, antes del inicio del nuevo ciclo, para quienes no alcanzaron los objetivos mínimos en diciembre. Es un momento de **solo intensificación**: no tiene pista de profundización y **no imparte contenidos nuevos**. Su nombre es referencial y ordena alfabéticamente después de los documentos numerados de los especiales.

## 1. Metadatos del momento

| Campo | Detalle |
| --- | --- |
| Momento | Especial de marzo — intensificación (fuera de la estructura anual de 36 encuentros) |
| Cuándo | Marzo, antes del inicio del nuevo ciclo |
| Duración | 2 encuentros de 240 minutos cada uno (480 minutos totales) |
| Destinatarios | Estudiantes que no alcanzaron los objetivos mínimos en diciembre y tuvieron más tiempo para prepararse |
| Requisitos | Repositorio del grupo disponible en GitHub (con tp-u1, tp-u2, tp-u3 y trabajo-final); `hospital.db`; PC del aula-taller con SDK de .NET 6, VS Code y terminal; credenciales de GitHub del grupo accesibles; plan de repaso y guía de diciembre ya trabajados (estudio personal previo) |
| Lugar | Aula-taller de la institución |
| Carácter | Solo intensificación: sin pista de profundización. Sin contenidos nuevos: repaso guiado del camino mínimo completo y evaluación del momento. **El estándar de evaluación no baja respecto de diciembre**: mismos objetivos mínimos y misma exigencia; lo único que cambia es el tiempo de preparación que tuvo cada estudiante |
| Evaluación | Prueba práctica individual en versiones A y B (`evaluaciones/evaluacion-especiales-marzo.md`), con criterio Apto / No apto aún por objetivo mínimo |

## 2. Acuerdo pedagógico — grupo de intensificación

El momento atiende un único grupo de condición (intensificación), con el siguiente acuerdo pedagógico documentado:

### Contenidos mínimos irrenunciables (camino mínimo completo del curso)

Los mismos que en diciembre: el camino mínimo completo del curso, nada menos.

| Unidad | Contenido mínimo irrenunciable |
| --- | --- |
| Unidad 1 | Crear una API Minimal desde la terminal (`dotnet new web`, `dotnet run`) y ejecutarla; endpoint GET con parámetro de ruta que devuelva JSON; verbos HTTP y códigos de respuesta con `Results` (200, 201, 400, 404); entrega por GitHub (carpeta, commits y push) |
| Unidad 2 | Conexión a `hospital.db` con Dapper; SELECT parametrizado con WHERE por id; búsqueda parcial con LIKE parametrizado; JOIN de dos tablas mapeado a record compuesto; escritura (INSERT) parametrizada con validación manual y códigos 201 y 400 |
| Unidad 3 | JOIN de tres tablas; reporte con COUNT y GROUP BY; tratamiento del dato sucio (valores NULL, por ejemplo ingresos abiertos sin fecha de alta) sin romper la consulta |
| Unidad 4 | README de portada del trabajo; flujo profesional del repositorio: issue, rama por feature, pull request revisado y fusión a main protegida |

### Actividad y recursos acordados

| Componente | Acuerdo |
| --- | --- |
| Actividad (ultra-condensada) | Repaso guiado núcleo por núcleo con énfasis en el estudio personal previo: cada estudiante llega con el camino mínimo repasado con la guía de diciembre; el docente muestra el mínimo, cada estudiante lo reconstruye sin la guía sobre el propio repositorio del grupo y usa la guía solo para verificar; corrección inmediata sobre la máquina |
| Metodología (ultra-condensada) | Teoría mínima dentro de la práctica, sin exposiciones extendidas y sin contenidos nuevos; apoyo entre pares presentes; cierre de cada bloque con commit referente |
| Recursos (condensados al 25%) | Aula-taller, una PC por estudiante, VS Code + terminal, `hospital.db`, repositorio del grupo en GitHub, guía de repaso y hoja de comandos provistas por el docente |

## 3. Encuentro 1 — Puesta a punto y repaso guiado U1-U2

| Bloque | Tiempo | Desarrollo |
| --- | --- | --- |
| Plenaria de apertura | 20 | Encuadre del momento: qué se recupera y para qué (resultado Apto / No apto aún por objetivo mínimo), lectura del acuerdo pedagógico, registro del plan de diciembre (qué núcleos marcó cada estudiante como flojos y qué repaso personal hizo desde diciembre) y reglas de trabajo del aula-taller |
| Bloque 1 | 90 | Repaso guiado de la Unidad 1 sobre una lista en memoria: crear el proyecto y correrlo; GET con parámetro de ruta (200 con el dato, 404 con mensaje); alta con validación manual (201, 400); rutina de commit local del día |
| Bloque 2 | 90 | Repaso guiado de la Unidad 2 sobre `hospital.db`: conexión con Dapper; el GET por id reemplaza la lista por un SELECT parametrizado con alias; búsqueda parcial con LIKE; JOIN de dos tablas mapeado a record compuesto; escritura parametrizada con validación; commit y push |
| Plenaria de cierre | 40 | Puesta en común de los errores comunes del día; cada estudiante vuelve a marcar qué núcleos quedaron flojos en su guía; organización del segundo encuentro y del repaso personal de U3-U4 para casa |

## 4. Encuentro 2 — Repaso U3-U4 y evaluación del momento

| Bloque | Tiempo | Desarrollo |
| --- | --- | --- |
| Plenaria de apertura | 20 | Puente con el encuentro anterior y con el repaso personal de casa: dudas pendientes de U1-U2; plan del día; reglas de la evaluación (individual, material provisto, tiempos) |
| Bloque 1 | 90 | Repaso guiado de U3 y U4: JOIN de tres tablas con el molde canónico (`admissions` + `patients` + `doctors`); reporte con COUNT y GROUP BY; dato sucio: ingresos abiertos con `discharge_date` en NULL y su filtro; README de portada; flujo issue → rama por feature → pull request → main protegida |
| Bloque 2 | 90 | Evaluación del momento: prueba práctica individual en versiones A y B sobre `hospital.db` y el repositorio del grupo (`evaluaciones/evaluacion-especiales-marzo.md`) |
| Plenaria de cierre | 40 | Registro del resultado por objetivo mínimo; devolución oral inicial; entrega por escrito del detalle de objetivos pendientes a quien corresponda |

## 5. Criterios de logro del momento

- El resultado se registra **por objetivo mínimo** (U1, U2, U3 y U4) como **Logrado** o **No logrado aún**, a partir de la evidencia de la prueba.
- **Apto:** los cuatro objetivos mínimos del camino quedan logrados en la prueba.
- **No apto aún:** al menos un objetivo queda sin lograr. No es una calificación final: cierra el ciclo de recuperación del curso; el resultado queda registrado en el legajo y la devolución detalla los objetivos pendientes para encarar el nuevo ciclo.
- El registro es docente formal (alumno, versión, objetivo por objetivo, resultado del momento) y la devolución es oral en la plenaria de cierre del segundo encuentro.
- El momento no imparte contenidos nuevos. **El estándar de evaluación es idéntico al de diciembre** (`especiales-diciembre-intensificacion.md`): la prueba de marzo recorre el mismo camino mínimo completo, con versiones A y B equivalentes a las de diciembre en objetivos y exigencia; lo único que cambia es el tiempo de preparación que tuvo cada estudiante.
