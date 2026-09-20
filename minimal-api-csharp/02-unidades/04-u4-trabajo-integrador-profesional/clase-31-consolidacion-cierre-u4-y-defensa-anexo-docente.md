# Anexo docente — Encuentro 31: consolidación, cierre de la Unidad 4 y defensa

> Registro docente formal. Documento interno del docente: no se entrega a los alumnos.

| Campo | Detalle |
| --- | --- |
| Encuentro | 31 — Unidad didáctica 4 (5 de 5, cierre) |
| Contenido | Consolidación y entrega del trabajo-final; guion de defensa; rúbrica anticipada; preguntas y respuestas esperadas |
| Continuidad | Los bloques de rúbrica y preguntas anticipan la evaluación del encuentro 32 (ver `evaluacion-u4*.md` de la unidad) |

## 1. Checklist de entrega final del trabajo-final

Verificación docente sobre el repositorio de cada grupo al cierre del encuentro (la misma lista sirve para la verificación de la entrega en el encuentro 32):

| ✔ | Ítem |
| --- | --- |
| ☐ | `main` contiene los requisitos a-f fusionados; no hay PRs abiertos |
| ☐ | `README.md` en la raíz: proyecto, integrantes, cómo clonar y correr, tabla de endpoints con ejemplos curl probados |
| ☐ | Un clon fresco sigue el README y corre la API sin ayuda (probarlo el docente) |
| ☐ | Issues: los cumplidos cerrados; los abiertos restantes son explicables |
| ☐ | Historial: commits con la convención `trabajo-final: ...`, PRs revisados, sin push directo a `main` después de la protección |
| ☐ | Código: todo en `Program.cs`, records al final, consultas parametrizadas, `Results.*`, ids `long`, fechas `string` |

## 2. Guion de la defensa (plantilla docente)

Duración individual: 5 a 7 minutos. El orden sugerido recorre la consigna por requisito, que es también el orden de la rúbrica.

| Momento | Duración | Contenido | Evidencia observable |
| --- | --- | --- | --- |
| Portada | ~1 min | Qué es la API, sobre qué base trabaja, quiénes son el grupo y qué hizo cada uno | README en pantalla, lectura propia |
| Demo (a) | ~1 min | `GET /admissions/details`: ingresos con paciente, médico y especialidad | `curl` en vivo, respuesta 200 explicada |
| Demo (b) | ~1 min | `GET /stats/specialties`: ingresos por especialidad | `curl` + lectura de una fila del resultado |
| Demo (c) | ~1 min | `GET /patients/search`: los tres casos (200, 400, 404) | Los tres comandos preparados y sus códigos |
| Demo (d) | ~1 min | `POST` válido (201), `POST` inválido (400), `DELETE` (204/404) | Cuatro comandos o los que el guion decida |
| Demo (e) | ~1 min | `GET /admissions/dirty-dates` y explicación del dato sucio | Respuesta 200 + explicación del caso `'1971-01-05'` |
| Cierre | ~1 min | Una decisión técnica propia: parámetros SQL, códigos de estado o el flujo de ramas/PRs | Explicación con el código en pantalla |

Preparación previa esperada de cada alumno: archivo propio con los comandos `curl` listos, API arrancada y puerto verificado. Si un comando falla en la demo: leer el error en voz alta y razonar la causa; la lectura del error también es competencia evaluada.

## 3. Preguntas y respuestas esperadas por requisito

Banco de preguntas del docente para la defensa, con la respuesta esperada. Cada alumno recibe dos o tres, mezclando un requisito que programó y uno del grupo.

### Requisito (a) — JOIN triple

- **¿Por qué tres tablas y no dos?** — El ingreso (`admissions`) guarda solo los ids: `patient_id` y `attending_doctor_id`. Los nombres y la especialidad viven en `patients` y `doctors`; sin los JOIN la respuesta tendría números, no datos útiles.
- **¿Qué pasa si un ingreso apuntara a un médico que no existe?** — Con JOIN interno, esa fila desaparecería del resultado: el JOIN solo devuelve coincidencias. La base tiene integridad referencial, así que no debería ocurrir; saber nombrarlo es suficiente.
- **¿Por qué los alias `AS PatientName`?** — Las columnas están en `snake_case` y Dapper mapea por nombre contra el record en PascalCase; el guión bajo rompe la coincidencia y el `AS` la arregla.

### Requisito (b) — GROUP BY

- **¿Qué agrupa exactamente `COUNT(*)`?** — Las filas de ingresos por cada especialidad distinta: una fila de resultado por grupo.
- **¿Por qué `ORDER BY TotalAdmissions DESC`?** — La estadística se lee de más a menos; el alias del conteo se puede usar en el orden.
- **¿Por qué el conteo es `int` y no `long`?** — Canon del curso: `int` para conteos y medidas; `long` reservado para ids, porque SQLite entrega enteros como `long` y el mapeo de ids con `int` falla.

### Requisito (c) — búsqueda con LIKE

- **¿Por qué el patrón `%term%`?** — `%` es el comodín de LIKE: significa «cualquier texto antes y después»; así el término buscado puede estar en cualquier parte del apellido.
- **¿Por qué 400 y no 404 cuando falta el parámetro?** — 400: el pedido está mal formado (falta un dato necesario). 404: el pedido está bien formado pero no hay recurso con esa condición (nadie coincide).
- **¿Por qué `@filter` y no concatenar el texto?** — Parámetros: inyección SQL imposible y errores de comillas evitados. Concatenar texto del usuario con SQL es el defecto grave del curso.

### Requisito (d) — escritura validada

- **¿Qué validaciones hace el POST y por qué cada una?** — Obligatorios (la tabla los exige), género `M`/`F` (dominio del dato), fecha ISO `yyyy-MM-dd` (formato canónico de las fechas del curso), provincia existente (integridad con la tabla de referencia). Cada validación devuelve 400 con mensaje en español.
- **¿Por qué 201 y no 200 en el alta?** — 201 significa «se creó un recurso nuevo» y viaja con la URL del recurso; 200 solo dice «ok».
- **¿Por qué el DELETE puede responder 400?** — Regla de negocio del trabajo: no se da de baja a un paciente con ingresos registrados; la baja de un paciente sin ingresos responde 204, y la de uno inexistente 404.

### Requisito (e) — dato sucio

- **¿Qué dato sucio eligieron y cómo lo detectaron?** — Altas anteriores a la fecha de ingreso (caso real del dataset: `'1971-01-05'`); se detecta comparando las fechas ISO como texto, que se comparan en orden cronológico por su formato.
- **¿Por qué no se «corrige» la base?** — El curso trata la base como fuente de datos real: la API la detecta, la expone y la explica; corregirla no corresponde y esconderla sería ocultar un problema real.
- **¿Qué otros datos sucios vieron en la base?** — Esperable: ciudades `NULL`, diagnósticos con errores de tipeo (`Amigima`, `Stomache Pain`), ingresos sin fecha de alta (pacientes aún internados).

### Requisito (f) — README

- **¿Qué tiene que poder hacer alguien con solo el README?** — Clonar el repo, entrar a `trabajo-final`, correr la API con el SDK de .NET 6 y probar cada endpoint con los curl de la tabla.
- **¿Por qué la tabla tiene una columna de estado?** — Convierte al README en el tablero del trabajo: muestra qué está listo y qué no, y en la defensa documenta la honestidad del proceso.

### Transversales (cualquier requisito)

- **¿Por qué los ids son `long`?** — SQLite entrega enteros como `long`; mapear un id a `int` rompe Dapper con un 500.
- **¿Por qué las fechas son `string`?** — Viajan como texto ISO `yyyy-MM-dd` desde SQLite; el cálculo (estadía, edad) se hace recién en la consulta o al presentar, no en el record.
- **¿Qué hace `using var connection ...`?** — Abre la conexión por pedido y la cierra sola al salir del handler.
- **¿Qué flujo siguió el feature que programaste?** — Issue con criterios → rama `feature/...` → commits `(#N)` → push → PR con `Closes #N` → revisión con checklist → merge a `main` protegida.
- **¿Qué significa que `main` esté protegida?** — GitHub rechaza push directo y exige PR con una aprobación: nadie integra sin revisión.

## 4. Rúbrica anticipada (criterios de corrección)

Bloques de observación compartidos con el grupo en el encuentro 31 y aplicados en el encuentro 32. El instrumento con calificaciones y las versiones A/B de la verificación práctica viven en los documentos `evaluacion-u4*.md` de la unidad; esta rúbrica anticipa los criterios.

| Bloque | Criterio | Logrado | En proceso | No logrado |
| --- | --- | --- | --- | --- |
| Entrega | Repositorio empujado, `main` completa, clon fresco corre con el README | Todo funciona desde cero | Corre con ayuda puntual | No corre desde clon fresco |
| Entrega | README completo con ejemplos curl probados | Tabla íntegra y verificada | Tabla con ejemplos sin probar | Tabla incompleta o falsa |
| Flujo profesional | Issues con criterios de aceptación y trazabilidad issue → rama → PR → merge | Cadena completa en la mayoría de los features | Cadena parcial o incompleta | Sin issues o sin PRs |
| Flujo profesional | Revisión entre pares y `main` protegida | PRs con aprobación ajena; sin push directo posterior a la protección | Protección activa con revisión débil | Sin revisión o sin protección |
| Requisitos a-f | Cada requisito responde según su criterio de aceptación (códigos incluidos) | Los seis cumplen | Al menos cuatro cumplen | Tres o menos cumplen |
| Requisitos a-f | Canon del código: `Program.cs` único, records al final, parametrización, `Results.*`, ids `long`, fechas `string` | Canon respetado | Desvíos menores explicables | Desvíos graves (concatenación SQL, `TypedResults`, ids `int`) |
| Defensa individual | Demo guiada por requisito con comandos preparados | Demo completa en tiempo | Demo incompleta pero razonada | Demo improvisada o fallida sin lectura del error |
| Defensa individual | Explicación del código propio y de las decisiones técnicas | Explica con el código en mano | Explica parcialmente con ayuda | No puede explicar lo que muestra |

Intervención en la defensa: ante silencio, bajar la pregunta de nivel («¿qué línea de la consulta busca las coincidencias?»); ante error no detectado por el alumno, mostrar la salida y pedir la lectura; la corrección docente nunca reemplaza el intento del alumno.

## 5. Errores esperados e intervención

| Error esperado | Intervención docente |
| --- | --- |
| El grupo «termina» con un PR sin fusionar | Inventario en primer lugar del encuentro; el docente no cierra el PR: dirige al grupo a decidir fusionar o descartar con fundamento |
| README verificado solo por quien lo escribió | Exigir la prueba del clon fresco por otro integrante; documentar el resultado |
| Demo con comandos tipeados en vivo | Ensayo con archivo propio de comandos; tipear JSON con escapes escapados en vivo es la causa más común de demo fallida |
| Todos defienden «su» requisito y nadie el grupo | Preguntas cruzadas del banco: un requisito programado por otro integrante, con el grupo presente |
| Ansiedad por la rúbrica | Recordar que los criterios son los mismos de la consigna y de las checklists de la unidad: nada de la rúbrica es nuevo |
| Issues abiertos que avergüenzan al grupo | Reencuadrar: un issue abierto explicado con precisión («falta X, lo intentamos Y») vale más que un tablero vacío y falso |
