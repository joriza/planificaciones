# Evaluación del momento 17-18 — Versión A

> Dominio de esta versión: kiosco escolar (U1) + club de barrio (U2). Duración: 90 minutos. Puntaje total: apto/no apto por objetivo mínimo. Resolución individual, con computadora, sin celular. Las condiciones completas están en `evaluacion-intensificaciones-17-18.md`.

## Antes de empezar

- Crea un archivo `kiosco_club.py` en la carpeta `tp-u1/` o `tp-u2/` de tu repo grupal.
- Escribí el programa en un solo archivo `.py`. Definí las funciones primero, el bloque de ejecución al final con `if __name__ == "__main__":`.
- Usá `input()` para leer datos y `print()` con f-strings para mostrar resultados.
- No se permite celular. Trabajo individual.
- Al terminar, hace commit y push al repo grupal.

## Objetivos de la prueba

- Usar `print()` / `input()` con conversión de tipos (`int()`, `float()`).
- Aplicar condicionales `if`/`elif`/`else` para decidir el flujo del programa.
- Usar un bucle `while` para mantener un menú activo hasta que el usuario decida salir.
- Almacenar datos en una lista.
- Definir y usar al menos una función con `def`, parámetros y `return`.

## Consigna — Programa corto de kiosco escolar con registro de clientes

Escribí un programa que gestione las ventas del **kiosco escolar**. El programa debe comenzar con una lista vacía y un menú que se repite hasta que el usuario elija salir.

### Datos de ejemplo del dominio

- **articulos**: ["Caramelos", "Galletitas", "Jugo"]
- **precio**: 50, 120, 80 (en pesos)
- **stock**: 100, 50, 30 (unidades disponibles)
- **cliente**: nombre de quien compra

### Requisitos del programa

1. **Menú principal** con `while True` y opciones:
   - 1: Registrar venta (`registerSale`)
   - 2: Mostrar articulos con stock
   - 3: Mostrar clientes registrados
   - 4: Calcular total de ventas del día (`saleTotal`)
   - 5: Salir

2. **Opción 1 — Registrar venta (`registerSale`)**
   - Pedir nombre del **cliente**.
   - Pedir nombre del **producto** y cantidad.
   - Verificar que haya **stock** suficiente. Si no hay, mostrar "Stock insuficiente".
   - Si hay stock, restar la cantidad del **stock** y calcular el total (`itemPrice` × cantidad).
   - Aplicar un **descuento** del 10% si el total supera los $200.
   - Guardar la venta en una lista (cada venta como un diccionario con los datos).

3. **Opción 2 — Mostrar articulos**
   - Recorrer la lista de **articulos** con un bucle `for` y mostrar nombre, **precio** y **stock** disponible.

4. **Opción 3 — Mostrar clientes registrados**
   - Mostrar todos los **clientes** que compraron hoy, sin repetir.

5. **Opción 4 — Calcular total de ventas (`saleTotal`)**
   - Sumar el total de todas las ventas registradas y mostrarlo con f-string formateado.

### Función requerida

Definí al menos una función `registerSale(articulos, stock, ventas, descuento, cliente, itemPrice, cantidad)` que reciba los datos necesarios, realice la venta si hay stock y devuelva la venta registrada o un mensaje de error.

### Formato de salida esperado

```
=== KIOSCO ESCOLAR ===
1. Registrar venta
2. Mostrar articulos
3. Mostrar clientes
4. Calcular total de ventas
5. Salir
Opción: 1
Nombre del cliente: Ana
Producto: Caramelos
Cantidad: 3
Venta registrada: Ana compró 3 Caramelos por $150.00
```

## Al terminar

Commit con mensaje `"feat: evaluacion 17-18 kiosco"` y push al repo grupal. Avisá al docente para que verifique.