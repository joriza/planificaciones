# Anexo docente — Encuentro 4: Primer programa en Python

## Encuadre

Primer contacto del grupo con Python, con la premisa de que viene de otro lenguaje: las ideas (variable, tipo, entrada, salida) ya las tiene y hoy cambia la sintaxis. No se espera que explique `def` ni el guard: son el esqueleto fijo del curso y se presentan como forma, no como contenido; las funciones se enseñan en la Unidad 2. El objetivo del encuentro es que cada estudiante escriba, ejecute desde la terminal y maneje su primer error previsto. La versión 1 de `gestion_notas.py` es la base del programa único que crece hasta el TP-U1: conviene cuidar la prolijidad desde hoy.

## Qué observar durante la clase

- Quién no logra ejecutar desde la terminal: ruta equivocada, VS Code sin abrir la carpeta, o el archivo guardado en otro lado. Es el cuello de botella típico de este encuentro.
- Confusión `str`/`int`: responder `19` no es lo mismo que escribir `19` sin conversión; pedir que prueben `input()` sin convertir para ver el `TypeError`.
- Reacción al primer `try/except`: algunos copian el bloque sin entenderlo; pedir que borren la línea `except ValueError:` a propósito y lean el traceback que aparece.
- Indentación: mezclar tabulaciones y espacios genera `IndentationError` difícil de leer a esta altura. Exigir 4 espacios desde el primer archivo.
- Que el promedio salga `8.0` y no `8`: buena oportunidad para presentar `float` sin teoría extra.

## Solución completa del ejercicio independiente

```python
import sys


def main():
    # Presentar el programa
    print("=== Registro de notas de la comision ===")

    # Pedir el nombre del estudiante (input devuelve siempre texto)
    nombre = input("Nombre del estudiante: ")

    # Pedir el apellido del estudiante
    apellido = input("Apellido: ")

    # Pedir los datos numericos y convertirlos a entero
    try:
        edad = int(input("Edad: "))
        anio_ingreso = int(input("Anio de ingreso: "))
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
    print(f"Apellido: {apellido}")
    print(f"Edad: {edad}")
    print(f"Anio de ingreso: {anio_ingreso}")
    print(f"Notas: {nota1}, {nota2}, {nota3}")
    print(f"Promedio: {promedio}")


if __name__ == "__main__":
    main()
```

Salida esperada (camino válido):

```
=== Registro de notas de la comision ===
Nombre del estudiante: Ana
Apellido: Perez
Edad: 19
Anio de ingreso: 2024
Nota 1: 8
Nota 2: 7
Nota 3: 9
=== Ficha del estudiante ===
Nombre: Ana
Apellido: Perez
Edad: 19
Anio de ingreso: 2024
Notas: 8, 7, 9
Promedio: 8.0
```

## Errores previsibles

1. **Operar `input()` sin convertir:** `edad = input(...)` y luego comparar o sumar lanza `TypeError`; el dato viene como texto siempre (verificado en el spike con entrada canalizada).
2. **`int("23.5")`:** lanza `ValueError` aunque parezca un número; para decimales corresponde `float()` (comportamiento observado en el spike).
3. **Identificadores con ñ o tildes:** `anio` en lugar de `año`, `comision` en lugar de `comisión`, dentro del código.
4. **Indentación inconsistente:** el cuerpo de `main()` fuera de columna lanza `IndentationError`; es el primer error de sintaxis real del curso.
5. **`except:` desnudo:** anticiparlo y prohibirlo ya: atrapa cualquier error y deja el programa «siguiendo» roto. Siempre la excepción específica.
6. **Comillas curvas al pegar desde un documento:** `SyntaxError` inmediato; el código se escribe y edita en VS Code.

## Criterios de logro (4-8)

| Nivel | Descripción |
|---|---|
| 4 | Escribe el programa pero no logra ejecutarlo desde la terminal sin ayuda. |
| 5 | Ejecuta y obtiene la ficha; no completa el ejercicio independiente. |
| 6 | Agrega apellido y anio de ingreso, pero algún dato no se muestra o falla la conversión. |
| 7 | Ejercicio completo, salida exacta en el camino válido y en el inválido. |
| 8 | Explica con sus palabras qué hace cada línea y qué tipo tiene cada variable. |

## Agrupamiento

Individual, una máquina por estudiante. El primer programa es personal para garantizar que todo el grupo pasa por escribir, guardar y ejecutar desde la terminal. La consulta entre pares está permitida; el archivo, no.

## Ajustes para la siguiente edición

- Si más del 40% no logra ejecutar en los primeros 20 minutos, frenar y dedicar un bloque a la terminal (ruta actual, `cd`, carpeta abierta en VS Code) antes de seguir con el código.
- Si el grupo demuestra soltura con variables y tipos por venir de otro lenguaje, adelantar el camino de error y dejar la conversión `float` como desafío del bloque de actividad complementaria.
