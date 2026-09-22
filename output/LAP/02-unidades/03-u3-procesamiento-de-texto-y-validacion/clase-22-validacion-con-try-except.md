# Encuentro 22 — Validación con try/except

> Procesamiento de texto y validación

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 22 de 36 |
| Unidad | 3 — Procesamiento de texto y validación |
| Eje temático | 3 — Procesamiento de texto y validación |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 120 minutos (2 horas reloj) |
| Concepto nuevo | Validación con try/except |
| Requisitos previos | Encuentro 21: métodos de cadenas (`split`, `strip`, `join`, `replace`) y f-strings con formato |
| Uso de celular | No permitido |
| Organización del trabajo | Grupos de 2 personas. Una computadora por grupo, alternan quien escribe en cada ejercicio. |

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

1. Identificar cuándo `int()` o `float()` lanzan `ValueError` al recibir texto no numérico.
2. Usar `try/except ValueError` para capturar el error y mostrar un mensaje accionable.
3. Implementar el patrón de reintento `while True` con validación.
4. Distinguir entre errores de usuario (entrada inválida) y errores de programa (bug), y decidir cuáles atrapar.

## 3. Teoría mínima (20 min)

### Charla rápida: el portero del boliche

En la puerta de un boliche hay un portero que solo deja entrar a mayores de edad. Vos llegás y decís «diecisiete»; el portero no te entiende porque necesita un número. Te pide «decime tu edad en número». Eso mismo hace `int()` cuando recibe texto: solo entiende dígitos. Si llegás con `"diecisiete"`, `int()` protesta. `try/except` es el protocolo: intentá convertir, y si falla, atajá el error y pedí de nuevo.

### Lo mínimo indispensable

**La excepción `ValueError`:** cuando llamás `int("hola")`, Python lanza `ValueError` porque el texto no es numérico. Lo mismo con `float()`.

**Patrón canónico de validación (único autorizado en el curso):**

```python
def read_int(message):
    """Pide un entero y reintenta hasta obtener uno válido."""
    while True:
        try:
            return int(input(message))
        except ValueError:
            print("Eso no es un número entero; intentá de nuevo.")
```

**Reglas de la casa:**
- `except:` desnudo está **prohibido**. Siempre nombrá la excepción: `except ValueError`.
- El mensaje de error debe ser **accionable**: decirle al usuario qué hacer, no solo «Error».
- El bloque `try` debe ser lo más chico posible: solo la conversión, no toda la función.
- `while True` con `return` en el `try` es el patrón: se sale solo cuando la conversión es exitosa.

**Variante con `float`:**

```python
def read_float(message):
    while True:
        try:
            return float(input(message))
        except ValueError:
            print("Eso no es un número válido (ej: 12.5); intentá de nuevo.")
```

**Qué NO se atrapa con `try/except`:**
- Una opción inválida de menú (se resuelve con `if/else` y mensaje).
- Una clave que falta en un diccionario (se resuelve con `.get()` o `in`).
- Un error de lógica del programa (eso es un bug, no se tapa).

## 4. Práctica guiada (35 min)

**Escenario:** en la pizzería necesitamos registrar pedidos con cantidad y precio. El usuario puede equivocarse al tipear. Vamos a hacer una función de carga validada.

**Código completo (`order_input.py`):**

```python
def read_int(message):
    """Solicita un entero con validación y reintento."""
    while True:
        try:
            return int(input(message))
        except ValueError:
            print("❌ Eso no es un número entero; escribí solo dígitos (ej: 3).")


def read_float(message):
    """Solicita un número decimal con validación y reintento."""
    while True:
        try:
            return float(input(message))
        except ValueError:
            print("❌ Eso no es un número válido; usá punto decimal (ej: 12.50).")


def add_pizza_to_order(order_list):
    """Agrega una pizza al pedido pidiendo cantidad y precio."""
    print("\n--- Nueva pizza ---")
    name = input("Nombre de la pizza: ").strip()
    quantity = read_int(f"Cantidad de {name}: ")
    unit_price = read_float(f"Precio unitario de {name}: $")

    # Calcula subtotal
    subtotal = quantity * unit_price
    order_list.append((name, quantity, unit_price, subtotal))
    print(f"✓ Agregadas {quantity}x {name} a ${unit_price:.2f} = ${subtotal:.2f}")


def show_order(order_list):
    """Muestra el pedido completo."""
    if not order_list:
        print("El pedido está vacío.")
        return

    print("\n=== Pedido completo ===")
    total = 0.0
    for name, qty, price, sub in order_list:
        total += sub
        print(f"{qty}x {name}: ${price:.2f} c/u → ${sub:.2f}")
    print(f"Total: ${total:.2f}")


if __name__ == "__main__":
    order = []
    print("=== Registro de pedidos de la pizzería ===")
    add_pizza_to_order(order)
    add_pizza_to_order(order)
    show_order(order)
```

**Salida esperada (con errores incluidos):**
```
=== Registro de pedidos de la pizzería ===

--- Nueva pizza ---
Nombre de la pizza: muzza
Cantidad de muzza: dos
❌ Eso no es un número entero; escribí solo dígitos (ej: 3).
Cantidad de muzza: 2
Precio unitario de muzza: $doce
❌ Eso no es un número válido; usá punto decimal (ej: 12.50).
Precio unitario de muzza: $1200
✓ Agregadas 2x muzza a $1200.00 = $2400.00

--- Nueva pizza ---
Nombre de la pizza: napo
Cantidad de napo: 1
Precio unitario de napo: $1400
✓ Agregadas 1x napo a $1400.00 = $1400.00

=== Pedido completo ===
2x muzza: $1200.00 c/u → $2400.00
1x napo: $1400.00 c/u → $1400.00
Total: $3800.00
```

**Pasos para la puesta en común:**
1. Escribí el código en `order_input.py`.
2. Ejecutalo y probá la ruta feliz (números válidos).
3. Reiniciá y probá escribir texto donde va un número.
4. Discutí: ¿qué pasa si en vez de `except ValueError` escribimos `except:`? — el docente explica por qué está prohibido.

## 5. Ejercicio independiente (25 min)

**Consigna:** escribí un programa `read_age.py` que pida la edad del comprador (entre 0 y 120) con validación. Usá el patrón `read_int` visto, pero agregá una segunda validación: si la edad no está entre 0 y 120, mostrá un mensaje y volvé a pedir.

**Formato esperado:**
```
Ingresá tu edad: -5
❌ La edad debe estar entre 0 y 120 años; intentá de nuevo.
Ingresá tu edad: 150
❌ La edad debe estar entre 0 y 120 años; intentá de nuevo.
Ingresá tu edad: 25
✓ Edad registrada: 25 años.
```

**Pista:** después del `return int(...)`, antes de salir de la función, chequeá con `if` si el valor está en el rango permitido. Si no, mostrá el mensaje y el `while` se encarga de pedir de nuevo.

**Solución:** en el anexo docente.

## 6. Extensión y consolidación (20 min)

Para quienes terminan el ejercicio base:

1. **Agregá validación de rango superior:** en la pizzería, la cantidad máxima por pizza es 99. Modificá `read_int` para que acepte un mínimo y un máximo opcionales.
2. **Menú simple con opción numérica:** hacé un programa que muestre 3 opciones de pizzas numeradas y pida elegir. Si el usuario tipea 4, 0 o letras, debe rechazar y volver a pedir.
3. **Múltiples intentos acotados:** modificá el patrón para que después de 3 intentos fallidos el programa termine con un mensaje.

## 7. Cierre (10 min)

### Qué te llevás

- `int()` y `float()` lanzan `ValueError` cuando reciben texto no numérico — es esperado, no es un bug del programa.
- El patrón `while True` + `try/except ValueError` + `return` es la receta canónica para validar entrada.
- `except:` desnudo está prohibido: siempre nombrá la excepción que esperás.
- Los errores de validación son del usuario; los bugs son del programador. No se mezclan.

### Lo que viene

En el **Encuentro 23** vamos a meter todo esto adentro de un **menú de consola en memoria**, con `import` de módulos built-in como `random` y `math`.

## 8. Errores comunes y trampas

| Error | Causa | Fix |
| --- | --- | --- |
| `except:` sin nombre de excepción | El programador tapa todos los errores, incluso bugs | Siempre nombrar `except ValueError:` |
| Poner todo el programa dentro de `try` | Atrapa errores que no deberían atraparse | Poné solo la conversión dentro del `try` |
| Validar el rango pero olvidar el `while` | Si la edad está fuera de rango, no vuelve a pedir | Validá dentro del mismo `while True` que pide el número |
| `int(input(...))` fuera del `try` | `ValueError` sin atrapar corta el programa | Encerrá la línea completa `int(input(...))` en el `try` |
| Mensaje de error genérico: `"Error: entrada inválida"` | No ayuda al usuario a corregir | El mensaje debe decir qué espera el programa y cómo corregirlo |
| Usar `try/except` para opción de menú inválida | No es un `ValueError`, es una opción que no existe | Usá `if/else` con mensaje "Opción inválida" |
| Validar el rango antes de devolver y olvidar el `return` | La función devuelve `None` si no hay `return` | Asegurate de que `return` esté después de validar |