# Encuentro 7 — Bucles for y while

> 1 — Fundamentos de Python y control del flujo

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 7 de 36 |
| Unidad | 1 — Fundamentos de Python y control del flujo |
| Eje temático | 1 — Fundamentos del lenguaje Python |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 120 minutos (2 horas reloj) |
| Concepto nuevo | Bucles `for` sobre `range()` y strings; bucle `while` con condición de corte; contadores y acumuladores |
| Requisitos previos | Encuentro 6: `if`/`elif`/`else`, operadores de comparación y lógicos, `try/except ValueError` |
| Uso de celular | No permitido |
| Organización del trabajo | Individual, con variaciones en dúo para el ejercicio de extensión |

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

1. Repetir acciones una cantidad conocida de veces con `for` y `range()`.
2. Recorrer un string carácter por carácter con `for`.
3. Repetir hasta que se cumpla una condición con `while`.
4. Usar contadores (contar repeticiones) y acumuladores (sumar o promediar valores).

## 3. Teoría mínima (20 min)

### Charla rápida: la vuelta al circuito

Imagá que tenés que correr 5 vueltas a una pista. No escribís "doy una vuelta" cinco veces: contás las vueltas con un número y cuando llegás a 5 terminás. El bucle `for` es como ese contador automático: sabés de antemano cuántas vueltas dar. El bucle `while` es distinto: es como esperar el colectivo — no sabés cuánto va a tardar, solo repetís "¿llegó?" hasta que efectivamente llegue.

### Lo mínimo indispensable

**for sobre range().** `range(n)` genera números de 0 a n-1. Con `for` iteramos sobre cada uno:

```python
# Muestra los numeros del 0 al 4
for i in range(5):
    print(i)

# range(inicio, fin, paso)
print("Del 2 al 8, de a 2:")
for i in range(2, 9, 2):
    print(i)
```

**for sobre strings.** Un string es una secuencia de caracteres. Podés recorrerlo con `for`:

```python
name = "Ana"
for letter in name:
    print(letter)
# A
# n
# a
```

**Contadores y acumuladores.** Patrones fundamentales:

```python
# Contador: cuenta cuantas veces pasa algo
count = 0
for i in range(10):
    if i % 2 == 0:
        count = count + 1
print(f"Pares del 0 al 9: {count}")

# Acumulador: suma valores
total = 0
for i in range(1, 6):
    total = total + i
print(f"Suma del 1 al 5: {total}")
```

**while.** Se ejecuta mientras la condición sea `True`. Hay que asegurarse de que la condición cambie dentro del bloque, o el bucle nunca termina:

```python
# Cuenta regresiva con while
countdown = 5
while countdown > 0:
    print(countdown)
    countdown = countdown - 1   # sin esta linea, el bucle es infinito
print("Despegue!")
```

**while True con break.** Es común usarlo para validar entrada:

```python
while True:
    try:
        age = int(input("Edad: "))
        if age > 0:
            break
        print("La edad debe ser positiva.")
    except ValueError:
        print("Eso no es un numero.")
```

## 4. Práctica guiada (35 min)

Escribamos un programa `suma_rango.py` que pida dos números (inicio y fin) y calcule la suma de todos los enteros entre ellos (inclusive).

```python
# Suma todos los enteros entre inicio y fin (inclusive)

# Validacion del inicio
while True:
    try:
        start = int(input("Ingresa el numero de inicio: "))
        break
    except ValueError:
        print("Eso no es un numero entero.")

# Validacion del fin
while True:
    try:
        end = int(input("Ingresa el numero de fin: "))
        break
    except ValueError:
        print("Eso no es un numero entero.")

# Acumulador: suma todos los numeros del rango
total = 0
for num in range(start, end + 1):
    total = total + num

print(f"La suma de {start} a {end} es {total}.")
```

**Salida esperada:**

```
Ingresa el numero de inicio: 1
Ingresa el numero de fin: 5
La suma de 1 a 5 es 15.

Ingresa el numero de inicio: 10
Ingresa el numero de fin: 10
La suma de 10 a 10 es 10.
```

Ahora modifiquen el programa:
1. Cuenten cuántos números hay entre inicio y fin (pista: ya lo saben con `end - start + 1`).
2. Sumen solo los pares (usen `% 2 == 0` adentro del `for`).
3. Muestren la cantidad de pares y la cantidad de impares encontrados.

## 5. Ejercicio independiente (25 min)

**Consigna:** Escribí un programa `adivina.py` que elija un número secreto fijo (por ejemplo 7) y le pida al usuario que adivine. El programa da pistas ("más alto", "más bajo") y cuenta cuántos intentos usó. Cuando acierta, muestra un mensaje de felicitaciones con la cantidad de intentos.

Requisitos:
- El número secreto se asigna como variable al inicio (`secret = 7`).
- El programa usa un `while` que sigue hasta que el usuario acierta.
- Validación con `try/except ValueError`.
- Contador de intentos.

**Pista:** el `while` se corta cuando la entrada del usuario es igual al secreto. Usá un contador `attempts = 0` y sumale 1 en cada vuelta.

## 6. Extensión y consolidación (20 min)

Si terminaste el juego de adivinar, probá estas variaciones:

1. **Rango variable.** Al iniciar el programa, pedí un límite inferior y superior. El número secreto se calcula con `(limite_inferior + limite_superior) // 2` (la mitad del rango, siempre entero).
2. **Contar vocales.** Pedí una palabra y contá cuántas vocales tiene (a, e, i, o, u). Recorrela con `for letter in word:`.
3. **Tabla de multiplicar.** Pedí un número y mostrá su tabla del 1 al 10 con un `for`. Cada línea: `"5 x 3 = 15"`.

## 7. Cierre (10 min)

### Qué te llevás

- `for` itera sobre una secuencia: `range(n)` da 0 a n-1, `range(inicio, fin, paso)` da control preciso.
- `while` repite mientras la condición sea `True`; si la condición nunca cambia, es un bucle infinito.
- Los contadores aumentan de 1 en 1 (`count = count + 1`); los acumuladores suman valores (`total = total + valor`).
- `while True` con `break` adentro es el patrón estándar para validar entrada hasta que sea correcta.

### Lo que viene

En el **Encuentro 8 — Cierre U1: repaso y TP** vamos a cerrar la Unidad 1 con un repaso general y el trabajo sobre el TP-U1. También vamos a aprender el ciclo completo de entrega con Git y GitHub, que vas a usar para el resto del curso.

## 8. Errores comunes y trampas

| Error | Causa | Fix |
| --- | --- | --- |
| Bucle infinito: `while intentos < 5:` sin modificar `intentos` adentro | La condición nunca cambia; Python no corta solo | Agregar `intentos = intentos + 1` dentro del bloque |
| `for i in range(1, 5)` espera que incluya el 5 | `range(1, 5)` genera 1, 2, 3, 4; el fin es exclusivo | Usar `range(1, 6)` para incluir el 5 |
| Usar `for i in range(5):` y después tratar a `i` como el valor acumulado | `i` toma cada valor de la secuencia, no es un acumulador | Usar una variable separada como `total = total + i` |
| Olvidar la conversión en `int(input(...))` dentro de un `while True` | `input()` siempre devuelve `str`; la comparación numérica falla | Convertir apenas se lee: `int(input(...))` |
| `while True:` sin `break` en ninguna rama | El bucle no tiene salida | Agregar `break` cuando la condición de corte se cumple |
| `total = total + 1` cuando querés contar pasos | `total = total + 1` cuenta (contador), `total = total + valor` acumula (acumulador) | Usar `count = count + 1` para contar, y otra variable para sumar valores |
