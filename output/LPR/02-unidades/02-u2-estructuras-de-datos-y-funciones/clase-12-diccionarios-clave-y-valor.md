# Encuentro 12 — Diccionarios: clave y valor

> Estructuras de datos y funciones · Unidad 2

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 12 de 36 |
| Unidad | 2 — Estructuras de datos y funciones |
| Eje temático | 2 — Estructuras de datos y funciones |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 120 minutos (2 horas reloj) |
| Concepto nuevo | Diccionarios: clave y valor |
| Requisitos previos | Listas, tuplas y conjuntos (set): creación, métodos, criterio de elección. Todo de los encuentros 10 y 11. |
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

1. Crear un diccionario con pares clave-valor entre llaves.
2. Acceder a un valor por su clave con `[]` y `.get()`.
3. Agregar y modificar entradas, y eliminar con `pop` o `del`.
4. Recorrer un diccionario con `keys()`, `values()` e `items()`.
5. Prevenir `KeyError` usando `in` y `.get()`.

## 3. Teoría mínima (20 min)

### Charla rápida: la ficha del socio

En el club de barrio, cada socio tiene una ficha con campos: nombre, edad, cuota al día, categoría. En Python, la ficha es un **diccionario**: una colección donde cada **clave** (nombre del campo) apunta a un **valor** (el dato). No importa el orden: busco por la clave y obtengo el valor al instante.

```python
member = {
    "name": "Ana García",
    "age": 17,
    "fee_paid": True,
    "category": "menor"
}
```

Las listas funcionan con índices numéricos; los diccionarios con claves con nombre. Si la lista es una fila de casilleros numerados, el diccionario es un archivero con etiquetas.

### Lo mínimo indispensable

**Crear y acceder:**

```python
member = {"name": "Ana", "age": 17}
print(member["name"])      # Ana
print(member.get("age"))       # 17
print(member.get("email", "-"))  # "-" — valor por defecto si no existe
```

**⚠ `member["clave_inexistente"]` lanza `KeyError`.** Siempre verificar con `in` o usar `.get()`.

**Agregar, modificar y eliminar:**

```python
member["phone"] = "11-5555-1234"  # agregar nueva clave
member["age"] = 18                # modificar existente
del member["phone"]               # eliminar una clave
popped = member.pop("age")        # eliminar y devolver el valor
```

**Recorridos:**

```python
# keys, values, items devuelven vistas (como sets)
for key in member.keys():
    print(key)

for value in member.values():
    print(value)

for key, value in member.items():
    print(f"{key}: {value}")
```

**Diccionario vacío:**

```python
members = {}    # diccionario vacío — esto SÍ es un dict
```

## 4. Práctica guiada (35 min)

Armamos un programa que administra los socios del club usando diccionarios.

**Paso 1:** crear `club_dict.py` y escribir:

```python
# === Diccionario de un socio ===
member = {
    "name": "Ana García",
    "age": 17,
    "fee_paid": True,
    "category": "menor"
}

print("=== Ficha del socio ===")
# Acceso directo (sabemos que existe)
print("Nombre:", member["name"])
print("Edad:", member["age"])

# Acceso seguro con .get()
status = member.get("fee_paid", "No especificado")
print("Cuota al día:", status)

# === Agregar nueva clave ===
member["phone"] = "11-5555-1234"
print("\nDespués de agregar teléfono:")
print("Teléfono:", member["phone"])

# === Modificar un valor ===
member["age"] = 18
print("Edad actualizada:", member["age"])

# === Recorrer con items() ===
print("\n=== Todos los datos del socio ===")
for key, value in member.items():
    print(f"  {key}: {value}")

# === Prevenir KeyError ===
print("\n=== Búsqueda segura ===")
if "email" in member:
    print("Email:", member["email"])
else:
    print("El socio no tiene email registrado.")

# === Eliminar con pop ===
removed = member.pop("phone", None)
if removed:
    print(f"Teléfono eliminado: {removed}")

# === Mostrar claves y valores por separado ===
print("\nClaves del diccionario:", list(member.keys()))
print("Valores:", list(member.values()))
```

**Paso 2:** ejecutá con `python club_dict.py`.

**Salida esperada:**

```
=== Ficha del socio ===
Nombre: Ana García
Edad: 17
Cuota al día: True

Después de agregar teléfono:
Teléfono: 11-5555-1234
Edad actualizada: 18

=== Todos los datos del socio ===
  name: Ana García
  age: 18
  fee_paid: True
  category: menor
  phone: 11-5555-1234

=== Búsqueda segura ===
El socio no tiene email registrado.

Claves del diccionario: ['name', 'age', 'fee_paid', 'category', 'phone']
Valores: ['Ana García', 18, True, 'menor', '11-5555-1234']
```

**Paso 3:** modificar un valor existente. Cambiá la categoría:

```python
member["category"] = "adulto"
print("Nueva categoría:", member["category"])
```

## 5. Ejercicio independiente (25 min)

**Consigna:** Escribí un programa `members_directory.py` que administre una lista de socios.

1. Creá un diccionario vacío `members` (la clave será el nombre, el valor será la edad).
2. Agregá tres socios: Ana (17), Luis (15), Sofía (18) — asignando directamente con `members["Ana"] = 17`.
3. Mostrá todos los socios recorriendo con `.items()`.
4. Preguntá un nombre por `input()`. Si existe en el diccionario, mostrá su edad. Si no, decí que no está registrado.
5. Preguntá un segundo nombre y eliminalo del diccionario con `pop()` si existe, o mostrá un mensaje si no.

**Pista:** usá `in` para verificar si un nombre existe antes de acceder con `[]`. `.pop(clave, None)` también es seguro.

## 6. Extensión y consolidación (20 min)

1. **Lista de diccionarios:** creá una lista donde cada socio es un diccionario completo (nombre, edad, categoría, cuota). Recorrela y mostrá cada ficha.
2. **Actualizar valores:** pedí un nombre por `input()` y, si existe, modificá su edad.
3. **Contar categorías:** usando un diccionario adicional, contá cuántos socios hay en cada categoría.

## 7. Cierre (10 min)

### Qué te llevás

- Los diccionarios guardan pares **clave → valor**. La clave es como el nombre del campo.
- Accedé con `dict["clave"]` si sabés que existe; usá `.get("clave", default)` si no estás seguro.
- `keys()`, `values()` e `items()` permiten recorrer el diccionario.
- Para agregar o modificar: `dict["clave"] = valor`. Para eliminar: `pop(clave)` o `del`.
- **Nunca** supongas que una clave existe: usá `in` o `.get()`.

### Lo que viene

**Encuentro 13: Funciones y ámbito local**

## 8. Errores comunes y trampas

| Error | Causa | Fix |
| --- | --- | --- |
| `member["email"]` sin verificar | La clave no existe → `KeyError` | Usar `if "email" in member:` o `member.get("email", "no tiene")` |
| Pensar que las claves tienen orden fijo | Dict preserva orden de inserción desde Python 3.7, pero no es el concepto central | Si necesitás orden alfabético, usá `sorted(member.keys())` |
| Confundir `{}` vacío con set | `{}` es diccionario, no set | Set vacío es `set()`; `{}` es `dict` vacío |
| Usar lista como clave | Las claves deben ser inmutables (`str`, `int`, `tuple`) | Usar str o int como clave |
| Olvidar que `keys()` devuelve una vista, no una lista | `members.keys()[0]` no funciona | Convertir con `list(members.keys())` |
| Usar `del member["clave"]` sin verificar | Si la clave no existe → `KeyError` | Usar `pop("clave", None)` que nunca lanza error |
