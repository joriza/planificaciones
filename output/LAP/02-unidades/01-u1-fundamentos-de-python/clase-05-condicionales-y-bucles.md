# Encuentro 5: Condicionales y bucles

## Datos del encuentro

| Campo | Valor |
|---|---|
| Unidad | U1: Fundamentos de Python |
| Encuentro | 5 de 31 (2 de 5 en la unidad) |
| Duración | 120 minutos |
| Carácter | Procedimental |

## Objetivos de aprendizaje

- Escribir decisiones con `if`, `elif` y `else`.
- Repetir una lectura inválida con `while` hasta obtener un dato válido.
- Recorrer una secuencia fija con `for` y `range()`.
- Acumular valores en un contador dentro de un bucle.
- Reemplazar el corte con `sys.exit(1)` por un reintento con mensaje claro.

## Reparto de tiempos (120 minutos)

| Bloque | Minutos |
|---|---|
| Apertura y motivación | 10 |
| Desarrollo teórico-práctico | 60 |
| Consolidación y cierre | 20 |
| Actividad complementaria | 30 |

## Charla rápida

Un programa con decisiones es como un viaje con GPS: en cada esquina un cartel decide el giro (`if`), y el GPS recalcula una y otra vez (`while`) hasta llegar al destino. El reintento del dato inválido es exactamente eso: «¿es un número? sigo; no es: vuelvo a preguntar». Y cuando la tarea se repite una cantidad conocida de veces — tres notas — el `for` es la vuelta completa al bloque, sin copiar y pegar el mismo código tres veces.

## Teoría mínima

### Decisiones: `if`, `elif`, `else`

```python
if promedio >= 8:
    condicion = "Promociona"
elif promedio >= 6:
    condicion = "Regular"
else:
    condicion = "Libre"
```

- La condición se evalúa de arriba hacia abajo y entra en la **primera** que cumple.
- Comparaciones: `>=`, `<=`, `>`, `<`, `==` (igualdad), `!=` (distinto). El `=` asigna; el `==` compara.
- El cuerpo va **indentado con 4 espacios**: en Python la indentación es estructura, no estética.

### Reintento: `while`

`while` repite su bloque mientras la condición sea verdadera. El patrón de reingreso del curso:

```python
while True:
    try:
        edad = int(input("Edad: "))
        break
    except ValueError:
        print("Debe ingresar un numero valido")
```

`while True` es un bucle que solo sale por el `break`, y el `break` solo se alcanza cuando la conversión funcionó. Si `int()` lanza `ValueError`, el `except` muestra el mensaje y el bucle vuelve a preguntar. Este patrón reemplaza al `sys.exit(1)` de la versión 1: el programa ya no corta, reintenta. (Y como ya no corta, ya no se necesita `import sys`.)

### Repetición fija: `for` y `range()`

```python
for numero in range(1, 4):
    print(f"Nota {numero}")
```

`range(1, 4)` produce `1, 2, 3`: **el límite final no se incluye**. Sirve para repetir una cantidad conocida de veces, con un contador listo para usar en los mensajes.

### Acumuladores

Un contador o acumulador se inicializa **antes** del bucle y se actualiza **dentro**: `suma_notas = 0` antes, `suma_notas = suma_notas + nota` adentro. Inicializarlo adentro es el error clásico: se reinicia en cada vuelta.

## Práctica guiada: la versión 2 del programa

La versión 2 de `gestion_notas.py` incorpora tres mejoras: reintenta los datos numéricos en lugar de cortar, lee las tres notas con un solo bloque `for`, y decide la condición del estudiante según el promedio.

**Paso 1:** abrir `gestion_notas.py` y reemplazar el contenido de `main()` por la versión 2 completa:

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


if __name__ == "__main__":
    main()
```

Notas sobre la versión:

- Ya no está `import sys`: el programa nunca corta por un dato inválido.
- El `for` contiene un `while`: primero se elige qué nota se pide (`numero`), y esa lectura se repite hasta ser válida. Recorrer el orden con calma: una vuelta del `for` puede incluir varias lecturas fallidas del `while`.
- El `promedio` divide por `3` porque son siempre tres notas; en el próximo encuentro ese número saldrá de la estructura de datos.

**Paso 2:** ejecutar y probar los dos caminos. Salida esperada (con un dato inválido en el medio, a propósito):

```
=== Registro de notas de la comision ===
Nombre del estudiante: Ana
Edad: 19
Nota 1: 8
Nota 2: ocho
Debe ingresar un numero valido
Nota 2: 7
Nota 3: 9
=== Ficha del estudiante ===
Nombre: Ana
Edad: 19
Promedio: 8.0
Condicion: Promociona
```

**Paso 3:** probar los tres rumbos de la condición: con promedio `8.0` o más (`Promociona`), entre `6.0` y `8.0` (`Regular`), y debajo de `6.0` (`Libre`). Anotar qué notas se usaron en cada caso: sirven para el cierre.

## Ejercicio independiente: contar aplazadas

Agregar al programa un conteo de notas aplazadas (nota menor que `6`) y mostrarlo al final de la ficha con el renglón `Aplazadas: N`.

**Pista:** el contador `aplazadas = 0` se inicializa junto a `suma_notas`, antes del `for`. La decisión `if nota < 6` va **dentro** del `for`, después de acumular la nota. El renglón de salida va con los demás `print` de la ficha.

**Solución esperada** (los renglones nuevos):

```python
    # Contador de notas aplazadas
    aplazadas = 0
    ...
        # Acumular la nota recien leida
        suma_notas = suma_notas + nota
        # Contar la nota si es aplazada
        if nota < 6:
            aplazadas = aplazadas + 1
    ...
    print(f"Aplazadas: {aplazadas}")
```

La solución completa, con el programa entero, está en el anexo docente.

## Cierre

**Qué llevamos:** `if/elif/else` decide por el primer rumbo que cumple; `while True` + `break` implementa el reintento hasta dato válido; `for` con `range()` recorre una cantidad fija de vueltas con contador incluido; los acumuladores se inicializan antes del bucle y se actualizan dentro. La versión 2 del programa ya no corta ante un dato inválido: reintenta.

**Lo que viene:** tres notas sueltas (`suma_notas`, sin lista) alcanzan para hoy, pero no se pueden recorrer ni mostrar juntas. En el próximo encuentro las notas pasan a ser una **lista**, y el nombre pasa por los métodos de cadena `strip()`, `split()` y `join()`.

## Errores comunes y trampas

| Error | Causa | Solución |
|---|---|---|
| Bucle infinito | `while True` sin `break` alcanzable, o el `break` fuera del `try`. | Verificar que `break` sea lo último del `try`; cortar con `Ctrl+C` y releer. |
| Esperar 4 vueltas de `range(1, 4)` | El límite final de `range` no se incluye: produce `1, 2, 3`. | Tres vueltas para tres notas; `range(1, cantidad + 1)` cuando se quiere incluir el tope. |
| `=` en lugar de `==` | `if nota = 6:` es asignación y lanza `SyntaxError`. | `==` compara, `=` asigna. |
| Acumulador reiniciado en cada vuelta | Inicializar `suma_notas = 0` dentro del `for`. | Inicializar antes del bucle, actualizar adentro. |
| `IndentationError` en el cuerpo del `if` | Mezclar niveles de indentación o usar tabulaciones y espacios juntos. | 4 espacios por nivel, en todos los bloques. |
| `except:` desnudo en el reintento | Aparenta funcionar igual, pero oculta el error real y deja el programa roto en silencio. | Siempre `except ValueError:` con su mensaje. |
