# Anexo docente — Encuentro 23: Módulos y menú en memoria

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

```python
# menu_matematica.py
# Menú de consola con operaciones matemáticas usando math.

import math


def read_positive_float(message):
    # Pide un número positivo hasta obtener uno válido.
    # float() acepta decimales; validamos que sea positivo.
    while True:
        try:
            valor = float(input(message))
            if valor <= 0:
                print("El valor debe ser positivo; intentá de nuevo.")
                continue
            return valor
        except ValueError:
            print("Eso no es un número; intentá de nuevo.")


def raiz_cuadrada():
    # Calcula y muestra la raíz cuadrada de un número positivo.
    numero = read_positive_float("Ingresá un número positivo: ")
    resultado = math.sqrt(numero)
    print(f"La raíz cuadrada de {numero} es {resultado:.4f}")


def area_circulo():
    # Calcula y muestra el área de un círculo dado su radio.
    radio = read_positive_float("Ingresá el radio del círculo: ")
    area = math.pi * radio ** 2
    print(f"El área del círculo con radio {radio} es {area:.4f}")


def mostrar_menu():
    # Muestra el menú de opciones al usuario.
    print("\n--- Menú Matemática ---")
    print("1. Raíz cuadrada")
    print("2. Área del círculo")
    print("3. Salir")


def main():
    # Bloque de ejecución principal: menú en memoria con while True.
    while True:
        mostrar_menu()
        opcion = input("Elegí una opción: ").strip()
        if opcion == "1":
            raiz_cuadrada()
        elif opcion == "2":
            area_circulo()
        elif opcion == "3":
            print("¡Hasta luego!")
            break
        else:
            print("Opción inválida; elegí 1, 2 o 3.")


if __name__ == "__main__":
    main()
```

**Explicación:** El programa importa `math` para acceder a `math.sqrt()` y `math.pi`. La función `read_positive_float` combina el patrón de reintento (`while True` + `try/except ValueError`) con una validación de positividad (`if valor <= 0`). Las funciones `raiz_cuadrada` y `area_circulo` usan `math.sqrt()` y `math.pi * radio ** 2` respectivamente. El menú en `main()` usa `if/elif/else` con `break` para la opción de salida.

## 2. Solución de la actividad de extensión

**Actividad 1 — Historial de cálculos:**

```python
# extension_historial.py
# Menú matemático con historial de cálculos.

import math


def read_positive_float(message):
    while True:
        try:
            valor = float(input(message))
            if valor <= 0:
                print("El valor debe ser positivo; intentá de nuevo.")
                continue
            return valor
        except ValueError:
            print("Eso no es un número; intentá de nuevo.")


def raiz_cuadrada(historial):
    numero = read_positive_float("Ingresá un número positivo: ")
    resultado = math.sqrt(numero)
    print(f"La raíz cuadrada de {numero} es {resultado:.4f}")
    historial.append({"operacion": f"raiz({numero})", "resultado": resultado})


def area_circulo(historial):
    radio = read_positive_float("Ingresá el radio del círculo: ")
    area = math.pi * radio ** 2
    print(f"El área del círculo con radio {radio} es {area:.4f}")
    historial.append({"operacion": f"area(radio={radio})", "resultado": area})


def mostrar_historial(historial):
    if not historial:
        print("Aún no hay cálculos en el historial.")
        return
    print("\n--- Historial ---")
    for i, registro in enumerate(historial, 1):
        print(f"{i}. {registro['operacion']} = {registro['resultado']:.4f}")


def mostrar_menu():
    print("\n--- Menú Matemática ---")
    print("1. Raíz cuadrada")
    print("2. Área del círculo")
    print("3. Ver historial")
    print("4. Salir")


def main():
    historial = []
    while True:
        mostrar_menu()
        opcion = input("Elegí una opción: ").strip()
        if opcion == "1":
            raiz_cuadrada(historial)
        elif opcion == "2":
            area_circulo(historial)
        elif opcion == "3":
            mostrar_historial(historial)
        elif opcion == "4":
            print("¡Hasta luego!")
            break
        else:
            print("Opción inválida; elegí 1, 2, 3 o 4.")


if __name__ == "__main__":
    main()
```

**Actividad 2 — Factorial con math:**

Agregá una función `factorial_numero()` y una opción `5` al menú:

```python
def factorial_numero():
    # Calcula el factorial de un entero no negativo.
    while True:
        try:
            n = int(input("Ingresá un entero no negativo: "))
            if n < 0:
                print("El número debe ser no negativo; intentá de nuevo.")
                continue
            resultado = math.factorial(n)
            print(f"{n}! = {resultado}")
            break
        except ValueError:
            print("Eso no es un número entero; intentá de nuevo.")
```

## 3. Respuesta esperada del ejercicio

| Opción | Entrada | Salida esperada |
| --- | --- | --- |
| 1 | `16` | `La raíz cuadrada de 16.0 es 4.0000` |
| 1 | `-4` (luego `9`) | `El valor debe ser positivo...` luego `La raíz cuadrada de 9.0 es 3.0000` |
| 1 | `abc` (luego `25`) | `Eso no es un número...` luego `La raíz cuadrada de 25.0 es 5.0000` |
| 2 | `5` | `El área del círculo con radio 5.0 es 78.5398` |
| 2 | `0` (luego `3`) | `El valor debe ser positivo...` luego `El área del círculo con radio 3.0 es 28.2743` |
| 3 | cualquiera | `Opción inválida; elegí 1, 2 o 3.` |

## 4. Criterios de corrección (lista de verificación)

- [ ] El programa usa `import math` para acceder a funciones matemáticas.
- [ ] La función `read_positive_float` combina `while True` + `try/except ValueError` + validación de positividad.
- [ ] `math.sqrt()` y `math.pi` se usan correctamente para las operaciones.
- [ ] El menú tiene al menos 3 opciones y usa `if/elif/else` con `break` para salir.
- [ ] No usa clases ni persistencia de ningún tipo.
- [ ] El código tiene comentarios en español que explican cada paso relevante.
- [ ] El programa tiene un bloque `if __name__ == "__main__":`.
- [ ] Los identificadores están en inglés y en `snake_case`.

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| `math.sqrt(-1)` lanza `ValueError` | No validó que el número sea positivo antes de llamar a `sqrt()` | Recordar que `math.sqrt()` requiere un valor no negativo; la validación debe hacerse antes de la llamada |
| `import random` dentro de la función | Funciona pero no es la convención del curso | Mostrar que los imports van arriba del archivo, junto a los demás imports |
| El menú no sale con la opción 3 | Olvidó `break` después de `print("¡Hasta luego!")` | Señalar que `break` es necesario para salir del `while True` del menú |
| `math.pi` muestra muchos decimales | No usó formato en el f-string | Mostrar la diferencia entre `f"{math.pi}"` y `f"{math.pi:.4f}"` |
| `float(input(...))` sin `try/except` | El programa se rompe si el usuario tipea texto no numérico | Reforzar que `input()` siempre devuelve `str` y que `float()` lanza `ValueError` con texto no numérico |

## 6. Registro de la clase

| Indicador | Qué registrar |
| --- | --- |
| Participación | Cantidad de alumnos que ejecutaron `menu_matematica.py` sin errores de sintaxis |
| Concepto clave | ¿Pueden explicar la diferencia entre `import random` y `import math`? |
| Dificultad frecuente | ¿Quién olvidó el `break` en la opción de salida? |
| Tiempo empleado | Minutos promedio hasta completar el ejercicio independiente |
| Observaciones | Notas cualitativas sobre grupos que necesitaron apoyo extra con `math.pi` o `math.sqrt()` |
