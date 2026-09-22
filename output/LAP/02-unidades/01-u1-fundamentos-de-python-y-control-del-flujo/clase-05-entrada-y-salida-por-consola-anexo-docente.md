# Anexo docente — Encuentro 5: Entrada y salida por consola

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

**Consigna:** `promedio.py` — leer 3 notas (float), calcular el promedio y mostrarlo con 2 decimales.

```python
# Calcula el promedio de tres notas

# Lectura de las tres notas (una por una)
note1 = float(input("Ingresa la primera nota: "))
note2 = float(input("Ingresa la segunda nota: "))
note3 = float(input("Ingresa la tercera nota: "))

# Calculo del promedio
average = (note1 + note2 + note3) / 3

# Salida con 2 decimales
print(f"Tu promedio es {average:.2f}")
```

**Salida verificada** (con datos de ejemplo):
```
Ingresa la primera nota: 7.5
Ingresa la segunda nota: 8
Ingresa la tercera nota: 9.25
Tu promedio es 8.25
```

**Casos borde:**
- Notas con un decimal: `6.5, 7.0, 8.5` → promedio `7.33`
- Todas iguales: `10, 10, 10` → promedio `10.00`
- Mínimo: `1, 1, 1` → promedio `1.00`

## 2. Solución de la actividad de extensión

### 2.1 Promedio ponderado
```python
# Promedio ponderado con pesos individuales
n1 = float(input("Nota 1: "))
p1 = float(input("Peso de la nota 1 (%): "))
n2 = float(input("Nota 2: "))
p2 = float(input("Peso de la nota 2 (%): "))
n3 = float(input("Nota 3: "))
p3 = float(input("Peso de la nota 3 (%): "))

weighted_avg = (n1 * p1 + n2 * p2 + n3 * p3) / (p1 + p2 + p3)
print(f"Promedio ponderado: {weighted_avg:.2f}")
```

### 2.2 Redondeo con `round()`
```python
average = (7.5 + 8.0 + 9.25) / 3
print(round(average, 2))     # muestra 8.25
```
Nota docente: `round(8.25, 2)` da `8.25` porque ya tiene 2 decimales exactos. Con `8.333...`, `round(8.333, 2)` da `8.33` (truncamiento banker's rounding, no siempre intuitivo). Preferir f-strings.

### 2.3 Nombre completo
```python
first_name = input("Nombre: ")
last_name = input("Apellido: ")
n1 = float(input("Nota 1: "))
n2 = float(input("Nota 2: "))
n3 = float(input("Nota 3: "))
avg = (n1 + n2 + n3) / 3
print(f"Alumno: {last_name}, {first_name} — Promedio: {avg:.2f}")
```

## 3. Respuesta esperada del ejercicio

### Programa `promedio.py`
| Entrada | Salida esperada |
|---|---|
| `7.5`, `8`, `9.25` | `Tu promedio es 8.25` |
| `10`, `10`, `10` | `Tu promedio es 10.00` |
| `0`, `5.5`, `10` | `Tu promedio es 5.17` |

### Programa `calculadora_edad.py` modificado (práctica guiada)
Verificar que:
- El mes de nacimiento y el mes actual se lean como números enteros.
- La comparación para saber si ya cumplió años es correcta.
- Se usa f-string para mostrar el mensaje final.

## 4. Criterios de corrección (lista de verificación)

| ✔ | Criterio | Puntos sugeridos |
|---|---|---|
| ☐ | El archivo se llama `promedio.py` | 0,5 |
| ☐ | Lee las 3 notas con `input()` | 1 |
| ☐ | Convierte cada nota a `float` | 1 |
| ☐ | Calcula el promedio correctamente | 1 |
| ☐ | Muestra el resultado con 2 decimales (`:.2f`) | 1,5 |
| ☐ | Usa f-strings para la salida | 0,5 |
| ☐ | Incluye al menos un comentario | 0,5 |
| ☐ | El programa corre sin errores | 1 |
| ☐ | **Total** | **7** |

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
|---|---|---|
| `TypeError: can only concatenate str` | Suma strings sin convertir: `"8" + "2" = "82"` vs `8 + 2 = 10` | Mostrar que `input()` devuelve `str`. Hacer `type(input("x: "))` en la terminal para que lo vean. |
| El programa se rompe si escriben texto en vez de número | `ValueError` no manejado. Validación con `try/except` se ve en el E6, pero puede anticiparse | Explicar que por ahora hay que tipear bien; en el próximo encuentro solucionamos eso. |
| Usa `+` para concatenar en vez de f-strings | Viene de otros lenguajes o vio tutoriales viejos | Mostrar la diferencia: `"Hola " + name` vs `f"Hola {name}"`. |
| No muestra los 2 decimales | Usó `print(avg)` sin formato, o usó `round()` pero no notó que `round(7.5, 2)` muestra `7.5` no `7.50` | Enseñar que `:.2f` **siempre** muestra 2 decimales aunque sean cero. |
| Lee todas las notas en una línea separada por espacios y falla | Quiere leer con `split()` sin saberlo aún | Explicar que por ahora se lee una nota por vez, en líneas separadas. |
| No guardó el archivo y ejecuta el anterior | El programa viejo se ejecuta en vez del nuevo | Verificar que el nombre del archivo en la pestaña de VS Code coincida con el que ejecuta. |

## 6. Registro de la clase

| Aspecto | Qué registrar |
|---|---|
| Comprensión de tipos | ¿Entienden que `input()` devuelve `str`? ¿Preguntan por qué falla la suma? Registrar cuántos preguntaron. |
| Errores de conversión | ¿Cuántos alumnos tuvieron `ValueError` por escribir texto? ¿Cuántos se confundieron con `int()` vs `float()`? |
| Organización | Rotación de monitores: ¿las parejas se turnaron o uno tomó el control todo el tiempo? |
| Para la evaluación de proceso | Identificar alumnos que ya usan f-strings sin ayuda vs. los que siguen concatenando con `+`. Es el indicador más temprano de autonomía. |