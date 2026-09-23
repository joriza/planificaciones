# Anexo docente — Encuentro 13: Funciones y ámbito local

> Documento docente formal. No se entrega a los alumnos.

## 1. Solución del ejercicio independiente

**Archivo esperado:** `club_menu.py`

```python
# === FUNCIONES ===

def read_int(message):
    """Pide un número entero con validación."""
    while True:
        try:
            return int(input(message))
        except ValueError:
            print("Eso no es un número entero; intentá de nuevo.")


def add_member(members, name, age):
    """Agrega un socio al diccionario."""
    members[name] = age
    print(f"{name} fue agregado correctamente.")


def remove_member(members, name):
    """Elimina un socio. Devuelve True si existía, False si no."""
    if name in members:
        members.pop(name)
        print(f"{name} fue eliminado del registro.")
        return True
    else:
        print(f"{name} no está registrado.")
        return False


def show_all(members):
    """Muestra todos los socios con su edad."""
    if len(members) == 0:
        print("No hay socios registrados.")
        return

    print("\n=== Socios del club ===")
    for name, age in members.items():
        print(f"  {name}: {age} años")
    print(f"Total: {len(members)} socios\n")


def show_menu():
    """Imprime el menú de opciones."""
    print("\n--- Club de Barrio ---")
    print("1. Ver todos los socios")
    print("2. Agregar un socio")
    print("3. Eliminar un socio")
    print("4. Salir")


# === BLOQUE PRINCIPAL ===
if __name__ == "__main__":
    members = {}

    while True:
        show_menu()
        option = read_int("Elegí una opción: ")

        if option == 1:
            show_all(members)

        elif option == 2:
            name = input("Nombre del socio: ")
            age = read_int("Edad: ")
            add_member(members, name, age)

        elif option == 3:
            name = input("Nombre del socio a eliminar: ")
            remove_member(members, name)

        elif option == 4:
            print("¡Gracias por usar el sistema del club!")
            break

        else:
            print("Opción inválida. Elegí 1, 2, 3 o 4.")
```

**Salida verificada** (interacción completa):

```
--- Club de Barrio ---
1. Ver todos los socios
2. Agregar un socio
3. Eliminar un socio
4. Salir
Elegí una opción: 1
No hay socios registrados.

--- Club de Barrio ---
1. Ver todos los socios
2. Agregar un socio
3. Eliminar un socio
4. Salir
Elegí una opción: 2
Nombre del socio: Ana
Edad: 17
Ana fue agregado correctamente.

--- Club de Barrio ---
1. Ver todos los socios
2. Agregar un socio
3. Eliminar un socio
4. Salir
Elegí una opción: 1

=== Socios del club ===
  Ana: 17 años
Total: 1 socios

--- Club de Barrio ---
1. Ver todos los socios
2. Agregar un socio
3. Eliminar un socio
4. Salir
Elegí una opción: 3
Nombre del socio a eliminar: Ana
Ana fue eliminado del registro.

--- Club de Barrio ---
1. Ver todos los socios
2. Agregar un socio
3. Eliminar un socio
4. Salir
Elegí una opción: 4
¡Gracias por usar el sistema del club!
```

## 2. Solución de la actividad de extensión

**1. Función que devuelve tupla con estadísticas:**

```python
def get_stats(ages):
    """Recibe lista de edades, devuelve (min, max, promedio)."""
    minimum = min(ages)
    maximum = max(ages)
    average = sum(ages) / len(ages)  # división real produce float
    return (minimum, maximum, average)


if __name__ == "__main__":
    ages = [17, 15, 18, 16, 19]
    stats = get_stats(ages)
    print(f"Mínimo: {stats[0]}, Máximo: {stats[1]}, Promedio: {stats[2]:.1f}")
```

**2. Parámetro por defecto:**

```python
def create_member(name, age, category="menor"):
    """Crea un diccionario de socio. category tiene valor por defecto."""
    return {"name": name, "age": age, "category": category}


if __name__ == "__main__":
    m1 = create_member("Ana", 17)              # usa "menor" por defecto
    m2 = create_member("Luis", 18, "adulto")   # pasa categoría distinta
    print(m1)
    print(m2)
```

**3. Docstrings:** cada función en la solución del ejercicio ya incluye docstring.

## 3. Respuesta esperada del ejercicio

| Opción | Acción del usuario | Salida esperada |
| --- | --- | --- |
| 1 (sin socios) | — | `No hay socios registrados.` |
| 2 | Nombre: Ana, Edad: 17 | `Ana fue agregado correctamente.` |
| 1 (con datos) | — | `Ana: 17 años`, `Total: 1 socios` |
| 3 | Nombre: Ana | `Ana fue eliminado del registro.` |
| 3 | Nombre: Pedro | `Pedro no está registrado.` |
| 4 | — | `¡Gracias por usar el sistema del club!` + termina |

## 4. Criterios de corrección (lista de verificación)

| ✔ | Aspecto | Peso |
| --- | --- | --- |
| ☐ | Archivo `club_menu.py` existe y compila | obligatorio |
| ☐ | Funciones definidas arriba del bloque principal | 1 pt |
| ☐ | `read_int` con `try/except ValueError` | 2 pts |
| ☐ | `add_member` modifica el diccionario recibido como parámetro | 1 pt |
| ☐ | `remove_member` verifica con `in` antes de eliminar | 2 pts |
| ☐ | `show_menu` imprime las 4 opciones | 1 pt |
| ☐ | Bloque `if __name__ == "__main__":` presente y ejecuta el bucle | 2 pts |
| ☐ | Bucle `while True` con `break` en opción 4 | 1 pt |
| ☐ | Comentarios y f-strings con español y tildes | 1 pt |
| **Total** | | **11 pts** |

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| `NameError: name 'show_menu' is not defined` | Usó la función antes de definirla, o código suelto sin `if __name__` | Mostrar que Python lee de arriba abajo. Las funciones van primero, el main al final. |
| La función no devuelve nada y lo usan igual | Sin `return` la función devuelve `None` | Mostrar `result = add_member(...); print(result)` → `None`. Si necesitás un valor, necesitás `return`. |
| Llaman a la función sin paréntesis | `x = show_menu` asigna la referencia a la función | Mostrar `type(show_menu)` vs `type(show_menu())`. Los paréntesis ejecutan. |
| Modifican edad pero no se refleja afuera | La edad es `int` (inmutable); la función recibe una copia | Devolver el nuevo valor con `return edad_nueva`. |
| Código fuera del bloque principal no funciona en orden | Código suelto antes de las definiciones o entre funciones | Recordar organización: funciones, luego bloque `if __name__`. |
| No usan `while True` y el menú no se repite | Escribieron secuencia lineal sin bucle | El menú debe estar dentro de un bucle infinito que solo corte con `break`. |

## 6. Registro de la clase

**Para cada grupo o estudiante, registrar:**

- ¿Entendieron la diferencia entre ámbito local y global?
- ¿Usaron `if __name__ == "__main__":` correctamente?
- ¿Pudieron armar el bucle del menú con funciones?

**Para la evaluación de proceso:**

- Quiénes escribieron funciones con docstrings (señal de comprensión conceptual).
- Dónde se atascaron más: ámbito local, return, o la organización del archivo.
- Esto es base para el TP-U2 (encuentro 14): detectar quiénes necesitan más práctica con funciones antes del trabajo final.
