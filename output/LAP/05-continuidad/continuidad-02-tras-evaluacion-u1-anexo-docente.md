# Anexo docente — Continuidad pedagógica 2: Repaso de la Unidad 1

> Anexo de uso exclusivo del docente. No se entrega a los alumnos ni a la administración junto con la actividad.

## Encuadre docente

Segunda continuidad: disponible en el tramo de la Unidad 2 (Encuentros 10 a 14). Repasa la Unidad 1 completa, que es la base sobre la que la unidad en curso sigue construyendo; no adelanta contenido de la Unidad 2. Todos los programas siguen las convenciones técnicas del curso (esqueleto canónico, `except` específicos, un solo archivo por programa).

## Soluciones

### Actividad 2 — Los cinco errores

| Nº | Error | Síntoma | Corrección |
| --- | --- | --- | --- |
| 1 | `range(1, 3)` | Pide dos notas cuando el enunciado pide tres | `range(1, 4)` |
| 2 | `input()` sin convertir | `suma = suma + nota` lanza `TypeError` (input devuelve `str`) | `nota = int(input(...))` |
| 3 | `suma = 0` dentro del `for` | Reinicia el acumulador en cada vuelta: el promedio queda mal sin mensaje de error | Inicializar `suma = 0` antes del bucle |
| 4 | `promedio = suma / 2` | Divide por dos, no por tres | `promedio = suma / 3` |
| 5 | `if promedio = 6:` | `SyntaxError`: asignación en lugar de comparación | `if promedio >= 6:` |

Versión corregida completa:

```python
# Promedio de tres notas - version corregida

def main():
    # Calcular el promedio de tres notas y decidir si aprueba
    suma = 0
    for numero in range(1, 4):
        nota = int(input(f"Nota {numero}: "))
        suma = suma + nota
    promedio = suma / 3
    if promedio >= 6:
        print("Aprobado")
    else:
        print("Insuficiente")


if __name__ == "__main__":
    main()
```

### Actividad 3 — Solución de referencia: `repaso_u1.py`

```python
# Repaso de la Unidad 1: promedio con reintentos y condicion

def pedir_edad():
    # Pedir la edad y repetir hasta que sea un numero valido.
    while True:
        try:
            edad = int(input("Edad: "))
            return edad
        except ValueError:
            print("Debe ingresar un numero valido")

def pedir_nota(numero):
    # Pedir la nota y repetir hasta que sea un numero valido.
    while True:
        try:
            nota = int(input(f"Nota {numero}: "))
            return nota
        except ValueError:
            print("Debe ingresar un numero valido")

def main():
    # Presentar el programa
    print("=== Repaso de la Unidad 1 ===")

    # Pedir el nombre del estudiante
    nombre = input("Nombre del estudiante: ")

    # Pedir la edad con reintento
    edad = pedir_edad()

    # Pedir las tres notas con reintento y acumularlas
    suma_notas = 0
    for numero in range(1, 4):
        suma_notas = suma_notas + pedir_nota(numero)

    # Calcular el promedio
    promedio = suma_notas / 3

    # Decidir la condicion segun el promedio
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

Salida esperada (con el dato inválido en el medio):

```text
=== Repaso de la Unidad 1 ===
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

### Actividad 4 — Solución de referencia: `frase.py`

```python
# Repaso de cadenas: split, strip, join y recorrido

def main():
    # Pedir una frase al usuario
    frase = input("Escriba una frase: ")

    # Separar la frase en palabras
    palabras = frase.split(" ")

    # Quedarse con las palabras no vacias
    palabras_validas = []
    for palabra in palabras:
        if palabra != "":
            palabras_validas.append(palabra)

    # Contar las palabras y buscar la mas larga
    mas_larga = ""
    for palabra in palabras_validas:
        if len(palabra) > len(mas_larga):
            mas_larga = palabra

    # Reconstruir la frase a partir de las palabras limpias
    limpia = " ".join(palabras_validas)

    # Mostrar los resultados
    print("Palabras:", len(palabras_validas))
    print("Mas larga:", mas_larga)
    print("Frase reconstruida:", limpia)


if __name__ == "__main__":
    main()
```

Salida esperada para la entrada `  programar   en python `:

```text
Palabras: 3
Mas larga: programar
Frase reconstruida: programar en python
```

### Actividad 5

Verificar en GitHub: commit con el mensaje `continuidad: repaso de la unidad 1` y los tres archivos (`promedios_v2.py`, `repaso_u1.py`, `frase.py`) dentro de `continuidad/`.

## Criterios de corrección (100 puntos)

| Actividad | Puntaje completo | Ajustes parciales |
| --- | --- | --- |
| 1 — Mapa | 10: cinco encuentros con tema y ejemplo propio | Filas incompletas: 4 a 8 |
| 2 — Caza de errores | 30: cinco errores con corrección y síntoma (6 cada uno) | Corrección sin síntoma: 3 por error |
| 3 — Programa | 35: reintentos (10), acumulación correcta (10), condición (10), ficha (5) | Sin reintento: máximo 25; condición con `=` en vez de `>=`: descontar 3 |
| 4 — Cadenas | 15: conteo sin espacios falsos (5), más larga (5), `join()` (5) | Conteo con espacios dobles contados: descontar 3 |
| 5 — Entrega | 10: commit subido con mensaje pedido y archivos en `continuidad/` | Commit local sin push: 5 |

## Qué mirar en la presentación manuscrita

- Que la explicación de cada error sea propia: un error explicado con el síntoma correcto vale más que la lista copiada del grupo.
- En la Actividad 3, que el reintento use `try/except ValueError` y no `except:` desnudo (prohibido por la hoja de convenciones).
- Que la frase de prueba de la Actividad 4 tenga realmente espacios repetidos: es lo que obliga a filtrar vacíos.
