# Anexo docente — Continuidad pedagógica 4: Repaso de las Unidades 1, 2 y 3

> Anexo de uso exclusivo del docente. No se entrega a los alumnos ni a la administración junto con la actividad.

## Encuadre docente

Cuarta y última continuidad: disponible en el tramo de la Unidad 4 (Encuentros 27 a 31). Repasa las Unidades 1 a 3 (la base exacta del proyecto integrador) sin adelantar contenido nuevo: issues, ramas y pull requests siguen siendo contenido de los encuentros regulares. Los programas siguen las convenciones técnicas del curso (`import` de stdlib, constantes, funciones, `main()`, guard).

## Soluciones

### Actividad 1 — Tabla de referencia

| Formato | Qué guarda | Cómo se lee en el curso | Cuándo conviene |
| --- | --- | --- | --- |
| TXT | Líneas de texto libre | `with open` y recorrido con `for`, `strip()` en cada línea | Notas simples, una cosa por línea |
| CSV | Una fila por línea, campos con coma | `split(",")` más `strip()` por campo | Tablas planas, intercambio con planillas |
| JSON | Colecciones completas (listas y diccionarios) | `json.load()` y `json.dump()` | Registros con estructura, todo junto en un archivo |

Para la agenda vale cualquiera bien justificado; la respuesta más sólida es JSON (registros con estructura y persistencia completa en un archivo), y CSV si se prioriza intercambio con planillas.

### Actividad 2 — Los cinco errores

| Nº | Error | Síntoma | Corrección |
| --- | --- | --- | --- |
| 1 | Falta `import json` | `NameError: name 'json' is not defined` al llamar `json.load` | `import json` arriba, con la stdlib |
| 2 | `json.dump` sin `ensure_ascii=False` | El JSON válido pero ilegible: «José» queda `\u00e9` | `json.dump(alumnos, f, ensure_ascii=False)` |
| 3 | `linea.split(",")` sin `strip()` | Campos con espacios y `\n` sobrantes (`' 8.5\n'`) | `linea = linea.strip()` antes de dividir y `.strip()` por campo |
| 4 | Línea vacía sin filtrar | `"".split(",")` devuelve `['']`: entra un registro basura de un campo | `if linea.strip() == "": continue` |
| 5 | `alumno["promedio"]` sin validar | `KeyError` si la clave no existe en algún registro | `if "promedio" in alumno:` antes de leer |

Bloque corregido:

```python
import json

RUTA_DATOS = "alumnos.json"

def cargar_alumnos():
    # Leer la coleccion completa de alumnos.
    try:
        with open(RUTA_DATOS, "r", encoding="utf-8") as f:
            return json.load(f)
    except FileNotFoundError:
        return []

def guardar_alumnos(alumnos):
    # Sobrescribir el archivo con la coleccion completa.
    with open(RUTA_DATOS, "w", encoding="utf-8") as f:
        json.dump(alumnos, f, ensure_ascii=False, indent=2)

def leer_csv(ruta):
    # Leer un CSV a mano.
    registros = []
    with open(ruta, "r", encoding="utf-8") as f:
        for linea in f:
            linea = linea.strip()
            if linea == "":
                continue
            campos = linea.split(",")
            registros.append([campo.strip() for campo in campos])
    return registros

def promedio_de(alumno):
    # Devolver el promedio del alumno si la clave existe.
    if "promedio" in alumno:
        return alumno["promedio"]
    return None
```

Nota: la comprensión de la lista de campos es la forma compacta del `strip` campo por campo; se acepta también el bucle explícito, que es el estilo preferido del curso para los primeros recorridos.

### Actividad 3 — Solución de referencia: `alumnos.py`

```python
# Repaso de la Unidad 3: coleccion de alumnos en JSON

import json
import sys

TEXTO_MENU = """
1) Agregar alumno
2) Lista de alumnos
3) Buscar por nombre
0) Guardar y salir
"""

RUTA_DATOS = "alumnos.json"

def pedir_edad():
    # Pedir la edad y repetir hasta que sea un numero entero valido.
    while True:
        try:
            edad = int(input("Edad: "))
            return edad
        except ValueError:
            print("Debe ingresar un numero valido")

def pedir_promedio():
    # Pedir el promedio y repetir hasta que sea un numero valido.
    while True:
        try:
            promedio = float(input("Promedio: "))
            return promedio
        except ValueError:
            print("Debe ingresar un numero valido")

def cargar_alumnos():
    # Leer la coleccion completa de alumnos guardada en el archivo JSON.
    try:
        with open(RUTA_DATOS, "r", encoding="utf-8") as f:
            return json.load(f)
    except FileNotFoundError:
        # Primera corrida: todavia no existe el archivo de datos.
        print("No existe el archivo de datos: se empieza de cero")
        return []
    except json.JSONDecodeError:
        # Archivo presente pero malformado: no se puede seguir con seguridad.
        print("El archivo de datos esta danado")
        sys.exit(1)

def guardar_alumnos(alumnos):
    # Sobrescribir el archivo con la coleccion completa.
    with open(RUTA_DATOS, "w", encoding="utf-8") as f:
        json.dump(alumnos, f, ensure_ascii=False, indent=2)

def agregar_alumno(alumnos):
    # Pedir los datos y agregar el registro a la coleccion.
    nombre = input("Nombre: ")
    edad = pedir_edad()
    promedio = pedir_promedio()
    alumnos.append({"nombre": nombre, "edad": edad, "promedio": promedio})
    print("Alumno agregado")

def mostrar_alumnos(alumnos):
    # Recorrer la coleccion y mostrar cada registro.
    print("=== Alumnos ===")
    for alumno in alumnos:
        print(alumno["nombre"], "| Edad:", alumno["edad"], "| Promedio:", alumno["promedio"])

def buscar_alumno(alumnos):
    # Mostrar el alumno cuyo nombre coincida, o avisar si no existe.
    nombre = input("Nombre a buscar: ")
    for alumno in alumnos:
        if alumno["nombre"] == nombre:
            print(alumno["nombre"], "| Edad:", alumno["edad"], "| Promedio:", alumno["promedio"])
            return
    print("No existe un alumno con ese nombre")

def main():
    # Menu de repaso: carga al abrir, guarda al salir.
    alumnos = cargar_alumnos()
    while True:
        print(TEXTO_MENU)
        opcion = input("Elija una opcion: ")
        if opcion == "1":
            agregar_alumno(alumnos)
        elif opcion == "2":
            mostrar_alumnos(alumnos)
        elif opcion == "3":
            buscar_alumno(alumnos)
        elif opcion == "0":
            guardar_alumnos(alumnos)
            print("Coleccion guardada en", RUTA_DATOS)
            break
        else:
            print("Opcion invalida")


if __name__ == "__main__":
    main()
```

`alumnos.json` esperado tras el alta de José:

```json
[
  {
    "nombre": "José",
    "edad": 21,
    "promedio": 7.0
  }
]
```

La tilde se ve real porque el guardado usa `ensure_ascii=False`; con el valor por defecto aparecería `Jos\u00e9`.

### Actividad 4 — Solución de referencia: `migrar.py`

```python
# Migracion de alumnos.csv a alumnos_migrados.json

import json

RUTA_CSV = "alumnos.csv"
RUTA_JSON = "alumnos_migrados.json"

def leer_csv(ruta):
    # Leer el CSV a mano y devolver la lista de diccionarios.
    registros = []
    with open(ruta, "r", encoding="utf-8") as f:
        for linea in f:
            linea = linea.strip()
            if linea == "":
                # Las lineas vacias no son registros: se descartan.
                continue
            campos = linea.split(",")
            registros.append({
                "nombre": campos[0].strip(),
                "edad": int(campos[1].strip()),
                "promedio": float(campos[2].strip()),
            })
    return registros

def main():
    # Migrar la coleccion y confirmar la cantidad migrada.
    alumnos = leer_csv(RUTA_CSV)
    with open(RUTA_JSON, "w", encoding="utf-8") as f:
        json.dump(alumnos, f, ensure_ascii=False, indent=2)
    print("Migrados", len(alumnos), "alumnos a", RUTA_JSON)


if __name__ == "__main__":
    main()
```

Salida esperada: `Migrados 3 alumnos a alumnos_migrados.json`, con tres registros y «José» con la tilde real.

### Actividad 5

Respuesta esperada: JSON, porque guarda la colección completa con estructura (listas y diccionarios) en un solo archivo, que es exactamente la persistencia que el proyecto integrador necesita. También se acepta CSV si la razón es el intercambio con planillas.

## Criterios de corrección (100 puntos)

| Actividad | Puntaje completo | Ajustes parciales |
| --- | --- | --- |
| 1 — Mapa | 10: tabla completa con lectura y criterio de elección | Filas incompletas: 4 a 7 |
| 2 — Bloque de datos | 30: cinco errores con corrección y síntoma (6 cada uno) | Corrección sin síntoma: 3 por error |
| 3 — Programa | 35: carga con ambos `except` (10), menú con funciones (10), reintentos de edad y promedio (5), guardado con `ensure_ascii=False` e `indent=2` (10) | `except:` desnudo: descontar 5; sin `sys.exit(1)` en JSON dañado: descontar 3 |
| 4 — Migración | 15: descarte de vacíos (5), conversión de tipos (5), JSON verificado con tilde real (5) | Tildes escapadas en el archivo generado: descontar 3 |
| 5 — Entrega | 10: commit subido con mensaje pedido y elección justificada | Commit local sin push: 5 |

## Qué mirar en la presentación manuscrita

- Que el mapa de formatos distinga «cómo se lee» de «cuándo conviene»: son dos columnas distintas, no una sola.
- En la Actividad 2, que el error 2 se explique como «JSON válido pero ilegible»: es la diferencia entre funcionar y funcionar bien.
- En la Actividad 3, que la apertura cargue una sola vez y que el guardado sea la salida del menú, no una llamada suelta por opción.
