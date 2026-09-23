# Encuentro 21 — Cadenas: métodos de texto

> Procesamiento de texto y validación

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 21 de 36 |
| Unidad | 3 — Procesamiento de texto y validación |
| Eje temático | 3 — Procesamiento de texto y validación |
| Carácter/Objetivo | Conceptual |
| Estructura | clase |
| Duración teórica | 120 minutos (2 horas) |
| Concepto nuevo | Cadenas: métodos de texto |
| Requisitos previos | Encuentros 1–20: variables, input/output, funciones, listas y diccionarios |
| Uso de celular | No permitido |
| Organización del trabajo | Trabajo individual en terminal; el docente circula y acompaña a quienes lo necesiten |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y puente | 10 min |
| Teoría mínima | 20 min |
| Práctica guiada | 35 min |
| Ejercicio independiente | 25 min |
| Extensión y consolidación | 20 min |
| Cierre | 10 min |
| **Total** | **120 min** |

## 2. Objetivos de aprendizaje

1. Procesar texto de entrada con `split`, `strip`, `join` y `replace` para extraer datos estructurados.
2. Aplicar f-strings con formato numérico (`:.2f`) para mostrar resultados con precisión.
3. Combinar métodos de cadenas con funciones para parsear líneas de entrada del usuario.
4. Distinguir entre métodos que devuelven una nueva cadena y los que no modifican la original.

## 3. Teoría mínima (20 min)

### Charla rápida: el colador de texto

Imaginate que tenés una frase escrita en un papel arrugado. `strip()` es como pasarla por una plancha: te saca los bordes sucios (espacios al inicio y al final). `split()` es como un colador: separa la frase en trozos (palabras) dejando que los espacios caigan. `join()` es lo contrario: tomás esos trozos y los unís con un hilo (un separador) que vos elegís. `replace()` es como una goma mágica que busca una palabra y la reemplaza por otra. Y los f-strings son el formato del menú del restaurante: ponés los valores adentro de las llaves y el resultado sale bien armado.

### Lo mínimo indispensable

- `str.split(sep=None)`: divide la cadena en una lista de subcadenas usando `sep` como separador; si `sep` es `None`, cualquier espacio en blanco cuenta y los repetidos se colapsan (spike 9.9).
- `str.strip()`: devuelve una copia sin espacios (u otros caracteres) en los bordes; no modifica la original porque `str` es inmutable (spike 9.3).
- `str.join(iterable)`: une los elementos de `iterable` con la cadena como separador y devuelve el resultado.
- `str.replace(old, new)`: reemplaza todas las ocurrencias de `old` por `new` y devuelve la nueva cadena.
- f-strings: `f"{valor:.2f}"` formatea un número con dos decimales; `f"{texto}"` inserta el valor de una variable dentro del texto.

## 4. Práctica guiada (35 min)

**Paso 1** — Abrí VS Code, creá un archivo llamado `procesar_texto.py` y escribí el siguiente código:

```python
# procesar_texto.py
# Programa que pide una frase al usuario y la procesa con métodos de cadena.

def procesar_frase(frase):
    # Quita espacios al inicio y al final de la frase.
    limpia = frase.strip()
    # Divide la frase en una lista de palabras.
    palabras = limpia.split()
    # Une las palabras con un guión como separador.
    con_guion = "-".join(palabras)
    # Reemplaza espacios por guiones bajos en la versión original.
    con_guion_bajo = limpia.replace(" ", "_")
    return palabras, con_guion, con_guion_bajo


def mostrar_resultados(palabras, con_guion, con_guion_bajo):
    # Muestra los resultados del procesamiento con f-strings.
    print(f"Cantidad de palabras: {len(palabras)}")
    print(f"Con guiones: {con_guion}")
    print(f"Con guiones bajos: {con_guion_bajo}")


if __name__ == "__main__":
    # Bloque de ejecución principal: se pide la frase al usuario.
    entrada = input("Ingresá una frase: ")
    palabras, con_guion, con_guion_bajo = procesar_frase(entrada)
    mostrar_resultados(palabras, con_guion, con_guion_bajo)
```

**Paso 2** — Ejecutá el programa y probá con la entrada `  hola mundo desde python  `. La salida esperada es:

```
Cantidad de palabras: 4
Con guiones: hola-mundo-desde-python
Con guiones bajos: hola_mundo_desde_python
```

**Paso 3** — Modificá el programa para que también cuente y muestre la longitud total de la frase sin espacios. Agregá una línea en `mostrar_resultados`:

```python
    print(f"Longitud sin espacios: {len(con_guion_bajo)}")
```

## 5. Ejercicio independiente (25 min)

**Consigna:** Escribí un programa llamado `formato_moneda.py` que pida al usuario el nombre de un producto y su precio (como número decimal), y muestre una línea formateada con el nombre en mayúsculas y el precio con dos decimales y signo de dólar. Pista: usá `upper()` para convertir a mayúsculas y `f"{precio:.2f}"` para el formato.

**Solución esperada:**

```python
# formato_moneda.py
# Pide un producto y su precio, y muestra una línea formateada.

def formatear_producto():
    # Lee el nombre del producto y lo limpia de bordes.
    nombre = input("Nombre del producto: ").strip()
    # Lee el precio como float dentro de un try/except para validar.
    try:
        precio = float(input("Precio: "))
    except ValueError:
        print("El precio debe ser un número.")
        return
    # Muestra el producto formateado con mayúsculas y precio con dos decimales.
    print(f"PRODUCTO: {nombre.upper()} — Precio: ${precio:.2f}")


if __name__ == "__main__":
    formatear_producto()
```

**Salida esperada** (con entrada `café` y `150`):

```
PRODUCTO: CAFÉ — Precio: $150.00
```

## 6. Extensión y consolidación (20 min)

**Actividad 1 — Reemplazo de palabras prohibidas:** Agregá al programa `procesar_texto.py` una función `censurar(texto, palabra)` que use `replace()` para reemplazar una palabra por asteriscos de la misma longitud. Probadlo con la frase `"este mensaje es secreto"` y la palabra `"secreto"`.

**Actividad 2 — Formatos numéricos:** Experimentá con f-strings: probá `f"{3.14159:.1f}"`, `f"{3.14159:.3f}"` y `f"{1000:,}"` (separador de miles) y anotá qué produce cada uno.

## 7. Cierre (10 min)

### Qué te llevás

- `split()` divide una cadena en lista; `strip()` quita bordes; `join()` une elementos con un separador; `replace()` intercadena subcadenas.
- Los f-strings permiten formatear números con `:.2f` y otros formatos directamente dentro del texto.
- `str` es inmutable: todos los métodos devuelven una nueva cadena, no modifican la original.

### Lo que viene

En el próximo encuentro vamos a usar `try/except` para que los programas no se rompan cuando el usuario tipea algo que no es un número.

## 8. Errores comunes y trampas

1. **`lista = lista.split()`** — `split()` devuelve una lista nueva, no muta la cadena original. Asigná el resultado en la misma línea o en una variable nueva.
2. **Confundir `join` con `split`** — `join` es un método de la cadena separador (`"-".join(lista)`), no de la lista. Llamarlo sobre la lista genera `AttributeError`.
3. **Esperar que `strip()` quite caracteres internos** — `strip()` solo actúa en los bordes; para quitar caracteres en medio usá `replace()`.
4. **Usar `+` para concatenar en mensajes al usuario** — Los f-strings son más legibles y evitan errores de tipo; usá `f"Total: {total}"` en vez de `"Total: " + str(total)`.
5. **Olvidar que `input()` siempre devuelve `str`** — Si necesitás un número, convertí con `int()` o `float()` dentro de `try/except ValueError`.
