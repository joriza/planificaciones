# Anexo docente — Encuentro 4: Introducción a .NET y C#

## Encuadre

Este es el primer contacto de los estudiantes con .NET y C#. No se espera que comprendan la totalidad del runtime ni la compilación en dos pasos. El objetivo es que escriban y ejecuten su primer programa, declaren variables y vean resultados en la consola. Toda la Unidad 1 trabaja sin base de datos; los datos son literales en el código.

## Qué observar durante la clase

- Dificultad para distinguir `string` de `long`: si declaran `"42"` como string o si intentan asignar `"Ana"` a un long.
- Errores de sintaxis: punto y coma faltante, olvido de `$` en interpolación.
- Confusión al escribir `Console.WriteLine`: mayúsculas, nombre incorrecto.
- Duda sobre qué es un proyecto (la carpeta generada) y qué es un archivo (`Program.cs`).

## Solución completa del ejercicio independiente

```csharp
// Declarar datos de un paciente usando variables
string firstName = "Ana";
string lastName = "Lopez";
string gender = "F";
string birthDate = "1990-05-15";
long patientId = 1;
long weight = 62;
string allergies = "Penicilina";

// Mostrar la informacion en consola
Console.WriteLine("=== Datos del paciente ===");
Console.WriteLine($"ID: {patientId}");
Console.WriteLine($"Nombre: {firstName} {lastName}");
Console.WriteLine($"Genero: {gender}");
Console.WriteLine($"Nacimiento: {birthDate}");
Console.WriteLine($"Peso: {weight} kg");
Console.WriteLine($"Alergias: {allergies}");
```

## Errores previsibles

1. **Omisión del comilla:** el programa imprime `Peso: weight` en lugar de `Peso: 62` porque falta `$`.
2. **Tipo `int` en lugar de `long`:** los cursos anteriores de JavaScript o Python no exigen declaración de tipo; la costumbre de `var` en C# (inferencia) no se enseña aún.
3. **Mayúscula en `dotnet`:** `DOTNET run` o `Dotnet run` fallan.
4. **Ejecutar sin `cd` a la carpeta del proyecto:** `dotnet run` desde la raíz del curso falla porque no encuentra el `.csproj`.

## Criterios de logro (4-8)

| Nivel | Descripción |
|---|---|
| 4 | Declara variables con el tipo correcto pero no logra ejecutar el programa. |
| 5 | Ejecuta el programa y ve la salida; no completa el ejercicio independiente. |
| 6 | Completa el ejercicio independiente; alguna alergia o peso no se muestra. |
| 7 | Ejercicio completo, salida exacta, sin errores de sintaxis. |
| 8 | Explica con sus palabras qué hace cada línea del programa. |

## Agrupamiento

Individual en esta etapa. Cada estudiante trabaja en su propia máquina. El primer proyecto es personal para garantizar que todo el mundo pasa por la creación y ejecución.

## Ajustes para la siguiente edición

- Si más del 40% del grupo no completa el ejercicio en el tiempo previsto, reducir la teoría y dedicar más minutos a la práctica guiada (pasar 10 minutos del bloque teórico al práctico).
- Si el grupo ya tiene experiencia en C#, saltar la analogía de la cocina y profundizar directamente en la sintaxis.