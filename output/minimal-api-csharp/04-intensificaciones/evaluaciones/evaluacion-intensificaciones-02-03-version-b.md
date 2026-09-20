# Evaluación — Intensificación y fortalecimiento de saberes previos — Versión B

## Metadatos

| Campo | Valor |
|---|---|
| Versión | B |
| Dominio de datos | Calificaciones de estudiantes (dominio textual) |
| Duración | 120 min |
| Tipo de evaluación | Por objetivo mínimo — Apto / No apto aún |

## Consigna

Creá un programa de consola en C# (`dotnet new console`) que resuelva los siguientes puntos. Trabajá de forma individual.

### Datos de ejemplo

```csharp
// Lista de calificaciones de 6 estudiantes (0 a 10)
double[] notas = { 7.5, 4.0, 8.0, 5.5, 9.0, 6.0 };
string[] nombres = { "Lucia", "Mateo", "Camila", "Lautaro", "Valentina", "Bruno" };
```

### Requisitos

1. Declará una variable `string` para el nombre de la materia y una variable `int` para la cantidad de estudiantes. Mostralas en consola.

2. Calculá el promedio general del curso usando un bucle `for` que recorra el arreglo de notas. Mostrá el resultado con dos decimales.

3. Determiná con un condicional `if/else` si cada estudiante aprueba (nota ≥ 6) o desaprueba. Mostralo así:
   ```
   Lucia: 7.5 — aprueba
   Mateo: 4.0 — desaprueba
   ```

4. Escribí una función `static string CategoriaNota(double nota)` que devuelva "Excelente" si nota ≥ 9, "Bien" si nota ≥ 6, o "A recuperar" si nota < 6. Usá la función para mostrar la categoría de cada estudiante.

5. Pedí al usuario que ingrese una nueva nota por consola, convertila a `double` y mostrá si el nuevo estudiante aprueba o desaprueba usando la función anterior.

6. El programa completo debe compilar y ejecutarse sin errores. Usá comentarios en español para marcar cada sección.