# Anexo docente — Encuentro 24: Integración: menú del TP

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

**Consigna:** opción 5 (buscar por ticket con detalle completo) y opción 3 mejorada (detalle completo si hay un solo resultado).

**Código solución (cambios sobre `pedidos.py`):**

```python
def find_by_ticket(order_list, ticket_number):
    """Busca un pedido por número de ticket."""
    for order in order_list:
        if order["ticket"] == ticket_number:
            return order
    return None


def show_order_detail(order):
    """Muestra el detalle completo de un pedido."""
    print(f"\n═══ Ticket #{order['ticket']} ═══")
    print(f"Comprador: {order['customer']}")
    print(f"Teléfono: {order['phone']}")
    print("--- Items ---")
    for name, qty, price, sub in order["items"]:
        print(f"  {qty}x {name}: ${price:.2f} → ${sub:.2f}")
    print(f"Total: ${order['total']:.2f}")
    print("═" * 30)


# Opciones adicionales para el menú (insertar en el while del __main__)
def run_option(option, orders, clean_phone):
    if option == "3":
        search = input("Teléfono a buscar: ").strip()
        results = search_by_phone(orders, clean_phone(search))
        if not results:
            print("📭 No se encontraron pedidos con ese teléfono.")
        elif len(results) == 1:
            show_order_detail(results[0])
        else:
            print(f"\nSe encontraron {len(results)} pedido(s):")
            for order in results:
                print(f"  #{order['ticket']} — {order['customer']} — ${order['total']:.2f}")
    elif option == "5":
        ticket = read_int("Número de ticket: ")
        found = find_by_ticket(orders, ticket)
        if found:
            show_order_detail(found)
        else:
            print(f"📭 No existe un pedido con ticket #{ticket}.")

# No olvidar agregar "5. Ver detalle por ticket" en show_menu()
```

**Salida verificada:**
```
Elegí una opción: 5
Número de ticket: 3142

═══ Ticket #3142 ═══
Comprador: María
Teléfono: 1123456789
--- Items ---
  2x muzza: $1200.00 → $2400.00
Total: $2400.00
══════════════════════════════════
```

## 2. Solución de la actividad de extensión

**Extensión 1 — Pedido más caro:**
```python
def show_most_expensive(order_list):
    if not order_list:
        print("📭 No hay pedidos.")
        return
    most_expensive = order_list[0]
    for order in order_list[1:]:
        if order["total"] > most_expensive["total"]:
            most_expensive = order
    print(f"\n🏆 Pedido más caro: Ticket #{most_expensive['ticket']}")
    show_order_detail(most_expensive)
```

**Extensión 2 — Precio positivo:**
```python
def read_positive_float(message):
    while True:
        try:
            value = float(input(message))
            if value > 0:
                return value
            else:
                print("❌ El precio debe ser mayor a 0.")
        except ValueError:
            print("❌ Usá punto decimal (ej: 12.50); intentá de nuevo.")

# Reemplazar read_float por read_positive_float al pedir precio
```

**Extensión 3 — Confirmación antes de guardar:**
```python
# Después de calcular total y ticket, pero antes de append:
print(f"\nResumen: {customer} | ${total:.2f} | {len(items)} pizza(s)")
confirm = input("¿Confirmar pedido? (s/n): ").strip().lower()
if confirm == "s":
    order_list.append({...})
    print(f"✓ Pedido registrado. Ticket #{ticket}")
else:
    print("✗ Pedido cancelado.")
```

## 3. Respuesta esperada del ejercicio

| Entrada | Comportamiento esperado |
| --- | --- |
| Opción 5 con ticket existente | Muestra detalle completo del pedido |
| Opción 5 con ticket inexistente | `📭 No existe un pedido con ticket #...` |
| Opción 3 que encuentra 1 pedido | Muestra detalle completo automático |
| Opción 3 que encuentra varios | Muestra lista resumida |

## 4. Criterios de corrección (lista de verificación)

- [ ] Implementa `find_by_ticket` que recorre la lista y compara con `==`
- [ ] Agrega opción 5 en el menú visible y en los `elif`
- [ ] Lee el ticket con `read_int`
- [ ] Muestra mensaje si no encuentra el ticket
- [ ] Modifica opción 3 para mostrar detalle cuando hay un solo resultado
- [ ] El código mantiene la estructura: funciones arriba, `__main__` abajo

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| La opción 5 no aparece en el menú | Agrega el `elif` pero no el texto en `show_menu()` | "El usuario no puede elegir una opción que no ve" |
| `find_by_ticket` devuelve `None` siempre | Compara con `order["ticket"]` pero guardó como string vs int | "`read_int` devuelve `int`; el ticket también es `int` — asegurate que ambos sean del mismo tipo" |
| Muestra todos los pedidos en vez de uno solo | Usa `for` y no corta cuando encuentra | "`return` corta la función cuando encontrás el que buscás" |
| No limpia el teléfono al buscar o al guardar | La búsqueda falla porque los formatos no coinciden | "Si guardaste limpio, buscá limpio" |
| La modificación de opción 3 rompe el flujo | Pone el detalle en el lugar equivocado | "Primero buscá, después decidí si es uno o varios" |

## 6. Registro de la clase

- **Por grupo:** registrar qué grupos completan el ejercicio independiente y cuáles avanzan a extensiones. Es la clase previa a la entrega: los grupos que quedan atrás necesitan atención personalizada en el encuentro 25.
- **Para la evaluación de proceso:** el TP-U3 se entrega en el encuentro 25. Verificar que cada grupo tiene un avance mínimo (pueden agregar al menos un pedido y listarlo). Si algún grupo no llegó, coordinar ayuda en el 25.
- **Bitácora:** grupos que ya tienen el programa funcionando, qué features extra agregaron, quiénes necesitan repaso de diccionarios.