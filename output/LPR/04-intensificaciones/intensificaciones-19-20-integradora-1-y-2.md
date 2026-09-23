# Intensificación integradora — Encuentros 19 y 20

## Metadatos

| Campo | Valor |
|---|---|
| Momento | Proyecto puente integrador — Encuentros 19 y 20 |
| Encuentros | 19 y 20 |
| Duración | 2 encuentros × 120 min (240 min total) |
| Destinatarios | Estudiantes que necesitan integrar los núcleos de las Unidades 1 y 2 antes de avanzar a la Unidad 3 |
| Requisitos | Haber cursado las Unidades 1 y 2; tener cuenta de GitHub activa y repo grupal clonado |
| Lugar | Aula de informática con VS Code, terminal y repo grupal GitHub |

## Acuerdo pedagógico

| Dimensión | Grupo de intensificación (recuperación pedagógica) | Grupo de fortalecimiento (profundización) |
|---|---|---|
| **Contenidos** | Integración de los núcleos de U1 y U2 en un programa completo de consola: entrada con `input()` y conversión de tipos, condicionales `if`/`elif`/`else`, bucles `for` y `while`, listas y diccionarios, funciones con `def`, parámetros y `return`, bloque principal `if __name__ == "__main__"`. Dominio: biblioteca de aula (préstamo de libros, tarifa, ejemplares, lector). | Extensión del programa integrador con funcionalidades adicionales: búsqueda avanzada, ordenamiento de resultados, manejo de múltiples criterios, uso de diccionarios anidados para datos complejos. |
| **Actividad / metodología** | Construcción guiada de un programa integrador de consola sobre el dominio de la biblioteca de aula. Encuentro 1: entrada, tipos, condicionales y bucles. Encuentro 2: funciones, lista de préstamos, bloque principal y entrega en GitHub. | Desafíos autónomos de extensión sobre el mismo programa base: agregar funciones de búsqueda, filtrado y ordenamiento. |
| **Recursos** | VS Code, terminal, repo grupal clonado, guía impresa de núcleos U1 y U2, lista de verificación de objetivos por alumno. | VS Code, terminal, repo grupal, consignas de desafío impresas. |

## Desarrollo del Encuentro 1

### Apertura (10 min)

El docente explica la modalidad del proyecto puente: "Hoy integran todo lo de las Unidades 1 y 2 en un solo programa. El dominio es la biblioteca de aula: préstamos de libros, tarifas, ejemplares disponibles y lectores." Se entrega la lista de verificación individual con los objetivos a integrar. **No se permite celular.**

### Desarrollo (45 min + 45 min)

**Bloque 1 — Entrada, tipos y condicionales (45 min)**

1. **(15 min)** Ejercicio 1 — programa base: crear un archivo `biblioteca.py`. Declarar variables con los tipos correctos para representar un libro: título (`str`), tarifa (`float`), ejemplares disponibles (`int`). Pedir datos con `input()` y convertir. Mostrar con f-string.
2. **(15 min)** Ejercicio 2 — condicionales: agregar validación. Si los ejemplares disponibles son 0, mostrar "Sin ejemplares disponibles". Si la tarifa supera los $50, aplicar un recargo del 10% para préstamos fuera de horario. Usar `if`/`elif`/`else`.
3. **(15 min)** Ejercicio 3 — bucle `while`: menú simple con opciones (1: ver libro, 2: registrar préstamo, 3: salir). Usar `while True` y `break`. Cada opción imprime el estado actual.

**Bloque 2 — Listas, diccionarios y funciones (45 min)**

1. **(15 min)** Ejercicio 4 — lista de préstamos: almacenar préstamos como diccionarios dentro de una lista. Pedir datos por teclado y agregar con `append()`.
2. **(15 min)** Ejercicio 5 — mostrar préstamos con `for`: recorrer la lista de préstamos y mostrar cada uno con f-string formateado.
3. **(15 min)** Ejercicio 6 — buscar préstamo por título de libro: recorrer la lista con `for` y comparar. Mostrar el préstamo encontrado o "Préstamo no encontrado".

### Cierre (20 min)

Verificación individual: el docente recorre los puestos y marca en la lista de verificación qué objetivos están logrados (1 a 6) y cuáles quedan pendientes para el encuentro siguiente. Cada estudiante hace commit del avance con mensaje `"feat: biblioteca base y listado"`.

---

## Desarrollo del Encuentro 2

### Apertura (10 min)

Repaso de lo logrado en el encuentro anterior. El docente presenta los objetivos del día: funciones, validación, menú completo y entrega en GitHub.

### Desarrollo (45 min + 45 min)

**Bloque 1 — Funciones y validación (45 min)**

1. **(15 min)** Ejercicio 7 — funciones: refactorizar el programa anterior. Extraer cada operación a una función: `agregar_libro()`, `listar_libros()`, `buscar_libro()`, `registrar_prestamo()`.
2. **(15 min)** Ejercicio 8 — bloque principal: agregar `if __name__ == "__main__"` y dentro el menú principal que llama a las funciones. Verificar que el programa funcione igual que antes.
3. **(15 min)** Ejercicio 9 — validación con `try`/`except`: envolver la conversión de tarifa y ejemplares en un bloque `try`/`except` que capture `ValueError`. Mostrar "Dato inválido, intente de nuevo" y pedir el dato otra vez.

**Bloque 2 — Menú completo y entrega (45 min)**

1. **(15 min)** Ejercicio 10 — menú completo en memoria: opciones (1: agregar libro, 2: listar libros, 3: buscar libro, 4: registrar préstamo, 5: salir). Cada opción ejecuta la función correspondiente.
2. **(15 min)** Ejercicio 11 — entregas GitHub: commit final con mensaje `"feat: biblioteca completa proyecto puente"`. Verificar que GitHub muestra el archivo.
3. **(15 min)** Ejercicio 12 — README básico: crear o actualizar `README.md` en la raíz del repo con título, descripción ("Sistema de gestión de biblioteca de aula en Python"), tecnologías y cómo ejecutar.

### Cierre con verificación (20 min)

El docente recorre los puestos con la lista de verificación. Cada estudiante explica brevemente: qué hace el programa, cómo valida los datos de entrada, y una función que le haya costado implementar.

---

## Evaluación

| Resultado | Condición |
|---|---|
| **Apto** | El programa compila y ejecuta. Usa `input()`/`print()` con tipos correctos, condicionales (`if`/`elif`/`else`), bucle `while` con menú, una lista para almacenar datos y al menos una función con `def` y `return`. Tiene bloque principal `if __name__ == "__main__"`. Hay commit en el repo. |
| **No apto aún por objetivo mínimo** | El programa no compila, no ejecuta, o falta alguno de los elementos anteriores. Se registran los objetivos pendientes y se deriva a la intensificación de las Unidades 3 y 4 (encuentros 34-35). |

## Criterios de logro

| Condición | Criterio |
|---|---|
| Apto | El estudiante construye un programa de consola completo (entrada validada, control de flujo, colecciones, funciones, menú en memoria) sobre el dominio de la biblioteca de aula. El código está en GitHub con README. Durante la defensa explica el funcionamiento general y la lógica de al menos una función. |
| No apto | El estudiante no completa alguno de los componentes anteriores o no puede explicar el funcionamiento de su propio código. Recibe la lista de objetivos pendientes y la fecha de la intensificación de las Unidades 3 y 4. |
