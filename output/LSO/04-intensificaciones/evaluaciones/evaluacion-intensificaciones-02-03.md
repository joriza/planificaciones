# Evaluación — Intensificación y fortalecimiento de saberes previos (Encuentros 2–3)

## Metadatos

| Campo | Valor |
|---|---|
| Momento | Intensificación y fortalecimiento de saberes previos |
| Encuentros | 2 y 3 |
| Duración | 120 min |
| Tipo de evaluación | Por objetivo mínimo — Apto / No apto aún |
| Cantidad de versiones | 2 (A y B) |
| Destinatarios | Totalidad del curso |
| Requisitos | Haber participado de los encuentros 2 y 3; conocer variables, condicionales, bucles y funciones en C# de consola |
| Lugar | Aula de informática con VS Code y SDK .NET 6 |

## Descripción general

Esta evaluación comprueba que cada estudiante ha alcanzado los objetivos mínimos de los encuentros de nivelación. Cada estudiante recibe la versión A o la versión B (mismos objetivos, distinto dominio de datos). Resuelve de forma individual en la computadora con `dotnet new console`.

## Criterios de evaluación

Se evalúa cada objetivo de forma independiente. El resultado general es **Apto** si todos los objetivos están logrados; **No apto aún por objetivo mínimo** si falta al menos uno, y se detalla cuál(es).

| # | Objetivo mínimo | Logrado | No logrado |
|---|---|---|---|
| 1 | Declara variables con el tipo correcto (`int`, `string`, `bool`, `double`) y realiza operaciones aritméticas/lógicas | ☐ | ☐ |
| 2 | Escribe condicionales (`if`/`else`) para tomar decisiones sobre los datos | ☐ | ☐ |
| 3 | Usa bucles (`for` o `while`) para procesar colecciones de datos | ☐ | ☐ |
| 4 | Declara funciones con parámetros y valor de retorno (`static`) | ☐ | ☐ |
| 5 | Lee datos ingresados por consola (`Console.ReadLine`) y los convierte al tipo adecuado (`int.Parse`, `double.Parse`) | ☐ | ☐ |
| 6 | Estructura un programa C# de consola completo que resuelve una situación problemática | ☐ | ☐ |

## Guía de corrección (docente)

Cada estudiante entrega su archivo `Program.cs` (o muestra el código en pantalla y lo ejecuta). El docente marca cada objetivo en la tabla según lo observado.

**Versión A — dominio numérico:** empleados, sueldos, bonificaciones.
**Versión B — dominio textual:** estudiantes, calificaciones, promociones.

Para aprobar un objetivo, el código debe:
1. Usar el tipo correcto para cada variable.
2. La condición debe estar correctamente escrita y cubrir los casos pedidos.
3. El bucle debe iterar la cantidad correcta de veces y acumular/modificar los valores según corresponda.
4. La función debe estar declarada fuera de `Main` (con `static`), tener los parámetros pedidos y devolver el tipo indicado.
5. La lectura debe usar `Console.ReadLine` con el mensaje adecuado y la conversión debe manejarse (al menos con `int.Parse` o `double.Parse`).
6. El programa debe compilar, ejecutar sin errores y producir la salida esperada para los datos de ejemplo provistos.

No se exige manejo de excepciones (`try-catch`). Si el programa falla por formato de entrada inválido, el objetivo 5 se marca como no logrado y se permite corregirlo durante la evaluación.