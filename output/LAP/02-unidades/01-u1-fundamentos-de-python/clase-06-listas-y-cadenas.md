# Encuentro 6: Listas y cadenas

## Datos del encuentro

| Campo | Valor |
|---|---|
| Unidad | U1: Fundamentos de Python |
| Encuentro | 6 de 31 (3 de 5 en la unidad) |
| Duración | 120 minutos |
| Carácter | Procedimental |

## Objetivos de aprendizaje

- Guardar valores en una lista con `append()` y medirla con `len()`.
- Recorrer una lista con `for` para sumar y para transformar sus elementos.
- Limpiar y separar cadenas con `strip()` y `split()`.
- Unir fragmentos con `join()` y aplicar `upper()` para presentar.
- Buscar el máximo y el mínimo de una lista recorriéndola con `if`.

## Reparto de tiempos (120 minutos)

| Bloque | Minutos |
|---|---|
| Apertura y motivación | 10 |
| Desarrollo teórico-práctico | 60 |
| Consolidación y cierre | 20 |
| Actividad complementaria | 30 |

## Charla rápida

Una lista es una fila de casilleros numerados: cada casillero guarda una cosa y la fila entera viaja junta bajo un solo nombre. Hoy las tres notas dejan de ser tres variables sueltas (`nota1`, `nota2`, `nota3`) y pasan a ser una fila: `notas`. Y las cadenas de texto son material de trabajo, no solo etiquetas: se pueden recortar los bordes (`strip`), cortar en partes (`split`) y volver a pegar (`join`), como una cinta que se corta y se vuelve a armar.

## Teoría mínima

### Listas

```python
notas = []                # lista vacia
notas.append(8)           # agregar al final
notas.append(7)
print(len(notas))         # 2: cantidad de elementos
```

- `append()` agrega al final; la lista crece en tiempo de ejecución.
- `len()` devuelve la cantidad de elementos: es la base del promedio cuando la cantidad no se sabe de antemano.
- El primer elemento es el índice `0`: `notas[0]` es la primera nota. Sirve para inicializar búsquedas.
- El recorrido es con `for`: `for nota in notas:` entrega los elementos, uno por vuelta.

### Cadenas: `strip()`, `split()`, `join()`

Métodos verificados en el spike de la materia:

| Método | Ejemplo | Resultado observado |
|---|---|---|
| `strip()` | `"  Ana  ".strip()` | `"Ana"`: quita espacios de los bordes, no los del medio. |
| `split()` | `"ana  perez".split()` | `['ana', 'perez']`: sin argumento corta por espacios y no deja partes vacías. |
| `split(",")` | `"Ana, 23".split(",")` | `['Ana', ' 23']`: deja el espacio; por eso va acompañado de `strip()` en cada campo. |
| `join()` | `" - ".join(['8', '7'])` | `"8 - 7"`: el separador va adelante y la lista debe contener cadenas. |
| `upper()` | `"ana".upper()` | `"ANA"`: para títulos y presentaciones. |

`join()` es la respuesta al problema del separador: concatenar con `+` deja un separador sobrante al final (`"8 - 7 - "`); `join()` lo coloca solo entre elementos. La lista debe ser de cadenas: un entero se convierte primero con `str()`.

## Práctica guiada: la versión 3 del programa

La versión 3 guarda las notas en una lista, calcula el promedio con `len()`, muestra las notas unidas con `join()` y trabaja el nombre completo con `strip()`, `split()`, `join()` y `upper()`.

**Paso 1:** reemplazar el contenido de `gestion_notas.py` por la versión 3 completa:

```python
def main():
    # Presentar el programa
    print("=== Registro de notas de la comision ===")

    # Pedir el nombre completo del estudiante
    entrada = input("Nombre completo: ")

    # Limpiar los bordes y separar por espacios
    partes = entrada.strip().split()

    # Volver a unir las partes con un solo espacio
    nombre = " ".join(partes)

    # Pedir la edad, repitiendo mientras el dato no sea valido
    while True:
        try:
            edad = int(input("Edad: "))
            break
        except ValueError:
            print("Debe ingresar un numero valido")

    # Pedir las tres notas y guardarlas en una lista
    notas = []
    for numero in range(1, 4):
        # Repetir la lectura de la nota mientras no sea valida
        while True:
            try:
                nota = int(input(f"Nota {numero}: "))
                break
            except ValueError:
                print("Debe ingresar un numero valido")
        # Agregar la nota a la lista
        notas.append(nota)

    # Sumar las notas recorriendo la lista
    suma_notas = 0
    for nota in notas:
        suma_notas = suma_notas + nota

    # Calcular el promedio con la cantidad real de notas
    promedio = suma_notas / len(notas)

    # Convertir las notas a texto para poder unirlas
    textos = []
    for nota in notas:
        textos.append(str(nota))

    # Unir las notas con un separador legible
    texto_notas = " - ".join(textos)

    # Decidir la condicion del estudiante segun el promedio
    if promedio >= 8:
        condicion = "Promociona"
    elif promedio >= 6:
        condicion = "Regular"
    else:
        condicion = "Libre"

    # Mostrar la ficha del estudiante
    print(f"=== Ficha de {nombre.upper()} ===")
    print(f"Nombre: {nombre}")
    print(f"Edad: {edad}")
    print(f"Notas: {texto_notas}")
    print(f"Promedio: {promedio}")
    print(f"Condicion: {condicion}")


if __name__ == "__main__":
    main()
```

Notas sobre la versión:

- El promedio ahora divide por `len(notas)`: si mañana las notas fueran cuatro, la línea no se toca. Esa es la diferencia entre repetir código y estructurar datos.
- El nombre llega limpio aunque la entrada traiga espacios de más en los bordes o en el medio: `strip()` + `split()` + `join()` lo normalizan.
- `texto_notas` requiere dos pasos: convertir cada nota a texto (`str`) y recién después unir. Unir enteros directamente lanza `TypeError`.

**Paso 2:** ejecutar y probar con una entrada «sucia» para el nombre. Salida esperada (la entrada `  ana   perez ` lleva espacios de más a propósito):

```
=== Registro de notas de la comision ===
Nombre completo:   ana   perez 
Edad: 19
Nota 1: 8
Nota 2: 7
Nota 3: 9
=== Ficha de ANA PEREZ ===
Nombre: ana perez
Edad: 19
Notas: 8 - 7 - 9
Promedio: 8.0
Condicion: Promociona
```

**Paso 3:** verificar en pantalla el contenido de la lista: agregar transitoriamente `print(notas)` después de la carga, ver la lista completa `[8, 7, 9]`, y borrar el renglón de prueba.

## Ejercicio independiente: mayor y menor nota

Agregar a la ficha el cálculo de la mayor y la menor nota recorriendo la lista con un `for` y un `if` (sin usar `max()` ni `min()`): mostrar `Mayor nota: N` y `Menor nota: N`.

**Pista:** inicializar `mayor` y `menor` con la primera nota (`notas[0]`) y recorrer el resto: si la nota supera a `mayor`, se actualiza; si queda por debajo de `menor`, también. Los renglones de salida van con los demás de la ficha.

**Solución esperada** (los renglones nuevos):

```python
    # Buscar la mayor y la menor nota recorriendo la lista
    mayor = notas[0]
    menor = notas[0]
    for nota in notas:
        if nota > mayor:
            mayor = nota
        if nota < menor:
            menor = nota
    ...
    print(f"Mayor nota: {mayor}")
    print(f"Menor nota: {menor}")
```

La solución completa, con el programa entero, está en el anexo docente.

## Cierre

**Qué llevamos:** una lista guarda muchos valores bajo un nombre, crece con `append()` y se mide con `len()`. El recorrido con `for` entrega elemento por elemento, y `strip()`, `split()`, `join()` y `upper()` son el kit mínimo para limpiar, cortar, unir y presentar texto. La versión 3 del programa calcula el promedio con la cantidad real de notas y muestra el nombre normalizado.

**Lo que viene:** el programa ya está listo para vivir en un repositorio. En el próximo encuentro se crea el repositorio del grupo con `git init` y `.gitignore`, se registra la primera versión con `add` y `commit`, y se sube a GitHub con `push`: la primera entrega.

## Errores comunes y trampas

| Error | Causa | Solución |
|---|---|---|
| `IndexError: list index out of range` | Leer `notas[3]` cuando la lista tiene índices `0` a `2`. | Los índices llegan hasta `len(notas) - 1`; para buscar máximo y mínimo, arrancar en `notas[0]`. |
| `TypeError` en `join()` | Unir una lista de enteros: `" - ".join(notas)` con `notas = [8, 7]`. | Convertir primero: `str(nota)` en un recorrido, y recién después `join()`. |
| `split(",")` sin `strip()` | `"Ana, 23".split(",")` deja el espacio: `' 23'` falla en comparaciones de texto (observado en el spike). | `strip()` en cada campo separado. |
| Comparar sin limpiar | `"ana  perez"` con doble espacio no es igual a `"ana perez"`. | `strip().split()` y volver a unir con `" ".join(...)` para normalizar. |
| Inicializar el máximo en `0` | Si todas las notas fueran negativas, el máximo quedaría mal; y `notas[0]` es el punto de partida honesto. | Inicializar con el primer elemento de la lista. |
| `append()` fuera del bucle | La lista termina con una sola nota (la última leída) en lugar de tres. | El `append` va dentro del `for`, después del `while` de reingreso. |
