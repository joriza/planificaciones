# Anexo docente — Encuentro 30: Consolidación del integrador

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

**Consigna:** Cada grupo termina el integrador: cerrar issues, completar `factura.py`, probar con checklist, preparar `DEFENSA.md`.

**Solución completa de `factura.py`:**

```python
# factura.py
# Muestra la factura actual con los items vendidos y el total.

def show_invoice(invoice):
    """Recibe la lista de items vendidos y muestra la factura formateada."""
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


if __name__ == "__main__":
    # Prueba rápida
    test_invoice = [
        {"name": "manzana", "kilos": 2.0, "price": 2.50, "total": 5.00},
        {"name": "banana", "kilos": 1.5, "price": 1.80, "total": 2.70},
    ]
    show_invoice(test_invoice)
```

**Salida esperada de `python factura.py`:**

```
======= FACTURA =======
Manzana      2.00 kg × $2.50 = $5.00
Banana       1.50 kg × $1.80 = $2.70
======================
TOTAL: $7.70
======================
```

**Solución de `main.py` completo** (integración final):

```python
# main.py
# Programa integrador — Verdulería
# Integra registro, venta y facturación en un solo programa de consola.
# Todos los datos en memoria (listas y dicts).

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

**Archivo `DEFENSA.md` esperado:**

```markdown
# Defensa del trabajo final integrador

## Integrante: [Nombre]

### Módulo a cargo
[qué funciones implementó y en qué archivo]

### Error corregido
[qué error encontró y cómo lo solucionó]

### PR revisado
[qué PR de qué compañero revisó y qué verificó]

### Pregunta preparada
[una pregunta técnica con su respuesta]
```

## 2. Solución de la actividad de extensión

**Mejora opcional — Actualizar precio (`productos.py`):**

Extender el menú con opción 6 y agregar la función en `productos.py`:

```python
def update_price(product_list):
    """Actualiza el precio de un producto existente."""
    name = input("Nombre del producto: ").strip().lower()
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

**Refactor a `utils.py`:**

```python
# utils.py
# Funciones de utilidad compartidas por todos los módulos.

def read_int(prompt):
    while True:
        try:
            return int(input(prompt))
        except ValueError:
            print("Eso no es un número entero; intenta de nuevo.")

def read_float(prompt):
    while True:
        try:
            return float(input(prompt))
        except ValueError:
            print("Eso no es un número válido; intenta de nuevo.")
```

## 3. Respuesta esperada del ejercicio

| Elemento | Esperado | Verificación |
| --- | --- | --- |
| `main.py` funciona | Sin errores | `python main.py` → menú, registrar, vender, factura, salir |
| Factura vacía muestra mensaje | "No hay ventas registradas" | Opción 4 sin haber vendido |
| Stock insuficiente muestra error | "Stock insuficiente. Hay X kg disponibles." | Vender más de lo que hay |
| Entrada inválida manejada | Mensaje accionable | Ingresar letra en opción |
| Issues todos cerrados | 6 issues en estado Closed | Pestaña Issues |
| DEFENSA.md con secciones | 1 sección por integrante | Leer archivo |
| Último commit con mensaje | "trabajo-final: cierre..." | `git log --oneline -1` |

## 4. Criterios de corrección (lista de verificación)

| ✔ | Criterio | Peso |
| --- | --- | --- |
| ☐ | `main.py` ejecutable sin errores | 30% |
| ☐ | La checklist de 8 pruebas pasa completa | 25% |
| ☐ | Todos los issues cerrados | 15% |
| ☐ | `DEFENSA.md` con todos los integrantes | 15% |
| ☐ | Último commit pusheado con mensaje de cierre | 10% |
| ☐ | README actualizado con estado "En desarrollo" | 5% |

**Checklist de prueba completa:**

| ✔ | Prueba | Entrada | Resultado esperado |
| --- | --- | --- | --- |
| ☐ | Registrar producto | 1, "papa", 1.2, 25 | ✓ Papa registrado |
| ☐ | Listar productos | 2 | Aparece papa al final |
| ☐ | Vender con stock | 3, "papa", 3 | ✓ Venta registrada: $3.60 |
| ☐ | Stock insuficiente | 3, "banana", 100 | Stock insuficiente |
| ☐ | Ver factura | 4 | Muestra items y total |
| ☐ | Opción inválida | 6 | Opción inválida |
| ☐ | Entrada no numérica | "hola" en menú | Eso no es un número... |
| ☐ | Salir | 5 | Mensaje de despedida |

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| `main.py` importa y falla porque falta módulo | No todos los archivos existen | "¿Existe `ventas.py`? Si no, hay que crearlo o comentar el import temporalmente." |
| El menú no vuelve después de una opción | Faltó el `while True` | "¿El menú está dentro de un bucle? Si no, ejecuta una sola vez y termina." |
| Factura no acumula | Sobrescribe la lista en lugar de `append` | "Cada vez que vendés, ¿creás una factura nueva o agregás a la existente?" |
| `read_float` crashea con coma (12,5) | El usuario usa coma decimal | Explicar que `float()` acepta punto, no coma. Si quieren aceptar coma, agregar `.replace(",", ".")` |
| No hay DEFENSA.md | Se olvidaron | "Crealo ahora. No tiene que ser largo: 4 líneas por persona." |
| Último commit sin pushear | Se apuraron a cerrar | "`git push origin main`. Si no, el docente no ve el cambio." |

## 6. Registro de la clase

**Por grupo, registrar:**

- [ ] `python main.py` funciona: Sí / No (si no, detalle: _____)
- [ ] Checklist de pruebas completa: 0-8 (cuántas pasaron)
- [ ] Issues cerrados: _____/6
- [ ] DEFENSA.md completo: Sí / No
- [ ] Último commit pusheado: Sí / No
- [ ] Grupo listo para defensa: Sí / Necesita recuperación
- [ ] Observaciones: _____

**Para la evaluación de proceso:**

- Este encuentro es el último antes del cierre. Un grupo que no tiene el programa funcionando al final de la clase necesita intervención antes del Encuentro 31.
- La defensa individual del Encuentro 32 evaluará: explicación del código (40%), demo del programa (30%), comprensión del flujo Git (20%), respuesta a preguntas (10%).