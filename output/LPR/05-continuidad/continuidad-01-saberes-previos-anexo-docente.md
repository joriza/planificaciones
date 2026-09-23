# Anexo docente — Continuidad pedagógica 01: Saberes previos

> Documento docente formal. No se entrega a los alumnos: contiene las soluciones completas de cada actividad, los criterios de corrección, los errores previstos y su intervención.

## 1. Soluciones de las actividades

### Actividad 1 — Algoritmo en otro lenguaje (papel, 20 pts)

**Consigna:** Recordar un programa escrito en otro lenguaje y escribirlo en pseudocódigo, o escribir el algoritmo para calcular el promedio de tres notas en lenguaje natural.

**Solución esperada (ejemplo completo — promedio de tres notas):**

```
INICIO
1. Pedir al usuario que ingrese la primera nota
2. Leer la primera nota y guardarla en una variable
3. Pedir al usuario que ingrese la segunda nota
4. Leer la segunda nota y guardarla en una variable
5. Pedir al usuario que ingrese la tercera nota
6. Leer la tercera nota y guardarla en una variable
7. Calcular el promedio: (nota1 + nota2 + nota3) / 3
8. Mostrar el promedio en pantalla
9. Si el promedio es mayor o igual a 6, mostrar "Aprobado"
10. Si no, mostrar "Desaprobado"
FIN
```

**Criterios de corrección:**
- **Estructura completa (8 pts):** tiene inicio, entrada, procesamiento, salida y fin claramente identificados.
- **Pasos ordenados (6 pts):** la secuencia es lógica y no salta etapas.
- **Identificación de entrada y salida (3 pts):** distingue qué se lee y qué se muestra.
- **Toma de decisiones (3 pts):** incluye al menos una condición (aprobado/desaprobado).

**Errores frecuentes:**
- Confunden algoritmo con código de un lenguaje específico sin generalizar.
- Omiten la entrada de datos (asumen que las notas ya están definidas).
- No incluyen la toma de decisiones (solo calculan el promedio sin evaluarlo).
- **Intervención docente:** "Un algoritmo debe ser lo suficientemente general como para funcionar con cualquier conjunto de notas, no solo con un ejemplo. ¿Qué pasaría si el usuario ingresa un valor negativo?"

---

### Actividad 2 — Lógica booleana (papel, 20 pts)

**Solución esperada:**

| A | B | C | A and B | A or B | not A | (A and B) or (not C) |
|---|---|---|---------|--------|-------|----------------------|
| V | V | V | V | V | F | V |
| V | V | F | V | V | F | V |
| V | F | V | F | V | F | F |
| V | F | F | F | V | F | V |
| F | V | V | F | V | V | V |
| F | V | F | F | V | V | V |
| F | F | V | F | F | V | V |
| F | F | F | F | F | V | V |

Para A=Verdadero, B=Falso, C=Verdadero:
- `A and B` = Falso
- `A or B` = Verdadero
- `not A` = Falso
- `(A and B) or (not C)` = Falso or Falso = Falso

**Criterios de corrección:**
- **Tabla de verdad completa y correcta (12 pts, 3 pts c/u):** cada operación booleana evaluada correctamente en las 8 filas.
- **Evaluación con valores específicos (4 pts, 1 pt c/u):** cada resultado individual correcto.
- **Explicación de la regla (4 pts):** menciona que `and` requiere ambos verdaderos, `or` al menos uno verdadero, `not` invierte.

**Errores frecuentes:**
- Confunden `and` con `or` (creen que `V and F` es V).
- Piensan que `not` convierte Verdadero en Falso pero no entienden que es una inversión total.
- En la expresión compuesta, evalúan de izquierda a derecha sin respetar los paréntesis.
- **Intervención docente:** "Pensalo como interruptores: `and` necesita que ambos estén encendidos, `or` basta con que uno lo esté, y `not` apaga lo que está encendido y enciende lo que está apagado."

---

### Actividad 3 — Comandos de terminal (papel, 15 pts)

**Solución esperada:**

| Situación | Comando |
|-----------|---------|
| (a) Listar archivos en la carpeta actual | `ls` (Linux/Mac) o `dir` (Windows) |
| (b) Crear una carpeta `proyectos` | `mkdir proyectos` |
| (c) Cambiar a la carpeta `proyectos` | `cd proyectos` |
| (d) Volver a la carpeta padre | `cd ..` |
| (e) Verificar la ubicación actual | `pwd` (Linux/Mac) o `cd` (Windows) |

**Criterios de corrección:**
- **Cada comando correcto (3 pts c/u, 15 pts total):** comando adecuado para cada situación.

**Errores frecuentes:**
- Confunden `cd` con `ls` (usan `cd` para listar en lugar de para navegar).
- Escriben `mkdir` con mayúsculas o con espacios mal colocados.
- No conocen `cd ..` para subir un nivel.
- **Intervención docente:** "La terminal no tiene botón de retroceso. `cd ..` es tu forma de volver atrás. `pwd` te dice dónde estás, como una señal de calle."

---

### Actividad 4 — Tarea en computadora: primer contacto con Python (computadora, 25 pts)

**Solución completa (`saludo.py`):**

```python
# saludo.py
# Programa que saluda al usuario por nombre y muestra su edad

nombre = "Valeria"
edad = 16

print(f"Hola, {nombre}. Tenés {edad} años.")
```

**Salida esperada:**
```
Hola, Valeria. Tenés 16 años.
```

**Criterios de corrección:**
- **Variable `nombre` con string (5 pts):** valor asignado correctamente, entre comillas.
- **Variable `edad` con int (5 pts):** valor numérico sin comillas.
- **`print()` con f-string (10 pts):** usa `f"..."` con las variables interpoladas correctamente.
- **Comentario explicativo (5 pts):** al menos un comentario que explique la acción del programa.

**Errores frecuentes:**
- Usan comillas simples dentro del f-string cuando el texto contiene apóstrofes.
- Ponen `edad = "16"` (string en lugar de int).
- No usan f-string y concatenan con `+` (lo cual genera error si mezclan str e int).
- **Intervención docente:** "Si `edad` es un número, no lo pongas entre comillas. Las comillas lo convierten en texto y Python no puede sumar texto con números."

---

### Actividad 5 — Tarea en computadora: operaciones básicas (computadora, 20 pts)

**Solución completa (`calculadora.py`):**

```python
# calculadora.py
# Programa que realiza operaciones aritméticas básicas con dos valores

a = 15
b = 4

# Suma de ambos valores
print(f"Suma: {a + b}")

# Resta de ambos valores
print(f"Resta: {a - b}")

# Producto de ambos valores
print(f"Producto: {a * b}")

# Division real (siempre devuelve float)
print(f"Division: {a / b}")

# Division entera (descarta el resto)
print(f"Division entera: {a // b}")
```

**Salida esperada:**
```
Suma: 19
Resta: 11
Producto: 60
Division: 3.75
Division entera: 3
```

**Criterios de corrección:**
- **Variables `a` y `b` correctas (4 pts):** valores 15 y 4 asignados.
- **Suma y resta (4 pts c/u):** operaciones y salida correctas.
- **Producto (4 pts):** operación correcta.
- **División real (4 pts):** usa `/` y muestra `3.75`.
- **División entera (4 pts):** usa `//` y muestra `3`.
- **Comentarios (4 pts):** al menos un comentario que explique cada operación.

**Errores frecuentes:**
- Usan `/` para la división entera (obtienen `3.75` en lugar de `3`).
- Confunden `*` con `+` en el producto.
- No separan cada `print()` en su propia línea.
- **Intervención docente:** "En Python, `/` siempre hace división real y devuelve un `float`. Si querés división entera, usá `//`. Esto es diferente de otros lenguajes donde `/` entre enteros da un entero."

---

## 2. Criterios de logro generales

| Condición | Criterio |
|---|---|
| Logrado (≥70 pts) | El estudiante transfiere conocimientos de otros lenguajes a pseudocódigo, maneja la lógica booleana básica, opera la terminal con soltura y escribe su primer programa Python con variables, `print()` y comentarios. |
| En proceso (40–69 pts) | Reconoce los conceptos pero comete errores en la tabla de verdad, confunde comandos de terminal o tiene dificultades con la sintaxis básica de Python (tipos, f-strings). |
| Requiere apoyo (<40 pts) | No logra estructurar un algoritmo, no distingue operaciones lógicas básicas o no puede operar la terminal. Se sugiere intensificación específica antes del inicio de la Unidad 1. |

## 3. Nota para el docente

Esta actividad se aplica **antes del inicio de la Unidad 1** (encuentros 2-3 o en una clase previa). Su función es reactivar saberes previos de programación y detectar estudiantes que requieran intensificación en conceptos pre-Python. No reemplaza el diagnóstico inicial sino que lo complementa como herramienta de nivelación. Los resultados pueden usarse para conformar los grupos de intensificación/fortalecimiento de los primeros encuentros.
