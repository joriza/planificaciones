# Evaluación del momento de intensificación y fortalecimiento 34-35 — Recuperación y profundización de las Unidades 3 y 4

> Evaluación del Encuentro 35 (bloque 2) — Momento de intensificación y fortalecimiento «Recuperación y profundización de las Unidades 3 y 4». Curso: Minimal API con C# .NET 6. Este documento se entrega junto con la versión asignada (A o B). Leerlo completo antes de comenzar.

## 1. Identificación

| Campo | Detalle |
| --- | --- |
| Instancia | Encuentro 35 — bloque 2 del momento de intensificación y fortalecimiento 34-35 |
| Momento | Recuperación y profundización de las Unidades 3 y 4, tras el cierre del cuatrimestre 2 |
| Destinatarios | Todos los estudiantes presentes en el momento de intensificación y fortalecimiento, cualquiera sea su pista (recuperación o profundización) |
| Alcance | Núcleos de las Unidades 3 y 4 (tabla de la sección 2) |
| Modalidad | Ejercicio práctico individual con computadora sobre `hospital.db` (Parte 1) + flujo issue → rama → pull request en el repositorio del grupo (Parte 2) |
| Duración | 90 minutos de resolución (bloque 2); la revisión de los pull requests y el registro ocurren en la plenaria de cierre |
| Criterio de resultado | Apto / No apto aún por objetivo mínimo (sin puntaje numérico) |
| Uso de celular | No permitido |
| Material consultable | Solo el provisto con la prueba: enunciado, esqueleto de `Program.cs`, snippet con defecto para la Parte 2 y columnas de las tablas |

## 2. Alcance

| Unidad | Incluye | Excluye |
| --- | --- | --- |
| Unidad 3 | JOIN de tres tablas con record compuesto y 404 de existencia, estadística con GROUP BY (COUNT/AVG con tipos correctos), detección de casos límite sin 500 | Subconsultas como requisito del ejercicio, sprint de publicación (OM4 se acredita con la evidencia de los bloques del momento) |
| Unidad 4 | Flujo profesional completo: issue con criterios de aceptación, rama `feature/<tema>`, commits `(#N)`, push y pull request abierto sin fusionar | Defensa del trabajo integrador; README de portada como requisito del ejercicio (OM6 se acredita con la evidencia del repositorio al cierre del momento) |

## 3. Objetivos mínimos y criterio Apto / No apto aún

La prueba observa los seis objetivos mínimos del momento de intensificación y fortalecimiento. Cada objetivo se registra **Apto** o **No apto aún**; no hay puntaje numérico. El resultado es aún provisorio: los objetivos No apto aún se retoman en las instancias de intensificación posteriores a la cursada (diciembre y, de ser necesario, marzo). OM1, OM2 y OM5 se observan directamente en el ejercicio; OM3 se observa en el ejercicio y se completa con la evidencia de los bloques; OM4 y OM6 se acreditan con la evidencia de los bloques y del repositorio al cierre del Encuentro 35.

| Nº | Objetivo mínimo | Unidad | Dónde se observa | Criterio de Apto |
| --- | --- | --- | --- | --- |
| OM1 | JOIN triple: endpoints con JOIN de tres tablas (`admissions` + `patients` + `doctors`), con alias `AS` por columna, record compuesto y verificación de existencia con 404 | U3 | Versión A, Parte 1 | El `ON` empareja las claves correctas; el record compuesto se serializa a JSON; un id inexistente responde `404` con mensaje sin ejecutar la consulta principal |
| OM2 | Estadística con GROUP BY: agrupar con GROUP BY y COUNT/AVG sobre `patients` + `province_names`, con conteo en `int`, promedio con ROUND en `double` y orden por el agregado | U3 | Versión B, Parte 1 | La consulta agrupa por la columna correcta; los tipos del record son correctos; un código inexistente responde `404` con mensaje |
| OM3 | Dato sucio y manejo de errores: casos límite sin 500, con validación manual y mensajes en español; detección documentada del defecto | U3 | Parte 1 y Parte 2 (ambas versiones) + bloques del momento | Los casos límite responden `404` o mensaje en español, nunca `500`; el defecto queda detectado, documentado en el issue con criterios y corregido con prueba |
| OM4 | Configuración y publicación: cadena de conexión en `appsettings.json`, `dotnet publish` y corrida en release | U3 | Bloques del momento (guía del Encuentro 34, commit y corrida observada) | La API corre desde el binario publicado apuntando a la misma base; el commit de evidencia queda en el repositorio |
| OM5 | Flujo profesional: issue con criterios de aceptación, rama `feature/<tema>`, commits `(#N)`, push, pull request abierto y `main` protegida | U4 | Parte 2 (ambas versiones) | La secuencia completa queda visible en GitHub, con criterios verificables en el issue y el PR abierto sin fusionar |
| OM6 | README de portada: descripción del proyecto, integrantes y tabla de endpoints con sus códigos de respuesta | U4 | Repositorio del grupo al cierre del Encuentro 35 | El README existe, refleja el trabajo final y su tabla de endpoints está actualizada |

## 4. Estructura del ejercicio

Ejercicio pequeño en dos partes: un endpoint sobre `hospital.db` y el arreglo de un defecto con el flujo profesional. Tiempo sugerido de resolución: Parte 1, 45 min · Parte 2, 35 min · cierre, 10 min.

| Parte | Contenido | Objetivos observados | Tiempo |
| --- | --- | --- | --- |
| Parte 1 | Endpoint sobre `hospital.db`: versión A, JOIN triple sobre `admissions` + `patients` + `doctors`; versión B, estadística con GROUP BY sobre `patients` + `province_names`. Ambas con verificación de existencia y `404` con mensaje | Versión A: OM1 · Versión B: OM2 · ambas: OM3 | 45 min |
| Parte 2 | Sobre el repositorio del grupo: issue con criterios de aceptación para el defecto provisto, rama `feature/fix-eval-<inicial>`, arreglo del snippet, commits que referencian el issue, push y pull request abierto (sin fusionar) | OM5, OM3 | 35 min |
| Cierre | Pruebas finales, guardado del `Program.cs` de la Parte 1 en la carpeta indicada de la máquina y aviso al docente; el pull request queda abierto para la revisión docente | — | 10 min |

## 5. Condiciones de resolución

- Resolución estrictamente individual, con computadora.
- Sin celular en ningún momento del encuentro.
- Material consultable: únicamente el provisto con la prueba. No se consultan apuntes, repos propios, la web ni material de clases anteriores; las convenciones del curso y los comandos de git son de memoria.
- Parte 1: el alumno crea el proyecto con `dotnet new web`, reemplaza el `Program.cs` por el esqueleto, agrega los paquetes con `dotnet add package`, copia `hospital.db` junto al `.csproj` y solo agrega el endpoint pedido: los records provistos no se modifican.
- Parte 2: se trabaja sobre el repositorio del grupo en GitHub, en la carpeta `intensificaciones-34-35/`, con el archivo `defecto-<inicial>.cs` (copia del snippet provisto) corregido dentro de la rama. Cada alumno crea su propio issue, su propia rama y su propio pull request.
- `main` está protegida: el pull request **no se fusiona**; queda abierto para la revisión del docente, que es la devolución escrita del flujo profesional.
- Convenciones obligatorias del curso: rutas en inglés y plural, ids `long`, fechas `string` ISO, respuestas siempre con `Results` (nunca `TypedResults` ni el objeto crudo), consultas siempre parametrizadas, alias `AS` de `snake_case` a `PascalCase`, records al final del archivo y comentarios en español sin tildes.
- El tiempo agotado no invalida la prueba: se registra la evidencia parcial alcanzada, objetivo por objetivo.

## 6. Regla de equivalencia entre las versiones A y B

- **Misma estructura:** mismas partes, mismos tiempos, mismos objetivos mínimos observados y mismas reglas de resolución; el criterio de Apto es idéntico en ambas.
- **Distinto dominio y distinto núcleo central en la Parte 1:** la versión A evalúa el JOIN triple (ingresos con médico y paciente, tablas `admissions` + `patients` + `doctors`); la versión B la estadística con GROUP BY (pacientes por provincia, tablas `patients` + `province_names`). Ambas con verificación de existencia y `404` con mensaje.
- **Defecto equivalente en la Parte 2:** en la versión A el defecto es de tipo (`int` en lugar de `long` para el id del paciente, que produce 500); en la versión B es de seguridad (SQL concatenado con el dato recibido, en lugar de consulta parametrizada). Ambos son defectos canónicos del curso con síntoma observable, documentados y corregidos con el mismo flujo issue → rama → PR.
- El propósito de la equivalencia es que la versión asignada no otorgue ventaja ni habilite la copia entre compañeros.

## 7. Mecánica de asignación de versiones

- La versión (A o B) se asigna por posición en el aula, según lo defina el docente al iniciar la prueba (por ejemplo, filas alternadas de máquinas).
- La asignación se comunica al comenzar y se registra en la planilla de resultados (alumno → condición → versión → resultado por objetivo).
- La prueba es individual: alumnos del mismo grupo de trabajo pueden tener versiones distintas; la Parte 2 usa el repositorio del grupo, pero cada alumno aporta su issue, su rama y su pull request propios.

## 8. Registro del resultado y devolución

- El docente registra, para cada estudiante, la versión rendida y el resultado **Apto / No apto aún** de cada objetivo mínimo (OM1 a OM6), en registro docente formal.
- El registro y la comunicación individual del resultado preliminar ocurren en la plenaria de cierre del Encuentro 35.
- El resultado del momento es aún provisorio: acredita los objetivos alcanzados a la fecha y deja registrado qué continúa pendiente. No recalifica las evaluaciones del año.
- La revisión de cada pull request de la Parte 2, con su comentario del docente, es la devolución escrita del flujo profesional.
- Los objetivos que quedan No apto aún se retoman en la instancia de intensificación de diciembre (y, de ser necesario, en la de marzo).
