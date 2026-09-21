# Anexo docente — Evaluación de la Unidad 1, Versión A (gestión de notas)

> Documento de uso exclusivo del docente: no entregar a alumnos ni a administración.

## Encuadre docente

La versión A evalúa la secuencia completa trabajada en la unidad sobre el dominio de notas: entrada validada con reingreso, lista de tres notas por registro, promedio con `len()`, clasificación con `if/elif/else`, contadores y acumuladores, y reporte final protegido contra la colección vacía. No hay contenidos de unidades posteriores. La defensa verifica que cada integrante pueda explicar la conversión de la entrada, el uso de la lista y la protección del caso vacío.

## Solución completa (código canon)

```python
def main():
    # Presentar el programa
    print("=== Reporte de notas del parcial ===")

    # Pedir la cantidad de estudiantes, repitiendo mientras no sea valida
    while True:
        try:
            cantidad = int(input("Cantidad de estudiantes: "))
            break
        except ValueError:
            print("Debe ingresar un numero valido")

    # Preparar los contadores y acumuladores del parcial
    promocionados = 0
    regulares = 0
    libres = 0
    suma_promedios = 0.0
    mejor_apellido = ""
    mejor_promedio = -1

    # Procesar cada estudiante del parcial
    for i in range(1, cantidad + 1):
        print(f"--- Estudiante {i} de {cantidad} ---")

        # Pedir el apellido y dejarlo limpio
        entrada = input("Apellido: ")
        partes = entrada.strip().split()
        apellido = " ".join(partes)

        # Pedir las tres notas y guardarlas en una lista
        notas = []
        for numero in range(1, 4):
            # Repetir la lectura de la nota mientras no sea valida
            while True:
                try:
                    nota = int(input(f"Nota {numero}: "))
                    break
                except ValueError:
                    print("Debe ingresar un numero valido")
            # Agregar la nota a la lista
            notas.append(nota)

        # Sumar las notas recorriendo la lista
        suma_notas = 0
        for nota in notas:
            suma_notas = suma_notas + nota

        # Calcular el promedio con la cantidad real de notas
        promedio = suma_notas / len(notas)

        # Decidir la condicion del estudiante y acumularla
        if promedio >= 8:
            condicion = "Promociona"
            promocionados = promocionados + 1
        elif promedio >= 6:
            condicion = "Regular"
            regulares = regulares + 1
        else:
            condicion = "Libre"
            libres = libres + 1

        # Acumular el promedio para el promedio general
        suma_promedios = suma_promedios + promedio

        # Actualizar el mejor promedio del parcial
        if promedio > mejor_promedio:
            mejor_promedio = promedio
            mejor_apellido = apellido

        # Mostrar la ficha del estudiante
        print(f"Apellido: {apellido}")
        print(f"Notas: {notas}")
        print(f"Promedio: {promedio}")
        print(f"Condicion: {condicion}")

    # Mostrar el resumen del parcial
    print("=== Resumen del parcial ===")
    print(f"Promocionados: {promocionados}")
    print(f"Regulares: {regulares}")
    print(f"Libres: {libres}")
    if cantidad > 0:
        promedio_general = suma_promedios / cantidad
        porcentaje_promocionados = promocionados * 100 / cantidad
        print(f"Promedio general: {promedio_general}")
        print(f"Porcentaje de promocionados: {porcentaje_promocionados}")
        print(f"Mejor estudiante: {mejor_apellido} con promedio {mejor_promedio}")
    else:
        # No se ingresaron estudiantes: no hay promedio general
        print("No se ingresaron estudiantes")


if __name__ == "__main__":
    main()
```

## Salida esperada (extracto)

```
=== Reporte de notas del parcial ===
Cantidad de estudiantes: 2
--- Estudiante 1 de 2 ---
Apellido: ana perez
Nota 1: 8
Nota 2: 7
Nota 3: 9
Apellido: ana perez
Notas: [8, 7, 9]
Promedio: 8.0
Condicion: Promociona
--- Estudiante 2 de 2 ---
Apellido: luis gomez
Nota 1: 4
Nota 2: 5
Nota 3: 6
Apellido: luis gomez
Notas: [4, 5, 6]
Promedio: 5.0
Condicion: Libre
=== Resumen del parcial ===
Promocionados: 1
Regulares: 0
Libres: 1
Promedio general: 6.5
Porcentaje de promocionados: 50.0
Mejor estudiante: ana perez con promedio 8.0
```

Con cantidad 0, la salida esperada se reduce al mensaje «No se ingresaron estudiantes».

## Criterios de corrección (100 puntos)

| Criterio | Puntos | Logro completo | Recorte sugerido |
|---|---|---|---|
| Entrada validada | 20 | Todas las conversiones numéricas bajo `try/except ValueError` con reingreso (cantidad y notas) | Sin reingreso en un solo punto: 12; sin `try` en algún punto: 5 |
| Estructuras y cálculo | 25 | Tres notas por estudiante en lista; promedio con `len()`; condición con `if/elif/else` correcta | Promedio o condición con error puntual: 15; sin lista (tres variables sueltas): 10 |
| Reporte final | 15 | Contadores por condición, promedio general, porcentaje y mejor promedio, con guard `if cantidad > 0` | Falta un dato del resumen: 10; sin protección de colección vacía: 5 |
| Estructura y estilo | 20 | Esqueleto canónico, un comentario por acción, identificadores en español sin tildes | Comentarios o tildes: 12; lógica suelta fuera de `main()`: 5 |
| Entrega por GitHub | 20 | Carpeta y archivo correctos, commit convencional, push verificado, sin archivos extra | Commit sin push (verificar en el navegador): 10; carpeta equivocada: 5 |

## Defensa: preguntas sugeridas y respuestas esperadas

| Pregunta | Respuesta esperada |
|---|---|
| ¿Por qué la conversión va en el renglón del `input()`? | Porque `input()` devuelve `str`: sin `int()` la operación numérica lanza `TypeError`. |
| ¿Qué pasa si el usuario escribe una letra en una nota? | `int()` lanza `ValueError`; el `except` avisa y el `while True` vuelve a pedir. |
| ¿Por qué el resumen está dentro de `if cantidad > 0`? | Porque con 0 estudiantes el promedio general y el porcentaje dividen por cero. |
| ¿Qué guarda `notas` y cómo se recorre? | Una lista con las tres notas del estudiante; se suma recorriéndola con `for` y se promedia con `len(notas)`. |
| ¿Por qué `mejor_promedio` arranca en `-1`? | Porque las notas no son negativas: el primer promedio siempre lo supera y queda registrado. |

## Errores previsibles

1. Operar `input()` sin convertir: `TypeError` en la primera suma o comparación.
2. `int("23.5")`: `ValueError` observado; los decimales corresponden a `float()`, pero la consigna pide notas enteras.
3. Contadores inicializados dentro del `for`: el resumen termina en 1; detectarlo con la corrida de dos estudiantes.
4. División por cero con cantidad 0: probar ese camino antes de entregar.
5. `except:` desnudo: prohibido; siempre `except ValueError:`.
6. `commit` sin `push`: la entrega vale lo publicado en GitHub.

## Equivalencia con la versión B

| Elemento | Versión A (notas) | Versión B (inventario) |
|---|---|---|
| Registro | Estudiante (apellido + 3 notas) | Producto (nombre + stock en 3 depósitos) |
| Promedio por registro | Promedio de notas | Promedio de stock |
| Clasificación | Promociona / Regular / Libre | Crítico / Bajo / Suficiente |
| Resumen | Contadores, promedio general, porcentaje de promocionados, mejor estudiante | Contadores, promedio general, porcentaje de suficientes, mejor producto |
| Caso límite | Cantidad 0 | Cantidad 0 |

Mismas estructuras, mismas exigencias y misma rúbrica: solo cambia el dominio de los datos.
