# Evaluación del momento de intensificación — Saberes previos (Encuentros 2-3)

> Documento de la instancia de evaluación del momento de saberes previos. La consigna de cada versión está en su documento propio (`evaluacion-intensificaciones-02-03-version-a.md` y `evaluacion-intensificaciones-02-03-version-b.md`). La guía de corrección está incluida en este documento; no se generan anexos separados para esta evaluación.

## Metadatos

| Campo | Valor |
|---|---|
| Materia | Programación en Python |
| Instancia | Momento de intensificación y fortalecimiento de saberes previos — Encuentros 2 y 3; resolución en el segundo encuentro, en el bloque que el docente disponga |
| Duración | 60 minutos |
| Modalidad | Resolución manuscrita de pseudocódigo y traza, más demostración práctica de terminal |
| Entrega | Hoja de resolución con apellido, nombre y grupo; demostración de terminal frente al docente |
| Destinatarios | Todo el curso (las dos pistas del momento); el ejercicio acredita los objetivos mínimos de los previos |
| Requisitos previos | Encuentro 1 (encuadre y diagnóstico) y Encuentro 2 (secuencia y decisión) trabajados. No se usa Python ni Git: todavía no corresponden |
| Lugar de trabajo | Laboratorio de informática, con la guía de comandos básicos impresa del curso |
| Celular | No permitido |
| Versiones | A (ventas de un kiosco) y B (inscriptos de un club), equivalentes; asignación por grupo a cargo del docente |
| Criterio | Apto / No apto aún, por objetivo mínimo |

## Acuerdo de evaluación

La evaluación del momento acredita los saberes previos trabajados en los Encuentros 2 y 3: secuencia, decisión y repetición en pseudocódigo, traza de un bucle corto y comandos básicos de terminal. Es un ejercicio pequeño: tres problemas de pseudocódigo, una tabla de traza y una demostración de terminal. El resultado orienta el acompañamiento durante la Unidad 1; no reemplaza la evaluación de la unidad (Encuentro 9).

Las versiones A y B son equivalentes en dificultad: mismos objetivos y mismos requisitos, con distinto dominio de datos, y ninguna tiene reglas que la otra no tenga. Su propósito es que la elección de versión no otorgue ventaja ni habilite la copia entre grupos. La asignación la realiza el docente al inicio del bloque, alternando versiones entre grupos vecinos.

## Objetivos evaluados

- Resolver en pseudocódigo un problema de secuencia con tres entradas y una salida.
- Escribir una decisión con tres salidas posibles y verificarla con un caso por rama.
- Trazar un bucle corto indicando el valor de la variable acumuladora en cada vuelta.
- Integrar secuencia, decisión y repetición en un problema único, con valor centinela y descarte de valores inválidos.
- Crear una carpeta, ingresar a ella y listar su contenido con los comandos de terminal trabajados en clase.

## Consigna general

Resolver en la hoja los cinco puntos de la versión asignada al grupo: un problema de secuencia, uno de decisión con tres salidas, una tabla de traza de un bucle dado, un problema integrador con valor centinela y la secuencia de comandos de terminal anotada para su demostración. El dominio de datos de cada punto está en el documento de la versión.

## Condiciones de resolución

- Pseudocódigo legible, una acción por línea, con las palabras del curso: Leer, Mostrar, Si, Si no, Mientras.
- Cada decisión se verifica en la hoja con un caso por rama: valor probado y salida esperada.
- La traza se completa en tabla, con una fila por vuelta del bucle y una columna por variable.
- El problema integrador descarta los valores negativos con un aviso y evita dividir por cero cuando ningún valor supera el umbral.
- Los comandos de terminal se anotan tal como figuran en la guía impresa del curso.

## Criterios de acreditación por objetivo

| Objetivo mínimo | Evidencia en el ejercicio | Apto cuando |
|---|---|---|
| Secuencia con tres entradas y una salida | Punto 1 de la hoja | El pseudocódigo acumula los tres valores y muestra un único promedio |
| Decisión con tres salidas posibles | Punto 2 | Las tres ramas están escritas y cada una tiene su caso de verificación con la salida esperada |
| Traza de un bucle corto | Punto 3 | La tabla indica el valor del acumulador en cada vuelta y el total final es correcto |
| Integración con centinela y validación simple | Punto 4 | Lee hasta el centinela, descarta los negativos con aviso, cuenta los que superan el umbral y evita la división por cero |
| Comandos básicos de terminal | Punto 5 y demostración | Crea la carpeta, ingresa a ella y lista el contenido frente al docente, con los comandos anotados en la hoja |

**Regla de decisión:** el resultado es **Apto** cuando los cinco objetivos figuran acreditados. Con al menos un objetivo sin acreditar, el resultado es **No apto aún**, y se registran los objetivos pendientes como insumo del acompañamiento durante la Unidad 1.

## Guía de corrección

### Solución esperada — Versión A (ventas de un kiosco)

- Punto 1: promedio de 500, 750 y 1.250; acumular y dividir por 3 (2500 / 3 ≈ 833,33).
- Punto 2: `Si monto > 1000` → «Venta destacada»; `Si no, si monto = 1000` → «Venta en el límite»; `Si no` → «Venta común». La rama del caso igual se verifica con 1.000 exacto.
- Punto 3: suma del 1 al 5; acumulador en cada vuelta: 1, 3, 6, 10, 15.
- Punto 4: `Mientras monto ≠ 0`; con `monto < 0` avisa y descarta; con `monto > 1000` suma al contador y al acumulador; al final, si la cantidad es 0 muestra «No hubo ventas destacadas» sin dividir.
- Punto 5: crear la carpeta (`mkdir` o `md`), ingresar (`cd`) y listar (`dir` o el equivalente de la guía impresa).

### Solución esperada — Versión B (inscriptos de un club)

- Punto 1: promedio de 9, 11 y 14; acumular y dividir por 3 (34 / 3 ≈ 11,33).
- Punto 2: `Si edad > 12` → «Juveniles»; `Si no, si edad = 12` → «Límite»; `Si no` → «Infantiles». Verificación del caso igual con 12 exacto.
- Punto 3: suma de los pares del 2 al 10; acumulador en cada vuelta: 2, 6, 12, 20, 30.
- Punto 4: misma estructura que la versión A con el umbral de 12 años y el aviso «No hubo inscriptos juveniles».
- Punto 5: idéntico a la versión A.

### Errores que invalidan el objetivo

- Decisión sin la rama del caso igual al umbral, o verificación que no cubre las tres salidas: objetivo 2 no acreditado.
- Traza con el total solo al final, sin el valor del acumulador vuelta por vuelta: objetivo 3 no acreditado.
- Integrador que divide por cero cuando ninguno supera el umbral, o que acepta valores negativos sin aviso: objetivo 4 no acreditado.
- Comandos inventados, o demostración que no crea e ingresa a la carpeta: objetivo 5 no acreditado.

### Registro del resultado

- Planilla mínima: apellido y nombre; grupo; cinco columnas de objetivos (1 a 5); resultado final.
- Apto: cinco objetivos acreditados. No apto aún: se consignan los pendientes y se comunica al grupo de acompañamiento de la Unidad 1.

## Desarrollo del bloque de evaluación (60 minutos)

| Momento | Minutos |
|---|---|
| Lectura de la consigna y de la versión asignada | 5 |
| Resolución de los puntos 1 a 4 (pseudocódigo y traza) | 40 |
| Demostración de terminal frente al docente, por grupo | 10 |
| Revisión final de la hoja y entrega | 5 |
| **Total** | **60** |

## Versiones

| Versión | Dominio de datos | Consigna |
|---|---|---|
| A | Ventas de un kiosco (montos en pesos) | `evaluacion-intensificaciones-02-03-version-a.md` |
| B | Inscriptos de un club (edades) | `evaluacion-intensificaciones-02-03-version-b.md` |
