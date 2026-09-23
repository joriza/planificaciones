# Anexo docente — Encuentro 8: Cierre U1: repaso y TP

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

**Consigna:** TP-U1: programa `kiosco.py` para simular la atención en un kiosco escolar.

```python
# TP-U1: Kiosco escolar
# Programa de consola con entrada y control de flujo

# Productos del kiosco: codigo -> (nombre, precio, stock)
products = {
    101: ("Caramelos", 50.0, 30),
    102: ("Chicles", 25.0, 50),
    103: ("Galletitas", 100.0, 20),
    104: ("Jugos", 150.0, 15)
}

# Acumuladores de la sesion
total_units = 0
total_money = 0.0

running = True
while running:
    print()
    print("=== KIOSCO ESCOLAR ===")
    print("1. Ver lista de productos")
    print("2. Registrar una venta")
    print("3. Mostrar resumen de ventas")
    print("4. Salir")

    option = input("Elegi una opcion: ")

    if option == "1":
        print()
        print("CODIGO  | PRODUCTO     | PRECIO  | STOCK")
        print("--------|-------------|---------|------")
        for code in products:
            name, price, stock = products[code]
            print(f"{code:6d}  | {name:12s} | ${price:6.2f} | {stock:3d}")

    elif option == "2":
        print()
        # Pedir codigo de producto
        while True:
            try:
                code = int(input("Codigo del producto: "))
                break
            except ValueError:
                print("Codigo invalido; debe ser un numero.")

        if code in products:
            name, price, stock = products[code]
            print(f"Producto: {name} — Precio: ${price:.2f}")
            print(f"Stock disponible: {stock}")

            # Pedir cantidad
            while True:
                try:
                    quantity = int(input("Cantidad: "))
                    if quantity > 0:
                        break
                    print("La cantidad debe ser positiva.")
                except ValueError:
                    print("Cantidad invalida; debe ser un numero.")

            if quantity <= stock:
                # Calcular total con posible descuento
                if quantity > 5:
                    discount = 0.10
                    subtotal = price * quantity
                    final_price = subtotal * (1 - discount)
                    print(f"Descuento del 10% aplicado por comprar mas de 5.")
                else:
                    final_price = price * quantity

                # Descontar stock
                new_stock = stock - quantity
                products[code] = (name, price, new_stock)

                # Acumular en la sesion
                total_units = total_units + quantity
                total_money = total_money + final_price

                print(f"Venta registrada: {quantity} x {name} = ${final_price:.2f}")
            else:
                print(f"Stock insuficiente. Solo hay {stock} unidad(es).")
        else:
            print("Codigo de producto no encontrado.")

    elif option == "3":
        print()
        print("=== RESUMEN DE VENTAS (SESION ACTUAL) ===")
        print(f"Unidades vendidas: {total_units}")
        print(f"Dinero acumulado: ${total_money:.2f}")

    elif option == "4":
        running = False
        print("Gracias por usar el sistema. Saludos!")

    else:
        print("Opcion invalida. Elegi 1, 2, 3 o 4.")
```

**Salida verificada** (ejemplo de interacción completa):

```
=== KIOSCO ESCOLAR ===
1. Ver lista de productos
2. Registrar una venta
3. Mostrar resumen de ventas
4. Salir
Elegi una opcion: 2

Codigo del producto: 101
Producto: Caramelos — Precio: $50.00
Stock disponible: 30
Cantidad: 6
Descuento del 10% aplicado por comprar mas de 5.
Venta registrada: 6 x Caramelos = $270.00

Elegi una opcion: 3

=== RESUMEN DE VENTAS (SESION ACTUAL) ===
Unidades vendidas: 6
Dinero acumulado: $270.00

Elegi una opcion: 4
Gracias por usar el sistema. Saludos!
```

## 2. Solución de la actividad de extensión

En el Encuentro 8 las actividades de extensión son opcionales y no forman parte del TP obligatorio. Se sugieren para grupos que terminaron antes:

1. **Agregar un producto nuevo desde el menú.** Opción 5: pedir código, nombre, precio y stock; validar que el código no exista ya.
2. **Buscar producto por nombre.** Opción 6: pedir un texto y mostrar todos los productos cuyo nombre contenga ese texto (usar `in`).
3. **Mostrar productos con stock bajo.** Opción 7: mostrar productos con stock menor a 5.

No se proporciona solución completa de estas extensiones; el docente las usa como desafío abierto.

## 3. Respuesta esperada del ejercicio

### Programa `kiosco.py`
| Aspecto | Esperado |
|---|---|
| Productos | Diccionario con al menos 4 productos, cada uno como tupla `(nombre, precio, stock)` |
| Menú repetitivo | `while running:` con bandera o `while True` con `break` |
| Opción 1 | Recorre el diccionario y muestra todos los productos formateados |
| Opción 2 | Validación de código (`in products`), validación de cantidad (`try/except + quantity > 0`), validación de stock (`quantity <= stock`), descuento si quantity > 5 (`* 0.9`), actualización de stock y acumuladores |
| Opción 3 | Muestra total_units y total_money formateados |
| Opción 4 | Sale del bucle |
| Sin `if __name__ == "__main__":` | **Correcto**: en U1 no se usan funciones todavía |

### Ciclo de entrega Git
| Paso | Comando esperado |
|---|---|
| Crear repo en GitHub | Interfaz web, repositorio vacío `tp-lpr` |
| Init local | `git init` en carpeta `tp-u1/` |
| gitignore | `echo "__pycache__/" > .gitignore` y `echo ".vscode/" >> .gitignore` |
| Commit | `git add .` + `git commit -m "tp-u1: version inicial del programa"` |
| Remote | `git remote add origin <url>` |
| Push | `git push -u origin main` |

## 4. Criterios de corrección (lista de verificación)

### Código del TP

| ✔ | Criterio | Puntos sugeridos |
|---|---|---|
| ☐ | El archivo se llama `kiosco.py` y está en carpeta `tp-u1/` | 1 |
| ☐ | Define al menos 4 productos (diccionario con tuplas anidadas o similar) | 1,5 |
| ☐ | Menú principal con `while` (bandera o `break`) | 2 |
| ☐ | Opción 1: muestra todos los productos | 1 |
| ☐ | Opción 2: pedir código y validar existencia | 1,5 |
| ☐ | Opción 2: pedir cantidad y validar stock | 1,5 |
| ☐ | Opción 2: aplicar descuento 10% si cantidad > 5 | 1,5 |
| ☐ | Opción 2: descontar stock y acumular en totales | 1,5 |
| ☐ | Opción 3: resumen de unidades y dinero acumulado | 1 |
| ☐ | Opción 4: salir del programa | 0,5 |
| ☐ | Validación `try/except ValueError` en cada entrada numérica | 2 |
| ☐ | Mensajes en español con f-strings | 1 |
| ☐ | Comentarios explicativos | 0,5 |
| ☐ | **Total** | **16,5** |

### Entrega con Git

| ✔ | Criterio | Puntos |
|---|---|---|
| ☐ | `.gitignore` presente con `__pycache__/` y `.vscode/` | 1 |
| ☐ | Repositorio en GitHub (`tp-lpr`) visible | 1 |
| ☐ | Mensaje de commit con formato `"tp-u1: <avance>"` | 1 |
| ☐ | Push exitoso (ver archivos en GitHub web) | 1 |
| ☐ | **Total** | **4** |

### Notas sobre la corrección
- El TP se evalúa como aprobado/desaprobado con nota conceptual en esta unidad (primer TP). La corrección detallada con puntaje numérico se formaliza a partir de la U2.
- Para la U1, lo importante es que el programa **corra**, **valide entradas** y **use los conceptos de la unidad**.

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
|---|---|---|
| `KeyError` al buscar un código que no existe en el diccionario | Usa `products[code]` sin verificar antes con `in` | Mostrar `if code in products:` antes de acceder. |
| El menú solo se ejecuta una vez | El bucle `while` no está o está mal ubicado | Pedir que rodeen todo (menú + opciones) con `while running:` y solo pongan `running = False` en la opción 4. |
| El stock no se actualiza después de la venta | Modifican una variable local pero no actualizan el diccionario | Recordar que `products[code] = (name, price, new_stock)` reasigna la tupla completa. |
| El descuento se aplica siempre (incluso para 1 unidad) | La condición `if quantity > 5` está mal o no existe | Verificar que usen `if quantity > 5:` y no `if quantity:`. |
| `git push` falla porque no hay remote configurado | No ejecutaron `git remote add origin <url>` | Guiar: `git remote add origin https://github.com/usuario/tp-lpr.git` |
| `git commit` abre el editor Vim y no saben salir | No usaron `-m` | Enseñar `:q!` para salir, y después usar `git commit -m "mensaje"`. |
| La suma del resumen da cero aunque vendieron | No inicializaron los acumuladores o no actualizan `total_money` | Verificar `total_money = total_money + final_price` después de cada venta. |
| `TypeError: can't multiply sequence by non-int` | Usa `price * quantity` donde `price` es `str` | Revisar que `price` salga del diccionario como `float` (debería, pero si lo leyeron de `input()` sin convertir...). |

## 6. Registro de la clase

| Aspecto | Qué registrar |
|---|---|
| Avance del TP | ¿Grupos que terminaron el TP completo? ¿Grupos que solo llegaron a la mitad? |
| Comprensión de Git | ¿Todos pudieron hacer `git init` y `git push`? ¿Hubo problemas con autenticación? |
| Trabajo en equipo | ¿Ambos integrantes participaron? ¿Hubo conflicto de edición? |
| Para la evaluación de proceso | Este es el cierre de U1. Evaluar si cada alumno está en condiciones de rendir el Encuentro 9 (evaluación individual). Si algún grupo no logró completar el TP, programar una recuperación antes del 9. |

### Guía de conducción del encuentro

**Apertura (10 min):** Recorrida rápida de conceptos. Preguntar "¿qué aprendimos en cada encuentro?" y armar la lista en el pizarrón.

**Consolidación (40 min):**
- (15 min) Recorrer el esqueleto de programa con menú (práctica guiada).
- (10 min) Explicar el `while` con bandera (`running = True/False`).
- (15 min) Mostrar cómo se estructura el TP: productos como diccionario, resumen con acumuladores.

**Trabajo del TP (45 min):**
- Dar la consigna completa (vale como actividad evaluable).
- Circular por los grupos: asegurarse de que cada grupo tenga al menos un producto en el diccionario y un menú funcionando antes de los 20 min.
- A los 30 min, verificar que al menos la opción 1 y 2 están implementadas.

**Ciclo de entrega (15 min):**
- Explicar Git en el pizarrón (concepto de versionado, no archivos sueltos).
- Guiar paso a paso: gitignore → init → add → commit → remote → push.
- Ayudar con la autenticación (PAT de GitHub).

**Cierre (10 min):**
- Resumir lo que aprendieron en U1.
- Anunciar la evaluación individual del Encuentro 9.

### TP complementario (B) con dominio "biblioteca de aula"

Si el grupo necesita una versión alternativa del TP (mismo nivel de dificultad, dominio distinto), usar la tabla `tabla-dominio.json` (dominio u1, columna B). Los cambios son:

| Token A (kiosco) | Token B (biblioteca) |
|---|---|
| kiosco | biblioteca |
| venta | préstamo |
| productos | libros |
| precio | tarifa |
| stock | ejemplares |
| descuento | recargo |

Para generar la versión B se usa:
```powershell
powershell -File tools/generar-version-b.ps1 -Tabla input/materias/LPR/tabla-dominio.json -Origen output/LPR/02-unidades/01-u1-fundamentos-de-python-y-control-del-flujo/clase-08-cierre-u1-repaso-y-tp.md -Version B
```
(Este paso es opcional para el docente y solo si algún grupo necesita cambio de dominio.)
