# Anexo docente — Evaluación del momento 17-18 — Versión A

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión A, las respuestas esperadas de los ítems conceptuales, los criterios de corrección ítem por ítem y la pauta de devolución.

## 1. Solución completa

### Programa de referencia `kiosco_club.py`

```python
def register_sale(articulos, stock, ventas, descuento, cliente, item_price, cantidad):
    # Registra una venta si hay stock suficiente y devuelve el diccionario de venta.
    if cantidad > stock:
        return "Stock insuficiente"
    total = item_price * cantidad
    if total > 200:
        total = total * 0.9  # descuento del 10%
    venta = {"cliente": cliente, "producto": articulos[0], "cantidad": cantidad, "total": total}
    ventas.append(venta)
    return venta


def listar_articulos(articulos, stock, precios):
    # Muestra cada articulo con su precio y stock disponible.
    for i in range(len(articulos)):
        print(f"{articulos[i]}: ${precios[i]:.2f} — Stock: {stock[i]}")


def mostrar_clientes(ventas):
    # Muestra los clientes que compraron sin repetir.
    vistos = set()
    for venta in ventas:
        cliente = venta["cliente"]
        if cliente not in vistos:
            print(cliente)
            vistos.add(cliente)


def calcular_total(ventas):
    # Suma el total de todas las ventas registradas.
    total = 0
    for venta in ventas:
        total += venta["total"]
    return total


if __name__ == "__main__":
    articulos = ["Caramelos", "Galletitas", "Jugo"]
    precios = [50.0, 120.0, 80.0]
    stock = [100, 50, 30]
    ventas = []

    while True:
        print("=== KIOSCO ESCOLAR ===")
        print("1. Registrar venta")
        print("2. Mostrar articulos")
        print("3. Mostrar clientes")
        print("4. Calcular total de ventas")
        print("5. Salir")
        opcion = input("Opción: ")

        if opcion == "1":
            cliente = input("Nombre del cliente: ")
            producto = input("Producto: ")
            cantidad = int(input("Cantidad: "))
            precio = precios[articulos.index(producto)]
            resultado = register_sale(articulos, stock[articulos.index(producto)], ventas, 0.1, cliente, precio, cantidad)
            print(f"Venta registrada: {resultado}")
        elif opcion == "2":
            listar_articulos(articulos, stock, precios)
        elif opcion == "3":
            mostrar_clientes(ventas)
        elif opcion == "4":
            total = calcular_total(ventas)
            print(f"Total de ventas del día: ${total:.2f}")
        elif opcion == "5":
            break
        else:
            print("Opción inválida")
```

## 2. Salidas de referencia para la corrección

| Prueba | Pedido | Respuesta esperada | Comando de verificación |
| --- | --- | --- | ---|
| Menú principal | Bucle `while True` con opciones 1 a 5 y `break` en opción 5 | El programa muestra el menú repetidamente hasta que el usuario elige salir | Ejecutar y verificar que la opción 5 termina el programa |
| Opción 1 — Registrar venta | `registerSale` con validación de stock y descuento del 10% | Si stock < cantidad → "Stock insuficiente". Si total > 200 → descuento aplicado | Ejecutar con stock=2, cantidad=5 y con total > 200 |
| Opción 2 — Mostrar articulos | `for` sobre la lista de artículos mostrando nombre, precio y stock | Se muestran los 3 artículos con sus datos | Ejecutar y verificar la salida |
| Opción 3 — Mostrar clientes | `set` para evitar duplicados, `for` sobre ventas | Se muestran los clientes sin repetir | Ejecutar con 2 ventas del mismo cliente |
| Opción 4 — Calcular total | Acumulador `total` con `for` sobre ventas | Suma correcta de todos los totales de venta | Ejecutar con 2 ventas y verificar la suma |
| Función `registerSale` | `def` con parámetros, `return` de venta o mensaje | La función recibe los datos y devuelve el resultado correcto | Inspeccionar la definición de la función |
| Bloque principal | `if __name__ == "__main__":` con menú | El programa arranca desde el bloque principal | Ejecutar el archivo directamente |

## 3. Criterios de corrección ítem por ítem

- **Menú principal (10 pts):** 5 pts por `while True` con opciones. 5 pts por `break` en opción 5 y manejo de opción inválida.
- **Opción 1 — Registrar venta (20 pts):** 10 pts por la validación de stock correcta. 10 pts por el descuento del 10% cuando el total supera $200.
- **Opción 2 — Mostrar articulos (10 pts):** 5 pts por el `for` sobre la lista. 5 pts por la salida con f-string mostrando nombre, precio y stock.
- **Opción 3 — Mostrar clientes (10 pts):** 5 pts por el uso de `set` para evitar duplicados. 5 pts por el `for` sobre la lista de ventas.
- **Opción 4 — Calcular total (10 pts):** 5 pts por el acumulador `total`. 5 pts por la función `calcular_total` con `return`.
- **Función `registerSale` (15 pts):** 5 pts por `def` con parámetros correctos. 5 pts por `return` de la venta registrada. 5 pts por el mensaje de error "Stock insuficiente".
- **Bloque principal (10 pts):** 5 pts por `if __name__ == "__main__":`. 5 pts por la inicialización de variables y la llamada al menú.
- **Try/except (10 pts):** 5 pts por el bloque `try`/`except ValueError`. 5 pts por el mensaje de error claro.
- **Commit y push (5 pts):** 5 pts por el commit con mensaje descriptivo y push al repo.

**Total:** 100 puntos. Criterio de Apto: ≥ 60 puntos.

**Errores previstos y criterio de intervención:**
- Si el alumno usa `lista = lista.append(x)`, pedirle que corrija: `append` devuelve `None`.
- Si el alumno no usa `try`/`except` para la conversión de `input()`, indicar que `input()` siempre devuelve `str`.
- Si el alumno no tiene el bloque `if __name__ == "__main__":`, pedirle que mueva la ejecución al bloque principal.
- Si el alumno no distingue `stock` (cantidad disponible) del `total` (precio × cantidad), reforzar con el ejemplo de la venta.

## 4. Pauta de devolución

La devolución se realiza en el encuentro 18. Se devuelve con nota de Apto o No apto aún por objetivo mínimo. Si el objetivo mínimo queda pendiente, se ofrece el proyecto puente (encuentros 19-20) como primera capa de recuperación y la intensificación de las Unidades 3 y 4 (encuentros 34-35) como segunda capa. Se registra la nota en la planilla de evaluación y se anota la letra de la versión asignada.