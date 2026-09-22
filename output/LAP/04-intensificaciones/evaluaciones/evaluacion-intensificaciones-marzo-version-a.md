# Evaluación de marzo — Versión A

> Dominio de esta versión: verdulería (productos, kilos, precio, factura, stock). Duración: 90 minutos. Puntaje total: apto/no apto por objetivo mínimo. Resolución individual, con computadora, sin celular. Las condiciones completas están en `evaluacion-intensificaciones-marzo.md`.

## Antes de empezar

- Esta evaluación verifica el **camino mínimo completo del curso** con el **mismo estándar que diciembre**. La única diferencia es el tiempo de preparación: tuviste de diciembre a marzo para practicar.
- Creá un archivo `verduleria.py` en la carpeta `trabajo-final/` de tu repo grupal (o traelo preparado de tu casa).
- Escribí el programa en un solo archivo `.py`. Funciones arriba, `if __name__ == "__main__":` al final.
- No se permite celular. Trabajo individual.
- Al terminar, commit y push al repo grupal, y preparate para la defensa oral.

## Objetivos de la prueba

- Usar `print()` / `input()` con conversión de tipos (`int()`, `float()`).
- Aplicar condicionales `if`/`elif`/`else`.
- Usar bucles `while` (menú) y `for` (recorrer colecciones).
- Almacenar datos en listas de diccionarios.
- Definir funciones con `def`, parámetros y `return`.
- Validar entrada con `try`/`except`.
- Usar f-strings y métodos de cadenas básicos.
- Entregar en GitHub con commit y README.

## Consigna — Programa integrador de verdulería (mismo estándar que diciembre)

Escribí un programa que gestione los **productos** de una **verdulería**. Cada **producto** es un diccionario con:

- `"nombre"`: string
- `"precio"` (`productPrice`): float (precio por kilo)
- `"kilos"` (`stockWeight`): float (kilos disponibles en stock)

### Menú completo (con `while`)

```
=== VERDULERÍA ===
1. Agregar producto
2. Listar productos
3. Buscar producto por nombre
4. Vender producto
5. Factura
6. Salir
```

### Funciones requeridas

1. `agregar_producto(productList)` — pide nombre, precio por kilo y kilos disponibles. Valida que precio y kilos sean números con `try`/`except`. Agrega el producto como diccionario a la lista.
2. `listar_productos(productList)` — recorre la lista con `for` y muestra cada producto.
3. `buscar_producto(productList, productName)` — busca por nombre exacto, devuelve el diccionario o `None` si no existe.
4. `vender_producto(productList, ventas)` (`sellProduct`) — pide nombre del producto y kilos a vender. Verifica que haya stock suficiente. Si el producto tiene menos de 1 kilo, muestra "Stock bajo". Si se vende, descuenta los kilos y agrega la venta a una lista de ventas.
5. `mostrar_factura(ventas)` — recorre la lista de ventas y muestra cada una con el total. Usá f-strings con formato de dos decimales.

### Función de validación con `try`/`except`

```python
def read_float(mensaje):
    while True:
        try:
            return float(input(mensaje))
        except ValueError:
            print("Dato inválido. Ingrese un número.")
```

### Formato de salida esperado

```
=== VERDULERÍA ===
1. Agregar producto
2. Listar productos
3. Buscar producto por nombre
4. Vender producto
5. Factura
6. Salir
Opción: 1
Nombre del producto: Tomate
Precio por kilo: 250.50
Kilos disponibles: 15
Producto agregado correctamente.

=== VERDULERÍA ===
1. Agregar producto
2. Listar productos
3. Buscar producto por nombre
4. Vender producto
5. Factura
6. Salir
Opción: 4
Nombre del producto: Tomate
Kilos a vender: 2
Venta realizada: 2 kilos de Tomate por $501.00
```

### Nota sobre el estándar

Este programa es idéntico en requisitos al de la instancia de diciembre. **No baja el estándar**: la única diferencia es que tuviste tiempo adicional para prepararte. Si aprobabas en diciembre con este mismo programa, aprobás ahora; si no, tenés esta nueva oportunidad con el mismo nivel de exigencia.

## Defensa oral (se evalúa durante el cierre)

Preparate para explicar brevemente (2-3 minutos):
- ¿Qué hace tu programa?
- ¿Cómo validás los datos de entrada?
- ¿Cuál es la diferencia entre una lista y un diccionario en tu programa?
- Elegí una función que te haya costado — ¿cómo la resolviste?

## Al terminar

1. Commit final con mensaje `"feat: verduleria completa camino mínimo marzo"`.
2. Push al repo grupal en la carpeta `trabajo-final/`.
3. Verificá que el README.md tenga al menos título, descripción y cómo ejecutar.
4. Avisá al docente. Te va a hacer la verificación individual y la defensa oral.