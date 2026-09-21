# Anexo docente — Continuidad pedagógica 1: Saberes previos

> Anexo de uso exclusivo del docente. No se entrega a los alumnos ni a la administración junto con la actividad.

## Encuadre docente

Primera continuidad del curso: se usa si hay ausencia docente en los Encuentros 2 y 3, antes de la Unidad 1. No exige ningún contenido de la materia: todo se resuelve con la lógica y los lenguajes que el grupo trae. Al retomar la clase, la tabla de la Actividad 1 y el párrafo de la Actividad 5 son el insumo de diagnóstico más valioso para calibrar el Encuentro 4.

## Soluciones

### Actividad 1

Sin respuesta única: se espera la tabla completa del grupo. Registrarla: es el diagnóstico de entrada del curso.

### Actividad 2

**Algoritmo A** (con datos 7, 8, 9): `suma = 24`, `promedio = 8.0`, `8.0 >= 8` es verdadero → salida: `Promociona`. Paso decisivo: la condición usa `>=`, por lo que el 8 exacto promociona.

**Algoritmo B:** escribe `3`, luego `2`, luego `1`, y recién al salir del bucle `Despegue`. Paso decisivo: la condición `contador > 0` se evalúa antes de cada vuelta; cuando `contador` vale 0, el bucle termina y el `ESCRIBIR "Despegue"` está afuera.

### Actividad 3 — Pseudocódigo de referencia

```text
suma = 0
PARA i = 1 HASTA 3 HACER
    LEER nota
    MIENTRAS nota < 0 O nota > 10 HACER
        ESCRIBIR "Nota invalida: volver a pedir"
        LEER nota
    FIN MIENTRAS
    suma = suma + nota
FIN PARA
promedio = suma / 3
SI promedio >= 8 ENTONCES
    ESCRIBIR "Promociona"
SINO
    ESCRIBIR "No promociona"
FIN SI
```

Variantes aceptadas: validación con bandera o con `REPETIR ... HASTA`; cualquier orden equivalente de entradas y proceso. No se acepta una versión que pida la nota una sola vez sin repetición.

### Actividad 4 — Prueba de escritorio de referencia (caso con nota inválida: 11, luego 8, luego 9)

| Paso | Acción | Variables |
| --- | --- | --- |
| 1 | Leer nota (i = 1) | `nota = 11` |
| 2 | 11 fuera de rango → repetir | `nota = 8` |
| 3 | Válida → acumular | `suma = 8` |
| 4 | Leer nota (i = 2) | `nota = 9`, `suma = 17` |
| 5 | Leer nota (i = 3) | `nota = 10`, `suma = 27` |
| 6 | Promedio | `promedio = 9.0` → «Promociona» |

Versión de referencia en Python (solo para el docente: mostrarla al retomar la clase, ya iniciada la materia; sigue las convenciones técnicas del curso):

```python
# Referencia docente: promedio de tres notas con validacion de rango

def pedir_nota(numero):
    # Pedir la nota y repetir mientras no este entre 0 y 10.
    nota = int(input(f"Nota {numero}: "))
    while nota < 0 or nota > 10:
        print("Nota invalida: debe estar entre 0 y 10")
        nota = int(input(f"Nota {numero}: "))
    return nota

def main():
    # Calcular el promedio de tres notas validadas y decidir la condicion
    suma = 0
    for numero in range(1, 4):
        suma = suma + pedir_nota(numero)
    promedio = suma / 3
    if promedio >= 8:
        print("Promociona")
    else:
        print("No promociona")


if __name__ == "__main__":
    main()
```

### Actividad 5

El párrafo es válido si nombra al menos dos fortalezas concretas del grupo, una necesidad concreta para la materia (por ejemplo: instalar y probar Python, ver sintaxis de decisiones y bucles en Python) y una petición realista. No evaluar la redacción: evaluar la honestidad del diagnóstico.

## Criterios de corrección (100 puntos)

| Actividad | Puntaje completo | Ajustes parciales |
| --- | --- | --- |
| 1 — Inventario | 10: tabla completa del grupo | Fila propia ausente o incompleta: 4 a 7 |
| 2 — Pseudocódigo | 25: dos salidas correctas con su justificación (12 y 13) | Salida correcta sin explicación: hasta 8 por algoritmo |
| 3 — Algoritmo | 30: entradas/proceso/salida identificados (10), validación con repetición (15), claridad (5) | Sin repetición de validación: máximo 15 |
| 4 — Programa o escritorio | 25: los tres casos correctos, incluido el inválido | Un caso mal resuelto: 12 a 18 |
| 5 — Balance | 10: párrafo con fortalezas, necesidad y pedido | Lista suelta sin diagnóstico: máximo 5 |

## Qué mirar en la presentación manuscrita

- Que cada integrante pueda explicar, con sus palabras, el paso decisivo de la Actividad 2: es la señal de lectura propia frente a la copia del grupo.
- En la Actividad 3, que la repetición de validación esté pensada por el grupo y no copiada: preguntar qué pasa con la nota 11.
- El balance de la Actividad 5 suele anticipar los errores comunes del Encuentro 4: tenerlo a mano al planificar.
