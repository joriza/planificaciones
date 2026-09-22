# Intensificación y fortalecimiento de saberes previos — Encuentros 2 y 3

## Metadatos

| Campo | Valor |
|---|---|
| Momento | Intensificación y fortalecimiento de saberes previos |
| Encuentros | 2 y 3 |
| Duración | 2 encuentros × 120 min (240 min total) |
| Destinatarios | Totalidad del curso, con pistas diferenciadas por condición |
| Requisitos | Diagnóstico del Encuentro 1 resuelto; resultados individuales de nivelación |
| Lugar | Aula de informática con VS Code y terminal |

## Acuerdo pedagógico

| Dimensión | Grupo de intensificación (recuperación pedagógica) | Grupo de fortalecimiento (profundización) |
|---|---|---|
| **Contenidos** | Manejo de PC: archivos/carpetas, navegación en el sistema. Terminal: comandos básicos (`cd`, `dir`/`ls`, `mkdir`). Lógica de programación general: secuencia, decisión, repetición (diagramas de flujo, sin Python aún). | Desafíos de lógica sin código: problemas de secuencia, decisión y repetición resueltos en papel y simulados en terminal. Primeros pasos documentados: bitácora personal de comandos y algoritmos. |
| **Actividad / metodología** | Ejercicios guiados de terminal: navegar por carpetas, crear estructura de directorios del curso. Traducir algoritmos cotidianos a diagramas de flujo. Corrección paso a paso. | Desafíos de lógica (torre de Hanói, búsqueda en laberinto) resueltos como pseudocódigo. Bitácora de comandos de terminal con ejemplos propios. |
| **Recursos** | VS Code, terminal del sistema, guía impresa de comandos básicos, plantilla de diagrama de flujo. | VS Code, terminal del sistema, consignas de desafío impresas, plantilla de bitácora personal. |

## Desarrollo del Encuentro 2

### Apertura conjunta (10 min)

Plenaria: el docente presenta los resultados del diagnóstico del Encuentro 1 y explica la organización en dos pistas (intensificación / fortalecimiento). Cada estudiante recibe su asignación. Se recuerda que **no se permite celular** y que todo el trabajo se hace en la PC.

### Pista intensificación (45 min + 45 min)

**Bloque 1 — Terminal y archivos (45 min)**
1. **(15 min)** Conceptos: sistema de archivos, ruta absoluta vs relativa, carpeta vs archivo. Comandos `pwd`, `cd`, `ls` (Linux) o `dir` (Windows).
2. **(15 min)** Práctica guiada: navegar por el sistema, crear la estructura de carpetas del curso (`LAP/`, `LAP/unidad-1/`, etc.) desde la terminal.
3. **(15 min)** Ejercicio: dado un enunciado escrito, crear la estructura de carpetas correspondiente usando solo comandos.

**Bloque 2 — Lógica de programación (45 min)**
1. **(15 min)** Conceptos de secuencia, decisión y repetición con ejemplos cotidianos (receta de cocina, semáforo, contar boletos).
2. **(15 min)** Diagrama de flujo: símbolos básicos (inicio/fin, proceso, decisión, bucle). Traducir "preparar un mate" a diagrama.
3. **(15 min)** Ejercicio individual: dibujar el diagrama de flujo de "decidir si llevar paraguas según el clima".

### Pista fortalecimiento (45 min + 45 min)

**Bloque 1 — Desafíos de terminal (45 min)**
1. **(15 min)** Crear estructura anidada con un solo comando (`mkdir -p` o equivalente). Renombrar y mover archivos desde terminal.
2. **(15 min)** Desafío: replicar el árbol de directorios de un proyecto Python real (carpetas `src/`, `tests/`, `docs/`) usando una sola línea de comandos encadenados.
3. **(15 min)** Bitácora: registrar los comandos nuevos aprendidos con ejemplos de uso real.

**Bloque 2 — Desafíos de lógica (45 min)**
1. **(15 min)** Problema de secuencia: describir paso a paso cómo ordenar tres números sin usar código.
2. **(15 min)** Problema de decisión compuesta: dado un horario y un día, decidir si el kiosco escolar está abierto (combinación de condiciones).
3. **(15 min)** Problema de repetición: simular en terminal la cuenta regresiva con `echo` dentro de un bucle conceptual.

### Cierre conjunto (20 min)

Puesta en común: un voluntario de cada pista comparte su diagrama / bitácora. El docente destaca que la lógica de secuencia → decisión → repetición es la base de TODO programa, sin importar el lenguaje. Anticipa que en el próximo encuentro conocerán la plataforma de entregas.

---

## Desarrollo del Encuentro 3

### Apertura conjunta (10 min)

Repaso rápido: ¿qué es una ruta? ¿qué significa repetir? El docente escribe un diagrama de flujo en el pizarrón y lo recorre colectivamente. Anuncia que hoy se suma la plataforma de entregas del curso.

### Pista intensificación (45 min + 45 min)

**Bloque 1 — Plataforma de entregas (45 min)**
1. **(10 min)** El docente proyecta la URL del repositorio grupal de GitHub (organización del curso). Explica la diferencia entre navegador y cuenta propia.
2. **(15 min)** Cada estudiante abre el navegador, ingresa la URL, inicia sesión en GitHub con su cuenta (creación asistida si hace falta). Verifica que ve el repositorio del curso.
3. **(20 min)** Recorrido guiado por el repo: estructura de carpetas `tp-u1/`, `tp-u2/`, `trabajo-final/`. Explicación de qué se entrega en cada una y cómo se crea un archivo nuevo.

**Bloque 2 — Consolidación de lógica (45 min)**
1. **(15 min)** Del diagrama al pseudocódigo: escribir en lenguaje natural estructurado el algoritmo del encuentro anterior (paraguas / kiosco abierto).
2. **(15 min)** Pseudocódigo con decisiones y bucles: escribir "mostrar la tabla del 5" como texto estructurado.
3. **(15 min)** Relación con Python: "Todo esto que escribimos como diagrama o pseudocódigo, lo van a escribir como código real a partir del Encuentro 4."

### Pista fortalecimiento (45 min + 45 min)

**Bloque 1 — Documentación en la plataforma (45 min)**
1. **(10 min)** Explicación de la organización del repo grupal y el flujo de trabajo con GitHub (issues como tareas, ramas como versiones).
2. **(15 min)** Cada estudiante verifica su cuenta de GitHub, explora el repositorio del curso y localiza los archivos de las unidades.
3. **(20 min)** Desafío: crear un archivo `bitacora.md` en su computadora con los comandos y algoritmos trabajados,列表o en el repo como primer commit simbólico (el docente guía, sin Git todavía — se usará la interfaz web).

**Bloque 2 — Algoritmos de profundización (45 min)**
1. **(15 min)** Desafío de búsqueda: describir el algoritmo para encontrar el número más grande en una lista de tres números (primero en pseudocódigo, luego como diagrama).
2. **(15 min)** Desafío de validación: diseñar un algoritmo que valide si un año es bisiesto — secuencia de condiciones. Comparar con la solución real en Python (el docente la muestra como adelanto).
3. **(15 min)** Bitácora: registrar los algoritmos creados y las preguntas que surgieron, para retomarlas en la Unidad 1.

### Cierre conjunto (20 min)

Plenaria final: el docente muestra la pantalla del repositorio grupal en GitHub. "Este es su espacio de trabajo para todo el año. Cada TP, cada desafío, cada entrega — todo va a estar acá." Verifica que todos tengan sesión iniciada y puedan ver el repo. Cierra con: "El Encuentro 4 empezamos con Python — variables, tipos, `print()` y `input()`. Todo lo que practicaron estos dos encuentros les va a servir."

---

## Criterios de logro

| Condición | Criterio |
|---|---|
| Intensificación | El estudiante navega por el sistema de archivos con comandos básicos (`cd`, `ls`, `mkdir`), dibuja diagramas de flujo simples (secuencia, decisión, repetición), e ingresa a la plataforma GitHub con su cuenta propia. |
| Fortalecimiento | El estudiante ejecuta comandos encadenados de terminal, documenta su aprendizaje en una bitácora personal, y expresa algoritmos de mediana complejidad (búsqueda, validación compuesta) como pseudocódigo estructurado. |
| Ambos grupos | Participa de las plenarias de apertura y cierre, y puede explicar con sus palabras la relación entre un diagrama de flujo, un algoritmo y un programa de computadora. |