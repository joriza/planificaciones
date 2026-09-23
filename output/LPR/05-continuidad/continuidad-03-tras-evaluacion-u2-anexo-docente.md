# Anexo docente — Continuidad pedagógica 03: Tras la evaluación de la Unidad 2

> Documento docente formal. No se entrega a los alumnos: contiene las soluciones completas de cada actividad, los criterios de corrección, los errores previstos y su intervención.

## 1. Soluciones de las actividades

### Actividad 1 — Completar código: métodos de listas (papel, 15 pts)

**Código incompleto entregado al alumno:**

```python
# Programa: lista_de_compras
# Completar con los metodos de lista apropiados

compras = ["pan", "leche", "huevos", "pan"]

# 1. Agregar "manteca" al final
compras._____("manteca")

# 2. Eliminar la primera aparicion de "pan"
compras._____("pan")

# 3. Quitar el ultimo elemento
eliminado = compras._____()

# 4. Ordenar alfabeticamente
compras._____()

# 5. Encontrar la posicion de "leche"
posicion = compras._____("leche")

print(f"Lista final: {compras}")
print(f"Elemento eliminado: {eliminado}")
print(f"Posicion de 'leche': {posicion}")
```

**Solución esperada (líneas completadas):**

```python
compras.append("manteca")     # resultado: ["pan", "leche", "huevos", "pan", "manteca"]
compras.remove("pan")         # resultado: ["leche", "huevos", "pan", "manteca"]
eliminado = compras.pop()     # eliminado = "manteca", lista: ["leche", "huevos", "pan"]
compras.sort()                # resultado: ["huevos", "leche", "pan"]
posicion = compras.index("leche")  # posicion = 1
```

**Estado final de la lista:** `["huevos", "leche", "pan"]`
**Valor de `eliminado`:** `"manteca"`
**Valor de `posicion`:** `1`

**Criterios de corrección:**
- Cada método correcto (3 pts c/u, 15 pts total).

**Errores frecuentes:**
- Usan `append` para insertar en una posición específica.
- Confunden `remove` (elimina por valor) con `pop` (elimina por índice) o `del`.
- Creen que `sort()` devuelve una nueva lista (ordena in-place, devuelve `None`).
- No recuerdan que `index()` lanza excepción si no encuentra el valor.
- **Intervención docente:** "`remove()` borra la primera coincidencia del valor que le pasás. `pop()` saca por posición (el último si no le pasás índice)."

---

### Actividad 2 — Elección de estructura (papel, 15 pts)

**Situaciones y soluciones esperadas:**

**(a) Almacenar los días de la semana en orden**
- **Estructura:** tupla (`tuple`)
- **Justificación:** los días de la semana son fijos (no cambian), están en orden, y no deberían modificarse accidentalmente. La tupla es inmutable, lo que garantiza que no se alteren.

**(b) Guardar los nombres de estudiantes sin repetidos**
- **Estructura:** conjunto (`set`)
- **Justificación:** los conjuntos garantizan unicidad automática. No importa el orden. Si se agrega un nombre repetido, el conjunto lo ignora.

**(c) Asociar un nombre de producto con su precio**
- **Estructura:** diccionario (`dict`)
- **Justificación:** necesitamos una relación clave↔valor donde el nombre (único) se asocia con el precio. El diccionario es la estructura natural para esta correspondencia.

**(d) Registrar temperaturas horarias de un día que no van a cambiar**
- **Estructura:** tupla (`tuple`)
- **Justificación:** hay un orden fijo (0hs a 23hs), son exactamente 24 valores y no van a modificarse después. La inmutabilidad protege los datos.

**Criterios de corrección:**
- **Estructura correcta (8 pts, 2 pts c/u):** asigna la estructura adecuada.
- **Justificación clara (7 pts, ~1.75 pts c/u):** da una razón que mencione la propiedad relevante (inmutabilidad, unicidad, clave↔valor).

**Errores frecuentes:**
- Eligen lista para todo ("es lo que conozco") sin considerar propiedades.
- Confunden la función de un diccionario con una lista de pares.
- No diferencian tupla de lista por la inmutabilidad.
- **Intervención docente:** "Cada estructura tiene un superpoder: la tupla no se rompe, el set no duplica, el dict asocia, la lista ordena y modifica. Elegí según el superpoder que necesites."

---

### Actividad 3 — Escribir una función (papel, 20 pts)

**Solución esperada:**

```python
def calcular_promedio(lista_numeros):
    """Recibe una lista de float y devuelve el promedio."""
    suma = 0
    for numero in lista_numeros:
        suma = suma + numero
    promedio = suma / len(lista_numeros)
    return promedio


if __name__ == "__main__":
    notas = [7.5, 8.0, 6.5, 9.0, 5.5]
    resultado = calcular_promedio(notas)
    print(f"El promedio es: {resultado:.2f}")
```

**Criterios de corrección:**
- **Definición de función (10 pts):** usa `def`, nombre descriptivo, parámetro, `return`.
- **Lógica interna (4 pts):** recorre la lista, suma, divide por `len()`.
- **Bloque `if __name__ == "__main__"` (3 pts):** presente y bien escrito.
- **Ejemplo de uso (3 pts):** crea lista, llama a la función, muestra resultado.

**Errores frecuentes:**
- No usan `return` (imprimen dentro de la función).
- Olvidan los `()` al invocar la función.
- El bloque `if __name__` lo escriben como `if __name__ = "__main__"` (un solo `=`).
- No importan `len()` o lo escriben mal.
- **Intervención docente:** "Si la función no tiene `return`, devuelve `None`. La función tiene que devolver el valor, no mostrarlo — eso lo hace el que llama."

---

### Actividad 4 — Hallar el error: ámbito y tipos (papel, 15 pts)

**Fragmento 1 (modificar tupla):**

```python
dias = ("lun", "mar", "mie")
dias[1] = "MARTES"
print(dias)
```

**Error:** las tuplas son inmutables; no se puede asignar a `dias[1]`.
**Corrección:** usar una lista `dias = ["lun", "mar", "mie"]` o crear una tupla nueva.

**Fragmento 2 (variable local vs global):**

```python
total = 0

def sumar(a, b):
    total = a + b

sumar(3, 4)
print(total)
```

**Error:** `total` dentro de `sumar` es una variable local que no modifica la global.
**Corrección:** (a) agregar `return` y reasignar, o (b) declarar `global total` dentro de la función (menos recomendado). Solución correcta:

```python
def sumar(a, b):
    return a + b

total = sumar(3, 4)
print(total)  # 7
```

**Fragmento 3 (usar conjunto con índice):**

```python
vocales = {"a", "e", "i", "o", "u"}
print(vocales[2])
```

**Error:** los conjuntos (`set`) no soportan indexación (no tienen orden).
**Corrección:** convertir a lista primero: `lista_vocales = list(vocales)` y luego acceder con índice.

**Criterios de corrección:**
- **Fragmento 1 (5 pts):** identifica inmutabilidad de la tupla.
- **Fragmento 2 (5 pts):** identifica el problema de ámbito.
- **Fragmento 3 (5 pts):** identifica que el `set` no tiene índice.

**Errores frecuentes:**
- En Fragmento 2: no ven el error porque el código "funciona" (no lanza excepción). Creen que imprime 7.
- **Intervención docente:** "Python no te va a avisar si una variable local tiene el mismo nombre que una global. El error es lógico: la función no modificó la global."

---

### Actividad 5 — Tarea de programación: `gestor_contactos.py` (computadora, 35 pts)

**Solución completa:**

```python
# gestor_contactos.py
# Gestor de contactos usando un diccionario

def agregar_contacto(directorio, nombre, telefono):
    """Agrega un par nombre:telefono al directorio."""
    directorio[nombre] = telefono
    print(f"Contacto '{nombre}' agregado.")


def listar_contactos(directorio):
    """Recorre el diccionario y muestra cada contacto."""
    if not directorio:
        print("El directorio esta vacio.")
        return
    print("\n--- Lista de contactos ---")
    for nombre, telefono in directorio.items():
        print(f"{nombre}: {telefono}")
    print("--------------------------\n")


if __name__ == "__main__":
    directorio = {}

    agregar_contacto(directorio, "Ana Garcia", "11-1234-5678")
    agregar_contacto(directorio, "Carlos Lopez", "15-9876-5432")
    agregar_contacto(directorio, "Maria Fernandez", "11-5555-3333")

    listar_contactos(directorio)
```

**Salida esperada al ejecutar:**
```
Contacto 'Ana Garcia' agregado.
Contacto 'Carlos Lopez' agregado.
Contacto 'Maria Fernandez' agregado.

--- Lista de contactos ---
Ana Garcia: 11-1234-5678
Carlos Lopez: 15-9876-5432
Maria Fernandez: 11-5555-3333

--------------------------
```

**Criterios de corrección (35 pts):**
| Aspecto | Pts | Qué se evalúa |
|---------|-----|---------------|
| Diccionario como estructura | 5 | Usa un `dict` para el directorio |
| Función `agregar_contacto` | 8 | Recibe los 3 parámetros, asigna `directorio[nombre] = telefono` |
| Función `listar_contactos` | 8 | Recorre con `.items()`, muestra nombre y teléfono |
| `if __name__ == "__main__"` | 5 | Bloque presente con directorio inicial y al menos 3 contactos |
| Nombres y comentarios | 5 | snake_case en inglés, comentarios en español |
| Ejecución sin errores | 4 | Corre sin excepciones, no usa persistencia |

**Errores frecuentes y soluciones:**
| Error | Solución sugerida |
|-------|-------------------|
| Usan una lista de tuplas en lugar de diccionario | "¿Cómo buscarías el teléfono de una persona si tenés 100 contactos?" |
| No pasan el directorio como parámetro | "La función necesita el directorio para modificarlo. Si no lo pasás, no sabe qué modificar." |
| En `listar_contactos` imprimen el diccionario directamente (`print(directorio)`) sin formatear | "El usuario quiere verlo lindo, no como código Python." |
| Usan `nombre` en lugar de `telefono` en la asignación (`directorio[telefono] = nombre`) | Revisar el orden de los parámetros |
| Olvidan el `if __name__ == "__main__"` | "Sin ese bloque, si alguien importa tu archivo, se ejecuta todo automáticamente." |

**Verificación de ejecución:**

```bash
python gestor_contactos.py
```

Debe compilar y mostrar los 3 contactos agregados. No usa `open()`, `input()` ni persistencia.

---

## 2. Criterios de logro generales

| Condición | Criterio |
|---|---|
| Logrado (≥70 pts) | Elige y usa correctamente listas, tuplas, conjuntos y diccionarios según el problema; escribe funciones con `return` y bloque `if __name__`; integra estructuras en un programa completo. |
| En proceso (40–69 pts) | Reconoce las estructuras pero las aplica mecánicamente; confunde métodos o no escribe funciones autónomas. |
| Requiere apoyo (<40 pts) | Dificultades en más de una estructura de datos o en el concepto de función. Requiere intensificación antes de la Unidad 3. |

## 3. Nota para el docente

Esta actividad se aplica **tras la evaluación de la Unidad 2** (encuentro 15). Prestar atención a:
- Si el estudiante puede justificar la elección de estructura (eso indica comprensión, no solo memorización).
- Errores de ámbito que persisten de U1 y reaparecen al escribir funciones.
- El bloque `if __name__` suele olvidarse; verificar si lo incorporan como hábito en la Actividad 5.
