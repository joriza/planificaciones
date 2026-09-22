# Anexo docente — Encuentro 5: Estructuras de control y métodos

## Encuadre

Segundo encuentro de la Unidad 1. Los estudiantes ya conocen variables básicas y salida por consola. Ahora incorporan métodos, condicionales, bucles y records. El ejercicio sigue siendo de consola, sin API ni base de datos. La progresión del ejercicio único agrega una lista de pacientes, un método de impresión con formato, cálculo de edad condicional y un record posicional.

## Qué observar durante la clase

- Dificultad para distinguir entre definir un método (`void Nombre(...)`) y llamarlo (`Nombre(...);`).
- Tendencia a declarar el record después de `app.Run()` aun en consola: reforzar que los records van SIEMPRE al final.
- Errores en el cálculo de edad: resta de años sin ajuste por mes, uso de `int` donde deberían usar `long`.
- Confusión en el `foreach`: algunos escriben `foreach var p in patients` sin paréntesis.

## Solución completa del ejercicio independiente

```csharp
// Definir la lista de pacientes con datos fijos
var patients = new List<Patient>
{
    new Patient(1, "Ana", "Lopez", "F", "1990-05-15"),
    new Patient(2, "Luis", "Martinez", "M", "1985-08-22"),
    new Patient(3, "Elena", "Garcia", "F", "1978-12-03")
};

// Metodo para mostrar un paciente con edad calculada
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

    var fechaNac = DateTime.Parse(birthDate);
    int edad = DateTime.Today.Year - fechaNac.Year;
    if (DateTime.Today < fechaNac.AddYears(edad))
    {
        edad--;
    }

    Console.Write($" | Nac: {birthDate}");
    Console.WriteLine($" | Edad: {edad} anios");
}

// Recorrer la lista y mostrar cada paciente
Console.WriteLine("=== Lista de pacientes ===");
foreach (var p in patients)
{
    PrintPatient(p.PatientId, p.FirstName, p.LastName, p.Gender, p.BirthDate);
}

// Record al final del archivo
record Patient(long PatientId, string FirstName, string LastName, string Gender, string BirthDate);
```

## Errores previsibles

1. **Nombre duplicado de método:** si definen dos métodos con el mismo nombre y distinta firma, C# lo permite (overloading), pero confunde a los estudiantes principiantes.
2. **Variable del `foreach` como `string` en lugar de `Patient`:** usar `var` resuelve el tipo; explicar que `var` no es "sin tipo" sino "inferido del contenedor".
3. **Calcular edad con fecha actual fija:** si escriben `DateTime.Parse("2025-01-01")` en lugar de `DateTime.Today`, el resultado queda estático.
4. **Olvidar el ajuste por cumpleaños:** restan años sin verificar si el cumpleaños ya pasó, dando una edad incorrecta.
5. **Usar `Console.WriteLine` cuando quieren `Console.Write`:** la línea del género se corta prematuramente.

## Criterios de logro (4-8)

| Nivel | Descripción |
|---|---|
| 4 | Define el método pero no logra llamarlo dentro del bucle. |
| 5 | Muestra la lista con el método, sin cálculo de edad. |
| 6 | El cálculo de edad compila pero da un año de más o de menos. |
| 7 | Edad exacta, formato correcto, record al final del archivo. |
| 8 | Explica por qué el record va al final y distingue `Console.Write` de `WriteLine`. |

## Agrupamiento

Individual (parejas si hay máquinas insuficientes). Cada estudiante modifica su proyecto propio del encuentro anterior.

## Ajustes para la siguiente edición

- Si la mayoría escribe el record al inicio, agregar una advertencia visual en la pizarra durante la práctica guiada.
- Si el cálculo de edad insume más de 15 minutos, simplificar a solo mostrar el año de nacimiento y diferir el cálculo exacto a actividad complementaria.