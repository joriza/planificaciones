# Anexo docente — Evaluación de la Unidad 2, Versión B (inventario de productos)

> Documento de uso exclusivo del docente: no entregar a alumnos ni a administración.

## Encuadre docente

La versión B evalúa la misma estructura que la versión A sobre el dominio de inventario: descomposición en funciones, menú con persistencia, archivo de texto de tres campos, modos `"r"`/`"a"`/`"w"`, carga segura de la primera corrida y lectura robusta con `split`/`strip`. No exige contenidos de la Unidad 3 (diccionarios ni JSON). La defensa verifica los mismos puntos que en la versión A.

## Solución completa (código canon)

```python
RUTA_DATOS = "productos.txt"

TEXTO_MENU = """
=== Registro de productos ===
1 - Agregar un producto
2 - Listar los productos
3 - Buscar por producto
4 - Stock promedio por producto
5 - Eliminar por producto
0 - Salir
"""

def pedir_stock():
    # Pedir un stock y repetir la lectura mientras no sea valida.
    while True:
        try:
            stock = int(input("Stock: "))
            break
        except ValueError:
            print("Debe ingresar un numero valido")
    return stock

def cargar_productos():
    # Devolver los productos guardados en el archivo de datos.
    try:
        with open(RUTA_DATOS, "r", encoding="utf-8") as f:
            # Lista final de productos leidos
            productos = []
            for linea in f:
                # Saltar las lineas vacias
                if linea.strip() == "":
                    continue
                # Separar los campos y limpiarlos
                campos = linea.split(",")
                nombre = campos[0].strip()
                rubro = campos[1].strip()
                stock = int(campos[2].strip())
                productos.append([nombre, rubro, stock])
            return productos
    except FileNotFoundError:
        # Primera corrida: todavia no existe el archivo de datos.
        print("No existe el archivo de datos: se empieza de cero")
        return []

def agregar_producto(productos):
    # Pedir los datos y agregar el producto a la memoria y al archivo.
    nombre = input("Producto: ").strip()
    rubro = input("Rubro: ").strip()
    stock = pedir_stock()
    # Guardar el registro en memoria
    productos.append([nombre, rubro, stock])
    # Agregar la linea al final del archivo sin reescribirlo
    with open(RUTA_DATOS, "a", encoding="utf-8") as f:
        linea = nombre + "," + rubro + "," + str(stock) + "\n"
        f.write(linea)
    print("Producto agregado")

def mostrar_registro(registro, posicion):
    # Mostrar un registro con su posicion en la lista.
    print(posicion, "-", registro[0], "|", registro[1], "| Stock:", registro[2])

def listar_productos(productos):
    # Mostrar el listado numerado de los productos.
    if len(productos) == 0:
        print("No hay productos guardados")
        return
    for i in range(len(productos)):
        mostrar_registro(productos[i], i + 1)

def buscar_productos(productos):
    # Mostrar los productos cuyo nombre coincida con el buscado.
    buscado = input("Producto a buscar: ").strip()
    encontrado = False
    for i in range(len(productos)):
        registro = productos[i]
        if registro[0] == buscado:
            mostrar_registro(registro, i + 1)
            encontrado = True
    if not encontrado:
        print("No hay registros de ese producto")

def promedio_stock(productos):
    # Calcular el stock promedio por producto.
    if len(productos) == 0:
        print("No hay productos guardados: el promedio es 0")
        return
    # Sumar los stocks recorriendo la coleccion
    suma = 0
    for i in range(len(productos)):
        suma = suma + productos[i][2]
    print("Stock promedio por producto:", suma / len(productos))

def eliminar_por_producto(productos):
    # Quitar de memoria los registros del producto indicado y reescribir el archivo.
    buscado = input("Producto a eliminar: ").strip()
    # Conservar solo los registros de otros productos
    restantes = []
    for i in range(len(productos)):
        registro = productos[i]
        if registro[0] != buscado:
            restantes.append(registro)
    if len(restantes) == len(productos):
        print("No hay registros de ese producto")
        return productos
    # Reescribir todo el archivo con los registros restantes
    with open(RUTA_DATOS, "w", encoding="utf-8") as f:
        for i in range(len(restantes)):
            registro = restantes[i]
            linea = registro[0] + "," + registro[1] + "," + str(registro[2]) + "\n"
            f.write(linea)
    print("Producto eliminado")
    return restantes

def main():
    # Cargar los datos al abrir el programa
    productos = cargar_productos()
    # Repetir el menu hasta que se elija salir
    while True:
        # Mostrar el menu y pedir la opcion
        print(TEXTO_MENU)
        opcion = input("Elija una opcion: ")
        if opcion == "1":
            agregar_producto(productos)
        elif opcion == "2":
            listar_productos(productos)
        elif opcion == "3":
            buscar_productos(productos)
        elif opcion == "4":
            promedio_stock(productos)
        elif opcion == "5":
            productos = eliminar_por_producto(productos)
        elif opcion == "0":
            # Salir del programa
            break
        else:
            print("Opcion invalida")
    print("Hasta luego")


if __name__ == "__main__":
    main()
```

## Contenido esperado de `productos.txt` tras dos altas

```
tornillo m8,ferreria,30
taladro,herramientas,4
```

Un registro por línea, tres campos separados por coma, sin espacios alrededor de la coma.

## Criterios de corrección (100 puntos)

| Criterio | Puntos | Logro completo | Recorte sugerido |
|---|---|---|---|
| Menú y funciones | 25 | Seis opciones operativas; una función por operación; `main()` y guard completos | Opción sin funcionar: 15; lógica suelta fuera de funciones: 5 |
| Persistencia en texto | 25 | `with open` con `encoding="utf-8"` en todas las aperturas; `"a"` en alta, `"w"` en eliminación, `"r"` en carga | Un modo incorrecto: 15; apertura sin `encoding`: 10 |
| Lectura robusta | 20 | `split(",")` + `.strip()` por campo, líneas vacías filtradas, stock convertido con reingreso | Sin filtrado de vacías: 12; conversión sin `try`: 5 |
| Manejo de errores | 15 | `FileNotFoundError` con mensaje canónico; excepciones específicas; sin `traceback` previsto | Mensaje canónico ausente: 8; `except:` desnudo: 0 en el criterio |
| Entrega por GitHub | 15 | Carpeta y archivos correctos, commit convencional, push verificado | Commit sin push: 8; carpeta equivocada: 4 |

## Defensa: preguntas sugeridas y respuestas esperadas

| Pregunta | Respuesta esperada |
|---|---|
| ¿Qué modo usa el alta y por qué? | `"a"`: agrega al final sin borrar lo existente; con `"w"` perdería los productos anteriores. |
| ¿Qué modo usa la eliminación y por qué? | `"w"`: reescribe el archivo completo con los registros restantes. |
| ¿Qué pasa la primera vez, sin `productos.txt`? | `open` lanza `FileNotFoundError`; el programa avisa y arranca con la colección vacía. |
| ¿Por qué `.strip()` en cada campo? | La línea trae el `\n` y `split` deja espacios: sin `strip` las comparaciones fallan. |
| ¿Por qué el stock promedio está protegido? | Con la colección vacía la división por `len` es por cero; se avisa y se evita el cálculo. |

## Errores previsibles

1. Usar `"w"` en el alta: cada nuevo producto borra los anteriores (verificar con dos altas seguidas).
2. `open()` sin `encoding="utf-8"`: la codificación del sistema rompe los acentos de los datos.
3. Comparar líneas recién leídas sin `.strip()`: el `\n` impide la búsqueda.
4. Líneas vacías sin filtrar: `"".split(",")` devuelve `['']` y aparece un registro fantasma.
5. `stock = int(input())` sin `try`: una letra rompe el programa con `ValueError`.
6. `commit` sin `push`: la entrega vale lo publicado en GitHub.

## Equivalencia con la versión A

| Elemento | Versión A (notas) | Versión B (inventario) |
|---|---|---|
| Archivo de datos | `notas.txt` | `productos.txt` |
| Registro (3 campos) | `alumno,materia,nota` | `producto,rubro,stock` |
| Campo numérico | Nota (`int`) | Stock (`int`) |
| Cálculo (opción 4) | Promedio general de notas | Stock promedio por producto |
| Eliminación (opción 5) | Por alumno, reescribe con `"w"` | Por producto, reescribe con `"w"` |
| Primera corrida | Aviso canónico y colección vacía | Aviso canónico y colección vacía |

Mismo programa, mismas opciones, misma rúbrica: solo cambia el dominio de los datos.
