# Anexo docente — Encuentro 21: Cadenas: métodos de texto

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

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

**Explicación:** La función `formatear_producto` lee el nombre y el precio del usuario. Usa `.strip()` para limpiar la entrada, `float()` dentro de `try/except ValueError` para validar que el precio sea numérico, y un f-string con `.upper()` y `:.2f` para formatear la salida. Si el usuario tipea algo no numérico para el precio, se muestra un mensaje en español y la función termina con `return`.

## 2. Solución de la actividad de extensión

**Actividad 1 — Función censurar:**

```python
# extension_censurar.py
# Agrega una función que reemplaza una palabra por asteriscos.

def censurar(texto, palabra):
    # Reemplaza todas las ocurrencias de palabra por asteriscos de igual longitud.
    asteriscos = "*" * len(palabra)
    resultado = texto.replace(palabra, asteriscos)
    return resultado


if __name__ == "__main__":
    frase = "este mensaje es secreto"
    print(f"Original: {frase}")
    print(f"Censurado: {censurar(frase, 'secreto')}")
```

Salida esperada:

```
Original: este mensaje es secreto
Censurado: este mensaje es ******
```

**Actividad 2 — Experimentos con f-strings:**

| Expresión | Resultado |
| --- | --- |
| `f"{3.14159:.1f}"` | `3.1` |
| `f"{3.14159:.3f}"` | `3.142` |
| `f"{1000:,}"` | `1,000` |

## 3. Respuesta esperada del ejercicio

| Entrada nombre | Entrada precio | Salida esperada |
| --- | --- | --- |
| `café` | `150` | `PRODUCTO: CAFÉ — Precio: $150.00` |
| `  té verde  ` | `85.5` | `PRODUCTO: TÉ VERDE — Precio: $85.50` |
| `mate` | `abc` | `El precio debe ser un número.` |

## 4. Criterios de corrección (lista de verificación)

- [ ] El programa usa `input()` para pedir nombre y precio.
- [ ] Usa `.strip()` sobre el nombre.
- [ ] Usa `float()` dentro de `try/except ValueError` para el precio.
- [ ] Muestra el nombre en mayúsculas con `.upper()`.
- [ ] Muestra el precio con dos decimales usando `:.2f` en un f-string.
- [ ] El programa tiene un bloque `if __name__ == "__main__":`.
- [ ] El código tiene comentarios en español que explican cada paso relevante.
- [ ] No usa clases ni persistencia de ningún tipo.

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| `ValueError` sin mensaje amigable | Usó `float(input(...))` sin `try/except` | Recordar que `input()` siempre devuelve `str` y que `float()` lanza `ValueError` con texto no numérico |
| El precio muestra muchos decimales | No usó `:.2f` en el f-string | Mostrar la diferencia entre `f"{precio}"` y `f"{precio:.2f}"` |
| `AttributeError: 'list' object has no attribute 'upper'` | Aplicó `.upper()` sobre la lista de palabras en vez de sobre la cadena `nombre` | Revisar que `.upper()` es de `str`, no de `list` |
| El nombre no se limpia de bordes | Olvidó `.strip()` en la lectura | Señalar que `input()` incluye los espacios que el usuario tipee antes y después del texto |

## 6. Registro de la clase

| Indicador | Qué registrar |
| --- | --- |
| Participación | Cantidad de alumnos que pudieron ejecutar `procesar_texto.py` sin errores de sintaxis |
| Concepto clave | ¿Pueden nombrar la diferencia entre `split()` y `join()`? |
| Dificultad frecuente | ¿Quién confundió `strip()` con `replace()`? |
| Tiempo empleado | Minutos promedio hasta completar el ejercicio independiente |
| Observaciones | Notas cualitativas sobre grupos que necesitaron apoyo extra con f-strings |
