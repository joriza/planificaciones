# Momento de intensificación y fortalecimiento — Saberes previos (Encuentros 2-3)

> Momento de nivelación sobre lo que el grupo trae, organizado a partir del diagnóstico del Encuentro 1. **No imparte contenido nuevo del curso**: trabaja exclusivamente sobre saberes previos. El contenido de la Unidad 1 comienza en el Encuentro 4.

## Datos del momento

| Campo | Valor |
|---|---|
| Momento de uso | Encuentros 2 y 3 — Intensificación y fortalecimiento de saberes previos (primera instancia) |
| Duración | 2 encuentros de 120 minutos |
| Destinatarios | Todo el curso, agrupado en dos pistas según el diagnóstico del Encuentro 1: grupo de intensificación (previos con brechas) y grupo de fortalecimiento (previos sólidos) |
| Requisitos | Haber participado del Encuentro 1 (encuadre y diagnóstico). No se requiere Python ni Git: todavía no se usan |
| Lugar de trabajo | Laboratorio de informática. VS Code y terminal; uso de celular: no permitido |

## Acuerdo pedagógico

### Grupo de intensificación (recuperación pedagógica)

| Componente | Acuerdo |
|---|---|
| Contenidos mínimos irrenunciables | Secuencia, decisión y repetición resueltas en pseudocódigo; traza de un algoritmo corto sobre papel; navegación de carpetas y ejecución de comandos básicos en la terminal |
| Actividad y metodología | Problemas mínimos guiados paso a paso (uno por concepto, en orden creciente); traza colectiva en el pizarrón; cada consigna se prueba antes de darla por resuelta |
| Recursos | Pseudocódigo en papel; terminal del laboratorio; guía de comandos básicos impresa |

### Grupo de fortalecimiento (profundización)

| Componente | Acuerdo |
|---|---|
| Contenidos de fortalecimiento | Los mismos conceptos previos en problemas más completos: acumuladores y conteos por condición, validación de entrada en pseudocódigo y casos límite. Sin adelantar contenidos del curso |
| Actividad y metodología | Desafíos de lógica con autocontrol: diseñar, trazar con casos límite y revisar en pares; puesta en común de dos soluciones alternativas por problema |
| Recursos | Enunciados de desafíos; plantilla de traza; terminal del laboratorio |

## Encuentro 2 — Secuencia y decisión sobre lo que el grupo trae

### Objetivos del encuentro

- Explicitar el diagnóstico del Encuentro 1 y conformar las dos pistas de trabajo.
- Resolver problemas de secuencia y decisión en pseudocódigo, según la pista.
- Verificar cada solución con al menos un caso de prueba antes de cerrarla.

### Agenda (120 minutos)

| Bloque | Minutos | Actividad |
|---|---|---|
| Plenaria conjunta de apertura | 15 | Devolución del diagnóstico del Encuentro 1; presentación de las dos pistas y del modo de trabajo del momento |
| Trabajo por pistas | 75 | Intensificación: tres problemas guiados de secuencia y decisión (pseudocódigo), con traza colectiva del segundo. Fortalecimiento: dos desafíos con acumulador y conteo por condición, trazados con casos límite y revisados en pares |
| Plenaria conjunta de cierre | 20 | Dos grupos por pista exponen su solución; el docente sistematiza los errores comunes de decisión (condiciones incompletas, orden de las comparaciones) |
| Cierre individual | 10 | Cada estudiante anota en su carpeta un problema resuelto y la condición que más le costó; quedará como insumo del Encuentro 3 |

### Detalle de la pista de intensificación

1. Problema de secuencia: calcular el promedio de tres números dados (entradas fijas, sin interacción).
2. Problema de decisión: indicar si una nota permite aprobar, con el umbral leído del enunciado.
3. Problema combinado: leer dos notas y decidir entre «aprobado», «recuperación» o «insuficiente».
4. Quien completa antes: agregar a cada solución el caso límite que la rompería (nota exactamente en el umbral) y cómo lo resuelve.

### Detalle de la pista de fortalecimiento

1. Desafío de conteo: dada una lista de notas en el enunciado, contar cuántas superan el umbral, usando acumulador.
2. Desafío combinado: de la misma lista, obtener el promedio solo de las notas que lo superan y decidir qué pasa si ninguna lo hace.
3. Quien completa antes: resolver el desafío con validación de entrada en pseudocódigo (¿qué pasa si la nota es 99 o un texto?) y documentar la decisión.

## Encuentro 3 — Repetición y puente hacia la Unidad 1

### Objetivos del encuentro

- Resolver problemas con repetición y trazar bucles cortos sobre papel.
- Integrar secuencia, decisión y repetición en un problema único, según la pista.
- Reconocer qué se trabajará en la Unidad 1 (Encuentro 4) y con qué previos se llega.

### Agenda (120 minutos)

| Bloque | Minutos | Actividad |
|---|---|---|
| Plenaria conjunta de apertura | 10 | Recapitulación del Encuentro 2 desde los cierres individuales; objetivo del día |
| Trabajo por pistas | 80 | Intensificación: dos problemas de repetición con traza sobre papel y un problema integrador (leer notas hasta un tope y calcular el promedio). Fortalecimiento: desafío integrador con repetición, decisión y validación de entrada, más un contraejercicio de detección de errores en pseudocódigo ajeno |
| Plenaria conjunta de cierre | 20 | Comparación de las dos pistas sobre el mismo problema integrador; sistematización: los tres constructos (secuencia, decisión, repetición) son los que usará Python desde el Encuentro 4 |
| Puente a la Unidad 1 | 10 | Presentación de 5 minutos de lo que será el primer programa en Python; verificación de que cada estudiante tiene cuenta y carpeta de trabajo listas para el laboratorio |

### Detalle de la pista de intensificación

1. Repetición con tope fijo: sumar los números del 1 al 10 con traza completa de la variable acumuladora.
2. Repetición con condición: seguir leyendo números hasta que se ingrese un valor centinela.
3. Problema integrador: leer tres notas, validar que estén entre 1 y 10 y mostrar el promedio con su condición.
4. Quien completa antes: trazar el problema integrador con una nota inválida y describir qué debería hacer el algoritmo.

### Detalle de la pista de fortalecimiento

1. Desafío integrador: de una lista de inscripciones (nombre y tres notas), producir el listado con condición de cada estudiante y el promedio general, validando las notas.
2. Contraejercicio: el docente entrega un pseudocódigo con tres errores sembrados (condición invertida, acumulador mal inicializado, tope mal puesto); cada par debe encontrarlos justificando con traza.
3. Quien completa antes: redactar la versión del desafío que acepta una cantidad variable de notas por estudiante y discutir el costo de esa generalización.

## Criterios de logro

### Grupo de intensificación

- Resuelve en pseudocódigo un problema de secuencia con tres entradas y una salida.
- Escribe una decisión con dos o tres salidas posibles y la verifica con un caso por rama.
- Traza un bucle corto indicando el valor de la variable de control en cada vuelta.
- Navega carpetas y ejecuta comandos básicos en la terminal sin asistencia.
- Resuelve el problema integrador del Encuentro 3 combinando los tres constructos.

### Grupo de fortalecimiento

- Resuelve los desafíos con acumuladores y conteos por condición, con casos límite documentados.
- Detecta los errores sembrados en un pseudocódigo ajeno y justifica cada hallazgo con traza.
- Agrega validación de entrada a un problema propio sin que se le pida.
- Explica oralmente dos soluciones alternativas de un mismo problema y sus diferencias.

## Evaluación del momento

El momento tiene evaluación propia, en la carpeta de evaluaciones de los momentos del curso (ver README), con versiones equivalentes por grupo y criterio **Apto / No apto aún por objetivo mínimo** sobre los saberes previos trabajados. El resultado orienta el acompañamiento durante la Unidad 1; no reemplaza la evaluación de la unidad (Encuentro 9).
