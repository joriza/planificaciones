# Encuentro 22 — Validación con try/except

> Procesamiento de texto y validación

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 22 de 36 |
| Unidad | 3 — Procesamiento de texto y validación |
| Eje temático | 3 — Procesamiento de texto y validación |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 120 minutos (2 horas) |
| Concepto nuevo | Validación con try/except |
| Requisitos previos | Encuentro 21: métodos de cadenas; Encuentros 1–20: variables, input/output, funciones |
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

1. Atrapar `ValueError` con `try/except` para validar la entrada numérica del usuario.
2. Implementar el patrón de reintento con `while True` hasta obtener un dato válido.
3. Mostrar mensajes de error claros y en español cuando la entrada no sea la esperada.
4. Diferenciar entre `except ValueError` y un `except` genérico desnudo.

## 3. Teoría mínima (20 min)

### Charla rápida: el portero de la puerta

Pensá en `try/except` como un portero de un edificio. Cuando alguien (el programa) quiere entrar al departamento (ejecutar `int(input(...))`), el portero revisa si tiene la llave correcta (un valor numérico). Si no la tiene, en vez de dejarlo tirado en la escalera (un `ValueError` que rompe el programa), el portero lo recibe, le dice "no tenés la llave, intentá de nuevo" (el mensaje de error) y lo deja reintentar. El bucle `while True` es el pasillo de espera: mientras no pase la validación, el usuario sigue intentando.

### Lo mínimo indispensable

- `int()` y `float()` lanzan `ValueError` cuando el texto no es convertible a número (spike 9.1).
- El patrón canónico es `while True` con `try/except ValueError` y un `return` o `break` cuando la entrada es válida (ver convenciones técnicas sección 5).
- `except ValueError` nombra la excepción específica; `except:` desnudo está prohibido porque tapa errores inesperados (convenciones técnicas sección 6).
- Los mensajes de error visibles al usuario deben ser en español y accionables, nunca trazas crudas.

## 4. Práctica guiada (35 min)

**Paso 1** — Creá un archivo `leer_edad.py` con el siguiente código:

```python
# leer_edad.py
# Pide la edad al usuario y la valida con try/except.

def read_int(message):
    # Pide un número entero hasta obtener uno válido.
    # input() siempre devuelve str; int() lanza ValueError si no es numérico.
    while True:
        try:
            return int(input(message))
        except ValueError:
            print("Eso no es un número entero; intenta de nuevo.")


def main():
    # Bloque de ejecución principal: lee la edad y muestra un mensaje.
    edad = read_int("Ingresá tu edad: ")
    print(f"Tienes {edad} años. En 10 años tendrás {edad + 10}.")


if __name__ == "__main__":
    main()
```

**Paso 2** — Ejecutá el programa y probá las siguientes rutas:

1. **Ruta feliz:** ingresá `25` → salida: `Tienes 25 años. En 10 años tendrás 35.`
2. **Entrada no numérica:** ingresá `abc` → mensaje de error, vuelve a pedir. Luego ingresá `30` → salida correcta.
3. **Número con decimales:** ingresá `12.5` → `ValueError` (porque `int("12.5")` falla), vuelve a pedir.

**Paso 3** — Modificá el programa para que también pida el nombre (sin validación numérica) y lo muestre junto con la edad:

```python
    nombre = input("Tu nombre: ").strip()
    print(f"Hola, {nombre}. Tienes {edad} años.")
```

## 5. Ejercicio independiente (25 min)

**Consigna:** Escribí un programa llamado `calculadora_simple.py` que pida al usuario dos números enteros y muestre su suma, resta, producto y división real. Si el usuario tipea algo que no es un número, el programa debe mostrar un mensaje claro y volver a pedir ese dato. Pista: usá la función `read_int` del programa guía y llamala dos veces para obtener ambos números.

**Solución esperada:**

```python
# calculadora_simple.py
# Calculadora simple que pide dos números y muestra las cuatro operaciones.

def read_int(message):
    # Pide un número entero hasta obtener uno válido.
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

**Salida esperada** (con entrada `8` y `3`):

```
Suma: 8 + 3 = 11
Resta: 8 - 3 = 5
Producto: 8 * 3 = 24
División: 8 / 3 = 2.6666666666666665
```

## 6. Extensión y consolidación (20 min)

**Actividad 1 — División entera:** Agregá al programa la división entera (`//`) y el residuo (`%`). Mostrá también esos resultados con f-strings.

**Actividad 2 — Validación de opción de menú:** Escribí un mini-menú que pida al usuario que elija una opción (`1` sumar, `2` restar, `3` salir) y use `if/elif/else` para responder. Si la opción no es `1`, `2` ni `3`, mostrá "Opción inválida" y volvé a pedir. No uses excepciones para esto; usá validación con `if`.

## 7. Cierre (10 min)

### Qué te llevás

- `try/except ValueError` es la forma canónica de validar que `input()` contiene un número convertible.
- El patrón `while True` con `return` dentro del `try` permite reintentar hasta obtener un dato válido.
- `except:` desnudo está prohibido; siempre se nombra la excepción esperada.
- Los mensajes de error van en español y son accionables para el usuario.

### Lo que viene

En el próximo encuentro vamos a integrar funciones, colecciones y validación en un menú de consola que vive enteramente en memoria.

## 8. Errores comunes y trampas

1. **`lista = lista.append(x)`** — `append()` muta la lista y devuelve `None`; asignar el resultado anula la lista. Usá `lista.append(x)` en su propia línea.
2. **`except:` desnudo** — Captura cualquier excepción, incluyendo `KeyboardInterrupt`, y esconde errores de programación. Siempre nombrá la excepción: `except ValueError`.
3. **`int("12.5")` lanza `ValueError`** — `int()` no acepta decimales como texto; para eso usá `float()` primero y luego `int()` si necesitás entero.
4. **Confundir `return` con `print` dentro de la función** — Si usás `print` en vez de `return`, la función devuelve `None` y el valor no se puede usar afuera.
5. **Poner `input()` dentro del `except`** — El reintento debe estar en el `while True`, no dentro del bloque `except`; de lo contrario, el flujo de reintento no funciona correctamente.
