# Convenciones técnicas — Programación en Python

> **Canon del curso.** Esta hoja es la fuente única de verdad de tipos, formatos y estructura de código de la materia «Programación en Python». Todos los documentos de la materia la obedecen: **toda divergencia con esta hoja es un defecto**, no una variación de estilo.

| Campo | Valor |
| --- | --- |
| Curso | Programación en Python (LAP) |
| Registro | Docente y alumnos del curso |
| Base de datos canónica | Sin base de datos: todo se resuelve en memoria (sin archivos, CSV, JSON ni persistencia de ningún tipo) |
| Referencias de apoyo | Spike de verificación Python 3.11 (comportamientos citados por sección, sección 9) |

## 1. Propósito y alcance

- Esta hoja define los **tipos de datos, formatos y estructura del código** de todo el curso: ejemplos de clase, anexos, evaluaciones y trabajos de los alumnos.
- Ante cualquier duda técnica, **esta hoja decide**: el ajuste se hace primero acá y recién después se propaga a los documentos derivados. Nunca al revés.
- **Alcance:** entorno y estructura del programa, estilo de código, tipos canónicos y conversiones, entrada y salida por consola, validación de entrada, control de versiones del alumno y prueba del programa.
- **Fuera de alcance:** el contenido de cada encuentro (lo fija la planificación anual) y el formato pedagógico de los documentos (lo fija `input/estructura-de-la-clase.md`).

## 2. Entorno y estructura del programa

- **Entorno:** VS Code + terminal; Python 3 instalado y verificable con `python --version`.
- **Programa:** cada trabajo o ejemplo vive en **un solo archivo `.py`** en la raíz de su carpeta de trabajo; se ejecuta con `python <archivo>.py` desde la terminal y se corta con `Ctrl+C` si queda esperando entrada.
- **Dónde vive el código:** definiciones de funciones primero, bloque de ejecución principal `if __name__ == "__main__":` al final. Sin carpetas `models/`, `services/` ni división en módulos propios: si no hay alternativa posible, se justifica en el propio archivo con un comentario.
- **Archivos extra:** ninguno. Sin archivos de datos, sin CSV, sin JSON, sin bases de datos: el estado vive en variables y colecciones en memoria.

## 3. Estilo de código

- **Idiomas:** identificadores en inglés y en `snake_case` (`patient_count`, `read_age`); texto visible por consola y comentarios en español.
- **Comentarios:** cada acción relevante del ejemplo lleva un comentario que la explica; el alumno debe poder reconstruir el porqué leyendo el código.
- **Ejemplos:** mínimos, completos y ejecutables tal cual (sin pseudocódigo), de una sola pieza; no superan las 150 líneas por archivo.
- **Prohibido:** clases (POO), programación funcional (lambda, map/filter/reduce), patrones de diseño, type hints exigidos, comprehensions avanzadas y todo lo que funcione como abstracción antes de tiempo. Las funciones (`def`) son la única unidad de organización.

## 4. Tipos canónicos

Tipos únicos para todo el curso, tanto en ejemplos como en trabajos de alumnos (verificados en el spike, sección 9):

| Dato | Tipo | Ejemplo | Regla |
| --- | --- | --- | --- |
| Entero | `int` | `age = 17` | `int()` de texto no numérico lanza `ValueError` (spike 9.1); sin límite de tamaño declarado |
| Real | `float` | `price = 12.5` | La división `/` siempre produce `float` (spike 9.2); no se redondea salvo al mostrar |
| Texto | `str` | `name = "Ana"` | Inmutable (spike 9.3); siempre entre comillas dobles en los ejemplos |
| Lógico | `bool` | `active = True` | `True`/`False` con mayúscula; es subclase de `int` (spike 9.4), no se usa como número |
| Secuencia mutable | `list` | `items = [1, 2]` | Se modifica con métodos (`append`, `pop`, `sort`) que devuelven `None` (spike 9.5) |
| Secuencia inmutable | `tuple` | `point = (1, 2)` | No admite asignación por índice (spike 9.3) |
| Conjunto | `set` | `tags = {1, 2}` | Sin duplicados ni orden (spike 9.6); se crea con literales o `set()` |
| Mapeo | `dict` | `person = {"name": "Ana"}` | Acceso directo lanza `KeyError` si falta la clave (spike 9.7) |

**Conversiones:** la entrada de `input()` es **siempre `str`**; se convierte con `int()`/`float()` dentro de `try/except ValueError` (sección 6). Nunca se presupone el tipo que tipea el usuario.

**Slicing:** `secuencia[i:j]` sobre `str` y `list`; los índices fuera de rango **no lanzan error**, devuelven lo disponible (spike 9.8). Los índices negativos cuentan desde el final.

## 5. Entrada, salida y estado en memoria

Sin base de datos y sin archivos: la única frontera de datos del programa es la consola y su estado vive en variables y colecciones.

- **Entrada:** `input("mensaje: ")` devuelve `str`; todo dato numérico se convierte explícitamente en el momento de leerlo.
- **Salida:** `print()` para todo lo visible; mensajes compuestos con **f-strings** (`f"Total: ${total:.2f}"`), nunca concatenación con `+` para armar mensajes al usuario.
- **Procesamiento de texto:** `split` (sin argumento colapsa espacios repetidos, spike 9.9), `strip` (solo bordes), `join` y `replace` como caja de herramientas canónica para entrada del usuario.
- **Estado:** listas para secuencias que cambian, diccionarios para entidades con claves legibles, `set` para unicidad; se inicializan vacíos y se llenan durante la ejecución.

Ejemplo canónico mínimo, completo y funcional (lectura validada):

```python
def read_int(message):
    # Pide un número hasta obtener uno válido: input() devuelve str
    # y int() lanza ValueError si el texto no es numérico (spike 9.1).
    while True:
        try:
            return int(input(message))
        except ValueError:
            print("Eso no es un número entero; intenta de nuevo.")


if __name__ == "__main__":
    # Bloque de ejecución principal: las funciones viven arriba,
    # el programa arranca acá (spike 9.10).
    age = read_int("Edad: ")
    print(f"En 10 años tendrás {age + 10} años.")
```

## 6. Validación de entrada y errores

| Situación | Tratamiento canónico | Ejemplo |
| --- | --- | --- |
| El usuario tipea texto donde va un número | `try/except ValueError` con reintento (`while True`) | `int(input(...))` dentro de `try` |
| Opción de menú inválida | Mensaje claro y vuelta al menú (no excepción) | `if opcion == "1": ... else: print("Opción inválida")` |
| Clave ausente en diccionario | Solo si el flujo lo exige: `.get()` con valor por defecto o membresía `in` | `person.get("email", "-")` |
| Cualquier otro error | **Nunca** se tapa con `except` genérico sin mensaje: el programa muestra qué pasó y sigue o termina con un mensaje | `except ValueError as error: print("Entrada inválida:", error)` |

- Los mensajes de error visibles al usuario son **en español y accionables** («Eso no es un número entero; intenta de nuevo»), nunca códigos crudos ni trazas.
- `except:` desnudo está prohibido en los ejemplos: siempre se nombra la excepción esperada (`ValueError`).

## 7. Control de versiones del alumno

- **Repositorio:** uno por grupo para todo el curso, con una carpeta por trabajo: `tp-u1/`, `tp-u2/`, `tp-u3/`, `trabajo-final/`.
- **Ramas:** mono-rama `main` hasta la Unidad 4; en la Unidad 4 se pasa a ramas por feature con pull requests revisados y `main` protegida.
- **Ignorados:** `.gitignore` en la raíz con `__pycache__/` y `.vscode/`; nunca se versiona la basura del entorno.
- **Rutina de cierre:** un commit por fin de encuentro (o de clase que quedó sin terminar) con mensaje que refiera al avance: `git add .` + `git commit -m "tp-u1: <avance>"` (español, minúsculas tras los dos puntos) + `git push` cuando hay entrega.

## 8. Ejecutar y probar el programa

- **Arranque:** `python <archivo>.py` desde la terminal, en la carpeta del archivo; en VS Code con el botón Run.
- **Prueba manual canónica:** ejecutar y probar (1) la ruta feliz con datos válidos, (2) entrada no numérica donde se espera número, (3) lista o diccionario vacío, (4) opción de menú inexistente.
- **Cortes:** `Ctrl+C` si el programa queda esperando entrada; cerrar la terminal no guarda nada (todo es memoria).

## 9. Checklist de defectos frecuentes

Verificación rápida antes de cerrar cualquier ejemplo o trabajo (comportamientos observados en el spike, Python 3.11):

| ✔ | Defecto | Por qué falla | Corrección |
| --- | --- | --- | --- |
| ☐ | `lista = lista.append(x)` | `append` devuelve `None` y muta la lista (spike) | `lista.append(x)` en su propia línea |
| ☐ | `lista = lista.sort()` | `sort()` muta y devuelve `None` (spike) | `lista.sort()`, o `lista = sorted(otra)` si hace falta nueva lista |
| ☐ | Olvidar `int()` sobre `input()` | `input()` siempre devuelve `str`; `"2" + "2"` es `"22"` | Convertir al leer, dentro de `try/except ValueError` |
| ☐ | `s[0] = "H"` sobre un `str` | `str` es inmutable: `TypeError` (spike) | Construir nueva cadena (`"H" + s[1:]`) o usar `replace` |
| ☐ | `d["clave"]` sin comprobar | `KeyError` si la clave no existe (spike) | `in`, `.get(clave, default)` o mensaje de error |
| ☐ | `7 / 2` esperando `3` | `/` es división real (`3.5`, spike) | Usar `//` para división entera |
| ☐ | Función sin `return` usada como valor | Toda función sin `return` devuelve `None` (spike) | Agregar `return resultado` |
| ☐ | Variable de función leída afuera | El ámbito local no existe fuera de la función: `NameError` (spike) | Devolver el valor con `return` |
| ☐ | Código suelto fuera del bloque principal | El archivo se organiza: funciones arriba, ejecución en `if __name__ == "__main__":` | Mover la ejecución al bloque principal |
| ☐ | Ejemplo que pide un archivo o base de datos | El curso no usa persistencia de ningún tipo | Replantear el ejemplo con datos en memoria |