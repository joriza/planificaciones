# Anexo docente — Encuentro 10: SQLite: primera mirada y hospital.db

> Material de uso interno docente. No se distribuye a estudiantes.
> Curso: Desarrollo de APIs con C# .NET 6 (Minimal API) · Unidad 2 — Acceso a datos: SQLite y Dapper

## Encuadre

| Campo | Detalle |
| --- | --- |
| Encuentro | 10 — «SQLite: primera mirada / Devolución de la evaluación» · «Base hospital.db / Exploración de tablas» (carácter conceptual) |
| Formato | Encuentro estándar del curso (BOPPPS + GRR), con apertura dedicada a la devolución de la evaluación de la Unidad 1 |
| Producción esperada | Cuadro de exploración completo + `consultas-e10.sql` con las semillas y las consultas del ejercicio |
| Insumos | `hospital.db` distribuido por el docente; DB Browser for SQLite instalado en las máquinas |

**Decisión didáctica (exploración):** la exploración de la base se hace **solo con DB Browser for SQLite** y no con código C#. Razones: el encuentro es conceptual (mirar antes de programar), la herramienta visual da retroalimentación inmediata sobre estructura y datos, y evita mezclar dos novedades en un mismo bloque (herramienta + paquetes + código de conexión, que es el contenido del Encuentro 11). Las semillas SQL del Paso 5 siembran el vocabulario (`SELECT`, `COUNT`, `LIMIT`, `WHERE`) que Dapper usará en el próximo encuentro. Si en algún aula no se puede instalar DB Browser, usar la versión portable (zip sin instalación) del mismo sitio oficial; como última alternativa, el ejecutable `sqlite3` en terminal.

**Verificación previa a la clase:** controlar que la copia de `hospital.db` que se distribuye coincida con los volúmenes de referencia del curso: `province_names` 13 · `doctors` 27 · `patients` 258 · `admissions` 306. Si la copia difiere, ajustar las respuestas de conteo de este anexo (la estructura de tablas y columnas es idéntica en todas las versiones).

## Gestión de la devolución de la evaluación (apertura, 30 min)

| Tramo | Tiempo | Qué hacer |
| --- | --- | --- |
| Panorama general | 10 min | En el pizarrón: resultado global del curso, los 2 o 3 errores más frecuentes y su corrección. Sin individualizar personas ni notas frente al grupo |
| Entrega individual | 10 min | Distribuir las correcciones; leer en silencio. Quien quiera, anota consultas para el tramo final |
| Consultas | 5 min | Preguntas puntuales, respuestas breves. Derivar casos complejos a la afterclass |
| Puente | 5 min | Pregunta disparadora del documento del alumno: ¿dónde siguen los datos cuando el sistema se apaga? |

Sugerencias:

- Conectar los errores frecuentes de la evaluación con lo que viene: los errores de nombres (rutas, propiedades, claves) son el mismo tipo de error que hoy se llama "mapeo por nombre" en las bases. Lo que se corrigió en tp-u1 vuelve en la Unidad 2 con otro disfraz.
- Si hay recuperatorio o instancias adicionales, anunciarlo en este tramo y no después, para no interrumpir la práctica.
- No extender la devolución más allá del bloque: el encuentro tiene contenido conceptual propio y la práctica lo necesita completo.

## Solución esperada

### Cuadro de exploración (Paso 3 y ejercicio, ítem 1)

| Tabla | Qué guarda | Columnas principales | Filas |
| --- | --- | --- | --- |
| `province_names` | Provincias y territorios de Canadá | `province_id` (TEXT), `province_name` (TEXT) | 13 |
| `doctors` | Médicos y su especialidad | `doctor_id` (INTEGER), `first_name`, `last_name`, `specialty` | 27 |
| `patients` | Pacientes: datos personales y clínicos | `patient_id` (INTEGER), `first_name`, `last_name`, `gender`, `birth_date`, `city`, `province_id`, `allergies`, `height`, `weight` | 258 |
| `admissions` | Ingresos hospitalarios | `patient_id` (INTEGER), `admission_date`, `discharge_date`, `diagnosis`, `attending_doctor_id` | 306 |

(Ajustar los conteos de `patients` y `admissions` si la copia distribuida difiere; ver verificación previa.)

### Consultas del ejercicio (ítems 2 a 4)

```sql
-- 2. Los primeros 10 ingresos
SELECT * FROM admissions LIMIT 10;

-- 3. Pacientes con alergia a Peanuts
SELECT first_name, last_name, allergies
FROM patients
WHERE allergies = 'Peanuts';

-- 4. La fila completa del medico 7
SELECT *
FROM doctors
WHERE doctor_id = 7;
```

Respuesta del ítem 4 (estable: la tabla `doctors` es idéntica en todas las copias): `Hazel Patterson`, especialidad `Oncologist`. Para el ítem 3, el conteo exacto depende de la copia de la base; aceptar cualquier listado coherente con la consulta ejecutada y pedir que informen cuántas filas obtuvieron.

### Respuesta esperada del ítem 5 (reflexión)

Con palabras propias, algo equivalente a: la base está en un archivo del disco, que persiste aunque el programa termine; la `List<T>` vive en la memoria del proceso y desaparece cuando el proceso muere. Mencionar "archivo" y "memoria" es suficiente; el término técnico "persistencia" se celebra si aparece pero no se exige.

## Criterios de logro

| # | Criterio | Evidencia observable |
| --- | --- | --- |
| 1 | Distingue memoria de persistencia | Explica por qué la `List<T>` se pierde y el `.db` no, sin leerlo del documento |
| 2 | Describe SQLite como base en un archivo | Menciona "un solo archivo", "sin servidor" o "sin instalación" con palabras propias |
| 3 | Nombra las cuatro tablas y qué guarda cada una | Cuadro de exploración completo sin copiar la fila de `province_names` (esa se completó en conjunto) |
| 4 | Ejecuta consultas y lee sus resultados | `consultas-e10.sql` guardado con las 4 semillas y las 3 consultas del ejercicio |
| 5 | Adapta una consulta existente a un objetivo nuevo | El ítem 4 usa la estructura `WHERE doctor_id = 7` derivada de las semillas, no inventada |

## Qué observar durante la práctica

- **Vocabulario:** al recorrer la pestaña de estructura, pedir que describan una tabla en voz alta usando tabla / fila / columna. Quien dice "acá hay una lista de cosas" todavía no separa planilla de registro.
- **`NULL` frente a vacío:** en `patients`, que comparen una celda de `allergies` vacía con una que dice la alergia. Preguntar: ¿"sin alergia registrada" es lo mismo que "alergia a nada"? La distinción `NULL` / valor es uno de los conceptos que más rinde en la Unidad 2.
- **Predicción antes de ejecutar:** en Ejecutar SQL, que anuncien cuántas filas creen que va a devolver cada semilla antes de apretar play. Quien acierta los conteos chicos y se sorprende con los grandes está leyendo la diferencia referencia/movimiento.
- **Datos sucios reales:** pedir que encuentren un diagnóstico cortado o mal tipeado en `admissions` y lo comenten en parejas. Objetivo: aceptar temprano que los datos reales son imperfectos (en la Unidad 2 se filtran y en unidades siguientes se limpian).
- **Copia mecánica de SQL:** quien escribe `LIMIT 5` con el teclado sin mirar qué consulta está ejecutando suele traer resultados de la semilla anterior. Pedir que expliquen qué tabla está consultando cada panel de resultados.

## Ajustes

- **Si avanza con facilidad:** desafiar con `ORDER BY` (descubierto o guiado: ordenar `doctors` por `specialty`), o pedir el conteo de ingresos de un médico en una sola consulta (`WHERE attending_doctor_id = 7`). Son avances válidos pero no se formalizan: `ORDER BY` formaliza en la segunda mitad de la unidad.
- **Si se traba:** volver al Paso 3 y leer junto a la pestaña Estructura los nombres exactos de tabla y columnas; casi todos los errores del encuentro se resuelven leyendo ese listado. Para el ítem 4 del ejercicio, mostrar cuál de las semillas es la más parecida (la de Penicillin) y qué dos partes hay que cambiar.
- **Señales de alerta:** un cuadro de exploración con columnas inventadas (no copiadas de la pestaña Estructura); un `consultas-e10.sql` con solo las semillas y ninguna consulta propia; quien cierra DB Browser sin guardar el `.sql`.

## Recordatorio operativo

- Verificar antes del encuentro: DB Browser instalado (o portable disponible), copia de `hospital.db` lista para distribuir y volúmenes de referencia controlados (ver verificación previa).
- En los últimos minutos: confirmar que cada estudiante tenga `u2-sqlite/hospital.db` + `consultas-e10.sql` commiteados y pusheados (rutina desde el Encuentro 5): `git add .` → `git commit -m "Clase 10: primera mirada a hospital.db"` → `git push`.
