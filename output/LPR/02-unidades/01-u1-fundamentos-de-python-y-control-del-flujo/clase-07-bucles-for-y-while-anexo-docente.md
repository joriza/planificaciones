# Anexo docente — Encuentro 7: Bucles for y while

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

**Consigna:** `adivina.py` — juego de adivinar un número secreto con pistas y contador de intentos.

```python
# Juego: adivina el numero secreto

# Numero secreto fijo
secret = 7
attempts = 0

print("Adivina el numero secreto (esta entre 1 y 10).")

while True:
    try:
        guess = int(input("Tu numero: "))
        attempts = attempts + 1

        if guess == secret:
            print(f"Felicitaciones! Adivinaste en {attempts} intento(s).")
            break
        elif guess < secret:
            print("Mas alto.")
        else:
            print("Mas bajo.")
    except ValueError:
        print("Eso no es un numero; intenta de nuevo.")
```

**Salida verificada:**

| Entrada | Salida |
|---|---|
| `5` | `Mas alto.` |
| `8` | `Mas bajo.` |
| `7` | `Felicitaciones! Adivinaste en 3 intento(s).` |
| `tres` | `Eso no es un numero; intenta de nuevo.` (el contador NO aumenta en este caso) |

**Nota docente sobre el contador:** el `attempts = attempts + 1` está **después** de la validación `try/except`, dentro del bloque `try`. Si `int()` falla, la línea del contador nunca se ejecuta, y el contador no aumenta. Eso es correcto porque un intento inválido no cuenta. Si algún alumno pone el contador antes de la validación (afuera del `try`), sugerirle que lo mueva adentro; no es grave pero es más preciso.

## 2. Solución de la actividad de extensión

### 2.1 Rango variable con número secreto en la mitad
```python
# El numero secreto es la mitad del rango
low_limit = int(input("Limite inferior: "))
high_limit = int(input("Limite superior: "))
secret = (low_limit + high_limit) // 2
attempts = 0

print(f"Adivina el numero secreto (entre {low_limit} y {high_limit}).")

while True:
    try:
        guess = int(input("Tu numero: "))
        attempts = attempts + 1
        if guess == secret:
            print(f"Bien! Era {secret}. Usaste {attempts} intento(s).")
            break
        elif guess < secret:
            print("Mas alto.")
        else:
            print("Mas bajo.")
    except ValueError:
        print("Numero invalido.")
```

### 2.2 Contar vocales
```python
# Cuenta vocales en una palabra
word = input("Ingresa una palabra: ")
vowel_count = 0

for letter in word:
    if letter == "a" or letter == "e" or letter == "i" or letter == "o" or letter == "u":
        vowel_count = vowel_count + 1

print(f"La palabra '{word}' tiene {vowel_count} vocal(es).")
```

**Variante mejorada** (para alumnos que preguntan por mayúsculas):
```python
word = input("Ingresa una palabra: ").lower()
```

### 2.3 Tabla de multiplicar
```python
# Tabla de multiplicar del 1 al 10
num = int(input("Que tabla queres ver? "))

for i in range(1, 11):
    result = num * i
    print(f"{num} x {i} = {result}")
```

**Salida verificada** (entrada 5):
```
5 x 1 = 5
5 x 2 = 10
5 x 3 = 15
5 x 4 = 20
5 x 5 = 25
5 x 6 = 30
5 x 7 = 35
5 x 8 = 40
5 x 9 = 45
5 x 10 = 50
```

## 3. Respuesta esperada del ejercicio

### Programa `adivina.py`
| Aspecto | Esperado |
|---|---|
| Número secreto | Variable al inicio: `secret = 7` o cualquier entero fijo |
| Bucle principal | `while True` con `break` al acertar |
| Contador | `attempts = attempts + 1` dentro del `try`, después de leer |
| Pistas | `if guess < secret` → "Más alto"; `else` (si no es menor y no es igual) → "Más bajo" |
| Validación | `try/except ValueError` dentro del `while True` |

### Programa `suma_rango.py` (práctica guiada) modificado
Verificar que:
- El contador de pares e impares funciona.
- `total_pares = total_pares + num` dentro de `if num % 2 == 0`.

## 4. Criterios de corrección (lista de verificación)

| ✔ | Criterio | Puntos sugeridos |
|---|---|---|
| ☐ | El archivo se llama `adivina.py` | 0,5 |
| ☐ | Número secreto asignado en variable (no hardcodeado literal en la condición) | 0,5 |
| ☐ | Bucle `while` que se corta al acertar (con `break` o condición) | 1,5 |
| ☐ | Contador de intentos (`attempts = attempts + 1`) | 1,5 |
| ☐ | Pistas "más alto" / "más bajo" | 1,5 |
| ☐ | Validación de entrada (`try/except ValueError`) | 1,5 |
| ☐ | Mensaje final con cantidad de intentos (f-string) | 1 |
| ☐ | Comentarios en el código | 0,5 |
| ☐ | **Total** | **8,5** |

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
|---|---|---|
| Bucle infinito porque el `while` no tiene `break` ni condición de cambio | No usa `break` ni cambia una variable de control | Mostrar el patrón: `while True:` + `if condicion: break`. |
| El contador de intentos aumenta incluso cuando el usuario tipea texto | `attempts = attempts + 1` está antes del `try`, o fuera del `try` pero antes del `except` | Señalar que los intentos inválidos no deberían contar. Mover el contador después de la conversión exitosa. |
| Pista invertida: si el número es menor dice "más bajo" | Confunde la relación: si `guess < secret`, el secreto es más alto | Dibujar la recta numérica en el pizarrón. |
| `for i in range(1, 11)` pero espera que termine en 11 | No entiende que `range(start, stop)` excluye `stop` | Mostrar con `list(range(1, 11))` en la terminal. |
| Olvida la validación `try/except` | Todavía no internalizaron el patrón | Recordar que cualquier `input()` numérico lleva validación. |
| Usa `for` en vez de `while` para el juego de adivinar | `for` no es adecuado porque no sabemos cuántos intentos hará | Explicar: `for` es para cantidad conocida, `while` para condición. |

## 6. Registro de la clase

| Aspecto | Qué registrar |
|---|---|
| Comprensión de `for` vs `while` | ¿Cuándo eligen uno u otro naturalmente? ¿Usan `for` para el juego de adivinar? |
| Contadores y acumuladores | ¿Aplican el patrón solos o necesitan recordatorio? |
| Bucle infinito | ¿Cuántos entraron en bucle infinito? ¿Supieron cortar con `Ctrl+C`? |
| Para la evaluación de proceso | Es el último encuentro antes del TP y la evaluación. Identificar parejas que necesitan más apoyo en el TP. |
