# Encuentro 30 — Consolidación del integrador

> Trabajo integrador y flujo profesional

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 30 de 36 |
| Unidad | 4 — Trabajo integrador y flujo profesional |
| Eje temático | 4 — Trabajo integrador profesional |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 120 minutos (2 horas reloj) |
| Concepto nuevo | Consolidación del integrador |
| Requisitos previos | Encuentro 29 completado: cada integrante implementó y mergeó su módulo (productos, ventas, factura, menú). El repositorio tiene código funcional en ramas feature mergeadas a main. |
| Uso de celular | No permitido |
| Organización del trabajo | Grupos de 3-4 integrantes. Los grupos que completaron todos los módulos trabajan en la integración y preparación de la defensa. Los grupos con módulos pendientes priorizan cerrarlos al inicio. El docente atiende a los grupos más atrasados. |

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

1. Integrar todos los módulos del programa en un solo archivo `main.py` ejecutable.
2. Probar el programa completo (ruta feliz, errores de entrada, opción inválida).
3. Resolver los issues pendientes y cerrarlos con PRs.
4. Preparar la estructura de la defensa individual: qué va a explicar cada integrante.
5. Hacer el commit de cierre del encuentro con mensaje significativo.

## 3. Teoría mínima (20 min)

### Charla rápida: El ensayo general antes del estreno

Imaginá que tu grupo es una banda que ensayó cada tema por separado. Hoy es el ensayo general: todo el grupo toca junto, los temas suenan en el orden correcto, se afinan los volúmenes y se prueban los equipos. Si algo suena mal, se ajusta antes del concierto (que es la defensa). El público no escucha los ensayos individuales: escucha el resultado final. Lo mismo con el integrador: no importa qué tan bien funcione cada módulo por separado si no funcionan juntos.

### Lo mínimo indispensable

**Integración de módulos.** Cada módulo (`productos.py`, `ventas.py`, `factura.py`) expone funciones que se importan en `main.py` y se conectan a través del menú.

Para que `main.py` pueda usar las funciones de los otros archivos, se importan al principio:

```python
from productos import register_product, list_products, find_product
from ventas import sell_product
from factura import show_invoice
```

El estado compartido (la lista de productos y la factura actual) vive en `main.py` y se pasa como argumento a cada función.

**Ciclo de vida del programa:**
1. Inicializa lista de productos vacía y factura vacía.
2. Muestra el menú y espera opción.
3. Según la opción, llama a la función correspondiente.
4. Vuelve al menú hasta que el usuario elige "Salir".
5. Muestra mensaje de despedida y termina.

**Checklist de prueba canónica:**
1. Ruta feliz: registrar producto, vender, ver factura, salir.
2. Entrada no numérica donde se espera número.
3. Lista vacía: factura sin productos, lista sin productos.
4. Opción de menú inexistente.

**Preparación de la defensa.** Cada integrante debe poder explicar:

- **Su módulo:** qué hace, cómo lo implementó, qué validaciones tiene.
- **Un error que encontró y corrigió:** muestra aprendizaje.
- **El flujo del programa:** cómo se conecta su módulo con los demás.
- **Un PR que revisó:** qué observó y por qué aprobó.

## 4. Práctica guiada (35 min)

Vamos a integrar todos los módulos en un solo programa ejecutable.

**Paso 1: Posicionarse en main y crear rama de integración**

```bash
git switch main
git pull origin main
git switch -c feature/integracion-final
```

**Paso 2: Escribir `main.py` que importe y conecte todo**

```python
# main.py
# Programa integrador — Verdulería
# Integra registro de productos, venta con stock y facturación.
# Todos los datos viven en memoria (listas y dicts).

from productos import register_product, list_products, find_product
from ventas import sell_product
from factura import show_invoice


def read_int(prompt):
    # Lee un entero con validación (spike 9.1).
    while True:
        try:
            return int(input(prompt))
        except ValueError:
            print("Eso no es un número entero; intenta de nuevo.")


def main():
    # Lista compartida: cada producto es un dict
    # {"name": str, "price": float, "kilos": float}
    product_list = [
        {"name": "manzana", "price": 2.50, "kilos": 10.0},
        {"name": "banana", "price": 1.80, "kilos": 15.0},
        {"name": "naranja", "price": 1.20, "kilos": 20.0},
    ]
    # Factura de la venta actual: lista de items vendidos
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

**Paso 3: Verificar que `productos.py` tiene `find_product()`**

Si no la tiene, agregala:

```python
def find_product(product_list, name):
    """Busca un producto por nombre en productList y muestra su info."""
    for product in product_list:
        if product["name"] == name.strip().lower():
            return product
    return None
```

**Paso 4: Verificar que `ventas.py` existe con `sell_product()`**

Verificar que el archivo tiene la función `sell_product()` y que importa `find_product` y `read_float` correctamente.

**Paso 5: Ejecutar el programa completo**

```bash
python main.py
```

Probar: 1 (registrar Pera, 3.5/kg, 8kg), 3 (vender 2kg de manzana), 4 (ver factura), 5 (salir).

**Paso 6: Si funciona, commitear y abrir PR**

```bash
git add .
git commit -m "integrador: integrar todos los módulos en main.py"
git push -u origin feature/integracion-final
```

Abrir PR, revisión entre pares, mergear.

## 5. Ejercicio independiente (25 min)

**Consigna:** Cada grupo termina el integrador siguiendo estos pasos:

1. **Cerrar issues pendientes:** revisá qué issues están abiertos y asegurate de que todos tengan PR mergeado. Si un issue no está resuelto, asignalo a un integrante ahora.
2. **Completar `factura.py`** si falta: debe mostrar cada item (nombre, kilos, precio, subtotal) y el total de la factura.
3. **Probar el programa completo** con la checklist canónica:
   - ☐ Registrar producto y verlo en la lista.
   - ☐ Vender producto con stock suficiente.
   - ☐ Vender producto sin stock suficiente (debe mostrar mensaje de error).
   - ☐ Vender producto que no existe.
   - ☐ Ver factura sin haber vendido nada.
   - ☐ Ingresar texto donde se espera número.
   - ☐ Elegir opción 6 (inexistente).
   - ☐ Salir del programa.
4. **Preparar la defensa:** cada integrante escribe 3-4 líneas sobre qué va a explicar en la defensa individual. Guardarlo como `DEFENSA.md` en el repo.

**Pista:** Para la factura, si la lista `invoice` está vacía mostrá "No hay ventas registradas.".

**Solución esperada:** Un programa que ejecuta las 8 pruebas de la checklist sin errores. Archivo `DEFENSA.md` en la raíz. Todos los issues cerrados.

## 6. Extensión y consolidación (20 min)

**Para los grupos que terminaron:**

1. **Mejora opcional:** Agregá una opción "Actualizar precio" que pida el nombre del producto y el nuevo precio, y lo actualice en la lista. Creá un issue, rama, PR y mergealo.
2. **Refactor:** Pasá `read_int` y `read_float` a un archivo `utils.py` e importalas desde cada módulo. Creá el PR correspondiente.
3. **Verificación final del repositorio:** Revisá que el README tenga las instrucciones correctas de ejecución y que `.gitignore` exista con `__pycache__/`.

## 7. Cierre (10 min)

### Qué te llevás

- Integrar módulos en Python es cuestión de `from ... import ...` en la parte superior del archivo.
- El estado compartido (lista de productos, factura) se pasa como argumento: cada función recibe lo que necesita.
- La prueba canónica no es opcional: sin ella, el programa puede fallar en la defensa.
- Preparar la defensa ahora evita el estrés de último minuto: sabés qué decir y cómo mostrarlo.

### Lo que viene

En el **Encuentro 31** es el **cierre de la Unidad 4 y entrega final**: sistematizamos todo el trabajo, hacemos el commit final del trabajo integrador y preparamos la defensa individual delante del docente. Después del encuentro 31 viene el **Encuentro 32 — Defensa del integrador**, donde cada integrante presenta su trabajo individualmente.

## 8. Errores comunes y trampas

1. **Import circular o archivo que no existe.** *Causa:* `main.py` importa `productos` pero `productos.py` está en otra carpeta o no existe. *Fix:* verificar que todos los `.py` estén en `trabajo-final/` y que los imports no tengan puntos.

2. **La factura se borra al volver al menú.** *Causa:* en lugar de acumular items, la función crea una factura nueva cada vez. *Fix:* pasar la misma lista `current_invoice` a todas las llamadas de `sell_product()`.

3. **Menú que no vuelve después de una opción.** *Causa:* faltó indentar o el `break` corta el loop. *Fix:* verificar que la opción 5 (Salir) sea la única que interrumpe el `while True`.

4. **El programa crashea si se ingresa un float en `read_int`.** *Causa:* `int()` no acepta strings con punto decimal (spike 9.1). *Fix:* usar `read_float()` para precio y kilos; `read_int()` solo para opciones del menú y cantidades enteras.

5. **El producto se busca exacto sin normalizar.** *Causa:* el usuario escribe "Manzana" y el código busca "manzana". *Fix:* aplicar `.strip().lower()` al nombre de búsqueda y al momento de registrar.

6. **Commit de integración sin probar.** *Causa:* mergear el PR de integración sin ejecutar `python main.py`. *Fix:* probar antes de mergear; si falla, no se mergea.
