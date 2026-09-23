# Encuentro 5 — Entrada y salida por consola

> 1 — Fundamentos de Python y control del flujo

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 5 de 36 |
| Unidad | 1 — Fundamentos de Python y control del flujo |
| Eje temático | 1 — Fundamentos del lenguaje Python |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 120 minutos (2 horas reloj) |
| Concepto nuevo | Entrada con `input()`, salida con `print()`, conversión de tipos (`int()`, `float()`, `str()`), f-strings |
| Requisitos previos | Encuentro 4: tipos básicos (`int`, `float`, `str`, `bool`), operadores aritméticos, comentarios |
| Uso de celular | No permitido |
| Organización del trabajo | Individual con monitores rotativos: un compañero observa mientras el otro escribe |

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

1. Capturar datos del usuario con `input()` y entender que siempre devuelve texto (`str`).
2. Convertir texto a número con `int()` y `float()` dentro de un `try/except ValueError`.
3. Armar mensajes de salida con f-strings en vez de concatenar con `+`.
4. Mostrar valores numéricos con formato en pantalla usando f-strings.

## 3. Teoría mínima (20 min)

### Charla rápida: el programa que escucha

Hasta ahora el programa hablaba pero no escuchaba. Es como un recepcionista que dice siempre la misma frase sin preguntar tu nombre. Con `input()` el programa hace una pausa, lee lo que el usuario escribe y lo guarda en una variable. Pero hay una trampa: `input()` siempre devuelve texto, aunque el usuario haya tipeado un número. Si querés sumar, primero tenés que convertir ese texto a número con `int()` o `float()`.

### Lo mínimo indispensable

**Leer datos con `input()`.** La función `input()` muestra un mensaje (opcional) y espera que el usuario escriba algo y presione Enter. Lo que sea que escriba, lo devuelve como texto (`str`).

```python
# input() siempre devuelve str
name = input("Como te llamas? ")
print("Hola,")
print(name)
```

**Convertir tipos.** Si el usuario tipea `"17"`, eso es texto, no número. Para poder hacer cuentas hay que convertirlo:

```python
age_text = input("Cuantos anios tenes? ")
age = int(age_text)      # convierte "17" -> 17
next_year = age + 1
print("El anio que viene vas a tener:")
print(next_year)
```

Pero si el usuario tipea algo que no se puede convertir (por ejemplo `"diecisiete"`), `int()` lanza un error `ValueError` y el programa se rompe. Vamos a ver cómo manejarlo desde el Encuentro 6; por ahora conviene tipear bien los datos.

**f-strings.** Armar mensajes con `print("Edad:", age)` funciona, pero es más cómodo usar f-strings: ponés una `f` antes de las comillas y escribís las variables entre llaves `{}`:

```python
name = input("Como te llamas? ")
age = int(input("Cuantos anios tenes? "))

# f-string: las variables van entre {}
print(f"Hola {name}, el anio que viene vas a tener {age + 1} anios.")
```

Las f-strings también permiten dar formato a números:

```python
price = 1250.5
# :.2f muestra 2 decimales
print(f"El precio es ${price:.2f}")
```

## 4. Práctica guiada (35 min)

Vamos a escribir un programa `calculadora_edad.py` que lea el nombre y el año de nacimiento del usuario y calcule su edad aproximada.

```python
# Calcula la edad aproximada a partir del anio de nacimiento
# Usa el anio actual como valor fijo (despues vamos a mejorarlo)

# Entrada de datos
name = input("Como te llamas? ")
birth_year_text = input("En que anio naciste? ")

# Conversion de str a int
birth_year = int(birth_year_text)

# Anio actual (fijo para el ejemplo)
current_year = 2024

# Calculo
age = current_year - birth_year

# Salida con f-string
print(f"Hola {name}, este anio cumplis (o ya cumpliste) {age} anios.")
```

**Salida esperada** (con datos de ejemplo):

```
Como te llamas? Martina
En que anio naciste? 2007
Hola Martina, este anio cumplis (o ya cumpliste) 17 anios.
```

Ahora modifiquen el programa para:
1. Pedir también el mes de nacimiento (como número) y el mes actual.
2. Mostrar un mensaje distinto si la persona ya cumplió años este año o todavía no.

**Pista:** usá `int(input(...))` en una sola línea para ahorrar variables intermedias.

## 5. Ejercicio independiente (25 min)

**Consigna:** Escribí un programa `promedio.py` que le pida al usuario tres notas (números con decimales) de una materia y muestre el promedio con **exactamente 2 decimales**.

El programa debe:
1. Pedir las tres notas una por una.
2. Convertirlas a `float`.
3. Calcular el promedio.
4. Mostrar el resultado con un mensaje como `"Tu promedio es 7.83"`.

**Pista:** usá `float(input(...))` para leer cada nota. Para mostrar 2 decimales usá `:.2f` adentro de la f-string.

## 6. Extensión y consolidación (20 min)

Si terminaste el promedio, probá estas variaciones:

1. **Promedio ponderado.** Pedí también el peso (porcentaje) de cada nota. El promedio ponderado es `(n1*p1 + n2*p2 + n3*p3) / (p1+p2+p3)`.
2. **Redondeo sin formato.** Calculá el promedio y mostralo con `print(round(promedio, 2))`. ¿Se ve igual que con f-string?
3. **Nombre completo.** Pedí nombre y apellido por separado y armá un mensaje que diga `"Alumno: Garcia, Martina — Promedio: 7.83"`.

## 7. Cierre (10 min)

### Qué te llevás

- `input()` lee todo como texto (`str`), aunque el usuario tipee números.
- Para hacer cuentas hay que convertir con `int()` (entero) o `float()` (decimal).
- Si la conversión falla, `ValueError` rompe el programa.
- Las f-strings (`f"..."`) arman mensajes legibles sin concatenar con `+`.
- `:.2f` adentro de una f-string controla cuántos decimales se muestran.

### Lo que viene

En el **Encuentro 6 — Condicionales y operadores** vamos a aprender a tomar decisiones: si el usuario es mayor de edad, si la nota alcanza para aprobar, si un número es par o impar. Todo con `if`, `elif` y `else`.

## 8. Errores comunes y trampas

| Error | Causa | Fix |
| --- | --- | --- |
| `ValueError: invalid literal for int()` al ejecutar `int("diez")` | El usuario tipeó texto no numérico y `int()` no sabe convertirlo | Validar la entrada con `try/except ValueError` (lo vemos en el E6) |
| `TypeError: can only concatenate str` al hacer `"Edad: " + age` | `age` es `int`, no se puede concatenar con `+` a un `str` | Usar f-string: `f"Edad: {age}"` |
| El programa termina sin esperar entrada | No se llamó a `input()` con un mensaje visible | Agregar `input("Mensaje: ")` |
| `input()` "devuelve" el número pero sigue siendo texto | No se convirtió con `int()` o `float()` | `age = int(input("Edad: "))` |
| La f-string muestra `{age}` literal en vez del valor | Falta la `f` antes de las comillas: se usó `"..."` en vez de `f"..."` | Escribir `f"Edad: {age}"` |
| `7 + 3` concatenado como `"73"` en vez de sumar `10` | Las variables son `str` (no se convirtieron al leer) | Convertir en el momento de la lectura: `int(input(...))` |
