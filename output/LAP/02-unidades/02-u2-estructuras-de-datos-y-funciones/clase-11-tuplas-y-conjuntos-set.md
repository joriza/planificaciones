# Encuentro 11 — Tuplas y conjuntos (set)

> Estructuras de datos y funciones · Unidad 2

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 11 de 36 |
| Unidad | 2 — Estructuras de datos y funciones |
| Eje temático | 2 — Estructuras de datos y funciones |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 120 minutos (2 horas reloj) |
| Concepto nuevo | Tuplas y conjuntos (set) |
| Requisitos previos | Listas: creación, `append`, `pop`, `index`, `sort`, acceso por índice, mutabilidad, slicing. Todo del encuentro 10. |
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

1. Crear tuplas con `()` y explicar por qué son inmutables.
2. Crear conjuntos con `{}` y `set()`, y entender que no tienen duplicados ni orden fijo.
3. Elegir entre `list`, `tuple` y `set` según el problema (mutabilidad, unicidad, orden).
4. Usar `add`, `remove`, `in` y `len` sobre conjuntos.
5. Convertir entre tipos de colección según la necesidad.

## 3. Teoría mínima (20 min)

### Charla rápida: la bandeja de herramientas

Imaginá que el club tiene tres tipos de registros:

- **Lista** (pizarrón): los socios activos, se modifican todos los días (mutables, orden importa).
- **Tupla** (foto impresa): las categorías de socio fijas — «menor», «adulto», «vitalicio». No se modifican nunca.
- **Set** (canasta de pelotas): los números de credenciales que ya se entregaron. No nos importa el orden, solo no repetir.

Cada estructura es la mejor para un trabajo distinto.

### Lo mínimo indispensable

**Tupla (`tuple`):** secuencia **inmutable** entre paréntesis. No se puede modificar después de creada.

```python
# Las categorías de socio siempre son las mismas
categories = ("menor", "adulto", "vitalicio")
print(categories[0])      # "menor" — acceso por índice sí funciona
# categories[0] = "infantil"   # TypeError: tuple no admite asignación
```

**Conjunto (`set`):** colección **sin duplicados ni orden fijo**, entre llaves.

```python
# Números de credencial ya entregados — sin repetir
issued_ids = {101, 105, 103, 101}  # el 101 repetido se ignora
print(issued_ids)  # {101, 103, 105} — orden no garantizado

issued_ids.add(110)
issued_ids.remove(105)
print(105 in issued_ids)  # False
print(len(issued_ids))    # 3
```

⚠ **Crear set vacío:** no se usa `{}` vacío (eso es un diccionario). Usar `set()`.

**Conversión entre colecciones:**

```python
names_list = ["Ana", "Luis", "Ana"]  # lista con duplicado
names_set = set(names_list)           # {"Ana", "Luis"} — sin duplicados
names_unique_list = list(names_set)   # ["Ana", "Luis"]
```

**Criterio de elección:**

| Necesito | Uso | Razón |
| --- | --- | --- |
| Modificar, orden importa | `list` | Mutable, ordenada |
| No modificar nunca | `tuple` | Inmutable, segura |
| Sin duplicados, orden no importa | `set` | Unicidad automática |

## 4. Práctica guiada (35 min)

Armamos un programa que trabaja con datos del club usando las tres estructuras.

**Paso 1:** crear `club_collections.py` y escribir:

```python
# === Tuplas: categorías fijas ===
categories = ("menor", "adulto", "vitalicio")
print("Categorías de socio (tupla):", categories)
print("Primera categoría:", categories[0])

# Intentar modificar (esto va a fallar, lo vemos comentado)
# categories[1] = "senior"   # TypeError

# === Lista: socios activos ===
active_members = ["Ana García", "Luis Pérez", "Sofía Martínez"]
print("\nSocios activos (lista):", active_members)
active_members.append("Carlos López")
print("Después de agregar:", active_members)

# === Set: números de credencial ya emitidos ===
issued_ids = {101, 105, 103, 107}
print("\nCredenciales emitidas (set):", issued_ids)

# Agregar nuevas credenciales
issued_ids.add(110)
issued_ids.add(103)  # duplicado, se ignora
print("Después de agregar 110 y 103 (duplicado):", issued_ids)

# Verificar si una credencial ya fue emitida
check_id = 103
if check_id in issued_ids:
    print(f"La credencial {check_id} ya fue emitida.")
else:
    print(f"La credencial {check_id} está disponible.")

# Eliminar una credencial
issued_ids.remove(107)
print("Después de eliminar 107:", issued_ids)

# === Conversión: lista de nombres sin duplicados ===
names_with_dupes = ["Ana", "Luis", "Ana", "Sofía", "Luis"]
unique_names = list(set(names_with_dupes))
print("\nNombres originales (con duplicados):", names_with_dupes)
print("Nombres únicos (set → list):", unique_names)

# === Mostrar cantidad de cada colección ===
print(f"\nCantidad de categorías: {len(categories)}")
print(f"Cantidad de socios activos: {len(active_members)}")
print(f"Cantidad de credenciales emitidas: {len(issued_ids)}")
```

**Paso 2:** ejecutá con `python club_collections.py`.

**Salida esperada:**

```
Categorías de socio (tupla): ('menor', 'adulto', 'vitalicio')
Primera categoría: menor

Socios activos (lista): ['Ana García', 'Luis Pérez', 'Sofía Martínez']
Después de agregar: ['Ana García', 'Luis Pérez', 'Sofía Martínez', 'Carlos López']

Credenciales emitidas (set): {101, 103, 105, 107}
Después de agregar 110 y 103 (duplicado): {101, 103, 105, 107, 110}
La credencial 103 ya fue emitida.
Después de eliminar 107: {101, 103, 105, 110}

Nombres originales (con duplicados): ['Ana', 'Luis', 'Ana', 'Sofía', 'Luis']
Nombres únicos (set → list): ['Ana', 'Luis', 'Sofía']

Cantidad de categorías: 3
Cantidad de socios activos: 4
Cantidad de credenciales emitidas: 4
```

## 5. Ejercicio independiente (25 min)

**Consigna:** Escribí un programa `club_registry.py` que:

1. Cree una tupla `months` con los nombres de los meses del año (no se modifica nunca).
2. Cree una lista `member_names` con los nombres: `"Ana"`, `"Luis"`, `"Sofía"`, `"Carlos"`, `"Ana"`.
3. Convierta la lista a un set (`unique_names`) para eliminar el duplicado.
4. Agregue un nombre nuevo al set (pedilo por `input()`).
5. Muestre cuántos nombres únicos hay.
6. Pregunte un nombre y diga si está en el set de nombres únicos.

**Pista:** para que el set funcione bien, después de `set(lista)` usá `add()` para agregar y `in` para preguntar.

## 6. Extensión y consolidación (20 min)

1. **Unión de sets:** creá dos sets `set_a = {1, 2, 3}` y `set_b = {3, 4, 5}`. Mostrá la unión (`set_a | set_b`) y la intersección (`set_a & set_b`).
2. **Tupla como clave segura:** mostrá que una tupla puede usarse como elemento de un set (un `list` no puede).
3. **Eliminación segura en set:** usá `discard()` en vez de `remove()` para eliminar un elemento que quizá no existe (probá con uno existente y uno inexistente).

## 7. Cierre (10 min)

### Qué te llevás

- **Tupla:** inmutable, para datos que no cambian. Acceso por índice igual que lista.
- **Set:** sin duplicados, sin orden fijo. Se crea con `{}` o `set()`. Set vacío solo con `set()`.
- Para decidir: ¿lo modifico? → `list`. ¿No cambia nunca? → `tuple`. ¿Solo quiero saber si está o no está? → `set`.
- `len()` funciona en las tres; `in` también.

### Lo que viene

**Encuentro 12: Diccionarios: clave y valor**

## 8. Errores comunes y trampas

| Error | Causa | Fix |
| --- | --- | --- |
| `t[0] = x` sobre una tupla | La tupla es inmutable: `TypeError` | Usar lista si necesitás modificar, o crear una tupla nueva |
| Crear set vacío con `{}` | `{}` vacío es un diccionario, no un set | Usar `my_set = set()` para set vacío |
| Pensar que un set tiene orden | `set` no garantiza orden; en cada ejecución puede variar | Pasar a `list()` si necesitás orden, o usar `sorted()` |
| Usar `remove()` en un set con elemento inexistente | `KeyError` | Usar `discard()` que no lanza error si no existe, o verificar con `in` antes |
| Confundir `(1)` con una tupla | `(1)` es un `int`, no una tupla de un elemento | La tupla de un elemento necesita coma: `(1,)` |
| Meter una lista dentro de un set | Las listas no son "hashables": `TypeError` | Usar tupla en vez de lista dentro del set |