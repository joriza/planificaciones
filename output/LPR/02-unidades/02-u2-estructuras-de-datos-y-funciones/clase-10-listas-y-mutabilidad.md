# Encuentro 10 — Listas y mutabilidad

> Estructuras de datos y funciones · Unidad 2

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 10 de 36 |
| Unidad | 2 — Estructuras de datos y funciones |
| Eje temático | 2 — Estructuras de datos y funciones |
| Carácter/Objetivo | Conceptual |
| Estructura | clase |
| Duración teórica | 120 minutos (2 horas reloj) |
| Concepto nuevo | Listas y mutabilidad |
| Requisitos previos | Variables y tipos (`int`, `float`, `str`, `bool`), entrada por `input()`, conversión con `int()`/`float()`, estructura `if-else`, bucle `for` sobre rangos y cadenas, operadores `in` y `not in`. Todo visto en la Unidad 1. |
| Uso de celular | No permitido |
| Organización del trabajo | Individual con monitor, o en parejas si alcanzan las máquinas. Cada estudiante escribe su propio archivo `.py`. Rotación de monitor cada 20 minutos en parejas. |

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

1. Crear una lista con literales y agregar elementos con `append`.
2. Acceder a elementos por índice y eliminar el último con `pop`.
3. Buscar la posición de un elemento con `index` y ordenar con `sort`.
4. Distinguir entre tipos mutables (lista) e inmutables (`str`, `tuple`).
5. Usar slicing `[i:j]` sobre listas y cadenas.

## 3. Teoría mínima (20 min)

### Charla rápida: el pizarrón y la foto

Imaginate que tenés la lista de socios del club anotada en un pizarrón con tiza. Podés borrar un nombre, agregar otro al final, cambiar el orden. Eso es una **lista**: podés modificarla después de crearla. Ahora imagine esa misma lista impresa en una foto: no podés tachar ni agregar nombres sin sacar otra foto. Eso es un tipo inmutable como el `str` o la `tuple`. Hoy manejamos el pizarrón.

### Lo mínimo indispensable

**Lista (`list`):** secuencia mutable de elementos separados por coma entre corchetes.

```python
member_names = ["Ana", "Luis", "Sofía"]
```

**Métodos básicos (todas mutan la lista y devuelven `None`):**

| Operación | Código | Efecto |
| --- | --- | --- |
| Agregar al final | `member_names.append("Pedro")` | Lista crece |
| Sacar el último | `popped = member_names.pop()` | Devuelve el elemento y lo borra |
| Buscar posición | `pos = member_names.index("Luis")` | Devuelve índice 0-based |
| Ordenar | `member_names.sort()` | Ordena ascendente, modifica la lista |

**Regla de oro:** `append`, `pop`, `index`, `sort` **no devuelven la lista**. Esto:

```python
# MAL — append devuelve None, la lista se pierde
member_names = member_names.append("Pedro")

# BIEN
member_names.append("Pedro")
```

**Mutabilidad:** una lista cambia "en el lugar". Un `str` no:

```python
name = "Ana"
# name[0] = "B"  # TypeError: el str es inmutable
name = "Bet" + name[1:]  # Hay que construir uno nuevo
```

**Slicing `[i:j]`:** obtiene un subsegmento desde `i` hasta `j-1`. Funciona en listas y strings. Índices fuera de rango no lanzan error, devuelven lo disponible.

```python
items = [10, 20, 30, 40, 50]
sub = items[1:4]   # [20, 30, 40]
first = items[:3]  # [10, 20, 30]
last = items[-2:]  # [40, 50]
```

## 4. Práctica guiada (35 min)

Armamos juntos un programa que administra la lista de socios del club de barrio.

**Paso 1:** crear el archivo `club_members.py` y escribir el programa completo.

```python
# Lista inicial de socios
member_names = ["Ana García", "Luis Pérez", "Sofía Martínez", "Carlos López"]

print("=== Club de Barrio — Lista de socios ===")
print("Socios actuales:", member_names)

# --- Agregar un socio ---
print("\nAgregamos un nuevo socio...")
member_names.append("María Torres")
print("Después de append:", member_names)

# --- Buscar posición ---
print("\nBuscamos la posición de 'Luis Pérez'...")
position = member_names.index("Luis Pérez")
print(f"Luis Pérez está en la posición {position}")

# --- Sacar el último ---
print("\nEl secretario pidió borrar el último socio...")
removed = member_names.pop()
print(f"Sacamos a: {removed}")
print("Lista actual:", member_names)

# --- Ordenar alfabéticamente ---
print("\nOrdenamos la lista...")
member_names.sort()
print("Lista ordenada:", member_names)

# --- Slicing: primeros 2 socios ---
print("\nPrimeros 2 socios (slicing):", member_names[:2])

# --- Mostrar cantidad ---
print(f"\nTotal de socios: {len(member_names)}")
```

**Paso 2:** ejecutalo con `python club_members.py`.

**Salida esperada:**

```
=== Club de Barrio — Lista de socios ===
Socios actuales: ['Ana García', 'Luis Pérez', 'Sofía Martínez', 'Carlos López']

Agregamos un nuevo socio...
Después de append: ['Ana García', 'Luis Pérez', 'Sofía Martínez', 'Carlos López', 'María Torres']

Buscamos la posición de 'Luis Pérez'...
Luis Pérez está en la posición 1

El secretario pidió borrar el último socio...
Sacamos a: María Torres
Lista actual: ['Ana García', 'Luis Pérez', 'Sofía Martínez', 'Carlos López']

Ordenamos la lista...
Lista ordenada: ['Ana García', 'Carlos López', 'Luis Pérez', 'Sofía Martínez']

Primeros 2 socios (slicing): ['Ana García', 'Carlos López']

Total de socios: 4
```

**Paso 3:** probá mutabilidad. Agregá estas líneas al final y observá:

```python
# Demostración de mutabilidad: la lista cambia "en el lugar"
original = member_names[:]  # copia con slicing
member_names.append("Nuevo socio")
print(f"Lista original después de append: {original}")  # no cambió
print(f"Lista actual: {member_names}")
```

## 5. Ejercicio independiente (25 min)

**Consigna:** Escribí un programa `member_ages.py` que trabaje con las edades de los socios del club.

1. Creá una lista llamada `ages` con las edades: 17, 15, 18, 16, 19.
2. Mostrá la lista completa.
3. Preguntá al usuario qué edad quiere agregar (usá `input()` + `int()` dentro de `try/except`).
4. Agregá la nueva edad con `append` y mostrá la lista actualizada.
5. Ordená la lista y mostrá el resultado.
6. Usá `pop()` para sacar la última edad y mostrá cuál se fue.
7. Mostrá la edad que está en la posición 2 (tercer elemento) usando índice.

**Pista:** recordá que `input()` devuelve `str`. Convertí con `int()` atrapando `ValueError`.

**Solución:** en el anexo docente.

## 6. Extensión y consolidación (20 min)

Si terminás el ejercicio base, probá estas variaciones:

1. **Edad máxima y mínima:** usá `max(ages)` y `min(ages)` para mostrar la edad más grande y la más chica.
2. **Slice de mayores:** mostrá las últimas 3 edades de la lista ordenada con slicing.
3. **Lista de nombres:** partiendo de `"Ana,Luis,Sofía,Carlos"` usá `split(",")` para generar una lista, agregale un nombre y mostrá el resultado.
4. **Mutabilidad vs string:** mostrá que no podés hacer `"Hola"[0] = "h"` y por qué.

## 7. Cierre (10 min)

### Qué te llevás

- Las listas se crean con `[]`, se modifican con `append`, `pop`, `sort`.
- `append`, `pop`, `sort` **no devuelven la lista** — se usan solos en una línea.
- Los strings son inmutables: no podés cambiarles un carácter, tenés que construir uno nuevo.
- El slicing `[i:j]` funciona en listas y strings, y los índices fuera de rango no rompen.

### Lo que viene

**Encuentro 11: Tuplas y conjuntos (set)**

## 8. Errores comunes y trampas

| Error | Causa | Fix |
| --- | --- | --- |
| `lista = lista.append(x)` | `append` devuelve `None` y muta la lista; reasignar la pierde | `lista.append(x)` en su propia línea |
| `lista = lista.sort()` | `sort()` muta y devuelve `None`, igual que `append` | `lista.sort()` solo, sin asignación |
| `s[0] = "H"` sobre un `str` | El `str` es inmutable — `TypeError` | Construir nueva cadena con slicing: `"H" + s[1:]` |
| Poner índice fuera de rango al acceder | Ejemplo: `items[10]` en lista de 5 elementos — `IndexError` | Verificar con `len(items)` o usar slicing que tolera rangos fuera de límite |
| Olvidar que `input()` devuelve `str` | Sumar `input()` + número: concatena en vez de sumar | Convertir con `int(input(...))` dentro de `try/except ValueError` |
| Confundir posición con contenido | `items.index(30)` busca el valor 30, no la posición 30 | `index` busca por valor; para acceder por posición se usa `items[pos]` |
