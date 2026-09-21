# Encuentro 10: Funciones: def y return

## Datos del encuentro

| Campo | Valor |
|---|---|
| Unidad | U2: Funciones y archivos de texto |
| Encuentro | 10 de 20 |
| Duración | 120 minutos |
| Carácter | Conceptual |

## Objetivos de aprendizaje

- Definir funciones con `def`, parámetros y `return`.
- Distinguir definir una función de llamarla.
- Reutilizar una misma función desde varios puntos del programa.
- Organizar el archivo `.py` con el esqueleto canónico: constantes, funciones, `main()` y guard.

## Reparto de tiempos (120 minutos)

| Bloque | Minutos |
|---|---|
| Apertura y motivación | 10 |
| Desarrollo teórico-práctico | 60 |
| Consolidación y cierre | 20 |
| Actividad complementaria | 30 |

## Charla rápida

En la Unidad 1 cada programa era una sola tanda de instrucciones de arriba abajo. Hoy empieza la Unidad 2, donde los programas se escriben por partes. Una función es como un contacto guardado en el teléfono: se le pone un nombre una vez y, cada vez que se lo llama, ocurre siempre lo mismo, sin volver a tipear el número. El programa de esta unidad es una agenda de contactos: en el TP-U2 va a quedar guardada en un archivo de texto, pero hoy la armamos en memoria, con funciones bien separadas.

## Teoría mínima

### Definir con `def` y llamar por su nombre

`def` crea la función; no la ejecuta. Se ejecuta recién cuando alguien la llama:

```python
def mostrar_contacto(contacto):
    # Mostrar un contacto de la agenda.
    print(contacto[0], "| Tel:", contacto[1])

# Llamar a la funcion con un dato de prueba
mostrar_contacto(["Ana", "4567"])
```

### Parámetros y `return`

Los **parámetros** son los datos que entran; `return` es el dato que sale:

```python
def buscar_contacto(contactos, nombre):
    # Devolver la posicion del contacto o -1 si no existe.
    for i in range(len(contactos)):
        if contactos[i][0] == nombre:
            return i
    return -1
```

Quien llama recibe el valor y decide qué hacer con él: `posicion = buscar_contacto(agenda, "Ana")`.

### El esqueleto canónico del `.py`

Orden fijo, siempre igual:

1. `import` de la biblioteca estándar, solo los que se usan.
2. Constantes en `MAYUSCULAS_CON_GUIONES_BAJOS` (rutas de datos, textos de menú).
3. Funciones con `def`.
4. `def main():` como punto de entrada.
5. `if __name__ == "__main__":` llamando a `main()`, siempre al final.

Nada de lógica suelta fuera de funciones: si el archivo se importa como módulo, el código a nivel de módulo se ejecuta igual.

### Una función que valida

Conviene que la conversión numérica viva en su propia función y reintente el `input()`:

```python
def pedir_edad():
    # Pedir la edad y repetir hasta que sea un numero entero valido.
    while True:
        try:
            edad = int(input("Edad: "))
            return edad
        except ValueError:
            print("Debe ingresar un numero valido")
```

Esa función se usa desde cualquier parte del programa donde se necesite una edad: escribir una vez, llamar siempre.

## Práctica guiada: la agenda en memoria

Armamos la primera versión de la agenda: un menú con `while` como en la Unidad 1, pero repartido en funciones. Los datos viven en una lista en memoria y se pierden al apagar: eso se arregla en los próximos encuentros.

**Paso 1:** dentro del repositorio del grupo, crear la carpeta `tp-u2/` y el archivo `agenda.py`.

**Paso 2:** escribir:

```python
# Agenda de contactos - version 1: funciones con datos en memoria

TEXTO_MENU = """
1) Alta de contacto
2) Lista de contactos
3) Buscar por nombre
0) Salir
"""

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

def main():
    # Menu principal de la agenda (datos solo en memoria).
    contactos = []
    while True:
        print(TEXTO_MENU)
        opcion = input("Elija una opcion: ")
        if opcion == "1":
            contactos.append(pedir_contacto())
        elif opcion == "2":
            mostrar_contactos(contactos)
        elif opcion == "3":
            nombre = input("Nombre a buscar: ")
            posicion = buscar_contacto(contactos, nombre)
            if posicion == -1:
                print("No existe un contacto con ese nombre")
            else:
                print("Esta en la posicion", posicion)
        elif opcion == "0":
            break
        else:
            print("Opcion invalida")

if __name__ == "__main__":
    main()
```

**Paso 3:** ejecutar desde la terminal:

```bash
python agenda.py
```

Salida esperada (fragmento):

```
Elija una opcion: 1
Nombre: Ana
Telefono: 4567
Edad: 23

Elija una opcion: 2
=== Contactos ===
0 - Ana | Tel: 4567 | Edad: 23
```

**Paso 4:** probar los dos caminos: el normal (alta y lista) y el de error (buscar un nombre que no existe; escribir la edad con letras y verificar el reintento).

## Ejercicio independiente: contar mayores de una edad

Agregar la función `contar_mayores(contactos, edad_minima)` que devuelva cuántos contactos superan esa edad, y la opción `4) Mayores de una edad` en el menú.

**Pista:** recorrer la lista con un contador; la edad de cada contacto está en `contactos[i][2]`. Para pedir la edad mínima, reutilizar `pedir_edad()` en vez de escribir un `input` nuevo.

**Solución esperada:**

```python
def contar_mayores(contactos, edad_minima):
    # Contar cuantos contactos superan la edad minima.
    contador = 0
    for i in range(len(contactos)):
        if contactos[i][2] > edad_minima:
            contador = contador + 1
    return contador
```

Y en el menú:

```python
        elif opcion == "4":
            edad_minima = pedir_edad()
            print("Mayores de", edad_minima, ":", contar_mayores(contactos, edad_minima))
```

## Actividad complementaria

Sobre la extensión de la unidad: agregar validaciones de datos. Escribir `pedir_nombre()` que repita el `input()` mientras el texto esté vacío (`if nombre == "":`), y lo mismo para el teléfono. Hacer que `pedir_contacto()` use esas funciones en lugar de los `input` sueltos: validar una vez, reutilizar siempre.

## Rutina de cierre (git)

```bash
git add .
git commit -m "tp-u2: funciones para la agenda"
git push
```

> **Importante:** un commit por encuentro. El mensaje va en español, sin tildes, después de los dos puntos.

## Cierre

**Qué te llevas:** una función se define una vez con `def` y se llama muchas veces. Los parámetros entran, `return` sale. El esqueleto canónico ordena el archivo: constantes, funciones, `main()` y guard. Las conversiones numéricas viven en funciones que reintentan el `input()`.

**Lo que viene:** la agenda de hoy se borra al cerrar el programa. En el Encuentro 11 empieza la persistencia: leer los contactos desde un archivo de texto con `with open`, y el primer `FileNotFoundError` de la cursada.

## Errores comunes y trampas

| Error | Causa | Solución |
|---|---|---|
| `NameError` al llamar una función | Se la llama antes de haberla definido: Python ejecuta el archivo de arriba abajo. | Definir todas las funciones antes de `main()`; llamar recién dentro de `main()`. |
| La función no devuelve nada | Falta `return`: la función devuelve `None` y el dato se pierde. | Terminar con `return valor` y asignar el resultado al llamar. |
| Escribir paréntesis en la definición y no en la llamada (o al revés) | Confundir definir (`def f():`) con llamar (`f()`). | `def` lleva paréntesis en el encabezado; la llamada también lleva paréntesis. |
| `TypeError` al comparar la edad | `input()` devuelve `str`; comparar texto con número lanza `TypeError`. | Convertir en el mismo renglón: `edad = int(input("Edad: "))`, dentro del `try`. |
| `except:` desnudo | Atrapa cualquier error y el programa sigue roto sin decir por qué. | `except ValueError:` siempre con la excepción específica. |
| Lógica suelta fuera de funciones | Al importar el archivo, el código a nivel de módulo se ejecuta igual. | Constantes → funciones → `main()` → guard `if __name__ == "__main__":`. |
