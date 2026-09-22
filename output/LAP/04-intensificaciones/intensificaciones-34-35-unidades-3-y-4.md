# Intensificación y fortalecimiento de las Unidades 3 y 4 — Encuentros 34 y 35

## Metadatos

| Campo | Valor |
|---|---|
| Momento | Intensificación y fortalecimiento de las Unidades 3 y 4 |
| Encuentros | 34 y 35 |
| Duración | 2 encuentros × 120 min (240 min total) |
| Destinatarios | Totalidad del curso, con pistas diferenciadas por condición |
| Requisitos | Haber cursado las unidades 3 y 4; tener TP-U3 commiteado y trabajo final en progreso o pendiente; repo grupal GitHub clonado |
| Lugar | Aula de informática con VS Code, terminal y repo grupal GitHub |

## Acuerdo pedagógico

| Dimensión | Grupo de intensificación (recuperación pedagógica) | Grupo de fortalecimiento (profundización) |
|---|---|---|
| **Contenidos** | U3: métodos de cadenas (`split`, `strip`, `join`, `replace`), f-strings, validación con `try`/`except`, menú en memoria (sin archivos). U4: README profesional, issues, ramas, PR, main protegida. Quienes adeuden el trabajo final lo completan con commits y push. | U3: composición de métodos de cadenas para parseo complejo, validación robusta con `try`/`except`/`else`/`finally`, menú con sub-menús. U4: resolución de issues mediante ramas, PR con revisión cruzada entre pares, README avanzado con badges. |
| **Actividad / metodología** | Ejercicios guiados: procesar pedidos de una pizzería (strings, validación), construir menú en memoria, completar y cerrar el trabajo final con README y PR. | Desafíos autónomos: parser de texto de pedidos con formato libre, validador de datos de entrada, menú jerárquico. Flujo profesional completo: issue → rama → PR → merge. |
| **Recursos** | VS Code, terminal, repo grupal clonado, guía impresa de métodos de cadenas y `try`/`except`, plantilla README, lista de verificación de objetivos por alumno. | VS Code, terminal, repo grupal, consignas de desafío impresas, documentación oficial de Python (local o descargada), plantilla README avanzado. |

## Desarrollo del Encuentro 34

### Apertura conjunta (10 min)

Plenaria: el docente recorre los núcleos de U3 (procesamiento de texto, validación, menú en memoria) y U4 (flujo profesional). Explica que hoy se enfocan en U3 y que el trabajo final se retoma en el Encuentro 35. Se asigna cada estudiante a su pista según el desempeño en TP-U3 y el estado del trabajo final. **No se permite celular.**

### Pista intensificación (45 min + 45 min)

**Bloque 1 — Métodos de cadenas (45 min)**
1. **(15 min)** Repaso: `split()`, `strip()`, `join()`, `replace()`. Ejercicio guiado: dividir un pedido (\(pedido\)) de pizzería en ingredientes (\(ingredientes\)), limpiar espacios, unir con comas.
2. **(15 min)** f-strings: formato de salida con variables y expresiones. Ejercicio: mostrar el detalle del pedido de la pizzería (\(pizzería\)) con formato legible: nombre del comprador (\(comprador\)), ingredientes (\(ingredientes\)), precio (\(orderPrice\)).
3. **(15 min)** Aplicación: procesar una línea de texto con datos de un pedido (\(orderText\)) separados por `|`, extraer nombre, teléfono (\(telefono\)) e ingredientes, y mostrar todo con f-strings.

**Bloque 2 — Validación y menú en memoria (45 min)**
1. **(15 min)** `try`/`except` básico. Ejercicio: capturar `ValueError` al convertir precios (\(orderPrice\)) desde string. Mostrar mensaje de error amigable sin que el programa se rompa.
2. **(15 min)** Validación de teléfono (\(validPhone\)): función que verifique que un string tenga solo dígitos y 10 caracteres usando `isdigit()` y `len()`. Integrar en el programa de pedidos.
3. **(15 min)** Menú en memoria: crear un menú con opciones (1: cargar pedido, 2: ver pedidos, 3: buscar por nombre, 4: salir) usando un diccionario como almacenamiento en memoria. Sin archivos, sin base de datos.

### Pista fortalecimiento (45 min + 45 min)

**Bloque 1 — Parseo complejo de texto (45 min)**
1. **(15 min)** Composiciones de métodos de cadena: procesar una línea como `"Muzzarella;Tomate;Aceitunas (sin cebolla)"` extrayendo ingredientes base y extras con `split()` múltiple.
2. **(15 min)** Expresiones regulares básicas con `re.search` (mención, no profundización): validar formato de teléfono (\(telefono\)) con patrón simple. Comparar con la solución de `isdigit()`/`len()`.
3. **(15 min)** Parseo de texto libre: procesar un pedido (\(orderText\)) escrito en lenguaje natural ("2 muzza + 1 napo + 1 fainá") y extraer cantidades, variedades y precios estimados.

**Bloque 2 — Validación robusta y sub-menús (45 min)**
1. **(15 min)** `try`/`except`/`else`/`finally`: estructura completa. Verificar que el bloque `else` se ejecuta solo si no hubo excepción y `finally` siempre.
2. **(15 min)** Función `validPhone` (\(validPhone\)) y `validName` (\(validName\)): validar nombre del cliente (\(customerName\)) que contenga al menos nombre y apellido, y teléfono de exactamente 10 dígitos.
3. **(15 min)** Menú con sub-menús: opción "Pedidos" que abra un segundo nivel (1: cargar, 2: modificar, 3: eliminar, 4: volver). Implementar con diccionario de funciones.

### Cierre conjunto (20 min)

Puesta en común: cada pista comparte un fragmento de código que resolvió. El docente destaca la diferencia entre usar `split()` simple y parsear texto libre. Anticipa que en el próximo encuentro se cierra U4 con el flujo profesional (README, issues, ramas, PR) y se completa el trabajo final quienes lo adeuden.

---

## Desarrollo del Encuentro 35

### Apertura conjunta (10 min)

Repaso: el docente muestra en vivo un programa de pedidos de pizzería funcionando con menú en memoria. Pregunta: "Esto funciona en mi PC. ¿Cómo lo comparto con el mundo?". Respuesta: con README, issues, ramas y PR. Hoy cerramos U4.

### Pista intensificación (45 min + 45 min)

**Bloque 1 — README profesional y cierre del repo (45 min)**
1. **(15 min)** ¿Qué es un README? Estructura básica: título, descripción, tecnologías (Python 3.x), cómo ejecutar, ejemplo de uso. Plantilla provista.
2. **(15 min)** Cada estudiante crea o actualiza el README del repo grupal con la plantilla. Lo commitea en una rama `docs/readme`.
3. **(15 min)** Issues: crear un issue en GitHub con la descripción de una funcionalidad faltante. Asignarla a un compañero.

**Bloque 2 — Trabajo final: commits, PR y main protegida (45 min)**
1. **(20 min)** Quienes adeudan el trabajo final: conectarlo al repo grupal. Commit del código faltante en una rama `feature/trabajo-final`. Abrir PR hacia `main`.
2. **(15 min)** El docente verifica que main esté protegida (no se puede pushear directo). El PR debe ser revisado y mergeado por otro compañero o el docente.
3. **(10 min)** Quienes ya completaron el trabajo final: ayudar a un compañero con su PR (code review cruzado). Verificar que el PR tenga al menos un comentario de revisión.

### Pista fortalecimiento (45 min + 45 min)

**Bloque 1 — README avanzado y flujo profesional (45 min)**
1. **(15 min)** README avanzado: badges de estado, tabla de contenidos, sección de contribución, licencia. Generar badges con shields.io.
2. **(15 min)** Cada estudiante mejora el README del repo con badges y tabla de contenidos. Crea un issue de mejora y lo resuelve con una rama y PR.
3. **(15 min)** Code review cruzado: revisar el PR de un compañero, dejar al menos un comentario sustantivo (sugerencia de mejora, pregunta sobre la implementación).

**Bloque 2 — Resolución de issues con ramas y PR (45 min)**
1. **(15 min)** Tomar un issue abierto del repo (propio o de un compañero), crear rama con nombre descriptivo (`fix/memoria-pedidos`, `feat/ordenar-menu`).
2. **(15 min)** Implementar la solución, commit con mensaje que referencie el issue ("Closes #3: agrega ordenamiento alfabético de pedidos"). Push, abrir PR.
3. **(15 min)** Mergear el PR tras revisión. Verificar que main se actualizó. Eliminar la rama de feature.

### Cierre conjunto (20 min)

Plenaria final: el docente proyecta el repo grupal y muestra los PRs mergeados, los issues resueltos, el README actualizado y la main protegida. "Esto es un repositorio profesional. Lo que vieron hoy es cómo se trabaja en equipo en cualquier empresa de software. Cerramos U4."

---

## Criterios de logro

| Condición | Criterio |
|---|---|
| Intensificación | El estudiante procesa strings con `split`/`strip`/`join`/`replace`, escribe f-strings, valida entrada con `try`/`except`, construye un menú en memoria con diccionarios, y crea/actualiza el README del repo. Completa el trabajo final con commits, rama y PR. Resuelve al menos 3 de los 4 bloques. |
| Fortalecimiento | El estudiante compone métodos de cadenas para parseo complejo, aplica `try`/`except`/`else`/`finally`, implementa sub-menús, lidera code review cruzado, y resuelve issues con ramas y PRs. README avanzado con badges. |
| Ambos grupos | Participa de las plenarias de apertura y cierre, actualiza el repositorio grupal, y completa el cierre del trabajo final con commits y PR. |