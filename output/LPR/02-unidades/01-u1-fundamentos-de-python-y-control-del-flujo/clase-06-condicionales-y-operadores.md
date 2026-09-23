# Encuentro 6 — Condicionales y operadores

> 1 — Fundamentos de Python y control del flujo

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 6 de 36 |
| Unidad | 1 — Fundamentos de Python y control del flujo |
| Eje temático | 1 — Fundamentos del lenguaje Python |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 120 minutos (2 horas reloj) |
| Concepto nuevo | Operadores de comparación y lógicos (`and`, `or`, `not`); estructura `if` / `elif` / `else` |
| Requisitos previos | Encuentro 5: `input()`, conversión de tipos (`int()`, `float()`), f-strings |
| Uso de celular | No permitido |
| Organización del trabajo | Pares rotativos (programación en dúos, un teclado cada 15 min) |

### Reparto de tiempos

| Momento | Tiempo |
| --- | --- |
| Apertura y puente | 10 min |
| Teoría mínima | 20 min |
| Práctica guiada | 35 min |
| Ejercicio independiente | 25 min |
| Extensión y consolidación | 20 min |
| Cierre | 10 min |
| **Total** | **120 min** |

## 2. Objetivos de aprendizaje

1. Comparar valores usando `==`, `!=`, `<`, `>`, `<=`, `>=` y comprender que cada comparación devuelve `True` o `False`.
2. Combinar condiciones con `and`, `or`, `not` para expresar decisiones compuestas.
3. Escribir estructuras `if` / `elif` / `else` que ejecuten distintos bloques según una condición.
4. Validar entrada numérica con `try/except ValueError` para evitar que el programa se rompa con datos inválidos.

## 3. Teoría mínima (20 min)

### Charla rápida: el semáforo

Un semáforo decide: si está verde, pasás; si está rojo, parás; si está amarillo, preparate. Tu programa necesita hacer lo mismo: **si** el usuario es mayor de edad, mostrá un mensaje; **si no**, mostrá otro. Las condiciones son preguntas de sí o no que el programa evalúa como `True` (verdadero) o `False` (falso). Con `and` y `or` podés hacer preguntas compuestas: "si tiene más de 15 **y** trajo permiso".

### Lo mínimo indispensable

**Operadores de comparación.** Cada comparación devuelve `True` o `False`:

```python
age = 17
print(age == 18)    # False (es igual?)
print(age != 18)    # True  (es distinto?)
print(age < 18)     # True  (es menor que?)
print(age >= 18)    # False (es mayor o igual?)
```

**Operadores lógicos.** Combinan condiciones:

```python
has_license = True
age = 20

# and: ambas deben ser True
print(age >= 18 and has_license)  # True

# or: al menos una debe ser True
has_permission = False
print(age >= 18 or has_permission)  # True

# not: invierte el valor
print(not has_license)  # False
```

**if / elif / else.** La estructura que decide:

```python
age = int(input("Que edad tenes? "))

if age >= 18:
    print("Sos mayor de edad.")
else:
    print("Sos menor de edad.")
```

Con más de dos caminos se usa `elif` (abreviatura de "else if"):

```python
grade = float(input("Nota del examen: "))

if grade >= 8:
    print("Muy bien, aprobaste con excelente.")
elif grade >= 6:
    print("Aprobaste.")
elif grade >= 4:
    print("Aprobaste con lo justo.")
else:
    print("Desaprobaste.")
```

**Validación con try/except.** Si el usuario tipea letras donde esperamos números, `int()` o `float()` lanzan `ValueError`. Para que el programa no se rompa, se atrapa el error y se vuelve a pedir:

```python
while True:
    try:
        age = int(input("Edad: "))
        break          # sale del while si la conversion fue exitosa
    except ValueError:
        print("Eso no es un numero entero; intenta de nuevo.")

# Ahora age es un int seguro
if age >= 18:
    print("Mayor de edad.")
else:
    print("Menor de edad.")
```

## 4. Práctica guiada (35 min)

Escribamos un programa `clasificador_notas.py` que pida una nota, la valide y clasifique al alumno.

```python
# Clasifica una nota numerica en categorias

while True:
    try:
        grade = float(input("Ingresa la nota (0 a 10): "))
        if grade >= 0 and grade <= 10:
            break
        else:
            print("La nota debe estar entre 0 y 10.")
    except ValueError:
        print("Eso no es un numero; intenta de nuevo.")

if grade >= 9:
    category = "Excelente"
elif grade >= 7:
    category = "Bueno"
elif grade >= 5:
    category = "Regular"
elif grade >= 3:
    category = "Insuficiente"
else:
    category = "Malo"

print(f"Nota: {grade:.1f} — Categoria: {category}")
```

**Salida esperada** (varios casos):

```
Ingresa la nota (0 a 10): 8.5
Nota: 8.5 — Categoria: Bueno

Ingresa la nota (0 a 10): once
Eso no es un numero; intenta de nuevo.
Ingresa la nota (0 a 10): 11
La nota debe estar entre 0 y 10.
Ingresa la nota (0 a 10): 4
Nota: 4.0 — Categoria: Insuficiente
```

Ahora modifiquen el programa:
1. Agreguen una condición con `or`: si la nota es menor que 2 o mayor que 9, mostrar un mensaje extra `"Caso extremo"`.
2. Agreguen la categoría "Sobresaliente" para nota 10 exacta (antes que "Excelente").

## 5. Ejercicio independiente (25 min)

**Consigna:** Escribí un programa `bisiesto.py` que pida un año (entero positivo) y determine si es bisiesto o no.

Un año es bisiesto si:
- Es divisible por 4 **y** no es divisible por 100, **o**
- Es divisible por 400.

Usá validación de entrada con `try/except ValueError`. Mostrá el resultado con un f-string.

**Pista:** para saber si un número es divisible por otro, usá el operador `%`. Si el resto es 0, es divisible. Por ejemplo: `anio % 4 == 0`.

## 6. Extensión y consolidación (20 min)

Si terminaste el bisiesto, probá estas variaciones:

1. **Tres números.** Pedí tres números y mostrá cuál es el mayor (sin usar `max()`). Usá `if` anidados o condiciones compuestas.
2. **Día de la semana.** Pedí un número del 1 al 7 y mostrá el nombre del día (lunes=1, domingo=7). Usá `if` / `elif` / `else` (no adelantes `match` ni diccionarios).
3. **Calculadora simple.** Pedí dos números y una operación (`+`, `-`, `*`, `/`). Según la operación, mostrá el resultado. Validá que no se divida por cero.

## 7. Cierre (10 min)

### Qué te llevás

- Las comparaciones (`==`, `!=`, `<`, `>`, `<=`, `>=`) devuelven `True` o `False`.
- `and` exige que todas las condiciones sean `True`; `or` alcanza con una.
- `if` / `elif` / `else` elige qué bloque ejecutar según las condiciones.
- El orden de los `elif` importa: Python ejecuta el primero que da `True`.
- `try/except ValueError` evita que el programa se rompa con entrada inválida.

### Lo que viene

En el **Encuentro 7 — Bucles for y while** vamos a hacer que el programa repita acciones automáticamente con bucles `for` y `while`. Vas a poder recorrer rangos de números, procesar texto caracter por caracter y repetir hasta que se cumpla una condición.

## 8. Errores comunes y trampas

| Error | Causa | Fix |
| --- | --- | --- |
| Poner `=` en vez de `==` en una condición: `if age = 18` | `=` es asignación, no comparación; Python lanza `SyntaxError` | Usar `==` en condiciones: `if age == 18` |
| Condición que nunca se cumple por orden incorrecto | `if grade >= 5` antes de `if grade >= 8`: el primer bloque atrapa notas >= 5 antes de que llegue al de >= 8 | Ordenar de más restrictiva a menos restrictiva |
| Olvidar los dos puntos `:` al final de `if`, `elif` o `else` | Python requiere `:` para abrir el bloque | Escribir `if condicion:` |
| Confundir `and` con `&` o `or` con `|` | `&` y `|` son operadores de bits, no lógicos booleanos | Usar `and` y `or` (palabras) para condiciones |
| Validar con `if edad > 17 and < 65` (falta la variable en la segunda parte) | Cada condición debe ser completa | Escribir `if edad > 17 and edad < 65` |
| `try` sin `except` o `except:` desnudo | El bloque `try` necesita un manejador; `except:` sin tipo atrapa todo, incluso errores que no debería | Usar `except ValueError:` o el tipo específico |
