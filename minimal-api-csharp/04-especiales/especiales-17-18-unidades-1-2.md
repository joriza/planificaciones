# Encuentros especiales 17 y 18 — Recuperación y profundización de las Unidades 1 y 2 (primera instancia)

> Momento especial diferenciado del curso **Minimal API con C# .NET 6**: dos pistas en paralelo (recuperación y profundización) con plenarias conjuntas de apertura y cierre. No imparte contenido nuevo. La evaluación del momento, en versiones A y B equivalentes, está en `evaluaciones/evaluacion-especiales-17-18.md`.

## 1. Metadatos del momento

| Campo | Detalle |
| --- | --- |
| Momento | Encuentros 17 y 18 — Recuperación y profundización de las Unidades 1 y 2 (primera instancia) |
| Cuándo | Inmediatamente después del cierre integrador del cuatrimestre 1 (Encuentro 16) |
| Duración | 2 encuentros de 240 minutos (4 horas reloj) cada uno |
| Destinatarios | Todo el curso, organizado por condición en dos pistas: **grupo de recuperación (intensificación)**, con objetivos mínimos de las Unidades 1 y 2 No apto aún según el registro del cuatrimestre (evaluaciones de los Encuentros 9, 15 y 16); **grupo de profundización (fortalecimiento)**, con los objetivos mínimos Apto |
| Requisitos | Registro de resultados del cuatrimestre completo para definir la condición de cada estudiante; VS Code y SDK de .NET 6 instalados y verificados; archivo `hospital.db` (lo distribuye el docente); repositorio de GitHub del grupo al día (tp-u1 y tp-u2) |
| Lugar de trabajo | Aula-taller del curso, una PC por grupo de trabajo |
| Uso de celular | No permitido en ningún momento de los dos encuentros |
| Registro | Resultados de la evaluación del momento en registro docente formal; materiales de las pistas en registro didáctico |
| Organización del trabajo | Grupos: alumnos presentes ÷ equipos disponibles (mínimo posible); ningún equipo queda sin usar; rotación de integrantes en cada bloque |

## 2. Acuerdo pedagógico

El acuerdo se documenta por grupo de condición. Las dos pistas trabajan los **mismos núcleos de las Unidades 1 y 2**: ninguna pista adelanta contenidos de las Unidades 3 y 4.

### Grupo de recuperación (intensificación)

| Componente | Acuerdo |
| --- | --- |
| Contenidos mínimos irrenunciables | **Unidad 1:** crear y correr la API (`dotnet new web`, anatomía de `Program.cs`, `dotnet run`, probar en navegador); endpoint con parámetro de ruta (`{id:long}`, JSON automático, 200/404); verbos y códigos de respuesta (`Results` explícito, 201/400/404 con mensaje en español); ciclo de entrega GitHub (carpeta del trabajo, `add`, `commit`, `push`). **Unidad 2:** SELECT/WHERE/LIKE con Dapper (conexión con `using`, consulta parametrizada, alias `AS` para columnas `snake_case`); JOIN de dos tablas (`JOIN ... ON`, record compuesto); escritura validada (INSERT parametrizado con `ExecuteScalar<long>`, 201 con URL, 400 con mensaje) |
| Actividad y metodología acordada (ultra-condensada) | Repaso dirigido núcleo por núcleo con la guía condensada: ejemplo mínimo del docente, reconstrucción guiada del mismo endpoint por los alumnos y mini-ejercicio de un solo paso verificado antes de avanzar. Cada núcleo cierra con un commit referente. Batería mínima de pruebas: navegador (GET) y `curl` (POST), verificando el código de cada respuesta. Sin ejercicios combinados: un núcleo por vez hasta lograrlo |
| Recursos acordados (condensado al 25%) | Guía única de repaso con los pasos mínimos de cada núcleo (equivale a una selección de una cuarta parte del material de las clases de las Unidades 1 y 2), cuadro de referencia rápida de verbos y códigos de respuesta con `Results`, y checklist de entrega por GitHub. Sin material adicional |

### Grupo de profundización (fortalecimiento)

| Componente | Acuerdo |
| --- | --- |
| Contenidos de profundización | Ampliación sobre los contenidos regulares, sin adelantar unidades siguientes: **endpoint compuesto adicional con JOIN de dos tablas y proyección a medida** (elegir y renombrar solo las columnas necesarias de ambas tablas, con nombres concatenados en SQL); **validaciones más estrictas** sobre lo ya visto (rechazar 400 con mensajes específicos según la causa: campo faltante, valor fuera de lo esperado, referencia inexistente verificada por consulta previa); **exploración de datos con GROUP BY simple como extensión** (conteo de filas por grupo, por ejemplo médicos por especialidad, siempre sobre consultas ya conocidas; sin promedios, sumas ni series por mes, que pertenecen a la Unidad 3) |
| Actividad y metodología acordada (ultra-condensada) | Hoja de desafíos graduados sobre `hospital.db`, trabajados en el repositorio del grupo con un commit referente por desafío. Cada desafío incluye su caso de prueba esperado (pedido y respuesta). Puesta en común breve al final de cada bloque: un grupo explica su solución y el resto compara enfoques |
| Recursos acordados (condensado al 25%) | Hoja de desafíos con consignas y casos de prueba (una cuarta parte del volumen habitual de material práctico), y el mismo cuadro de referencia rápida de verbos y códigos que usa la pista de recuperación. Sin material adicional |

### Condiciones comunes a las dos pistas

- Sin contenido nuevo: lo que se recupera o profundiza ya fue enseñado en los Encuentros 4 a 14.
- Plenarias conjuntas de apertura y cierre en cada encuentro; los bloques de trabajo corren en paralelo.
- Rotación de integrantes en el trabajo grupal según los presentes y los equipos disponibles.
- Uso de celular no permitido; la entrega por GitHub se hace desde el navegador de la PC del grupo.

## 3. Objetivos mínimos del momento

Esta tabla es la referencia común de las dos pistas y de la evaluación del momento (versión A/B). El criterio de logro es **Apto / No apto aún por objetivo mínimo**.

| Nº | Objetivo mínimo | Unidad | Criterio de Apto |
| --- | --- | --- | --- |
| OM1 | Crear y correr la API: crear el proyecto con `dotnet new web`, agregar los paquetes de acceso a datos, copiar `hospital.db` junto al `.csproj`, correr con `dotnet run` y probar un endpoint en el navegador | U1 | El proyecto compila, corre y responde; se probó al menos un GET en el navegador y la API se detuvo con `Ctrl+C` |
| OM2 | Endpoint con parámetro: escribir `GET .../{id:long}` con el parámetro tipado `long` que responda `200` con el recurso o `404` con mensaje si no existe | U1 | La ruta lleva la restricción `{id:long}`; ambos casos (existente e inexistente) responden con el código correcto |
| OM3 | Verbos y códigos de respuesta: usar `Results` explícito con el código correcto en cada caso (200, 201, 400, 404) y mensajes en español | U1 | Ninguna respuesta devuelve el objeto crudo; los `400` y `404` llevan cuerpo con `mensaje` |
| OM4 | SELECT/WHERE/LIKE con Dapper: conexión con `using` dentro del handler, consulta parametrizada, alias `AS` para las columnas `snake_case` y búsqueda parcial con `LIKE` | U2 | La consulta nunca concatena el SQL con datos recibidos; el patrón del `LIKE` viaja por parámetro |
| OM5 | JOIN de dos tablas: consulta con `JOIN ... ON` mapeada a un record compuesto con columnas de ambas tablas | U2 | El `ON` empareja las claves correctas; el record compuesto se serializa a JSON con la respuesta `200` |
| OM6 | Escritura validada: alta con `POST` que valida los campos obligatorios (400 con mensaje), inserta con INSERT parametrizado y responde `201` con la URL del recurso nuevo | U2 | La validación corre antes de consultar la base; el id generado se obtiene con `ExecuteScalar<long>` |
| OM7 | Ciclo de entrega GitHub: entregar en la carpeta del trabajo dentro del repositorio del grupo, con commits referentes y push | U1 | El push queda visible en GitHub con al menos un commit por ítem o núcleo trabajado |

## 4. Desarrollo del Encuentro 17

Agenda del momento especial: plenaria de apertura (20 min), bloque 1 (90 min), bloque 2 (90 min) y plenaria de cierre (40 min). Las dos pistas corren en paralelo durante los bloques.

| Bloque | Tiempo | Pista recuperación (intensificación) | Pista profundización (fortalecimiento) |
| --- | --- | --- | --- |
| Plenaria de apertura (conjunta) | 20 min | Encuadre del momento: lectura de la tabla de objetivos mínimos, condiciones de la evaluación del Encuentro 18 y conformación de las dos pistas según el registro del cuatrimestre | Misma plenaria |
| Bloque 1 (paralelo) | 90 min | Núcleos de la Unidad 1: crear y correr el proyecto (`dotnet new web`, paquetes, `dotnet run`, navegador), endpoint con parámetro (200/404) y verbos y códigos con `Results`. Reconstrucción guiada + mini-ejercicios verificados, un commit por núcleo | Desafíos 1 y 2: JOIN de dos tablas (`patients` con `province_names`) con proyección a medida del record compuesto y nombres concatenados en SQL. Un commit por desafío |
| Bloque 2 (paralelo) | 90 min | Núcleos de la Unidad 2: SELECT con alias + WHERE + LIKE parametrizado; JOIN de dos tablas (`admissions` con `doctors`); escritura validada (INSERT, 201/400). Batería mínima de pruebas con navegador y `curl` | Desafíos 3 y 4: validaciones más estrictas con mensajes específicos por causa y exploración de datos con GROUP BY simple (conteo de médicos por especialidad). Preparación de la demostración para el plenario |
| Plenaria de cierre (conjunta) | 40 min | Puesta en común: cada pista muestra un producto (un endpoint funcionando / el desafío más interesante). Registro docente de avance por objetivo mínimo y ajustes para el Encuentro 18 | Misma plenaria |

## 5. Desarrollo del Encuentro 18

Misma agenda: 20/90/90/40. Este encuentro cierra con la **evaluación del momento en versiones A y B**.

| Bloque | Tiempo | Pista recuperación (intensificación) | Pista profundización (fortalecimiento) |
| --- | --- | --- | --- |
| Plenaria de apertura (conjunta) | 20 min | Retomar el registro de avance del Encuentro 17; condiciones de la evaluación del bloque 2; preparación del ambiente de trabajo (VS Code, terminal, `hospital.db`) | Misma plenaria |
| Bloque 1 (paralelo) | 90 min | Consolidación de los núcleos con menor logro según el registro del Encuentro 17, y simulacro del formato de la prueba (un GET por id y una búsqueda, con sus casos de prueba) | Cierre de los desafíos pendientes con sus casos de prueba y ensayo de la demostración que se presenta en el plenario final |
| Bloque 2 | 90 min | **Evaluación del momento especial en versiones A y B**: prueba práctica individual con computadora sobre `hospital.db` + entrega por GitHub. Rinden todos los presentes, cualquiera sea su pista | Misma evaluación |
| Plenaria de cierre (conjunta) | 40 min | Entrega por GitHub y verificación (15 min) + plenaria conjunta de cierre del momento: balance por pista, resultado aún provisorio de Apto o No apto aún por objetivo mínimo y proyección hacia el proyecto puente (Encuentros 19 y 20) | Misma plenaria |

La devolución detallada de la evaluación se realiza al inicio del Encuentro 19, junto con la apertura del proyecto puente.

## 6. Criterios de logro del momento

| Objetivo mínimo | Apto | No apto aún |
| --- | --- | --- |
| OM1 a OM7 (tabla de la sección 3) | El estudiante cumple el criterio de Apto del objetivo en la evaluación del momento y lo sostiene en la plenaria de cierre | El objetivo queda pendiente; se retoma en las instancias de intensificación posteriores a la cursada (diciembre y, de ser necesario, marzo) |

El resultado del momento es **aún provisorio**: acredita los objetivos mínimos de las Unidades 1 y 2 alcanzados a la fecha y deja registrado, objetivo por objetivo, qué continúa pendiente. No recalifica las evaluaciones del cuatrimestre ni reemplaza al proyecto puente de los Encuentros 19 y 20.

## 7. Evaluación del momento

- La evaluación del momento especial se aplica en el **bloque 2 del Encuentro 18** (90 minutos de resolución + 15 minutos de entrega por GitHub al inicio del plenario de cierre).
- Es una prueba práctica individual con computadora sobre `hospital.db`, con **entrega por GitHub**, en **versiones A y B equivalentes**: mismos objetivos, misma estructura, mismas reglas, distinto dominio de datos.
- Criterio de resultado: **Apto / No apto aún por objetivo mínimo** (tabla de la sección 3). No hay puntaje numérico.
- Documentos: `evaluaciones/evaluacion-especiales-17-18.md` (base), `evaluaciones/evaluacion-especiales-17-18-version-a.md`, `evaluaciones/evaluacion-especiales-17-18-version-b.md` y el anexo docente con las soluciones y los criterios por objetivo.
