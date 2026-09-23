# Evaluación de la intensificación de marzo — Versión A

> Dominio de esta versión: verdulería (productos, kilos, precio, factura, stock). Duración: 240 minutos (2 encuentros). Resolución individual, con computadora, sin celular. Las condiciones completas están en `evaluacion-intensificaciones-marzo.md`.

## Antes de empezar

- Crea un archivo `verduleria.py` en la carpeta `trabajo-final/` de tu repo grupal.
- Escribí el programa en un solo archivo `.py`. Definí las funciones primero, el bloque de ejecución al final con `if __name__ == "__main__":`.
- Usá `input()` para leer datos y `print()` con f-strings para mostrar resultados.
- No se permite celular. Trabajo individual.
- Al terminar, hace commit y push al repo grupal.

## Objetivos de la prueba

El programa debe cumplir con los siguientes objetivos del camino mínimo completo (mismo estándar que diciembre):

1. Entrada/salida con `print()` / `input()` y conversión de tipos correcta (`int()`, `float()`).
2. Variables y tipos básicos (`int`, `float`, `str`, `bool`).
3. Condicionales `if`/`elif`/`else` para decidir el flujo del programa.
4. Bucles `for` y `while` para repetición.
5. Listas para almacenar colecciones de datos.
6. Diccionarios para modelar entidades con claves legibles.
7. Funciones con `def`, parámetros y `return`.
8. Bloque principal `if __name__ == "__main__"`.
9. Métodos de cadenas (`split`, `strip`, `join`, `replace`) y f-strings.
10. Validación con `try`/`except` para `ValueError`.
11. Menú en memoria con `while True` y `break`.
12. Entrega en GitHub con README y defensa oral.

## Consigna — Programa integrador de verdulería

Escribí un programa completo de consola para gestionar una **verdulería**. El programa debe permitir: agregar productos, listar productos, buscar productos, vender productos y generar una factura.

### Datos de ejemplo del dominio

- **producto**: nombre del producto (str)
- **productos**: lista de productos disponibles (list)
- **kilos**: cantidad en kilos disponible (float)
- **factura**: resumen de la venta actual (dict)
- **productList**: lista de productos como diccionarios (list)
- **productName**: nombre del producto a buscar (str)
- **productPrice**: precio unitario del producto (float)
- **stockWeight**: cantidad en kilos disponible (float)
- **sellProduct**: función que registra una venta

### Requisitos del programa

1. **Programa base** — variables y entrada:
   - Declarar variables con los tipos correctos para representar un producto de la verdulería.
   - Pedir datos con `input()` y convertir (`int()`, `float()`).
   - Mostrar con f-string.

2. **Condicionales**:
   - Si el producto tiene menos de 1 kilo disponible, mostrar "Stock bajo".
   - Si el precio supera los $500, aplicar un descuento del 10%.
   - Usar `if`/`elif`/`else`.

3. **Bucle `while` con menú**:
   - Menú con opciones (1: ver producto, 2: vender, 3: salir).
   - Usar `while True` y `break`.

4. **Listas y diccionarios**:
   - Lista de productos como diccionarios dentro de una lista (`productList`).
   - Agregar productos con `append()`.
   - Mostrar productos con `for`.
   - Buscar producto por nombre (`productName`).

5. **Funciones**:
   - Definir al menos `agregar_producto()`, `listar_productos()`, `buscar_producto()`, `vender_producto()`.
   - Cada función con `def`, parámetros y `return`.

6. **Bloque principal**:
   - `if __name__ == "__main__":` con el menú principal que llama a las funciones.

7. **Validación**:
   - Envolver la conversión de precio y kilos en `try`/`except ValueError`.
   - Mostrar "Dato inválido, intente de nuevo" y pedir el dato otra vez.

8. **Menú completo**:
   - Opciones 1 a 5: agregar producto, listar productos, buscar producto, vender producto, salir.

## Al terminar

Commit con mensaje `"feat: verduleria completa camino minimo"` y push al repo grupal. Avisá al docente para que verifique.