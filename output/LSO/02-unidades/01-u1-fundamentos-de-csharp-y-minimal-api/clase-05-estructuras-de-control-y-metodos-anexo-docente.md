# Anexo docente — Encuentro 5: Estructuras de control y métodos

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

### Calculadora de notas — solución completa

```csharp
// Program.cs — calculadora de notas con estructuras de control y metodos
// No usa base de datos; ejercicio de logica en consola

var notas = new int[] { 6, 8, 5, 9, 4 };
int aprobadas = 0;
int desaprobadas = 0;

foreach (var nota in notas)
{
    string estado = ClasificarNota(nota);
    Console.WriteLine($"Nota {nota}: {estado}");

    if (estado == "Aprobado")
    {
        aprobadas++;
    }
    else
    {
        desaprobadas++;
    }
}

Console.WriteLine($"\nTotal aprobadas: {aprobadas}");
Console.WriteLine($"Total desaprobadas: {desaprobadas}");

string ClasificarNota(int nota)
{
    return nota >= 7 ? "Aprobado" : "Desaprobado";
}
```

**Salida verificada:**
```
Nota 6: Desaprobado
Nota 8: Aprobado
Nota 5: Desaprobado
Nota 9: Aprobado
Nota 4: Desaprobado

Total aprobadas: 2
Total desaprobadas: 3
```

## 2. Solución de la actividad de extensión

### Ejercicio extendido: promedio de aprobadas

Extensión del ejercicio anterior: calcular el promedio de las notas aprobadas y mostrarlo con dos decimales.

```csharp
var notas = new int[] { 6, 8, 5, 9, 4 };
int aprobadas = 0;
int sumaAprobadas = 0;

foreach (var nota in notas)
{
    if (nota >= 7)
    {
        aprobadas++;
        sumaAprobadas += nota;
    }
}

double promedio = aprobadas > 0 ? (double)sumaAprobadas / aprobadas : 0;

Console.WriteLine($"Cantidad de aprobadas: {aprobadas}");
Console.WriteLine($"Promedio de aprobadas: {promedio:F2}");
```

**Salida esperada:**
```
Cantidad de aprobadas: 2
Promedio de aprobadas: 8.50
```

**Pista para el docente:** La conversión `(double)` es necesaria porque la división de dos `int` en C# hace división entera y trunca el resultado decimal.

## 3. Respuesta esperada del ejercicio

| Pregunta | Respuesta esperada |
| --- | --- |
| ¿Qué hace `if (nota >= 7)`? | Evalúa si la variable `nota` es mayor o igual a 7. Si es verdadero, ejecuta el bloque de código dentro de las llaves. |
| ¿Cuál es la diferencia entre `for` y `foreach`? | `for` se usa cuando se conoce el número de iteraciones y se controla con un índice. `foreach` se usa para recorrer cada elemento de una colección sin manejar un índice manualmente. |
| ¿Qué hace `return` dentro de un método? | Sale del método y entrega el valor especificado al código que llamó al método. |
| ¿Qué es un método `void`? | Un método que no devuelve ningún valor. Solo ejecuta las instrucciones dentro de su bloque. |
| ¿Por qué se usa `aprobadas++`? | Es una forma abreviada de `aprobadas = aprobadas + 1`. Incrementa el contador en 1 cada vez que se encuentra una nota aprobada. |
| ¿Qué pasa si se olvida `i++` en un bucle `for`? | El bucle se ejecuta infinitamente porque la condición de salida nunca se cumple. |

## 4. Criterios de corrección (lista de verificación)

- [ ] El alumno define un arreglo de notas con al menos 5 elementos.
- [ ] Usa un bucle `foreach` para recorrer el arreglo.
- [ ] Usa un condicional `if`/`else` para clasificar cada nota.
- [ ] Define el método `ClasificarNota(int nota)` con tipo de retorno `string`.
- [ ] El método devuelve `"Aprobado"` cuando `nota >= 7` y `"Desaprobado"` en caso contrario.
- [ ] Muestra el conteo final de aprobadas y desaprobadas.
- [ ] El código compila y la salida coincide con la esperada.
- [ ] Los comentarios en el código están en español y no llevan tildes ni eñes.
- [ ] El grupo hizo commit y push al final del encuentro.

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| `if (nota = 7)` en lugar de `if (nota == 7)` | Confundir asignación (`=`) con comparación (`==`) | Señalar que un solo `=` asigna un valor y `==` compara. El compilador puede dar error si se asigna dentro de un `if` con una constante. |
| El método `ClasificarNota` no devuelve nada | Usar `Console.WriteLine` dentro del método en lugar de `return` | Recordar que un método con tipo de retorno `string` debe tener un `return` con un valor de tipo `string`. |
| Bucle infinito al usar `while` | Olvidar modificar la variable de control dentro del bucle | Verificar que la variable que controla la condición cambie en cada iteración. |
| Las llaves `{}` faltan en el `if` y solo se ejecuta la primera línea | No entender que sin llaves solo la primera línea pertenece al bloque | Mostrar el ejemplo con y sin llaves para que vean la diferencia en la ejecución. |
| `promedio` da un resultado entero sin decimales | Dividir dos `int` sin conversión previa | Explicar que C# hace división entera con operandos enteros. Usar `(double)` para forzar la conversión. |
| No declaran el método `ClasificarNota` antes de llamarlo | En top-level statements, los métodos locales deben definirse antes de ser invocados | Recordar que en C# con top-level statements, los métodos locales deben estar definidos antes de su primer uso en el flujo del programa. |

## 6. Registro de la clase

| Grupo | Presentes | Participación en apertura | Uso correcto de if/else | Uso correcto de bucles | Definición de método | Commit en GitHub | Observaciones |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Grupo 1 | — | — | — | — | — | — | — |
| Grupo 2 | — | — | — | — | — | — | — |
| Grupo 3 | — | — | — | — | — | — | — |
| Grupo 4 | — | — | — | — | — | — | — |

**Notas para evaluación de proceso:**
- Verificar que cada grupo tenga al menos un commit en GitHub al final del encuentro.
- Observar si los grupos pueden ejecutar el programa y obtener la salida correcta.
- Registrar qué grupos lograron la extensión (promedio de aprobadas) sin ayuda.
- Anotar errores frecuentes para abordarlos en el encuentro siguiente.
