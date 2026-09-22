# Intensificación y fortalecimiento de saberes previos — Encuentros 2 y 3

## Metadatos

| Campo | Valor |
|---|---|
| Momento | Intensificación y fortalecimiento de saberes previos |
| Encuentros | 2 y 3 |
| Duración | 2 encuentros × 240 min (4 horas reloj cada uno) |
| Destinatarios | Totalidad del curso, con pistas diferenciadas por condición |
| Requisitos | Diagnóstico del Encuentro 1 resuelto; resultados individuales de nivelación; VS Code y terminal configurados |
| Lugar | Aula de informática con VS Code y terminal |
| Uso de celular | No permitido |

## Acuerdo pedagógico

| Dimensión | Grupo de intensificación (recuperación pedagógica) | Grupo de fortalecimiento (profundización) |
|---|---|---|
| **Contenidos** | Manejo de PC: archivos y carpetas, navegación en el sistema de archivos. Terminal: comandos básicos (`cd`, `ls`/`dir`, `mkdir`, `touch`). Lógica de programación general: secuencia, decisión, repetición (diagramas de flujo, sin C# aún). | Desafíos de lógica sin código: problemas de secuencia, decisión y repetición resueltos en papel y simulados en terminal. Primeros pasos documentados: bitácora personal de comandos y algoritmos. |
| **Actividad / metodología** | Ejercicios guiados de terminal: navegar por carpetas, crear la estructura de directorios del curso. Traducir algoritmos cotidianos a diagramas de flujo. Corrección paso a paso por el docente. | Desafíos de lógica (torre de Hanói, búsqueda en laberinto) resueltos como pseudocódigo. Bitácora de comandos de terminal con ejemplos propios. |
| **Recursos** | VS Code, terminal del sistema, guía impresa de comandos básicos, plantilla de diagrama de flujo. | VS Code, terminal del sistema, consignas de desafío impresas, plantilla de bitácora personal. |

## Desarrollo del Encuentro 2

### Apertura conjunta (15 min)

Plenaria: el docente presenta los resultados del diagnóstico del Encuentro 1 y explica la organización en dos pistas (intensificación / fortalecimiento). Cada estudiante recibe su asignación. Se recuerda que **no se permite celular** y que todo el trabajo se hace en la PC.

### Pista intensificación — Bloque 1 (50 min)

**Terminal y archivos (50 min)**

1. **(15 min)** Conceptos: sistema de archivos, ruta absoluta vs relativa, carpeta vs archivo. Comandos `pwd`, `cd`, `ls` (Linux) o `dir` (Windows). El docente modela cada comando en vivo.
2. **(15 min)** Práctica guiada: navegar por el sistema, crear la estructura de carpetas del curso (`LSO/`, `LSO/unidad-1/`, etc.) desde la terminal. El docente acompaña paso a paso.
3. **(20 min)** Ejercicio: dado un enunciado escrito, crear la estructura de carpetas correspondiente usando solo comandos de terminal. El docente verifica que cada grupo tenga la estructura correcta.

### Pista fortalecimiento — Bloque 1 (50 min)

**Desafíos de terminal (50 min)**

1. **(15 min)** Crear estructura anidada con un solo comando (`mkdir -p` o equivalente en Windows). Renombrar y mover archivos desde terminal.
2. **(15 min)** Desafío: replicar el árbol de directorios de un proyecto real (carpetas `src/`, `tests/`, `docs/`) usando una sola línea de comandos encadenados.
3. **(20 min)** Bitácora: registrar los comandos nuevos aprendidos con ejemplos de uso real en una plantilla de bitácora personal.

### Pista intensificación — Bloque 2 (50 min)

**Lógica de programación: secuencia y decisión (50 min)**

1. **(15 min)** Conceptos de secuencia, decisión y repetición con ejemplos cotidianos (receta de cocina, semáforo, contar boletos). El docente dibuja el diagrama de flujo en el pizarrón.
2. **(15 min)** Diagrama de flujo: símbolos básicos (inicio/fin, proceso, decisión, bucle). Traducir "preparar un mate" a diagrama de flujo.
3. **(20 min)** Ejercicio individual: dibujar el diagrama de flujo de "decidir si llevar paraguas según el clima". El docente recorre el aula y orienta.

### Pista fortalecimiento — Bloque 2 (50 min)

**Desafíos de lógica: secuencia y decisión (50 min)**

1. **(15 min)** Problema de secuencia: describir paso a paso cómo ordenar tres números sin usar código. Escribir el algoritmo en lenguaje natural estructurado.
2. **(15 min)** Problema de decisión compuesta: dado un horario y un día, decidir si el kiosco escolar está abierto (combinación de condiciones). Dibujar el diagrama de flujo correspondiente.
3. **(20 min)** Comparación en parejas: cada estudiante intercambia su diagrama con un compañero y verifica si la lógica es correcta. El docente retoma los errores más frecuentes en plenario.

### Pista intensificación — Bloque 3 (50 min)

**Lógica de programación: repetición (50 min)**

1. **(15 min)** Concepto de bucle: `while` y `for` como formas de repetir. Ejemplo: contar del 1 al 10. El docente modela en la terminal.
2. **(15 min)** Diagrama de flujo del bucle: símbolo de decisión con retroceso. Traducir "mostrar la tabla del 5" a diagrama de flujo con bucle.
3. **(20 min)** Ejercicio individual: dibujar el diagrama de flujo de "sumar los números del 1 al 100". El docente verifica que cada estudiante comprenda el concepto de iteración.

### Pista fortalecimiento — Bloque 3 (50 min)

**Desafíos de lógica: repetición y composición (50 min)**

1. **(15 min)** Problema de repetición: simular en terminal la cuenta regresiva con `echo` dentro de un bucle conceptual. Luego, escribir el pseudocódigo completo.
2. **(15 min)** Problema de composición: combinar secuencia, decisión y repetición en un solo algoritmo. Ejemplo: "dado un listado de notas, mostrar las aprobadas y el promedio".
3. **(20 min)** Desafío avanzado: diseñar un algoritmo que valide si un año es bisiesto — secuencia de condiciones compuestas. Comparar la solución con la de un compañero.

### Pista intensificación — Bloque 4 (45 min)

**Integración y práctica (45 min)**

1. **(15 min)** Del diagrama al pseudocódigo: escribir en lenguaje natural estructurado el algoritmo del encuentro anterior (paraguas / kiosco abierto / suma 1-100).
2. **(15 min)** Pseudocódigo con decisiones y bucles: escribir "mostrar la tabla del 5" como texto estructurado.
3. **(15 min)** Relación con C#: "Todo esto que escribimos como diagrama o pseudocódigo, lo van a escribir como código real a partir del Encuentro 4. C# usa variables, tipos y condicionales — la lógica es la misma."

### Pista fortalecimiento — Bloque 4 (45 min)

**Algoritmos de profundización (45 min)**

1. **(15 min)** Desafío de búsqueda: describir el algoritmo para encontrar el número más grande en una lista de tres números (primero en pseudocódigo, luego como diagrama).
2. **(15 min)** Desafío de validación: diseñar un algoritmo que valide si un año es bisiesto — secuencia de condiciones. Comparar con la solución real en C# (el docente la muestra como adelanto).
3. **(15 min)** Bitácora: registrar los algoritmos creados y las preguntas que surgieron, para retomarlas en la Unidad 1.

### Cierre conjunto (15 min)

Puesta en común: un voluntario de cada pista comparte su diagrama / bitácora. El docente destaca que la lógica de secuencia → decisión → repetición es la base de TODO programa, sin importar el lenguaje. Anticipa que en el próximo encuentro conocerán la plataforma de entregas.

### Errores comunes y trampas

1. **Confundir ruta absoluta con relativa.** Causa: los alumnos no entienden la diferencia entre empezar desde la raíz del sistema y desde la carpeta actual. Fix: el docente practica `pwd` (ruta absoluta) y `cd ..` (relativa) en vivo.
2. **No traer el dispositivo con VS Code instalado.** Causa: los alumnos subestiman la importancia de tener el entorno listo desde el primer día. Fix: en el contrato pedagógico se especifica que el entorno debe estar instalado antes del E2.
3. **Confundir el diagnóstico con una evaluación.** Causa: los alumnos se ponen ansiosos al ver una hoja con preguntas. Fix: el docente deja claro desde el inicio que el diagnóstico no se califica y que sirve para conocer el punto de partida del grupo.
4. **Subestimar la importancia del celular.** Causa: los alumnos están acostumbrados a usar el celular como herramienta de consulta constante. Fix: se establece desde el E1 que el celular no está permitido durante los encuentros.
5. **No leer el contrato pedagógico.** Causa: los alumnos suelen firmar sin leer. Fix: el docente dedica tiempo a recorrer las cláusulas más relevantes y responde preguntas antes de pedir la firma.
6. **Confundir un diagrama de flujo con el código final.** Causa: los alumnos piensan que el diagrama es el programa terminado. Fix: el docente deja claro que el diagrama es un plano, y que el código viene después, en C#.

## Desarrollo del Encuentro 3

### Apertura conjunta (15 min)

Repaso rápido: ¿qué es una ruta? ¿qué significa repetir? El docente escribe un diagrama de flujo en el pizarrón y lo recorre colectivamente. Anuncia que hoy se suma la plataforma de entregas del curso.

### Pista intensificación — Bloque 1 (50 min)

**Plataforma de entregas (50 min)**

1. **(10 min)** El docente proyecta la URL del repositorio grupal de GitHub (organización del curso). Explica la diferencia entre navegador y cuenta propia.
2. **(15 min)** Cada estudiante abre el navegador, ingresa la URL, inicia sesión en GitHub con su cuenta (creación asistida si hace falta). Verifica que ve el repositorio del curso.
3. **(25 min)** Recorrido guiado por el repo: estructura de carpetas `tp-u1/`, `tp-u2/`, `trabajo-final/`. Explicación de qué se entrega en cada una y cómo se crea un archivo nuevo. El docente modela la creación de una carpeta en el navegador.

### Pista fortalecimiento — Bloque 1 (50 min)

**Documentación en la plataforma (50 min)**

1. **(10 min)** Explicación de la organización del repo grupal y el flujo de trabajo con GitHub (issues como tareas, ramas como versiones).
2. **(15 min)** Cada estudiante verifica su cuenta de GitHub, explora el repositorio del curso y localiza los archivos de las unidades.
3. **(25 min)** Desafío: crear un archivo `bitacora.md` en su computadora con los comandos y algoritmos trabajados, listo en el repo como primer commit simbólico (el docente guía, sin Git todavía — se usará la interfaz web).

### Pista intensificación — Bloque 2 (50 min)

**Consolidación de lógica (50 min)**

1. **(15 min)** Del diagrama al pseudocódigo: escribir en lenguaje natural estructurado el algoritmo del encuentro anterior (paraguas / kiosco abierto / suma 1-100).
2. **(15 min)** Pseudocódigo con decisiones y bucles: escribir "mostrar la tabla del 5" como texto estructurado.
3. **(20 min)** Relación con C#: "Todo esto que escribimos como diagrama o pseudocódigo, lo van a escribir como código real a partir del Encuentro 4." El docente muestra un ejemplo mínimo de un programa en C# que usa `Console.WriteLine` y un `if`.

### Pista fortalecimiento — Bloque 2 (50 min)

**Algoritmos de profundización (50 min)**

1. **(15 min)** Desafío de búsqueda: describir el algoritmo para encontrar el número más grande en una lista de tres números (primero en pseudocódigo, luego como diagrama).
2. **(15 min)** Desafío de validación: diseñar un algoritmo que valide si un año es bisiesto — secuencia de condiciones. Comparar con la solución real en C# (el docente la muestra como adelanto).
3. **(20 min)** Bitácora: registrar los algoritmos creados y las preguntas que surgieron, para retomarlas en la Unidad 1.

### Pista intensificación — Bloque 3 (45 min)

**Integración terminal + lógica (45 min)**

1. **(15 min)** Ejercicio integrador: crear una carpeta `logica/` dentro de la estructura del curso, y dentro de ella crear un archivo `algoritmo.txt` con el pseudocódigo del algoritmo del paraguas.
2. **(15 min)** Ejercicio de terminal: mover el archivo `algoritmo.txt` a una subcarpeta `backup/` usando comandos de terminal.
3. **(15 min)** Verificación final: el docente recorre el aula y verifica que cada estudiante tenga la estructura de carpetas correcta y el archivo con el pseudocódigo.

### Pista fortalecimiento — Bloque 3 (45 min)

**Algoritmos avanzados y documentación (45 min)**

1. **(15 min)** Desafío de composición: combinar secuencia, decisión y repetición en un solo algoritmo. Ejemplo: "dado un listado de 5 notas, mostrar las aprobadas y el promedio".
2. **(15 min)** Documentación: escribir un README mínimo en la carpeta `logica/` que explique qué algoritmos se trabajaron y cómo se resolvieron.
3. **(15 min)** Preparación para el próximo encuentro: el docente anuncia que en el E4 arrancamos con C# — variables, tipos, `Console.WriteLine` y `Console.ReadLine`. Todo lo que practicaron estos dos encuentros les va a servir.

### Cierre conjunto (15 min)

Plenaria final: el docente muestra la pantalla del repositorio grupal en GitHub. "Este es su espacio de trabajo para todo el año. Cada TP, cada desafío, cada entrega — todo va a estar acá." Verifica que todos tengan sesión iniciada y puedan ver el repo. Cierra con: "El Encuentro 4 empezamos con C# — variables, tipos y primeros comandos en la consola. Todo lo que practicaron estos dos encuentros les va a servir."

### Errores comunes y trampas

1. **No conectar la lógica con el lenguaje de programación.** Causa: los alumnos piensan que los diagramas de flujo y el pseudocódigo son ejercicios separados del código real. Fix: el docente siempre muestra cómo el mismo algoritmo se traduce a C# en el siguiente encuentro.
2. **No traer el dispositivo con VS Code instalado.** Causa: los alumnos subestiman la importancia de tener el entorno listo desde el primer día. Fix: en el contrato pedagógico se especifica que el entorno debe estar instalado antes del E2.
3. **Perder el hilo entre encuentros.** Causa: al haber 36 encuentros, los alumnos pierden de vista cómo se conectan los contenidos. Fix: los cierres integradores (E16, E33, E36) sirven como puntos de anclaje que explicitan las conexiones entre unidades.
4. **No actualizar el repo grupal.** Causa: los alumnos no entienden que GitHub es su espacio de trabajo y no hacen commit de sus avances. Fix: el docente verifica los commits al final de cada encuentro y refuerza la importancia del versionado.
5. **Confundir el diagnóstico con una evaluación.** Causa: los alumnos se ponen ansiosos al ver una hoja con preguntas. Fix: el docente deja claro desde el inicio que el diagnóstico no se califica y que sirve para conocer el punto de partida del grupo.
6. **Subestimar la importancia del celular.** Causa: los alumnos están acostumbrados a usar el celular como herramienta de consulta constante. Fix: se establece desde el E1 que el celular no está permitido durante los encuentros; la consulta se hace en la terminal o en los materiales proporcionados.

## Criterios de logro

| Condición | Criterio |
|---|---|
| Intensificación | El estudiante navega por el sistema de archivos con comandos básicos (`cd`, `ls`, `mkdir`), dibuja diagramas de flujo simples (secuencia, decisión, repetición), e ingresa a la plataforma GitHub con su cuenta propia. |
| Fortalecimiento | El estudiante ejecuta comandos encadenados de terminal, documenta su aprendizaje en una bitácora personal, y expresa algoritmos de mediana complejidad (búsqueda, validación compuesta) como pseudocódigo estructurado. |
| Ambos grupos | Participa de las plenarias de apertura y cierre, y puede explicar con sus palabras la relación entre un diagrama de flujo, un algoritmo y un programa de computadora. |
