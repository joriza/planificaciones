# Anexo docente — Encuentro 11: Tuplas y conjuntos (set)

> Documento docente formal. No se entrega a los alumnos.

## 1. Solución del ejercicio independiente

**Archivo esperado:** `club_registry.py`

```python
# 1. Tupla con los meses del año
months = ("enero", "febrero", "marzo", "abril", "mayo", "junio",
          "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre")

print("Meses del año (tupla):", months)

# 2. Lista de nombres con duplicado
member_names = ["Ana", "Luis", "Sofía", "Carlos", "Ana"]
print("\nLista original (con duplicado):", member_names)

# 3. Convertir a set para eliminar duplicados
unique_names = set(member_names)
print("Nombres únicos (set):", unique_names)

# 4. Pedir un nombre nuevo y agregarlo
new_name = input("\nIngresá un nombre para agregar: ")
unique_names.add(new_name)
print("Después de agregar:", unique_names)

# 5. Cantidad de nombres únicos
print(f"\nCantidad de nombres únicos: {len(unique_names)}")

# 6. Preguntar si un nombre está en el set
search_name = input("Ingresá un nombre para buscar: ")
if search_name in unique_names:
    print(f"{search_name} SÍ está en el registro.")
else:
    print(f"{search_name} NO está en el registro.")
```

**Salida verificada** (con entradas `"María"` y `"Luis"`):

```
Meses del año (tupla): ('enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre')

Lista original (con duplicado): ['Ana', 'Luis', 'Sofía', 'Carlos', 'Ana']
Nombres únicos (set): {'Ana', 'Carlos', 'Luis', 'Sofía'}

Ingresá un nombre para agregar: María
Después de agregar: {'Ana', 'Carlos', 'Luis', 'María', 'Sofía'}

Cantidad de nombres únicos: 5
Ingresá un nombre para buscar: Luis
Luis SÍ está en el registro.
```

## 2. Solución de la actividad de extensión

**1. Unión e intersección de sets:**

```python
set_a = {1, 2, 3}
set_b = {3, 4, 5}
print("Unión:", set_a | set_b)          # {1, 2, 3, 4, 5}
print("Intersección:", set_a & set_b)   # {3}
```

**2. Tupla como clave de set (la lista no puede):**

```python
# Esto funciona: la tupla es hashable
valid_set = {("Ana", 17), ("Luis", 15)}
print("Set de tuplas:", valid_set)

# Esto falla: list no es hashable
# invalid_set = {["Ana", 17]}   # TypeError: unhashable type: 'list'
```

**3. `discard()` vs `remove()`:**

```python
ids = {101, 105, 103}
ids.discard(105)    # existe, lo borra
ids.discard(999)    # no existe, no hace nada (no lanza error)
print("Después de discard:", ids)

# remove lanza KeyError si no existe
# ids.remove(999)   # KeyError
```

## 3. Respuesta esperada del ejercicio

| Paso | Acción | Salida esperada |
| --- | --- | --- |
| 1 | Crear tupla `months` | `('enero', ..., 'diciembre')` |
| 2 | Crear lista con duplicado | `['Ana', 'Luis', 'Sofía', 'Carlos', 'Ana']` |
| 3 | `set(member_names)` | `{'Ana', 'Carlos', 'Luis', 'Sofía'}` |
| 4 | `add("María")` | Set con nombres + "María" |
| 5 | `len(unique_names)` | 5 |
| 6 | `"Luis" in unique_names` | `Luis SÍ está en el registro.` |
| 6 | `"Pedro" in unique_names` | `Pedro NO está en el registro.` |

## 4. Criterios de corrección (lista de verificación)

| ✔ | Aspecto | Peso |
| --- | --- | --- |
| ☐ | Archivo `club_registry.py` existe y compila | obligatorio |
| ☐ | Tupla `months` con los 12 meses | 1 pt |
| ☐ | Lista con los 5 nombres dados | 1 pt |
| ☐ | Conversión a set con `set(member_names)` | 2 pts |
| ☐ | Agregar nombre por `input()` + `add()` | 2 pts |
| ☐ | Mostrar `len(unique_names)` | 1 pt |
| ☐ | Búsqueda con `in` y respuesta condicional | 2 pts |
| ☐ | Comentarios en español por acción relevante | 1 pt |
| **Total** | | **10 pts** |

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| `{}` vacío como set | Piensa que `{}` es un set vacío | Mostrar `type({})` → `dict`. Recordar: set vacío es `set()`. |
| `remove()` lanza `KeyError` | No verifica existencia previa | Mostrar `discard()` como alternativa segura, o enseñar el patrón `if x in my_set: my_set.remove(x)`. |
| Usa lista como elemento del set | `TypeError: unhashable type: 'list'` | Explicar que solo tipos inmutables (tupla, str, int) pueden estar dentro de un set. |
| Piensa que `(1)` es una tupla | Falta la coma | `type((1))` → `int`. La tupla de un elemento es `(1,)`. |
| Confunde orden del set con orden de creación | No sabe que set no preserva orden | Mostrar con múltiples ejecuciones que el orden varía. Si necesita orden: `sorted()`. |
| No usa `add()` sino `append()` sobre un set | Trata al set como lista | `set` no tiene `append`. El método es `add()`. Mostrar `dir(my_set)`. |

## 6. Registro de la clase

**Para cada grupo o estudiante, registrar:**

- ¿Usaron correctamente `set()` para crear el set vacío y `add()` para agregar?
- ¿Entendieron que la tupla no se puede modificar? ¿Lo probaron?
- ¿Pudieron explicar cuándo usar cada tipo de colección?

**Para la evaluación de proceso:**

- Quiénes comprendieron el concepto de unicidad automática del set.
- Quiénes preguntaron por qué el orden del set cambia entre ejecuciones.
- Anotar estudiantes que confundieron `{}` con set para retomar en el encuentro 12 (diccionarios también usan `{}`).