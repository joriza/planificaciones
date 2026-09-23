# Encuentro 29 — Desarrollo del integrador

> Trabajo integrador y flujo profesional

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 29 de 36 |
| Unidad | 4 — Trabajo integrador y flujo profesional |
| Eje temático | 4 — Trabajo integrador profesional |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 120 minutos (2 horas reloj) |
| Concepto nuevo | Desarrollo del integrador |
| Requisitos previos | Encuentro 28 completado: main protegida, ramas por issue creadas y al menos un PR mergeado. Cada grupo tiene el esqueleto del trabajo final con los placeholders de archivos. |
| Uso de celular | No permitido |
| Organización del trabajo | Grupos de 3-4 integrantes. Cada integrante trabaja en su rama asignada (issue) y abre PR cuando su función está lista. El docente circula entre los grupos para destrabar PRs y resolver conflictos. |

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

1. Implementar el módulo asignado del programa verdulería en su rama feature.
2. Abrir un pull request con código funcional (no placeholders) y asignar revisor.
3. Revisar el código de un compañero contra la checklist de defectos frecuentes de Python.
4. Resolver conflictos de merge simples en GitHub o local.
5. Integrar el módulo revisado a main y verificar que el programa sigue funcionando.

## 3. Teoría mínima (20 min)

### Charla rápida: La verdulería como sistema integrado

Imaginá una verdulería real. El dueño necesita: saber qué productos tiene y cuánto pesa cada uno (stock), poder registrar un producto nuevo cuando llega el camión, cobrar una venta restando lo que se vendió del stock y darle un ticket al cliente. Esas cuatro operaciones son tu programa. Cada integrante construye una pieza (registro, venta, factura, menú) y todas se conectan a través del menú principal. La magia no está en cada pieza por separado, está en que funcionan juntas compartiendo los datos en memoria.

### Lo mínimo indispensable

**Estructura del programa integrador (dominio verdulería).**

```
trabajo-final/
  main.py          # Menú principal que conecta todo
  productos.py     # Registro y consulta de productos
  ventas.py        # Control de venta y actualización de stock
  factura.py       # Generación de factura de la venta actual
```

Cada archivo contiene funciones que trabajan sobre listas y diccionarios compartidos. El estado se pasa entre funciones como parámetros. No hay archivos ni persistencia.

**Funciones canónicas para el integrador:**

```python
def read_int(prompt):
    # Lee un entero con validación: input() devuelve str,
    # int() lanza ValueError si no es numérico (spike 9.1).
    while True:
        try:
            return int(input(prompt))
        except ValueError:
            print("Eso no es un número entero; intenta de nuevo.")


def read_float(prompt):
    # Lee un decimal con validación: float() lanza ValueError
    # si el texto no puede convertirse (spike 9.2).
    while True:
        try:
            return float(input(prompt))
        except ValueError:
            print("Eso no es un número válido; intenta de nuevo.")


def show_menu(options):
    # Muestra un menú numerado. options es una lista de strings.
    # Ejemplo: ["Registrar producto", "Vender", "Factura", "Salir"]
    print("\n=== VERDULERÍA ===")
    for i, option in enumerate(options, start=1):
        print(f"{i}. {option}")
    print()
```

**Reglas del flujo de trabajo de hoy:**
1. Cada integrante trabaja en su rama: `git switch feature/<issue>`.
2. Cuando la función está lista (ejecutable, probada), abrí PR.
3. El revisor verifica el código contra la checklist de defectos frecuentes.
4. Merge solo después de aprobación.
5. Después del merge, cada integrante actualiza su main: `git switch main && git pull`.

## 4. Práctica guiada (35 min)

Vamos a implementar el módulo de registro de productos completo, paso a paso.

**Paso 1: Ubicarse en la rama correcta**

```bash
git switch main
git pull origin main
git switch -c feature/registro-productos
```

**Paso 2: Escribir el archivo `productos.py` con la función de registro**

```python
# productos.py
# Funciones para registrar y consultar productos en una verdulería.
# Cada producto es un dict con nombre, precio por kilo y kilos en stock.


def register_product(product_list):
    """Registra un nuevo producto: pide nombre, precio y kilos.

    Recibe la lista de productos y agrega un nuevo dict.
    No devuelve nada (None): muta la lista recibida.
    """
    print("\n--- Registrar producto ---")
    name = input("Nombre del producto: ").strip().lower()

    # Verificar si el producto ya existe
    for product in product_list:
        if product["name"] == name:
            print(f"El producto '{name}' ya está registrado.")
            return

    price = read_float("Precio por kilo ($): ")
    kilos = read_float("Kilos en stock: ")

    product_list.append({
        "name": name,
        "price": price,
        "kilos": kilos
    })
    print(f"✓ '{name.capitalize()}' registrado con ${price:.2f}/kg y {kilos} kg.")


def list_products(product_list):
    """Muestra todos los productos con su precio y stock."""
    if not product_list:
        print("No hay productos registrados.")
        return

    print("\n--- Productos disponibles ---")
    for product in product_list:
        print(f"{product['name'].capitalize():15} "
              f"${product['price']:.2f}/kg  "
              f"{product['kilos']:.2f} kg")
    print(f"Total: {len(product_list)} producto(s).")


if __name__ == "__main__":
    # Prueba rápida de las funciones
    test_list = [
        {"name": "manzana", "price": 2.5, "kilos": 10},
        {"name": "banana", "price": 1.8, "kilos": 15},
    ]
    list_products(test_list)
    register_product(test_list)
    list_products(test_list)
```

**Paso 3: Probar el módulo**

```bash
python productos.py
```

Salida esperada:

```
--- Productos disponibles ---
Manzana         $2.50/kg  10.00 kg
Banana          $1.80/kg  15.00 kg
Total: 2 producto(s).

--- Registrar producto ---
Nombre del producto: Pera
Precio por kilo ($): 3.2
Kilos en stock: 8
✓ 'Pera' registrado con $3.20/kg y 8.00 kg.

--- Productos disponibles ---
Manzana         $2.50/kg  10.00 kg
Banana          $1.80/kg  15.00 kg
Pera            $3.20/kg  8.00 kg
Total: 3 producto(s).
```

**Paso 4: Publicar, abrir PR y asignar revisor**

```bash
git add .
git commit -m "productos: implementar registro y listado"
git push -u origin feature/registro-productos
```

Andá a GitHub, abrí el PR con título "Implementar módulo de registro de productos" y asigná un revisor.

**Paso 5: Revisar el PR de un compañero**

El revisor mira el diff y verifica la checklist de defectos frecuentes:

- ¿Las funciones usan `return`? ✔
- ¿No hay `lista = lista.append()`? ✔
- ¿Los mensajes al usuario usan f-strings? ✔
- ¿La entrada se valida con `try/except ValueError`? ✔
- ¿No hay código suelto fuera del bloque `if __name__ == "__main__":`? ✔

Si todo está bien, **Approve** y **Merge**.

## 5. Ejercicio independiente (25 min)

**Consigna:** Cada integrante implementa su módulo asignado siguiendo el modelo de la práctica guiada:

| Issue | Archivo | Qué implementar |
| --- | --- | --- |
| #2 Menú principal | `main.py` | Función `show_menu()` que recibe una lista de opciones y el loop principal del programa |
| #3 Registro de producto | `productos.py` | Completar: ya tienen la base de la práctica, agregar función `find_product()` por nombre |
| #4 Venta y control de stock | `ventas.py` | Función `sell_product()` que descuenta kilos y valida stock suficiente |
| #5 Factura de la venta | `factura.py` | Función `show_invoice()` que muestra los items vendidos y el total de la venta actual |

Cada módulo se prueba con `python <archivo>.py` antes de abrir PR.

**Pista:** La función `find_product()` recibe el nombre y la lista, recorre con un bucle `for` y devuelve el producto (dict) si existe o `None` si no.

**Solución esperada:** Al final del encuentro, cada integrante debe tener al menos un PR mergeado con código funcional de su módulo. El programa completo aún no corre de forma integrada (falta unirlos en main.py), pero cada pieza funciona por separado.

## 6. Extensión y consolidación (20 min)

**Para los grupos que terminaron:**

1. **Conectar módulos:** En `main.py`, importá las funciones de los otros módulos y armá el menú completo que llame a las funciones correctas. Probá el integrador completo con `python main.py`.
2. **Función adicional:** Agregá una función `update_price(product_list)` que permita cambiar el precio de un producto existente. Creá un issue nuevo (#7) y trabajalo en su rama.
3. **README dinámico:** Actualizá el README con la estructura real del proyecto y los nombres de los módulos.

## 7. Cierre (10 min)

### Qué te llevás

- Cada módulo se implementa en su rama y se integra vía PR: así no se rompe lo que ya funciona.
- Las funciones de validación (`read_int`, `read_float`) se reusan en todos los módulos: no las copies, ponelas en un archivo compartido o pasalas como parámetro.
- Revisar el código del compañero con la checklist de defectos frecuentes te hace mejor programador: aprendés viendo errores ajenos.
- El programa integrador empieza a tomar forma: ya tenés productos, ventas y factura como piezas independientes.

### Lo que viene

En el **Encuentro 30** vas a **consolidar el integrador**: cerrar issues pendientes, integrar todos los módulos en un solo programa ejecutable, hacer los ajustes finales y empezar a preparar la defensa individual. Es la última clase de desarrollo antes del cierre.

## 8. Errores comunes y trampas

1. **Función sin `return` que se usa como valor.** *Causa:* `register_product()` muta la lista pero no devuelve nada; si hacés `resultado = register_product(...)`, `resultado` es `None`. *Fix:* estas funciones trabajan por efecto y no necesitan return.

2. **No validar entrada en precio o kilos.** *Causa:* usar `float(input(...))` sin `try/except`. *Fix:* siempre `read_float()` con el patrón de validación canónico.

3. **Comparar strings sin normalizar.** *Causa:* el usuario escribe "Manzana" y el programa busca "manzana". *Fix:* aplicar `.strip().lower()` al leer el nombre.

4. **PR con código que no compila.** *Causa:* hacer commit de un archivo a mitad de edición. *Fix:* antes de abrir el PR, probar `python archivo.py`. Si falla, no se abre el PR.

5. **Conflictos por archivos duplicados.** *Causa:* dos integrantes crean `main.py` en distintas ramas. *Fix:* acordar qué archivos crea cada uno y no tocarlos hasta que el primer PR se mergee.

6. **Olvidar pushear el commit antes del PR.** *Causa:* el commit está local pero no en GitHub; el PR aparece con 0 commits. *Fix:* siempre verificar con `git push` antes de abrir el PR.
