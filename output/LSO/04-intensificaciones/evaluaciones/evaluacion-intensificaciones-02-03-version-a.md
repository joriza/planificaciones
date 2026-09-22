# Evaluación — Intensificación y fortalecimiento de saberes previos — Versión A

## Metadatos

| Campo | Valor |
|---|---|
| Versión | A |
| Dominio de datos | Sueldos de empleados (dominio numérico) |
| Duración | 120 min |
| Tipo de evaluación | Por objetivo mínimo — Apto / No apto aún |

## Consigna

Creá un programa de consola en C# (`dotnet new console`) que resuelva los siguientes puntos. Trabajá de forma individual.

### Datos de ejemplo

```csharp
// Lista de sueldos de 6 empleados (en pesos)
double[] sueldos = { 85000, 120000, 65000, 95000, 110000, 72000 };
```

### Requisitos

1. Declará una variable `string` para el nombre de la empresa y una variable `int` para la cantidad de empleados. Mostralas en consola con `Console.WriteLine`.

2. Calculá el sueldo promedio del plantel usando un bucle `for` que recorra el arreglo. Mostrá el resultado con dos decimales.

3. Determiná con un condicional `if/else` si cada empleado cobra más o menos que el promedio. Mostralo en pantalla así:
   ```
   Empleado 1: $85000 — debajo del promedio
   Empleado 2: $120000 — arriba del promedio
   ```

4. Escribí una función `static double CalcularBonificacion(double sueldo)` que devuelva un 10 % del sueldo si este es menor a $100000, o un 5 % si es igual o mayor. Usá la función para mostrar la bonificación de cada empleado.

5. Pedí al usuario que ingrese un nuevo sueldo por consola, convertilo a `double` y agregalo al arreglo (simulado en un nuevo bucle). Mostrá el nuevo promedio.

6. El programa completo debe compilar y ejecutarse sin errores. Usá comentarios en español para marcar cada sección.