# Evaluación del momento especial 17-18 — Recuperación y profundización de las Unidades 1 y 2

> Evaluación del Encuentro 18 (bloque 2) — Momento especial «Recuperación y profundización de las Unidades 1 y 2 (primera instancia)». Curso: Minimal API con C# .NET 6. Este documento se entrega junto con la versión asignada (A o B). Leerlo completo antes de comenzar.

## 1. Identificación

| Campo | Detalle |
| --- | --- |
| Instancia | Encuentro 18 — bloque 2 del momento especial 17-18 |
| Momento | Recuperación y profundización de las Unidades 1 y 2 (primera instancia), tras el cierre del cuatrimestre 1 |
| Destinatarios | Todos los estudiantes presentes en el momento especial, cualquiera sea su pista (recuperación o profundización) |
| Alcance | Núcleos de las Unidades 1 y 2 (tabla de la sección 3) |
| Modalidad | Prueba práctica individual con computadora sobre `hospital.db` + entrega por GitHub |
| Duración | 90 minutos de resolución (bloque 2) + 15 minutos de entrega por GitHub al inicio del plenario de cierre |
| Criterio de resultado | Apto / No apto aún por objetivo mínimo (sin puntaje numérico) |
| Uso de celular | No permitido |
| Material consultable | Solo el provisto con la prueba: enunciado, esqueleto de `Program.cs` y columnas de las tablas |

## 2. Alcance

| Unidad | Incluye | Excluye |
| --- | --- | --- |
| Unidad 1 | Crear y correr el proyecto, endpoint con parámetro de ruta, verbos y códigos con `Results`, ciclo de entrega GitHub | Nada queda excluido de los núcleos listados |
| Unidad 2 | Conexión a `hospital.db`, SELECT/WHERE/LIKE parametrizado con alias, JOIN de dos tablas con record compuesto, escritura validada (INSERT, 201/400) | JOIN de tres tablas, agregaciones completas y GROUP BY, subconsultas, datos sucios, configuración y publicación (Unidad 3); flujo profesional del repositorio (Unidad 4) |

## 3. Objetivos mínimos y criterio Apto / No apto aún

La prueba evalúa los siete objetivos mínimos del momento especial. Cada objetivo se registra **Apto** o **No apto aún**; no hay puntaje numérico. El resultado es aún provisorio: los objetivos No apto aún se retoman en las instancias de intensificación posteriores a la cursada (diciembre y, de ser necesario, marzo).

| Nº | Objetivo mínimo | Unidad | Criterio de Apto |
| --- | --- | --- | --- |
| OM1 | Crear y correr la API: crear el proyecto con `dotnet new web`, agregar los paquetes de acceso a datos, copiar `hospital.db` junto al `.csproj`, correr con `dotnet run` y probar un endpoint en el navegador | U1 | El proyecto compila, corre y responde; se probó al menos un GET en el navegador y la API se detuvo con `Ctrl+C` |
| OM2 | Endpoint con parámetro: escribir `GET .../{id:long}` con el parámetro tipado `long` que responda `200` con el recurso o `404` con mensaje si no existe | U1 | La ruta lleva la restricción `{id:long}`; ambos casos (existente e inexistente) responden con el código correcto |
| OM3 | Verbos y códigos de respuesta: usar `Results` explícito con el código correcto en cada caso (200, 201, 400, 404) y mensajes en español | U1 | Ninguna respuesta devuelve el objeto crudo; los `400` y `404` llevan cuerpo con `mensaje` |
| OM4 | SELECT/WHERE/LIKE con Dapper: conexión con `using` dentro del handler, consulta parametrizada, alias `AS` para las columnas `snake_case` y búsqueda parcial con `LIKE` | U2 | La consulta nunca concatena el SQL con datos recibidos; el patrón del `LIKE` viaja por parámetro |
| OM5 | JOIN de dos tablas: consulta con `JOIN ... ON` mapeada a un record compuesto con columnas de ambas tablas | U2 | El `ON` empareja las claves correctas; el record compuesto se serializa a JSON con la respuesta `200` |
| OM6 | Escritura validada: alta con `POST` que valida los campos obligatorios (400 con mensaje), inserta con INSERT parametrizado y responde `201` con la URL del recurso nuevo | U2 | La validación corre antes de consultar la base; el id generado se obtiene con `ExecuteScalar<long>` |
| OM7 | Ciclo de entrega GitHub: entregar en la carpeta del trabajo dentro del repositorio del grupo, con commits referentes y push | U1 | El push queda visible en GitHub con al menos un commit por ítem trabajado |

## 4. Estructura de la prueba

Ejercicio pequeño sobre `hospital.db`: una API con cuatro endpoints y su entrega por GitHub. Tiempo sugerido de resolución: Ítem 1, 15 min · Ítem 2, 15 min · Ítem 3, 20 min · Ítem 4, 15 min · Ítem 5, 20 min · revisión final, 5 min.

| Ítem | Contenido | Objetivos observados |
| --- | --- | --- |
| 1 | Preparar el proyecto: crear con `dotnet new web`, agregar paquetes, copiar la base, correr y probar en el navegador | OM1 |
| 2 | `GET` por id con `200`/`404` | OM2, OM3 |
| 3 | Búsqueda parcial con `LIKE` por query string, con validación del texto vacío (`400`) | OM4, OM3 |
| 4 | Consulta con `JOIN` de dos tablas mapeada a record compuesto | OM5 |
| 5 | Alta con `POST`: validación (`400`), INSERT parametrizado y `201` con URL | OM6, OM3 |
| 6 | Entrega por GitHub: carpeta del trabajo, commits referentes y push | OM7 |

## 5. Condiciones de resolución

- Resolución estrictamente individual, con computadora.
- Sin celular en ningún momento del encuentro.
- Material consultable: únicamente el provisto con la prueba. No se consultan apuntes, repos propios, la web ni material de clases anteriores.
- La prueba provee el archivo `Program.cs` de esqueleto (con los `using`, la cadena de conexión y los records) y la hoja con las columnas de las tablas. El alumno crea el proyecto con `dotnet new web`, reemplaza el `Program.cs` por el esqueleto, agrega los paquetes con `dotnet add package`, copia `hospital.db` junto al `.csproj` y solo agrega los endpoints pedidos: los records provistos no se modifican.
- Convenciones obligatorias del curso: rutas en inglés y plural, ids `long`, fechas `string` ISO, respuestas siempre con `Results` (nunca el objeto crudo), consultas siempre parametrizadas, comentarios en el código.
- Entrega: al finalizar el bloque 2 (o al agotarse el tiempo), el trabajo se sube al repositorio del grupo en la carpeta `especial-17-18/`, con commits referentes y push. El tiempo agotado no invalida la prueba: se registra la evidencia parcial alcanzada, objetivo por objetivo.

## 6. Regla de equivalencia entre las versiones A y B

- **Misma estructura:** mismos ítems, mismos objetivos mínimos observados ítem por ítem, mismas reglas de resolución y misma cantidad de endpoints y consultas.
- **Distinto dominio:** la versión A trabaja sobre médicos y especialidades (tablas `doctors` y `admissions`); la versión B sobre pacientes y ciudades (tablas `patients` y `admissions`).
- **Puntaje de objetivos idéntico:** cada ítem observa los mismos objetivos en ambas versiones (tabla de la sección 4) con el mismo criterio de Apto; la única diferencia admitida es la cantidad de campos obligatorios que fija cada tabla (tres columnas obligatorias en `doctors`, cinco en `patients`): la regla validada es idéntica (campos obligatorios no vacíos).
- El propósito de la equivalencia es que la versión asignada no otorgue ventaja ni habilite la copia entre compañeros.

## 7. Mecánica de asignación de versiones

- La versión (A o B) se asigna por posición en el aula, según lo defina el docente al iniciar la prueba (por ejemplo, filas alternadas de máquinas).
- La asignación se comunica al comenzar y se registra en la planilla de resultados (alumno → versión).
- La prueba es individual: alumnos del mismo grupo de trabajo pueden tener versiones distintas; eso no afecta la prueba ni el grupo.

## 8. Registro del resultado y devolución

- El docente registra, para cada estudiante, la versión rendida y el resultado **Apto / No apto aún** de cada objetivo mínimo (OM1 a OM7), en registro docente formal.
- El resultado del momento es aún provisorio: acredita los objetivos alcanzados a la fecha y deja registrado qué continúa pendiente. No recalifica las evaluaciones del cuatrimestre.
- La devolución individual escrita se entrega al inicio del Encuentro 19, junto con la apertura del proyecto puente.
- Los objetivos que quedan No apto aún se retoman en la instancia de intensificación de diciembre (y, de ser necesario, en la de marzo).
