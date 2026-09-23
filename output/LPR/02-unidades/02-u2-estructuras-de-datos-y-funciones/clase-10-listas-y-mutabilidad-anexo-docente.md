# Anexo docente — Encuentro 10: Listas y mutabilidad

> Documento docente formal. No se entrega a los alumnos.

## 1. Solución del ejercicio independiente

**Archivo esperado:** `member_ages.py`

```python
# Lista inicial de edades de socios del club
ages = [17, 15, 18, 16, 19]

print("=== Edades de los socios ===")
print("Edades iniciales:", ages)

# Pedir una nueva edad con validación
while True:
    try:
        new_age = int(input("Ingresá una nueva edad: "))
        break
    except ValueError:
        print("Eso no es un número entero; intentá de nuevo.")

# Agregar la nueva edad
ages.append(new_age)
print("Después de agregar:", ages)

# Ordenar y mostrar
ages.sort()
print("Edades ordenadas:", ages)

# Sacar el último elemento
removed = ages.pop()
print(f"El último edad que se fue: {removed}")

# Mostrar el tercer elemento (índice 2)
third = ages[2]
print(f"La edad en la posición 2 (tercer elemento): {third}")
print("Lista final:", ages)
```

**Salida verificada** (con entrada `14`):

```
=== Edades de los socios ===
Edades iniciales: [17, 15, 18, 16, 19]
Ingresá una nueva edad: 14
Después de agregar: [17, 15, 18, 16, 19, 14]
Edades ordenadas: [14, 15, 16, 17, 18, 19]
El último edad que se fue: 19
La edad en la posición 2 (tercer elemento): 16
Lista final: [14, 15, 16, 17, 18]
```

## 2. Solución de la actividad de extensión

**1. Edad máxima y mínima:**

```python
print(f"Edad máxima: {max(ages)}")
print(f"Edad mínima: {min(ages)}")
```

**2. Slice de mayores (últimas 3 de la ordenada):**

```python
ages.sort()
print("Últimas 3 edades:", ages[-3:])
```

**3. Lista desde string con split:**

```python
names_str = "Ana,Luis,Sofía,Carlos"
name_list = names_str.split(",")
name_list.append("María")
print("Lista generada con split:", name_list)
```

**4. Demostración de inmutabilidad del string:**

```python
word = "Hola"
# word[0] = "h"   # Esto lanza TypeError
# Forma correcta: construir nuevo
word = "h" + word[1:]
print("String modificado (nuevo):", word)
```

## 3. Respuesta esperada del ejercicio

| Paso | Comando/acción | Salida esperada |
| --- | --- | --- |
| Crear lista | `ages = [17, 15, 18, 16, 19]` | — |
| Mostrar | `print(ages)` | `[17, 15, 18, 16, 19]` |
| Ingresar 14 | `int(input(...))` con validación | `14` |
| `append` + mostrar | `ages.append(14)` → `print(ages)` | `[17, 15, 18, 16, 19, 14]` |
| `sort` + mostrar | `ages.sort()` → `print(ages)` | `[14, 15, 16, 17, 18, 19]` |
| `pop` + mostrar | `removed = ages.pop()` → `print(removed)` | `19` |
| Índice 2 | `ages[2]` | `16` |

## 4. Criterios de corrección (lista de verificación)

| ✔ | Aspecto | Peso |
| --- | --- | --- |
| ☐ | El archivo `member_ages.py` existe y compila | obligatorio |
| ☐ | La lista `ages` se crea correctamente con los 5 valores dados | 1 pt |
| ☐ | Se pide una nueva edad con `input()` y se valida con `try/except ValueError` | 2 pts |
| ☐ | Se usa `append()` sin asignar el resultado (línea propia) | 1 pt |
| ☐ | Se usa `sort()` sin asignar el resultado | 1 pt |
| ☐ | Se usa `pop()` y se muestra el valor eliminado | 1 pt |
| ☐ | Se accede por índice a la posición 2 (`ages[2]`) | 1 pt |
| ☐ | Los comentarios explican cada acción relevante | 1 pt |
| ☐ | Los mensajes al usuario son f-strings, en español y con tildes | 1 pt |
| **Total** | | **9 pts** |

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| `append` no funciona: la lista queda `None` | El estudiante asignó el resultado (`ages = ages.append(14)`) | Mostrar en la terminal que `append` devuelve `None`: ejecutar `print(ages.append(14))` y ver el `None`. La lista se modifica en el lugar. |
| `sort` no funciona igual | El estudiante asignó `ages = ages.sort()` | Ídem: `print(ages.sort())` devuelve `None`. La lista queda ordenada igual. |
| `IndexError: list index out of range` | Usó índice mayor que `len(ages)-1` | Preguntar «¿cuántos elementos tiene la lista?» y mostrar que los índices van de 0 a `len-1`. |
| `NameError` o edad no numérica | No convirtió `input()` con `int()`, o el `try/except` está mal ubicado | Recordar que `input()` devuelve `str`; demostrar con `type(input("test: "))` en la terminal. |
| El programa no usa `pop()` | No comprendió que `pop()` saca el último y lo devuelve | Pedir que ejecuten `help(list.pop)` en la terminal o que lean el error a propósito con una lista vacía. |
| No muestra mensajes o usa concatenación `+` en vez de f-strings | Olvido de la convención del curso | Señalar la sección de salida de las convenciones técnicas: «mensajes compuestos con f-strings, nunca concatenación con `+`». |

## 6. Registro de la clase

**Para cada grupo o estudiante, registrar:**

- ¿Pudieron crear la lista y ejecutar `append` sin asignar?
- ¿Usaron `sort()` correctamente o intentaron asignar el resultado?
- ¿Validaron la entrada numérica con `try/except`?
- ¿Comprendieron la diferencia entre mutable (`list`) e inmutable (`str`) al hacer la demostración?

**Para la evaluación de proceso:**

- Dificultad observada en el uso de `index()` y slicing.
- Velocidad: quiénes llegaron a extensión y quiénes apenas completaron el ejercicio base.
- Anotar nombres de estudiantes que mostraron confusión con la mutabilidad para retomar en el encuentro 11.
