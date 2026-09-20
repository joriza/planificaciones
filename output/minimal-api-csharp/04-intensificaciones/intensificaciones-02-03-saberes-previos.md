# Intensificación y fortalecimiento de saberes previos — Encuentros 2 y 3

## Metadatos

| Campo | Valor |
|---|---|
| Momento | Intensificación y fortalecimiento de saberes previos |
| Encuentros | 2 y 3 |
| Duración | 2 encuentros × 240 min (480 min total) |
| Destinatarios | Totalidad del curso, con pistas diferenciadas por condición |
| Requisitos | Diagnóstico del Encuentro 1 resuelto; manejo básico de terminal y editor |
| Lugar | Aula de informática con VS Code y SDK .NET 6 |

## Acuerdo pedagógico

| Dimensión | Grupo de intensificación (recuperación pedagógica) | Grupo de fortalecimiento (profundización) |
|---|---|---|
| **Contenidos** | Lógica de programación: variables, tipos de datos, condicionales (`if`/`else`), bucles (`for`, `while`), estructura de un programa en C# (namespace, class, Main). Pseudocódigo como puente al código real. | Extensión de algoritmos: composición de condicionales anidados, bucles con bandera, recorrido de colecciones básicas (`int[]`), introducción a funciones con retorno. |
| **Actividad / metodología** | Ejercicios guiados de lógica en pseudocódigo y C#: leer datos, decidir con `if`, repetir con `for`. Corrección paso a paso en la computadora. | Desafíos de programación sin base de datos: ordenar un arreglo, validar un patrón, generar secuencias. Resolución autónoma con revisión entre pares. |
| **Recursos** | VS Code, `dotnet new console`, guía impresa de pseudocódigo, ejemplos resueltos para comparar. | VS Code, `dotnet new console`, consignas de desafío, acceso a MSDN / docs.microsoft.com para consulta. |

## Desarrollo del Encuentro 2

### Apertura conjunta (20 min)

Plenaria: el docente presenta los resultados del diagnóstico del Encuentro 1 y explica la organización en dos pistas. Cada estudiante recibe su asignación de grupo. Se recuerdan los objetivos del momento: nivelar saberes previos para arrancar las unidades con base firme.

### Pista intensificación (120 min + 80 min complementarios)

1. **(45 min)** Repaso de variables y tipos: declaración, asignación, operadores aritméticos y lógicos. Ejercicio: escribir un programa que calcule el promedio de tres notas ingresadas por consola.
2. **(45 min)** Condicionales: `if`, `else if`, `else`. Ejercicio: determinar si un número es par o impar y si es positivo, negativo o cero.
3. **(30 min)** Bucles: `for` y `while`. Ejercicio: mostrar la tabla de multiplicar de un número ingresado.
4. **(80 min — complementario)** Actividad integradora: combinar bucle y condicional para contar cuántos números de una secuencia ingresada son pares.

### Pista fortalecimiento (120 min + 80 min complementarios)

1. **(40 min)** Condicionales compuestos y operadores lógicos. Ejercicio: validar si un año es bisiesto según la regla completa.
2. **(40 min)** Bucles con bandera y `break`. Ejercicio: adivinar un número secreto con pistas de mayor/menor.
3. **(40 min)** Primer contacto con arreglos: declarar, recorrer con `foreach`, sumar elementos.
4. **(80 min — complementario)** Desafío: encontrar el segundo valor más grande de un arreglo sin ordenar.

### Cierre conjunto (20 min)

Puesta en común de una resolución de cada pista. El docente destaca los errores típicos (off-by-one, tipo de dato incorrecto, condición invertida) y anticipa que en el próximo encuentro se conectará esto con la escritura de endpoints GET.

---

## Desarrollo del Encuentro 3

### Apertura conjunta (20 min)

Repaso rápido: ¿qué aprendimos en el encuentro anterior? El docente escribe en vivo un programa corto que usa bucle y condicional, y pregunta dónde pueden aparecer esos mismos patrones en una API web.

### Pista intensificación (120 min + 80 min complementarios)

1. **(45 min)** Funciones: declaración con `static`, parámetros, retorno. Ejercicio: escribir una función `EsPar` que reciba un entero y devuelva `bool`, y usarla en `Main`.
2. **(45 min)** Refactorizar los ejercicios del encuentro anterior dentro de funciones. Separar responsabilidades (lectura, cálculo, salida).
3. **(30 min)** Introducción a `Console.ReadLine()` y conversión de tipos (`int.Parse`). Ejercicio completo: menú con opciones (1. Par/impar, 2. Tabla, 3. Salir).
4. **(80 min — complementario)** Ampliar el menú con una opción que calcule el factorial de un número usando un bucle.

### Pista fortalecimiento (120 min + 80 min complementarios)

1. **(40 min)** Funciones con múltiples parámetros y retorno de tuplas. Ejercicio: función que devuelva min y max de un arreglo.
2. **(40 min)** Recursión simple: calcular factorial o Fibonacci por recurrencia.
3. **(40 min)** `StringBuilder` y manipulación de cadenas: reemplazar caracteres, convertir a mayúsculas, invertir cadena.
4. **(80 min — complementario)** Desafío: validar si una palabra es palíndromo usando un bucle y funciones.

### Cierre conjunto (20 min)

Plenaria final: cada grupo comparte una línea de código de la que se sienta orgulloso. El docente conecta los saberes trabajados con lo que viene en la Unidad 1: "Todo esto que escribieron en consola, lo van a escribir como endpoints de una API. La lógica es la misma; cambia la entrada y la salida."

---

## Criterios de logro

| Condición | Criterio |
|---|---|
| Intensificación | El estudiante declara variables con el tipo correcto, escribe condicionales y bucles simples, y estructura un programa C# de consola con funciones. Resuelve al menos 3 de los 4 ejercicios del encuentro 2 y 2 de los 3 del encuentro 3. |
| Fortalecimiento | El estudiante compone condicionales anidados, usa bucles con bandera y arreglos, y escribe funciones con parámetros y retorno. Resuelve los desafíos completos de ambos encuentros. |
| Ambos grupos | Participa de las plenarias de apertura y cierre, y puede explicar con sus palabras la relación entre un programa de consola y una API web. |