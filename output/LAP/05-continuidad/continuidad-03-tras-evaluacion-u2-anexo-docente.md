# Anexo docente — Continuidad pedagógica 3: Repaso de las Unidades 1 y 2

> Anexo de uso exclusivo del docente. No se entrega a los alumnos ni a la administración junto con la actividad.

## Encuadre docente

Tercera continuidad: disponible en el tramo de cierre del primer cuatrimestre (Encuentros 16 a 20). Repasa las Unidades 1 y 2 completas sin adelantar contenido de la Unidad 3. La agenda mínima es una versión reducida del TP-U2: sirve para detectar a los grupos que entregaron el TP sin haberlo comprendido. Los programas siguen las convenciones técnicas del curso.

## Soluciones

### Actividad 2 — Los cinco errores

| Nº | Error | Síntoma | Corrección |
| --- | --- | --- | --- |
| 1 | `open(ruta, "r")` sin `encoding="utf-8"` | Usa la codificación del sistema: una ñ guardada en UTF-8 lanza `UnicodeDecodeError` al releer | `open(ruta, "r", encoding="utf-8")` |
| 2 | `contar_lineas` no tiene `return` | Devuelve `None`: la impresión final muestra `Lineas en el archivo: None` | `return cantidad` al final |
| 3 | `input("Edad: ")` sin convertir | `edad` es `str`: cualquier comparación o suma numérica lanza `TypeError` | `int(input("Edad: "))` con reintento |
| 4 | Modo `"w"` para agregar | `"w"` trunca: el archivo pierde todo lo anterior en cada alta | Modo `"a"` |
| 5 | `except:` desnudo | Oculta cualquier error real (prohibido por la hoja de convenciones) | `except FileNotFoundError:` |

Fragmentos corregidos:

```python
def contar_lineas(ruta):
    # Contar cuantas lineas tiene el archivo de datos.
    with open(ruta, "r", encoding="utf-8") as f:
        cantidad = 0
        for linea in f:
            cantidad = cantidad + 1
    return cantidad

def pedir_edad():
    # Pedir la edad y repetir hasta que sea un numero valido.
    while True:
        try:
            edad = int(input("Edad: "))
            return edad
        except ValueError:
            print("Debe ingresar un numero valido")

def agregar_linea(ruta, linea_nueva):
    # Agregar una linea al final del archivo.
    with open(ruta, "a", encoding="utf-8") as f:
        f.write(linea_nueva + "\n")

def cargar_agenda(ruta):
    # Leer la agenda completa y devolverla como lista.
    try:
        with open(ruta, "r", encoding="utf-8") as f:
            return f.readlines()
    except FileNotFoundError:
        return []
```

### Actividad 3 — Solución de referencia: `agenda.py`

```python
# Agenda minima de repaso: menu, funciones y persistencia en archivo

TEXTO_MENU = """
1) Alta de contacto
2) Lista de contactos
0) Salir
"""

RUTA_DATOS = "agenda.txt"

def pedir_edad():
    # Pedir la edad y repetir hasta que sea un numero valido.
    while True:
        try:
            edad = int(input("Edad: "))
            return edad
        except ValueError:
            print("Debe ingresar un numero valido")

def pedir_contacto():
    # Pedir los datos y devolver el contacto como lista.
    nombre = input("Nombre: ")
    telefono = input("Telefono: ")
    edad = pedir_edad()
    return [nombre, telefono, edad]

def cargar_contactos():
    # Leer el archivo y devolver la lista de contactos.
    try:
        with open(RUTA_DATOS, "r", encoding="utf-8") as f:
            contactos = []
            for linea in f:
                linea = linea.strip()
                if linea == "":
                    continue
                campos = linea.split(",")
                if len(campos) < 3:
                    # Linea danada: se avisa y se descarta.
                    print("Linea invalida en el archivo: se descarta")
                    continue
                contactos.append([campos[0].strip(), campos[1].strip(), int(campos[2].strip())])
            return contactos
    except FileNotFoundError:
        # Primera corrida: todavia no existe el archivo de datos.
        print("No existe el archivo de datos: se empieza de cero")
        return []

def agregar_al_archivo(contacto):
    # Agregar un contacto al final del archivo sin borrar lo anterior.
    with open(RUTA_DATOS, "a", encoding="utf-8") as f:
        f.write(contacto[0] + "," + contacto[1] + "," + str(contacto[2]) + "\n")

def guardar_contactos(contactos):
    # Sobrescribir el archivo con la lista completa, una linea por contacto.
    with open(RUTA_DATOS, "w", encoding="utf-8") as f:
        for contacto in contactos:
            f.write(contacto[0] + "," + contacto[1] + "," + str(contacto[2]) + "\n")

def mostrar_contactos(contactos):
    # Recorrer la lista completa y mostrar cada contacto.
    print("=== Contactos ===")
    for i in range(len(contactos)):
        print(i, "-", contactos[i][0], "| Tel:", contactos[i][1], "| Edad:", contactos[i][2])

def main():
    # Menu con persistencia: carga al abrir, guarda al salir.
    contactos = cargar_contactos()
    while True:
        print(TEXTO_MENU)
        opcion = input("Elija una opcion: ")
        if opcion == "1":
            contacto = pedir_contacto()
            contactos.append(contacto)
            agregar_al_archivo(contacto)
            print("Contacto agregado")
        elif opcion == "2":
            mostrar_contactos(contactos)
        elif opcion == "0":
            guardar_contactos(contactos)
            print("Agenda guardada en", RUTA_DATOS)
            break
        else:
            print("Opcion invalida")


if __name__ == "__main__":
    main()
```

Salida esperada de la segunda corrida (tras dos altas):

```text
=== Contactos ===
0 - Ana | Tel: 4444 | Edad: 19
1 - Luis | Tel: 5555 | Edad: 20
```

### Actividad 4 — Respuestas esperadas

1. Sin `agenda.txt`, el programa avisa «No existe el archivo de datos: se empieza de cero» y arranca con la lista vacía, sin `traceback`.
2. Antes de la corrección, la línea `Ana,444` produce `IndexError` al leer `campos[2]` (el programa corta). Después de agregar el chequeo `if len(campos) < 3: continue`, el programa avisa «Linea invalida en el archivo: se descarta» y sigue con el resto.

## Criterios de corrección (100 puntos)

| Actividad | Puntaje completo | Ajustes parciales |
| --- | --- | --- |
| 1 — Mapa | 10: dos columnas completas más la fila de modos | Columna de U2 incompleta: máximo 6 |
| 2 — Fragmentos | 30: cinco errores con corrección y síntoma (6 cada uno) | Corrección sin síntoma: 3 por error |
| 3 — Agenda | 35: menú con funciones (10), alta con `"a"` (5), lista con filtro de vacíos (10), carga con `FileNotFoundError` (5), salida con `"w"` (5) | Sin esqueleto canónico: descontar 5; `except:` desnudo: descontar 5 |
| 4 — Resistencia | 15: caso 1 explicado (5), caso 2 corregido y verificado (10) | Corrección que corta en vez de descartar: máximo 5 |
| 5 — Entrega | 10: commit subido con mensaje pedido | Commit local sin push: 5 |

## Qué mirar en la presentación manuscrita

- Que la explicación del modo `"w"` incluya la palabra «sobrescribe» o «borra lo anterior»: es el defecto más costoso del TP-U2.
- Que la agenda cargue una sola vez al abrir: dos llamadas a `cargar_contactos()` duplican la lista.
- En la Actividad 4, que el descarte avise antes de continuar: descartar en silencio también es un defecto a corregir.
