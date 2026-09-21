# Continuidad pedagógica 2 — Repaso de la Unidad 1

> Documento de continuidad pedagógica: actividades de repaso y fijación para desarrollar en una clase sin presencia docente. Se entrega a la administración para los casos de ausencia del docente. Repasa la totalidad de la Unidad 1 (Fundamentos de Python).

## Datos de referencia

| Campo | Valor |
| --- | --- |
| Curso | Programación en Python |
| Momento de uso | Tramo posterior a la Evaluación de la Unidad 1 (Encuentros 10 a 14) |
| Duración teórica | 120 minutos |
| Modalidad de trabajo | Resolución en grupo, según la organización habitual de la asignatura; presentación individual y manuscrita |
| Requisitos | Computadora con Python 3.11, VS Code y terminal; repositorio del grupo en GitHub (creado en el Encuentro 7) |

## Objetivos

- Repasar variables, tipos de dato, entrada y salida de datos en Python.
- Detectar y corregir errores de sintaxis y de lógica en un programa dado.
- Escribir un programa de consola con decisiones, reintentos y acumuladores.
- Procesar cadenas con `split()`, `strip()` y `join()`.
- Registrar el trabajo con un commit y subirlo al repositorio del grupo.

## Actividades puntuadas (100 puntos · 120 minutos)

| Nº | Actividad | Tiempo | Puntaje |
| --- | --- | --- | --- |
| 1 | Mapa de la Unidad 1 | 15 min | 10 puntos |
| 2 | Caza de errores | 30 min | 30 puntos |
| 3 | Programa de repaso: promedio con reintentos | 40 min | 35 puntos |
| 4 | Cadenas: análisis de una frase | 20 min | 15 puntos |
| 5 | Entrega y cierre | 15 min | 10 puntos |
| | **Totales** | **120 min** | **100 puntos** |

En cada actividad, la presentación individual manuscrita consiste en transcribir a mano el resultado indicado más una observación propia del integrante.

### Actividad 1 — Mapa de la Unidad 1 (15 min · 10 puntos)

El grupo arma en papel una tabla con los cinco encuentros de la Unidad 1 (primer programa; condicionales y bucles; listas y cadenas; Git y GitHub; cierre y TP). Por cada encuentro: tema en una línea y un ejemplo propio de una línea de código o de comando.

Presentación manuscrita: la fila del encuentro que a cada integrante le resulte más difícil, más una línea que diga por qué.

### Actividad 2 — Caza de errores (30 min · 30 puntos)

El siguiente programa tiene **cinco errores sembrados**. Encontrarlos, anotarlos y corregirlos en un archivo `promedios_v2.py`; el programa corregido debe pedir tres notas y funcionar sin errores:

```python
# Promedio de tres notas - version con errores

def main():
    # Calcular el promedio de tres notas y decidir si aprueba
    for numero in range(1, 3):
        suma = 0
        nota = input(f"Nota {numero}: ")
        suma = suma + nota
    promedio = suma / 2
    if promedio = 6:
        print("Aprobado")
    else:
        print("Insuficiente")


if __name__ == "__main__":
    main()
```

Probar la versión corregida con tres notas válidas y verificar la salida.

Presentación manuscrita: los cinco errores con su corrección y el síntoma que produce cada uno.

### Actividad 3 — Programa de repaso: promedio con reintentos (40 min · 35 puntos)

Escribir un programa `repaso_u1.py` que:

1. Pida el nombre del estudiante.
2. Pida la edad y repita la lectura mientras el dato no sea un número (`try/except ValueError` con reintento).
3. Pida tres notas, con el mismo reintento por nota, y las acumule.
4. Calcule el promedio y decida la condición: 8 o más «Promociona», 6 o más «Regular», menos de 6 «Libre».
5. Muestre la ficha final: nombre, edad, promedio y condición.

Probar los dos caminos: un ingreso inválido en el medio (por ejemplo, «ocho») y una corrida completamente válida.

Presentación manuscrita: la ficha final de la corrida con el dato inválido, copiada a mano.

### Actividad 4 — Cadenas: análisis de una frase (20 min · 15 puntos)

Escribir un programa `frase.py` que pida una frase y muestre: cuántas palabras tiene (ignorando espacios repetidos), cuál es la palabra más larga y la frase reconstruida con `join()` a partir de las palabras limpias. Probarla con una frase que empiece y termine con espacios y tenga espacios dobles en el medio.

Presentación manuscrita: la salida del programa para esa frase de prueba.

### Actividad 5 — Entrega y cierre (15 min · 10 puntos)

Guardar los tres programas en una carpeta `continuidad/` del repositorio del grupo y realizar el ciclo de entrega:

```bash
git add .
git commit -m "continuidad: repaso de la unidad 1"
git push
```

Verificar en GitHub que el commit quedó subido.

Presentación manuscrita: el mensaje del commit y la lista de archivos subidos.

## Autoevaluación

Marcar con una cruz lo que se pueda afirmar al terminar la clase:

- [ ] Encontré los cinco errores de la Actividad 2 y puedo explicar por qué cada uno falla.
- [ ] Mi programa pide las tres notas y repite la lectura cuando el dato no es un número.
- [ ] La ficha final muestra nombre, edad, promedio y condición correctos en los dos caminos probados.
- [ ] Puedo procesar una frase con `split()`, `strip()` y `join()` sin volver a la teoría.
- [ ] Puedo explicar la diferencia entre `=` y `==` en Python.
- [ ] El commit del grupo quedó subido a GitHub con el mensaje pedido.

## Nota académica

La resolución de las actividades se realiza en la forma habitual de la asignatura, por lo general en grupo. Las tareas de programación requieren el uso de la computadora. La presentación es individual y manuscrita, al inicio de la próxima clase, y constituye una actividad más de la asignatura que forma parte del proceso de evaluación.
