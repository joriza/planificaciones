# Encuentro 10 — SQLite: primera mirada y hospital.db

> Unidad 2 — Acceso a datos: SQLite y Dapper

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 10 |
| Unidad | 2 — Acceso a datos: SQLite y Dapper |
| Carácter | Conceptual: primero comprender, después codificar |
| Duración teórica | 4 horas reloj (240 minutos) |
| Concepto nuevo | Qué es una base de datos, qué es SQLite, estructura y exploración de `hospital.db` |
| Requisitos previos | Unidad 1 completa y evaluada (tp-u1 del Encuentro 9); repositorio con remoto configurado y push al día |
| Uso de celular | No permitido |
| Planificación anual | Encuentro 10: «SQLite: primera mirada / Devolución de la evaluación» · «Base hospital.db / Exploración de tablas» |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura: devolución de la evaluación y puente | 30 min |
| Teoría mínima | 45 min |
| Práctica guiada | 90 min |
| Ejercicio independiente | 55 min |
| Puesta en común y cierre | 20 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

**Apertura (30 min).** El encuentro abre con la devolución de la evaluación de la Unidad 1: panorama general de los resultados del curso, los errores más frecuentes y cómo se corrige cada uno. La corrección individual se entrega al inicio y queda un espacio breve para consultas. Después, el puente hacia la unidad nueva con una pregunta disparadora: cuando el hospital cierra y el sistema se apaga, ¿dónde siguen los datos? Los pacientes, los médicos y los ingresos de una guardia real no viven en una lista dentro de un programa: viven en una base de datos. Hoy se abre esa base y se aprende a mirarla.

Al finalizar el encuentro, cada estudiante puede:

1. Explicar qué es una base de datos y qué problema resuelve frente a los datos en memoria de la Unidad 1.
2. Describir qué es SQLite y por qué se dice que la base entera es un solo archivo.
3. Identificar las cuatro tablas de `hospital.db`, qué guarda cada una y cómo se relacionan entre sí.
4. Explorar estructura y datos de una base con DB Browser for SQLite, usando sus pestañas de estructura, datos y consultas.
5. Escribir y ejecutar primeras consultas `SELECT` (conteo, listado limitado y filtro simple) sobre tablas reales.

## 3. Teoría mínima (45 min)

### Charla rápida: el archivo de historias clínicas

Todo hospital tiene un archivo físico de historias clínicas: un ambiente con estanterías, legajos numerados y planillas con formato uniforme. La guardia cierra, el edificio queda vacío, y el archivo sigue ahí: a la mañana siguiente, cualquier médico puede pedir la historia de un paciente y leerla. Nadie necesita saber cómo está construida la estantería; alcanza con pedir "la historia número 47".

Una base de datos es exactamente eso, pero digital: un lugar ordenado donde los datos viven aunque el programa esté apagado, con formatos uniformes para que cualquier programa pueda consultarlos. El programa pide datos; la base los entrega.

### De la lista en memoria a la base de datos

En la Unidad 1 los datos vivían en una `List<T>` dentro de `Program.cs`. Eso alcanzó para aprender, pero tiene límites:

| | `List<T>` en memoria (Unidad 1) | Base de datos (desde hoy) |
| --- | --- | --- |
| Dónde vive | En la memoria del programa mientras corre | En un archivo en el disco |
| Al apagar o reiniciar | Se pierde todo | Sigue ahí |
| Cómo se consulta | Con código C# | Con SQL, el idioma de las consultas |
| Quién más puede leerla | Solo ese programa | Cualquier herramienta que hable SQL |

La base de datos resuelve el problema central: la **persistencia**, que los datos sobrevivan al programa que los creó.

### SQLite: la base entera en un archivo

**SQLite** es un motor de bases de datos que no necesita instalación ni servidor: es una biblioteca que el programa incorpora, y la base completa es **un solo archivo**. En este curso ese archivo es `hospital.db`: los datos reales de un hospital canadiense (pacientes, médicos e ingresos de un año de actividad). Copiar, mover o respaldar la base equivale a copiar, mover o respaldar ese archivo. Es la opción más usada en el mundo para aplicaciones chicas y medianas (celulares, navegadores, sistemas de escritorio), y por eso arranca la unidad.

### El archivo que vamos a mirar: hospital.db

La base tiene cuatro tablas. Cada tabla es una planilla uniforme: cada **fila** es un registro (un paciente, un médico, un ingreso) y cada **columna** es un campo (el nombre, la fecha, el diagnóstico).

| Tabla | Qué guarda | Clave |
| --- | --- | --- |
| `province_names` | Provincias y territorios de Canadá: código de dos letras y nombre (datos de referencia) | `province_id` (texto) |
| `doctors` | Médicos: nombre, apellido y especialidad | `doctor_id` (entero) |
| `patients` | Pacientes: nombre, género, fecha de nacimiento, ciudad, provincia, alergias, altura y peso | `patient_id` (entero) |
| `admissions` | Ingresos hospitalarios: qué paciente, fechas de ingreso y alta, diagnóstico y médico tratante | `patient_id` + fecha de ingreso |

Las tablas se conectan entre sí por sus claves: cada paciente apunta a su provincia, y cada ingreso apunta a un paciente y a un médico.

```text
province_names ──< patients ──< admissions >── doctors
```

Para leer ese archivo se usa una herramienta visual: **DB Browser for SQLite**, que permite ver la estructura, recorrer los datos y ejecutar consultas sin escribir una línea de C#. El idioma de las consultas es **SQL**, y su verbo más usado es `SELECT`: la orden de *entregar estas columnas de esa tabla*. Hoy se usa de a poco; en el próximo encuentro la API lo hablará por nosotros.

## 4. Práctica guiada (90 min)

### Paso 1 — Preparar la carpeta del encuentro

Dentro de la carpeta del repositorio del curso, crear la subcarpeta `u2-sqlite` y copiar en ella el archivo `hospital.db` que entrega el docente. Verificar que el archivo quedó dentro de la carpeta:

```powershell
u2-sqlite
└── hospital.db
```

Abrir esa carpeta en VS Code (`File → Open Folder`).

### Paso 2 — Abrir la base con DB Browser for SQLite

Instalar (o verificar que esté instalado) **DB Browser for SQLite**: descarga gratuita desde `sqlitebrowser.org`, versión estable para Windows. Luego:

1. Abrir DB Browser.
2. Botón **Abrir base de datos** (arriba a la izquierda).
3. Buscar y abrir `u2-sqlite/hospital.db`.

La barra de título muestra la ruta del archivo abierto: la base entera es ese único `.db`.

### Paso 3 — Leer la estructura: las cuatro tablas

En la pestaña **Estructura de la base de datos** (Database Structure) aparecen las cuatro tablas. Al seleccionar cada tabla se ven sus columnas con sus tipos: `TEXT` para textos y fechas, `INTEGER` para enteros.

Completar la tercera columna del cuadro con las columnas que se observan:

| Tabla | Qué guarda | Columnas principales (se anotan observando) |
| --- | --- | --- |
| `province_names` | Provincias y territorios | |
| `doctors` | Médicos y especialidad | |
| `patients` | Pacientes: datos personales y clínicos | |
| `admissions` | Ingresos hospitalarios | |

Observación de la pestaña: la tabla `patients` apunta a `province_names` (columna `province_id`) y `admissions` apunta a `patients` y `doctors`. Las claves del diagrama de la teoría se ven en las columnas reales.

### Paso 4 — Recorrer los datos

En la pestaña **Examinar datos** (Browse Data), elegir la tabla en el desplegable superior y recorrer sus filas con las flechas de paginación. Observaciones pautadas, una por tabla:

- `province_names`: tiene 13 filas, una por provincia o territorio. Los códigos son de dos letras (`ON`, `BC`, `AB`).
- `doctors`: tiene 27 médicos. La columna `specialty` está en inglés (`Cardiologist`, `Internist`): son datos reales de un hospital canadiense.
- `patients`: hay cientos de filas. Muchas celdas de `allergies` están vacías: ese vacío en SQL se llama `NULL` (dato ausente, distinto de un texto vacío con significado). En otros pacientes la alergia está registrada (`Sulfa`, `Penicillin`).
- `admissions`: cada fila es un ingreso con fecha en formato `AAAA-MM-DD`. Hay diagnósticos cortados a mitad de palabra y con errores de tipeo: los datos reales son imperfectos y así llegan. Un mismo `patient_id` puede aparecer en varias filas: son ingresos distintos del mismo paciente.

Esta base se explora en modo solo lectura: no escribir sobre las celdas de Examinar datos.

### Paso 5 — Primeras consultas SQL

Abrir la pestaña **Ejecutar SQL** (Execute SQL), pegar estas cuatro consultas y ejecutarlas con el botón de reproducción (ícono de play). Se ejecutan en bloque y cada una deja su resultado en un panel:

```sql
-- 1. Cuantas filas tiene cada tabla
SELECT COUNT(*) FROM province_names;
SELECT COUNT(*) FROM doctors;
SELECT COUNT(*) FROM patients;
SELECT COUNT(*) FROM admissions;

-- 2. Los primeros 5 medicos
SELECT * FROM doctors LIMIT 5;

-- 3. Pacientes con alergia a Penicillin
SELECT first_name, last_name, allergies
FROM patients
WHERE allergies = 'Penicillin';

-- 4. Los ingresos atendidos por el medico 1
SELECT patient_id, admission_date, diagnosis
FROM admissions
WHERE attending_doctor_id = 1;
```

Lectura de cada resultado:

- Las consultas de conteo devuelven **un único valor**: la cantidad de filas de la tabla. Comparar los cuatro: las dos tablas de referencia (`province_names`, `doctors`) son chicas; las dos tablas de movimiento (`patients`, `admissions`) son grandes. Anotar los valores: se usan en el ejercicio.
- `SELECT *` significa "todas las columnas"; `LIMIT 5` recorta el resultado a las primeras 5 filas.
- `WHERE` filtra: solo las filas que cumplen la condición. El texto se compara con comillas simples (`'Penicillin'`).
- La cuarta consulta muestra los ingresos de un solo médico: la relación entre tablas ya se puede consultar.

### Paso 6 — Guardar las consultas

Con el botón de guardar del panel SQL, guardar las consultas como `consultas-e10.sql` dentro de `u2-sqlite`. Ese archivo queda como registro del encuentro y viaja con el commit de cierre.

## 5. Ejercicio independiente (55 min)

### Consigna

Sobre la misma base abierta en DB Browser:

1. Completar la cuarta columna del cuadro de exploración con la cantidad de filas de cada tabla (usar las consultas de conteo del Paso 5 y anotar los cuatro valores).
2. Mostrar los primeros 10 ingresos: adaptar la consulta de los primeros 5 médicos.
3. Listar los pacientes con alergia `'Peanuts'`: adaptar la consulta de Penicillin.
4. Obtener la fila completa del médico con `doctor_id = 7`: adaptar una de las consultas anteriores.
5. Responder con dos o tres líneas propias: ¿por qué los datos de `hospital.db` sobreviven al reinicio de la computadora y los de la `List<T>` de la Unidad 1 no?

### Pista

Ninguna consulta nueva: todas salen de modificar las cuatro semillas del Paso 5 (cambiar el número de `LIMIT`, el valor del filtro o el nombre de la tabla). La solución completa está en el anexo docente y se corrige en la puesta en común.

## 6. Cierre (20 min)

### Qué nos llevamos

- Una base de datos resuelve la persistencia: los datos viven en el disco y sobreviven al programa, a diferencia de la `List<T>` en memoria.
- SQLite es un motor sin servidor: la base entera es un archivo (`hospital.db`) que se copia, mueve y respalda como cualquier archivo.
- `hospital.db` tiene cuatro tablas (`province_names`, `doctors`, `patients`, `admissions`) conectadas por claves: dos de referencia (chicas) y dos de movimiento (grandes).
- SQL es el idioma de las consultas: `SELECT` para leer, `COUNT(*)` para contar, `LIMIT` para recortar, `WHERE` para filtrar.
- En `NULL` el vacío es un valor con significado: dato ausente.

### Lo que viene

- Encuentro 11: «Dapper: Query&lt;T&gt; / SELECT con mapeo a records» y «Conexión a la base / Alias AS y DTOs». La API de C# se conecta a `hospital.db` y los mismos datos de hoy salen por HTTP en JSON: primeros endpoints GET contra la base real.

### Recordatorio de commit (rutina desde el Encuentro 5)

Con la exploración terminada y `consultas-e10.sql` guardado, al cierre del encuentro:

```powershell
git add .
git commit -m "Clase 10: primera mirada a hospital.db"
git push
```

## 7. Errores comunes y trampas

| Trampa | Causa | Cómo se resuelve |
| --- | --- | --- |
| Buscarle "servidor" a SQLite | Costumbre de pensar base de datos = programa gigante instalado | SQLite no instala nada: es una biblioteca que usa el programa, y la base es un archivo común que se abre, copia y respalda |
| Mezclar el vocabulario al describir | Confundir tabla, fila y columna | Tabla: la planilla completa (`patients`). Fila: un registro (un paciente). Columna: un campo (la fecha de nacimiento) |
| Mover o borrar `hospital.db` con la base abierta | El archivo está en uso por DB Browser | Cerrar DB Browser antes de mover o copiar la carpeta; verificar que el `.db` viaja con el resto de los archivos |
| Escribir sobre los datos en Examinar datos | La pestaña también sirve de editor | Este encuentro es de solo lectura; si se toca una celda, cerrar sin guardar los cambios |
| `no such table: patient` en Ejecutar SQL | Nombre de tabla mal escrito (en singular o con error de tipeo) | Los nombres van en plural, tal como aparecen en la pestaña Estructura: `patients`, `doctors`, `admissions`, `province_names`; revisar también el punto y coma |
| Esperar que la API ya muestre estos datos | Confundir explorar el archivo con conectar la API | La conexión C# → base llega en el Encuentro 11; hoy el archivo se mira con sus propias herramientas |
