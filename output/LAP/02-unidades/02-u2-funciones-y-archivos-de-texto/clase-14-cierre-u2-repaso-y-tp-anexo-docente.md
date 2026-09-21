# Anexo docente — Encuentro 14: Cierre U2 — repaso y TP

## Encuadre

Quinto y último encuentro de la Unidad 2. Los estudiantes integran funciones y archivos de texto en el TP-U2: la agenda en archivo de texto construida como ejercicio progresivo único desde el Encuentro 10. La personalización mínima del TP es el cuarto campo `ciudad`, que obliga a tocar los cuatro puntos del formato de línea (pedir, mostrar, cargar, escribir); el ejercicio independiente agrega una estadística con `return` decimal. La entrega es por GitHub desde el repositorio del grupo, con la rutina de cierre de la unidad.

La modalidad es actitudinal: se evalúa la entrega completa y publicada, no solo el código que corre en el aula. Lo que no está en el último push, no está entregado.

## Qué observar durante la clase

- El campo `ciudad` agregado en algunos puntos y no en otros: se pide pero no se muestra, o se guarda pero no se carga (la carga con tres campos y el archivo de cuatro rompe la carga o pierde la ciudad).
- La línea de armado corregida en `guardar_contactos` pero no en `agregar_al_archivo`: son dos lugares con el mismo formato.
- Entrega incompleta: commit sin push, o push sin commit; verificar `git log --oneline` y el repositorio en GitHub antes de dar por entregado.
- Mensajes del commit con tildes o mayúsculas (`"TP-U2: Entrega!"` en lugar de `tp-u2: entrega de la agenda`).
- Archivo de datos con espacios después de las comas escritos a mano: funciona por el `.strip()` de la carga, pero conviene que lo noten como evidencia de por qué el `strip` está en todos los campos.
- Grupos que entregan el `agenda.py` sin el `contactos.txt`, o con rutas absolutas: la ruta es relativa y el archivo viaja con el programa.

## Solución completa del TP-U2 (referencia docente)

Versión final con el campo `ciudad` y la opción 9:

```python
# Agenda de contactos - TP-U2: agenda en archivo de texto

TEXTO_MENU = """
1) Alta de contacto
2) Lista de contactos
3) Buscar por nombre
4) Eliminar contacto
5) Ver el archivo de datos
6) Guardar ahora
7) Mayores de una edad
8) Editar telefono
9) Promedio de edad
0) Salir
"""

RUTA_DATOS = "contactos.txt"

def pedir_edad():
    # Pedir la edad y repetir hasta que sea un numero entero valido.
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
    ciudad = input("Ciudad: ")
    return [nombre, telefono, edad, ciudad]

def mostrar_contacto(contacto, posicion):
    # Mostrar un contacto con su posicion en la lista.
    print(posicion, "-", contacto[0], "| Tel:", contacto[1], "| Edad:", contacto[2], "| Ciudad:", contacto[3])

def mostrar_contactos(contactos):
    # Recorrer la lista completa y mostrar cada contacto.
    print("=== Contactos ===")
    for i in range(len(contactos)):
        mostrar_contacto(contactos[i], i)

def buscar_contacto(contactos, nombre):
    # Devolver la posicion del contacto o -1 si no existe.
    for i in range(len(contactos)):
        if contactos[i][0] == nombre:
            return i
    return -1

def contar_mayores(contactos, edad_minima):
    # Contar cuantos contactos superan la edad minima.
    contador = 0
    for i in range(len(contactos)):
        if contactos[i][2] > edad_minima:
            contador = contador + 1
    return contador

def promedio_edades(contactos):
    # Calcular el promedio de edad de la agenda.
    if len(contactos) == 0:
        return 0
    suma = 0
    for i in range(len(contactos)):
        suma = suma + contactos[i][2]
    return suma / len(contactos)

def cargar_contactos():
    # Leer el archivo y devolver la lista de contactos guardados.
    try:
        with open(RUTA_DATOS, "r", encoding="utf-8") as f:
            contactos = []
            for linea in f:
                linea = linea.strip()
                if linea == "":
                    continue
                campos = linea.split(",")
                nombre = campos[0].strip()
                telefono = campos[1].strip()
                edad = int(campos[2].strip())
                ciudad = campos[3].strip()
                contactos.append([nombre, telefono, edad, ciudad])
            return contactos
    except FileNotFoundError:
        # Primera corrida: todavia no existe el archivo de datos.
        print("No existe el archivo de datos: se empieza de cero")
        return []

def mostrar_archivo():
    # Mostrar el archivo tal cual, una linea por registro.
    try:
        with open(RUTA_DATOS, "r", encoding="utf-8") as f:
            cantidad = 0
            for linea in f:
                linea = linea.strip()
                if linea == "":
                    continue
                print(linea)
                cantidad = cantidad + 1
            if cantidad == 0:
                print("El archivo no tiene contactos guardados")
    except FileNotFoundError:
        print("No existe el archivo de datos: se empieza de cero")

def guardar_contactos(contactos):
    # Sobrescribir el archivo con la lista completa, una linea por contacto.
    with open(RUTA_DATOS, "w", encoding="utf-8") as f:
        for contacto in contactos:
            linea = contacto[0] + "," + contacto[1] + "," + str(contacto[2]) + "," + contacto[3] + "\n"
            f.write(linea)

def agregar_al_archivo(contacto):
    # Agregar un contacto al final del archivo sin borrar lo anterior.
    with open(RUTA_DATOS, "a", encoding="utf-8") as f:
        linea = contacto[0] + "," + contacto[1] + "," + str(contacto[2]) + "," + contacto[3] + "\n"
        f.write(linea)

def eliminar_contacto(contactos, nombre):
    # Eliminar el contacto por nombre y reescribir el archivo.
    posicion = buscar_contacto(contactos, nombre)
    if posicion == -1:
        print("No existe un contacto con ese nombre")
        return
    del contactos[posicion]
    guardar_contactos(contactos)
    print("Contacto eliminado y archivo actualizado")

def editar_telefono(contactos, nombre, telefono_nuevo):
    # Reemplazar el telefono del contacto y reescribir el archivo.
    posicion = buscar_contacto(contactos, nombre)
    if posicion == -1:
        print("No existe un contacto con ese nombre")
        return
    contactos[posicion][1] = telefono_nuevo
    guardar_contactos(contactos)
    print("Telefono actualizado y archivo reescrito")

def main():
    # Menu principal con persistencia: carga al abrir, guarda al salir.
    contactos = cargar_contactos()
    while True:
        print(TEXTO_MENU)
        opcion = input("Elija una opcion: ")
        if opcion == "1":
            contacto = pedir_contacto()
            contactos.append(contacto)
            agregar_al_archivo(contacto)
            print("Contacto agregado a", RUTA_DATOS)
        elif opcion == "2":
            mostrar_contactos(contactos)
        elif opcion == "3":
            nombre = input("Nombre a buscar: ")
            posicion = buscar_contacto(contactos, nombre)
            if posicion == -1:
                print("No existe un contacto con ese nombre")
            else:
                print("Esta en la posicion", posicion)
        elif opcion == "4":
            nombre = input("Nombre a eliminar: ")
            eliminar_contacto(contactos, nombre)
        elif opcion == "5":
            mostrar_archivo()
        elif opcion == "6":
            guardar_contactos(contactos)
            print("Agenda guardada en", RUTA_DATOS)
        elif opcion == "7":
            edad_minima = pedir_edad()
            print("Mayores de", edad_minima, ":", contar_mayores(contactos, edad_minima))
        elif opcion == "8":
            nombre = input("Nombre a editar: ")
            telefono_nuevo = input("Telefono nuevo: ")
            editar_telefono(contactos, nombre, telefono_nuevo)
        elif opcion == "9":
            print("Promedio de edad:", promedio_edades(contactos))
        elif opcion == "0":
            guardar_contactos(contactos)
            print("Agenda guardada en", RUTA_DATOS)
            break
        else:
            print("Opcion invalida")

if __name__ == "__main__":
    main()
```

Formato esperado de `contactos.txt` (cuatro campos por línea):

```
Ana,4567,23,Rosario
Luis,7890,35,Cordoba
Mara,3210,19,Santa Fe
```

## Errores previsibles

1. **Campo nuevo a medias:** `ciudad` se pide y se guarda, pero `cargar_contactos` sigue leyendo tres campos: la agenda reabierta pierde la ciudad o revienta. Corrección: los cuatro puntos del formato (pedir, mostrar, cargar, escribir) siempre juntos.
2. **Formato distinto en las dos escrituras:** la línea corregida en `guardar_contactos` pero no en `agregar_al_archivo` deja líneas de tres campos mezcladas con líneas de cuatro. Corrección: mismo armado de línea en ambas funciones.
3. **Commit sin push (o push sin commit):** el trabajo queda en la máquina del aula. Corrección: `git log --oneline` local y verificación del repositorio en GitHub como paso de cierre obligatorio.
4. **Mensaje de commit fuera de convención:** tildes, mayúsculas o sin el prefijo de carpeta (`"Entrega TP 2"`). Corrección: `tp-u2: <resumen en espanol, sin tildes>`.
5. **`contactos.txt` faltante en el repositorio:** el programa corre en el aula pero el grupo evaluador no puede probar la carga. Corrección: verificar que el push incluya `tp-u2/agenda.py` y `tp-u2/contactos.txt`.
6. **`int()` sobre un campo desplazado:** con el formato de cuatro campos, si la carga sigue leyendo `campos[2]` como ciudad (o al revés), `int("Rosario")` lanza `ValueError`. Es el mismo error de tipos del borde: revisar los índices al tocar el formato.

## Criterios de logro (4-8)

| Nivel | Descripción |
|---|---|
| 4 | El programa corre parcialmente: carga o guarda, pero no el ciclo completo; sin entrega publicada. |
| 5 | Ciclo completo funcionando en el aula; la entrega en GitHub está incompleta (sin push o sin `contactos.txt`). |
| 6 | Entrega publicada completa; el campo `ciudad` funciona en la memoria pero se pierde al reabrir, o el mensaje de commit no cumple la convención. |
| 7 | TP completo: cuatro campos end-to-end, modos `"w"`/`"a"` correctos, esqueleto canónico, checklist íntegra, commit y push verificados. |
| 8 | Todo lo del 7, más la opción 9 funcionando y una explicación clara de cuándo `"a"` y cuándo `"w"` sobre el código propio del grupo. |

## Agrupamiento

Grupal (2 a 3 integrantes), un solo repositorio por grupo con una sola carpeta `tp-u2/`. Los integrantes pueden trabajar en una máquina compartida o con pantalla compartida; el push final es del grupo. En mono-rama `main`, sin ramas: la profesionalización del repositorio llega en la Unidad 4.

## Ajustes para la siguiente edición

- Si más de un tercio de los grupos no completa el push en clase, abrir la Unidad 3 con 15 minutos de resolución de entregas y revisar la rutina de cierre de los encuentros previos.
- Si el campo `ciudad` resulta insuficiente como personalización, ofrecer como extensión una segunda estadística (contactos por ciudad) en lugar de un quinto campo.
- Si el repaso relámpago muestra fragilidad generalizada en los modos `"w"`/`"a"`, dedicar la apertura a un experimento en vivo de truncado antes de liberar el trabajo del TP.
