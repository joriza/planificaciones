# Encuentro 4 — Primer programa y variables

> 1 — Fundamentos de Python y control del flujo

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 4 de 36 |
| Unidad | 1 — Fundamentos de Python y control del flujo |
| Eje temático | 1 — Fundamentos del lenguaje Python |
| Carácter/Objetivo | Conceptual |
| Estructura | clase |
| Duración teórica | 120 minutos (2 horas reloj) |
| Concepto nuevo | Primer programa en Python; variables, asignación y tipos básicos; operadores aritméticos; comentarios |
| Requisitos previos | Ninguno: es el primer encuentro con Python |
| Uso de celular | No permitido |
| Organización del trabajo | Individual con puesto fijo; se alterna entre escuchar, escribir código y resolver ejercicios |

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

1. Escribir y ejecutar un primer programa en Python desde VS Code y la terminal.
2. Declarar variables con nombres significativos en inglés y asignarles valores de tipo `int`, `float`, `str` y `bool`.
3. Usar los operadores aritméticos (`+`, `-`, `*`, `/`, `//`, `%`, `**`) en expresiones sencillas.
4. Agregar comentarios que documenten el propósito de cada bloque de código.

## 3. Teoría mínima (20 min)

### Charla rápida: la caja de herramientas

Imaginate que abrís una caja de herramientas. Cada herramienta tiene un nombre y un propósito: un martillo no es lo mismo que un destornillador, pero ambas son herramientas. En Python pasa algo parecido: cada **valor** que el programa necesita recordar se guarda en una **variable**, que tiene un nombre y un **tipo** que dice qué clase de dato contiene. Python te deja ver qué hay dentro con `print()` y hacer cuentas con operadores aritméticos, igual que una calculadora.

### Lo mínimo indispensable

**Un primer programa.** La forma más simple de que Python haga algo es con `print()`:

```python
# Muestra un mensaje en la consola
print("Hola, mundo!")
```

**Variables.** Una variable es un nombre que le ponés a un valor. El operador `=` asigna (guarda) el valor de la derecha en la variable de la izquierda:

```python
# Tipos basicos
age = 17              # int (entero)
price = 12.5           # float (real)
name = "Ana"           # str (texto, siempre con comillas dobles)
active = True          # bool (logico: True o False)

print(age)
print(price)
print(name)
print(active)
```

Los nombres de variable se escriben en **inglés**, en **snake_case** (todo minúscula, separado por guión bajo), sin tildes ni eñes.

**Operadores aritméticos.** Python entiende las cuentas como una calculadora:

```python
a = 10
b = 3

suma = a + b          # 13
resta = a - b         # 7
multi = a * b         # 30
div_real = a / b      # 3.333...  (siempre float)
div_entera = a // b   # 3         (trunca decimales)
resto = a % b         # 1         (modulo)
potencia = a ** b     # 1000      (10 elevado a 3)

print(suma)
print(resto)
print(potencia)
```

**Comentarios.** Todo lo que está después de `#` hasta el final de la línea es un comentario: Python lo ignora. Sirve para explicar qué hace cada parte del código.

## 4. Práctica guiada (35 min)

Vamos a escribir un programa que calcule cuántos días, horas y minutos vivió una persona hasta cierto cumpleaños, usando solo los datos del año actual y su edad. Abrí VS Code, creá un archivo `edad.py` y escribí lo siguiente:

```python
# Calcula tiempo vivido aproximado en dias, horas y minutos
# Usa solo valores fijos (sin entrada de datos todavia)

name = "Luis"
age = 17               # edad actual en anios
days_per_year = 365
hours_per_day = 24
minutes_per_hour = 60

# Calculos aproximados (sin contar bisiestos)
total_days = age * days_per_year
total_hours = total_days * hours_per_day
total_minutes = total_hours * minutes_per_hour

print("Nombre:")
print(name)
print("Edad en anios:")
print(age)
print("Dias vividos (aprox):")
print(total_days)
print("Horas vividas (aprox):")
print(total_hours)
print("Minutos vividos (aprox):")
print(total_minutes)
```

**Salida esperada** (los valores numéricos dependen de los cálculos):

```
Nombre:
Luis
Edad en anios:
17
Dias vividos (aprox):
6205
Horas vividas (aprox):
148920
Minutos vividos (aprox):
8935200
```

Ahora modifiquen el programa para:
1. Cambien el valor de `name` por su propio nombre.
2. Cambien `age` por su propia edad.
3. Agreguen una variable `weeks_per_year = 52` y calculen las semanas vividas (`total_weeks`).
4. Muestren también las semanas vividas con `print()`.

**Pista:** la multiplicación se escribe con `*`; el orden de las operaciones es el mismo que en matemática (primero multiplicación y división, después suma y resta). Usá paréntesis si querés asegurar el orden.

Ejecutá el programa con `python edad.py` desde la terminal integrada de VS Code.

## 5. Ejercicio independiente (25 min)

**Consigna:** Escribí un programa `rectangulo.py` que calcule el área y el perímetro de un rectángulo. Los lados del rectángulo se guardan como variables al principio del código. El programa debe mostrar en la consola el valor de cada lado, el área calculada y el perímetro calculado.

Usá:
- Largo = 12.5 (tipo `float`)
- Ancho = 8.3 (tipo `float`)

**Pista:** el área es largo × ancho. El perímetro es 2 × largo + 2 × ancho. Recordá que los identificadores van en inglés.

## 6. Extensión y consolidación (20 min)

Si terminaste el ejercicio anterior, probá estas variaciones:

1. **Redondear con operadores.** Usá `//` para calcular cuántas veces enteras entra el ancho en el largo.
2. **Potencia.** Calculá el área de un cuadrado cuyo lado es el mismo valor del largo (12.5) usando el operador `**`.
3. **Mezcla de tipos.** Asigná `count = 10` (int) y `unit_price = 4.99` (float), calculá `total = count * unit_price` y mostrá el resultado. ¿De qué tipo es `total`?

## 7. Cierre (10 min)

### Qué te llevás

- Python ejecuta instrucciones de arriba a abajo.
- Las variables guardan valores en memoria con un nombre y un tipo.
- Cada tipo (`int`, `float`, `str`, `bool`) sirve para una clase de dato distinta.
- Los operadores aritméticos funcionan como en una calculadora, pero `/` siempre devuelve `float` y `//` trunca.
- Los comentarios con `#` explican el código sin afectar la ejecución.

### Lo que viene

En el **Encuentro 5 — Entrada y salida por consola** vamos a hacer que el programa hable con el usuario: leer datos con `input()`, convertirlos al tipo correcto y armar mensajes con f-strings. Ahí tus programas van a dejar de ser fijos y van a reaccionar a lo que el usuario escribe.

## 8. Errores comunes y trampas

| Error | Causa | Fix |
| --- | --- | --- |
| `SyntaxError: invalid syntax` al escribir `print "hola"` | En Python 3 los paréntesis en `print()` son obligatorios | Escribir `print("hola")` |
| `NameError: name 'edad' is not defined` | La variable se llama `age` (inglés) pero se usa `edad` (español) | Usar siempre el nombre exacto que se asignó; mantener identificadores en inglés |
| `7 / 2` da `3.5` en vez de `3` | El operador `/` es división real, no entera | Usar `//` si se quiere división entera (`7 // 2` → `3`) |
| Asignar `miVariable = 5` sin declaración previa es válido pero confunde | No hay error, pero mezclar estilos (camelCase con snake_case) dificulta la lectura | Usar siempre `snake_case` (`my_variable`) |
| Olvidar las comillas en un texto: `name = Ana` | Sin comillas, Python busca una variable llamada `Ana` que no existe | Escribir `name = "Ana"` con comillas dobles |
| `a = a + 1` antes de haber definido `a` | No se puede usar una variable antes de asignarle un valor | Primero asignar el valor inicial (`a = 0`) |
