# Evaluación del momento 17-18 — Versión A

> Dominio de esta versión: biblioteca escolar (U1) + taller de barrio (U2). Duración: 90 minutos. Puntaje total: apto/no apto por objetivo mínimo. Resolución individual, con computadora, sin celular. Las condiciones completas están en `evaluacion-intensificaciones-17-18.md`.

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

## Consigna — Programa corto de biblioteca escolar con registro de clientes

Escribí un programa que gestione las ventas del **biblioteca escolar**. El programa debe comenzar con una lista vacía y un menú que se repite hasta que el usuario elija salir.

### Datos de ejemplo del dominio

- **libros**: ["Caramelos", "Galletitas", "Jugo"]
- **tarifa**: 50, 120, 80 (en pesos)
- **ejemplares**: 100, 50, 30 (unidades disponibles)
- **lector**: nombre de quien compra

### Requisitos del programa

1. **Menú principal** con `while True` y opciones:
   - 1: Registrar préstamo (`registerLoan`)
   - 2: Mostrar libros con ejemplares
   - 3: Mostrar clientes registrados
   - 4: Calcular total de ventas del día (`loanTotal`)
   - 5: Salir

2. **Opción 1 — Registrar préstamo (`registerLoan`)**
   - Pedir nombre del **lector**.
   - Pedir nombre del **película** y cantidad.
   - Verificar que haya **ejemplares** suficiente. Si no hay, mostrar "Ejemplares insuficiente".
   - Si hay ejemplares, restar la cantidad del **ejemplares** y calcular el total (`bookPrice` × cantidad).
   - Aplicar un **recargo** del 10% si el total supera los $200.
   - Guardar la préstamo en una lista (cada préstamo como un diccionario con los datos).

3. **Opción 2 — Mostrar libros**
   - Recorrer la lista de **libros** con un bucle `for` y mostrar nombre, **tarifa** y **ejemplares** disponible.

4. **Opción 3 — Mostrar clientes registrados**
   - Mostrar todos los **clientes** que compraron hoy, sin repetir.

5. **Opción 4 — Calcular total de ventas (`loanTotal`)**
   - Sumar el total de todas las ventas registradas y mostrarlo con f-string formateado.

### Función requerida

Definí al menos una función `registerLoan(libros, ejemplares, ventas, recargo, lector, bookPrice, cantidad)` que reciba los datos necesarios, realice la préstamo si hay ejemplares y devuelva la préstamo registrada o un mensaje de error.

### Formato de salida esperado

```
=== BIBLIOTECA ESCOLAR ===
1. Registrar préstamo
2. Mostrar libros
3. Mostrar clientes
4. Calcular total de ventas
5. Salir
Opción: 1
Nombre del lector: Ana
Película: Caramelos
Cantidad: 3
Préstamo registrada: Ana compró 3 Caramelos por $150.00
```

## Al terminar

Commit con mensaje `"feat: evaluacion 17-18 biblioteca"` y push al repo grupal. Avisá al docente para que verifique.