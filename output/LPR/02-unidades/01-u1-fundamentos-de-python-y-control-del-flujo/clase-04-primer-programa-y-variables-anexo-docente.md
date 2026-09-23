# Anexo docente — Encuentro 4: Primer programa y variables

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

**Consigna:** `rectangulo.py` — calcular área y perímetro de un rectángulo con largo=12.5, ancho=8.3.

```python
# Calcula el area y el perimetro de un rectangulo

# Datos fijos del rectangulo
length = 12.5   # largo (float)
width = 8.3     # ancho (float)

# Calculos
area = length * width
perimeter = 2 * length + 2 * width

# Salida
print("Rectangulo")
print(f"Largo: {length}")
print(f"Ancho: {width}")
print(f"Area: {area}")
print(f"Perimetro: {perimeter}")
```

**Salida verificada:**
```
Rectangulo
Largo: 12.5
Ancho: 8.3
Area: 103.75
Perimetro: 41.6
```

**Variante con f-strings (más compacta):**
```python
print(f"Area: {length * width}")
print(f"Perimetro: {2 * (length + width)}")
```

## 2. Solución de la actividad de extensión

### 2.1 División entera (`//`)
```python
# Cuantas veces enteras entra el ancho en el largo
fit_count = length // width
print(f"El ancho entra {fit_count} veces enteras en el largo.")
```
Resultado: `12.5 // 8.3 = 1.0` (la parte entera de la división). En Python 3, `//` con `float` devuelve `float` pero truncado.

### 2.2 Potencia (`**`)
```python
# Area del cuadrado con lado = length
square_area = length ** 2
print(f"Area del cuadrado de lado {length}: {square_area}")
```
Resultado: `12.5 ** 2 = 156.25`.

### 2.3 Mezcla de tipos
```python
count = 10               # int
unit_price = 4.99        # float
total = count * unit_price
print(f"Total: {total}")
print(f"Tipo de total: {type(total)}")
```
Resultado: `total` es `float` porque `int * float` produce `float` (promoción automática).

## 3. Respuesta esperada del ejercicio

### Programa `rectangulo.py`
| Entrada (no aplica: programa sin input) | Salida esperada |
|---|---|
| — | `Rectangulo` / `Largo: 12.5` / `Ancho: 8.3` / `Area: 103.75` / `Perimetro: 41.6` |

### Programa `edad.py` modificado (práctica guiada)
Cada alumno usa su propia edad. Verificar que:
- Nombre esté entre comillas dobles.
- Edad sea `int`.
- `total_weeks = age * weeks_per_year` esté bien calculado.
- Todos los `print()` tengan paréntesis.

## 4. Criterios de corrección (lista de verificación)

| ✔ | Criterio | Puntos sugeridos |
|---|---|---|
| ☐ | El archivo se llama `rectangulo.py` | 0,5 |
| ☐ | Usa variables `length` y `width` en inglés | 1 |
| ☐ | Asigna los valores correctos (12.5 y 8.3) | 0,5 |
| ☐ | Calcula `area` correctamente (`length * width`) | 1 |
| ☐ | Calcula `perimeter` correctamente | 1 |
| ☐ | Usa `print()` con paréntesis | 0,5 |
| ☐ | Muestra todos los valores pedidos | 0,5 |
| ☐ | Incluye al menos un comentario relevante | 0,5 |
| ☐ | El programa corre sin errores | 1 |
| ☐ | **Total** | **6,5** |

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
|---|---|---|
| El programa tira `SyntaxError` por falta de paréntesis en `print` | El alumno usa `print "texto"` como en Python 2 | Señalar que en Python 3 los paréntesis son obligatorios. Mostrar `print("texto")`. |
| Las variables están en español (`largo`, `ancho`) | No leyó o no aplicó la convención de identificadores en inglés | Recordar la regla: los nombres de variable van en inglés. Pedir que los renombre. |
| No aparece la salida del perímetro | Solo copió el código del área sin agregar el del perímetro | Preguntar: "¿cuántos valores pidió el enunciado?" (4: lado, ancho, área, perímetro). |
| Confunde `//` con `/` al interpretar resultados | No comprende la diferencia entre división real y entera | Explicar con un ejemplo en pizarrón: `7 / 2 = 3.5`, `7 // 2 = 3`. |
| El archivo no se ejecuta porque no está guardado | No guardó el archivo antes de ejecutar | Mostrar el indicador de archivo sin guardar (punto/círculo en la pestaña). Recordar `Ctrl+S`. |

## 6. Registro de la clase

| Aspecto | Qué registrar |
|---|---|
| Participación individual | Quiénes preguntaron, quiénes terminaron el ejercicio rápido, quiénes no llegaron a la extensión. |
| Conceptos que costaron | ¿Tuvieron dificultad con `//` y `%`? ¿Confundieron asignación `=` con igualdad `==` (si bien aún no vimos `==`, aparece en las preguntas)? |
| Organización | ¿Trabajaron en VS Code sin problemas? ¿Alguien no pudo ejecutar desde la terminal? |
| Para la evaluación de proceso | Anotar grupos (o individuales) que mostraron autonomía y los que necesitaron ayuda constante. Son insumos para el Encuentro 9 (evaluación individual). |
