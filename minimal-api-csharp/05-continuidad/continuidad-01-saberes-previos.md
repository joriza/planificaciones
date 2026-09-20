# Continuidad pedagógica 1 — Saberes previos

> Documento de continuidad pedagógica de la asignatura «Minimal API con C# .NET 6» (documento 1 de 4). Se entrega a la administración para los casos de ausencia del docente: contiene actividades de repaso y fijación realizables **sin presencia docente**. Las soluciones completas y los criterios de corrección se encuentran en el documento docente separado `continuidad-01-saberes-previos-anexo-docente.md`, que no se entrega a los alumnos.

## 1. Datos de referencia

| Campo | Detalle |
| --- | --- |
| Asignatura | Minimal API con C# .NET 6 |
| Documento | Continuidad pedagógica 1 — repaso y fijación de saberes previos |
| Momento de uso | Inicio del curso, antes de la Unidad 1: los alumnos aún no vieron ningún tema de la asignatura. Sirve para cualquier encuentro en que el docente esté ausente en ese tramo |
| Duración teórica | 240 minutos (4 horas reloj) |
| Requisitos | Aula habitual; cuaderno y bolígrafo por alumno; este documento impreso (uno por banco) o proyectado. **No requiere computadora**: todas las actividades se resuelven en papel. Sin uso de celular |
| Organización de la resolución | En forma habitual: por lo general, en grupo, con rotación de la persona que escribe; la presentación es individual y manuscrita (ver nota de registro académico) |
| Actividades | Seis actividades puntuadas sobre 100 cuyos tiempos suman 240 minutos |

## 2. Propósito e instrucciones para la resolución

**Propósito (registro docente formal).** Este documento permite que el grupo repase y fije los saberes previos sobre los que se apoya toda la asignatura: partes de una computadora y organización de archivos y carpetas, terminal básica (navegar, listar, crear), qué es la web (URL y ciclo de petición y respuesta), lectura de un documento JSON corto a ojo y operaciones de lógica secuencial simples. No adelanta ningún contenido de la asignatura: todo se resuelve con lo que los alumnos traen de su formación anterior.

**Instrucciones para el grupo (sin docente):**

1. Leer primero el documento completo: la tabla de actividades indica puntos y tiempo sugerido de cada una.
2. Resolver en los grupos habituales, con rotación de la persona al teclado o al papel; nadie queda sin grupo.
3. Cada integrante escribe **sus propias respuestas a mano** en el cuaderno: la presentación es individual.
4. Las consignas se resuelven con los datos de las «Fichas de trabajo» (sección 5); no hace falta buscar información afuera del documento.
5. El tiempo de cada actividad es una guía: si un grupo avanza más rápido, puede usar el sobrante en revisar sus respuestas.
6. No se usa celular en ningún momento.
7. Al terminar la actividad 6, cada alumno ordena sus respuestas numeradas para presentarlas manuscritas al inicio de la próxima clase.

## 3. Objetivos

Al trabajar este documento, cada estudiante puede:

1. Reconocer las partes de una computadora y organizar la información en archivos, carpetas y rutas.
2. Predecir el efecto de los comandos básicos de la terminal para navegar, listar y crear carpetas.
3. Describir el ciclo de petición y respuesta entre cliente y servidor a partir de una URL.
4. Leer un documento JSON corto identificando claves, valores, tipos y elementos de un arreglo.
5. Expresar una tarea sencilla como una secuencia ordenada de pasos.

## 4. Actividades

| N.º | Actividad | Consigna completa | Puntos | Tiempo |
| --- | --- | --- | --- | --- |
| 1 | La computadora y sus archivos | Clasificar los ocho dispositivos de la ficha 1 en entrada, salida, procesamiento o almacenamiento (inciso a); a partir del árbol de carpetas, escribir la ruta completa de los tres archivos (inciso b), la ruta de la carpeta nueva que se pide (inciso c) y decidir si dos carpetas son la misma, con justificación (inciso d). | 20 | 45 min |
| 2 | Órdenes a la terminal | Leer las tres secuencias de comandos de la ficha 2 con su carpeta de arranque, ejecutarlas «en el papel» paso a paso y anotar qué carpetas crea cada `mkdir`, en qué carpeta termina cada secuencia y qué muestra el `dir` final; en la secuencia 3, explicar qué ocurre con el comando que falla y si algo se rompe. | 20 | 50 min |
| 3 | El viaje de un pedido web | Descomponer las tres URLs de la ficha 3 en protocolo, dominio y ruta; completar el mapa cliente → petición → servidor → respuesta; y analizar las dos situaciones indicando quién es el cliente, quién es el servidor, qué se pidió y qué se recibió. | 20 | 50 min |
| 4 | Leer un JSON a ojo | A partir del documento JSON de la ficha 4: contar los pares clave-valor del objeto principal e identificar sus claves, indicar el tipo de cada valor, contar los elementos del arreglo, nombrar al segundo estudiante y copiar el JSON completo con el par `"sede": "Oeste"` agregado en el lugar correcto. | 20 | 50 min |
| 5 | Pasos en orden | Ordenar los seis pasos desordenados de la tarea de entrega (inciso a); detectar el paso fuera de lugar de la segunda secuencia y reescribirla en orden correcto (inciso b); y escribir la secuencia propia de 5 o 6 pasos de una tarea cotidiana elegida, de modo que otra persona pueda seguirla sin preguntar nada (inciso c). | 10 | 25 min |
| 6 | Autoevaluación final | Completar la autoevaluación de la sección 6: marcar el nivel de logro de cada objetivo, responder las dos preguntas de reflexión y ordenar las respuestas manuscritas para la presentación. | 10 | 20 min |
| **Total** | — | — | **100** | **240 min** |

## 5. Fichas de trabajo

### Ficha 1 — La computadora y sus archivos (actividad 1)

**Inciso (a).** Clasificar cada dispositivo en la categoría correcta: dispositivo de **entrada**, de **salida**, de **procesamiento** o de **almacenamiento**.

```text
teclado · monitor · mouse · disco rígido
impresora · microprocesador (CPU) · auriculares · pen drive
```

**Incisos (b), (c) y (d).** El árbol de carpetas de la computadora de un alumno es este:

```text
Mis documentos
├── Escuela
│   ├── 5to
│   │   └── practica.txt
│   └── fotos.png
├── Personal
│   └── cv.pdf
└── notas.txt
```

- **(b)** Escribir la ruta completa de cada archivo: `practica.txt`, `fotos.png` y `cv.pdf`.
- **(c)** Si dentro de `Escuela` se crea una carpeta nueva llamada `Tareas`, escribir la ruta completa de esa carpeta.
- **(d)** ¿`Escuela` y `Escuela/5to` son la misma carpeta? Responder sí o no y justificar en una línea.

### Ficha 2 — Órdenes a la terminal (actividad 2)

Las tres secuencias usan esta carpeta de partida (los comandos son los vistos en la secundaria: `cd` para navegar, `mkdir` para crear carpetas, `dir` para listar, `cd ..` para subir):

```text
Documentos
└── Cursos
    └── practica
        └── guia1
```

**Secuencia 1** (arranca en `Documentos`):

```text
cd Cursos
mkdir ejercicios
cd ejercicios
mkdir clase1
cd ..
dir
```

**Secuencia 2** (arranca en `Documentos/Cursos/practica/guia1`):

```text
cd ..
cd ..
mkdir apuntes
cd apuntes
dir
```

**Secuencia 3** (arranca en `Documentos`):

```text
cd Cursos
cd Musica
mkdir listas
cd ..
dir
```

Para cada secuencia, anotar: qué carpetas se crean, en qué carpeta queda parada la terminal al final y qué muestra el `dir` final. En la secuencia 3: ¿qué pasa con el comando `cd Musica`? ¿Algo se rompe por ese error?

**Pista.** Hacé la traza como si fueras la terminal: una carpeta por línea, y en cada paso preguntate «¿dónde estoy ahora?».

### Ficha 3 — El viaje de un pedido web (actividad 3)

**Inciso (a).** Descomponer cada URL en **protocolo**, **dominio** y **ruta**:

```text
http://escuela.edu.ar/aula/avisos
https://noticias.com/deportes/resultados
http://localhost:5080/hola
```

**Inciso (b).** Completar el mapa del ciclo, escribiendo en cada flecha la palabra que falta:

```text
cliente  ──( ¿? )──▶  servidor
cliente  ◀──( ¿? )──  servidor
```

**Inciso (c).** Analizar cada situación e indicar: quién es el **cliente**, quién es el **servidor**, qué se **pidió** y qué se **recibió**.

1. Escribís en el navegador la dirección del portal de la escuela y la página carga en la pantalla.
2. Escribís una dirección que no existe y el navegador muestra que no se encontró la página.

**Pista.** El cliente es quien pide; el servidor es la computadora que espera pedidos y responde. También una respuesta de error es una respuesta.

### Ficha 4 — Leer un JSON a ojo (actividad 4)

Este es el documento JSON que van a leer (se lee a ojo, sin programa): un objeto con pares clave-valor, donde un valor puede ser texto, número, verdadero/falso o un arreglo.

```json
{
  "curso": "Minimal API",
  "anio": 2024,
  "activo": true,
  "estudiantes": [
    { "nombre": "Ana", "edad": 17 },
    { "nombre": "Bruno", "edad": 18 }
  ]
}
```

Responder:

- **(a)** ¿Cuántos pares clave-valor tiene el objeto principal? ¿Cuáles son sus claves?
- **(b)** ¿Qué tipo de valor tiene cada clave del objeto principal (texto, número, verdadero/falso, arreglo)?
- **(c)** ¿Cuántos elementos tiene el arreglo `estudiantes`?
- **(d)** ¿Cómo se llama el segundo estudiante? ¿De qué tipo es el valor de su `edad`?
- **(e)** Copiar el JSON completo, agregando el par `"sede": "Oeste"` al objeto principal, en el lugar correcto y con su coma.

**Pista.** Un par clave-valor se escribe `"clave": valor` y los pares del mismo objeto se separan con comas. Mirá dónde cierra cada llave antes de insertar el par nuevo.

### Ficha 5 — Pasos en orden (actividad 5)

**Inciso (a).** Estos pasos de «preparar un trabajo para entregar» están desordenados. Reordenarlos del 1 al 6:

```text
( ) Copiar la carpeta al pen drive.
( ) Crear la carpeta del trabajo.
( ) Escribir el archivo y guardarlo con nombre.
( ) Verificar que el archivo se abre desde el pen drive.
( ) Cerrar el programa.
( ) Abrir el programa de escritura.
```

**Inciso (b).** Esta secuencia tiene un paso fuera de lugar. Detectarlo, explicar por qué está mal ahí y reescribir la secuencia completa en orden:

```text
1. Guardar el archivo.
2. Abrir el programa de escritura.
3. Escribir el texto.
4. Cerrar el programa.
```

**Inciso (c).** Elegir una tarea cotidiana (por ejemplo: hacer una torta, preparar la mochila, armar una bicicleta) y escribir su secuencia de 5 o 6 pasos, ordenados y completos, de modo que otra persona pueda hacerla sin preguntar nada.

## 6. Autoevaluación del alumno

Al finalizar las actividades, completar la siguiente tabla marcando una columna por fila, con honestidad: sirve para saber qué conviene repasar.

| Objetivo | Lo hice solo | Lo hice con ayuda | No pude todavía |
| --- | --- | --- | --- |
| 1. Reconocer partes de la computadora y organizar archivos y carpetas con sus rutas. | | | |
| 2. Predecir qué hacen los comandos básicos de la terminal (navegar, listar, crear). | | | |
| 3. Describir el ciclo de petición y respuesta a partir de una URL. | | | |
| 4. Leer un JSON corto identificando claves, valores, tipos y elementos. | | | |
| 5. Expresar una tarea como una secuencia ordenada de pasos. | | | |

**Preguntas de reflexión:**

1. ¿Qué actividad me resultó más fácil y por qué?
2. ¿Qué tema quiero que se repase en la próxima clase?

## 7. Presentación y nota de registro académico

La presentación se realiza **en forma individual y manuscrita**, al inicio de la próxima clase, con las respuestas numeradas por actividad y la autoevaluación completa. Es una actividad más de la asignatura y forma parte del proceso de evaluación.

**Nota (registro académico).** La resolución se realiza en forma habitual (por lo general, en grupo); la presentación es individual y manuscrita, al inicio de la próxima clase, y constituye una actividad más de la asignatura que forma parte del proceso de evaluación.
