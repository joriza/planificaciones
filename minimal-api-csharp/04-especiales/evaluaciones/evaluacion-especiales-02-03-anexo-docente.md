# Anexo docente — Evaluación del momento especial 2 y 3 — Saberes previos

> Documento docente formal. No se entrega a los alumnos: contiene la solución de las versiones A y B, los criterios de corrección por objetivo mínimo, los errores previstos y la pauta de registro y devolución.

## 1. Solución de la versión A (biblioteca escolar)

### Parte 1 — URL y respuesta

| Ítem | Respuesta esperada | Aceptaciones válidas |
| --- | --- | --- |
| a | Protocolo: `https` · Dominio: `api.biblioteca.ejemplo.edu.ar` · Ruta: `/libros/7` | El dominio señalado con su terminación (`ejemplo.edu.ar` o `api.biblioteca.ejemplo.edu.ar`) es el mismo texto: se acepta si identifica dónde termina el dominio y dónde empieza la ruta |
| b | El navegador (cliente) hace la petición; la computadora de la biblioteca (servidor) la responde | «El programa navegador», «la máquina que guarda los datos del libro» o equivalentes, siempre con los dos roles |
| c | Es la respuesta; la produjo el servidor | Si nombró solo «la biblioteca», se acepta: el rol servidor quedó identificado en el ítem b |

### Parte 2 — Lectura de un JSON corto

| Ítem | Respuesta esperada |
| --- | --- |
| a | 5 pares clave-valor |
| b | `titulo`: texto · `autor`: texto · `anio`: número · `generos`: arreglo · `disponible`: verdadero/falso (booleano) |
| c | 2 elementos, ambos de tipo texto |

### Parte 3 — Archivos y terminal en papel

| Ítem | Respuesta esperada | Aceptaciones válidas |
| --- | --- | --- |
| a | `cd curso` | — |
| b | `cd practicas` y luego `mkdir tp0` (dos comandos) o, desde `curso`, un único comando con la ruta relativa: `mkdir practicas\tp0` | Se acepta `mkdir practicas/tp0` con barra común: la terminal lo interpreta igual en este recorrido |
| c | `dir` o `ls` (los dos listan en la terminal del aula) | — |
| d | 1) `cd practicas` · 2) `cd tp0` (se acepta `cd practicas\tp0` como un solo paso) · 3) ejecutar el programa: `.\saludo.exe` (se acepta `.\saludo` o `saludo`) | Lo que corrige OM4 es el orden: primero entrar, después ejecutar. Un paso de más (por ejemplo, listar antes de entrar) no invalida la secuencia si el orden entrar → ejecutar se conserva |

## 2. Solución de la versión B (playlist de música)

### Parte 1 — URL y respuesta

| Ítem | Respuesta esperada | Aceptaciones válidas |
| --- | --- | --- |
| a | Protocolo: `https` · Dominio: `api.musica.ejemplo.org` · Ruta: `/playlist/12` | Ídem versión A: se acepta el dominio señalado con su terminación, siempre que la ruta quede separada |
| b | El navegador (cliente) hace la petición; la computadora de la aplicación de música (servidor) la responde | Ídem versión A |
| c | Es la respuesta; la produjo el servidor | Ídem versión A |

### Parte 2 — Lectura de un JSON corto

| Ítem | Respuesta esperada |
| --- | --- |
| a | 5 pares clave-valor |
| b | `titulo`: texto · `creador`: texto · `anio`: número · `canciones`: arreglo · `publica`: verdadero/falso (booleano) |
| c | 3 elementos, todos de tipo texto |

### Parte 3 — Archivos y terminal en papel

| Ítem | Respuesta esperada | Aceptaciones válidas |
| --- | --- | --- |
| a | `cd curso` | — |
| b | `cd trabajos` y luego `mkdir tp0`, o desde `curso`: `mkdir trabajos\tp0` | Se acepta `mkdir trabajos/tp0` con barra común |
| c | `dir` o `ls` | — |
| d | 1) `cd trabajos` · 2) `cd tp0` (o `cd trabajos\tp0` en un solo paso) · 3) `.\saludo.exe` (se acepta `.\saludo` o `saludo`) | Ídem versión A: el orden entrar → ejecutar es lo que acredita OM4 |

Equivalencia verificada: ambas versiones tienen la misma estructura de partes e ítems, URLs con idénticas partes, JSON con 5 pares y los mismos tipos (dos textos, un número, un arreglo de textos, un booleano), y una Parte 3 con el mismo árbol de carpetas y el mismo programa final; solo cambian dominio, datos y nombres de carpetas.

## 3. Criterios de corrección por objetivo mínimo

| OM | Qué evidencia lo alcanza | Se verifica en | Criterio de Apto |
| --- | --- | --- | --- |
| OM1 — Terminal | Comandos correctos de navegación, creación de carpetas y listado | 3a, 3b y 3c | Los tres ítems con el comando correcto o su equivalente aceptado; se tolera un error de tipeo que no cambie el comando (por ejemplo, un espacio de más) |
| OM2 — URL y petición/respuesta | Partes de la URL bien ubicadas y ciclo con cliente y servidor identificados | 1a, 1b y 1c | 1a con las tres partes correctas, 1b con los dos roles y 1c con respuesta/servidor; un desorden en la enumeración de 1a no descalifica si cada parte está bien identificada |
| OM3 — Lectura de JSON | Cantidad de pares, tipos de valores y elementos del arreglo | 2a, 2b y 2c | 2a correcto (5 pares), tabla de tipos sin más de un error, y 2c con cantidad y tipo del arreglo correctos |
| OM4 — Secuencia de pasos | Secuencia completa y en orden para entrar a la carpeta y ejecutar el programa | 3d | Secuencia con entrar antes de ejecutar, con los comandos correctos o equivalentes; una omisión del paso `cd practicas`/`cd trabajos` cuando ya venía del ítem anterior se consigna como observación sin quitar el OM4 |

- **Apto en el momento:** OM1, OM2, OM3 y OM4 alcanzados.
- **No apto aún:** al menos un OM sin alcanzar; se registra cuál o cuáles en la planilla y se deriva a `05-continuidad/continuidad-01-saberes-previos.md`.
- La corrección no lleva puntaje: es cualitativa, por objetivo mínimo, igual para ambas versiones.

## 4. Errores previstos y criterio de intervención

| Error observable | Causa probable | Criterio |
| --- | --- | --- |
| Marca la ruta como dominio (o al revés) | Leyó la URL como un texto único | 1a queda sin acreditar ese ítem; si 1b y 1c están bien, el OM2 se define por el conjunto según el criterio de Apto |
| Dice que el texto JSON es la petición | Invirtió el ciclo de petición y respuesta | 1c No apto aún; repasar con el mapa del pizarrón antes de registrar el OM2 |
| Cuenta el arreglo como un solo valor | No reconoce los corchetes como contenedor de varios elementos | 2c No apto aún |
| Escribe `mkdir tp0` a secas en el ítem 3b | Omitió la carpeta contenedora | No acredita 3b salvo que escriba la ruta relativa completa (`mkdir practicas\tp0` / `mkdir trabajos\tp0`) |
| Ejecuta `saludo` antes de entrar a `tp0` | Secuencia desordenada | OM4 No apto aún aunque los comandos sean correctos: el objetivo es el orden de los pasos |
| Usa `ls` en lugar de `dir` (o al revés) | Dudó entre sistemas | Ambos se aceptan: en la terminal del aula los dos listan |

## 5. Registro y devolución

- Planilla del momento: alumno, condición de pista (recuperación o profundización), versión (A o B), resultado por objetivo mínimo (OM1 a OM4: Apto / No apto aún) y resultado del momento.
- Devolución oral breve por alumno en la misma plenaria de cierre del Encuentro 3; el docente indica a cada alumno qué objetivo consolidó y cuál queda pendiente.
- Los objetivos en No apto aún se trabajan en la instancia de continuidad de saberes previos (`05-continuidad/continuidad-01-saberes-previos.md`) y se revisan antes del primer cierre de unidad.
- El registro es cualitativo y provisorio: orienta la nivelación, no califica.
