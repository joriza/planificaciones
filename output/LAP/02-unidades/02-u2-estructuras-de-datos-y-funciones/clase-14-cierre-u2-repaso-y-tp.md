# Encuentro 14 — Cierre U2: repaso y TP

> Estructuras de datos y funciones · Encuentro de cierre de unidad

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 14 de 36 |
| Unidad | 2 — Estructuras de datos y funciones |
| Eje temático | 2 — Estructuras de datos y funciones |
| Carácter/Objetivo | Actitudinal |
| Estructura | cierre |
| Duración teórica | 120 minutos (2 horas reloj) |
| TP obligatorio | TP-U2: programa con colecciones y funciones |
| Concepto nuevo | Cierre U2: repaso y TP |
| Requisitos previos | Listas, tuplas, sets, diccionarios, funciones, ámbito local, `if __name__ == "__main__"`. Todo de los encuentros 10-13. |
| Uso de celular | No permitido |
| Organización del trabajo | Individual o en parejas (misma modalidad que el curso). Cada estudiante produce su propio archivo en su carpeta `tp-u2/` del repositorio grupal. |

### Reparto de tiempos

| Momento | Tiempo |
| --- | --- |
| Apertura | 10 min |
| Consolidación | 40 min |
| Trabajo del TP | 45 min |
| Ciclo de entrega | 15 min |
| Cierre | 10 min |
| **Total** | **120 min** |

## 2. Objetivos de aprendizaje

Al finalizar este encuentro vas a poder:

1. Sistematizar las cuatro colecciones de la Unidad 2 (list, tuple, set, dict) y saber cuándo usar cada una.
2. Descomponer un problema de dominio en funciones con `def`, parámetros y `return`.
3. Armar un programa completo con menú, colecciones y funciones.
4. Entregar el TP-U2 siguiendo la rutina de Git: carpeta nueva, commits y push.

## 3. Apertura (10 min)

### Charla rápida: el club entero en un programa

En los últimos cuatro encuentros aprendiste cuatro herramientas para organizar datos:

- **Listas** — la guía de socios (se modifica, orden importa).
- **Tuplas** — las categorías fijas (no cambian nunca).
- **Sets** — las credenciales emitidas (sin duplicados).
- **Diccionarios** — la ficha de cada socio (clave → valor).

Y con funciones (`def`) aprendiste a empaquetar cada tarea en un bloque reutilizable.

Hoy juntamos todo en el **TP-U2**: un programa que administra los socios de un club de barrio, con menú, colecciones y funciones. Y lo entregás con carpeta nueva, commit y push, como ya sabés hacer desde el encuentro 8.

### Mapa de la Unidad 2

| Tipo | Colección | Métodos clave | Mutabilidad |
| --- | --- | --- | --- |
| Secuencia mutable | `list` | `append`, `pop`, `index`, `sort` | ✅ Mutable |
| Secuencia inmutable | `tuple` | Acceso por índice | ❌ Inmutable |
| Conjunto | `set` | `add`, `remove`, `discard`, `in` | ✅ Mutable (elementos únicos) |
| Mapeo | `dict` | `keys`, `values`, `items`, `get`, `pop` | ✅ Mutable |

## 4. Consolidación (40 min)

### Repaso exprés con ejercicios cortos

Escribí en un archivo `review_u2.py` y ejecutá cada fragmento. No copies todo de una vez: escribí, ejecutá, entendé.

**1. Lista — filtrar mayores de 16:**

```python
ages = [17, 15, 18, 16, 19, 14]
old_enough = []
for age in ages:
    if age >= 16:
        old_enough.append(age)
print("Mayores o igual a 16:", old_enough)
```

**2. Set — eliminar duplicados de una lista:**

```python
names = ["Ana", "Luis", "Ana", "Sofía", "Luis", "Carlos"]
unique = set(names)
print("Nombres únicos:", unique)
print("Cantidad de nombres distintos:", len(unique))
```

**3. Diccionario — buscar y mostrar:**

```python
member = {"name": "Ana", "age": 17, "fee_paid": True}
search_key = input("Clave a buscar: ")

# Acceso seguro
value = member.get(search_key, "Clave no encontrada")
print(f"Valor de '{search_key}': {value}")
```

**4. Tupla como estructura fija:**

```python
def get_coordinates():
    """Devuelve un par (x, y) como tupla."""
    return (10, 20)

point = get_coordinates()
print(f"Coordenada X: {point[0]}, Y: {point[1]}")
```

**5. Función que usa un diccionario:**

```python
def count_by_category(members):
    """Recibe un dict nombre→categoría, devuelve dict conteo."""
    counts = {}
    for name, category in members.items():
        if category in counts:
            counts[category] += 1
        else:
            counts[category] = 1
    return counts


if __name__ == "__main__":
    data = {"Ana": "menor", "Luis": "menor", "Sofía": "adulto", "Carlos": "vitalicio"}
    result = count_by_category(data)
    print("Conteo por categoría:", result)
```

## 5. Trabajo del TP (45 min)

### TP-U2: Administración del club de barrio

**Dominio:** club de barrio — socios, cuotas, categorías, credenciales.

Escribí un programa `main.py` dentro de una carpeta `tp-u2/` (creala si no existe) que tenga **funciones** arriba y **bloque principal** abajo, con un menú interactivo.

**Requisitos funcionales:**

1. El programa arranca con algunos socios precargados (mínimo 3) en un diccionario donde cada clave es el nombre y cada valor es otro diccionario con edad, categoría y cuota al día (bool).
2. Menú con estas opciones:
   - **1. Ver todos los socios:** muestra nombre, edad, categoría y estado de cuota.
   - **2. Agregar socio:** pide nombre, edad, categoría (menor/adulto/vitalicio) y si pagó (sí/no → bool).
   - **3. Buscar socio:** pide nombre, muestra todos sus datos o dice "no encontrado".
   - **4. Dar de baja:** elimina un socio por nombre (con confirmación de si existía).
   - **5. Socios con cuota al día:** muestra solo los que pagaron.
   - **6. Salir.**
3. Cada opción del menú debe estar implementada en una función separada.
4. Validación de entrada numérica con `read_int` (como en el encuentro 13).
5. El programa no usa archivos ni persistencia: los datos viven en memoria mientras se ejecuta.

**Entrega:** carpeta `tp-u2/` con el archivo `main.py`, commit con mensaje `tp-u2: programa con colecciones y funciones`, y push al repositorio grupal.

**Pista:** pensá la estructura de datos primero. Un diccionario de diccionarios te permite buscar por nombre sin recorrer:

```python
club = {
    "Ana García": {"age": 17, "category": "menor", "fee_paid": True},
    "Luis Pérez": {"age": 15, "category": "menor", "fee_paid": False},
    "Sofía Martínez": {"age": 18, "category": "adulto", "fee_paid": True}
}
```

## 6. Ciclo de entrega (15 min)

### Rutina de Git (recordatorio breve)

Ya la conocés del encuentro 8. Repaso rápido:

```bash
# 1. Asegurate de estar en la carpeta del repositorio
cd /ruta/al/repo

# 2. Creá la carpeta del TP (si no existe)
mkdir tp-u2

# 3. Copiá o creá tu main.py adentro

# 4. Agregá todo y commit
git add .
git commit -m "tp-u2: programa con colecciones y funciones"

# 5. Subí a GitHub
git push
```

**Antes del commit**, verificá:

- [ ] El archivo compila con `python tp-u2/main.py`.
- [ ] El menú muestra las 6 opciones y responde a cada una.
- [ ] Probaste: agregar socio, buscar, dar de baja, filtrar por cuota al día.
- [ ] Probaste: poner texto donde va un número (el programa no debe romperse).
- [ ] Probaste: buscar un socio que no existe.

## 7. Cierre (10 min)

### Qué te llevás de la Unidad 2

- **Cuatro colecciones** para organizar datos: listas (mutables), tuplas (inmutables), sets (únicos), diccionarios (clave→valor).
- **Funciones** para descomponer problemas: `def`, parámetros, `return`, ámbito local.
- **Organización profesional**: funciones primero, `if __name__ == "__main__":` al final.
- **Validación**: `try/except ValueError` para entrada numérica, `in` y `.get()` para diccionarios.
- **Rutina Git:** carpeta por trabajo, commit por entrega, push a GitHub.

### Lo que viene

**Encuentro 15: Evaluación de la Unidad 2**

## 8. Errores comunes y trampas

| Error | Causa | Fix |
| --- | --- | --- |
| Usar lista de diccionarios en vez de dict de dicts para búsqueda | Recorrer una lista para buscar un socio es más lento y verboso | Usar `dict` anidado: nombre como clave facilita búsqueda directa |
| No validar entrada numérica en edad | `input()` devuelve str; comparar con `int` no funciona o suma mal | Usar `read_int()` con `try/except ValueError` |
| Olvidar `break` en el menú | El bucle nunca termina aunque el usuario elija "Salir" | `while True` + `if opcion == 6: break` |
| Mezclar `{}` para set y dict | Creer que `{}` vacío es un set | `{}` es dict vacío; `set()` es set vacío |
| No manejar `KeyError` al buscar socio | Usar `club[nombre]` sin verificar `in` | Usar `.get(nombre)` o `if nombre in club:` |
| Asignar resultado de `append` o `sort` | `lista = lista.append(x)` → pierde la lista | Usar `lista.append(x)` en su propia línea |