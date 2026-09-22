# Encuentro 25 — Cierre U3: repaso y TP

> Unidad 3 — CRUD completo con Dapper · Encuentro de cierre de unidad

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 25 de 36 |
| Unidad | 3 — CRUD completo con Dapper |
| Eje temático | 5 — CRUD con Dapper |
| Carácter/Objetivo | Actitudinal |
| Estructura | cierre |
| Duración teórica | 240 minutos (4 horas reloj) |
| TP obligatorio | TP-U3: CRUD completo |
| Concepto nuevo | Cierre U3: repaso y TP |
| Requisitos previos | Encuentros 21-24: INSERT, DELETE, UPDATE, CRUD completo y JOIN triple |
| Uso de celular | No permitido |
| Organización del trabajo | Grupos de 3-4 integrantes (presentes ÷ equipos disponibles) |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y motivación | 20 min |
| Desarrollo teórico-práctico | 120 min |
| Consolidación y cierre | 20 min |
| Actividad complementaria | 80 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

1. Repasar los cuatro endpoints CRUD y la diferencia entre los códigos HTTP de cada operación.
2. Explicar por qué se usa `ExecuteScalar<long>` para INSERT y `Execute` para UPDATE/DELETE.
3. Describir cómo funciona un JOIN de 3 tablas y por qué se usan alias `AS`.
4. Entregar el TP-U3 en GitHub con la estructura de carpetas correcta.

## 3. Apertura y motivación (20 min)

### Charla rápida: analogía breve que ancle el concepto

Repasamos la unidad completa como si fuera el menú completo de un restaurante. El GET es la carta, el POST es el pedido nuevo, el PUT es la modificación y el DELETE es la cancelación. El JOIN de 3 tablas es como pedir un plato que viene con todos los ingredientes listados juntos. Hoy cerramos la unidad y entregamos el trabajo práctico.

### Lo mínimo indispensable

La unidad cubrió las cuatro operaciones CRUD con Dapper en Minimal API. Cada operación tiene su método Dapper canónico (`Query<T>`, `ExecuteScalar<long>`, `Execute`) y su código HTTP correspondiente (`200`, `201`, `204`, `400`, `404`). El TP-U3 integra todo lo aprendido en un repositorio de grupo con commits organizados.

## 4. Desarrollo teórico-práctico (120 min)

### Paso 1 — Repaso rápido de los 4 endpoints

| Operación | Método Dapper | Código HTTP | Endpoint |
| --- | --- | --- | --- |
| GET (listar) | `Query<T>` | 200 | `MapGet` |
| GET (uno) | `QueryFirstOrDefault<T>` | 200 o 404 | `MapGet` |
| POST (crear) | `ExecuteScalar<long>` | 201 | `MapPost` |
| PUT (actualizar) | `Execute` | 204 o 404 | `MapPut` |
| DELETE (borrar) | `Execute` | 204 o 404 | `MapDelete` |

### Paso 2 — Repaso del JOIN de 3 tablas

El JOIN de 3 tablas une `admissions` con `patients` y `doctors`. Cada columna del SELECT necesita alias `AS` que coincida con el nombre del parámetro del record. Los campos calculados (como `PatientName` con `||`) se aliasean con `AS`.

### Paso 3 — Entrega del TP-U3 en GitHub

La entrega del TP-U3 se realiza de la siguiente manera:

1. Cada grupo crea una carpeta `tp-u3/` en su repositorio de grupo.
2. Dentro de `tp-u3/` se incluye el `Program.cs` con los cuatro endpoints CRUD completos y al menos un endpoint con JOIN de 3 tablas.
3. Se hace commit con el mensaje: `tp-u3: crud completo con join de 3 tablas` (español, minúsculas tras los dos puntos, sin tildes).
4. Se hace push al repositorio remoto.

**Tamaño de grupos**: presentes ÷ equipos disponibles. Si hay 12 presentes y 3 equipos disponibles, cada grupo tiene 4 integrantes. La distribución se ajusta según la cantidad de equipos disponibles en el aula.

### Paso 4 — Verificación de la entrega

El docente verifica que cada grupo tenga:
- La carpeta `tp-u3/` en la rama `main` del repositorio.
- Un `Program.cs` que compile y corra contra `hospital.db`.
- Los cuatro endpoints CRUD funcionales.
- Al menos un endpoint con JOIN de 3 tablas.
- Un `.gitignore` en la raíz con `bin/` y `obj/`.

## 5. Consolidación y cierre (20 min)

### Qué te llevás

- Los cuatro endpoints CRUD se implementan con Dapper usando `Query<T>`, `ExecuteScalar<long>` y `Execute`.
- Los códigos HTTP canónicos son: `200` (lectura), `201` (alta), `204` (actualización/borrado), `400` (dato faltante), `404` (recurso inexistente).
- El JOIN de 3 tablas usa `JOIN ... ON` con alias `AS` para cada columna del SELECT.
- La entrega del TP-U3 es en la carpeta `tp-u3/` del repositorio de grupo, con commit y push a `main`.
- Los grupos se forman con presentes ÷ equipos disponibles.

## Lo que viene

Encuentro 26: Evaluación de la Unidad 3. Cada alumno defenderá individualmente su implementación del TP-U3.
