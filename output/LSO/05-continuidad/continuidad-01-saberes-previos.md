# Continuidad pedagógica 01 — Saberes previos

## Datos de referencia

| Campo | Valor |
|-------|-------|
| Curso | Minimal API con C# .NET 6 |
| Momento de uso | Inicio del curso (antes del encuentro 1) |
| Duración teórica | 240 minutos (4 horas reloj) |
| Requisitos | Lápiz, papel, cuaderno. No se requiere computadora. |

## Objetivos de aprendizaje

1. Revisar y consolidar los conocimientos de lógica proposicional y tablas de verdad como base para el razonamiento algorítmico.
2. Practicar el seguimiento de instrucciones y la trazabilidad de variables en secuencias de pasos.
3. Desarrollar capacidad de abstracción mediante la escritura de pseudocódigo para algoritmos conceptuales.
4. Identificar patrones y secuencias lógicas como base para el pensamiento computacional.

## Actividades puntuadas (sobre 100)

### Actividad 1 — Lógica proposicional y tablas de verdad (20 puntos / 45 minutos)

**Consigna:** Construí la tabla de verdad completa para cada una de las siguientes expresiones lógicas. Luego indicá si cada una es tautología, contradicción o contingencia.

a) `(p ∧ q) → p`
b) `p ∨ (¬p ∧ q)`
c) `(p → q) ↔ (¬q → ¬p)`

**Pistas:** Recordá que una implicación `p → q` es falsa únicamente cuando `p` es verdadero y `q` es falso. La bicondicional `p ↔ q` es verdadera cuando ambos operandos tienen el mismo valor de verdad.

**Puntos:** 20

---

### Actividad 2 — Seguimiento de instrucciones y flujo de control (25 puntos / 50 minutos)

**Consigna:** Tenés el siguiente conjunto de instrucciones. Indicá el valor final de cada variable al terminar la ejecución.

```
Inicio
  x ← 10
  y ← 5
  z ← 0

  Si x > y entonces
    z ← x + y
  Sino
    z ← x - y
  Fin Si

  x ← z - 3
  y ← z + 2
  z ← x * y

Fin
```

**Preguntas:**
a) ¿Cuál es el valor final de `x`?
b) ¿Cuál es el valor final de `y`?
c) ¿Cuál es el valor final de `z`?
d) ¿Qué rama del si se ejecutó? Justificá.

**Puntos:** 25

---

### Actividad 3 — Pseudocódigo: algoritmo de ordenamiento conceptual (20 puntos / 50 minutos)

**Consigna:** Escribí un algoritmo en pseudocódigo que reciba tres números enteros y los ordene de menor a mayor. Usá solo estructuras de control vistas en clase (condicionales y asignaciones). No se permite usar funciones de ordenamiento predefinidas.

**Requisitos:**
- El algoritmo debe recibir tres variables: `a`, `b`, `c`.
- Al finalizar, las tres variables deben estar ordenadas: `a ≤ b ≤ c`.
- Incluí comentarios en cada paso que expliquen qué hace esa asignación.

**Puntos:** 20

---

### Actividad 4 — Trazado de variables y cambios de estado (20 puntos / 50 minutos)

**Consigna:** Considerá el siguiente bloque de instrucciones. Completá la tabla de trazado con el valor de cada variable en cada paso.

```
Inicio
  a ← 3
  b ← 7
  c ← a + b
  a ← c - a
  b ← c - b
  c ← a + b
Fin
```

**Tabla de trazado:**

| Paso | a | b | c |
|------|---|---|---|
| Inicio | — | — | — |
| 1: a ← 3 | | | |
| 2: b ← 7 | | | |
| 3: c ← a + b | | | |
| 4: a ← c - a | | | |
| 5: b ← c - b | | | |
| 6: c ← a + b | | | |

**Pregunta extra (5 puntos adicionales):** ¿Qué operación matemática realiza este algoritmo sobre los valores iniciales de `a` y `b`? Explicá brevemente.

**Puntos:** 20 (incluye 5 puntos extra)

---

### Actividad 5 — Identificación de patrones y secuencias lógicas (15 puntos / 45 minutos)

**Consigna:** Observá las siguientes secuencias. Identificá el patrón, escribí los dos próximos elementos y explicá la regla que genera la secuencia.

a) 2, 6, 12, 20, 30, __, __
b) 1, 1, 2, 3, 5, 8, __, __
c) A, C, F, J, __, __

**Para cada secuencia indicá:**
- La regla de generación (en palabras).
- Los dos próximos elementos.
- Si la secuencia es finita o infinita y por qué.

**Puntos:** 15

---

## Autoevaluación para el alumno

Antes de la próxima clase, respondé con honestidad las siguientes preguntas. No hay puntos en juego; es una herramienta para que identifiques qué repasar.

- ¿Puedo construir una tabla de verdad completa para una expresión con dos o tres conectivos lógicos?
- ¿Soy capaz de seguir un algoritmo paso a paso y registrar el valor de cada variable en cada iteración?
- ¿Puedo escribir pseudocódigo que use condicionales y asignaciones para resolver un problema simple?
- ¿Identifico patrones en secuencias numéricas y alfabéticas y puedo formular la regla que las genera?
- ¿Me siento seguro/a para comenzar el curso con estos conocimientos previos?

Si respondiste "no" a alguna de estas preguntas, repasá la actividad correspondiente antes del próximo encuentro.

## Nota de registro académico

la resolución se realiza en forma habitual (por lo general, en grupo); la presentación es individual y manuscrita, al inicio de la próxima clase, y constituye una actividad más de la asignatura que forma parte del proceso de evaluación.
