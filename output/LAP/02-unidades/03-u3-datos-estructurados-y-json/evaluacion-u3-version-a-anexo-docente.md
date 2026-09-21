# Anexo docente — Evaluación de la Unidad 3, Versión A (gestión de notas)

> Documento de uso exclusivo del docente: no entregar a alumnos ni a administración.

## Encuadre docente

La versión A evalúa la unidad sobre el dominio de notas: registro como diccionario con claves canónicas, colección como lista, persistencia JSON completa con carga segura de tres caminos, consultas con búsqueda sin mayúsculas distintivas y filtro con exportación a un archivo de resultado separado. Reutiliza funciones y lectura de la Unidad 2 solo como base ya adquirida. La defensa verifica el modelo de datos, la carga segura y la separación entre archivo principal y resultado.

## Solución completa (código canon)

```python
import json
import sys

RUTA_DATOS = "notas.json"
RUTA_RESULTADO = "resultado.json"

TEXTO_MENU = """
=== Notas en JSON ===
1 - Alta de nota
2 - Listado de notas
3 - Buscar por alumno
4 - Filtrar por nota minima
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

def guardar_notas(notas):
    # Sobrescribir el archivo con la coleccion completa.
    with open(RUTA_DATOS, "w", encoding="utf-8") as f:
        json.dump(notas, f, ensure_ascii=False, indent=2)

def alta(notas):
    # Pedir el registro y agregarlo a la coleccion.
    # Pedir el alumno y repetir mientras quede vacio
    while True:
        alumno = input("Alumno: ").strip()
        if alumno != "":
            break
        print("El campo no puede quedar vacio")
    materia = input("Materia: ").strip()
    nota = pedir_nota()
    # Armar el registro con las claves canonicas
    registro = {"alumno": alumno, "materia": materia, "nota": nota}
    notas.append(registro)
    # Guardar la coleccion completa tras cada alta
    guardar_notas(notas)
    print("Registro agregado")

def mostrar_registro(registro, posicion):
    # Mostrar un registro con su posicion en la lista.
    print(posicion, "-", registro["alumno"], "|", registro["materia"], "| Nota:", registro["nota"])

def listar(notas):
    # Mostrar el listado numerado de la coleccion.
    if len(notas) == 0:
        print("No hay registros guardados")
        return
    for i in range(len(notas)):
        mostrar_registro(notas[i], i + 1)

def buscar(notas):
    # Buscar registros por alumno sin distinguir mayusculas.
    buscado = input("Alumno a buscar: ").strip().lower()
    encontrado = False
    for i in range(len(notas)):
        registro = notas[i]
        if registro["alumno"].lower() == buscado:
            mostrar_registro(registro, i + 1)
            encontrado = True
    if not encontrado:
        print("No hay registros de ese alumno")

def filtrar(notas):
    # Exportar a resultado.json los registros que alcanzan la nota minima.
    minima = pedir_nota()
    # Seleccionar los registros que cumplen la condicion
    seleccion = []
    for i in range(len(notas)):
        registro = notas[i]
        if registro["nota"] >= minima:
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
    notas = cargar_notas()
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
            alta(notas)
        elif opcion == 2:
            listar(notas)
        elif opcion == 3:
            buscar(notas)
        elif opcion == 4:
            filtrar(notas)
        elif opcion == 0:
            # Guardar la coleccion completa al salir
            guardar_notas(notas)
            break
        else:
            print("Opcion invalida")
    print("Hasta luego")


if __name__ == "__main__":
    main()
```

## Contenido esperado de `notas.json` tras dos altas

```json
[
  {
    "alumno": "ana perez",
    "materia": "Matematica",
    "nota": 8
  },
  {
    "alumno": "luis gomez",
    "materia": "Matematica",
    "nota": 5
  }
]
```

Con `ensure_ascii=False` e `indent=2`: caracteres reales en UTF-8 y archivo multi-línea legible.

## Criterios de corrección (100 puntos)

| Criterio | Puntos | Logro completo | Recorte sugerido |
|---|---|---|---|
| Registros y colección | 20 | Diccionarios con claves `alumno`/`materia`/`nota`; alta con nombre obligatorio; guardado en cada alta | Claves inconsistentes con el canon: 10; sin validación del nombre vacío: 12 |
| Persistencia JSON | 25 | `json.load`/`json.dump` con `ensure_ascii=False` e `indent=2`; `FileNotFoundError` → `[]`; `JSONDecodeError` → aviso + `sys.exit(1)`; guardado al salir | Falta un camino de carga: 15; `ensure_ascii` ausente: 15 |
| Consultas | 25 | Listado numerado, búsqueda `.lower()` de ambos lados, filtro por umbral con exportación a `resultado.json` sin pisar `notas.json` | El filtro pisa el archivo principal: 5; búsqueda sensible a mayúsculas: 18 |
| Canon de estructura y estilo | 20 | Esqueleto completo, opción de menú bajo `try/except ValueError`, comentarios por acción, sin tildes en el código | Menú sin validar: 12; tildes o comentarios faltantes: 12 |
| Entrega por GitHub | 10 | Carpeta y archivos correctos, commit convencional, push verificado | Commit sin push: 5 |

## Defensa: preguntas sugeridas y respuestas esperadas

| Pregunta | Respuesta esperada |
|---|---|
| ¿Por qué un dict y no una lista de campos? | El acceso es por clave con nombre (`registro["nota"]`), no por posición: el registro se lee y se mantiene sin depender del orden de los campos. |
| ¿Qué pasa sin `notas.json`? | `json.load` nunca se ejecuta: `FileNotFoundError` devuelve `[]` y la primera corrida arranca vacía. |
| ¿Qué pasa con el archivo dañado? | `json.JSONDecodeError`: aviso y `sys.exit(1)`; no se continúa para no pisar datos que no se pueden releer. |
| ¿Por qué `ensure_ascii=False` e `indent=2`? | Sin `ensure_ascii=False` las tildes y ñ quedan como `\u00f1`; sin `indent=2` el archivo sale en una sola línea ilegible. |
| ¿Cómo evita el filtro pisar `notas.json`? | La selección se escribe en `RUTA_RESULTADO`, un archivo distinto del archivo de datos. |

## Errores previsibles

1. Escribir `notas.json` a mano en lugar de dejar que lo genere el programa: regenerar corriendo el programa.
2. `json.dump` sin `ensure_ascii=False`: `\u00f1` en lugar de ñ (JSON válido, ilegible).
3. Exportar el filtro sobre `RUTA_DATOS`: el archivo principal queda pisado; verificar con `type` ambos archivos.
4. Búsqueda sin `.lower()`: «Ana» no encuentra «ana».
5. `except:` desnudo en la carga: oculta el `JSONDecodeError` y el programa sigue roto.
6. Opción de menú con `int(input())` sin `try`: una letra rompe el programa con `ValueError`.

## Equivalencia con la versión B

| Elemento | Versión A (notas) | Versión B (inventario) |
|---|---|---|
| Archivo de datos | `notas.json` | `inventario.json` |
| Registro (3 claves) | `alumno`, `materia`, `nota` | `producto`, `rubro`, `stock` |
| Alta | Alumno obligatorio | Producto obligatorio |
| Búsqueda | Por alumno, sin mayúsculas distintivas | Por producto, sin mayúsculas distintivas |
| Filtro (opción 4) | Nota mínima (`>=`) exportada a `resultado.json` | Stock máximo (`<=`) exportado a `resultado.json` |
| Carga segura | `[]` / aviso + `sys.exit(1)` | `[]` / aviso + `sys.exit(1)` |

Mismo programa, mismas opciones, misma rúbrica: solo cambia el dominio de los datos y la dirección del umbral.
