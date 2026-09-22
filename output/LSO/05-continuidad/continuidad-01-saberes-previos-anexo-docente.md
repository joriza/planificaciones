# Anexo docente — Continuidad pedagógica 01: Saberes previos

## Soluciones

### Actividad 1 — Lógica proposicional y tablas de verdad (20 puntos)

**a) `(p ∧ q) → p`**

| p | q | p ∧ q | (p ∧ q) → p |
|---|---|-------|-------------|
| V | V | V     | V           |
| V | F | F     | V           |
| F | V | F     | V           |
| F | F | F     | V           |

Clasificación: **Tautología** (todas las filas dan verdadero).

**b) `p ∨ (¬p ∧ q)`**

| p | q | ¬p | ¬p ∧ q | p ∨ (¬p ∧ q) |
|---|---|----|--------|--------------|
| V | V | F  | F      | V            |
| V | F | F  | F      | V            |
| F | V | V  | V      | V            |
| F | F | V  | F      | F            |

Clasificación: **Contingencia** (no siempre verdadero ni siempre falso).

**c) `(p → q) ↔ (¬q → ¬p)`**

| p | q | p → q | ¬q | ¬p | ¬q → ¬p | (p → q) ↔ (¬q → ¬p) |
|---|---|-------|----|----|---------|----------------------|
| V | V | V     | F  | F  | V       | V                    |
| V | F | F     | V  | F  | F       | V                    |
| F | V | V     | F  | V  | V       | V                    |
| F | F | V     | V  | V  | V       | V                    |

Clasificación: **Tautología** (contrapositiva de la implicación).

**Criterios de corrección:**
- Cada tabla de verdad completa y correcta: 5 puntos (total 15 puntos).
- Clasificación correcta (tautología/contingencia/contradicción): 5 puntos (total 5 puntos).
- Se descuenta 1 punto por tabla incompleta o error de cálculo.

---

### Actividad 2 — Seguimiento de instrucciones y flujo de control (25 puntos)

**Resolución paso a paso:**

| Paso | Instrucción | x | y | z |
|------|-------------|---|---|---|
| Inicio | — | 10 | 5 | 0 |
| 1 | Si x > y entonces (10 > 5, verdadero) | 10 | 5 | 0 |
| 2 | z ← x + y | 10 | 5 | 15 |
| 3 | x ← z - 3 | 12 | 5 | 15 |
| 4 | y ← z + 2 | 12 | 17 | 15 |
| 5 | z ← x * y | 12 | 17 | 204 |

**Respuestas:**
a) x = 12
b) y = 17
c) z = 204
d) Se ejecutó la rama "entonces" porque x (10) > y (5).

**Criterios de corrección:**
- Valores finales correctos de x, y, z: 15 puntos (5 cada uno).
- Justificación correcta de la rama ejecutada: 5 puntos.
- Tabla de trazado completa y ordenada: 5 puntos.
- Se descuenta 1 punto por cada valor incorrecto.

---

### Actividad 3 — Pseudocódigo: algoritmo de ordenamiento conceptual (20 puntos)

**Solución esperada (ejemplo):**

```
Algoritmo OrdenarTresNumeros
  Leer a, b, c

  // Comparar a y b, intercambiar si a es mayor
  Si a > b entonces
    temp ← a
    a ← b
    b ← temp
  Fin Si

  // Ahora a ≤ b, comparar b y c
  Si b > c entonces
    temp ← b
    b ← c
    c ← temp
  Fin Si

  // Recheckear a y b porque c pudo haberse movido
  Si a > b entonces
    temp ← a
    a ← b
    b ← temp
  Fin Si

  // Al finalizar: a ≤ b ≤ c
  Escribir a, b, c
Fin Algoritmo
```

**Criterios de corrección:**
- Algoritmo correcto que ordena tres valores: 10 puntos.
- Comentarios explicativos en cada paso asignación: 5 puntos.
- Estructura correcta (solo condicionales y asignaciones, sin funciones predefinidas): 5 puntos.
- Se aceptan variantes válidas (por ejemplo, comparación por pares en distinto orden) siempre que el resultado sea correcto.

---

### Actividad 4 — Trazado de variables y cambios de estado (20 puntos)

**Resolución paso a paso:**

| Paso | Instrucción | a | b | c |
|------|-------------|---|---|---|
| Inicio | — | 3 | 7 | — |
| 1 | a ← 3 | 3 | 7 | — |
| 2 | b ← 7 | 3 | 7 | — |
| 3 | c ← a + b | 3 | 7 | 10 |
| 4 | a ← c - a | 7 | 7 | 10 |
| 5 | b ← c - b | 7 | 3 | 10 |
| 6 | c ← a + b | 7 | 3 | 10 |

**Respuesta extra:** El algoritmo intercambia los valores de `a` y `b` usando `c` como variable auxiliar. Al finalizar, `a` tiene el valor original de `b` (7) y `b` tiene el valor original de `a` (3). La suma `a + b` se conserva en `c` (10).

**Criterios de corrección:**
- Tabla de trazado completa y correcta: 10 puntos.
- Valores correctos en cada celda: 5 puntos.
- Explicación correcta de la operación (intercambio): 5 puntos.
- Se descuenta 1 punto por celda incorrecta.

---

### Actividad 5 — Identificación de patrones y secuencias lógicas (15 puntos)

**a) 2, 6, 12, 20, 30, __, __**

- Regla: cada término es `n × (n + 1)` donde n comienza en 1.
  - 1×2=2, 2×3=6, 3×4=12, 4×5=20, 5×6=30, 6×7=42, 7×8=56
- Próximos elementos: **42, 56**
- La secuencia es infinita porque n crece indefinidamente.

**b) 1, 1, 2, 3, 5, 8, __, __**

- Regla: cada término es la suma de los dos anteriores (sucesión de Fibonacci).
  - 1+1=2, 1+2=3, 2+3=5, 3+5=8, 5+8=13, 8+13=21
- Próximos elementos: **13, 21**
- La secuencia es infinita porque no hay un límite superior definido.

**c) A, C, F, J, __, __**

- Regla: las posiciones en el alfabeto avanzan con saltos crecientes de +2, +3, +4, +5, +6...
  - A(1), C(3), F(6), J(10), O(15), U(21)
  - Saltos: +2, +3, +4, +5, +6
- Próximos elementos: **O, U**
- La secuencia es infinita porque el alfabeto se puede recorrer cíclicamente o los saltos siguen creciendo.

**Criterios de corrección:**
- Regla correcta identificada para cada secuencia: 6 puntos (2 cada una).
- Próximos elementos correctos: 6 puntos (2 cada una).
- Clasificación correcta de finita/infinita con justificación: 3 puntos.

---

## Criterios de corrección generales

| Criterio | Ponderación |
|----------|-------------|
| Soluciones correctas y completas | 70% |
| Presentación ordenada y legible | 15% |
| Justificaciones y explicaciones coherentes | 15% |

La presentación es individual y manuscrita. Se valorará la claridad del trazado y la organización del pseudocódigo. Los puntos extra de la Actividad 4 se suman al total sin exceder el máximo de 100.
