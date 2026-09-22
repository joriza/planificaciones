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
| Duración teórica | 120 minutos (2 horas reloj) |
| Concepto nuevo | Módulos y menú en memoria |
| Requisitos previos | Encuentro 22: validación con `try/except ValueError` y patrón de reintento |
| Uso de celular | No permitido |
| Organización del trabajo | Grupos de 2 personas. En este encuentro cada grupo arma su primer menú funcional completo. |

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

1. Usar `import` para incorporar funciones de módulos built-in (`random.randint`, `math.sqrt`).
2. Diseñar un menú de consola con opciones numeradas y un bucle principal `while True`.
3. Integrar funciones, colecciones, validación y procesamiento de texto en un solo programa.
4. Distinguir entre módulos built-in (que vienen con Python) y módulos propios (que no usamos en este curso).

## 3. Teoría mínima (20 min)

### Charla rápida: la caja de herramientas de la pizzería

La pizzería tiene una caja de herramientas compartida: un horno (que todos usan), una calculadora de precios, un generador de números de ticket. En Python, esas herramientas compartidas se llaman **módulos**. `import` es la forma de pedir: «che, prestame el `random` para generar un número de ticket al azar» o «prestame `math` para calcular el área de la pizza». No los escribimos nosotros: ya vienen con Python.

### Lo mínimo indispensable

**Los módulos son archivos de Python con funciones ya escritas.** Se importan con `import` al principio del archivo:

```python
import random
import math

# Uso:
num = random.randint(1, 100)      # entero aleatorio entre 1 y 100
raiz = math.sqrt(144)             # raíz cuadrada: 12.0
```

**Reglas del curso sobre import:**
- Solo `import` de módulos **built-in** (los que vienen instalados con Python). No vamos a instalar paquetes externos.
- `import` va al **principio del archivo**, después de los comentarios, antes de las funciones.
- Usamos la sintaxis `import modulo` (no `from modulo import *`).
- Para llamar una función del módulo: `random.randint(...)` o `math.sqrt(...)`.

**Menú de consola en memoria — patrón canónico:**

```python
import random

def show_menu():
    print("\n=== Pizzería El Pythonista ===")
    print("1. Agregar pizza al pedido")
    print("2. Ver pedido actual")
    print("3. Generar número de ticket")
    print("0. Salir")
    return input("Elegí una opción: ")

if __name__ == "__main__":
    order = []  # memoria: el estado vive acá
    while True:
        option = show_menu()
        if option == "0":
            print("¡Gracias por tu pedido!")
            break
        elif option == "1":
            # agregar pizza (función)
            pass  # placeholder: lo completamos en práctica guiada
        elif option == "2":
            # ver pedido
            pass
        elif option == "3":
            ticket = random.randint(1000, 9999)
            print(f"📄 Número de ticket: #{ticket}")
        else:
            print("❌ Opción inválida; elegí 0-3.")
```

## 4. Práctica guiada (35 min)

**Escenario:** pizzería con menú completo en memoria. Integramos todo lo visto hasta ahora: funciones que procesan texto, validan entrada con `try/except`, y usan `random` para el ticket.

**Código completo (`pizza_menu.py`):**

```python
import random


def read_int(message, min_val=None, max_val=None):
    """Pide un entero con validación y rango opcional."""
    while True:
        try:
            value = int(input(message))
            if min_val is not None and value < min_val:
                print(f"❌ El mínimo es {min_val}; intentá de nuevo.")
                continue
            if max_val is not None and value > max_val:
                print(f"❌ El máximo es {max_val}; intentá de nuevo.")
                continue
            return value
        except ValueError:
            print("❌ Eso no es un número entero; intentá de nuevo.")


def parse_pizza_line(line):
    """Procesa una línea como '2 muzza' y devuelve (cant, nombre)."""
    parts = line.strip().split()
    if len(parts) < 2:
        return None
    try:
        quantity = int(parts[0])
        name = " ".join(parts[1:])
        return (quantity, name)
    except ValueError:
        return None


def add_pizza(order_list):
    """Agrega una pizza al pedido interactivamente."""
    print("\n--- Agregar pizza ---")
    line = input("Ingresá cantidad y nombre (ej: 2 muzza): ")
    parsed = parse_pizza_line(line)
    if parsed is None:
        print("❌ Formato incorrecto; usá: cantidad nombre")
        return
    quantity, name = parsed
    # Precio fijo por simplicidad (lo podría calcular con dict)
    unit_price = 1200.0 if name.lower() == "muzza" else 1400.0
    subtotal = quantity * unit_price
    order_list.append((name, quantity, unit_price, subtotal))
    print(f"✓ Agregadas {quantity}x {name} a ${unit_price:.2f} = ${subtotal:.2f}")


def show_order(order_list):
    """Muestra el pedido actual."""
    if not order_list:
        print("\n📭 El pedido está vacío.")
        return
    print("\n=== Pedido actual ===")
    total = 0.0
    for name, qty, price, sub in order_list:
        total += sub
        print(f"{qty}x {name}: ${price:.2f} c/u → ${sub:.2f}")
    print(f"Total: ${total:.2f}")


def show_menu():
    """Muestra el menú y devuelve la opción elegida."""
    print("\n" + "=" * 35)
    print("   🍕 Pizzería El Pythonista")
    print("=" * 35)
    print("1. Agregar pizza")
    print("2. Ver pedido")
    print("3. Generar ticket")
    print("0. Salir")
    return input("Elegí una opción: ").strip()


if __name__ == "__main__":
    order = []
    print("¡Bienvenido a la Pizzería El Pythonista!")

    while True:
        option = show_menu()

        if option == "0":
            print("🍕 ¡Gracias por tu pedido! Que lo disfrutes.")
            break
        elif option == "1":
            add_pizza(order)
        elif option == "2":
            show_order(order)
        elif option == "3":
            ticket = random.randint(100, 999)
            print(f"📄 Ticket #{ticket} — guardá este número.")
        else:
            print("❌ Opción inválida. Elegí 0, 1, 2 o 3.")
```

**Salida esperada (secuencia de prueba):**
```
¡Bienvenido a la Pizzería El Pythonista!

=====================================
   🍕 Pizzería El Pythonista
=====================================
1. Agregar pizza
2. Ver pedido
3. Generar ticket
0. Salir
Elegí una opción: 1

--- Agregar pizza ---
Ingresá cantidad y nombre (ej: 2 muzza): 2 muzza
✓ Agregadas 2x muzza a $1200.00 = $2400.00

Elegí una opción: 1
--- Agregar pizza ---
Ingresá cantidad y nombre (ej: 2 muzza): 1 napo
✓ Agregadas 1x napo a $1400.00 = $1400.00

Elegí una opción: 2

=== Pedido actual ===
2x muzza: $1200.00 c/u → $2400.00
1x napo: $1400.00 c/u → $1400.00
Total: $3800.00

Elegí una opción: 3
📄 Ticket #742 — guardá este número.

Elegí una opción: 0
🍕 ¡Gracias por tu pedido! Que lo disfrutes.
```

**Pasos:**
1. Escribí el archivo completo `pizza_menu.py` tal como está arriba.
2. Ejecutalo y probá cada opción del menú.
3. Probá opciones inválidas (letra `x`, número `9`).
4. Probá el parseo con formato incorrecto (ej: `muzza` sin cantidad).

## 5. Ejercicio independiente (25 min)

**Consigna:** partiendo de `pizza_menu.py`, agregá una opción **4. Ver ticket activo** que recuerde el último ticket generado y lo muestre de nuevo. Si todavía no se generó ningún ticket, mostrá "Todavía no hay ticket; generá uno con la opción 3."

Además, modificá la opción 2 para que muestre también la **cantidad total de pizzas** (no solo el total en dinero) al final.

**Pista:** necesitás una variable global (bueno, una variable en el bloque `__main__`) para guardar el último ticket. Inicializala en `None` y actualizala cuando generás uno nuevo.

**Solución:** en el anexo docente.

## 6. Extensión y consolidación (20 min)

Para quienes terminan el ejercicio base:

1. **Agregá `math.sqrt`:** cuando el pedido supera los $5000, mostrá un mensaje que diga "¡Pedido grande! La raíz cuadrada del total es {total_raiz:.2f}" usando `math.sqrt`.
2. **Precio dinámico con random:** cuando se agrega una pizza, que el precio unitario varíe un poco: `random.randint(1100, 1500)`.
3. **Confirmación antes de salir:** cuando el usuario elige 0, preguntá "¿Estás seguro? (s/n)" antes de cortar.

## 7. Cierre (10 min)

### Qué te llevás

- `import` es la forma de usar herramientas que ya vienen con Python: `random`, `math`.
- El menú de consola vive en un `while True` que solo corta con `break`.
- Las opciones del menú se resuelven con `if/elif/else`, no con `try/except`.
- Integrar funciones + colecciones + validación + texto en un solo programa es el núcleo de la U3.

### Lo que viene

**Encuentro 24: Integración: menú del TP**

## 8. Errores comunes y trampas

| Error | Causa | Fix |
| --- | --- | --- |
| Escribe `from random import *` | Quiere importar todo sin prefijo | Usar `import random` y llamar `random.randint(...)` |
| Olvida el `import` al principio | El módulo no está disponible | `import` debe ir antes de cualquier uso del módulo |
| Escribe `import math` después de usarlo | Python ejecuta en orden; el módulo no está cargado | Mover todos los `import` al principio del archivo |
| Menú eterno sin opción de salida | Falta `option == "0"` con `break` | Siempre incluir una opción de salida en el menú |
| Usa `try/except` para la opción inválida | Confunde validación de entrada con control de menú | La opción inválida se resuelve con `else` y un mensaje simple |
| Llama `randint()` sin el prefijo `random.` | Importó el módulo pero no usa el nombre completo | Llamar `random.randint()` con el nombre del módulo adelante |
| La variable `order` está fuera del `while` pero el `while` la modifica | Funciona porque `order` es una lista mutable; confunde el alcance | Explicar que las listas son mutables y se modifican in-place |
| `import` con espacios o tildes en el path del archivo | El módulo `random` está instalado en Python, no en el directorio | No es un path de archivo: es el nombre del módulo en la biblioteca estándar |