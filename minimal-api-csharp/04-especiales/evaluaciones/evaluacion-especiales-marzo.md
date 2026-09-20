# Evaluación del especial de marzo — Intensificación del camino mínimo

> Evaluación del momento especial de marzo (fuera de la planificación anual) · Curso: Minimal API con C# .NET 6. Este documento se entrega junto con la versión asignada (A o B). Leerlo completo antes de comenzar.

## 1. Identificación

| Campo | Detalle |
| --- | --- |
| Instancia | Especial de marzo — intensificación del camino mínimo completo |
| Momento | Marzo, antes del inicio del nuevo ciclo; segundo encuentro del momento (fuera de la estructura anual de 36 encuentros) |
| Destinatarios | Estudiantes que no alcanzaron los objetivos mínimos en diciembre y tuvieron más tiempo para prepararse |
| Alcance | Camino mínimo completo del curso: Unidades 1, 2, 3 y 4 con sus saberes transversales de git y GitHub |
| Modalidad | Ejercicio práctico individual con computadora: mini API sobre `hospital.db` con constancia en el repositorio del grupo |
| Duración | 90 minutos de resolución, dentro del encuentro de 240 minutos |
| Resultado | Apto / No apto aún, registrado objetivo por objetivo (sin puntaje numérico) |
| Uso de celular | No permitido |
| Material consultable | Solo el provisto con la prueba: enunciado, hoja de comandos, records y columnas de las tablas |

## 2. Objetivos mínimos evaluados (camino mínimo completo del curso)

Los mismos objetivos que en diciembre, con la misma evidencia esperada.

| Unidad | Objetivo mínimo | Evidencia en el ejercicio |
| --- | --- | --- |
| Unidad 1 | Crear y ejecutar una API Minimal desde la terminal; construir un endpoint con parámetro de ruta que devuelva JSON; aplicar verbos y códigos de respuesta con `Results` (200, 201, 400, 404); completar la entrega por GitHub | Ítems 1, 2, 5 y 6 |
| Unidad 2 | Consultar `hospital.db` con Dapper: SELECT parametrizado con WHERE por id; búsqueda parcial con LIKE; JOIN de dos tablas mapeado a record compuesto; escritura (INSERT) parametrizada con validación manual | Ítems 2, 3 y 5 |
| Unidad 3 | Resolver un JOIN de tres tablas; construir un reporte con COUNT y GROUP BY; tratar el dato sucio (valores NULL) sin romper la consulta | Ítem 4 |
| Unidad 4 | Documentar el trabajo con README de portada; sostener el flujo profesional del repositorio: issue, rama por feature, pull request revisado y fusión a main | Ítem 6 |

## 3. Estructura del ejercicio

Mini API sobre `hospital.db` que recorre el camino mínimo completo del curso, dejando constancia en el repositorio del grupo:

| Ítem | Consigna (resumen) | Tiempo |
| --- | --- | --- |
| 1 | Crear la mini API: proyecto nuevo, paquetes de Dapper, `hospital.db` junto al `.csproj`, API corriendo | 10 min |
| 2 | GET con parámetro de ruta: 200 con el dato o 404 con mensaje | 15 min |
| 3 | Búsqueda parcial con LIKE parametrizado, mostrando el dato relacionado de una segunda tabla (JOIN de dos tablas) | 15 min |
| 4 | Reporte con JOIN de las tres tablas, COUNT y GROUP BY, excluyendo el dato sucio (ingresos abiertos sin fecha de alta) | 25 min |
| 5 | Escritura validada: INSERT parametrizado con validación manual, 201 o 400 | 15 min |
| 6 | Constancia en el repositorio del grupo: carpeta, README breve, issue, rama por feature, pull request y main | 10 min |

## 4. Condiciones de resolución

- Resolución estrictamente individual, con computadora, sobre `hospital.db` y el repositorio del grupo.
- Sin celular en ningún momento de la prueba.
- Material consultable: únicamente el provisto con la prueba. No se consultan apuntes, repos propios, la web ni material de clases anteriores.
- Todo el código va en `Program.cs`; los records los provee la prueba y van siempre al final del archivo, después de `app.Run()`.
- Convenciones obligatorias del curso: rutas en inglés y plural, ids `long`, fechas `string` ISO, respuestas siempre con `Results` (nunca el objeto crudo), consultas siempre parametrizadas, comentarios en el código.
- El tiempo agotado no invalida la prueba: se registra la evidencia alcanzada objetivo por objetivo.

## 5. Resultado: Apto / No apto aún por objetivo mínimo

- Cada objetivo mínimo de la tabla del punto 2 se registra como **Logrado** o **No logrado aún**, según la evidencia de los ítems que lo acreditan.
- **Apto:** los cuatro objetivos mínimos quedan logrados en la prueba.
- **No apto aún:** al menos un objetivo queda sin lograr. No es una calificación final: cierra el ciclo de recuperación del curso; el resultado queda registrado y la devolución detalla los objetivos pendientes para encarar el nuevo ciclo.
- El criterio completo de registro por objetivo está en el anexo docente de esta evaluación.

## 6. Regla de equivalencia entre las versiones A y B

- Misma estructura: los seis ítems, los mismos objetivos mínimos, los mismos requisitos y los mismos tiempos ítem por ítem.
- Distinto dominio, y distinto del evaluado en diciembre: la versión A trabaja el dominio de ingresos (tablas `admissions` y `doctors`); la versión B el dominio de provincias (tablas `province_names` y `patients`). Diciembre evaluó los dominios de médicos y de pacientes: los dominios de marzo son otros para que la prueba no se pueda resolver de memoria.
- Ninguna regla que una tenga y la otra no: cambia la tabla de trabajo, no la exigencia. La validación de la escritura exige en cada versión los campos obligatorios que fija la tabla correspondiente, con la misma regla (campos obligatorios no vacíos; los ids numéricos, distintos de 0). En marzo, en las dos versiones, la clave del recurso nuevo viaja en el cuerpo del pedido, porque así lo definen las tablas del dominio (`admissions` con clave compuesta y `province_names` con clave de texto): la regla de validación y los códigos 201 y 400 son idénticos.
- El propósito de la equivalencia es que la versión asignada no otorgue ventaja ni habilite la copia entre compañeros.

## 7. Mecánica de asignación de versiones

- La versión (A o B) la asigna el docente al iniciar la prueba (por ejemplo, alternando máquinas o por lista), y se registra en la planilla (alumno → versión).
- La prueba es individual: integrantes de un mismo grupo pueden tener versiones distintas.
- La constancia del ítem 6 va en el repositorio del grupo de cada estudiante; si rinde más de un integrante del mismo grupo, cada uno trabaja en su propia subcarpeta dentro de `especial-marzo/`.

## 8. Registro y devolución

- La planilla registra: alumno, versión, objetivo mínimo por objetivo (Logrado / No logrado aún) y resultado del momento (Apto / No apto aún).
- La devolución es oral en la plenaria de cierre del segundo encuentro, objetivo por objetivo, con la evidencia observada.
- Quienes obtengan No apto aún reciben por escrito el detalle de los objetivos pendientes, para encarar el nuevo ciclo sabiendo qué reforzar.
- El estándar de marzo es idéntico al de diciembre: mismos objetivos mínimos, misma exigencia y versiones equivalentes; lo único que cambia es el tiempo de preparación que tuvo cada estudiante.
