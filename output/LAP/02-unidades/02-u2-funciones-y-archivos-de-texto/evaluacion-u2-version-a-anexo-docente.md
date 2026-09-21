# Anexo docente — Evaluación de la Unidad 2, Versión A (gestión de notas)

> Documento de uso exclusivo del docente: no entregar a alumnos ni a administración.

## Encuadre docente

La versión A evalúa la unidad sobre el dominio de notas: descomposición en funciones, menú con persistencia, archivo de texto de tres campos, modos `"r"`/`"a"`/`"w"`, carga segura de la primera corrida y lectura robusta con `split`/`strip`. No exige contenidos de la Unidad 3 (diccionarios ni JSON). La defensa verifica los modos de apertura y el camino sin archivo de datos.

## Solución completa (código canon)

```python
RUTA_DATOS = "notas.txt"

TEXTO_MENU = """
=== Libreta de notas ===
1 - Agregar una nota
2 - Listar las notas
3 - Buscar por alumno
4 - Promedio general
5 - Eliminar por alumno
0 - Salir
"""

def pedir_nota():
    # Pedir una nota y repetir la lectura mientras no sea valida.
    while True:
        try:
            nota = int(input("Nota: "))
            break
        except ValueError:
            print("Debe ingresar un numero valido")
    return nota

def cargar_notas():
    # Devolver las notas guardadas en el archivo de datos.
    try:
        with open(RUTA_DATOS, "r", encoding="utf-8") as f:
            # Lista final de notas leidas
            notas = []
            for linea in f:
                # Saltar las lineas vacias
                if linea.strip() == "":
                    continue
                # Separar los campos y limpiarlos
                campos = linea.split(",")
                alumno = campos[0].strip()
                materia = campos[1].strip()
                nota = int(campos[2].strip())
                notas.append([alumno, materia, nota])
            return notas
    except FileNotFoundError:
        # Primera corrida: todavia no existe el archivo de datos.
        print("No existe el archivo de datos: se empieza de cero")
        return []

def agregar_nota(notas):
    # Pedir los datos y agregar la nota a la memoria y al archivo.
    alumno = input("Alumno: ").strip()
    materia = input("Materia: ").strip()
    nota = pedir_nota()
    # Guardar el registro en memoria
    notas.append([alumno, materia, nota])
    # Agregar la linea al final del archivo sin reescribirlo
    with open(RUTA_DATOS, "a", encoding="utf-8") as f:
        linea = alumno + "," + materia + "," + str(nota) + "\n"
        f.write(linea)
    print("Nota agregada")

def mostrar_registro(registro, posicion):
    # Mostrar un registro con su posicion en la lista.
    print(posicion, "-", registro[0], "|", registro[1], "| Nota:", registro[2])

def listar_notas(notas):
    # Mostrar el listado numerado de las notas.
    if len(notas) == 0:
        print("No hay notas guardadas")
        return
    for i in range(len(notas)):
        mostrar_registro(notas[i], i + 1)

def buscar_notas(notas):
    # Mostrar las notas cuyo alumno coincida con el nombre buscado.
    buscado = input("Alumno a buscar: ").strip()
    encontrado = False
    for i in range(len(notas)):
        registro = notas[i]
        if registro[0] == buscado:
            mostrar_registro(registro, i + 1)
            encontrado = True
    if not encontrado:
        print("No hay notas de ese alumno")

def promedio_general(notas):
    # Calcular el promedio de todas las notas guardadas.
    if len(notas) == 0:
        print("No hay notas guardadas: el promedio es 0")
        return
    # Sumar las notas recorriendo la coleccion
    suma = 0
    for i in range(len(notas)):
        suma = suma + notas[i][2]
    print("Promedio general:", suma / len(notas))

def eliminar_por_alumno(notas):
    # Quitar de memoria las notas del alumno indicado y reescribir el archivo.
    buscado = input("Alumno a eliminar: ").strip()
    # Conservar solo los registros de otros alumnos
    restantes = []
    for i in range(len(notas)):
        registro = notas[i]
        if registro[0] != buscado:
            restantes.append(registro)
    if len(restantes) == len(notas):
        print("No hay notas de ese alumno")
        return notas
    # Reescribir todo el archivo con los registros restantes
    with open(RUTA_DATOS, "w", encoding="utf-8") as f:
        for i in range(len(restantes)):
            registro = restantes[i]
            linea = registro[0] + "," + registro[1] + "," + str(registro[2]) + "\n"
            f.write(linea)
    print("Notas eliminadas")
    return restantes

def main():
    # Cargar los datos al abrir el programa
    notas = cargar_notas()
    # Repetir el menu hasta que se elija salir
    while True:
        # Mostrar el menu y pedir la opcion
        print(TEXTO_MENU)
        opcion = input("Elija una opcion: ")
        if opcion == "1":
            agregar_nota(notas)
        elif opcion == "2":
            listar_notas(notas)
        elif opcion == "3":
            buscar_notas(notas)
        elif opcion == "4":
            promedio_general(notas)
        elif opcion == "5":
            notas = eliminar_por_alumno(notas)
        elif opcion == "0":
            # Salir del programa
            break
        else:
            print("Opcion invalida")
    print("Hasta luego")


if __name__ == "__main__":
    main()
```

## Contenido esperado de `notas.txt` tras dos altas

```
ana perez,Matematica,8
luis gomez,Matematica,5
```

Un registro por línea, tres campos separados por coma, sin espacios alrededor de la coma.

## Criterios de corrección (100 puntos)

| Criterio | Puntos | Logro completo | Recorte sugerido |
|---|---|---|---|
| Menú y funciones | 25 | Seis opciones operativas; una función por operación; `main()` y guard completos | Opción sin funcionar: 15; lógica suelta fuera de funciones: 5 |
| Persistencia en texto | 25 | `with open` con `encoding="utf-8"` en todas las aperturas; `"a"` en alta, `"w"` en eliminación, `"r"` en carga | Un modo incorrecto: 15; apertura sin `encoding`: 10 |
| Lectura robusta | 20 | `split(",")` + `.strip()` por campo, líneas vacías filtradas, nota convertida con reingreso | Sin filtrado de vacías: 12; conversión sin `try`: 5 |
| Manejo de errores | 15 | `FileNotFoundError` con mensaje canónico; excepciones específicas; sin `traceback` previsto | Mensaje canónico ausente: 8; `except:` desnudo: 0 en el criterio |
| Entrega por GitHub | 15 | Carpeta y archivos correctos, commit convencional, push verificado | Commit sin push: 8; carpeta equivocada: 4 |

## Defensa: preguntas sugeridas y respuestas esperadas

| Pregunta | Respuesta esperada |
|---|---|
| ¿Qué modo usa el alta y por qué? | `"a"`: agrega al final sin borrar lo existente; con `"w"` perdería las notas anteriores. |
| ¿Qué modo usa la eliminación y por qué? | `"w"`: reescribe el archivo completo con los registros restantes. |
| ¿Qué pasa la primera vez, sin `notas.txt`? | `open` lanza `FileNotFoundError`; el programa avisa y arranca con la colección vacía. |
| ¿Por qué `.strip()` en cada campo? | La línea trae el `\n` y `split` deja espacios: sin `strip` las comparaciones fallan. |
| ¿Por qué el promedio está protegido? | Con la colección vacía la división por `len` es por cero; se avisa y se evita el cálculo. |

## Errores previsibles

1. Usar `"w"` en el alta: cada nueva nota borra las anteriores (verificar con dos altas seguidas).
2. `open()` sin `encoding="utf-8"`: la codificación del sistema rompe los acentos de los datos.
3. Comparar líneas recién leídas sin `.strip()`: el `\n` impide la búsqueda.
4. Líneas vacías sin filtrar: `"".split(",")` devuelve `['']` y aparece un registro fantasma.
5. `nota = int(input())` sin `try`: una letra rompe el programa con `ValueError`.
6. `commit` sin `push`: la entrega vale lo publicado en GitHub.

## Equivalencia con la versión B

| Elemento | Versión A (notas) | Versión B (inventario) |
|---|---|---|
| Archivo de datos | `notas.txt` | `productos.txt` |
| Registro (3 campos) | `alumno,materia,nota` | `producto,rubro,stock` |
| Campo numérico | Nota (`int`) | Stock (`int`) |
| Cálculo (opción 4) | Promedio general de notas | Stock promedio por producto |
| Eliminación (opción 5) | Por alumno, reescribe con `"w"` | Por producto, reescribe con `"w"` |
| Primera corrida | Aviso canónico y colección vacía | Aviso canónico y colección vacía |

Mismo programa, mismas opciones, misma rúbrica: solo cambia el dominio de los datos.
