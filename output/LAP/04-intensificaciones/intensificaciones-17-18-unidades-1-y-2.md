# Intensificación y fortalecimiento de las Unidades 1 y 2 — Encuentros 17 y 18

## Metadatos

| Campo | Valor |
|---|---|
| Momento | Intensificación y fortalecimiento de las Unidades 1 y 2 — primera instancia |
| Encuentros | 17 y 18 |
| Duración | 2 encuentros × 120 min (240 min total) |
| Destinatarios | Totalidad del curso, con pistas diferenciadas por condición |
| Requisitos | Haber cursado las unidades 1 y 2; tener resueltos o intentados los TP-U1 y TP-U2; repo grupal GitHub clonado en la PC |
| Lugar | Aula de informática con VS Code, terminal y repo grupal GitHub |

## Acuerdo pedagógico

| Dimensión | Grupo de intensificación (recuperación pedagógica) | Grupo de fortalecimiento (profundización) |
|---|---|---|
| **Contenidos** | U1: tipos (`int`, `float`, `str`, `bool`), entrada/salida (`print`, `input`), condicionales (`if`/`elif`/`else`), bucles (`for`, `while`). U2: listas (mutabilidad, slicing), tuplas y set, diccionarios, funciones (`def`, parámetros, retorno), bloque principal (`if __name__`). | U1: condicionales anidados con operadores lógicos, bucles con `break`/`continue`/`else`, comprensión de listas. U2: funciones con argumentos por nombre y valores default, funciones con retorno múltiple (tupla), manejo de excepciones (`try`/`except` básico), enumeración con `enumerate`. |
| **Actividad / metodología** | Ejercicios guiados paso a paso: corregir errores comunes, refactorizar programas existentes del TP, cerrar el ciclo Git (commit + push) del TP correspondiente. | Desafíos de profundización autónomos: extender programas con nuevas funcionalidades, refactorizar con comprensión de listas y funciones de orden superior. |
| **Recursos** | VS Code, terminal, repo grupal clonado, guía impresa de núcleos U1 y U2, ejemplos resueltos del TP-U1 y TP-U2, lista de verificación de objetivos por alumno. | VS Code, terminal, repo grupal, consignas de desafío impresas, documentación oficial de Python (local o descargada). |

## Desarrollo del Encuentro 17

### Apertura conjunta (10 min)

Plenaria: el docente recorre los núcleos de U1 y U2 con un mapa conceptual en el pizarrón (tipos → variables → entrada/salida → condicionales → bucles → colecciones → funciones). Se asigna cada estudiante a su pista según el desempeño registrado en los TP-U1 y TP-U2. **No se permite celular.**

### Pista intensificación (45 min + 45 min)

**Bloque 1 — U1: tipos, condicionales y bucles (45 min)**
1. **(15 min)** Repaso declaración de variables y tipos. Ejercicio guiado: programa que pida nombre, edad y promedio, los muestre con formato. Errores comunes: no convertir con `int()`/`float()`, concatenar tipos distintos.
2. **(15 min)** Condicionales. Ejercicio: programa para un kiosco escolar que determine si un cliente (\(cliente\)) puede comprar un producto (\(producto\)) según su edad y el tipo de producto. Usar `if`/`elif`/`else`.
3. **(15 min)** Bucles. Ejercicio: mostrar un menú con opciones (1: ver producto, 2: calcular total, 3: salir) usando `while` y `break`.

**Bloque 2 — U2: listas y tuplas (45 min)**
1. **(15 min)** Listas: mutabilidad, índice, `append`, `remove`, slicing. Ejercicio: gestionar la lista de socios (\(socios\)) del club de barrio — agregar, eliminar, mostrar.
2. **(15 min)** Tuplas y set: inmutabilidad, desempacado, operaciones de conjunto (unión, intersección). Ejercicio: separar socios (\(socios\)) activos de inactivos usando set.
3. **(15 min)** Mini-integrador: combinar lista de socios (\(memberList\)) con bucle `for` para mostrar los que tienen cuota (\(clubFee\)) al día. Commit y push en el repo.

### Pista fortalecimiento (45 min + 45 min)

**Bloque 1 — U1 profundizado (45 min)**
1. **(15 min)** Condicionales anidados con `and`/`or`/`not`. Desafío: validar si un socio (\(socio\)) del club puede acceder al salón de usos múltiples según edad, cuota al día (\(clubFee\)) y autorización.
2. **(15 min)** Bucles con `continue` y `else`. Desafío: procesar la lista de socios (\(memberList\)) y saltar los que tienen cuota vencida (\(vencimiento\)), mostrar solo los activos (\(activeMembers\)).
3. **(15 min)** Comprensión de listas. Desafío: generar una lista de edades (\(memberAge\)) filtrada (solo mayores de 18) en una línea.

**Bloque 2 — U2 profundizado (45 min)**
1. **(15 min)** Funciones con valores default y argumentos por nombre. Desafío: función `findMember(memberList, nombre, activo=True)` que busque socios (\(socios\)) activos o inactivos según el parámetro.
2. **(15 min)** Retorno múltiple. Desafío: función que reciba la lista de socios (\(memberList\)) y devuelva el más joven y el más viejo como tupla.
3. **(15 min)** Enumeración con `enumerate`. Desafío: mostrar la lista de socios (\(socios\)) numerada para un menú interactivo.

### Cierre conjunto (20 min)

Puesta en común: cada pista comparte la línea de código que más les costó resolver. El docente destaca los errores típicos (olvidar `int()`, confundir `=` con `==`, modificar una lista mientras se la recorre). Anticipa que en el encuentro siguiente se completa U2 con diccionarios y funciones, y se consolida el ciclo Git.

---

## Desarrollo del Encuentro 18

### Apertura conjunta (10 min)

Repaso relámpago: el docente escribe en vivo un programa que pida tres números, los guarde en una lista y muestre el promedio. Pregunta "¿qué falta? — diccionarios y funciones". Anuncia que hoy se consolidan esos dos núcleos y se cierra el ciclo Git de los TP-U1 y TP-U2.

### Pista intensificación (45 min + 45 min)

**Bloque 1 — Diccionarios (45 min)**
1. **(15 min)** Concepto: pares clave-valor. Ejercicio: crear un diccionario con los datos de un socio (\(socio\)) del club (nombre, edad, cuota, vencimiento) y acceder a cada campo.
2. **(15 min)** Recorrido de diccionarios con `for`. Ejercicio: mostrar el listado completo de socios (\(socios\)) almacenados como diccionarios dentro de una lista.
3. **(15 min)** Mini-integrador: buscar un socio (\(findMember\)) por nombre en una lista de diccionarios. Devolver todos sus datos o un mensaje "no encontrado".

**Bloque 2 — Funciones y bloque principal (45 min)**
1. **(15 min)** Definir función con `def`, parámetros y `return`. Ejercicio: función `calcular_cuota(monto_base, descuento)` que devuelva el total.
2. **(15 min)** Función que reciba una lista de socios (\(memberList\)) y devuelva los activos (\(activeMembers\)). Implementar y probar desde `main()`.
3. **(15 min)** Bloque principal (`if __name__ == "__main__"`). Refactorizar el programa del encuentro 17 para que use funciones y bloque principal. Commit y push.

### Pista fortalecimiento (45 min + 45 min)

**Bloque 1 — Diccionarios profundizados (45 min)**
1. **(15 min)** Diccionarios anidados. Desafío: modelar un club (\(club\)) con lista de socios (\(socios\)) donde cada socio tenga datos personales y un historial de pagos (lista de fechas).
2. **(15 min)** Métodos de diccionarios (`get`, `keys`, `values`, `items`). Desafío: generar un reporte con los socios (\(socios\)) que adeudan más de 2 cuotas (\(clubFee\)).
3. **(15 min)** Comprensión de diccionarios. Desafío: crear un diccionario {nombre: edad} a partir de una lista de diccionarios de socios (\(socios\)) en una línea.

**Bloque 2 — Funciones profundizadas (45 min)**
1. **(15 min)** Funciones como valores de primera clase. Desafío: pasar una función como argumento a otra función (callback) para ordenar la lista de socios (\(memberList\)) por distintos criterios.
2. **(15 min)** `lambda` y `map`/`filter`. Desafío: filtrar socios (\(socios\)) mayores de 18 con `filter` y una función lambda.
3. **(15 min)** `try`/`except` básico. Desafío: envolver la entrada de datos en un bloque `try`/`except` para validar que la edad y la cuota (\(clubFee\)) sean numéricas.

### Cierre conjunto (20 min)

Plenaria final: el docente muestra el repo grupal actualizado con los commits del encuentro. Verifica que los TP-U1 y TP-U2 estén commiteados y pusheados. "Con esto cierran las dos primeras unidades. En el proyecto puente (encuentros 19 y 20) van a integrar todo: entrada, condicionales, bucles, listas, diccionarios, funciones — un solo programa que vale como recuperatorio."

---

## Criterios de logro

| Condición | Criterio |
|---|---|
| Intensificación | El estudiante escribe programas que usan tipos correctos, `input()`/`print()`, condicionales, bucles, listas, tuplas, diccionarios y funciones con `def` y `return`. Utiliza el bloque principal (`if __name__`). Resuelve al menos 3 de los 4 bloques de cada encuentro. Commitea y pushea al repo grupal. |
| Fortalecimiento | El estudiante compone condicionales anidados con operadores lógicos, usa comprensión de listas y diccionarios, escribe funciones con argumentos por nombre y valores default, y emplea `lambda`, `map`/`filter` y `try`/`except` básico. Resuelve los desafíos completos de ambos encuentros. |
| Ambos grupos | Participa de las plenarias de apertura y cierre, y actualiza el repositorio grupal con los avances de cada encuentro. |