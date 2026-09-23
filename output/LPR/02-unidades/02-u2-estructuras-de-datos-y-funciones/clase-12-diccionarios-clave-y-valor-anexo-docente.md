# Anexo docente — Encuentro 12: Diccionarios: clave y valor

> Documento docente formal. No se entrega a los alumnos.

## 1. Solución del ejercicio independiente

**Archivo esperado:** `members_directory.py`

```python
# 1. Diccionario vacío: nombre socios → edad
members = {}

# 2. Agregar tres socios
members["Ana"] = 17
members["Luis"] = 15
members["Sofía"] = 18

print("=== Directorio de socios ===")

# 3. Mostrar todos con items()
print("Socios registrados:")
for name, age in members.items():
    print(f"  {name}: {age} años")

# 4. Buscar un socio por nombre
search = input("\nIngresá un nombre para buscar: ")
if search in members:
    print(f"{search} tiene {members[search]} años.")
else:
    print(f"{search} no está registrado en el directorio.")

# 5. Eliminar un socio
remove = input("\nIngresá un nombre para eliminar: ")
removed_age = members.pop(remove, None)
if removed_age is not None:
    print(f"{remove} fue eliminado del directorio (edad: {removed_age}).")
else:
    print(f"{remove} no está registrado, no se puede eliminar.")

# Mostrar directorio final
print("\nDirectorio final:")
for name, age in members.items():
    print(f"  {name}: {age} años")
```

**Salida verificada** (con entrada `"Ana"` y `"Pedro"`):

```
=== Directorio de socios ===
Socios registrados:
  Ana: 17 años
  Luis: 15 años
  Sofía: 18 años

Ingresá un nombre para buscar: Ana
Ana tiene 17 años.

Ingresá un nombre para eliminar: Pedro
Pedro no está registrado, no se puede eliminar.

Directorio final:
  Ana: 17 años
  Luis: 15 años
  Sofía: 18 años
```

Con entrada `"Pedro"` y `"Luis"`:

```
Ingresá un nombre para buscar: Pedro
Pedro no está registrado en el directorio.

Ingresá un nombre para eliminar: Luis
Luis fue eliminado del directorio (edad: 15).

Directorio final:
  Ana: 17 años
  Sofía: 18 años
```

## 2. Solución de la actividad de extensión

**1. Lista de diccionarios (cada socio es una ficha):**

```python
members = [
    {"name": "Ana García", "age": 17, "category": "menor", "fee_paid": True},
    {"name": "Luis Pérez", "age": 15, "category": "menor", "fee_paid": False},
    {"name": "Sofía Martínez", "age": 18, "category": "adulto", "fee_paid": True}
]

print("=== Fichas completas ===")
for member in members:
    print(f"  {member['name']} — {member['age']} años — {member['category']} — Cuota: {member['fee_paid']}")
```

**2. Actualizar edad por nombre:**

```python
search_name = input("Nombre a actualizar: ")
if search_name in members:
    new_age = int(input("Nueva edad: "))
    members[search_name] = new_age
    print(f"Edad de {search_name} actualizada a {new_age}.")
else:
    print("No existe ese socio.")
```

**3. Contar por categoría:**

```python
# Asumiendo que cada socio tiene categoría
category_count = {}
for m in members:
    cat = m["category"]
    if cat in category_count:
        category_count[cat] += 1
    else:
        category_count[cat] = 1
print("Socios por categoría:", category_count)
```

## 3. Respuesta esperada del ejercicio

| Paso | Acción | Salida esperada |
| --- | --- | --- |
| 1 | `members = {}` | Diccionario vacío |
| 2 | `members["Ana"] = 17` | — |
| 2 | `members["Luis"] = 15` | — |
| 2 | `members["Sofía"] = 18` | — |
| 3 | `.items()` | `Ana: 17`, `Luis: 15`, `Sofía: 18` |
| 4 | Buscar "Ana" | `Ana tiene 17 años.` |
| 4 | Buscar "Pedro" | `Pedro no está registrado.` |
| 5 | Eliminar "Pedro" (no existe) | Mensaje de no encontrado |
| 5 | Eliminar "Luis" (existe) | `Luis fue eliminado... edad: 15` |

## 4. Criterios de corrección (lista de verificación)

| ✔ | Aspecto | Peso |
| --- | --- | --- |
| ☐ | Archivo `members_directory.py` existe y compila | obligatorio |
| ☐ | Diccionario vacío creado con `{}` | 1 pt |
| ☐ | Tres socios agregados con sintaxis `dict["clave"] = valor` | 1 pt |
| ☐ | Recorrido con `.items()` | 2 pts |
| ☐ | Búsqueda con `in` y respuesta condicional | 2 pts |
| ☐ | Eliminación con `pop()` y valor por defecto | 2 pts |
| ☐ | Mensajes al usuario con f-strings, español, tildes | 1 pt |
| ☐ | Comentarios en español | 1 pt |
| **Total** | | **10 pts** |

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| `KeyError` al acceder | Usó `member["clave"]` sin verificar con `in` | Mostrar `member.get("clave")` y preguntar: «¿qué pasa si la clave no existe?». |
| Usa `append()` sobre el diccionario | Confunde dict con lista | Dict no tiene orden numérico; se agrega con `dict["nueva_clave"] = valor`. |
| Usa `.keys()[0]` | Cree que `keys()` devuelve lista | Mostrar `type(member.keys())` → `dict_keys`. Convertir con `list(member.keys())`. |
| Modifica clave en vez de valor | `member["name"] = member["name"].upper()` — confunde clave con valor | Preguntar «¿cuál es la clave y cuál es el valor?» y dibujar el par. |
| Recorre con `for k in member` y no usa `.items()` | Funciona pero pierde el valor | Es correcto (recorre claves), pero para mostrar clave+valor conviene `.items()`. |
| `del member["clave"]` sin verificar | `KeyError` si la clave no existe | Usar `pop(clave, None)` que nunca lanza error. |

## 6. Registro de la clase

**Para cada grupo o estudiante, registrar:**

- ¿Crearon el diccionario vacío con `{}` o intentaron con `set()`?
- ¿Usaron `in` para verificar existencia antes de acceder?
- ¿Usaron `pop()` con segundo argumento o `del`?

**Para la evaluación de proceso:**

- Quiénes llegaron a la extensión «lista de diccionarios» (puente hacia el TP-U2).
- Dificultades con la diferencia entre clave y valor.
- Anotar confusiones entre `{}` (dict) y `set()` (set) para retomar en el cierre U2 (encuentro 14).
