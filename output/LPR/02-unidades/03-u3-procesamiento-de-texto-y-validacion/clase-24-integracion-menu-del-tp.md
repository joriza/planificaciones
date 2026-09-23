# Encuentro 24 — Integración: menú del TP

> Procesamiento de texto y validación

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 24 de 36 |
| Unidad | 3 — Procesamiento de texto y validación |
| Eje temático | 3 — Procesamiento de texto y validación |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 120 minutos (2 horas) |
| Concepto nuevo | Integración: menú del TP |
| Requisitos previos | Encuentros 21–23: cadenas, try/except, módulos y menú en memoria |
| Uso de celular | No permitido |
| Organización del trabajo | Trabajo individual en terminal; el docente circula y acompaña a quienes lo necesiten |

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

1. Diseñar un programa completo en un solo archivo `.py` que integre funciones, colecciones, menú textual y validación de entrada.
2. Aplicar el patrón de menú en memoria con `while True`, `if/elif/else` y `break`.
3. Consolidar el uso de `try/except ValueError` para toda entrada numérica del usuario.
4. Organizar el código con funciones arriba y bloque `if __name__ == "__main__":` al final.

## 3. Teoría mínima (20 min)

### Charla rápida: el menú como corazón del programa

Un menú de consola es como el tablero de control de un avión: tiene opciones claras, cada una hace algo distinto y el piloto (el usuario) elige qué hacer. En este encuentro vamos a armar el TP-U3 completo: un programa de menú de consola validado que vive entero en memoria, sin archivos ni bases de datos. El menú es el corazón del programa; las funciones son los motores de cada opción.

### Lo mínimo indispensable

- Un programa completo en un solo archivo `.py` se organiza así: imports arriba, funciones en el medio, bloque `if __name__ == "__main__":` al final.
- El menú se implementa con `while True` que muestra opciones, lee la elección con `input()`, y ejecuta la acción con `if/elif/else`.
- Cada opción del menú puede ser una función separada que use `try/except ValueError` para validar entradas numéricas.
- El estado del programa vive en variables y colecciones en memoria (listas, diccionarios).
- No se usa persistencia de ningún tipo: no archivos, no CSV, no JSON, no base de datos.

## 4. Práctica guiada (35 min)

**Paso 1** — Creá un archivo `tp_u3_menu.py` con la siguiente estructura base:

```python
# tp_u3_menu.py
# TP-U3: menú de consola validado en memoria.
# Gestiona una lista de productos con nombre y precio.

def mostrar_menu():
    # Muestra el menú de opciones al usuario.
    print("\n--- Menú de Productos ---")
    print("1. Agregar producto")
    print("2. Listar productos")
    print("3. Buscar producto")
    print("4. Salir")


def agregar_producto(productos):
    # Agrega un producto a la lista con validación de precio.
    nombre = input("Nombre del producto: ").strip()
    if not nombre:
        print("El nombre no puede estar vacío.")
        return
    while True:
        try:
            precio = float(input("Precio: "))
            if precio < 0:
                print("El precio no puede ser negativo; intentá de nuevo.")
                continue
            break
        except ValueError:
            print("Eso no es un número; intentá de nuevo.")
    productos.append({"nombre": nombre, "precio": precio})
    print(f"Producto '{nombre}' agregado con éxito.")


def listar_productos(productos):
    # Muestra todos los productos con su precio formateado.
    if not productos:
        print("No hay productos cargados.")
        return
    print("\n--- Lista de Productos ---")
    for i, prod in enumerate(productos, 1):
        print(f"{i}. {prod['nombre']} — ${prod['precio']:.2f}")


def buscar_producto(productos):
    # Busca un producto por nombre usando strip y lower.
    if not productos:
        print("No hay productos cargados.")
        return
    termino = input("Ingresá el nombre a buscar: ").strip().lower()
    encontrados = [p for p in productos if termino in p["nombre"].lower()]
    if not encontrados:
        print(f"No se encontraron productos que contengan '{termino}'.")
        return
    print(f"\n--- Resultados para '{termino}' ---")
    for prod in encontrados:
        print(f"  {prod['nombre']} — ${prod['precio']:.2f}")


def main():
    # Bloque de ejecución principal: menú en memoria con while True.
    productos = []
    while True:
        mostrar_menu()
        opcion = input("Elegí una opción: ").strip()
        if opcion == "1":
            agregar_producto(productos)
        elif opcion == "2":
            listar_productos(productos)
        elif opcion == "3":
            buscar_producto(productos)
        elif opcion == "4":
            print("¡Hasta luego!")
            break
        else:
            print("Opción inválida; elegí 1, 2, 3 o 4.")


if __name__ == "__main__":
    main()
```

**Paso 2** — Ejecutá el programa y probá todas las rutas:

1. Opción `1`: agregá dos productos (ej. `café` a `150` y `té` a `80`).
2. Opción `2`: listá los productos y verificá que se muestran con precio formateado.
3. Opción `3`: buscá `caf` y verificá que encuentra `café`.
4. Opción `4`: sale del programa.
5. Opción `5` (inválida): muestra el mensaje de opción inválida.
6. En opción `1`, probá precio no numérico (`abc`) y precio negativo (`-10`).

**Paso 3** — Agregá una opción `5` que elimine el último producto de la lista (usá `pop()`). Mostrá un mensaje si la lista está vacía.

## 5. Ejercicio independiente (25 min)

**Consigna:** Completá el programa `tp_u3_menu.py` agregando las siguientes funcionalidades: (a) opción `5` para eliminar un producto por número de índice, (b) opción `6` para mostrar el total de productos y el promedio de precios, y (c) validación de que el índice de eliminación sea un número válido y esté dentro del rango de la lista. Pista: para la opción de eliminar, usá `pop(indice)` y validá que `indice` esté en `range(len(productos))`.

**Solución esperada:**

```python
# tp_u3_menu.py
# TP-U3: menú de consola validado en memoria.
# Gestiona una lista de productos con nombre y precio.

def mostrar_menu():
    # Muestra el menú de opciones al usuario.
    print("\n--- Menú de Productos ---")
    print("1. Agregar producto")
    print("2. Listar productos")
    print("3. Buscar producto")
    print("4. Eliminar producto")
    print("5. Resumen de productos")
    print("6. Salir")


def agregar_producto(productos):
    # Agrega un producto a la lista con validación de precio.
    nombre = input("Nombre del producto: ").strip()
    if not nombre:
        print("El nombre no puede estar vacío.")
        return
    while True:
        try:
            precio = float(input("Precio: "))
            if precio < 0:
                print("El precio no puede ser negativo; intentá de nuevo.")
                continue
            break
        except ValueError:
            print("Eso no es un número; intentá de nuevo.")
    productos.append({"nombre": nombre, "precio": precio})
    print(f"Producto '{nombre}' agregado con éxito.")


def listar_productos(productos):
    # Muestra todos los productos con su precio formateado.
    if not productos:
        print("No hay productos cargados.")
        return
    print("\n--- Lista de Productos ---")
    for i, prod in enumerate(productos, 1):
        print(f"{i}. {prod['nombre']} — ${prod['precio']:.2f}")


def buscar_producto(productos):
    # Busca un producto por nombre usando strip y lower.
    if not productos:
        print("No hay productos cargados.")
        return
    termino = input("Ingresá el nombre a buscar: ").strip().lower()
    encontrados = [p for p in productos if termino in p["nombre"].lower()]
    if not encontrados:
        print(f"No se encontraron productos que contengan '{termino}'.")
        return
    print(f"\n--- Resultados para '{termino}' ---")
    for prod in encontrados:
        print(f"  {prod['nombre']} — ${prod['precio']:.2f}")


def eliminar_producto(productos):
    # Elimina un producto por índice validado.
    if not productos:
        print("No hay productos para eliminar.")
        return
    listar_productos(productos)
    while True:
        try:
            indice = int(input("Ingresá el número del producto a eliminar: "))
            if indice < 1 or indice > len(productos):
                print(f"Ingresá un número entre 1 y {len(productos)}.")
                continue
            eliminado = productos.pop(indice - 1)
            print(f"Eliminado: {eliminado['nombre']}")
            break
        except ValueError:
            print("Eso no es un número; intentá de nuevo.")


def resumen_productos(productos):
    # Muestra la cantidad total y el promedio de precios.
    if not productos:
        print("No hay productos cargados.")
        return
    total = sum(p["precio"] for p in productos)
    promedio = total / len(productos)
    print(f"Total de productos: {len(productos)}")
    print(f"Promedio de precios: ${promedio:.2f}")


def main():
    # Bloque de ejecución principal: menú en memoria con while True.
    productos = []
    while True:
        mostrar_menu()
        opcion = input("Elegí una opción: ").strip()
        if opcion == "1":
            agregar_producto(productos)
        elif opcion == "2":
            listar_productos(productos)
        elif opcion == "3":
            buscar_producto(productos)
        elif opcion == "4":
            eliminar_producto(productos)
        elif opcion == "5":
            resumen_productos(productos)
        elif opcion == "6":
            print("¡Hasta luego!")
            break
        else:
            print("Opción inválida; elegí 1, 2, 3, 4, 5 o 6.")


if __name__ == "__main__":
    main()
```

**Salida esperada** (con productos `café` a `150` y `té` a `80`, opción 5):

```
Total de productos: 2
Promedio de precios: $115.00
```

## 6. Extensión y consolidación (20 min)

**Actividad 1 — Ordenar productos:** Agregá una opción que muestre los productos ordenados por precio de menor a mayor. Usá `productos.sort(key=lambda p: p["precio"])` o una función auxiliar con `sorted()`.

**Actividad 2 — Validación de rango en el menú:** Creá una función `read_menu_option(min_val, max_val)` que valide que la opción ingresada esté dentro del rango permitido, usando `try/except` y un bucle de reintento.

## 7. Cierre (10 min)

### Qué te llevás

- Un programa completo en un solo archivo `.py` se organiza con imports arriba, funciones en el medio y `if __name__ == "__main__":` al final.
- El patrón de menú en memoria combina `while True`, `if/elif/else`, `break` y validación con `try/except ValueError`.
- Las colecciones (`list` de `dict`) permiten gestionar datos en memoria sin persistencia.
- La validación de entrada es responsabilidad de cada función que lee datos numéricos.

### Lo que viene

En el próximo encuentro vamos a cerrar la Unidad 3 con el repaso general y la entrega del TP-U3.

## 8. Errores comunes y trampas

1. **`productos = productos.pop(x)`** — `pop()` muta la lista y devuelve el elemento eliminado; asignarlo a la misma variable pierde la referencia a la lista. Usá `productos.pop(x)` en su propia línea.
2. **Índice fuera de rango en `pop()`** — Si el usuario ingresa un número mayor a la longitud de la lista, `pop()` lanza `IndexError`. Validá que el índice esté en `range(len(productos))` antes de llamar a `pop()`.
3. **`float()` en `input()` sin `try/except`** — Si el usuario tipea texto no numérico, el programa se rompe con `ValueError`. Siempre envolver la conversión en `try/except`.
4. **Usar `while True` sin `break` en la opción de salida** — El menú queda en loop infinito y el programa nunca termina. Asegurarse de que la opción de salida tenga un `break`.
5. **`if/elif` incompleto** — Si no hay un `else` para opciones inválidas, el programa no avisa al usuario y el menú no se vuelve a mostrar correctamente en algunos flujos. Siempre incluir un `else` con mensaje de opción inválida.
6. **Código suelto fuera del bloque principal** — Definiciones de funciones deben estar arriba; la ejecución debe estar dentro de `if __name__ == "__main__":`.
