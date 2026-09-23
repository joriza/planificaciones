# Continuidad pedagógica 04 — Tras la evaluación de la Unidad 3

> Programación en Python · Actividad de continuidad pedagógica · Tras el encuentro 26

## Datos de referencia

| Campo | Detalle |
| --- | --- |
| Curso | Programación en Python |
| Momento de uso | Después del encuentro 26 (evaluación de la Unidad 3) |
| Duración teórica | 120 minutos (2 horas reloj) |
| Requisitos | Contenidos de las Unidades 1 a 3: variables, entrada/salida, condicionales, bucles (U1); listas, tuplas, conjuntos, diccionarios, funciones, `if __name__` (U2); métodos de cadenas (`split`, `strip`, `join`, `replace`), f-strings con formato, validación con `try`/`except ValueError` y `while True`, menú de consola en memoria (U3). Para las tareas de programación: computadora con Python 3 y VS Code. |
| Entrega | Individual, manuscrita (parte en papel) + archivos `.py` de las tareas de programación. |

## Objetivos

1. Aplicar **métodos de cadenas** (`split`, `strip`, `join`, `replace`) para procesar texto ingresado por el usuario.
2. Usar **f-strings con formato** (`f"{valor:.2f}"`, alineación) para presentar información tabulada.
3. Implementar **validación robusta** con `try`/`except ValueError` y bucles `while True` para entrada de datos.
4. Construir un **menú de consola** que ejecute opciones hasta que el usuario decida salir.

## Actividades

| # | Actividad | Puntaje | Tiempo estimado |
| --- | --- | --- | --- |
| 1 | **Completar código: métodos de cadenas (papel).** Dado un programa que recibe una frase y debe separarla en palabras, limpiar espacios y reemplazar caracteres, completá las líneas con los métodos correctos (`split`, `strip`, `join`, `replace`). | 10 | 15 min |
| 2 | **Predecir salida: f-strings con formato (papel).** Leé cada fragmento con f-strings que usan ancho de campo, cantidad de decimales o alineación y escribí exactamente lo que se muestra en consola. | 10 | 15 min |
| 3 | **Escribir validación (papel).** Escribí el código de una función `pedir_entero(mensaje)` que recibe un texto, lo muestra como prompt, y usa un bucle `while True` con `try`/`except ValueError` para asegurarse de devolver un `int`. Incluí un ejemplo de uso que llame a la función y muestre el doble del valor ingresado. | 20 | 25 min |
| 4 | **Completar un menú (papel).** Dado un programa con un menú esqueleto (`while True`, `input` de opción, `if`/`elif`/`else`), completá las opciones faltantes (agregar ítem, listar ítems, salir). El menú trabaja sobre una lista en memoria. | 20 | 20 min |
| 5 | **Tarea de programación: analizador de texto con menú.** Escribí un programa `analizador_texto.py` que presente un menú con estas opciones usando un diccionario en memoria como almacenamiento: (1) Ingresar frase — pide una frase y la guarda asociada a un título; (2) Mostrar palabras — usa `split` para mostrar cada palabra separada; (3) Contar caracteres — cuenta letras, espacios y signos; (4) Salir. Cada opción debe estar validada con `try`/`except` si corresponde y los resultados deben mostrarse con f-strings formateadas. Incluí comentarios. | 40 | 45 min |
| **Total** | | **100** | **120 min** |

## Autoevaluación

1. **¿Recordás qué hace `split()` y qué devuelve?** Sí / Más o menos / No.
   *Reflexión breve: ¿en qué actividad lo usaste o identificaste?*

2. **¿Sabés cómo mostrar un número con solo dos decimales en un f-string?** Sí, lo uso / Lo vi pero no lo recuerdo / No.
   *Reflexión breve: ¿para qué serviría en un programa real?*

3. **¿Entendés por qué `try`/`except` evita que el programa se detenga con un error?** Sí, claro / A medias / No.
   *Reflexión breve: ¿qué pasa si no usás validación y el usuario ingresa texto donde se espera un número?*

4. **Cuando armás un menú con `while True`, ¿cómo hacés para que el programa termine cuando el usuario elige "Salir"?** Lo explico / Tengo una idea / No sé.
   *Reflexión breve: ¿usaste `break`? ¿dónde lo pondrías?*

5. **De todos los temas de las Unidades 1 a 3, ¿cuál te gustaría reforzar antes del Trabajo Final?**
   *Escribí uno o dos temas.*

## Nota académica

La resolución se realiza en forma habitual (por lo general, en grupo); las tareas de programación requieren el uso de la computadora; la presentación es individual y manuscrita, al inicio de la próxima clase, y constituye una actividad más de la asignatura que forma parte del proceso de evaluación.
