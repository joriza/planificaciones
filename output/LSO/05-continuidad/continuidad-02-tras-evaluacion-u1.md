# Continuidad pedagógica 02 — Tras evaluación de U1

## Datos de referencia

| Campo | Valor |
|-------|-------|
| Curso | Minimal API con C# .NET 6 |
| Momento de uso | Tras la evaluación de U1 (encuentro 9) |
| Duración teórica | 240 minutos (4 horas reloj) |
| Requisitos | Computadora, VS Code, SDK .NET 6, terminal. Archivo `hospital.db` disponible. |

## Objetivos de aprendizaje

1. Repasar los tipos de datos de C# y la declaración de variables para consolidar la base del curso.
2. Reforzar el uso de estructuras de control de flujo (if/else, switch) en la resolución de problemas.
3. Revisar la definición y uso de métodos con parámetros y valores de retorno.
4. Practicar la creación de endpoints GET con `MapGet` en una Minimal API.

## Actividades puntuadas (sobre 100)

### Actividad 1 — Tipos de datos y variables (15 puntos / 40 minutos)

**Consigna:** En una computadora, abrí una consola de C# (o un proyecto de Minimal API) y completá las siguientes tareas.

a) Declará e inicializá variables de cada uno de estos tipos: `long`, `string`, `string?`, `long?`, `int`, `double`. Asignáles valores representativos del contexto hospitalario (por ejemplo, `patientId`, `firstName`, `height`, `weight`).

b) Predicí el resultado de cada una de estas operaciones y luego verificá ejecutando:

```csharp
long patientId = 42;
string firstName = "Carlos";
long? height = 175;
string? city = null;

Console.WriteLine(patientId.GetType().Name);
Console.WriteLine(height.HasValue);
Console.WriteLine(city == null);
```

c) ¿Qué pasa si declarás `int patientId = 42` en lugar de `long`? Ejecutá el código y registrá el error o comportamiento observado.

**Puntos:** 15

---

### Actividad 2 — Control de flujo (20 puntos / 45 minutos)

**Consigna:** En la computadora, escribí un programa que resuelva cada uno de los siguientes enunciados usando `if/else` o `switch`.

a) Dado un número entero `patientId`, escribí un mensaje que indique si el paciente es menor de 18 años (requiere consentimiento), entre 18 y 65 (adulto), o mayor de 65 (adulto mayor). Usá una variable `int age` y probá con tres valores distintos.

b) Escribí un método `string GetSeverity(long heartRate)` que devuelva `"Bajo"` si `heartRate < 60`, `"Normal"` si está entre 60 y 100 inclusive, y `"Alto"` si es mayor a 100. Probá con los valores 55, 75 y 110.

c) ¿Qué sucede si en el inciso b) no incluís un `else` para el caso `"Alto"`? Ejecutá el código y explicá el resultado.

**Puntos:** 20

---

### Actividad 3 — Métodos y funciones (20 puntos / 45 minutos)

**Consigna:** En la computadora, escribí los siguientes métodos dentro de un proyecto de Minimal API o en una consola de prueba.

a) Escribí un método `long CalculateBMI(long weight, long height)` que calcule el IMC usando la fórmula `weight / (height * height) * 10000` (peso en gramos, altura en centímetros, resultado redondeado a entero). Usá `long` para todos los parámetros y el retorno.

b) Escribí un método `bool IsValidPatient(long? height, long? weight)` que devuelva `true` solo si ambos valores no son nulos y son mayores a cero.

c) Llamá ambos métodos desde el `Main` (o desde un endpoint de prueba) con estos datos: peso = 75000 (75 kg), altura = 175 (cm). Mostrá el resultado por consola.

d) ¿Por qué el método de IMC usa `long` y no `double`? ¿Qué pérdida de precisión puede generar esto? Anotá tu respuesta.

**Puntos:** 20

---

### Actividad 4 — Endpoint GET con MapGet (25 puntos / 60 minutos)

**Consigna:** En la computadora, creá un proyecto de Minimal API (`dotnet new web`) que exponga los siguientes endpoints. Usá solo `Program.cs`, Dapper y `hospital.db`.

a) `GET /patients` — retorna la lista completa de pacientes con todos sus campos. Usa `Query<Patient>` y alias `AS` en el SELECT.

b) `GET /patients/{id:long}` — retorna un paciente por ID. Si no existe, devolvé `Results.NotFound` con un mensaje en español.

c) `GET /patients?city={city}` — retorna los pacientes filtrados por ciudad usando `LIKE` con parámetro. Si no se pasa `city`, retorna todos los pacientes.

**Requisitos:**
- El record `Patient` debe ir después de `app.Run()`.
- Toda consulta SQL debe ser parametrizada (`@city`, `@id`).
- Los tipos canónicos deben respetar la convención del curso (`long` para INTEGER, `string?` para nullable).
- Comentarios en español en cada paso del código.

**Puntos:** 25

---

### Actividad 5 — Repaso conceptual (20 puntos / 50 minutos)

**Consigna:** Respondé las siguientes preguntas en papel o en un archivo de texto (sin ejecutar código).

a) ¿Cuál es la diferencia entre `MapGet` y `MapPost`? Explicá con un ejemplo de cada uno.

b) ¿Por qué Dapper requiere alias `AS` en los SELECT cuando los nombres de columna usan snake_case?

c) ¿Qué diferencia hay entre `Query<T>` y `QueryFirstOrDefault<T>`? ¿Cuándo usarías cada uno?

d) ¿Qué código de respuesta HTTP se devuelve cuando un recurso no existe? ¿Y cuando la solicitud tiene datos faltantes?

e) ¿Por qué se usa `ExecuteScalar<long>` en lugar de `ExecuteScalar<int>` para conteos y claves primarias?

**Puntos:** 20

---

## Autoevaluación para el alumno

Antes de la próxima clase, respondé con honestidad las siguientes preguntas. No hay puntos en juego; es una herramienta para que identifiques qué repasar.

- ¿Puedo declarar variables de los tipos canónicos del curso (`long`, `string`, `string?`, `long?`) y explicar por qué no uso `int` para las claves primarias?
- ¿Soy capaz de escribir estructuras `if/else` y `switch` que manejen al menos tres ramas?
- ¿Puedo definir un método con parámetros y valor de retorno, y llamarlo desde un endpoint?
- ¿Sé crear un endpoint `GET` con `MapGet` que use Dapper para consultar la base de datos?
- ¿Entiendo por qué las consultas SQL deben ser siempre parametrizadas?

Si respondiste "no" a alguna de estas preguntas, repasá la actividad correspondiente antes del próximo encuentro.

## Nota de registro académico

la resolución se realiza en forma habitual (por lo general, en grupo); las tareas de programación requieren el uso de la computadora; la presentación es individual y manuscrita, al inicio de la próxima clase, y constituye una actividad más de la asignatura que forma parte del proceso de evaluación.
