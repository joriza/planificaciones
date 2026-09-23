# Encuentro 13 — Funciones y ámbito local

> Estructuras de datos y funciones · Unidad 2

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 13 de 36 |
| Unidad | 2 — Estructuras de datos y funciones |
| Eje temático | 2 — Estructuras de datos y funciones |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 120 minutos (2 horas reloj) |
| Concepto nuevo | Funciones y ámbito local |
| Requisitos previos | Listas, tuplas, sets, diccionarios: creación, métodos, recorridos. Todo de los encuentros 10-12. |
| Uso de celular | No permitido |
| Organización del trabajo | Individual con monitor, o en parejas. Cada estudiante escribe su propio `.py`. |

### Reparto de tiempos

| Momento | Tiempo |
| --- | --- |
| Apertura y puente | 10 min |
| Teoría mínima | 20 min |
| Práctica guiada | 35 min |
| Ejercicio independiente | 25 min |
| Extensión y consolidación | 20 min |
| Cierre | 10 min |
| **Total** | **120 min** |

## 2. Objetivos de aprendizaje

Al finalizar este encuentro vas a poder:

1. Definir una función con `def`, parámetros y `return`.
2. Llamar a una función y usar su valor de retorno.
3. Explicar que las variables dentro de una función son locales y no existen afuera.
4. Escribir un archivo organizado con funciones arriba y `if __name__ == "__main__":` abajo.
5. Descomponer un problema pequeño en funciones.

## 3. Teoría mínima (20 min)

### Charla rápida: la receta del cocinero

Una función es como una receta. Le pasás ingredientes (parámetros), seguís los pasos, y obtenés un plato (return). Mientras cocinás, usás tus propios bowls (variables locales) que no existen fuera de la cocina. Si necesitás algo del resultado, el cocinero te lo pasa en el plato.

Hasta ahora escribimos todo el código corrido, como una receta sin separar en pasos reutilizables. Con `def` aprendemos a empaquetar pasos para usarlos muchas veces.

### Lo mínimo indispensable

**Estructura de una función:**

```python
def nombre_funcion(parametro1, parametro2):
    """Cuerpo: hace algo y devuelve un resultado."""
    resultado = parametro1 + parametro2
    return resultado
```

**Ámbito local:** las variables creadas dentro de la función **no existen fuera**.

```python
def calculate_double(value):
    double = value * 2  # double es local
    return double

result = calculate_double(5)
print(result)         # 10
# print(double)       # NameError — double no existe acá
```

**Organización del archivo (desde hoy y siempre):**

```python
# 1. Primero todas las funciones
def read_int(message):
    while True:
        try:
            return int(input(message))
        except ValueError:
            print("Eso no es un número entero; intentá de nuevo.")

def show_menu():
    print("1. Ver socios")
    print("2. Agregar socio")
    print("3. Salir")

# 2. Al final, el bloque de ejecución principal
if __name__ == "__main__":
    # El programa arranca acá
    show_menu()
    option = read_int("Opción: ")
```

**¿Por qué `if __name__ == "__main__"`?** Porque así el archivo solo se ejecuta cuando lo corremos directamente. Si lo importáramos desde otro archivo (en el futuro), las funciones estarían disponibles pero el bloque principal no se ejecutaría automáticamente.

**Sin `return` la función devuelve `None`:**

```python
def greet(name):
    print(f"Hola {name}")   # no hay return

result = greet("Ana")
print(result)   # None
```

**Regla:** si una función produce un valor, lo devuelve con `return`. Si solo hace algo (como imprimir), no necesita `return`, pero no esperes un valor útil de vuelta.

## 4. Práctica guiada (35 min)

Armamos un programa con funciones para el club.

**Paso 1:** crear `club_functions.py` y escribir:

```python
# === FUNCIONES ===

def read_int(message):
    """Pide un número entero con validación (input devuelve str)."""
    while True:
        try:
            return int(input(message))
        except ValueError:
            print("Eso no es un número entero; intentá de nuevo.")


def add_member(members, name, age):
    """Agrega un socio al diccionario (clave=nombre, valor=edad)."""
    members[name] = age
    return members


def find_member(members, name):
    """Busca un socio por nombre. Devuelve la edad o None si no existe."""
    return members.get(name, None)


def show_all(members):
    """Muestra todos los socios con su edad."""
    if len(members) == 0:
        print("No hay socios registrados.")
        return

    print("=== Socios del club ===")
    for name, age in members.items():
        print(f"  {name}: {age} años")
    print(f"Total: {len(members)} socios")


# === BLOQUE PRINCIPAL ===
if __name__ == "__main__":
    club_members = {}

    add_member(club_members, "Ana García", 17)
    add_member(club_members, "Luis Pérez", 15)
    add_member(club_members, "Sofía Martínez", 18)

    show_all(club_members)

    print("\nAgregamos un nuevo socio...")
    add_member(club_members, "Carlos López", 16)
    show_all(club_members)

    print("\nBuscamos a 'Luis Pérez'...")
    age = find_member(club_members, "Luis Pérez")
    if age is not None:
        print(f"Luis Pérez tiene {age} años.")
    else:
        print("No encontrado.")

    print("\nBuscamos a 'María Torres'...")
    age = find_member(club_members, "María Torres")
    if age is not None:
        print(f"María Torres tiene {age} años.")
    else:
        print("No encontrado.")
```

**Paso 2:** ejecutá con `python club_functions.py`.

**Salida esperada:**

```
=== Socios del club ===
  Ana García: 17 años
  Luis Pérez: 15 años
  Sofía Martínez: 18 años
Total: 3 socios

Agregamos un nuevo socio...
=== Socios del club ===
  Ana García: 17 años
  Luis Pérez: 15 años
  Sofía Martínez: 18 años
  Carlos López: 16 años
Total: 4 socios

Buscamos a 'Luis Pérez'...
Luis Pérez tiene 15 años.

Buscamos a 'María Torres'...
No encontrado.
```

**Paso 3:** comentá el `return members` dentro de `add_member`, volvé a ejecutar y observá que la función devuelve `None` — pero la lista se modificó igual porque `dict` es mutable. Comentá y preguntá: ¿es necesario ese `return`?

## 5. Ejercicio independiente (25 min)

**Consigna:** Escribí un programa `club_menu.py` con un menú de opciones usando funciones.

El programa debe tener estas funciones arriba del `if __name__ == "__main__":`:

1. `read_int(message)` — la función de validación de la práctica guiada.
2. `add_member(members, name, age)` — agrega un socio al diccionario.
3. `remove_member(members, name)` — elimina un socio del diccionario si existe. Devuelve `True` si lo eliminó, `False` si no.
4. `show_all(members)` — muestra la lista de socios.
5. `show_menu()` — imprime el menú.

En el bloque principal, el programa debe:

- Crear un diccionario vacío `members`.
- Mostrar el menú en un bucle: 1 = Ver todos, 2 = Agregar, 3 = Eliminar, 4 = Salir.
- Para agregar, pedir nombre y edad con `read_int`.
- Para eliminar, pedir nombre y llamar a `remove_member`.
- Salir cuando el usuario elija 4.

**Pista:** el bucle principal tiene que llamar a `show_menu()` y después leer la opción. Usá `while True` y `break` cuando la opción sea 4.

## 6. Extensión y consolidación (20 min)

1. **Función con tupla como retorno:** escribí una función `get_stats(ages)` que reciba una lista de edades y devuelva una tupla con `(min, max, promedio)`.
2. **Parámetro por defecto:** creá una función `create_member(name, age, category="menor")` que devuelva un diccionario de socio. Llamala sin pasar la categoría (usar el default) y con una categoría distinta.
3. **Docstring:** agregale un `"""docstring"""` a cada función explicando qué hace, qué parámetros recibe y qué devuelve.

## 7. Cierre (10 min)

### Qué te llevás

- Las funciones se definen con `def nombre(parametros):` y se llaman con `nombre(args)`.
- Las variables dentro de la función son locales: no existen afuera.
- `return` devuelve un valor; sin `return` la función devuelve `None`.
- El archivo se organiza: **funciones primero, `if __name__ == "__main__":` al final**.
- Las colecciones mutables (listas, dicts) se modifican dentro de la función incluso sin `return`.

### Lo que viene

**Encuentro 14: Cierre U2: repaso y TP**

## 8. Errores comunes y trampas

| Error | Causa | Fix |
| --- | --- | --- |
| Llamar a una función sin paréntesis | `result = show_all` asigna la función, no la ejecuta | Siempre `show_all()` con paréntesis para invocar |
| Usar variable local fuera de la función | `NameError` porque no existe en el ámbito global | Devolver el valor con `return` y capturarlo al llamar |
| Modificar un parámetro de tipo inmutable (int, str, tuple) y esperar cambio afuera | Los tipos inmutables no se modifican "en el lugar"; la función recibe una copia | Devolver el nuevo valor con `return` y reasignarlo |
| Olvidar `return` y usar el resultado igual | La función devuelve `None` → `result = greet("Ana"); print(result + 1)` falla | Agregar `return valor` en la función |
| Código suelto sin `if __name__ == "__main__":` | El archivo funciona igual por ahora, pero es mala práctica que se vuelve problema al importar | Mover la ejecución al bloque principal |
| Definir función después de usarla | Python lee el archivo de arriba a abajo — `NameError` si la función no está definida aún | Las funciones siempre arriba, la ejecución al final |
