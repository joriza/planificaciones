# Anexo docente — Encuentro 25: Cierre U3: repaso y TP

> Documento docente formal. No se entrega a los alumnos.

## 1. Solución del ejercicio de consolidación

El ejercicio de consolidación no tiene una solución única: cada grupo parte del programa que construyó en la clase 24. El docente debe guiar para que todos lleguen a un programa que cumpla con el checklist.

**Programa mínimo esperado (líneas clave):**

El `pedidos.py` debe tener, como mínimo, estas funciones:

| Función | ¿Qué validación tiene? | Comportamiento esperado |
| --- | --- | --- |
| `read_int(msg, min, max)` | `try/except ValueError` + rango | Reintenta hasta obtener entero válido |
| `read_float(msg)` | `try/except ValueError` | Reintenta hasta obtener float válido |
| `clean_phone(phone)` | `replace(" ", "").replace("-", "")` | Devuelve solo dígitos |
| `parse_order_line(line)` | `try/except ValueError` en `int(parts[0])` | Devuelve `(cant, nombre)` o `None` |
| `add_order(order_list)` | Internamente usa las funciones de validación | Agrega diccionario a la lista |
| `list_orders(order_list)` | Sin validación | Recorre e imprime |
| `search_by_phone(order_list, phone)` | Aplica `clean_phone` | Devuelve lista de coincidencias |
| `show_menu()` | Sin validación | Imprime opciones, devuelve string |

**Estructura del diccionario de pedido:**
```python
{
    "customer": str,
    "phone": str,         # solo dígitos
    "items": list,        # [(name, qty, price, subtotal), ...]
    "total": float,
    "ticket": int
}
```

## 2. Solución de la actividad de extensión

**Funcionalidades extra sugeridas para grupos avanzados:**

**Opción — Modificar pedido:**
```python
def modify_order(order_list):
    ticket = read_int("Número de ticket a modificar: ")
    order = find_by_ticket(order_list, ticket)
    if not order:
        print(f"📭 No existe ticket #{ticket}.")
        return
    print(f"Modificando pedido de {order['customer']}")
    while True:
        line = input("Nueva pizza (cant nombre) o ENTER para terminar: ").strip()
        if line == "":
            break
        parsed = parse_order_line(line)
        if parsed:
            qty, name = parsed
            price = read_float(f"  Precio de {name}: $")
            subtotal = qty * price
            order["items"].append((name, qty, price, subtotal))
    order["total"] = sum(sub for _, _, _, sub in order["items"])
    print(f"✓ Pedido #{ticket} actualizado. Nuevo total: ${order['total']:.2f}")
```

**Opción — Ordenar pedidos por total:**
```python
def show_sorted_by_total(order_list):
    if not order_list:
        print("📭 No hay pedidos.")
        return
    sorted_orders = sorted(order_list, key=lambda o: o["total"], reverse=True)
    for order in sorted_orders:
        print(f"  #{order['ticket']} — {order['customer']} — ${order['total']:.2f}")
```

## 3. Respuesta esperada del ejercicio

No aplica: el ejercicio de consolidación es de sistematización y revisión, no tiene una única respuesta.

## 4. Criterios de corrección del TP-U3

**Lista de verificación para la evaluación del TP-U3:**

- [ ] El programa es un solo archivo `pedidos.py` en `tp-u3/`
- [ ] Estructura correcta: funciones arriba, `if __name__ == "__main__":` al final
- [ ] `import random` al principio
- [ ] Menú con `while True` y opciones: 1-4 + 0
- [ ] Opción 1: pide nombre, teléfono y lista de pizzas
- [ ] Validación con `try/except ValueError` para cantidades y precios
- [ ] `except:` nombra `ValueError` (no es desnudo)
- [ ] Métodos de texto: `split`/`strip`/`join`/`replace` para procesar entrada
- [ ] `clean_phone` con `replace` para limpiar teléfono
- [ ] Opción 2: lista todos los pedidos
- [ ] Opción 3: busca por teléfono (coincidencia parcial con `in`)
- [ ] Opción 4: muestra ventas totales
- [ ] Opción 0: sale con mensaje
- [ ] Opción inválida: mensaje claro
- [ ] Sin `open()`, sin archivos, sin persistencia
- [ ] Sin clases, sin lambda (salvo `key=lambda` opcional en extensión), sin comprehensions avanzadas
- [ ] Mensajes al usuario en español con f-strings
- [ ] Identificadores en inglés `snake_case`
- [ ] Commit con mensaje `"tp-u3: menú de consola validado para pizzería"`
- [ ] Push exitoso al remoto

**Ponderación sugerida:** cada item del checklist vale un punto. 15/15 = 10. 12/15 = 7. Menos de 10/15 = recuperatorio.

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| El programa no arranca porque falta `import` | Se olvidó de importar `random` o lo puso al final | "Los import van al principio, antes de cualquier función" |
| `git add` no encuentra la carpeta | Crearon la carpeta pero no el archivo adentro | "`tp-u3/pedidos.py` tiene que existir; `ls tp-u3/` para verificar" |
| `git push` pide credenciales | No configuraron GitHub en VS Code | Ayudar a configurar o usar token |
| El grupo no tiene nada funcionando | No avanzaron en la clase 24 o faltaron | Planificar recuperatorio antes de la evaluación |
| El commit se hace desde otra carpeta y no incluye el TP | Están en la raíz del repo pero no agregaron la carpeta | `git status` muestra qué está en stage |
| El programa se cierra si el usuario tipea un espacio | No usó `.strip()` en el `input()` de las opciones | "`" 1".strip()` da `"1"` — siempre strip al leer opciones" |

## 6. Registro de la clase

- **Por grupo:** registrar qué grupos completan la entrega (commit + push). Anotar los que no llegan y necesitan recuperatorio.
- **Para la evaluación de proceso:** el TP-U3 es el entregable de la unidad. La evaluación escrita (encuentro 26) tomará los mismos conceptos. Si un grupo no pudo entregar, probablemente necesite apoyo extra antes del encuentro 26.
- **Bitácora:**
  - Fecha de la clase.
  - Grupos que entregaron.
  - Grupos que no entregaron y causa probable.
  - Funcionalidades extra implementadas (para destacar).
  - Dificultades técnicas con Git (para reforzar en la próxima entrega).
- **Próximo encuentro:** la Evaluación de la Unidad 3. Preparar una consigna individual similar al TP, pero más acotada (45 min), sobre el dominio de pizzería.