# Anexo docente — Encuentro 29: Desarrollo del integrador

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

**Consigna:** Cada integrante implementa su módulo asignado siguiendo el modelo de la práctica guiada.

**Módulos esperados:**

| Issue | Archivo | Funciones esperadas |
| --- | --- | --- |
| #2 Menú principal | `main.py` | `show_menu(options)` y loop `while True` con `read_int` para la opción |
| #3 Registro de producto | `productos.py` | `register_product(product_list)`, `list_products(product_list)`, `find_product(product_list, name)` |
| #4 Venta y control de stock | `ventas.py` | `sell_product(product_list, invoice)` con validación de stock |
| #5 Factura de la venta | `factura.py` | `show_invoice(invoice)` que muestra items y total |

**Solución de referencia para `ventas.py`:**

```python
# ventas.py
# Control de venta: descuenta stock y agrega items a la factura.


def sell_product(product_list, invoice):
    """Registra una venta: busca producto, valida stock, descuenta y factura."""
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

    # Descontar del stock
    product["kilos"] -= kilos

    # Agregar a la factura
    item_total = kilos * product["price"]
    invoice.append({
        "name": product["name"],
        "kilos": kilos,
        "price": product["price"],
        "total": item_total
    })
    print(f"✓ Venta registrada: {kilos:.2f} kg de "
          f"{product['name'].capitalize()} — ${item_total:.2f}")


def read_float(prompt):
    # Lee un decimal con validación (spike 9.2).
    while True:
        try:
            return float(input(prompt))
        except ValueError:
            print("Eso no es un número válido; intenta de nuevo.")
```

**Aceptaciones válidas:**
- El nombre de la función puede ser `process_sale`, `make_sale`, etc.
- La validación de stock puede estar en `main.py` o en `ventas.py`.
- La factura puede ser una lista de diccionarios o un string formateado.
- `read_float` puede estar en un módulo compartido si el grupo modularizó.

## 2. Solución de la actividad de extensión

**Conectar módulos en `main.py`:**

```python
# main.py
# Programa integrador — Verdulería
# Integra registro de productos, venta con stock y facturación.
# Todos los datos viven en memoria (listas y dicts).

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
    product_list = [
        {"name": "manzana", "price": 2.50, "kilos": 10.0},
        {"name": "banana", "price": 1.80, "kilos": 15.0},
        {"name": "naranja", "price": 1.20, "kilos": 20.0},
    ]
    current_invoice = []

    options = ["Registrar producto",
               "Listar productos",
               "Vender producto",
               "Ver factura actual",
               "Salir"]

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

**Función adicional `update_price`:**

```python
def update_price(product_list):
    """Cambia el precio de un producto existente."""
    name = input("Nombre del producto a actualizar: ").strip().lower()
    product = find_product(product_list, name)
    if product is None:
        print("Producto no encontrado.")
        return
    nuevo_precio = read_float("Nuevo precio por kilo ($): ")
    product["price"] = nuevo_precio
    print(f"Precio de '{product['name'].capitalize()}' actualizado a ${nuevo_precio:.2f}/kg.")
```

## 3. Respuesta esperada del ejercicio

| Indicador | Esperado | Cómo verificar |
| --- | --- | --- |
| Al menos 1 PR mergeado por integrante | PRs en estado "Merged" | Pestaña Pull requests |
| Código funcional (no placeholders) | `python <archivo>.py` funciona | Ejecutar cada módulo |
| `find_product()` implementada | Busca por nombre y devuelve dict o None | Probar con nombre existente e inexistente |
| `sell_product()` valida stock | Muestra mensaje de stock insuficiente | Probar con más kilos de los disponibles |
| `show_invoice()` muestra total | Total acumulado correcto | Verificar con datos de prueba |

## 4. Criterios de corrección (lista de verificación)

| ✔ | Criterio | Peso |
| --- | --- | --- |
| ☐ | Cada integrante tiene al menos un PR mergeado | 30% |
| ☐ | El código funciona sin errores (ruta feliz) | 20% |
| ☐ | La validación de entrada funciona (try/except) | 15% |
| ☐ | El PR fue revisado por un compañero | 15% |
| ☐ | El módulo sigue las convenciones del curso | 10% |
| ☐ | El commit tiene mensaje significativo | 10% |

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| Función sin `return` usada como valor | Confusión con mutación | "Esta función muta la lista, no devuelve nada. ¿Para qué la usás?" |
| No validar entrada en precio o kilos | Usar `float()` sin `try/except` | "¿Qué pasa si el usuario escribe 'abc' donde va un número?" |
| Comparar strings sin normalizar | El usuario escribe "Manzana" y el código busca "manzana" | "Aplicá `.strip().lower()` al leer y al buscar." |
| PR con código que no compila | Commit a mitad de edición | "Probá `python archivo.py` antes de abrir el PR." |
| Conflictos por archivos duplicados | Dos integrantes crean el mismo archivo | "Acordá qué archivos crea cada uno y no tocarlos hasta que el primer PR se mergee." |
| Olvidar pushear el commit antes del PR | El commit está local pero no en GitHub | "Verificá con `git push` antes de abrir el PR." |

## 6. Registro de la clase

**Por grupo, registrar:**

- [ ] Cantidad de PRs mergeados: _____
- [ ] Cantidad de módulos funcionando: _____
- [ ] ¿Cada integrante tiene al menos un PR mergeado? Sí / No
- [ ] ¿Cada PR fue revisado por un compañero? Sí / No
- [ ] Conflictos de merge resueltos: 0 / 1 / 2+
- [ ] Grupo que necesita refuerzo en código: Sí / No
- [ ] Observaciones: _____

**Para la evaluación de proceso:**

- Si un grupo no completó todos los módulos, el Encuentro 30 arrancará con deuda técnica.
- Los conflictos de merge son normales y deseables: indican que el grupo está trabajando en paralelo.
- Registrar qué integrantes no tienen PRs mergeados: necesitan asistencia individual.
