# Evaluación de la Unidad 1 — Encuentro 9

> Evaluación de la instancia «Evaluación de la Unidad 1 — Encuentro 9» · Curso: Programación en Python. Documento de **metadatos y acuerdos de la instancia**, en registro docente formal. El material del alumno es la versión `evaluacion-u1-version-a` y sus versiones equivalentes generadas; sus soluciones y criterios de corrección van en el anexo docente separado (`evaluacion-u1-version-a-anexo-docente.md`).

## 1. Identificación

| Campo | Detalle |
| --- | --- |
| Instancia | Evaluación de la Unidad 1 — Encuentro 9 |
| Unidad evaluada | 1 — Fundamentos de Python y control del flujo |
| Eje temático | 1 — Fundamentos del lenguaje Python |
| Carácter/Objetivo | Evaluación práctica individual: verificar la capacidad de escribir un programa de consola que combine entrada, conversión de tipos, condicionales y bucles. |
| Destinatarios | Todo el curso |
| Duración teórica | 120 minutos (2 horas reloj) |
| Uso de celular | No permitido |
| Documentos de la instancia | `evaluacion-u1.md` · `evaluacion-u1-version-a.md` · `evaluacion-u1-version-a-anexo-docente.md` (más las versiones equivalentes B generadas desde la A) |

## 2. Estructura del encuentro (120 min)

| Momento | Tiempo | Qué ocurre |
| --- | --- | --- |
| Apertura e instrucciones | 10 min | El docente explica la dinámica del encuentro: defensa del TP por grupo + prueba individual. Asigna versiones (A o B) por fila. |
| Defensa individual del TP (grupos) | 30 min | Mientras un grupo rinde la prueba, el docente toma la defensa del TP a otro grupo en rotación. |
| Prueba práctica individual | 70 min | Cada estudiante resuelve su ejercicio de forma individual en su computadora. |
| Cierre y recogida | 10 min | Los estudiantes entregan por Git (commit + push). El docente cierra el encuentro y anuncia la devolución para el encuentro siguiente. |
| **Total** | **120 min** | |

## 3. Regla canónica de la instancia

La entrega del TP-U1 se verificó en el encuentro 8 (cierre de unidad). En este encuentro 9 se realiza la defensa individual del TP y la prueba práctica individual escrita. La devolución de ambos se realiza al inicio del encuentro siguiente (encuentro 10). Si un estudiante no completa la prueba en el tiempo asignado, entrega lo que tenga y se evalúa sobre lo entregado; no hay recuperación intra-encuentro.

## 4. Defensa individual del TP (modalidad)

Mientras un grupo rinde la prueba práctica, el docente se reúne por separado con cada grupo y verifica:

1. Que el repositorio existe en GitHub con la carpeta `tp-u1/`.
2. Que el archivo `kiosco.py` está presente y ejecutable.
3. Demo rápida: el grupo ejecuta el programa y muestra las 4 opciones del menú.
4. Pregunta individual a cada integrante sobre una parte del código (p. ej., «¿qué hace este `while`?», «¿por qué usaron `try/except` acá?»).
5. Registro en planilla: cada objetivo del TP se marca como logrado / parcial / no logrado.

## 5. Alcance

**Incluido:** variables y tipos (`int`, `float`, `str`), `input()` y `print()`, conversión con `int()`/`float()`, f-strings, condicionales `if`/`elif`/`else`, operadores de comparación y lógicos, bucle `while` con bandera, contadores y acumuladores, validación con `try/except ValueError`.

**Excluido:** colecciones (`list`, `tuple`, `set`, `dict`) como tema principal; funciones `def`; archivos; POO.

**Objetivo mínimo:** escribir un programa de consola funcional que lea datos del usuario, tome decisiones con `if`/`elif`/`else` y repita con un bucle `while`, manejando entradas inválidas con `try/except`.

## 6. Prueba práctica individual (versiones equivalentes)

La prueba consiste en **un único ejercicio práctico** que se resuelve en un archivo `.py`. Puntaje total: 100 puntos. El enunciado se organiza en partes que reflejan secciones del mismo programa:

- **Parte 1 — Menú y visualización (30 pts):** diccionario de productos provisto, menú con `while`, opción de listar productos.
- **Parte 2 — Registro de venta (40 pts):** entrada con validación, condicionales para stock y descuento, actualización de acumuladores.
- **Parte 3 — Resumen de ventas (20 pts):** mostrar total de unidades vendidas y dinero acumulado.
- **Parte 4 — Ítems conceptuales (10 pts):** preguntas breves sobre conceptos de la unidad.

## 7. Criterios de calificación

| Componente | Puntaje | Qué se observa |
| --- | --- | --- |
| Estructura y convenciones | 10 pts | Un solo archivo `.py`, funciones arriba (si usa) o código limpio, bloque `if __name__ == "__main__":`, f-strings, identificadores en inglés snake_case, mensajes en español. |
| Funcionamiento del menú | 20 pts | El menú se repite hasta elegir Salir; las opciones válidas ejecutan su acción; las inválidas muestran mensaje claro. |
| Registro de venta | 40 pts | Lectura de código y cantidad con validación `try/except`, verificación de existencia del producto y stock suficiente, descuento condicional, actualización de stock y acumuladores. |
| Resumen de ventas | 10 pts | Muestra unidades totales y dinero acumulado correctamente. |
| Ítems conceptuales | 10 pts | Respuestas correctas a preguntas sobre tipos, conversión y bucles. |
| Defensa del TP | 10 pts | Repositorio en orden, demo funcional, respuesta individual del integrante. |
| **Total** | **100 pts** | |

## 8. Condiciones de resolución de la prueba

- **Individual:** cada estudiante resuelve su propia prueba en su computadora.
- **Material consultable:** apuntes propios, clases del aula virtual, documentación de Python. No se permite comunicación entre estudiantes.
- **Convenciones obligatorias:** las de `input/materias/LAP/convenciones-tecnicas.md` (snake_case, f-strings, `if __name__`, sin persistencia, sin `except:` desnudo).
- **Entrega:** commit + push al repositorio grupal en la carpeta `evaluacion-u1/` antes de que termine el encuentro. Si no hay push, se evalúa sobre el archivo local que el estudiante muestre al docente.

## 9. Regla de equivalencia entre versiones

Las versiones A y B comparten la misma estructura, los mismos objetivos de aprendizaje y los mismos requisitos. Cambia exclusivamente el dominio de aplicación (kiosco escolar ↔ biblioteca de aula) y los tokens de identificadores y datos de ejemplo que lo reflejan. Ninguna versión tiene reglas adicionales que la otra no tenga. Ambas se corrigen con la misma tabla de puntaje.

## 10. Mecánica de asignación de versiones

El docente asigna las versiones por fila de la sala: fila impar → versión A (kiosco), fila par → versión B (biblioteca). Se registra la versión asignada en la planilla de curso junto con el puntaje obtenido.

## 11. Devolución

La devolución se realiza al inicio del encuentro siguiente (encuentro 10). El docente entrega la planilla con puntajes y comentarios breves por criterio. Los estudiantes que no alcancen el objetivo mínimo (menos de 60 puntos en la prueba o TP no defendido) reciben una pista de recuperación: deben rehacer el ejercicio en su versión corregida y presentarlo al inicio del encuentro 11. El docente lleva registro en la planilla de seguimiento.