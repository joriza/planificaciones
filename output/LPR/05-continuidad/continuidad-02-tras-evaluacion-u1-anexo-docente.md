# Anexo docente — Continuidad pedagógica 02: Tras la evaluación de la Unidad 1

> Documento docente formal. No se entrega a los alumnos: contiene las soluciones completas de cada actividad, los criterios de corrección, los errores previstos y su intervención.

## 1. Soluciones de las actividades

### Actividad 1 — Completar código: declaración y tipos (papel, 15 pts)

**Código incompleto entregado al alumno:**

```python
# Programa: info_estudiante
# Completar las variables faltantes y las conversiones

nombre = input("Ingrese su nombre: ")
# edad: debe ser entero
edad = _____(input("Ingrese su edad: "))
# altura: debe ser float
altura = float(input("Ingrese su altura en metros: "))
# es_estudiante: debe ser bool
es_estudiante = _____
# materia: debe ser str
materia = "Programación en Python"
# cantidad de materias aprobadas
materias_aprobadas = _____
```

**Solución esperada (lo que completa el alumno):**

```python
edad = int(input("Ingrese su edad: "))
es_estudiante = True       # o False
materias_aprobadas = 3     # o cualquier entero
```

Además, el alumno debe indicar que:
- `nombre` y `materia` ya son `str` (no necesitan conversión).
- `es_estudiante` se asigna directamente como `True` o `False` (no viene de `input()`).
- `materias_aprobadas` es un `int` literal.

**Criterios de corrección:**
- **Conversión de edad (5 pts):** usa `int()` alrededor de `input()`.
- **Tipo bool (5 pts):** asigna `True` o `False` literal, no entre comillas.
- **Tipo int para materias_aprobadas (5 pts):** asigna un número entero, no un string.

**Errores frecuentes:**
- Escriben `edad = int(input(...))` pero ponen `edad = input(int(...))` al revés.
- Ponen `es_estudiante = "True"` (string en lugar de bool).
- No reconocen que `materias_aprobadas` ya tiene el tipo implícito por el valor.
- **Intervención docente:** "La función `int()` convierte lo que está adentro a entero. `int(input(...))` primero pide el dato, después lo convierte."

---

### Actividad 2 — Predicción de salida: condicionales (papel, 15 pts)

**Fragmento 1:**

```python
edad = 17
if edad >= 18:
    print("Mayor de edad")
else:
    print("Menor de edad")
print("Fin del programa")
```

**Salida esperada:**
```
Menor de edad
Fin del programa
```

**Fragmento 2:**

```python
nota = 7
if nota >= 8:
    print("Muy bueno")
elif nota >= 6:
    print("Bueno")
elif nota >= 4:
    print("Regular")
else:
    print("Desaprobado")
```

**Salida esperada:**
```
Bueno
```

**Fragmento 3 (con operador lógico):**

```python
temperatura = 30
llueve = False
if temperatura > 25 and not llueve:
    print("Ir a la pileta")
else:
    print("Quedarse en casa")
```

**Salida esperada:**
```
Ir a la pileta
```

**Criterios de corrección:**
- **Fragmento 1 (5 pts):** escribe exactamente ambas líneas en orden.
- **Fragmento 2 (5 pts):** identifica que `7` entra en `elif nota >= 6` y NO también en los siguientes.
- **Fragmento 3 (5 pts):** evalúa la condición compuesta correctamente.

**Errores frecuentes:**
- En Fragmento 2, creen que imprime "Regular" porque 7 ≥ 4 (no entienden que `elif` se salta los siguientes si ya entró en uno).
- En Fragmento 3, malinterpretan `not llueve` (bool negado).
- **Intervención docente:** "`elif` significa 'si no se cumplió el de arriba, probá este'. Si ya entró en uno, no mira los siguientes."

---

### Actividad 3 — Completar bucle: contadores y acumuladores (papel, 20 pts)

**Código incompleto entregado al alumno:**

```python
# Programa: sumar_pares
# Completar el acumulador y el contador

suma = 0
cantidad = 0
for i in range(1, 11):
    if i % 2 == 0:
        _____  # acumular i en suma
        _____  # contar este par

print(f"Suma de pares: {suma}")
print(f"Cantidad de pares: {cantidad}")
```

**Solución esperada (líneas a completar):**

```python
        suma = suma + i    # equivalente: suma += i
        cantidad = cantidad + 1  # equivalente: cantidad += 1
```

**Salida que debe mostrar el `print()` final:**
```
Suma de pares: 30
Cantidad de pares: 5
```

Explicación: los pares entre 1 y 10 son 2, 4, 6, 8, 10. Suma = 30, cantidad = 5.

**Criterios de corrección:**
- **Acumulador correcto (10 pts):** `suma = suma + i` (o `suma += i`).
- **Contador correcto (5 pts):** `cantidad = cantidad + 1` (o `cantidad += 1`).
- **Valor final indicado (5 pts):** suma=30, cantidad=5.

**Errores frecuentes:**
- Confunden contador con acumulador: ponen `suma = suma + 1` (cuenta pero no suma el valor).
- Inicializan dentro del bucle (reinician en cada iteración).
- No entienden que `range(1, 11)` llega hasta 10 inclusive.
- **Intervención docente:** "El acumulador guarda una suma que crece con cada valor; el contador suma siempre 1 para llevar la cuenta."

---

### Actividad 4 — Hallar el error (papel, 15 pts)

**Fragmento 1:**

```python
numero = input("Ingrese un numero: ")
if numero > 10:
    print("Es mayor que 10")
```

**Error:** `input()` devuelve un `str`, no se puede comparar con `>` contra un `int`.
**Corrección:** `numero = int(input("Ingrese un numero: "))`

**Fragmento 2:**

```python
for i in range(5)
    print(i * 2)
```

**Error:** falta el `:` al final de la línea del `for`.
**Corrección:** `for i in range(5):`

**Fragmento 3 (dos errores):**

```python
total = 0
while total <= 100:
    print("Todavia no llega")
    total = total + 0.5
print("Llego")   # este print esta fuera del bucle
```

**Error 1:** indentación inconsistente (el último `print` está fuera del `while`, puede ser intencional).
**Error 2 (principal):** el bucle puede no terminar nunca porque `total` arranca en 0 y suma 0.5 cada vez… pero sí termina (0.5×200 = 100). El error real es que **no hay garantía de que llegue exactamente a 100** debido a errores de redondeo de punto flotante. Alternativa: `total <= 100 - 0.001` o usar `while total < 100:`.

**Para la corrección en clase:** se acepta como error que `while total <= 100` con flotantes puede tener problemas de precisión. O bien que el último `print` queda fuera del bucle y solo se ejecuta al final, que es correcto (no es error). El error más evidente: la condición `<= 100` hace una iteración extra porque cuando `total` es 100, la condición es True y suma 0.5 más (100.5). Mejor usar `< 100`.

**Criterios de corrección:**
- **Fragmento 1 (5 pts):** identifica que falta `int()`.
- **Fragmento 2 (5 pts):** identifica que falta `:`.
- **Fragmento 3 (5 pts):** identifica al menos un error (condición o redondeo).

**Errores frecuentes:** solo encuentran errores sintácticos pero no lógicos.
- **Intervención docente:** "Hay dos tipos de errores: los que Python te avisa (sintácticos) y los que no te avisa pero el programa hace otra cosa (lógicos)."

---

### Actividad 5 — Tarea de programación: `validador_notas.py` (computadora, 35 pts)

**Solución completa:**

```python
# validador_notas.py
# Pide 5 notas, valida que esten entre 1 y 10, calcula promedio y determina si aprueba

ACUMULADOR_DE_NOTAS = 0
CONTADOR_DE_NOTAS = 0

while CONTADOR_DE_NOTAS < 5:
    nota = float(input(f"Ingrese la nota {CONTADOR_DE_NOTAS + 1}: "))

    if nota >= 1 and nota <= 10:
        ACUMULADOR_DE_NOTAS = ACUMULADOR_DE_NOTAS + nota
        CONTADOR_DE_NOTAS = CONTADOR_DE_NOTAS + 1
    else:
        print("Error: la nota debe estar entre 1 y 10. Intente de nuevo.")

promedio = ACUMULADOR_DE_NOTAS / 5

print(f"\nPromedio: {promedio:.2f}")

if promedio >= 6:
    print("APROBADO")
else:
    print("DESAPROBADO")
```

**Salida de prueba:**
```
Ingrese la nota 1: 8
Ingrese la nota 2: 5
Ingrese la nota 3: 12
Error: la nota debe estar entre 1 y 10. Intente de nuevo.
Ingrese la nota 3: 7
Ingrese la nota 4: 4
Ingrese la nota 5: 9

Promedio: 6.60
APROBADO
```

**Criterios de corrección (35 pts):**
| Aspecto | Pts | Qué se evalúa |
|---------|-----|---------------|
| Bucle `while` con contador | 5 | Usa `while` con una variable contador que llega a 5 |
| Acumulador de notas | 5 | Suma cada nota válida en una variable acumuladora |
| Validación con condicional | 5 | `if nota >= 1 and nota <= 10` (o equivalente) |
| Reintento en inválido | 5 | Si la nota es inválida, no la cuenta y vuelve a pedir |
| Cálculo de promedio | 5 | Divide el acumulador por 5 (o por el contador) |
| Mensaje APROBADO/DESAPROBADO | 5 | Condicional con promedio ≥ 6 |
| Comentarios y nombres claros | 5 | Identificadores en inglés snake_case, comentarios en español |

**Errores frecuentes y soluciones:**
| Error | Solución sugerida |
|-------|-------------------|
| Usan `for` en lugar de `while` y no pueden reintentar | Explicar que `for` itera sobre una secuencia fija; `while` permite flexibilidad |
| Piden las 5 notas sin validar cada una | "¿Qué pasa si el usuario ingresa -3 en la nota 2?" |
| Calculan promedio fuera del bucle pero usan el contador como divisor | "Si una nota es inválida, tu contador no avanzó. Dividí por 5 fijo porque son siempre 5 notas." |
| No convierten a `float` | "Si no convertís, `input()` te devuelve texto y la suma concatena." |
| Condición invertida (`not nota >= 1 and nota <= 10`) sin paréntesis | Repasar prioridad de operadores lógicos |

**Verificación de ejecución:**

```bash
python validador_notas.py
```

El programa debe compilar y ejecutarse sin errores. No usa persistencia (no lee ni escribe archivos).

---

## 2. Criterios de logro generales

| Condición | Criterio |
|---|---|
| Logrado (≥70 pts) | Escribe código con tipos correctos, predice la salida de condicionales y bucles, usa contadores/acumuladores, y produce un programa que valida y calcula correctamente. |
| En proceso (40–69 pts) | Comprende los conceptos pero tiene errores de sintaxis, lógica de condiciones encadenadas o mal uso de contador/acumulador. |
| Requiere apoyo (<40 pts) | Presenta dificultades en más de dos temas (tipos, condicionales, bucles). Se recomienda intensificación focalizada antes de la Unidad 2. |

## 3. Nota para el docente

Esta actividad se aplica **tras la evaluación de la Unidad 1** (encuentro 9). Su objetivo es detectar brechas antes de avanzar a estructuras de datos y funciones. Prestar atención especial a:
- Uso de `int()`/`float()` en `input()` (error muy frecuente que persiste).
- Comprensión de `elif` como cadena excluyente.
- Diferencia entre contador y acumulador en bucles.
- Validación de entrada como concepto previo a `try`/`except` (U3).
