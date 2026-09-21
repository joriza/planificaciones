# Encuentro 4: Primer programa en Python

## Datos del encuentro

| Campo | Valor |
|---|---|
| Unidad | U1: Fundamentos de Python |
| Encuentro | 4 de 31 (1 de 5 en la unidad) |
| Duración | 120 minutos |
| Carácter | Conceptual |

## Objetivos de aprendizaje

- Ejecutar un programa desde la terminal con `python gestion_notas.py`.
- Declarar variables de tipo `str`, `int` y `float`.
- Leer datos con `input()` y convertirlos con `int()` en el mismo renglón.
- Mostrar resultados con `print()` y cadenas con formato.
- Manejar el error `ValueError` con un mensaje claro y un código de salida.

## Reparto de tiempos (120 minutos)

| Bloque | Minutos |
|---|---|
| Apertura y motivación | 10 |
| Desarrollo teórico-práctico | 60 |
| Consolidación y cierre | 20 |
| Actividad complementaria | 30 |

## Charla rápida

El intérprete de Python es un traductor simultáneo: lee el programa línea por línea y lo ejecuta en el momento, sin una etapa de compilación previa. Se escribe el archivo, se guarda, y con un comando desde la terminal el programa ya está corriendo. Quien viene de otro lenguaje ya conoce las ideas — variables, tipos, entrada y salida — y hoy solo cambia el idioma: la misma lógica de siempre, escrita con menos ceremonia.

## Teoría mínima

### Entorno y ejecución

- **Entorno:** VS Code + terminal, con Python 3.11 (verificar con `python --version`).
- **Ejecutar:** `python gestion_notas.py` desde la terminal (la de VS Code sirve). El programa se corta con `Ctrl+C`.
- **Un solo archivo `.py` por programa.** No hay proyecto ni compilación: el archivo es el programa.

### Variables y tipos

En Python una variable se crea al asignarle un valor, sin declarar el tipo. Tres tipos para toda la unidad:

| Tipo | Almacena | Ejemplo |
|---|---|---|
| `str` | Texto | `"Ana"` |
| `int` | Números enteros | `19` |
| `float` | Números con decimales | `8.0` |

> **Regla del curso:** identificadores y mensajes en español, en `snake_case` y sin tildes dentro del código (`gestion_notas`, `promedio`). Un comentario por cada acción del programa.

### Entrada y salida

`input()` muestra un mensaje y **siempre devuelve texto** (`str`). Para operar con números hay que convertir en el mismo renglón: `edad = int(input("Edad: "))`. Si el texto no representa un número, `int()` lanza `ValueError`.

`print()` muestra resultados en la consola. Las cadenas con formato (`f"..."`) permiten incrustar variables entre llaves:

```python
print(f"Nombre: {nombre}")
```

### El primer manejo de errores

Un dato inválido no debe dejar que el programa siga con basura. El patrón del curso: `try/except` con la excepción específica, mensaje claro en español y, si el programa no puede continuar, `sys.exit(1)`. Recién en el próximo encuentro ese corte se convertirá en reintento.

## Práctica guiada: la ficha del estudiante

A partir de hoy y hasta el cierre de la unidad se trabaja sobre **un único programa que evoluciona**: `gestion_notas.py`. La versión 1 pide los datos de un estudiante y muestra su ficha con el promedio.

**Paso 1:** crear una carpeta de trabajo personal (fuera del futuro repositorio) y abrir en VS Code.

**Paso 2:** crear el archivo `gestion_notas.py` con este contenido:

```python
import sys


def main():
    # Presentar el programa
    print("=== Registro de notas de la comision ===")

    # Pedir el nombre del estudiante (input devuelve siempre texto)
    nombre = input("Nombre del estudiante: ")

    # Pedir los datos numericos y convertirlos a entero
    try:
        edad = int(input("Edad: "))
        nota1 = int(input("Nota 1: "))
        nota2 = int(input("Nota 2: "))
        nota3 = int(input("Nota 3: "))
    except ValueError:
        # Alguna entrada numerica no es un numero valido
        print("Debe ingresar un numero valido")
        sys.exit(1)

    # Calcular el promedio del estudiante
    promedio = (nota1 + nota2 + nota3) / 3

    # Mostrar la ficha del estudiante
    print("=== Ficha del estudiante ===")
    print(f"Nombre: {nombre}")
    print(f"Edad: {edad}")
    print(f"Notas: {nota1}, {nota2}, {nota3}")
    print(f"Promedio: {promedio}")


if __name__ == "__main__":
    main()
```

Sobre la forma del archivo, que es fija para todo el curso: constantes (cuando las haya), funciones con `def`, `def main():` como punto de entrada y al final el guard `if __name__ == "__main__":`. Por ahora no hace falta entender `def` en profundidad: es el esqueleto fijo de todo programa del curso, y las funciones se estudian en la Unidad 2. Lo importante hoy es que toda la lógica vive dentro de `main()`.

**Paso 3:** ejecutar el programa:

```bash
python gestion_notas.py
```

Salida esperada:

```
=== Registro de notas de la comision ===
Nombre del estudiante: Ana
Edad: 19
Nota 1: 8
Nota 2: 7
Nota 3: 9
=== Ficha del estudiante ===
Nombre: Ana
Edad: 19
Notas: 8, 7, 9
Promedio: 8.0
```

Observar que el promedio sale `8.0`: la división con `/` produce siempre un `float`, incluso cuando el resultado es exacto.

**Paso 4:** probar el camino de error: ejecutar de nuevo y responder `ocho` en la primera nota. El programa muestra el mensaje y termina con código de salida `1` (verificable con `echo %ERRORLEVEL%` en Windows o `echo $?` en Linux/Mac).

## Ejercicio independiente: completar la ficha

Agregar al programa dos campos nuevos: `apellido` (texto) y `anio_ingreso` (entero, por ejemplo `2024`). Mostrarlos en la ficha, después de la edad, con el mismo formato del resto.

**Pista:** `apellido` no necesita conversión (`input` ya devuelve texto); `anio_ingreso` sí va dentro del `try` con las demás conversiones. Cuidar que el nombre del campo no lleve la letra ñ.

**Solución esperada** (los renglones nuevos):

```python
    apellido = input("Apellido: ")
    ...
    anio_ingreso = int(input("Anio de ingreso: "))
    ...
    print(f"Apellido: {apellido}")
    print(f"Anio de ingreso: {anio_ingreso}")
```

La solución completa, con el programa entero, está en el anexo docente.

## Cierre

**Qué llevamos:** Python se escribe en un `.py` y se ejecuta desde la terminal, sin compilación. Las variables nacen al asignar: `str`, `int`, `float`. `input()` devuelve siempre texto y la conversión se hace en el mismo renglón. Un dato inválido se maneja con `try/except` específico, mensaje claro y `sys.exit(1)` si no hay forma de continuar.

**Lo que viene:** el programa de hoy corta ante un dato inválido. En el próximo encuentro se agregan condicionales (`if/elif/else`) y bucles (`while`, `for`) para que el programa pida de nuevo el dato hasta que sea válido, y para decidir la condición del estudiante según su promedio.

## Errores comunes y trampas

| Error | Causa | Solución |
|---|---|---|
| `TypeError: can only concatenate str` | Operar el resultado de `input()` sin convertir: `input()` devuelve `str` siempre. | Convertir en el mismo renglón: `int(input(...))`. |
| `ValueError: invalid literal for int()` | Escribir `"23.5"` o `ocho` donde se espera un entero: `int()` no acepta decimales ni letras. | `float()` para decimales, `int()` solo para enteros; capturar el `ValueError`. |
| `IndentationError` | El cuerpo de `def main():` debe ir indentado; Python usa la indentación como estructura. | Indentar con 4 espacios, siempre los mismos. |
| Comillas curvas `“...”` | Copiar código desde un procesador de textos cambia `"` por comillas tipográficas y el programa no corre. | Escribir el código en VS Code, no en un editor de textos. |
| Nombres con tildes o ñ | `año = int(...)` falla o se vuelve frágil entre teclados. | Identificadores en `snake_case` sin tildes ni ñ: `anio_ingreso`. |
| Cambiar el programa y no ver cambios | El archivo no se guardó antes de ejecutar. | Guardar (`Ctrl+S`) antes de cada `python gestion_notas.py`. |
