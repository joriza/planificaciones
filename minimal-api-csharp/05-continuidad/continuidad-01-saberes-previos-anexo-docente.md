# Anexo docente — Continuidad pedagógica 1: Saberes previos

> Documento docente formal. **No se entrega a los alumnos**: contiene las soluciones completas de las seis actividades del documento `continuidad-01-saberes-previos.md` y los criterios de corrección por actividad, con puntaje. Queda a disposición del docente para corregir las presentaciones manuscritas individuales y registrar el resultado como una actividad más del proceso de evaluación.

## 1. Soluciones y criterios por actividad

### Actividad 1 — La computadora y sus archivos (20 puntos)

**Solución inciso (a):**

| Dispositivo | Categoría |
| --- | --- |
| Teclado | Entrada |
| Monitor | Salida |
| Mouse | Entrada |
| Disco rígido | Almacenamiento |
| Impresora | Salida |
| Microprocesador (CPU) | Procesamiento |
| Auriculares | Salida |
| Pen drive | Almacenamiento |

**Solución incisos (b) a (d):**

- **(b)** Rutas completas: `Mis documentos/Escuela/5to/practica.txt`, `Mis documentos/Escuela/fotos.png`, `Mis documentos/Personal/cv.pdf`.
- **(c)** La carpeta nueva es `Mis documentos/Escuela/Tareas` (queda vacía hasta que se guarden archivos dentro).
- **(d)** No. `Escuela` es la carpeta que contiene `5to` y `fotos.png`; `Escuela/5to` es una carpeta distinta, adentro de `Escuela`, que contiene `practica.txt`.

**Criterios de corrección (20 puntos):** inciso (a), 8 puntos (1 por dispositivo bien clasificado); inciso (b), 6 puntos (2 por ruta completa y bien jerarquizada); inciso (c), 3 puntos (2 por la ruta correcta, 1 por indicar que es carpeta); inciso (d), 3 puntos (1 por el «no», 2 por una justificación que distinga los niveles del árbol).

### Actividad 2 — Órdenes a la terminal (20 puntos)

**Solución secuencia 1** (arranca en `Documentos`): `mkdir ejercicios` crea `Documentos/Cursos/ejercicios`; `mkdir clase1` crea `Documentos/Cursos/ejercicios/clase1`; el `cd ..` sube de `ejercicios` a `Cursos`. La terminal queda en `Documentos/Cursos` y el `dir` final muestra la carpeta `ejercicios` (y `practica`, si ya existía en el esquema de partida).

**Solución secuencia 2** (arranca en `Documentos/Cursos/practica/guia1`): los dos `cd ..` suben a `practica` y luego a `Cursos`; `mkdir apuntes` crea `Documentos/Cursos/apuntes` y `cd apuntes` entra ahí. La terminal queda en `Documentos/Cursos/apuntes` y el `dir` final muestra una lista vacía: la carpeta se acaba de crear y no tiene nada adentro.

**Solución secuencia 3** (arranca en `Documentos`): el comando `cd Musica` falla porque la carpeta `Musica` no existe dentro de `Cursos`; la terminal muestra un aviso de que no encuentra esa carpeta y **sigue parada en `Cursos`**. Nada se rompe: luego `mkdir listas` crea `Documentos/Cursos/listas`, el `cd ..` sube a `Documentos` y el `dir` final muestra `Cursos`. Conclusión esperada: escribir mal un comando o pedir una carpeta inexistente no destruye nada; la terminal avisa y queda donde está.

**Criterios de corrección (20 puntos):** secuencia 1, 7 puntos (3 por la carpeta final, 4 por el contenido del `dir`); secuencia 2, 7 puntos (3 por la carpeta final, 4 por el `dir` vacío justificado); secuencia 3, 6 puntos (3 por explicar el fallo de `cd Musica` sin rotura, 3 por la carpeta final y el `dir`). Se acepta `ls` en lugar de `dir` si el alumno explicita la equivalencia.

### Actividad 3 — El viaje de un pedido web (20 puntos)

**Solución inciso (a):**

| URL | Protocolo | Dominio | Ruta |
| --- | --- | --- | --- |
| `http://escuela.edu.ar/aula/avisos` | `http` | `escuela.edu.ar` | `/aula/avisos` |
| `https://noticias.com/deportes/resultados` | `https` | `noticias.com` | `/deportes/resultados` |
| `http://localhost:5080/hola` | `http` | `localhost:5080` | `/hola` |

**Solución inciso (b):** el mapa queda `cliente ──(petición)──▶ servidor` y `cliente ◀──(respuesta)── servidor`. Un alumno puede leerlo en voz alta así: el cliente pide, el servidor responde.

**Solución inciso (c):**

1. El cliente es el navegador del alumno; el servidor es la computadora de la escuela que aloja el portal. Se pidió la página de la dirección escrita (el portal) y se recibió la página, que el navegador muestra.
2. Sí hubo petición: el navegador pidió esa dirección. El servidor (o el propio navegador al no encontrar destino) respondió con un aviso de que la página no se encontró. Conclusión esperada: una respuesta de error también es una respuesta del ciclo.

**Criterios de corrección (20 puntos):** inciso (a), 12 puntos (4 por URL: protocolo, dominio y ruta correctos); inciso (b), 2 puntos (una palabra correcta por flecha); inciso (c), 6 puntos (3 por situación: cliente, servidor, pedido y respuesta identificados).

### Actividad 4 — Leer un JSON a ojo (20 puntos)

**Solución:**

- **(a)** El objeto principal tiene **4 pares clave-valor**: `curso`, `anio`, `activo` y `estudiantes`.
- **(b)** `curso`: texto; `anio`: número; `activo`: verdadero/falso; `estudiantes`: arreglo (de objetos).
- **(c)** El arreglo `estudiantes` tiene **2 elementos**.
- **(d)** El segundo estudiante se llama `Bruno`; su `edad` es un valor de tipo **número**.
- **(e)** JSON completo con el par nuevo (valen cualquier posición interna del objeto principal, siempre con su coma y sin romper las llaves):

```json
{
  "curso": "Minimal API",
  "anio": 2024,
  "activo": true,
  "sede": "Oeste",
  "estudiantes": [
    { "nombre": "Ana", "edad": 17 },
    { "nombre": "Bruno", "edad": 18 }
  ]
}
```

**Criterios de corrección (20 puntos):** inciso (a), 4 puntos (2 por la cantidad, 2 por las claves); inciso (b), 4 puntos (1 por tipo correcto); inciso (c), 2 puntos; inciso (d), 2 puntos (1 por el nombre, 1 por el tipo); inciso (e), 8 puntos (4 por insertarlo dentro del objeto principal y no dentro del arreglo, 4 por la sintaxis correcta del par y su coma).

### Actividad 5 — Pasos en orden (10 puntos)

**Solución inciso (a), orden correcto:**

```text
1. Crear la carpeta del trabajo.
2. Abrir el programa de escritura.
3. Escribir el archivo y guardarlo con nombre.
4. Cerrar el programa.
5. Copiar la carpeta al pen drive.
6. Verificar que el archivo se abre desde el pen drive.
```

**Solución inciso (b):** el paso fuera de lugar es el 1 («Guardar el archivo»): no se puede guardar antes de abrir el programa y escribir. Secuencia corregida: 1. Abrir el programa de escritura. 2. Escribir el texto. 3. Guardar el archivo. 4. Cerrar el programa.

**Solución inciso (c):** respuesta abierta. Se considera correcta toda secuencia de 5 o 6 pasos **ordenada** (cada paso usa solo lo que ya hicieron los anteriores), **completa** (no asume pasos invisibles) y **ejecutable sin preguntar nada**.

**Criterios de corrección (10 puntos):** inciso (a), 6 puntos (1 por posición correcta); inciso (b), 2 puntos (1 por detectar el paso, 1 por reescritura correcta); inciso (c), 2 puntos (secuencia ordenada y ejecutable).

### Actividad 6 — Autoevaluación final (10 puntos)

**Solución:** no hay respuestas únicas: es un instrumento metacognitivo. La tabla de logros se completa marcando una columna por fila y las dos preguntas de reflexión se responden con una o dos líneas cada una.

**Criterios de corrección (10 puntos):** 5 puntos por la tabla completa (1 por fila, con exactamente una columna marcada) y 5 puntos por las dos reflexiones respondidas (2 o 3 puntos cada una según concreten qué les resultó fácil o qué quieren repasar; una respuesta vacía o genérica de una palabra no completa la fila).

## 2. Cuadro resumen de puntajes

| Actividad | Puntaje máximo |
| --- | --- |
| 1. La computadora y sus archivos | 20 |
| 2. Órdenes a la terminal | 20 |
| 3. El viaje de un pedido web | 20 |
| 4. Leer un JSON a ojo | 20 |
| 5. Pasos en orden | 10 |
| 6. Autoevaluación final | 10 |
| **Total** | **100** |

## 3. Registro y uso previsto

- La presentación es **individual y manuscrita**, al inicio de la próxima clase: cada alumno entrega sus respuestas numeradas por actividad y la autoevaluación completa.
- El docente corrige con los criterios de este anexo, registra el puntaje sobre 100 como una actividad más del proceso de evaluación y devuelve observaciones al grupo en el encuentro siguiente.
- El trabajo se resolvió en grupo, pero la corrección y el registro son individuales: dos presentaciones con respuestas idénticas palabra por palabra merecen una revisión del proceso de resolución antes de asignar puntaje.
- Si un objetivo de la autoevaluación quedó en «No pude todavía» para la mayoría del grupo, conviene retomarlo brevemente al inicio del encuentro próximo, antes de avanzar con contenido nuevo.
