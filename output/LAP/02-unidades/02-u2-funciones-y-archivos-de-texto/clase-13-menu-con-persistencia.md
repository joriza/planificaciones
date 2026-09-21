# Encuentro 13: Menú con persistencia

## Datos del encuentro

| Campo | Valor |
|---|---|
| Unidad | U2: Funciones y archivos de texto |
| Encuentro | 13 de 20 |
| Duración | 120 minutos |
| Carácter | Procedimental |

## Objetivos de aprendizaje

- Integrar carga, menú, funciones y guardado en un único `.py` con el esqueleto canónico.
- Eliminar un contacto de la lista y reescribir el archivo tras el cambio.
- Decidir cuándo alcanza el modo `"a"` y cuándo hace falta reescribir con `"w"`.
- Probar el ciclo completo: abrir, modificar, guardar y reabrir.

## Reparto de tiempos (120 minutos)

| Bloque | Minutos |
|---|---|
| Apertura y motivación | 10 |
| Desarrollo teórico-práctico | 60 |
| Consolidación y cierre | 20 |
| Actividad complementaria | 30 |

## Charla rápida

La agenda de bolsillo se usa así: se abre el cuaderno, se consulta, se anota o se tacha, y al cerrarlo lo tachado quedó tachado. El programa de hoy hace exactamente ese ciclo: carga los contactos al abrir, los modifica en memoria según el menú, y al salir reescribe el archivo. Todo el programa vive en un único `.py`, ordenado con el esqueleto canónico: constantes arriba, funciones después, `main()` como encargado del ciclo, y el guard al final.

## Teoría mínima

### El ciclo completo del dato

```
archivo  --cargar-->  memoria  --modificar (menu)-->  memoria  --guardar-->  archivo
```

La memoria es la zona de trabajo: rápido, pero se pierde al apagar. El archivo es el estado definitivo: lento de cambiar, pero persistente. Cargar es leer con `"r"`; guardar es escribir con `"w"` el conjunto completo.

### Eliminar: buscar, borrar en memoria, reescribir

```python
def eliminar_contacto(contactos, nombre):
    # Eliminar el contacto por nombre y reescribir el archivo.
    posicion = buscar_contacto(contactos, nombre)
    if posicion == -1:
        print("No existe un contacto con ese nombre")
        return
    del contactos[posicion]
    guardar_contactos(contactos)
    print("Contacto eliminado y archivo actualizado")
```

Dos detalles: primero se busca y se valida la posición (`del` con una posición inexistente corta el programa); después, eliminar exige reescribir todo con `"w"`, porque el modo `"a"` solo agrega: nunca borra.

### Cuándo `"a"` y cuándo `"w"`

- Alta de un contacto: `"a"` alcanza (se pega una línea al final).
- Eliminar o editar: `"w"` obligatorio (la línea vieja tiene que desaparecer, y solo la reescritura total lo logra).
- Guardar la salida: siempre `"w"` (reescribe la agenda completa desde la memoria).

### Un solo `.py`, orden fijo

Constantes (`TEXTO_MENU`, `RUTA_DATOS`) → funciones → `main()` → guard. Nada de lógica suelta: al importar el archivo, el código a nivel de módulo se ejecuta igual.

## Práctica guiada: el programa completo

**Paso 1:** agregar `eliminar_contacto` (la de la teoría) y la opción 4 al menú.

**Paso 2:** ordenar `agenda.py` con el esqueleto canónico. El programa completo queda así:

```python
# Agenda de contactos - version final: menu con persistencia en archivo

TEXTO_MENU = """
1) Alta de contacto
2) Lista de contactos
3) Buscar por nombre
4) Eliminar contacto
5) Ver el archivo de datos
6) Guardar ahora
7) Mayores de una edad
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
    return [nombre, telefono, edad]

def mostrar_contacto(contacto, posicion):
    # Mostrar un contacto con su posicion en la lista.
    print(posicion, "-", contacto[0], "| Tel:", contacto[1], "| Edad:", contacto[2])

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
                contactos.append([nombre, telefono, edad])
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
            linea = contacto[0] + "," + contacto[1] + "," + str(contacto[2]) + "\n"
            f.write(linea)

def agregar_al_archivo(contacto):
    # Agregar un contacto al final del archivo sin borrar lo anterior.
    with open(RUTA_DATOS, "a", encoding="utf-8") as f:
        linea = contacto[0] + "," + contacto[1] + "," + str(contacto[2]) + "\n"
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
        elif opcion == "0":
            guardar_contactos(contactos)
            print("Agenda guardada en", RUTA_DATOS)
            break
        else:
            print("Opcion invalida")

if __name__ == "__main__":
    main()
```

**Paso 3:** probar el ciclo completo: abrir (carga lo guardado), eliminar un contacto, salir, y reabrir para verificar que ya no está. Verificar también `contactos.txt` en VS Code.

**Paso 4:** probar los dos caminos de cada operación nueva: eliminar un nombre que existe y uno que no existe.

## Ejercicio independiente: editar el teléfono

Agregar la opción `8) Editar telefono` con una función `editar_telefono(contactos, nombre, telefono_nuevo)` que reemplace el teléfono del contacto y reescriba el archivo.

**Pista:** reutilizar `buscar_contacto` para la posición; el nuevo teléfono se reemplaza en memoria con `contactos[posicion][1] = telefono_nuevo`. ¿Sirve `"a"` acá? No: la línea vieja del archivo sigue estando, y agregar otra no la corrige — hace falta la reescritura total.

**Solución esperada:**

```python
def editar_telefono(contactos, nombre, telefono_nuevo):
    # Reemplazar el telefono del contacto y reescribir el archivo.
    posicion = buscar_contacto(contactos, nombre)
    if posicion == -1:
        print("No existe un contacto con ese nombre")
        return
    contactos[posicion][1] = telefono_nuevo
    guardar_contactos(contactos)
    print("Telefono actualizado y archivo reescrito")
```

## Actividad complementaria

Sobre la extensión de la unidad: opciones extra al menú. Agregar `8) Cantidad de contactos` que muestre cuántos hay en memoria y cuántas líneas tiene el archivo, y comparar ambos números: si difieren, hay cambios sin guardar. Es un ejercicio de diagnóstico: obliga a pensar qué se modificó en memoria y qué llegó al disco.

## Rutina de cierre (git)

```bash
git add .
git commit -m "tp-u2: menu completo con eliminacion y persistencia"
git push
```

## Cierre

**Qué te llevas:** el ciclo archivo → memoria → archivo es el patrón de todo programa con persistencia. Eliminar y editar exigen reescribir con `"w"`; el alta alcanza con `"a"`. Un solo `.py` con el esqueleto canónico: constantes, funciones, `main()` y guard.

**Lo que viene:** el Encuentro 14 cierra la unidad: repaso integrador, la personalización final de la agenda y la entrega del TP-U2 por GitHub.

## Errores comunes y trampas

| Error | Causa | Solución |
|---|---|---|
| `del contactos[i]` sin validar la posición | La posición viene de `buscar_contacto`, que puede devolver `-1`. | Validar `if posicion == -1` antes del `del`. |
| Eliminar en memoria y no reescribir el archivo | El cambio queda solo en memoria: al reabrir, el contacto volvió. | Terminar la operación con `guardar_contactos(contactos)`. |
| Guardar la salida con `"a"` | El archivo crece con la agenda completa cada vez que se sale. | La agenda completa se reescribe con `"w"`; `"a"` es solo para el alta. |
| Editar con `"a"` | La línea vieja sigue en el archivo y la nueva se agrega: contacto duplicado con datos distintos. | Reescribir todo con `"w"` tras editar. |
| Cargar dos veces en la misma corrida | Se llama a `cargar_contactos()` más de una vez y la lista se duplica. | Cargar una sola vez, al inicio de `main()`. |
| Listado desordenado (funciones después de `main`) | Al importar el archivo, el código a nivel de módulo se ejecuta igual y aparece `NameError`. | Esqueleto canónico: constantes → funciones → `main()` → guard. |
