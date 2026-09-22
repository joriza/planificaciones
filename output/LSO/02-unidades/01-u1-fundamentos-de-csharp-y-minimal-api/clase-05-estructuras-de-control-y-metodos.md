# Encuentro 5 — Estructuras de control y métodos

> Unidad 1 — Fundamentos de C# y Minimal API

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 5 de 36 |
| Unidad | 1 — Fundamentos de C# y Minimal API |
| Eje temático | 1 — Introducción a C# y .NET 6 |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 240 minutos (4 horas reloj) |
| Uso de celular | No permitido |
| Concepto nuevo | Estructuras de control y métodos |
| Requisitos previos | Encuentro 4: tipos de datos, variables, estructura de Program.cs |
| Organización del trabajo | Grupos de 3-4 personas; un repositorio compartido por grupo para todo el curso |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y motivación | 20 min |
| Desarrollo teórico-práctico | 120 min |
| Consolidación y cierre | 20 min |
| Actividad complementaria | 80 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

1. Usar condicionales (`if`, `else if`, `else`) para tomar decisiones en un programa C#.
2. Implementar bucles (`for`, `foreach`, `while`) para repetir acciones sobre colecciones.
3. Definir métodos con parámetros y tipo de retorno para organizar el código en bloques reutilizables.
4. Distinguir entre un método que devuelve un valor (`return`) y uno que no devuelve nada (`void`).
5. Aplicar estructuras de control y métodos para resolver un problema simple de lógica.

## 3. Apertura y motivación (20 min)

### Charla rápida: ¿Por qué repetir código es una mala idea?

Si tienen que escribir `Console.WriteLine("Hola")` 100 veces, ¿lo hacen 100 veces? No. Usan un bucle. La programación se trata de encontrar patrones y automatizarlos. Hoy vamos a aprender las herramientas que nos permiten tomar decisiones y repetir acciones sin escribir lo mismo muchas veces.

### Diagnóstico rápido

- Si `edad = 18`, ¿qué pasaría si escribimos `if (edad >= 18) Console.WriteLine("Mayor de edad");`? ¿Qué se imprime?
- ¿Cuántas veces se ejecuta `for (int i = 0; i < 5; i++)`?
- ¿Qué es un método y para qué sirve?

Cada grupo responde en una hoja. Se comparan las respuestas en plenario.

## 4. Desarrollo teórico-práctico (120 min)

### 4.1 Condicionales: `if`, `else if`, `else` (25 min)

Los condicionales permiten que el programa tome decisiones según una condición booleana.

```csharp
int nota = 7;

// Si la nota es mayor o igual a 7, aprobo
if (nota >= 7)
{
    Console.WriteLine("Aprobado");
}
// Si no, pero es mayor o igual a 4, promociona sin final
else if (nota >= 4)
{
    Console.WriteLine("Promocionado sin final");
}
// Si no cumple ninguna condicion anterior, reprueba
else
{
    Console.WriteLine("Reprobado");
}
```

**Salida esperada:** `Aprobado`

**Ejercicio guiado:** Cambiar el valor de `nota` a 5 y verificar que la salida sea `Promocionado sin final`. Luego cambiar a 2 y verificar `Reprobado`.

### 4.2 Bucles `for` y `foreach` (25 min)

El bucle `for` repite una acción un número conocido de veces. El bucle `foreach` recorre cada elemento de una colección.

```csharp
// Bucle for: contar del 1 al 5
for (int i = 1; i <= 5; i++)
{
    Console.WriteLine($"Numero {i}");
}

// Bucle foreach: recorrer una lista de nombres
var nombres = new string[] { "Ana", "Luis", "Maria" };

foreach (var nombre in nombres)
{
    Console.WriteLine($"Hola, {nombre}");
}
```

**Salida esperada:**
```
Numero 1
Numero 2
Numero 3
Numero 4
Numero 5
Hola, Ana
Hola, Luis
Hola, Maria
```

### 4.3 Bucles `while` (15 min)

El bucle `while` repite mientras una condición sea verdadera. Es útil cuando no se sabe de antemano cuántas veces se va a repetir.

```csharp
// Contar hacia atras desde 5 hasta 1
int contador = 5;

while (contador > 0)
{
    Console.WriteLine(contador);
    contador--;
}

Console.WriteLine("Despegue!");
```

**Salida esperada:**
```
5
4
3
2
1
Despegue!
```

### 4.4 Métodos: declarar y llamar (30 min)

Un método es un bloque de código con nombre que se puede llamar desde otro lugar. Puede recibir parámetros y devolver un valor.

```csharp
// Metodo que recibe dos numeros y devuelve su suma
int Sumar(int a, int b)
{
    int resultado = a + b;
    return resultado;
}

// Metodo que no devuelve nada (void) y solo muestra un mensaje
void Saludar(string nombre)
{
    Console.WriteLine($"Hola, {nombre}! Bienvenido.");
}

// Llamar a los metodos desde el programa principal
int suma = Sumar(3, 5);
Console.WriteLine($"La suma es: {suma}");

Saludar("Carlos");
```

**Salida esperada:**
```
La suma es: 8
Hola, Carlos! Bienvenido.
```

**Punto clave:** Los métodos se definen después de `app.Run()` en `Program.cs` cuando se usa top-level statements, o dentro de una clase en proyectos con estructura tradicional. En este curso, para ejemplos simples, se pueden definir como métodos locales dentro del flujo principal.

### 4.5 Combinación de estructuras: resolver un problema (25 min)

Ejemplo completo: un programa que reciba una lista de notas y muestre cuántas son aprobatorias (>= 7) y cuántas desaprobatorias.

```csharp
var notas = new int[] { 8, 4, 6, 9, 5, 7, 3, 10 };
int aprobadas = 0;
int desaprobadas = 0;

foreach (var nota in notas)
{
    if (nota >= 7)
    {
        aprobadas++;
    }
    else
    {
        desaprobadas++;
    }
}

Console.WriteLine($"Aprobadas: {aprobadas}");
Console.WriteLine($"Desaprobadas: {desaprobadas}");
```

**Salida esperada:**
```
Aprobadas: 4
Desaprobadas: 4
```

## 5. Consolidación y cierre (20 min)

- Cada grupo escribe en una hoja: 2 condicionales que usaron, 1 bucle y 1 método que definieron.
- Se comparten las hojas en plenario.
- El docente verifica que todos los grupos puedan explicar qué hace cada estructura.

## 6. Actividad complementaria (80 min)

### Ejercicio independiente: calculadora de notas

Crear un programa en `Program.cs` que:

1. Defina un arreglo de 5 notas enteras (valores entre 1 y 10).
2. Use un bucle `foreach` para recorrer las notas.
3. Use un condicional `if` para clasificar cada nota como aprobada (>= 7) o desaprobada.
4. Defina un método `string ClasificarNota(int nota)` que devuelva `"Aprobado"` o `"Desaprobado"`.
5. Muestre el conteo final de aprobadas y desaprobadas.

**Pista:** El método `ClasificarNota` recibe un `int` y devuelve un `string`. Use `return` dentro del método.

### Solución esperada del docente

```csharp
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

**Salida esperada:**
```
Nota 6: Desaprobado
Nota 8: Aprobado
Nota 5: Desaprobado
Nota 9: Aprobado
Nota 4: Desaprobado

Total aprobadas: 2
Total desaprobadas: 3
```

### Entrega del commit

Al finalizar, cada grupo debe hacer commit de los avances:

```bash
git add .
git commit -m "tp-u1: estructuras de control y metodos agregados"
git push
```

## 7. Cierre (15 min)

### Qué te llevás

- Los condicionales (`if`/`else if`/`else`) permiten tomar decisiones según el valor de una expresión booleana.
- Los bucles (`for`, `foreach`, `while`) repiten acciones sin escribir el mismo código muchas veces.
- Los métodos organizan el código en bloques reutilizables: pueden recibir parámetros y devolver valores con `return`.
- Un método con tipo de retorno `void` no devuelve nada; solo ejecuta una acción.

### Lo que viene

**Encuentro 6: Minimal API y endpoint GET** — Vamos a crear nuestro primer endpoint web con `MapGet` y probarlo en el navegador.

## 8. Errores comunes y trampas

1. **Usar `=` en lugar de `==` en un condicional** — `if (nota = 7)` asigna 7 a `nota` en lugar de comparar. El compilador puede dar un error o un comportamiento inesperado. Siempre usar `==` para comparar.
2. **Olvidar las llaves `{}` en un `if`/`else`** — Si no se usan llaves, solo la primera línea después del condicional pertenece al bloque. Esto genera errores lógicos difíciles de detectar.
3. **Bucle infinito con `while`** — Si la condición nunca se vuelve falsa, el bucle no termina y la app se cuelga. Siempre asegurarse de que la variable de control cambie dentro del bucle.
4. **Definir un método antes de `app.Run()` sin contexto adecuado** — En top-level statements, los métodos locales deben definirse antes de ser llamados, o como métodos de nivel de archivo después de `app.Run()`.
5. **Confundir `return` con `Console.WriteLine`** — `return` sale del método y entrega un valor; `Console.WriteLine` solo muestra texto en consola pero no sale del método.
6. **No incrementar el contador en el bucle `for`** — Olvidar `i++` hace que el bucle se ejecute infinitamente.
