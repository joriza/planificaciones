# Evaluación del momento 19-20 — Versión A

> Dominio de esta versión: biblioteca de aula (U1) + club de barrio (U2). Duración: 90 minutos. Puntaje total: apto/no apto por objetivo mínimo. Resolución individual, con computadora, sin celular. Las condiciones completas están en `evaluacion-intensificaciones-19-20.md`.

## Antes de empezar

- Crea un archivo `biblioteca_club.py` en la carpeta `tp-u1/` o `tp-u2/` de tu repo grupal.
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

## Consigna — Programa corto de biblioteca de aula con registro de préstamos

Escribí un programa que gestione los préstamos de la **biblioteca de aula**. El programa debe comenzar con una lista vacía y un menú que se repite hasta que el usuario elija salir.

### Datos de ejemplo del dominio

- **libros**: ["Matemáticas", "Historia", "Literatura"]
- **tarifa**: 10, 25, 15 (en pesos por día)
- **ejemplares**: 3, 2, 4 (unidades disponibles)
- **lector**: nombre de quien pide el préstamo

### Requisitos del programa

1. **Menú principal** con `while True` y opciones:
   - 1: Registrar préstamo (`registerLoan`)
   - 2: Mostrar libros con ejemplares
   - 3: Mostrar lectores registrados
   - 4: Calcular total de préstamos del día (`loanTotal`)
   - 5: Salir

2. **Opción 1 — Registrar préstamo (`registerLoan`)**
   - Pedir nombre del **lector**.
   - Pedir nombre del **libro** y cantidad de días.
   - Verificar que haya **ejemplares** suficientes. Si no hay, mostrar "Sin ejemplares disponibles".
   - Si hay ejemplares, restar la cantidad de los **ejemplares** y calcular el total (`bookPrice` × días).
   - Aplicar un **recargo** del 10% si el total supera los $50.
   - Guardar el préstamo en una lista (cada préstamo como un diccionario con los datos).

3. **Opción 2 — Mostrar libros**
   - Recorrer la lista de **libros** con un bucle `for` y mostrar nombre, **tarifa** y **ejemplares** disponibles.

4. **Opción 3 — Mostrar lectores registrados**
   - Mostrar todos los **lectores** que pidieron préstamo hoy, sin repetir.

5. **Opción 4 — Calcular total de préstamos (`loanTotal`)**
   - Sumar el total de todos los préstamos registrados y mostrarlo con f-string formateado.

### Función requerida

Definí al menos una función `registerLoan(libros, ejemplares, prestamos, recargo, lector, bookPrice, dias)` que reciba los datos necesarios, realice el préstamo si hay ejemplares y devuelva el préstamo registrado o un mensaje de error.

### Formato de salida esperado

```
=== BIBLIOTECA DE AULA ===
1. Registrar préstamo
2. Mostrar libros
3. Mostrar lectores
4. Calcular total de préstamos
5. Salir
Opción: 1
Nombre del lector: Ana
Libro: Matemáticas
Días: 3
Préstamo registrado: Ana pidió 3 días de Matemáticas por $30.00
```

## Al terminar

Commit con mensaje `"feat: evaluacion 19-20 biblioteca"` y push al repo grupal. Avisá al docente para que verifique.