# Encuentro 5: Estructuras de control y métodos

## Datos del encuentro

| Campo | Valor |
|---|---|
| Unidad | U1: Fundamentos de C# y Minimal API |
| Encuentro | 5 de 8 |
| Duración | 240 minutos |
| Carácter | Procedimental |

## Objetivos de aprendizaje

- Escribir funciones con `void` y parámetros nombrados.
- Usar `if` para mostrar información condicional según el valor de una variable.
- Recorrer una lista de pacientes con un bucle `foreach`.
- Declarar una lista de registros usando un tipo `record`.

## Reparto de tiempos (240 minutos)

| Bloque | Minutos |
|---|---|
| Apertura y motivación | 20 |
| Desarrollo teórico-práctico | 120 |
| Consolidación y cierre | 20 |
| Actividad complementaria | 80 |

## Charla rápida

En el encuentro anterior escribimos datos fijos para un solo paciente. Ahora vamos a necesitar atender a varios pacientes en la sala de espera. Un método es como una receta que se escribe una vez y se aplica a cada persona que llega. Un `if` es como un cartel que dice "solo mujeres a la izquierda, solo varones a la derecha". Un bucle `foreach` es el asistente que repite la misma acción para cada paciente de la lista.

## Teoría mínima

### Métodos (funciones)

Un método agrupa una secuencia de instrucciones que se pueden reutilizar:

```csharp
void MostrarPaciente(long id, string nombre, string apellido)
{
    Console.WriteLine($"ID: {id} - {nombre} {apellido}");
}
```

Se llama por su nombre: `MostrarPaciente(1, "Ana", "Lopez");`.

### Condicional `if`

Ejecuta un bloque solo si una condición es verdadera:

```csharp
if (gender == "F")
{
    Console.WriteLine("Genero: Femenino");
}
```

Operadores de comparación: `==` (igual), `!=` (distinto).

### Bucle `foreach`

Recorre todos los elementos de una lista:

```csharp
foreach (var p in patients)
{
    MostrarPaciente(p.PatientId, p.FirstName, p.LastName);
}
```

### Record posicional

Un tipo que agrupa varios valores en una misma estructura. Se declara SIEMPRE al final del archivo, después de `app.Run()` (cuando haya API). Por ahora con `dotnet new console` los records van al final del archivo igual:

```csharp
record Patient(long PatientId, string FirstName, string LastName, string Gender, string BirthDate);
```

## Práctica guiada: método y condicional

Partimos del proyecto `hospital-app` del encuentro anterior. Convertimos los datos sueltos en una lista de pacientes y escribimos un método para mostrar cada uno.

**Paso 1:** reemplazar `Program.cs` con:

```csharp
// Definir la lista de pacientes con datos fijos (sin BD)
var patients = new List<Patient>
{
    new Patient(1, "Ana", "Lopez", "F", "1990-05-15"),
    new Patient(2, "Luis", "Martinez", "M", "1985-08-22"),
    new Patient(3, "Elena", "Garcia", "F", "1978-12-03")
};

// Metodo para mostrar un paciente en consola
void PrintPatient(long id, string firstName, string lastName, string gender, string birthDate)
{
    Console.Write($"ID: {id} | {firstName} {lastName} ");
    if (gender == "F")
    {
        Console.Write("(Femenino)");
    }
    else
    {
        Console.Write("(Masculino)");
    }
    Console.WriteLine($" | Nac: {birthDate}");
}

// Recorrer la lista y mostrar cada paciente
Console.WriteLine("=== Lista de pacientes ===");
foreach (var p in patients)
{
    PrintPatient(p.PatientId, p.FirstName, p.LastName, p.Gender, p.BirthDate);
}

// Definir el record al final del archivo
record Patient(long PatientId, string FirstName, string LastName, string Gender, string BirthDate);
```

**Paso 2:** ejecutar:

```bash
dotnet run
```

Salida esperada:

```
=== Lista de pacientes ===
ID: 1 | Ana Lopez (Femenino) | Nac: 1990-05-15
ID: 2 | Luis Martinez (Masculino) | Nac: 1985-08-22
ID: 3 | Elena Garcia (Femenino) | Nac: 1978-12-03
```

> **Nota:** `Console.Write` (sin `Line`) no agrega un salto de línea al final, permitiendo acumular texto en el mismo renglón.

## Ejercicio independiente: agregar columna de edad

Calcular la edad aproximada con `DateTime.Parse` y mostrar el texto `"Edad: NN anios"` al final del método `PrintPatient`.

**Pista:** usar `DateTime.Parse(birthDate)` para obtener la fecha, luego `DateTime.Today.Year - fecha.Year` para los años. Restar un año si el cumpleaños aún no ocurrió este año.

**Solución esperada:**

Agregar al método `PrintPatient`, antes de cerrar la línea:

```csharp
var fechaNac = DateTime.Parse(birthDate);
int edad = DateTime.Today.Year - fechaNac.Year;
if (DateTime.Today < fechaNac.AddYears(edad))
{
    edad--;
}
Console.Write($" | Edad: {edad} anios");
```

La salida entonces será:

```
ID: 1 | Ana Lopez (Femenino) | Nac: 1990-05-15 | Edad: 35 anios
```

### Qué te llevás

- Los métodos agrupan código que se repite.
- `if` y `else` eligen un camino según una condición.
- `foreach` recorre una lista.
- Los records posicionales van siempre al final del archivo.

### Lo que viene

En el Encuentro 6 este programa de consola se convierte en una Minimal API: los datos de los pacientes dejan la consola y viajan por HTTP como JSON desde el primer endpoint GET.

## Errores comunes y trampas

| Error | Causa | Solución |
|---|---|---|
| Record al inicio del archivo | C# exige que las top-level statements precedan a las declaraciones de tipos. | Escribir el record al final, después de todo el código ejecutable. |
| Olvidar `new` en `new List<Patient>` | La lista debe instanciarse con `new`. | Escribir `new List<Patient> { ... }`. |
| Confundir `=` con `==` | `=` asigna, `==` compara. | En `if` usar `==`. |
| Paréntesis de más o de menos en `if` | La condición va entre paréntesis: `if (x == 1)`. | Revisar que no falten ni sobren paréntesis. |
| Fecha sin `DateTime.Parse` | Comparar strings directamente no da la diferencia de años. | Convertir con `DateTime.Parse` antes de calcular la edad. |