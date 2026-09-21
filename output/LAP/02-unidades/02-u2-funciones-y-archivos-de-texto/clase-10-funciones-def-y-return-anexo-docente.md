# Anexo docente — Encuentro 10: Funciones: def y return

## Encuadre

Primer encuentro de la Unidad 2 (Funciones y archivos de texto). Los estudiantes llegan con la Unidad 1 cerrada: variables, condicionales, bucles, listas y cadenas, más el ciclo Git completo del Encuentro 7. Hoy se incorpora la descomposición del programa en funciones y el esqueleto canónico del `.py`. Arranca el ejercicio progresivo único de la unidad: una agenda de contactos (`tp-u2/agenda.py`) que crece encuentro a encuentro hasta ser el TP-U2 (agenda en archivo de texto). Hoy queda en memoria; el archivo entra en el Encuentro 11.

El carácter es conceptual: importa más la distinción definir/llamar y el rol de `return` que la cantidad de funciones escritas.

## Qué observar durante la clase

- Confusión definir vs. llamar: buscan un «resultado» en el renglón del `def` o esperan que definir la función la ejecute.
- Funciones sin `return` que «funcionan a medias»: imprimen pero no devuelven, y el valor no queda disponible en `main()`.
- Parámetros ignorados: dentro de la función escriben de nuevo el `input()` en lugar de usar el parámetro recibido.
- Indentación del cuerpo del `def`: cuerpo fuera de la función o mezcla de tabulaciones y espacios.
- Guard mal copiado: `if __name__ == "__main__":` sin los dos puntos finales, o `main()` fuera del `if`.
- Reuso desaprovechado en el ejercicio: duplican el `int(input(...))` con su `try` en vez de llamar a `pedir_edad()`.

## Solución completa del ejercicio independiente

Versión final de `agenda.py` con la opción 4 integrada:

```python
# Agenda de contactos - version 1: funciones con datos en memoria

TEXTO_MENU = """
1) Alta de contacto
2) Lista de contactos
3) Buscar por nombre
4) Mayores de una edad
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

def contar_mayores(contactos, edad_minima):
    # Contar cuantos contactos superan la edad minima.
    contador = 0
    for i in range(len(contactos)):
        if contactos[i][2] > edad_minima:
            contador = contador + 1
    return contador

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
        elif opcion == "4":
            edad_minima = pedir_edad()
            print("Mayores de", edad_minima, ":", contar_mayores(contactos, edad_minima))
        elif opcion == "0":
            break
        else:
            print("Opcion invalida")

if __name__ == "__main__":
    main()
```

Salida esperada de la opción 4:

```
Elija una opcion: 4
Edad: 20
Mayores de 20 : 2
```

## Errores previsibles

1. **Lógica suelta fuera de funciones:** restando el esqueleto, escriben el menú a nivel de módulo. Verificado en el spike del curso: al importar el archivo, ese código se ejecuta igual; el guard solo protege `main()`. Corrección: constantes → funciones → `main()` → guard.
2. **Operar `input()` sin convertir:** `input()` devuelve `str`; `"23" > 20` lanza `TypeError`. Corrección: `int(input(...))` en el renglón, dentro del `try` de `pedir_edad()`.
3. **`except:` desnudo:** atrapa cualquier error y el programa «sigue» roto sin decir por qué. Corrección: `except ValueError:` con la excepción específica y el mensaje canónico «Debe ingresar un numero valido».
4. **`int("23.5")`:** lanza `ValueError` aunque parezca un número. Para la edad, que es entera, `int()` es correcto; el caso «número con decimales» se retoma con `float()` en el Encuentro 14 (promedio de edades).
5. **Olvidar el `return` del contador:** `contar_mayores` cuenta bien pero devuelve `None`; al imprimir aparece `None` en lugar del número. Corrección: `return contador` al final del bucle.

## Criterios de logro (4-8)

| Nivel | Descripción |
|---|---|
| 4 | El programa corre el menú, pero las funciones no se usan: lógica repetida o suelta fuera de funciones. |
| 5 | Alta y lista funcionan con funciones, pero `buscar_contacto` no devuelve la posición o devuelve `None`. |
| 6 | Las tres opciones funcionan; falta el guard, o `pedir_edad` no reintenta ante `ValueError`. |
| 7 | Esqueleto canónico completo; opción 4 con `contar_mayores` devolviendo el conteo; dos caminos probados. |
| 8 | Reuso real: la opción 4 llama a `pedir_edad()`; explica definir vs. llamar y por qué nada va suelto a nivel de módulo. |

## Agrupamiento

Individual, en parejas solo si faltan máquinas. Cada estudiante trabaja en su propio repositorio con la carpeta `tp-u2/`; el commit de cierre es individual.

## Ajustes para la siguiente edición

- Si el menú `while` de la Unidad 1 no está fresco, dedicar los primeros 10 minutos del desarrollo a reconstruirlo en pizarra antes de partirlo en funciones.
- Si el ejercicio de `contar_mayores` se resuelve rápido, adelantar la actividad complementaria (validaciones de nombre y teléfono) dentro del desarrollo.
- Si aparece de forma generalizada el error de definir funciones después de `main()`, abrir el Encuentro 11 mostrando el esqueleto canónico completo en pizarra.
