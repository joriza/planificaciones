# Anexo docente — Encuentro 25: Cierre U3: repaso y TP

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

La solución del ejercicio independiente de la clase 24 es el programa `tp_u3_menu.py` completo, que se reproduce a continuación:

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

**Explicación:** Este programa integra todos los conceptos de la unidad 3: funciones (`def`), colecciones (`list` de `dict`), menú en memoria (`while True` + `if/elif/else` + `break`), validación de entrada (`try/except ValueError`), y f-strings con formato (`.2f`). No usa persistencia de ningún tipo. El código tiene comentarios en español que explican cada acción relevante.

## 2. Solución de la actividad de extensión

**Actividad 1 — Ordenar productos por precio:**

La función `ordenar_productos` se agrega al programa y se incluye como opción `7` en el menú:

```python
def ordenar_productos(productos):
    # Muestra los productos ordenados por precio de menor a mayor.
    if not productos:
        print("No hay productos para ordenar.")
        return
    ordenados = sorted(productos, key=lambda p: p["precio"])
    print("\n--- Productos ordenados por precio ---")
    for i, prod in enumerate(ordenados, 1):
        print(f"{i}. {prod['nombre']} — ${prod['precio']:.2f}")
```

**Actividad 2 — Función `read_menu_option`:**

```python
def read_menu_option(min_val, max_val):
    # Pide una opción de menú y valida que esté en el rango [min_val, max_val].
    while True:
        try:
            opcion = int(input("Elegí una opción: "))
            if opcion < min_val or opcion > max_val:
                print(f"Ingresá un número entre {min_val} y {max_val}.")
                continue
            return opcion
        except ValueError:
            print("Eso no es un número; intentá de nuevo.")
```

Esta función centraliza la lectura y validación del menú, reemplazando la lectura directa de `input()` en `main()`.

## 3. Respuesta esperada del ejercicio

| Ruta | Entradas | Salida esperada |
| --- | --- | --- |
| Agregar | `café`, `150` | `Producto 'café' agregado con éxito.` |
| Agregar | `té`, `80` | `Producto 'té' agregado con éxito.` |
| Listar | — | `1. café — $150.00` / `2. té — $80.00` |
| Buscar | `caf` | `café — $150.00` |
| Eliminar | `1` | `Eliminado: café` |
| Resumen | — | `Total de productos: 1` / `Promedio de precios: $80.00` |
| Salir | — | `¡Hasta luego!` |
| Eliminar (lista vacía) | — | `No hay productos para eliminar.` |
| Precio no numérico | `abc` | `Eso no es un número; intentá de nuevo.` |
| Precio negativo | `-10` | `El precio no puede ser negativo; intentá de nuevo.` |

## 4. Criterios de corrección (lista de verificación)

- [ ] El programa vive en un solo archivo `.py`.
- [ ] El menú tiene al menos 4 opciones.
- [ ] Cada opción del menú es una función separada.
- [ ] La validación de entrada numérica usa `try/except ValueError`.
- [ ] Se usa `strip()` para limpiar las entradas de texto.
- [ ] Los resultados se muestran con f-strings formateados (`.2f` para precios).
- [ ] No usa persistencia de ningún tipo (sin archivos, CSV, JSON ni base de datos).
- [ ] El código tiene comentarios en español que explican cada paso relevante.
- [ ] Los identificadores están en inglés y en `snake_case`.
- [ ] El programa tiene menos de 150 líneas.
- [ ] El programa se ejecuta correctamente con `python tp_u3_menu.py`.
- [ ] La entrega incluye carpeta nueva, commit con mensaje claro y push.

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| `IndexError` en `pop()` | No validó que el índice esté en rango | Mostrar que `pop()` lanza `IndexError` si el índice es inválido; validar con `if indice < 1 or indice > len(productos)` antes de llamar |
| `productos = productos.pop(x)` | Confunde el retorno de `pop()` con la lista | Recordar que `pop()` muta la lista y devuelve el elemento; la lista se modifica in-place |
| El menú no se repite tras una acción | Falta `while True` o `break` mal colocado | Verificar que el `while True` envuelva todo el menú y que solo la opción de salida tenga `break` |
| `float()` sin `try/except` | El programa se rompe con entrada no numérica | Reforzar que `input()` siempre devuelve `str` y que `float()` lanza `ValueError` |
| `else` faltante en el menú | Las opciones inválidas no generan mensaje | Señalar que todo menú debe tener un `else` para opciones no reconocidas |
| `lista = lista.append(x)` | Confunde mutación con retorno | Recordar que `append()` devuelve `None` y muta la lista in-place |
| Código suelto fuera del bloque principal | La ejecución no está dentro de `if __name__ == "__main__":` | Recordar la organización canónica: imports, funciones, bloque principal |

## 6. Registro de la clase

| Indicador | Qué registrar |
| --- | --- |
| Participación | Cantidad de alumnos que completaron y entregaron el TP-U3 |
| Concepto clave | ¿Pueden explicar por qué `productos = productos.pop(x)` es un error? |
| Dificultad frecuente | ¿Quién tuvo problemas con la validación de índice en `eliminar_producto`? |
| Tiempo empleado | Minutos promedio hasta completar la entrega del TP-U3 |
| Observaciones | Notas cualitativas sobre grupos que necesitaron apoyo extra con `sorted()` o `lambda` |
| Entrega | ¿Se realizó la entrega con carpeta nueva, commit y push? |
