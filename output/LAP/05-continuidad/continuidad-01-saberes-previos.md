# Continuidad pedagógica 1 — Saberes previos

> Documento de continuidad pedagógica: actividades de repaso y fijación para desarrollar en una clase sin presencia docente. Se entrega a la administración para los casos de ausencia del docente. No requiere ningún contenido previo de la materia: se trabaja sobre los saberes de programación que el grupo trae.

## Datos de referencia

| Campo | Valor |
| --- | --- |
| Curso | Programación en Python |
| Momento de uso | Inicio del curso, antes del desarrollo de la Unidad 1 (Encuentros 2 y 3) |
| Duración teórica | 120 minutos |
| Modalidad de trabajo | Resolución en grupo, según la organización habitual de la asignatura; presentación individual y manuscrita |
| Requisitos | Lápiz y papel para todas las actividades; computadora del laboratorio solo si el grupo dispone de un lenguaje que ya conoce instalado |

## Objetivos

- Relevar los saberes de programación con los que ingresa cada integrante del grupo.
- Interpretar un algoritmo en pseudocódigo y predecir su salida sin ejecutarlo.
- Resolver un problema sencillo con variables, decisiones y repetición.
- Pasar del enunciado de un problema a su algoritmo, y del algoritmo a un programa o a una prueba de escritorio.
- Dejar registradas las fortalezas y las necesidades del grupo para el inicio de la materia.

## Actividades puntuadas (100 puntos · 120 minutos)

| Nº | Actividad | Tiempo | Puntaje |
| --- | --- | --- | --- |
| 1 | Inventario de saberes del grupo | 10 min | 10 puntos |
| 2 | Lectura de pseudocódigo | 25 min | 25 puntos |
| 3 | Del enunciado al algoritmo | 30 min | 30 puntos |
| 4 | Del algoritmo al programa | 35 min | 25 puntos |
| 5 | Cierre: balance del grupo | 20 min | 10 puntos |
| | **Totales** | **120 min** | **100 puntos** |

En cada actividad, la presentación individual manuscrita consiste en transcribir a mano el resultado indicado más una observación propia del integrante.

### Actividad 1 — Inventario de saberes del grupo (10 min · 10 puntos)

Cada integrante anota en su hoja: qué lenguaje de programación conoce, si ya usó variables, decisiones (`SI ... ENTONCES`) y repeticiones (`MIENTRAS`, `PARA`), y un programa que recuerde haber escrito. El grupo reúne las respuestas en una tabla común con una fila por integrante: integrante, lenguaje, variables (sí/no), decisiones (sí/no), repeticiones (sí/no), programa recordado.

Presentación manuscrita: la fila propia del inventario.

### Actividad 2 — Lectura de pseudocódigo (25 min · 25 puntos)

Sin ejecutar nada, leer los dos algoritmos y anotar la salida completa que produciría cada uno, paso a paso.

**Algoritmo A:**

```text
LEER nota1, nota2, nota3
suma = nota1 + nota2 + nota3
promedio = suma / 3
SI promedio >= 8 ENTONCES
    ESCRIBIR "Promociona"
SINO
    ESCRIBIR "No promociona"
FIN SI
```

**Algoritmo B:**

```text
contador = 3
MIENTRAS contador > 0 HACER
    ESCRIBIR contador
    contador = contador - 1
FIN MIENTRAS
ESCRIBIR "Despegue"
```

El grupo debe ponerse de acuerdo en cada salida antes de pasar a la actividad siguiente.

Presentación manuscrita: las dos salidas previstas y una línea que explique el paso decisivo de cada algoritmo.

### Actividad 3 — Del enunciado al algoritmo (30 min · 30 puntos)

**Enunciado:** calcular el promedio de las tres notas de un estudiante y decidir si promociona (promedio de 8 o más) o no. Si una nota no está entre 0 y 10, debe volver a pedirse.

Escribir en papel el algoritmo en pseudocódigo (o en diagrama de flujo), identificando: las entradas, el proceso, la salida y la validación con repetición para el rango de notas.

Presentación manuscrita: la versión final del algoritmo del grupo, copiada a mano, más una mejora o duda propia del integrante.

### Actividad 4 — Del algoritmo al programa (35 min · 25 puntos)

Dos caminos posibles, según los recursos disponibles:

- **Con computadora:** si el laboratorio tiene instalado un lenguaje que el grupo conoce, escribir el programa de la Actividad 3 en ese lenguaje, ejecutarlo con tres casos (7-8-9, un caso con una nota inválida en el medio y 10-10-9) y comparar cada resultado con lo previsto.
- **Sin computadora:** realizar la prueba de escritorio completa del algoritmo en una tabla (paso, variable, valor) con los mismos tres casos.

Presentación manuscrita: la corrida o la prueba de escritorio del caso con la nota inválida.

### Actividad 5 — Cierre: balance del grupo (20 min · 10 puntos)

Redactar en grupo un párrafo de 5 a 8 líneas que responda: ¿qué sabe hacer el grupo?, ¿qué le falta para programar en Python?, ¿qué le pediría mañana a la materia?

Presentación manuscrita: el párrafo del balance.

## Autoevaluación

Marcar con una cruz lo que se pueda afirmar al terminar la clase:

- [ ] Pude describir qué saberes de programación trae cada integrante del grupo.
- [ ] Predije las salidas de los dos algoritmos antes de comparar con el grupo.
- [ ] Puedo explicar por qué el algoritmo B escribe 3, 2, 1 y recién después «Despegue».
- [ ] El algoritmo de la Actividad 3 repite la lectura mientras la nota esté fuera del rango 0 a 10.
- [ ] La corrida o prueba de escritorio coincidió con lo que el algoritmo preveía (y si no, encontré por qué).
- [ ] Quedó escrito el balance del grupo con una necesidad concreta para la materia.

## Nota académica

La resolución de las actividades se realiza en la forma habitual de la asignatura, por lo general en grupo. Las tareas de programación requieren el uso de la computadora. La presentación es individual y manuscrita, al inicio de la próxima clase, y constituye una actividad más de la asignatura que forma parte del proceso de evaluación.
