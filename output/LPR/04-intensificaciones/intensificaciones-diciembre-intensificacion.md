# Intensificación de diciembre — Camino mínimo completo

## Metadatos

| Campo | Valor |
|---|---|
| Momento | Intensificación de diciembre (fuera de la estructura anual) |
| Duración | 2 encuentros × 120 min (240 min total) |
| Destinatarios | Estudiantes que no alcanzaron los objetivos mínimos del curso durante el ciclo lectivo |
| Requisitos | Haber cursado la totalidad del año; tener cuenta de GitHub activa y repo grupal clonado; asistencia obligatoria |
| Lugar | Aula de informática con VS Code, terminal y repo grupal GitHub |
| Evaluación | Camino mínimo completo del curso. Criterio: **Apto / No apto aún por objetivo mínimo**. No hay puntaje numérico. |

## Acuerdo pedagógico

| Dimensión | Grupo de intensificación (recuperación pedagógica) — único grupo |
|---|---|
| **Contenidos** | Camino mínimo completo del curso: 1) entrada/salida con `print()` / `input()`; 2) variables y tipos (`int`, `float`, `str`, `bool`); 3) condicionales (`if`/`elif`/`else`); 4) bucles (`for`, `while`); 5) listas y diccionarios; 6) funciones con `def`, parámetros y `return`; 7) bloque principal (`if __name__ == "__main__"`); 8) métodos de cadenas (`split`, `strip`, `join`, `replace`), f-strings; 9) validación con `try`/`except`; 10) menú en memoria; 11) entregas por GitHub del repo grupal (carpetas `tp-u1/` a `trabajo-final/`); 12) defensa oral del programa presentado. Dominio: verdulería (productos, kilos, precio, factura, stock). |
| **Actividad / metodología** | Recorrido acelerado por los contenidos mínimos del año con énfasis en los objetivos no alcanzados. Cada estudiante reconstruye —o completa— un programa integrador de consola sobre el dominio de la verdulería, dividido en dos encuentros. Encuentro 1: entrada, condicionales, bucles, listas, diccionarios. Encuentro 2: funciones, validación, menú, entregas GitHub y defensa. |
| **Recursos** | VS Code, terminal, repo grupal clonado, guía paso a paso del camino mínimo (impresa), lista de verificación de objetivos por alumno, plantilla README. |

## Desarrollo del Encuentro 1

### Apertura (10 min)

El docente explica la modalidad de la instancia de diciembre: "No es un curso nuevo — es la oportunidad de demostrar que pueden hacer el camino mínimo. Cada objetivo que logren hoy es un objetivo aprobado." Se entrega la lista de verificación individual con los objetivos no alcanzados de cada alumno. Sale del ciclo reposo para diciembre. **No se permite celular.**

### Desarrollo (45 min + 45 min)

**Bloque 1 — Entrada, tipos y condicionales (45 min)**

1. **(15 min)** Ejercicio 1 — programa base: crear un archivo `verduleria.py`. Declarar variables con los tipos correctos para representar un producto de la verdulería: nombre (`str`), precio (`float`), kilos disponibles (`float`). Pedir datos con `input()` y convertir. Mostrar con f-string.
2. **(15 min)** Ejercicio 2 — condicionales: agregar validación. Si el producto tiene menos de 1 kilo disponible, mostrar "Stock bajo". Si el precio supera los $500, aplicar un descuento del 10%. Usar `if`/`elif`/`else`.
3. **(15 min)** Ejercicio 3 — bucle `while`: menú simple con opciones (1: ver producto, 2: vender, 3: salir). Usar `while True` y `break`. Cada opción imprime el estado actual.

**Bloque 2 — Listas, diccionarios y bucles (45 min)**

1. **(15 min)** Ejercicio 4 — lista de productos: almacenar productos como diccionarios dentro de una lista. Pedir datos por teclado y agregar con `append()`.
2. **(15 min)** Ejercicio 5 — mostrar productos con `for`: recorrer la lista de productos y mostrar cada uno con f-string formateado.
3. **(15 min)** Ejercicio 6 — buscar producto por nombre: recorrer la lista con `for` y comparar. Mostrar el producto encontrado o "Producto no encontrado".

### Cierre (20 min)

Verificación individual: el docente recorre los puestos y marca en la lista de verificación qué objetivos están logrados (1 a 6) y cuáles quedan pendientes para el encuentro siguiente. Cada estudiante hace commit del avance con mensaje `"feat: verduleria base y listado"`.

---

## Desarrollo del Encuentro 2

### Apertura (10 min)

Repaso de lo logrado en el encuentro anterior. El docente presenta los objetivos del día: funciones, validación, menú completo, entrega en GitHub y defensa.

### Desarrollo (45 min + 45 min)

**Bloque 1 — Funciones y validación (45 min)**

1. **(15 min)** Ejercicio 7 — funciones: refactorizar el programa anterior. Extraer cada operación a una función: `agregar_producto()`, `listar_productos()`, `buscar_producto()`, `vender_producto()`.
2. **(15 min)** Ejercicio 8 — bloque principal: agregar `if __name__ == "__main__"` y dentro el menú principal que llama a las funciones. Verificar que el programa funcione igual que antes.
3. **(15 min)** Ejercicio 9 — validación con `try`/`except`: envolver la conversión de precio y kilos en un bloque `try`/`except` que capture `ValueError`. Mostrar "Dato inválido, intente de nuevo" y pedir el dato otra vez.

**Bloque 2 — Menú, entrega y defensa (45 min)**

1. **(15 min)** Ejercicio 10 — menú completo en memoria: opciones (1: agregar producto, 2: listar productos, 3: buscar producto, 4: vender producto, 5: factura, 6: salir). Factura muestra el resumen de la venta actual.
2. **(15 min)** Ejercicio 11 — entregas GitHub: commit final con mensaje `"feat: verduleria completa camino mínimo"`. Crear carpeta `trabajo-final/` en el repo grupal si no existe. Pushear. Verificar que GitHub muestra el archivo.
3. **(15 min)** Ejercicio 12 — README básico: crear o actualizar `README.md` en la raíz del repo con título, descripción ("Sistema de gestión de verdulería en Python"), tecnologías y cómo ejecutar.

### Cierre con defensa (20 min)

El docente recorre los puestos con la lista de verificación. Cada estudiante explica brevemente: qué hace el programa, cómo valida los datos de entrada, y una función que le haya costado implementar.

Si el estudiante cumple todos los objetivos (1 a 12), recibe **Apto**. Si falta alguno, se registra como **No apto aún por objetivo mínimo** y se detalla cuál(es) objetivo(s) no alcanzó, junto con la sugerencia de la instancia de marzo como siguiente oportunidad con el mismo estándar.

---

## Evaluación

| Resultado | Condición |
|---|---|
| **Apto** | El programa compila y ejecuta. Usa `input()`/`print()`, condicionales, bucles, listas, diccionarios, funciones, bloque principal, `try`/`except`, f-strings y menú en memoria. El repo tiene commit y README. El estudiante explica su código durante la defensa. |
| **No apto aún por objetivo mínimo** | Falta al menos uno de los elementos anteriores. Se especifica qué objetivo(s) no se alcanzó y se sugiere la instancia de marzo como siguiente oportunidad con el mismo estándar. |

## Criterios de logro

| Condición | Criterio |
|---|---|
| Apto | El estudiante construye un programa de consola completo (entrada validada, control de flujo, colecciones, funciones, menú en memoria) sobre el dominio de la verdulería. Entrega el código en GitHub con README. Durante la defensa explica el funcionamiento general y la lógica de al menos una función. |
| No apto | El estudiante no completa alguno de los componentes anteriores o no puede explicar el funcionamiento de su propio código. Recibe la lista de objetivos pendientes y la fecha de la instancia de marzo. |
