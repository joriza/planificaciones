# Anexo docente — Encuentro 22: Validación con try/except

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

**Consigna:** `read_age.py` — pedir edad con validación de entero y de rango 0-120.

**Código solución:**

```python
def read_age(message):
    """Pide una edad con validación de entero y rango 0-120."""
    while True:
        try:
            age = int(input(message))
            if 0 <= age <= 120:
                return age
            else:
                print("❌ La edad debe estar entre 0 y 120 años; intentá de nuevo.")
        except ValueError:
            print("❌ Eso no es un número entero; escribí solo dígitos.")


if __name__ == "__main__":
    age = read_age("Ingresá tu edad: ")
    print(f"✓ Edad registrada: {age} años.")
```

**Salida verificada:**
```
Ingresá tu edad: -5
❌ La edad debe estar entre 0 y 120 años; intentá de nuevo.
Ingresá tu edad: 150
❌ La edad debe estar entre 0 y 120 años; intentá de nuevo.
Ingresá tu edad: 25
✓ Edad registrada: 25 años.
```

## 2. Solución de la actividad de extensión

**Extensión 1 — Validación con rango parametrizable:**
```python
def read_int(message, min_val=None, max_val=None):
    while True:
        try:
            value = int(input(message))
            if min_val is not None and value < min_val:
                print(f"❌ El valor mínimo es {min_val}; intentá de nuevo.")
                continue
            if max_val is not None and value > max_val:
                print(f"❌ El valor máximo es {max_val}; intentá de nuevo.")
                continue
            return value
        except ValueError:
            print("❌ Eso no es un número entero; intentá de nuevo.")

# Ejemplo: read_int("Cantidad (1-99): ", 1, 99)
```

**Extensión 2 — Menú simple con opción numerada:**
```python
if __name__ == "__main__":
    pizzas = ["1. Muzza ($1200)", "2. Napo ($1400)", "3. Especial ($1800)"]
    print("=== Menú de pizzas ===")
    for p in pizzas:
        print(p)
    choice = read_int("Elegí una opción (1-3): ", 1, 3)
    print(f"Elegiste: {pizzas[choice - 1]}")
```

**Extensión 3 — Intentos acotados:**
```python
def read_int_limited(message, max_attempts=3):
    for attempt in range(1, max_attempts + 1):
        try:
            return int(input(f"{message} (intento {attempt}/{max_attempts}): "))
        except ValueError:
            if attempt < max_attempts:
                print("❌ Número inválido; intentá de nuevo.")
            else:
                print("❌ Demasiados intentos fallidos. Cerrando.")
                return None
```

## 3. Respuesta esperada del ejercicio

| Entrada | Salida esperada |
| --- | --- |
| `25` | `✓ Edad registrada: 25 años.` |
| `-5` | `❌ La edad debe estar entre 0 y 120 años; intentá de nuevo.` y repite |
| `150` | `❌ La edad debe estar entre 0 y 120 años; intentá de nuevo.` y repite |
| `abc` | `❌ Eso no es un número entero; escribí solo dígitos.` y repite |
| `0` | `✓ Edad registrada: 0 años.` (válido, borde inferior) |
| `120` | `✓ Edad registrada: 120 años.` (válido, borde superior) |

## 4. Criterios de corrección (lista de verificación)

- [ ] Usa el patrón `while True` con `try/except ValueError`
- [ ] Valida el rango 0-120 con un `if` después de convertir
- [ ] Muestra mensajes accionables en español
- [ ] El `except` nombra `ValueError` (no es desnudo)
- [ ] Las funciones están arriba, la ejecución en `if __name__ == "__main__":`
- [ ] El programa es un solo archivo `.py`

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| Valida el rango antes de convertir | Confunde el orden: primero `int()`, después validar | Mostrar el flujo: "primero convertí, después verificá si está en rango" |
| Pone el `if` de rango fuera del `while` | No entiende que el `while` cubre ambos errores | Señalar: "el `while` debe rodear todo el proceso de pedido" |
| No usa `continue` o `return` para salir | La función sigue ejecutando después de mostrar error | Explicar que `return` corta la función y el `while` |
| Pone `while` con condición (`while age < 0 or age > 120`) | Mezcla validación con control de flujo | Mostrar que `while True` con `return` interior es más claro |
| Escribe `except:` sin `ValueError` | Hábito de otros lenguajes o tutorials viejos | Recordar regla del curso: "siempre nombrar la excepción" |

## 6. Registro de la clase

- **Por grupo:** anotar si algún grupo no logra el patrón sin ayuda. Registrar si algún grupo usa `except:` desnudo y necesita corrección.
- **Para la evaluación de proceso:** verificar que cada grupo entiende la diferencia entre error de validación y error de bug. Preguntar al cierre: "¿qué excepción atrapamos y por qué justo esa?"
- **Bitácora:** grupos que completaron extensión vs. solo base. Conceptos que generaron confusión (rango vs. conversión).