# Anexo docente — Encuentro 6: Listas y cadenas

## Encuadre

Último encuentro de código antes del ciclo de Git: la versión 3 cierra la forma del programa que se entregará en el TP-U1. Conceptualmente hay dos saltos: los datos pasan de variables sueltas a una colección (y el `3` hardcodeado del promedio se reemplaza por `len(notas)`), y el texto pasa de etiqueta a material procesable. Los métodos de cadena se presentan con los ejemplos verificados en el spike de la hoja de convenciones, no como definiciones de manual. El ejercicio de máximo y mínimo es el primer algoritmo de búsqueda del curso: conviene resolverlo primero en el pizarrón con tres valores y luego pasarlo a código.

## Qué observar durante la clase

- `join()` sobre enteros: es el `TypeError` del encuentro. Hacerlo ocurrir a propósito una vez y leer el mensaje completo.
- Estudiantes que inicializan `mayor = 0`: con notas positivas funciona y es difícil de detectar; pedir el argumento de por qué `notas[0]` es mejor punto de partida.
- El `print(notas)` de verificación que queda en el archivo: la lista se muestra en formato interno `[8, 7, 9]`; diferenciarlo del formato pensado para el usuario (`8 - 7 - 9`).
- Nombres con doble espacio en el medio: `strip()` no los arregla; `split()` + `join()` sí. Es la mejor demostración de por qué se combinan los tres métodos.
- Quienes copian la versión 3 sin entender la diferencia con la 2: pedir que señalen las tres diferencias concretas (lista, `len()`, cadenas) antes de ejecutar.

## Solución completa del ejercicio independiente

```python
def main():
    # Presentar el programa
    print("=== Registro de notas de la comision ===")

    # Pedir el nombre completo del estudiante
    entrada = input("Nombre completo: ")

    # Limpiar los bordes y separar por espacios
    partes = entrada.strip().split()

    # Volver a unir las partes con un solo espacio
    nombre = " ".join(partes)

    # Pedir la edad, repitiendo mientras el dato no sea valido
    while True:
        try:
            edad = int(input("Edad: "))
            break
        except ValueError:
            print("Debe ingresar un numero valido")

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

    # Buscar la mayor y la menor nota recorriendo la lista
    mayor = notas[0]
    menor = notas[0]
    for nota in notas:
        if nota > mayor:
            mayor = nota
        if nota < menor:
            menor = nota

    # Convertir las notas a texto para poder unirlas
    textos = []
    for nota in notas:
        textos.append(str(nota))

    # Unir las notas con un separador legible
    texto_notas = " - ".join(textos)

    # Decidir la condicion del estudiante segun el promedio
    if promedio >= 8:
        condicion = "Promociona"
    elif promedio >= 6:
        condicion = "Regular"
    else:
        condicion = "Libre"

    # Mostrar la ficha del estudiante
    print(f"=== Ficha de {nombre.upper()} ===")
    print(f"Nombre: {nombre}")
    print(f"Edad: {edad}")
    print(f"Notas: {texto_notas}")
    print(f"Promedio: {promedio}")
    print(f"Condicion: {condicion}")
    print(f"Mayor nota: {mayor}")
    print(f"Menor nota: {menor}")


if __name__ == "__main__":
    main()
```

Salida esperada:

```
=== Registro de notas de la comision ===
Nombre completo: ana perez
Edad: 19
Nota 1: 8
Nota 2: 5
Nota 3: 9
=== Ficha de ANA PEREZ ===
Nombre: ana perez
Edad: 19
Notas: 8 - 5 - 9
Promedio: 7.333333333333333
Condicion: Regular
Mayor nota: 9
Menor nota: 5
```

El promedio no exacto (`7.3333...`) es una oportunidad de cierre: la división con `/` produce `float` y la salida muestra todos sus decimales; el formato con `:.1f` queda como mejora opcional de la actividad complementaria.

## Errores previsibles

1. **`split(",")` sin `strip()`:** los campos quedan con espacios (`' 23'`) y toda comparación de texto contra el dato limpio falla (defecto observado en el spike de la hoja).
2. **`join()` sobre enteros:** `TypeError: sequence item 0: expected str instance`; la conversión con `str()` es un paso obligatorio, no opcional.
3. **`IndexError` al inicializar:** `notas[3]` sobre tres elementos; los índices válidos son `0` a `len(notas) - 1`.
4. **`append()` fuera del `for`:** la lista queda con un solo elemento y el promedio se calcula sobre una nota; se detecta comparando con la corrida a mano.
5. **Comparar líneas sin limpiar los bordes:** `strip()` solo quita bordes; el doble espacio interno exige `split()` + `join()` (misma familia de defectos que la checklist registra para campos de texto).
6. **Buscar máximo inicializando en `0`:** funciona con notas positivas y esconde el error conceptual; exigir `notas[0]` como inicialización y pedir que lo justifiquen.

## Criterios de logro (4-8)

| Nivel | Descripción |
|---|---|
| 4 | La lista no se completa: las notas no se guardan o una pisa a la otra. |
| 5 | El programa corre con la lista; falla la limpieza del nombre o el `join` de las notas. |
| 6 | Ficha completa con lista y cadenas; falta el ejercicio de mayor y menor. |
| 7 | Todo completo, salida exacta, nombre normalizado aunque la entrada traiga espacios de más. |
| 8 | Explica qué devuelven `split()` y `join()` y resuelve el máximo sin mirar la solución. |

## Agrupamiento

Individual, una máquina por estudiante. Para el bloque de actividad complementaria: parejas para probar entradas «sucias» contra el programa del compañero (espacios, mayúsculas, decimales) y reportar qué resistió y qué no.

## Ajustes para la siguiente edición

- Si `split()`/`join()` cuesta, abrir el intérprete interactivo de Python en la terminal y experimentar los ejemplos del spike en vivo antes de tocar el programa.
- Si el grupo resuelve rápido máximo y mínimo, proponer en actividad complementaria el formato del promedio con `f"{promedio:.1f}"` y la búsqueda del estudiante con el nombre más largo.
