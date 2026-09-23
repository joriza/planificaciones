# Intensificación de las Unidades 1 y 2 — Encuentros 17 y 18

## Metadatos

| Campo | Valor |
|---|---|
| Momento | Intensificación de las Unidades 1 y 2 |
| Encuentros | 17 y 18 |
| Duración | 2 encuentros × 120 min (240 min total) |
| Destinatarios | Estudiantes que no alcanzaron los objetivos mínimos de las Unidades 1 y 2 |
| Requisitos | Haber cursado las Unidades 1 y 2; tener cuenta de GitHub activa y repo grupal clonado |
| Lugar | Aula de informática con VS Code, terminal y repo grupal GitHub |

## Acuerdo pedagógico

| Dimensión | Grupo de intensificación (recuperación pedagógica) | Grupo de fortalecimiento (profundización) |
|---|---|---|
| **Contenidos** | Camino mínimo de U1 y U2: 1) `print()` / `input()` con conversión de tipos; 2) variables y tipos (`int`, `float`, `str`, `bool`); 3) condicionales (`if`/`elif`/`else`); 4) bucles (`for`, `while`); 5) listas y diccionarios; 6) funciones con `def`, parámetros y `return`; 7) bloque principal (`if __name__ == "__main__"`). Dominio: kiosco escolar (U1) y club de barrio (U2). | Extensión del programa base con funcionalidades adicionales: ordenamiento de listas, búsqueda por múltiples criterios, uso de diccionarios anidados, funciones con argumentos por nombre y valores default. |
| **Actividad / metodología** | Recorrido acelerado por los contenidos mínimos de U1 y U2. Cada estudiante reconstruye un programa corto de consola sobre el dominio del kiosco escolar y el club de barrio en dos encuentros. Encuentro 1: entrada, tipos y condicionales. Encuentro 2: bucles, listas, diccionarios, funciones y bloque principal. | Desafíos autónomos de extensión sobre el mismo programa base: agregar ordenamiento, búsqueda avanzada, diccionarios anidados. |
| **Recursos** | VS Code, terminal, repo grupal clonado, guía impresa de núcleos U1 y U2, lista de verificación de objetivos por alumno. | VS Code, terminal, repo grupal, consignas de desafío impresas. |

## Desarrollo del Encuentro 1

### Apertura (10 min)

El docente explica la modalidad de la instancia de intensificación: "No es un curso nuevo — es la oportunidad de demostrar que pueden aplicar lo aprendido en las Unidades 1 y 2. Cada objetivo que logren hoy es un objetivo aprobado." Se entrega la lista de verificación individual con los objetivos no alcanzados de cada alumno. **No se permite celular.**

### Desarrollo (45 min + 45 min)

**Bloque 1 — Entrada, tipos y condicionales (45 min)**

1. **(15 min)** Ejercicio 1 — programa base: crear un archivo `kiosco_club.py`. Declarar variables con los tipos correctos para representar un producto del kiosco: nombre (`str`), precio (`float`), stock (`int`). Pedir datos con `input()` y convertir. Mostrar con f-string.
2. **(15 min)** Ejercicio 2 — condicionales: agregar validación. Si el producto tiene stock bajo (menos de 5 unidades), mostrar "Stock bajo". Si el precio supera los $100, aplicar un descuento del 10%. Usar `if`/`elif`/`else`.
3. **(15 min)** Ejercicio 3 — bucle `while`: menú simple con opciones (1: ver producto, 2: registrar venta, 3: salir). Usar `while True` y `break`. Cada opción imprime el estado actual.

**Bloque 2 — Listas, diccionarios y funciones (45 min)**

1. **(15 min)** Ejercicio 4 — lista de productos: almacenar productos como diccionarios dentro de una lista. Pedir datos por teclado y agregar con `append()`.
2. **(15 min)** Ejercicio 5 — mostrar productos con `for`: recorrer la lista de productos y mostrar cada uno con f-string formateado.
3. **(15 min)** Ejercicio 6 — buscar producto por nombre: recorrer la lista con `for` y comparar. Mostrar el producto encontrado o "Producto no encontrado".

### Cierre (20 min)

Verificación individual: el docente recorre los puestos y marca en la lista de verificación qué objetivos están logrados (1 a 6) y cuáles quedan pendientes para el encuentro siguiente. Cada estudiante hace commit del avance con mensaje `"feat: kiosco_club base y listado"`.

---

## Desarrollo del Encuentro 2

### Apertura (10 min)

Repaso de lo logrado en el encuentro anterior. El docente presenta los objetivos del día: funciones, validación, menú completo y entrega en GitHub.

### Desarrollo (45 min + 45 min)

**Bloque 1 — Funciones y validación (45 min)**

1. **(15 min)** Ejercicio 7 — funciones: refactorizar el programa anterior. Extraer cada operación a una función: `agregar_producto()`, `listar_productos()`, `buscar_producto()`, `registrar_venta()`.
2. **(15 min)** Ejercicio 8 — bloque principal: agregar `if __name__ == "__main__"` y dentro el menú principal que llama a las funciones. Verificar que el programa funcione igual que antes.
3. **(15 min)** Ejercicio 9 — validación con `try`/`except`: envolver la conversión de precio y stock en un bloque `try`/`except` que capture `ValueError`. Mostrar "Dato inválido, intente de nuevo" y pedir el dato otra vez.

**Bloque 2 — Menú completo y entrega (45 min)**

1. **(15 min)** Ejercicio 10 — menú completo en memoria: opciones (1: agregar producto, 2: listar productos, 3: buscar producto, 4: registrar venta, 5: salir). Cada opción ejecuta la función correspondiente.
2. **(15 min)** Ejercicio 11 — entregas GitHub: commit final con mensaje `"feat: kiosco_club completo recuperación U1-U2"`. Verificar que GitHub muestra el archivo.
3. **(15 min)** Ejercicio 12 — README básico: crear o actualizar `README.md` en la raíz del repo con título, descripción, tecnologías y cómo ejecutar.

### Cierre con verificación (20 min)

El docente recorre los puestos con la lista de verificación. Cada estudiante explica brevemente: qué hace el programa, cómo valida los datos de entrada, y una función que le haya costado implementar.

---

## Evaluación

| Resultado | Condición |
|---|---|
| **Apto** | El programa compila y ejecuta. Usa `input()`/`print()` con tipos correctos, condicionales (`if`/`elif`/`else`), bucle `while` con menú, una lista para almacenar datos y al menos una función con `def` y `return`. Tiene bloque principal `if __name__ == "__main__"`. Hay commit en el repo. |
| **No apto aún por objetivo mínimo** | El programa no compila, no ejecuta, o falta alguno de los elementos anteriores (sin condicionales, sin bucle, sin funciones, sin lista, sin bloque principal, sin commit). Se registran los objetivos pendientes y se deriva al proyecto puente (encuentros 19-20). |

## Criterios de logro

| Condición | Criterio |
|---|---|
| Apto | El estudiante construye un programa de consola completo (entrada validada, control de flujo, colecciones, funciones, menú en memoria) sobre el dominio del kiosco escolar y el club de barrio. El código está en GitHub con README. Durante la defensa explica el funcionamiento general y la lógica de al menos una función. |
| No apto | El estudiante no completa alguno de los componentes anteriores o no puede explicar el funcionamiento de su propio código. Recibe la lista de objetivos pendientes y la fecha del proyecto puente (encuentros 19-20). |
