# Anexo docente — Evaluación de la Unidad 3, Versión B (inventario de productos)

> Documento de uso exclusivo del docente: no entregar a alumnos ni a administración.

## Encuadre docente

La versión B evalúa la misma estructura que la versión A sobre el dominio de inventario: registro como diccionario con claves canónicas, colección como lista, persistencia JSON completa con carga segura de tres caminos, consultas con búsqueda sin mayúsculas distintivas y filtro con exportación a un archivo de resultado separado. La única diferencia de contenido con la versión A es la dirección del umbral del filtro (stock máximo en lugar de nota mínima), de dificultad equivalente.

## Solución completa (código canon)

```python
import json
import sys

RUTA_DATOS = "inventario.json"
RUTA_RESULTADO = "resultado.json"

TEXTO_MENU = """
=== Inventario en JSON ===
1 - Alta de producto
2 - Listado de productos
3 - Buscar por producto
4 - Filtrar por stock maximo
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
    # Devolver la coleccion guardada en el archivo JSON.
    try:
        with open(RUTA_DATOS, "r", encoding="utf-8") as f:
            return json.load(f)
    except FileNotFoundError:
        # Primera corrida: todavia no existe el archivo de datos.
        return []
    except json.JSONDecodeError:
        # El archivo esta danado: avisar y terminar con codigo 1.
        print("El archivo de datos esta danado")
        sys.exit(1)

def guardar_productos(productos):
    # Sobrescribir el archivo con la coleccion completa.
    with open(RUTA_DATOS, "w", encoding="utf-8") as f:
        json.dump(productos, f, ensure_ascii=False, indent=2)

def alta(productos):
    # Pedir el registro y agregarlo a la coleccion.
    # Pedir el producto y repetir mientras quede vacio
    while True:
        producto = input("Producto: ").strip()
        if producto != "":
            break
        print("El campo no puede quedar vacio")
    rubro = input("Rubro: ").strip()
    stock = pedir_stock()
    # Armar el registro con las claves canonicas
    registro = {"producto": producto, "rubro": rubro, "stock": stock}
    productos.append(registro)
    # Guardar la coleccion completa tras cada alta
    guardar_productos(productos)
    print("Registro agregado")

def mostrar_registro(registro, posicion):
    # Mostrar un registro con su posicion en la lista.
    print(posicion, "-", registro["producto"], "|", registro["rubro"], "| Stock:", registro["stock"])

def listar(productos):
    # Mostrar el listado numerado de la coleccion.
    if len(productos) == 0:
        print("No hay registros guardados")
        return
    for i in range(len(productos)):
        mostrar_registro(productos[i], i + 1)

def buscar(productos):
    # Buscar registros por producto sin distinguir mayusculas.
    buscado = input("Producto a buscar: ").strip().lower()
    encontrado = False
    for i in range(len(productos)):
        registro = productos[i]
        if registro["producto"].lower() == buscado:
            mostrar_registro(registro, i + 1)
            encontrado = True
    if not encontrado:
        print("No hay registros de ese producto")

def filtrar(productos):
    # Exportar a resultado.json los productos con stock en el umbral de reposicion.
    maximo = pedir_stock()
    # Seleccionar los registros que cumplen la condicion
    seleccion = []
    for i in range(len(productos)):
        registro = productos[i]
        if registro["stock"] <= maximo:
            seleccion.append(registro)
    # Mostrar la seleccion
    if len(seleccion) == 0:
        print("Ningun registro cumple la condicion")
    else:
        for i in range(len(seleccion)):
            mostrar_registro(seleccion[i], i + 1)
    # Exportar la seleccion sin tocar el archivo principal
    with open(RUTA_RESULTADO, "w", encoding="utf-8") as f:
        json.dump(seleccion, f, ensure_ascii=False, indent=2)
    print("Seleccion exportada a", RUTA_RESULTADO)

def main():
    # Cargar la coleccion al abrir el programa
    productos = cargar_productos()
    # Repetir el menu hasta que se elija salir
    while True:
        # Mostrar el menu y pedir la opcion convertida a numero
        print(TEXTO_MENU)
        while True:
            try:
                opcion = int(input("Elija una opcion: "))
                break
            except ValueError:
                print("Debe ingresar un numero valido")
        if opcion == 1:
            alta(productos)
        elif opcion == 2:
            listar(productos)
        elif opcion == 3:
            buscar(productos)
        elif opcion == 4:
            filtrar(productos)
        elif opcion == 0:
            # Guardar la coleccion completa al salir
            guardar_productos(productos)
            break
        else:
            print("Opcion invalida")
    print("Hasta luego")


if __name__ == "__main__":
    main()
```

## Contenido esperado de `inventario.json` tras dos altas

```json
[
  {
    "producto": "tornillo m8",
    "rubro": "ferreria",
    "stock": 30
  },
  {
    "producto": "taladro",
    "rubro": "herramientas",
    "stock": 4
  }
]
```

Con `ensure_ascii=False` e `indent=2`: caracteres reales en UTF-8 y archivo multi-línea legible.

## Criterios de corrección (100 puntos)

| Criterio | Puntos | Logro completo | Recorte sugerido |
|---|---|---|---|
| Registros y colección | 20 | Diccionarios con claves `producto`/`rubro`/`stock`; alta con producto obligatorio; guardado en cada alta | Claves inconsistentes con el canon: 10; sin validación del nombre vacío: 12 |
| Persistencia JSON | 25 | `json.load`/`json.dump` con `ensure_ascii=False` e `indent=2`; `FileNotFoundError` → `[]`; `JSONDecodeError` → aviso + `sys.exit(1)`; guardado al salir | Falta un camino de carga: 15; `ensure_ascii` ausente: 15 |
| Consultas | 25 | Listado numerado, búsqueda `.lower()` de ambos lados, filtro por umbral con exportación a `resultado.json` sin pisar `inventario.json` | El filtro pisa el archivo principal: 5; búsqueda sensible a mayúsculas: 18 |
| Canon de estructura y estilo | 20 | Esqueleto completo, opción de menú bajo `try/except ValueError`, comentarios por acción, sin tildes en el código | Menú sin validar: 12; tildes o comentarios faltantes: 12 |
| Entrega por GitHub | 10 | Carpeta y archivos correctos, commit convencional, push verificado | Commit sin push: 5 |

## Defensa: preguntas sugeridas y respuestas esperadas

| Pregunta | Respuesta esperada |
|---|---|
| ¿Por qué un dict y no una lista de campos? | El acceso es por clave con nombre (`registro["stock"]`), no por posición: el registro se lee y se mantiene sin depender del orden de los campos. |
| ¿Qué pasa sin `inventario.json`? | `json.load` nunca se ejecuta: `FileNotFoundError` devuelve `[]` y la primera corrida arranca vacía. |
| ¿Qué pasa con el archivo dañado? | `json.JSONDecodeError`: aviso y `sys.exit(1)`; no se continúa para no pisar datos que no se pueden releer. |
| ¿Por qué `ensure_ascii=False` e `indent=2`? | Sin `ensure_ascii=False` las tildes y ñ quedan como `\u00f1`; sin `indent=2` el archivo sale en una sola línea ilegible. |
| ¿Cómo evita el filtro pisar `inventario.json`? | La selección se escribe en `RUTA_RESULTADO`, un archivo distinto del archivo de datos. |

## Errores previsibles

1. Escribir `inventario.json` a mano en lugar de dejar que lo genere el programa: regenerar corriendo el programa.
2. `json.dump` sin `ensure_ascii=False`: `\u00f1` en lugar de ñ (JSON válido, ilegible).
3. Exportar el filtro sobre `RUTA_DATOS`: el archivo principal queda pisado; verificar con `type` ambos archivos.
4. Búsqueda sin `.lower()`: «Taladro» no encuentra «taladro».
5. `except:` desnudo en la carga: oculta el `JSONDecodeError` y el programa sigue roto.
6. Opción de menú con `int(input())` sin `try`: una letra rompe el programa con `ValueError`.

## Equivalencia con la versión A

| Elemento | Versión A (notas) | Versión B (inventario) |
|---|---|---|
| Archivo de datos | `notas.json` | `inventario.json` |
| Registro (3 claves) | `alumno`, `materia`, `nota` | `producto`, `rubro`, `stock` |
| Alta | Alumno obligatorio | Producto obligatorio |
| Búsqueda | Por alumno, sin mayúsculas distintivas | Por producto, sin mayúsculas distintivas |
| Filtro (opción 4) | Nota mínima (`>=`) exportada a `resultado.json` | Stock máximo (`<=`) exportado a `resultado.json` |
| Carga segura | `[]` / aviso + `sys.exit(1)` | `[]` / aviso + `sys.exit(1)` |

Mismo programa, mismas opciones, misma rúbrica: solo cambia el dominio de los datos y la dirección del umbral.
