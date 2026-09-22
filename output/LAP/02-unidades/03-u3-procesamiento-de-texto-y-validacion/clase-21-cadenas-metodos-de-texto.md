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
| Duración teórica | 120 minutos (2 horas reloj) |
| Concepto nuevo | Cadenas: métodos de texto |
| Requisitos previos | Unidad 2: funciones con `def`/`return`, colecciones (`list`, `dict`, `set`), bloque `if __name__ == "__main__":` |
| Uso de celular | No permitido |
| Organización del trabajo | Grupos de 2 personas, mismas parejas de la U2. Cambio de rol de quien escribe después del ejercicio independiente. |

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

1. Procesar texto de entrada con `split`, `strip`, `join` y `replace` para extraer datos estructurados.
2. Aplicar f-strings con formato numérico (`:.2f`) para mostrar resultados monetarios.
3. Combinar métodos de cadenas con funciones para parsear líneas de entrada del usuario.
4. Distinguir entre métodos que devuelven una nueva cadena y los que no modifican el original.

## 3. Teoría mínima (20 min)

### Charla rápida: la terminal de la pizzería

Imaginate que trabajás en una pizzería y un cliente llama por teléfono para hacer un pedido. Te dicen todo junto: «dos muzza, una napo, una de palmito, y una fugazzeta». Tu cabeza tiene que separar eso en pedazos, sacarle los espacios de más, reconocer cada ítem y armar la comanda. Los métodos de cadena de Python hacen exactamente eso: `split` corta el texto como si fueran las comas de una frase, `strip` limpia los bordes, `join` vuelve a unir, y `replace` cambia una parte por otra.

### Lo mínimo indispensable

**Las cadenas (`str`) son inmutables.** Todo método de cadena devuelve una *nueva* cadena, no modifica la original.

**Métodos canónicos del curso:**

| Método | Qué hace | Ejemplo | Resultado |
| --- | --- | --- | --- |
| `cadena.split()` | Corta por espacios (colapsa repetidos) | `"a  b  c".split()` | `["a", "b", "c"]` |
| `cadena.split(sep)` | Corta por el separador dado | `"a,b,c".split(",")` | `["a", "b", "c"]` |
| `cadena.strip()` | Saca espacios de ambos bordes | `"  hola  ".strip()` | `"hola"` |
| `" ".join(lista)` | Une una lista con separador | `" ".join(["a","b"])` | `"a b"` |
| `cadena.replace(viejo, nuevo)` | Reemplaza todas las ocurrencias | `"1,2,3".replace(",", ".")` | `"1.2.3"` |

**f-strings con formato numérico:**
```python
precio = 12.5
print(f"Total: ${precio:.2f}")  # Total: $12.50
```
El formato `:.2f` fija dos decimales. Útil para montos, precios, resultados financieros.

**Receta canónica para parsear una línea de entrada:**
```python
linea = input("Ingresá los ingredientes separados por coma: ")
# 1. strip para bordes, 2. split para separar
partes = [p.strip() for p in linea.split(",")]
```
El `for` dentro de la lista recorre cada parte y le aplica `strip` para sacar espacios alrededor.

## 4. Práctica guiada (35 min)

**Escenario:** en la pizzería entran pedidos como texto sin formato. Tenemos que parsearlos para extraer cada ítem y mostrar el precio.

**Código completo (`pizza_parser.py`):**

```python
def parse_order(order_text):
    """
    Convierte un texto como '2 muzza, 1 napo' en una lista de tuplas.
    Cada tupla: (cantidad, nombre, precio_unitario).
    """
    items = []
    # Separa por coma, limpia bordes de cada parte
    parts = [p.strip() for p in order_text.split(",")]
    for part in parts:
        # Cada parte: "2 muzza" o "1 napo"
        tokens = part.split()
        if len(tokens) >= 2:
            quantity = int(tokens[0])
            name = " ".join(tokens[1:])  # nombre compuesto
            # Precio base según variedad
            unit_price = get_base_price(name)
            items.append((quantity, name, unit_price))
    return items


def get_base_price(pizza_name):
    """Devuelve el precio base de una pizza según su nombre."""
    prices = {
        "muzza": 1200.0,
        "napo": 1400.0,
        "palmito": 1600.0,
        "fugazzeta": 1500.0,
        "especial": 1800.0,
        "calabresa": 1700.0,
    }
    # .get devuelve "-" si no encuentra la variedad
    return prices.get(pizza_name, 0.0)


def print_order_summary(items):
    """Muestra el resumen del pedido con f-strings formateados."""
    print("\n=== Resumen del pedido ===")
    total = 0.0
    for quantity, name, unit_price in items:
        subtotal = quantity * unit_price
        total += subtotal
        print(f"{quantity}x {name}: ${unit_price:.2f} c/u → ${subtotal:.2f}")
    print(f"Total del pedido: ${total:.2f}")
    print("=" * 30)


if __name__ == "__main__":
    # Entrada: el usuario tipea el pedido como texto
    raw = input("Ingresá el pedido (ej: 2 muzza, 1 napo, 3 palmito): ")
    parsed = parse_order(raw)
    if parsed:
        print_order_summary(parsed)
    else:
        print("No se pudo interpretar el pedido.")
```

**Salida esperada:**
```
Ingresá el pedido (ej: 2 muzza, 1 napo, 3 palmito): 2 muzza, 1 napo, 3 calabresa

=== Resumen del pedido ===
2x muzza: $1200.00 c/u → $2400.00
1x napo: $1400.00 c/u → $1400.00
3x calabresa: $1700.00 c/u → $5100.00
Total del pedido: $8900.00
==============================
```

**Pasos para la puesta en común:**
1. Escribí el código en un archivo `pizza_parser.py`.
2. Ejecutalo con `python pizza_parser.py`.
3. Probá con distintas entradas: `"1 especial, 2 fugazzeta"`, `"3 muzza"`.
4. ¿Qué pasa si ponés `"muzza, napo"` sin cantidad? — se rompe porque `int("muzza")` falla. Descubrimos que necesitamos validación (lo veremos en la clase 22).

## 5. Ejercicio independiente (25 min)

**Consigna:** escribí un programa `telefono_cleaner.py` que reciba una línea con nombre de comprador, dirección y teléfono separados por punto y coma (`;`). El programa debe:

1. Separar los tres campos.
2. Limpiar espacios de bordes en cada campo.
3. Si el teléfono tiene espacios o guiones (ej: `"11 1234 5678"`), debe sacarlos con `replace` para dejar solo dígitos.
4. Mostrar los datos limpios con f-strings.

**Ejemplo de entrada:**
```
María García; Av. Siempre Viva 123; 11 2345 6789
```

**Salida esperada:**
```
Nombre: María García
Dirección: Av. Siempre Viva 123
Teléfono: 1123456789
```

**Pista:** `replace` puede sacar espacios (`" "`) y también guiones (`"-"`). Podés encadenar dos `replace`: uno para cada carácter que querés eliminar.

**Solución:** en el anexo docente. Intentá resolverlo sin mirar la respuesta.

## 6. Extensión y consolidación (20 min)

Para quienes terminan el ejercicio base:

1. **Agregá formato monetario con separador de miles:** investigá cómo usar `:,.2f` en f-strings para que `1234567.50` se muestre como `1,234,567.50`.
2. **Validación mínima:** si el teléfono limpio no tiene al menos 7 dígitos, mostrá un mensaje de advertencia.
3. **Procesamiento batch:** permití que el usuario ingrese tres líneas de pedido seguidas; procesalas en un `for` y mostrá un resumen final.

## 7. Cierre (10 min)

### Qué te llevás

- Las cadenas son inmutables: los métodos devuelven un nuevo `str`, no cambian el original.
- `split`, `strip`, `join` y `replace` son la caja de herramientas para procesar texto del usuario.
- Las f-strings con `:.2f` dan formato limpio a valores numéricos.
- Combo canónico: `strip` primero, `split` después, procesar cada parte.

### Lo que viene

En el **Encuentro 22** vamos a resolver el problema que apareció hoy: ¿qué pasa cuando el usuario tipea texto donde esperamos un número? Vamos a aprender **validación con `try/except`**.

## 8. Errores comunes y trampas

| Error | Causa | Fix |
| --- | --- | --- |
| `cadena = cadena.split()` y después querés usar la original | `split()` devuelve una nueva lista, la cadena original no se modifica | Guardá el resultado en otra variable o reasignala |
| `"  hola  ".strip()` y esperar que saque espacios internos | `strip` solo saca de los bordes, no del medio | Usá `replace(" ", "")` o `split()` + `join()` para espacios internos |
| `linea.split(",")` con `"a, b, c"` deja espacios en `" b"` | `split` no saca espacios alrededor del separador | Aplicá `strip()` a cada parte después de split |
| `f"{precio}"` muestra `12.5` en vez de `12.50` | Sin formato, Python no agrega ceros | Usá `f"{precio:.2f}"` |
| `join` al revés: `lista.join(" ")` en vez de `" ".join(lista)` | `join` es método del separador, no de la lista | Recordá: `separador.join(iterable)` |
| Usar `"hola".replace("")` para algo | `replace` con cadena vacía está bien, pero cuidado al borrar todo | Es válido, pero no hace nada útil si buscás otra cosa |