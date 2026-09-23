# Encuentro 23 — Módulos y menú en memoria

> Procesamiento de texto y validación

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 23 de 36 |
| Unidad | 3 — Procesamiento de texto y validación |
| Eje temático | 3 — Procesamiento de texto y validación |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 120 minutos (2 horas) |
| Concepto nuevo | Módulos y menú en memoria |
| Requisitos previos | Encuentro 22: try/except; Encuentros 1–21: funciones, listas, diccionarios, métodos de cadena |
| Uso de celular | No permitido |
| Organización del trabajo | Trabajo individual en terminal; el docente circula y acompaña a quienes lo necesiten |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y puente | 10 min |
| Teoría mínima | 20 min |
| Práctica guiada | 35 min |
| Ejercicio independiente | 25 min |
| Extensión y consolidación | 20 min |
| Cierre | 10 min |
| **Total** | **120 min** |

## 2. Objetivos de aprendizaje

1. Usar `import` para incorporar módulos built-in (`random`, `math`) en un programa.
2. Diseñar un menú de consola en memoria que combine funciones, colecciones y validación de entrada.
3. Integrar los núcleos del curso (funciones, listas, diccionarios, `try/except`, f-strings) en un solo programa coherente.
4. Distinguir entre la mención puntual de módulos y el desarrollo profundo de un módulo propio.

## 3. Teoría mínima (20 min)

### Charla rápida: la caja de herramientas del programador

Cuando necesitás una herramienta que ya está hecha —como un martillo que ya viene en la caja— no la construís desde cero. En Python, `import` es esa caja: `import random` te da acceso a funciones para números aleatorios, y `import math` te da acceso a operaciones matemáticas estándar. En este encuentro vamos a usar esas cajas para armar un menú de consola que viva entero en memoria, sin archivos ni bases de datos.

### Lo mínimo indispensable

- `import random` da acceso a `random.choice(lista)` para elegir un elemento al azar y `random.randint(a, b)` para un entero aleatorio en un rango.
- `import math` da acceso a `math.sqrt(x)` para raíz cuadrada y `math.pi` para el número π.
- Un menú de consola en memoria usa un bucle `while True` que muestra opciones, lee la elección del usuario con `input()`, y ejecuta la acción correspondiente con `if/elif/else`.
- La opción de salida usa `break` para terminar el bucle.
- Todo el estado del programa vive en variables y colecciones en memoria; no hay persistencia de ningún tipo.

## 4. Práctica guiada (35 min)

**Paso 1** — Creá un archivo `menu_random.py` con el siguiente código:

```python
# menu_random.py
# Menú de consola que usa random para generar números aleatorios.

import random


def generar_numero():
    # Genera un número aleatorio entre 1 y 100.
    numero = random.randint(1, 100)
    print(f"Número generado: {numero}")
    return numero


def adivinar_numero():
    # El programa piensa un número y el usuario intenta adivinarlo.
    objetivo = random.randint(1, 100)
    intentos = 0
    while True:
        try:
            palpite = int(input("Adiviná el número (1-100): "))
        except ValueError:
            print("Eso no es un número entero; intenta de nuevo.")
            continue
        intentos += 1
        if palpite < objetivo:
            print("Más alto.")
        elif palpite > objetivo:
            print("Más bajo.")
        else:
            print(f"¡Correcto! Lo adivinaste en {intentos} intentos.")
            break


def mostrar_menu():
    # Muestra el menú de opciones al usuario.
    print("\n--- Menú ---")
    print("1. Generar un número aleatorio")
    print("2. Jugar a adivinar el número")
    print("3. Salir")


def main():
    # Bloque de ejecución principal: menú en memoria con while True.
    while True:
        mostrar_menu()
        opcion = input("Elegí una opción: ").strip()
        if opcion == "1":
            generar_numero()
        elif opcion == "2":
            adivinar_numero()
        elif opcion == "3":
            print("¡Hasta luego!")
            break
        else:
            print("Opción inválida; elegí 1, 2 o 3.")


if __name__ == "__main__":
    main()
```

**Paso 2** — Ejecutá el programa y probá las tres opciones:

1. Opción `1`: genera y muestra un número aleatorio.
2. Opción `2`: juega al número adivinado; probá con entradas válidas y no numéricas.
3. Opción `3`: sale del programa.
4. Opción `4` (inválida): muestra el mensaje de opción inválida.

**Paso 3** — Agregá una opción `4` al menú que muestre la lista de todos los números generados en la sesión (usá una lista para acumularlos).

## 5. Ejercicio independiente (25 min)

**Consigna:** Escribí un programa llamado `menu_matematica.py` que muestre un menú con tres opciones: (1) calcular la raíz cuadrada de un número, (2) calcular el área de un círculo dado su radio, y (3) salir. Usá `import math` y las funciones `math.sqrt()` y `math.pi`. Validá que la entrada numérica sea positiva para la raíz cuadrada y que el radio sea mayor que cero para el área. Pista: creá una función `read_positive_float(message)` que reuse el patrón `while True` con `try/except ValueError` y verifique que el valor sea positivo.

**Solución esperada:**

```python
# menu_matematica.py
# Menú de consola con operaciones matemáticas usando math.

import math


def read_positive_float(message):
    # Pide un número positivo hasta obtener uno válido.
    while True:
        try:
            valor = float(input(message))
            if valor <= 0:
                print("El valor debe ser positivo; intentá de nuevo.")
                continue
            return valor
        except ValueError:
            print("Eso no es un número; intentá de nuevo.")


def raiz_cuadrada():
    # Calcula y muestra la raíz cuadrada de un número positivo.
    numero = read_positive_float("Ingresá un número positivo: ")
    resultado = math.sqrt(numero)
    print(f"La raíz cuadrada de {numero} es {resultado:.4f}")


def area_circulo():
    # Calcula y muestra el área de un círculo dado su radio.
    radio = read_positive_float("Ingresá el radio del círculo: ")
    area = math.pi * radio ** 2
    print(f"El área del círculo con radio {radio} es {area:.4f}")


def mostrar_menu():
    # Muestra el menú de opciones al usuario.
    print("\n--- Menú Matemática ---")
    print("1. Raíz cuadrada")
    print("2. Área del círculo")
    print("3. Salir")


def main():
    # Bloque de ejecución principal: menú en memoria con while True.
    while True:
        mostrar_menu()
        opcion = input("Elegí una opción: ").strip()
        if opcion == "1":
            raiz_cuadrada()
        elif opcion == "2":
            area_circulo()
        elif opcion == "3":
            print("¡Hasta luego!")
            break
        else:
            print("Opción inválida; elegí 1, 2 o 3.")


if __name__ == "__main__":
    main()
```

**Salida esperada** (opción 1, entrada `16`):

```
La raíz cuadrada de 16.0 es 4.0000
```

**Salida esperada** (opción 2, entrada `5`):

```
El área del círculo con radio 5.0 es 78.5398
```

## 6. Extensión y consolidación (20 min)

**Actividad 1 — Historial de cálculos:** Agregá una lista `historial = []` en `main()` que acumule cada resultado como un diccionario `{"operacion": ..., "resultado": ...}` y muestre el historial al final de cada operación.

**Actividad 2 — Factorial con math:** Agregá una opción `4` que calcule el factorial de un número entero positivo usando `math.factorial()`. Validá que la entrada sea un entero no negativo.

## 7. Cierre (10 min)

### Qué te llevás

- `import random` y `import math` son la forma canónica de usar módulos built-in; no se desarrollan como tema, solo se mencionan y se usan.
- Un menú de consola en memoria combina `while True`, `if/elif/else`, `break`, funciones y validación con `try/except`.
- Todo el estado vive en variables y colecciones en memoria; no hay persistencia.
- `math.sqrt()`, `math.pi`, `math.factorial()` son ejemplos de funciones de módulos built-in.

### Lo que viene

En el próximo encuentro vamos a integrar todo lo aprendido en el diseño del TP-U3: un menú de consola completo en un solo archivo `.py`.

## 8. Errores comunes y trampas

1. **`math.sqrt(-1)` lanza `ValueError`** — No se puede calcular la raíz cuadrada de un número negativo en `float`; validá que el input sea positivo antes de llamar a `math.sqrt()`.
2. **`import random` dentro de la función** — Funciona, pero es mejor poner los imports arriba del archivo para que sean visibles al leer el código.
3. **`math.pi` es `float`, no `int`** — Si necesitás un entero redondeado, usá `round(math.pi)`.
4. **Confundir `random.randint(a, b)` con `random.choice()`** — `randint` devuelve un entero en un rango; `choice` selecciona un elemento de una secuencia.
5. **Olvidar `break` en la opción de salida** — Sin `break`, el menú no sale del bucle y el programa queda en loop infinito.
6. **`float(input(...))` sin `try/except`** — Si el usuario tipea texto no numérico, el programa se rompe; siempre validar con `try/except ValueError`.
