# Anexo docente — Encuentro 29: Desarrollo del integrador

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

**Consigna:** Cada integrante implementa su módulo asignado, lo prueba localmente y lo integra vía PR con revisión entre pares.

**Módulo esperado por integrante:**

**Issue #2 — Menú principal (`main.py` — esqueleto):**

```python
def show_menu(options):
    print("\n=== VERDULERÍA ===")
    for i, option in enumerate(options, start=1):
        print(f"{i}. {option}")
    print()
```

**Issue #3 — Registro de producto (`productos.py` — completar con `find_product`):**

```python
def find_product(product_list, name):
    """Busca un producto por nombre (normalizado). Devuelve el dict o None."""
    for product in product_list:
        if product["name"] == name.strip().lower():
            return product
    return None
```

**Issue #4 — Venta y control de stock (`ventas.py`):**

```python
# ventas.py
# Control de venta: descuenta stock y agrega items a la factura.

def read_float(prompt):
    while True:
        try:
            return float(input(prompt))
        except ValueError:
            print("Eso no es un número válido; intenta de nuevo.")

def sell_product(product_list, invoice):
    print("\n--- Vender producto ---")
    name = input("Nombre del producto: ").strip().lower()
    product = find_product(product_list, name)
    
    if product is None:
        print(f"Producto '{name}' no encontrado.")
        return
    
    print(f"{product['name'].capitalize()} — "
          f"${product['price']:.2f}/kg — {product['kilos']:.2f} kg disponibles")
    
    kilos = read_float("Kilos a vender: ")
    
    if kilos <= 0:
        print("La cantidad debe ser mayor a cero.")
        return
    
    if kilos > product["kilos"]:
        print(f"Stock insuficiente. Hay {product['kilos']:.2f} kg disponibles.")
        return
    
    product["kilos"] -= kilos
    item_total = kilos * product["price"]
    invoice.append({
        "name": product["name"],
        "kilos": kilos,
        "price": product["price"],
        "total": item_total
    })
    print(f"✓ Venta registrada: {kilos:.2f} kg de "
          f"{product['name'].capitalize()} — ${item_total:.2f}")
```

**Issue #5 — Factura (`factura.py`):**

```python
# factura.py
# Generación de factura a partir de la lista de items vendidos.

def show_invoice(invoice):
    """Muestra la factura actual."""
    if not invoice:
        print("No hay ventas registradas.")
        return
    
    print("\n======= FACTURA =======")
    grand_total = 0.0
    for item in invoice:
        subtotal = item["kilos"] * item["price"]
        print(f"{item['name'].capitalize():12} "
              f"{item['kilos']:.2f} kg × ${item['price']:.2f} = ${subtotal:.2f}")
        grand_total += subtotal
    print("=" * 22)
    print(f"TOTAL: ${grand_total:.2f}")
    print("======================")
```

## 2. Solución de la actividad de extensión

**Conectar módulos en `main.py`:**

```python
from productos import register_product, list_products, find_product
from ventas import sell_product
from factura import show_invoice

def read_int(prompt):
    while True:
        try:
            return int(input(prompt))
        except ValueError:
            print("Eso no es un número entero; intenta de nuevo.")

def main():
    product_list = []
    current_invoice = []
    
    options = [
        "Registrar producto",
        "Listar productos",
        "Vender producto",
        "Ver factura actual",
        "Salir"
    ]
    
    while True:
        print("\n=== VERDULERÍA — Sistema de venta ===")
        for i, option in enumerate(options, start=1):
            print(f"{i}. {option}")
        
        choice = read_int("Opción: ")
        
        if choice == 1:
            register_product(product_list)
        elif choice == 2:
            list_products(product_list)
        elif choice == 3:
            sell_product(product_list, current_invoice)
        elif choice == 4:
            show_invoice(current_invoice)
        elif choice == 5:
            print("Gracias por usar Verdulería. ¡Hasta la próxima!")
            break
        else:
            print("Opción inválida. Elegí un número del 1 al 5.")

if __name__ == "__main__":
    main()
```

**Función adicional `update_price(product_list)`:**

```python
def update_price(product_list):
    name = input("Nombre del producto a actualizar: ").strip().lower()
    product = find_product(product_list, name)
    if product is None:
        print(f"Producto '{name}' no encontrado.")
        return
    new_price = read_float("Nuevo precio por kilo ($): ")
    if new_price <= 0:
        print("El precio debe ser mayor a cero.")
        return
    product["price"] = new_price
    print(f"✓ Precio de '{product['name'].capitalize()}' actualizado "
          f"a ${new_price:.2f}/kg.")
```

## 3. Respuesta esperada del ejercicio

| Indicador | Esperado | Cómo verificar |
| --- | --- | --- |
| Cada módulo existe | `.py` por integrante | `ls trabajo-final/` |
| El módulo corre solo | `python ventas.py` no tira error | Ejecutar |
| find_product normaliza | .strip().lower() | Revisar en código |
| PR por cada módulo | Al menos 3 PRs mergeados nuevos | Pestaña Pull requests |
| Cada PR revisado por otro | Approved en PR | Abrir cada PR |
| No hay clases, lambda, archivos | Código dentro del alcance | Revisar diff de PRs |

## 4. Criterios de corrección (lista de verificación)

| ✔ | Criterio | Peso |
| --- | --- | --- |
| ☐ | Cada integrante implementó su módulo | 30% |
| ☐ | El módulo incluye validación de entrada (try/except) | 20% |
| ☐ | El módulo se probó localmente (python archivo.py funciona) | 20% |
| ☐ | PR con código revisado por un compañero | 20% |
| ☐ | Sin defectos frecuentes (append mal usado, etc.) | 10% |

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| Módulo sin validación de entrada | Copiaron el patrón sin entender | "¿Qué pasa si el usuario escribe 'hola' donde va el precio? Probalo." |
| Función que no usa `product_list` | No pasan el argumento | "`product_list` no está definida dentro de la función. ¿Cómo la recibe?" |
| PR con código que no compila | Hicieron commit a mitad de edición | "Probá `python modulo.py` antes de abrir el PR. Si no corre, no se mergea." |
| Revisor aprueba sin comentarios | No revisó realmente | "Encontrame un error en el código de tu compañero antes de aprobar." |
| Dos integrantes hicieron el mismo módulo | Descoordinación | "Decidan oralmente quién hace cada issue. El que sobra, que tome un issue de mejora." |
| Conflicto de merge en PR | Dos integrantes tocaron el mismo archivo | "Usá GitHub Desktop o la terminal para resolver el conflicto. Elegí qué código conservar." |

## 6. Registro de la clase

**Por grupo, registrar:**

- [ ] Módulos implementados: producto / venta / factura / menú (marcar)
- [ ] ¿Cada integrante implementó el suyo? Sí / No
- [ ] PRs mergeados nuevos: _____
- [ ] Conflictos de merge: 0 / 1 / 2+
- [ ] Grupo que necesita refuerzo: Sí (¿en qué?) / No
- [ ] Observaciones: _____

**Para la evaluación de proceso:**

- Es la primera vez que escriben código real en ramas separadas. La calidad del código puede ser baja: priorizar que funcione y tenga validación, no la estética.
- Si un grupo tiene solo 2 módulos implementados y faltan los otros, reorganizar para el Encuentro 30: los que terminaron ayudan a los que no.