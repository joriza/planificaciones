# Anexo docente — Encuentro 5: Condicionales y bucles

## Encuadre

Primer encuentro procedimental de la unidad: se aprende decidiendo y repitiendo. El programa de E4 cortaba ante un dato inválido; la versión 2 lo convierte en reintento, que es el uso más honesto del `while` porque el grupo lo siente como necesidad propia («¿y si no pongo un número?»). Hay un anidamiento nuevo y exigente: un `while` dentro de un `for`. Conviene recorrerlo en el pizarrón una vez, vuelta por vuelta, antes de que lo escriban. La condición de promociona/regular/libre se elige con umbrales típicos (`8` y `6`) y queda como base del resumen de la comisión que pedirá el TP-U1.

## Qué observar durante la clase

- Bucles infinitos: casi siempre el `break` quedó fuera del `try` o el `except` no reempaquetó el pedido. Cortar con `Ctrl+C` es parte de la destreza del encuentro.
- Confusión `range(1, 4)` → expectativa de cuatro notas. Hacer contar las vueltas en voz alta la primera vez.
- Acumulador `suma_notas = 0` adentro del `for`: el promedio termina siendo solo la última nota dividida tres. Se detecta comparando con el cálculo a mano.
- Orden de las ramas del `if`: si escriben `if promedio >= 6` primero, un promedio de `9` entra en `Regular`. Probarlo a propósito es la mejor devolución.
- Copiar la versión 2 sin borrar `import sys`: no es error, pero es señal de reemplazo sin lectura; pedirla como limpieza.
- Doble validación pedida («¿y si la nota es 45?»): anotarlo como insumo real del ajuste de la unidad (validar rango 0-10 queda como mejora propuesta, no como requisito de hoy).

## Solución completa del ejercicio independiente

```python
def main():
    # Presentar el programa
    print("=== Registro de notas de la comision ===")

    # Pedir el nombre del estudiante (input devuelve siempre texto)
    nombre = input("Nombre del estudiante: ")

    # Pedir la edad, repitiendo mientras el dato no sea valido
    while True:
        try:
            edad = int(input("Edad: "))
            break
        except ValueError:
            print("Debe ingresar un numero valido")

    # Pedir las tres notas con un recorrido fijo de 1 a 3
    suma_notas = 0
    aplazadas = 0
    for numero in range(1, 4):
        # Repetir la lectura de la nota mientras no sea valida
        while True:
            try:
                nota = int(input(f"Nota {numero}: "))
                break
            except ValueError:
                print("Debe ingresar un numero valido")
        # Acumular la nota recien leida
        suma_notas = suma_notas + nota
        # Contar la nota si es aplazada
        if nota < 6:
            aplazadas = aplazadas + 1

    # Calcular el promedio del estudiante
    promedio = suma_notas / 3

    # Decidir la condicion del estudiante segun el promedio
    if promedio >= 8:
        condicion = "Promociona"
    elif promedio >= 6:
        condicion = "Regular"
    else:
        condicion = "Libre"

    # Mostrar la ficha del estudiante
    print("=== Ficha del estudiante ===")
    print(f"Nombre: {nombre}")
    print(f"Edad: {edad}")
    print(f"Promedio: {promedio}")
    print(f"Condicion: {condicion}")
    print(f"Aplazadas: {aplazadas}")


if __name__ == "__main__":
    main()
```

Salida esperada (con una aplazada y un reintento en el camino):

```
=== Registro de notas de la comision ===
Nombre del estudiante: Luis
Edad: veinte
Debe ingresar un numero valido
Edad: 20
Nota 1: 6
Nota 2: 5
Nota 3: 7
=== Ficha del estudiante ===
Nombre: Luis
Edad: 20
Promedio: 6.0
Condicion: Regular
Aplazadas: 1
```

## Errores previsibles

1. **Operar `input()` sin convertir dentro del `while`:** el `try` parece innecesario hasta que llega el primer `ocho`; sin conversión, `"1" + 1` lanza `TypeError` (defecto de la checklist: `input()` devuelve `str`).
2. **`int("23.5")`:** un estudiante escribe `7.5` como nota: `ValueError` y reintento, que es el comportamiento correcto; la nota decimal como problema queda planteado para discutir el criterio de redondeo.
3. **`except:` desnudo:** atrapa el `KeyboardInterrupt` del `Ctrl+C` y hasta un error de tipeo en el código; prohibido, siempre `except ValueError:`.
4. **Acumulador inicializado dentro del bucle:** el promedio sale mal sin ningún mensaje de error; es el defecto silencioso del encuentro.
5. **`range(1, 4)` leído como «hasta 4 inclusive»:** quedan faltando una nota o sobrando vueltas; contar vueltas en voz alta.
6. **Condición imposible por orden de ramas:** `>= 6` antes de `>= 8` hace inalcanzable el `Promociona`; probar con promedio 9 para evidenciarlo.

## Criterios de logro (4-8)

| Nivel | Descripción |
|---|---|
| 4 | Copia la versión 2 pero el programa no corre por errores de indentación. |
| 5 | El programa corre; el reintento falla en algún caso (bucle infinito o acepta lo inválido). |
| 6 | Reintento y condición funcionan; falta el conteo de aplazadas del ejercicio. |
| 7 | Todo completo con salida exacta, incluido el caso inválido corregido en el camino. |
| 8 | Explica por qué `range(1, 4)` da tres vueltas y qué pasa si falta el `break`. |

## Agrupamiento

Individual, una máquina por estudiante. Sugerencia: quienes terminan el ejercicio antes se convierten en «tutores de reintentos» y ayudan a detectar bucles infinitos ajenos, que es el dolor del encuentro.

## Ajustes para la siguiente edición

- Si el anidamiento `for` + `while` cuesta, practicar primero el patrón de reintento solo con la edad y recién después generalizarlo a las tres notas dentro del `for`.
- Si el grupo ya maneja bucles desde su lenguaje de origen, agregar como actividad complementaria la validación de rango (`0` a `10`) con un `while` adicional por nota.
