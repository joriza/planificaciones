# Evaluación del momento 02-03 — Versión B

> Dominio de esta versión: lógica, algoritmos y terminal sin C# aún. Duración: 90 minutos. Puntaje total: 100 puntos. Resolución individual, sin computadora (o mínima: seguir algoritmo, diagrama de flujo, secuencias/decisiones). Sin celular. Las condiciones completas están en `evaluacion-intensificaciones-02-03.md`.

## Antes de empezar

- Resolver en papel o con mínimo uso de computadora (solo si el docente lo autoriza para la parte de terminal).
- No se permite consultar C# ni documentación de programación.
- Cada ítem tiene un puntaje indicado; la suma total es 100 puntos.
- Si un ítem requiere un diagrama de flujo, usar los símbolos estándar: óvalo (inicio/fin), rectángulo (proceso), rombo (decisión), flechas de flujo.
- Al terminar, avisar al docente para la corrección.

## Objetivos de la prueba

- Evaluar saberes previos de lógica de programación: secuencia, decisión y repetición.
- Evaluar capacidad de traducción de algoritmos cotidianos a diagramas de flujo.
- Evaluar manejo básico de comandos de terminal (`cd`, `ls`/`dir`, `mkdir`, `touch`).
- Criterio de evaluación: Apto / No apto aún por objetivo mínimo.

## Material provisto — Esqueleto de `Program.cs`

No aplica para esta versión (sin C# aún). El alumno trabaja en papel o con mínimo uso de computadora.

## Parte 1 — Secuencia y terminal (30 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 1.1 | Escribir el paso a paso de «hacer un café con máquina» como secuencia de instrucciones numeradas (mínimo 6 pasos). | 10 |
| 1.2 | Dados los comandos `cd descargas`, `mkdir proyecto-final`, `cd proyecto-final`, `touch notas.txt`, indicar en qué carpeta queda el archivo `notas.txt` y qué comando lo creó. | 10 |
| 1.3 | Traducir el siguiente algoritmo a diagrama de flujo: «Si la temperatura es mayor a 30 grados, mostrar «Día caluroso»; sino, mostrar «Día normal»». | 10 |

## Parte 2 — Decisiones y repetición (40 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 2.1 | Dibujar un diagrama de flujo que lea cinco números y muestre el mayor de ellos. | 15 |
| 2.2 | Escribir la secuencia de pasos para sumar los números del 1 al 50 usando un bucle (pseudocódigo o diagrama). | 15 |
| 2.3 | Indicar cuántas veces se ejecuta el cuerpo del bucle en el siguiente caso: `para i desde 2 hasta 20 con paso 3`. Justificar. | 10 |

## Parte 3 — Integración (30 puntos)

| Ítem | Consigna | Puntos |
| --- | --- | --- |
| 3.1 | Dado el diagrama de flujo de una vending machine que pide una moneda y un producto, y devuelve el cambio si la moneda es suficiente o mensaje de «moneda insuficiente» si no, identificar la estructura de decisión y la estructura de repetición (si las hay). | 15 |
| 3.2 | Relacionar cada símbolo del diagrama de flujo (óvalo, rectángulo, rombo, flecha) con su equivalente en pseudocódigo o en C# (`if`, `for`, `while`, `Console.WriteLine`). | 15 |

## Parte 4 — Ítems conceptuales

- ¿Cuál es la diferencia entre una estructura de secuencia y una estructura de decisión? (5 pts)
- ¿Qué símbolo del diagrama de flujo representa una condición y por qué? (5 pts)
- ¿Por qué el bucle «sumar del 1 al 50» no necesita una variable de acumulación en el diagrama de flujo pero sí en pseudocódigo? (5 pts)
- ¿Qué comando de terminal crearías para listar los archivos de una carpeta y luego entrar en una subcarpeta? (5 pts)

## Batería de verificación: salida esperada de cada prueba

| Prueba | Pedido | Salida esperada |
| --- | --- | --- |
| 1.1 | Pasos para hacer un café | Secuencia numerada de al menos 6 pasos lógicos (ej.: encender la máquina, agregar agua, etc.) |
| 1.2 | Ubicación de `notas.txt` | Carpeta `proyecto-final` dentro de `descargas`; comando `touch notas.txt` |
| 1.3 | Diagrama de flujo de temperatura | Óvalo inicio → rectángulo «leer temperatura» → rombo «temperatura > 30» → rectángulo «mostrar Día caluroso» o «mostrar Día normal» → óvalo fin |
| 2.1 | Diagrama de flujo del mayor | Rombo con comparaciones encadenadas o anidadas; rectángulos para asignación y salida |
| 2.2 | Pseudocódigo de suma 1-50 | Variable `suma ← 0`, bucle `para i desde 1 hasta 50`, `suma ← suma + i`, mostrar `suma` |
| 2.3 | Cantidad de iteraciones | 7 iteraciones (2, 5, 8, 11, 14, 17, 20) |
| 3.1 | Identificación de estructuras | Decisión: condición de moneda suficiente; Repetición: no aplica (o validación de entrada si se incluye) |
| 3.2 | Relación símbolo-código | Óvalo → inicio/fin del programa; Rectángulo → proceso/asignación; Rombo → `if`/`while`; Flecha → flujo de ejecución |

## Al terminar

Dejar la prueba en la mesa y avisar al docente. Se devuelve con nota de Apto o No apto aún por objetivo mínimo. Si el objetivo mínimo queda pendiente, se ofrece la instancia de intensificación de los encuentros 17-18 como primera capa de recuperación.