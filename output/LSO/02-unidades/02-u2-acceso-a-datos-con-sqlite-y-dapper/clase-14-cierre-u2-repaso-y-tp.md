# Encuentro 14 — Cierre U2: repaso y TP

> Acceso a datos con SQLite y Dapper

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 14 de 36 |
| Unidad | 2 — Acceso a datos con SQLite y Dapper |
| Eje temático | 4 — Dapper y consultas parametrizadas |
| Carácter/Objetivo | Actitudinal |
| Estructura | cierre |
| Duración teórica | 240 minutos (4 horas reloj) |
| Concepto nuevo | Cierre U2: repaso y TP |
| Requisitos previos | Haber completado los encuentros 10 a 13; tener el TP-U2 en desarrollo. |
| Uso de celular | No permitido |
| Organización del trabajo | Grupos de trabajo según la distribución de equipos disponibles; cada grupo entrega en su carpeta `tp-u2/` del repositorio. |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y motivación | 20 min |
| Desarrollo teórico-práctico | 120 min |
| Consolidación y cierre | 20 min |
| Actividad complementaria | 80 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

1. Sistematizar los conceptos clave de la unidad: SQLite, Dapper, JOIN, parámetros y LIKE.
2. Revisar los patrones canónicos del curso: tipos de mapeo, alias `AS`, consultas parametrizadas.
3. Completar y entregar el TP-U2 en el repositorio del grupo.
4. Prepararse para la entrega y defensa individual de la Unidad 2.

## 3. Apertura y motivación (20 min)

### Sistematización de conceptos U2

El docente guía un repaso oral de los conceptos trabajados en los encuentros 10 a 13. Se pide a cada grupo que enumere en una pizarra los puntos clave:

- SQLite es una base de datos en un solo archivo `.db`.
- La cadena de conexión es `"Data Source=hospital.db"`.
- Dapper transforma filas SQL en objetos C# con `Query<T>` y `QueryFirstOrDefault<T>`.
- Los tipos canónicos: INTEGER → `long`, TEXT → `string`, nullable → `?`.
- Siempre se usa alias `AS` en el SELECT.
- Las consultas son siempre parametrizadas con `@param` y `new { param }`.
- `LIKE` permite búsquedas parciales con comodines `%`.
- Los endpoints devuelven `Results.Ok(...)`, `Results.NotFound(...)`, etc.
- Los records van después de `app.Run();`.

### Introducción al TP-U2

El docente presenta el TP-U2 y aclara que es la instancia de cierre de la unidad. Se explica el ciclo de entrega: nueva carpeta `tp-u2/` en el repositorio del grupo, commits con mensajes claros y push al remoto.

## 4. Desarrollo teórico-práctico (120 min)

### Repaso: recorrido por los 4 encuentros

El docente recorre brevemente cada encuentro y pide que los alumnos identifiquen el concepto central y un ejemplo de código:

| Encuentro | Concepto central | Método Dapper clave |
| --- | --- | --- |
| 10 | SELECT simple desde SQLite | `Query<T>`, `QueryFirstOrDefault<T>` |
| 11 | JOIN entre 2 tablas, ORDER BY, LIMIT | `Query<T>` con JOIN |
| 12 | Mapeo con alias `AS`, tipos canónicos | `Query<T>`, `QueryFirstOrDefault<T>` |
| 13 | Parámetros y LIKE | `Query<T>` con `new { ... }` |

### Trabajo en grupo: TP-U2

Cada grupo trabaja en su carpeta `tp-u2/` del repositorio. El TP-U2 consiste en crear una Minimal API que conecte a `hospital.db` y exponga endpoints que demuestren los conceptos de la unidad.

**Estructura esperada del TP-U2:**

```
tp-u2/
├── Program.cs          — único archivo de código
├── hospital.db         — copia de la base de datos
├── tp-u2.csproj        — proyecto .NET 6
└── .gitignore          — con bin/ y obj/
```

**Endpoints mínimos del TP-U2:**

1. `GET /patients` — lista todos los pacientes.
2. `GET /patients/{id:long}` — un paciente por ID.
3. `GET /patients-with-province` — pacientes con el nombre de su provincia (JOIN).
4. `GET /patients/search?name=...` — búsqueda parcial por nombre (LIKE).
5. `GET /doctors` — lista todos los médicos.
6. `GET /doctors/by-specialty?specialty=...` — médicos por especialidad (LIKE).

**Ciclo de entrega:**

```bash
# Crear la carpeta tp-u2 en el repositorio del grupo
mkdir tp-u2
# Copiar los archivos del proyecto a tp-u2/
# Agregar hospital.db al .gitignore si no se debe commitear
# O copiarlo si el profesor lo requiere

# Commit y push
git add .
git commit -m "tp-u2: entrega tp u2 sqlite y dapper basico"
git push
```

**Reglas de entrega:**
- La carpeta `tp-u2/` debe estar en la rama `main` del repositorio del grupo.
- El commit debe tener un mensaje en español, minúsculas después de los dos puntos, sin tildes.
- El proyecto debe compilar y ejecutar sin errores.
- Todos los endpoints deben devolver datos correctos contra `hospital.db`.

## 5. Consolidación y cierre (20 min)

### Qué te llevás

- SQLite guarda toda la base en un solo archivo y se conecta con `"Data Source=hospital.db"`.
- Dapper mapea filas SQL a objetos C# con `Query<T>` y `QueryFirstOrDefault<T>`.
- Los alias `AS` son obligatorios para que los nombres de columna coincidan con los del record.
- Los tipos canónicos son: INTEGER → `long`, TEXT → `string`, nullable → `?`.
- Las consultas son siempre parametrizadas con `@param` y `new { param }`.
- `LIKE` con comodines `%` permite búsquedas parciales.
- El TP-U2 se entrega en la carpeta `tp-u2/` del repositorio con commits y push.

### Lo que viene

Encuentro 15: Evaluación de la Unidad 2 — entrega y defensa individual del TP-U2.

## 6. Actividad complementaria (80 min)

### Trabajo de TP-U2 y preparación para la evaluación

En esta actividad los grupos trabajan en la finalización y entrega del TP-U2.

**Paso 1 — Finalizar el TP-U2 (40 min):**
1. Completar todos los endpoints mínimos del TP-U2.
2. Probar cada endpoint contra `hospital.db` y verificar que los datos sean correctos.
3. Revisar que el proyecto compile sin errores ni advertencias.
4. Verificar que los records usen los tipos canónicos (`long` para INTEGER, `string?` para nullable).

**Paso 2 — Preparar la entrega (20 min):**
1. Crear la carpeta `tp-u2/` en el repositorio del grupo.
2. Copiar los archivos del proyecto a `tp-u2/`.
3. Hacer `git add .`, `git commit` y `git push`.
4. Verificar que el push llegó al remoto.

**Paso 3 — Preparación para la defensa individual (20 min):**
1. Cada alumno debe poder explicar en voz alta qué hace cada endpoint.
2. Cada alumno debe poder explicar por qué se usa `long` y no `int` para los IDs.
3. Cada alumno debe poder explicar por qué se usan alias `AS` en el SELECT.
4. Cada alumno debe poder explicar la diferencia entre concatenar un valor en el SQL y usar un parámetro.

## 7. Errores comunes y trampas

| Error observable | Causa probable | Cómo intervenir |
| --- | --- | --- |
| El proyecto no compila | Falta `using Dapper;` o `using Microsoft.Data.Sqlite;`. | Verificar que los `using` están al inicio del archivo. |
| `InvalidOperationException` al ejecutar un endpoint | El record usa `int` en vez de `long` para una columna INTEGER. | Indicar que SQLite INTEGER siempre devuelve `Int64` (long). |
| El endpoint devuelve una lista vacía | `hospital.db` no está en la carpeta correcta del proyecto. | Verificar que `hospital.db` esté en la raíz del proyecto y que la cadena de conexión sea `"Data Source=hospital.db"`. |
| CS8803 al compilar | El record está declarado antes de `app.Run()`. | Mover el record para que quede después de `app.Run();`. |
| El commit no se hace | Falta `git add .` antes del commit. | Recordar la secuencia: `git add .` → `git commit -m "..."` → `git push`. |
| El mensaje del commit tiene tildes o mayúsculas | No se siguió la convención del curso. | Indicar que los mensajes deben estar en minúsculas después de los dos puntos y sin tildes. |
