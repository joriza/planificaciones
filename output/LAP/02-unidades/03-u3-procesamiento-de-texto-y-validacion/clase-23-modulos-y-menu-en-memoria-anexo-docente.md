# Anexo docente — Encuentro 23: Módulos y menú en memoria

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

**Consigna:** agregar opción 4 (mostrar último ticket) y mostrar cantidad total de pizzas en la opción 2.

**Código solución (cambios sobre `pizza_menu.py`):**

```python
def show_order(order_list):
    """Muestra el pedido actual con cantidad total de pizzas."""
    if not order_list:
        print("\n📭 El pedido está vacío.")
        return
    print("\n=== Pedido actual ===")
    total = 0.0
    total_pizzas = 0
    for name, qty, price, sub in order_list:
        total += sub
        total_pizzas += qty
        print(f"{qty}x {name}: ${price:.2f} c/u → ${sub:.2f}")
    print(f"Cantidad total de pizzas: {total_pizzas}")
    print(f"Total: ${total:.2f}")


# En el bloque __main__:
if __name__ == "__main__":
    order = []
    last_ticket = None  # variable para recordar el último ticket
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
            last_ticket = random.randint(100, 999)
            print(f"📄 Ticket #{last_ticket} — guardá este número.")
        elif option == "4":
            if last_ticket is None:
                print("📭 Todavía no hay ticket; generá uno con la opción 3.")
            else:
                print(f"📄 El último ticket es: #{last_ticket}")
        else:
            print("❌ Opción inválida. Elegí 0-4.")
```

**Salida verificada:**
```
Elegí una opción: 4
📭 Todavía no hay ticket; generá uno con la opción 3.
Elegí una opción: 3
📄 Ticket #457 — guardá este número.
Elegí una opción: 4
📄 El último ticket es: #457
```

## 2. Solución de la actividad de extensión

**Extensión 1 — `math.sqrt` para pedidos grandes:**
```python
import math

# Dentro de show_order, después del total:
if total > 5000:
    total_root = math.sqrt(total)
    print(f"📏 Raíz cuadrada del total: {total_root:.2f}")
```

**Extensión 2 — Precio dinámico con `random.randint`:**
```python
def add_pizza(order_list):
    # ... dentro de la función, reemplazar precio fijo:
    unit_price = random.randint(1100, 1500)
    # ... resto igual
```

**Extensión 3 — Confirmación de salida:**
```python
def handle_exit(option):
    if option == "0":
        confirm = input("¿Estás seguro de salir? (s/n): ").strip().lower()
        if confirm == "s":
            print("🍕 ¡Gracias por tu pedido! Que lo disfrutes.")
            return True
    return False
```

## 3. Respuesta esperada del ejercicio

| Entrada | Comportamiento esperado |
| --- | --- |
| Opción 4 sin ticket | `📭 Todavía no hay ticket; generá uno con la opción 3.` |
| Opción 3 | Muestra `📄 Ticket #XXX` |
| Opción 4 después del 3 | Muestra `📄 El último ticket es: #XXX` |
| Opción 2 con pedido | Muestra cantidad total de pizzas (ej: `Cantidad total de pizzas: 3`) |

## 4. Criterios de corrección (lista de verificación)

- [ ] Agrega la opción 4 en el menú y en los `elif`
- [ ] Usa una variable `last_ticket` inicializada en `None`
- [ | Muestra mensaje diferenciado si no hay ticket generado
- [ ] Modifica `show_order` para mostrar cantidad total
- [ ] Mantiene `import random` al principio
- [ ] El programa corre sin errores

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| La opción 4 no aparece en el menú | Modifica el `elif` pero no el `print` del menú | "El menú que ve el usuario tiene que listar todas las opciones" |
| `last_ticket` no se actualiza | No asigna `last_ticket = ...` cuando genera el ticket | "¿Dónde se genera el ticket nuevo? Ahí tenés que guardarlo" |
| Muestra `None` en vez del ticket | Imprime la variable sin actualizar o la inicializa mal | "`None` quiere decir que la variable nunca recibió un valor" |
| No chequea `None` y muestra otra cosa | Compara como string: `if last_ticket == "None"` | "El `None` de Python no tiene comillas, es un valor especial" |
| Cantidad total de pizzas no suma | Usa `len(order_list)` en vez de sumar las cantidades | "`len()` te da la cantidad de *líneas*, no la de pizzas. Tenés que sumar cada cantidad." |
| El programa se rompe si elige opción antes de agregar algo | `show_order` con lista vacía no tiene items | "Usá `if not order_list:` para el caso vacío" |

## 6. Registro de la clase

- **Por grupo:** registrar qué grupos logran completar el ejercicio independiente (opción 4 + cantidad total de pizzas) sin ayuda. Los que lo hacen más rápido son candidatos a ayudantes.
- **Para la evaluación de proceso:** observar si los grupos comprenden el patrón del menú (`while True`, `break`, opciones). Es la base del TP-U3.
- **Bitácora:** fecha, qué grupos necesitaron ayuda con `import`, quiénes preguntaron por `from ... import *`, cuántos llegaron a extensión.