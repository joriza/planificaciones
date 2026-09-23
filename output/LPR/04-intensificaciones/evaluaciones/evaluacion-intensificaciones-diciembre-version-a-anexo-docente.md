# Anexo docente — Evaluación de la intensificación de diciembre — Versión A

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión A, las respuestas esperadas de los ítems conceptuales, los criterios de corrección ítem por ítem y la pauta de devolución.

## 1. Solución completa

### Programa de referencia `verduleria.py`

```python
def agregar_producto(product_list, product_name, product_price, stock_weight):
    # Agrega un producto a la lista como diccionario.
    producto = {
        "productName": product_name,
        "productPrice": product_price,
        "stockWeight": stock_weight
    }
    product_list.append(producto)
    return producto


def listar_productos(product_list):
    # Muestra cada producto con su precio y stock.
    for producto in product_list:
        print(f"{producto['productName']}: ${producto['productPrice']:.2f} — Stock: {producto['stockWeight']} kg")


def buscar_producto(product_list, product_name):
    # Busca un producto por nombre y lo devuelve o None.
    for producto in product_list:
        if producto["productName"] == product_name:
            return producto
    return None


def vender_producto(product_list, product_name, cantidad):
    # Registra una venta si hay stock suficiente y devuelve el total.
    producto = buscar_producto(product_list, product_name)
    if producto is None:
        return "Producto no encontrado"
    if cantidad > producto["stockWeight"]:
        return "Stock insuficiente"
    total = producto["productPrice"] * cantidad
    producto["stockWeight"] -= cantidad
    return total


if __name__ == "__main__":
    product_list = []

    while True:
        print("=== VERDULERIA ===")
        print("1. Agregar producto")
        print("2. Listar productos")
        print("3. Buscar producto")
        print("4. Vender producto")
        print("5. Salir")
        opcion = input("Opción: ")

        if opcion == "1":
            nombre = input("Nombre del producto: ")
            try:
                precio = float(input("Precio: $"))
                kilos = float(input("Kilos disponibles: "))
            except ValueError:
                print("Dato inválido, intente de nuevo.")
                continue
            agregar_producto(product_list, nombre, precio, kilos)
            print(f"Producto '{nombre}' agregado.")
        elif opcion == "2":
            listar_productos(product_list)
        elif opcion == "3":
            nombre = input("Nombre del producto a buscar: ")
            resultado = buscar_producto(product_list, nombre)
            if resultado:
                print(f"Encontrado: {resultado['productName']} — ${resultado['productPrice']:.2f} — {resultado['stockWeight']} kg")
            else:
                print("Producto no encontrado")
        elif opcion == "4":
            nombre = input("Nombre del producto: ")
            try:
                cantidad = float(input("Cantidad en kg: "))
            except ValueError:
                print("Dato inválido, intente de nuevo.")
                continue
            resultado = vender_producto(product_list, nombre, cantidad)
            print(f"Resultado de la venta: {resultado}")
        elif opcion == "5":
            break
        else:
            print("Opción inválida")
```

## 2. Salidas de referencia para la corrección

| Prueba | Pedido | Respuesta esperada | Comando de verificación |
| --- | --- | --- | --- |
| Programa base | Variables con tipos correctos (`str`, `float`, `int`) | El programa declara variables y usa `input()` con conversión | Ejecutar y verificar que pide datos correctamente |
| Condicionales | `if`/`elif`/`else` para stock bajo y descuento | Si kilos < 1 → "Stock bajo". Si precio > 500 → descuento del 10% | Ejecutar con kilos=0.5 y precio=600 |
| Bucle `while` con menú | `while True` con opciones 1 a 5 y `break` en opción 5 | El programa muestra el menú repetidamente hasta que el usuario elige salir | Ejecutar y verificar que la opción 5 termina el programa |
| Lista de productos | `append()` para agregar, `for` para mostrar | Se muestran los productos agregados con sus datos | Ejecutar con 2 productos agregados |
| Búsqueda por nombre | `for` sobre la lista comparando `productName` | Muestra el producto encontrado o "Producto no encontrado" | Ejecutar buscando un producto existente y uno inexistente |
| Funciones | Al menos `agregar_producto`, `listar_productos`, `buscar_producto`, `vender_producto` con `def`, parámetros y `return` | Todas las funciones están definidas correctamente | Inspeccionar la definición de cada función |
| Bloque principal | `if __name__ == "__main__":` con menú | El programa arranca desde el bloque principal | Ejecutar el archivo directamente |
| `try`/`except` | `try`/`except ValueError` para conversión de precio y kilos | Muestra "Dato inválido, intente de nuevo" si el usuario ingresa texto donde se espera un número | Ejecutar ingresando texto en lugar de un número |

## 3. Criterios de corrección ítem por ítem

- **Programa base (10 pts):** 5 pts por variables con tipos correctos. 5 pts por `input()` con conversión de tipos.
- **Condicionales (15 pts):** 5 pts por `if`/`elif`/`else` para stock bajo. 5 pts por descuento del 10% cuando el precio > 500. 5 pts por mensajes claros.
- **Bucle `while` con menú (10 pts):** 5 pts por `while True`. 5 pts por `break` en opción 5 y manejo de opción inválida.
- **Lista de productos (10 pts):** 5 pts por `append()` para agregar. 5 pts por `for` para mostrar con f-string.
- **Búsqueda por nombre (10 pts):** 5 pts por el `for` sobre la lista. 5 pts por la comparación de `productName` y el mensaje "Producto no encontrado".
- **Funciones (15 pts):** 5 pts por cada función con `def`, parámetros y `return` correctos (3 funciones × 5 pts).
- **Bloque principal (10 pts):** 5 pts por `if __name__ == "__main__":`. 5 pts por la inicialización de `product_list` y la llamada al menú.
- **`try`/`except` (10 pts):** 5 pts por el bloque `try`/`except ValueError`. 5 pts por el mensaje de error claro.
- **Commit y push (5 pts):** 5 pts por el commit con mensaje descriptivo y push al repo.

**Total:** 100 puntos. Criterio de Apto: ≥ 60 puntos.

**Errores previstos y criterio de intervención:**
- Si el alumno usa `lista = lista.append(x)`, pedirle que corrija: `append` devuelve `None`.
- Si el alumno no usa `try`/`except` para la conversión de `input()`, indicar que `input()` siempre devuelve `str`.
- Si el alumno no tiene el bloque `if __name__ == "__main__":`, pedirle que mueva la ejecución al bloque principal.
- Si el alumno no actualiza el stock después de una venta, pedirle que reste la cantidad vendida del stock.
- Si el alumno confunde `stockWeight` (cantidad en kg) con `productPrice` (precio unitario), reforzar con el ejemplo de la venta.

## 4. Pauta de devolución

La devolución se realiza al finalizar la defensa oral. Se devuelve con nota de Apto o No apto aún por objetivo mínimo. Si el objetivo mínimo queda pendiente, se informa la instancia de marzo como siguiente oportunidad con el mismo estándar, y se entrega la lista de objetivos pendientes para que el estudiante se prepare. Se registra la nota en la planilla de evaluación y se anota la letra de la versión asignada.