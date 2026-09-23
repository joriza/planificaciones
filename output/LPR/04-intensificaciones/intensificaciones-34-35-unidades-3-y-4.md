# Intensificación de las Unidades 3 y 4 — Encuentros 34 y 35

## Metadatos

| Campo | Valor |
|---|---|
| Momento | Intensificación de las Unidades 3 y 4 |
| Encuentros | 34 y 35 |
| Duración | 2 encuentros × 120 min (240 min total) |
| Destinatarios | Estudiantes que no alcanzaron los objetivos mínimos de las Unidades 3 y 4 |
| Requisitos | Haber cursado las Unidades 1 a 4; tener cuenta de GitHub activa y repo grupal clonado |
| Lugar | Aula de informática con VS Code, terminal y repo grupal GitHub |

## Acuerdo pedagógico

| Dimensión | Grupo de intensificación (recuperación pedagógica) | Grupo de fortalecimiento (profundización) |
|---|---|---|
| **Contenidos** | Camino mínimo de U3 y U4: 1) métodos de cadenas (`split`, `strip`, `join`, `replace`) y f-strings; 2) validación con `try`/`except`; 3) módulos (`import` de built-ins); 4) menú en memoria integrado; 5) flujo profesional de Git y GitHub (README, issues, ramas, pull requests, main protegida). Dominio: pedidos de una pizzería (U3) y videoteca con alquiler de películas (U4). | Extensión del programa integrador con funcionalidades adicionales: procesamiento de texto avanzado, validación de rangos, menús con múltiples niveles, generación de reportes. |
| **Actividad / metodología** | Recorrido acelerado por los contenidos mínimos de U3 y U4. Cada estudiante reconstruye un programa integrador de consola sobre el dominio de la pizzería y la videoteca en dos encuentros. Encuentro 1: procesamiento de texto, validación y menú. Encuentro 2: flujo profesional de Git, README y defensa. | Desafíos autónomos de extensión sobre el mismo programa base: agregar procesamiento de texto avanzado, validación de rangos y reportes. |
| **Recursos** | VS Code, terminal, repo grupal clonado, guía impresa de núcleos U3 y U4, lista de verificación de objetivos por alumno. | VS Code, terminal, repo grupal, consignas de desafío impresas. |

## Desarrollo del Encuentro 1

### Apertura (10 min)

El docente explica la modalidad de la instancia de intensificación: "Hoy integran los núcleos de las Unidades 3 y 4 en un solo programa. El dominio es la pizzería (U3) y la videoteca (U4)." Se entrega la lista de verificación individual con los objetivos no alcanzados. **No se permite celular.**

### Desarrollo (45 min + 45 min)

**Bloque 1 — Procesamiento de texto y validación (45 min)**

1. **(15 min)** Ejercicio 1 — programa base: crear un archivo `pizzeria_videoteca.py`. Declarar variables para una orden de pizza: ingredientes (`str`), cantidad (`int`), precio unitario (`float`). Pedir datos con `input()` y convertir. Mostrar con f-string.
2. **(15 min)** Ejercicio 2 — métodos de cadenas: usar `split` para separar ingredientes separados por coma, `strip` para limpiar espacios, `join` para armar el resumen de la orden, `replace` para normalizar nombres.
3. **(15 min)** Ejercicio 3 — validación con `try`/`except`: envolver la conversión de cantidad y precio en un bloque `try`/`except` que capture `ValueError`. Mostrar "Dato inválido, intente de nuevo" y pedir el dato otra vez.

**Bloque 2 — Menú y módulos (45 min)**

1. **(15 min)** Ejercicio 4 — menú con `while True`: opciones (1: pedir pizza, 2: ver resumen de la orden, 3: salir). Usar `break` para salir.
2. **(15 min)** Ejercicio 5 — módulos: importar `random` para simular tiempos de espera estimados y `math` para redondear el total. Mención puntual de `import` como herramienta disponible.
3. **(15 min)** Ejercicio 6 — integración: combinar entrada, procesamiento de texto, validación y menú en un solo archivo `.py` con funciones y bloque principal.

### Cierre (20 min)

Verificación individual: el docente recorre los puestos y marca en la lista de verificación qué objetivos están logrados (1 a 6) y cuáles quedan pendientes para el encuentro siguiente. Cada estudiante hace commit del avance con mensaje `"feat: pizzeria_videoteca base y validacion"`.

---

## Desarrollo del Encuentro 2

### Apertura (10 min)

Repaso de lo logrado en el encuentro anterior. El docente presenta los objetivos del día: menú completo, flujo profesional de Git, README y defensa.

### Desarrollo (45 min + 45 min)

**Bloque 1 — Menú completo y flujo profesional (45 min)**

1. **(15 min)** Ejercicio 7 — menú completo en memoria: opciones (1: pedir pizza, 2: ver resumen, 3: simular tiempo de espera con `random`, 4: salir). Cada opción ejecuta la función correspondiente.
2. **(15 min)** Ejercicio 8 — flujo profesional de Git: crear rama por feature (`feat/menu-completo`), hacer commit con mensaje descriptivo, abrir pull request, revisar entre pares y merge a `main`.
3. **(15 min)** Ejercicio 9 — README profesional: crear `README.md` con título, descripción del programa, tecnologías usadas, instrucciones de ejecución y estructura del proyecto.

**Bloque 2 — Defensa y entrega (45 min)**

1. **(15 min)** Ejercicio 10 — verificación final: el estudiante ejecuta el programa y muestra que funciona correctamente con datos válidos y con entrada no numérica (prueba de `try`/`except`).
2. **(15 min)** Ejercicio 11 — defensa individual: cada estudiante explica brevemente qué hace el programa, cómo valida los datos de entrada y una función que le haya costado implementar.
3. **(15 min)** Ejercicio 12 — cierre de issues y preparación de la defensa: revisar que todos los puntos del README estén completos y que el repo refleje el flujo profesional.

### Cierre con verificación (20 min)

El docente recorre los puestos con la lista de verificación. Cada estudiante explica brevemente su programa y recibe la notificación de Apto o No apto aún por objetivo mínimo.

---

## Evaluación

| Resultado | Condición |
|---|---|
| **Apto** | El programa compila y ejecuta. Usa `input()`/`print()` con tipos correctos, métodos de cadenas (`split`, `strip`, `join`, `replace`), `try`/`except` para validación, menú en memoria con `while True`, funciones con `def`, `return` y bloque principal `if __name__ == "__main__"`. El repo tiene flujo profesional (ramas, PR, README). El estudiante defiende su código. |
| **No apto aún por objetivo mínimo** | Falta al menos uno de los elementos anteriores. Se especifica qué objetivo(s) no se alcanzó y se informa al estudiante junto con la recomendación de recursar la materia si el período lo permite. |

## Criterios de logro

| Condición | Criterio |
|---|---|
| Apto | El estudiante construye un programa de consola completo (procesamiento de texto, validación, menú en memoria) sobre el dominio de la pizzería y la videoteca. El código está en GitHub con README y flujo profesional. Durante la defensa explica el funcionamiento general, cómo valida los datos y al menos una función en detalle. |
| No apto | El estudiante no completa alguno de los componentes anteriores, no puede sostener una explicación coherente de su propio código, o no entregó el programa en GitHub con flujo profesional. Recibe el detalle de objetivos pendientes y la comunicación formal del resultado. |
