# Anexo docente — Encuentro 6: Condicionales y operadores

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

**Consigna:** `bisiesto.py` — determinar si un año es bisiesto.

```python
# Determina si un anio es bisiesto

# Validacion de entrada
while True:
    try:
        year = int(input("Ingresa un anio: "))
        if year > 0:
            break
        else:
            print("El anio debe ser positivo.")
    except ValueError:
        print("Eso no es un numero entero.")

# Regla de bisiesto:
# Divisible por 4 Y no divisible por 100, O divisible por 400
if (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0):
    print(f"El anio {year} es bisiesto.")
else:
    print(f"El anio {year} no es bisiesto.")
```

**Salida verificada:**

| Entrada | Salida |
|---|---|
| `2024` | `El anio 2024 es bisiesto.` |
| `1900` | `El anio 1900 no es bisiesto.` |
| `2000` | `El anio 2000 es bisiesto.` |
| `2025` | `El anio 2025 no es bisiesto.` |
| `texto` | `Eso no es un numero entero.` (hasta que escribe algo válido) |
| `0` | `El anio debe ser positivo.` (vuelve a pedir) |

## 2. Solución de la actividad de extensión

### 2.1 Tres números — encontrar el mayor
```python
# Encuentra el mayor de tres numeros
a = float(input("Numero 1: "))
b = float(input("Numero 2: "))
c = float(input("Numero 3: "))

if a >= b and a >= c:
    greatest = a
elif b >= a and b >= c:
    greatest = b
else:
    greatest = c

print(f"El mayor es {greatest}")
```

### 2.2 Día de la semana
```python
# Día de la semana a partir de un numero
day_num = int(input("Numero del dia (1-7): "))

if day_num == 1:
    day_name = "Lunes"
elif day_num == 2:
    day_name = "Martes"
elif day_num == 3:
    day_name = "Miercoles"
elif day_num == 4:
    day_name = "Jueves"
elif day_num == 5:
    day_name = "Viernes"
elif day_num == 6:
    day_name = "Sabado"
elif day_num == 7:
    day_name = "Domingo"
else:
    day_name = "invalido"

print(f"Dia: {day_name}")
```

### 2.3 Calculadora simple
```python
# Calculadora con dos numeros y una operacion
a = float(input("Primer numero: "))
b = float(input("Segundo numero: "))
op = input("Operacion (+, -, *, /): ")

if op == "+":
    result = a + b
elif op == "-":
    result = a - b
elif op == "*":
    result = a * b
elif op == "/":
    if b == 0:
        print("No se puede dividir por cero.")
    else:
        result = a / b
        print(f"Resultado: {result}")
else:
    print("Operacion no valida.")
```

## 3. Respuesta esperada del ejercicio

### Programa `bisiesto.py`
Verificar que:
- La validación con `try/except ValueError` está presente.
- La condición de bisiesto usa `and` y `or` correctamente.
- La salida usa f-strings.

## 4. Criterios de corrección (lista de verificación)

| ✔ | Criterio | Puntos sugeridos |
|---|---|---|
| ☐ | El archivo se llama `bisiesto.py` | 0,5 |
| ☐ | Validación de entrada con `try/except ValueError` | 1,5 |
| ☐ | Validación de año positivo (if year > 0) | 1 |
| ☐ | Implementa la regla de bisiesto con `%`, `and`, `or`, `not` | 3 |
| ☐ | Muestra resultado con f-string | 1 |
| ☐ | Incluye comentarios | 0,5 |
| ☐ | El programa corre sin errores | 1 |
| ☐ | **Total** | **8,5** |

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
|---|---|---|
| Condición escrita como `if year % 4 == 0 and year % 100 != 0 or year % 400 == 0` sin paréntesis (funciona por precedencia) | Confianza en la precedencia sin entender `and` antes que `or` | Preguntar: "¿Qué evalúa primero Python?" Probar con `True or True and False` en pizarrón. |
| `if a > b > c` que no funciona como esperan | En matemática funciona, pero muchos creen que Python lo interpreta igual | Mostrar que `a > b > c` sí funciona en Python como comparación encadenada, pero para este caso conviene `and`. |
| Escribe `elif:` sin condición | Creencia de que `elif` no lleva condición (como `else`) | Recordar que `elif` necesita una condición y dos puntos: `elif condicion:`. |
| Validación sin `while True`: el programa se cierra tras un error | Solo atrapa la excepción pero no repite | Mostrar el patrón `while True:` + `try` + `break`. |
| Usa `= =` (con espacio) en vez de `==` | Error de tipeo | `= =` es `SyntaxError`. Señalar que no debe haber espacio entre los dos signos. |
| `if year % 400 == 0` sin paréntesis pero funciona | Precedencia correcta, pero hay que entenderla | Explicar que `%` tiene más prioridad que `==`. |

## 6. Registro de la clase

| Aspecto | Qué registrar |
|---|---|
| Comprensión de `and`/`or` | ¿Entienden la diferencia? ¿Usan condiciones compuestas o dividen en `if` anidados? |
| Errores con `==` vs `=` | Es el error clásico. Registrar cuántos lo cometen y si lo autocorrigen. |
| Validación con `try/except` | Es el primer contacto. ¿Lo aplican o lo omiten? |
| Para la evaluación de proceso | Alumnos que ya construyen condiciones complejas solos vs. los que necesitan guía paso a paso. |