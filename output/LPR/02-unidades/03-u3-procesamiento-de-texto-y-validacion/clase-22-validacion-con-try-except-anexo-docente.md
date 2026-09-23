# Anexo docente — Encuentro 22: Validación con try/except

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

```python
# calculadora_simple.py
# Calculadora simple que pide dos números y muestra las cuatro operaciones.

def read_int(message):
    # Pide un número entero hasta obtener uno válido.
    # input() siempre devuelve str; int() lanza ValueError si no es numérico.
    while True:
        try:
            return int(input(message))
        except ValueError:
            print("Eso no es un número entero; intenta de nuevo.")


def main():
    # Lee dos números enteros validados.
    a = read_int("Primer número: ")
    b = read_int("Segundo número: ")
    # Muestra los resultados de las cuatro operaciones básicas.
    print(f"Suma: {a} + {b} = {a + b}")
    print(f"Resta: {a} - {b} = {a - b}")
    print(f"Producto: {a} * {b} = {a * b}")
    print(f"División: {a} / {b} = {a / b}")


if __name__ == "__main__":
    main()
```

**Explicación:** La función `read_int` implementa el patrón canónico de lectura validada: `while True` que reintenta hasta que `int()` tenga éxito, atrapando `ValueError` con un mensaje en español. La función `main` llama a `read_int` dos veces y muestra las cuatro operaciones con f-strings. La división `/` siempre produce `float` (spike 9.2).

## 2. Solución de la actividad de extensión

**Actividad 1 — División entera y residuo:**

Agregá estas dos líneas al bloque de impresión de `main`:

```python
    print(f"División entera: {a} // {b} = {a // b}")
    print(f"Residuo: {a} % {b} = {a % b}")
```

Salida esperada con `8` y `3`:

```
División entera: 8 // 3 = 2
Residuo: 8 % 3 = 2
```

**Actividad 2 — Menú con validación de opción:**

```python
# menu_opciones.py
# Menú simple con validación de opción sin excepciones.

def main():
    while True:
        print("1. Saludar")
        print("2. Despedirse")
        print("3. Salir")
        opcion = input("Elegí una opción: ").strip()
        if opcion == "1":
            print("¡Hola!")
        elif opcion == "2":
            print("¡Adiós!")
        elif opcion == "3":
            print("Hasta luego.")
            break
        else:
            print("Opción inválida; elegí 1, 2 o 3.")


if __name__ == "__main__":
    main()
```

La validación de menú usa `if/elif/else`, no excepciones. La opción `"3"` rompe el bucle con `break`.

## 3. Respuesta esperada del ejercicio

| Entrada primer número | Entrada segundo número | Salida esperada (fragmento) |
| --- | --- | --- |
| `8` | `3` | `Suma: 8 + 3 = 11` / `División: 8 / 3 = 2.666...` |
| `abc` (luego `5`) | `2` | Mensaje de error, luego `Suma: 5 + 2 = 7` |
| `10` | `xyz` (luego `4`) | Mensaje de error en segundo número, luego operaciones con 10 y 4 |

## 4. Criterios de corrección (lista de verificación)

- [ ] El programa usa `try/except ValueError` para validar la entrada numérica.
- [ ] El patrón de reintento es `while True` con `return` dentro del `try`.
- [ ] No usa `except:` desnudo; siempre nombra la excepción específica.
- [ ] Los mensajes de error están en español y son accionables.
- [ ] El programa tiene un bloque `if __name__ == "__main__":`.
- [ ] El código tiene comentarios en español que explican cada paso relevante.
- [ ] No usa clases ni persistencia de ningún tipo.
- [ ] La división `/` produce `float` y la división entera `//` produce `int`.

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| `lista = lista.append(x)` | Confunde mutación con retorno | Recordar que `append()` devuelve `None` y muta la lista in-place |
| `except:` desnudo captura todo | No nombró la excepción específica | Explicar que `except:` tapa `KeyboardInterrupt` y errores de programación; siempre usar `except ValueError` |
| El programa no reintenta | Puso `input()` dentro del `except` en vez del `while` | Señalar que el `while True` debe envolver todo el bloque `try/except` |
| `int("12.5")` lanza `ValueError` | Esperaba que `int()` aceptara decimales como texto | Mostrar que `int()` solo acepta enteros como texto; para decimales usar `float()` primero |
| `return` dentro del `except` | La función devuelve `None` en lugar de reintentar | El `return` debe estar dentro del `try`, después de la conversión exitosa |

## 6. Registro de la clase

| Indicador | Qué registrar |
| --- | --- |
| Participación | Cantidad de alumnos que ejecutaron `calculadora_simple.py` sin errores de sintaxis |
| Concepto clave | ¿Pueden explicar por qué `except:` desnudo es peligroso? |
| Dificultad frecuente | ¿Quién confundió `return` con `print` dentro de `read_int`? |
| Tiempo empleado | Minutos promedio hasta completar el ejercicio independiente |
| Observaciones | Notas cualitativas sobre grupos que necesitaron apoyo extra con el patrón `while True` |
