# Intensificación de marzo — Camino mínimo completo

## Metadatos

| Campo | Valor |
|---|---|
| Momento | Intensificación de marzo (fuera de la estructura anual, previa al nuevo ciclo) |
| Duración | 2 encuentros × 120 min (240 min total) |
| Destinatarios | Estudiantes que no alcanzaron los objetivos mínimos en la instancia de diciembre |
| Requisitos | Haber cursado la totalidad del año y la instancia de diciembre; contar con cuenta de GitHub activa y repo grupal clonado; asistencia obligatoria |
| Lugar | Aula de informática con VS Code, terminal y repo grupal GitHub |
| Evaluación | Camino mínimo completo del curso (mismo estándar que diciembre). Criterio: **Apto / No apto aún por objetivo mínimo**. No baja el estándar; cambia el tiempo de preparación del estudiante (diciembre → marzo). |

## Acuerdo pedagógico

| Dimensión | Grupo de intensificación (recuperación pedagógica) — único grupo |
|---|---|
| **Contenidos** | Camino mínimo completo del curso (idéntico al de diciembre): 1) entrada/salida con `print()` / `input()`; 2) variables y tipos (`int`, `float`, `str`, `bool`); 3) condicionales (`if`/`elif`/`else`); 4) bucles (`for`, `while`); 5) listas y diccionarios; 6) funciones con `def`, parámetros y `return`; 7) bloque principal (`if __name__ == "__main__"`); 8) métodos de cadenas (`split`, `strip`, `join`, `replace`), f-strings; 9) validación con `try`/`except`; 10) menú en memoria; 11) entregas por GitHub del repo grupal (carpetas `tp-u1/` a `trabajo-final/`); 12) defensa oral del programa presentado. Dominio: verdulería (producto, kilos, precio, factura, stock). |
| **Actividad / metodología** | El estudiante tuvo más tiempo para prepararse (diciembre a marzo). La instancia presencial se organiza como taller de verificación: el docente revisa el programa que el estudiante trae preparado y asiste en los puntos que todavía presenten dificultad. Encuentro 1: verificación de objetivos 1 a 6 (entrada, condicionales, bucles, listas, diccionarios). Encuentro 2: verificación de objetivos 7 a 12 (funciones, validación, menú, entrega y defensa). |
| **Recursos** | VS Code, terminal, repo grupal clonado, guía paso a paso del camino mínimo (impresa desde diciembre), lista de verificación de objetivos por alumno con el registro de diciembre, plantilla README. |

## Desarrollo del Encuentro 1

### Apertura (10 min)

El docente da la bienvenida a la instancia de marzo. Explica que el estándar es el mismo que en diciembre: "No bajamos la exigencia — ustedes tuvieron más tiempo para preparar cada objetivo. Hoy verificamos lo que traen." Cada estudiante recibe su lista de verificación individual actualizada con los objetivos pendientes desde diciembre. **No se permite celular.**

### Desarrollo (45 min + 45 min)

**Bloque 1 — Verificación de entrada, tipos y condicionales (45 min)**

1. **(15 min)** Verificación 1 — programa base: el estudiante muestra su archivo `verduleria.py`. El docente revisa que declare variables correctamente, use `input()` con conversión de tipos y muestre con f-strings. Marca objetivo como logrado en la lista.
2. **(15 min)** Verificación 2 — condicionales: mostrar la validación de stock (\(stockWeight\)) bajo y descuento por precio alto. Si no está implementado, se guía su creación en vivo.
3. **(15 min)** Verificación 3 — bucle `while` con menú simple. El estudiante ejecuta el programa y muestra las opciones 1 a 3 funcionando. Si falta, se completa con asistencia.

**Bloque 2 — Verificación de listas, diccionarios y bucles (45 min)**

1. **(15 min)** Verificación 4 — lista de productos (\(productList\)): el estudiante muestra cómo agrega productos como diccionarios a la lista. El docente revisa que la estructura de datos sea correcta (diccionarios con claves consistentes).
2. **(15 min)** Verificación 5 — mostrar productos con `for`: el estudiante ejecuta la opción de listar. Se verifica formato y que recorra toda la lista.
3. **(15 min)** Verificación 6 — buscar producto (\(productName\)): mostrar la función de búsqueda con resultados existentes y el mensaje "Producto no encontrado" para un nombre inexistente.

### Cierre (20 min)

El docente registra los objetivos logrados en el encuentro. Si un estudiante completó todos los objetivos 1 a 6, recibe el pase al encuentro 2 para funciones, validación y entrega. Si no, se le asigna trabajo adicional para el segundo encuentro. Cada estudiante hace commit si hubo modificaciones.

---

## Desarrollo del Encuentro 2

### Apertura (10 min)

Repaso de los objetivos de funciones, validación, menú completo y entrega. El docente muestra en vivo la estructura esperada del programa completo y recuerda que el README y la defensa son parte de la evaluación.

### Desarrollo (45 min + 45 min)

**Bloque 1 — Verificación de funciones, bloque principal y validación (45 min)**

1. **(15 min)** Verificación 7 — funciones: el estudiante muestra las funciones `agregar_producto()`, `listar_productos()`, `buscar_producto()` (\(productName\)) y `vender_producto()` (\(sellProduct\)). El docente verifica que tengan parámetros y retorno donde corresponda.
2. **(15 min)** Verificación 8 — bloque principal: el estudiante muestra `if __name__ == "__main__"` y que el programa funcione igual que en el encuentro anterior.
3. **(15 min)** Verificación 9 — `try`/`except`: el estudiante ingresa un dato no numérico en precio (\(productPrice\)) o kilos (\(kilos\)) y muestra que el programa captura el error sin romperse.

**Bloque 2 — Verificación de menú completo, entrega GitHub y defensa (45 min)**

1. **(15 min)** Verificación 10 — menú completo: opciones 1 a 6 funcionando (agregar, listar, buscar, vender, factura, salir). La factura (\(factura\)) muestra los totales de la venta.
2. **(15 min)** Verificación 11 — entrega GitHub: el estudiante muestra el commit final (`"feat: verduleria completa camino mínimo"`) en el repo grupal dentro de la carpeta `trabajo-final/`. Verificar que GitHub muestre el archivo.
3. **(15 min)** Verificación 12 — README: mostrar el `README.md` con título, descripción, tecnologías y cómo ejecutar. Si falta, se completa en el encuentro.

### Cierre con defensa (20 min)

El docente recorre los puestos con la lista de verificación. Cada estudiante explica brevemente:
- Qué hace el programa
- Cómo valida los datos de entrada
- La diferencia entre una lista y un diccionario en su programa
- Una función que le haya costado implementar

Si el estudiante cumple todos los objetivos (1 a 12), recibe **Apto**. Si falta alguno, se registra como **No apto aún por objetivo mínimo** y se detalla cuáles objetivos no alcanzó, junto con la recomendación de recursar la materia si el período lo permite.

---

## Evaluación

| Resultado | Condición |
|---|---|
| **Apto** | El programa compila y ejecuta. Usa `input()`/`print()`, condicionales, bucles, listas, diccionarios, funciones, bloque principal, `try`/`except`, f-strings y menú en memoria. El repo tiene commit y README. El estudiante explica su código durante la defensa. |
| **No apto aún por objetivo mínimo** | Falta al menos uno de los elementos anteriores. Se especifica qué objetivo(s) no se alcanzó y se informa al estudiante junto con la notificación a dirección. |

## Criterios de logro

| Condición | Criterio |
|---|---|
| Apto | El estudiante presenta un programa de consola completo (entrada validada, control de flujo, colecciones, funciones, menú en memoria) sobre el dominio de la verdulería. El código está en GitHub con README. Durante la defensa explica el funcionamiento general, cómo valida los datos y al menos una función en detalle. |
| No apto | El estudiante no completa alguno de los componentes del camino mínimo, no puede sostener una explicación coherente de su propio código, o no entregó el programa en GitHub. Recibe el detalle de objetivos pendientes y la comunicación formal del resultado. |