# Encuentro 4: Introducción a .NET y C#

## Datos del encuentro

| Campo | Valor |
|---|---|
| Unidad | U1: Fundamentos de C# y Minimal API |
| Encuentro | 4 de 8 |
| Duración | 240 minutos |
| Carácter | Conceptual |

## Objetivos de aprendizaje

- Explicar qué es .NET y cuál es su función como entorno de ejecución.
- Reconocer la estructura básica de un programa en C# con top-level statements.
- Declarar variables usando los tipos `string` y `long`.
- Mostrar información en la consola con `Console.WriteLine`.
- Crear y ejecutar un proyecto de consola con `dotnet new console`.

## Reparto de tiempos (240 minutos)

| Bloque | Minutos |
|---|---|
| Apertura y motivación | 20 |
| Desarrollo teórico-práctico | 120 |
| Consolidación y cierre | 20 |
| Actividad complementaria | 80 |

## Charla rápida

Imaginen que .NET es una cocina industrial: tiene hornos, hornallas, heladeras y un manual de procedimientos. C# es el idioma en el que el chef escribe las recetas. Una receta escrita en C# se le pasa a la cocina .NET, que la ejecuta: precalienta el horno (asigna memoria), corta los ingredientes (declara variables) y sirve el plato (muestra el resultado). Sin la cocina, la receta no se puede ejecutar. Sin la receta, la cocina no sabe qué hacer.

## Teoría mínima

### ¿Qué es .NET?

.NET es un entorno de ejecución (runtime) desarrollado por Microsoft. Provee servicios como administración de memoria, seguridad y bibliotecas de funciones. Un programa escrito en C# se compila a un código intermedio (IL) que .NET ejecuta en cualquier sistema operativo compatible.

### Tipos de datos básicos

En C# toda variable tiene un tipo definido en el momento de declararla. Dos tipos fundamentales para este curso:

| Tipo | Almacena | Ejemplo |
|---|---|---|
| `string` | Texto (cadena de caracteres) | `"Ana Lopez"` |
| `long` | Números enteros grandes (Int64) | `42` |

> **Regla:** los identificadores y rutas se escriben en inglés y en plural. Los comentarios y mensajes al usuario van en español.

### Variables

Se declaran con `tipo nombre = valor;`:

```csharp
string firstName = "Ana";
long patientId = 1;
```

### Mostrar en consola

```csharp
Console.WriteLine("Texto a mostrar");
Console.WriteLine($"El valor es {patientId}");
```

El prefijo `$` permite incrustar variables entre llaves.

## Práctica guiada: crear el primer proyecto

Vamos a crear un proyecto de consola y escribir un programa que muestre datos de un paciente.

**Paso 1:** abrir la terminal en la carpeta del curso y crear el proyecto:

```bash
dotnet new console -o hospital-app
cd hospital-app
```

**Paso 2:** reemplazar el contenido de `Program.cs` con:

```csharp
// Declarar datos de un paciente usando variables
string firstName = "Ana";
string lastName = "Lopez";
string gender = "F";
string birthDate = "1990-05-15";
long patientId = 1;

// Mostrar la informacion en consola
Console.WriteLine("=== Datos del paciente ===");
Console.WriteLine($"ID: {patientId}");
Console.WriteLine($"Nombre: {firstName} {lastName}");
Console.WriteLine($"Genero: {gender}");
Console.WriteLine($"Nacimiento: {birthDate}");
```

**Paso 3:** ejecutar el programa:

```bash
dotnet run
```

Salida esperada:

```
=== Datos del paciente ===
ID: 1
Nombre: Ana Lopez
Genero: F
Nacimiento: 1990-05-15
```

> **Nota:** la fecha viaja como texto. No usar `DateTime` ni `DateOnly`. Se muestra tal cual está guardada.

## Ejercicio independiente: completar la ficha del paciente

Agregar variables para `weight` (long) y `allergies` (string). Declarar los valores `62` y `"Penicilina"`. Mostrarlas al final del bloque con un mensaje como `Peso: 62 kg` y `Alergias: Penicilina`.

**Pista:** declarar las nuevas variables antes del `Console.WriteLine` que muestra el peso y las alergias. Usar el mismo formato `$"..."`.

**Solución esperada:**

```csharp
long weight = 62;
string allergies = "Penicilina";

Console.WriteLine($"Peso: {weight} kg");
Console.WriteLine($"Alergias: {allergies}");
```

## Cierre

**Qué te llevás:** .NET ejecuta programas escritos en C#. Toda variable tiene un tipo fijo. `string` para texto, `long` para números enteros. La consola muestra resultados con `Console.WriteLine`.

**Lo que viene:** en el próximo encuentro vamos a agregar lógica condicional y bucles para manejar varios pacientes, y vamos a escribir nuestras primeras funciones.

## Errores comunes y trampas

| Error | Causa | Solución |
|---|---|---|
| Usar `int` en lugar de `long` | El tipo `int` (Int32) alcanza para números chicos pero el curso exige `long` para consistencia con la base de datos. | Declarar siempre `long` para identificadores y valores enteros grandes. |
| Olvidar el `$` en el string | `$"..."` es necesario para interpolar variables. Sin `$`, la variable se imprime literal. | Agregar `$` al inicio de las comillas dobles. |
| Punto y coma faltante | Cada instrucción en C# termina con `;`. | Revisar que cada línea termine con `;`. |
| Escribir mal el nombre del método | `Console.Writeline` con `L` mayúscula no compila. | C# distingue mayúsculas: `WriteLine` con `W` y `L` mayúscula. |
| Tipo incorrecto al compilar | Asignar un texto a una variable `long` da error de compilación. | Solo asignar números sin comillas a `long`. |