# Evaluación de la intensificación de marzo — Camino mínimo completo

> Evaluación de la instancia «Intensificación de marzo — Camino mínimo completo» · Curso: Programación en Python. Documento de **metadatos y acuerdos de la instancia**, en registro docente formal. El material del alumno es la versión `evaluacion-intensificaciones-marzo-version-a` y sus versiones equivalentes generadas; sus soluciones y criterios de corrección van en el anexo docente separado (`evaluacion-intensificaciones-marzo-version-a-anexo-docente.md`).

## 1. Identificación

| Campo | Detalle |
| --- | --- |
| Instancia | Intensificación de marzo — Camino mínimo completo |
| Momento | Intensificación de marzo (fuera de la estructura anual, previa al nuevo ciclo) |
| Carácter/Objetivo | Evaluar el camino mínimo completo del curso (mismo estándar que diciembre). Criterio: **Apto / No apto aún por objetivo mínimo**. No baja el estándar; cambia el tiempo de preparación del estudiante (diciembre → marzo). |
| Destinatarios | Estudiantes que no alcanzaron los objetivos mínimos en la instancia de diciembre |
| Duración teórica | 240 minutos (4 horas reloj) |
| Uso de celular | No permitido |
| Documentos de la instancia | `evaluacion-intensificaciones-marzo.md` · `evaluacion-intensificaciones-marzo-version-a.md` (más las versiones equivalentes B generadas desde la A) |

## 2. Estructura del encuentro (240 min)

| Momento | Tiempo | Qué ocurre |
| --- | --- | --- |
| Apertura y organización | 10 min | Presentación de la instancia: camino mínimo completo, criterio Apto/No apto. |
| Bloque 1 — Entrada, tipos y condicionales | 45 min | Ejercicios 1 a 3: programa base con variables, condicionales y menú simple con `while`. |
| Bloque 2 — Listas, diccionarios y bucles | 45 min | Ejercicios 4 a 6: lista de productos como diccionarios, recorrido con `for`, búsqueda por nombre. |
| Bloque 3 — Funciones, validación y menú | 45 min | Ejercicios 7 a 10: refactorización con funciones, bloque principal, `try`/`except`, menú completo. |
| Bloque 4 — Entrega y defensa | 45 min | Ejercicios 11 y 12: commit final, README básico, defensa individual. |
| **Total** | **240 min** | |

## 3. Acuerdo pedagógico

| Dimensión | Grupo de intensificación (recuperación pedagógica) — único grupo |
|---|---|
| Contenidos | Camino mínimo completo del curso (idéntico al de diciembre): 1) entrada/salida con `print()` / `input()`; 2) variables y tipos (`int`, `float`, `str`, `bool`); 3) condicionales (`if`/`elif`/`else`); 4) bucles (`for`, `while`); 5) listas y diccionarios; 6) funciones con `def`, parámetros y `return`; 7) bloque principal (`if __name__ == "__main__"`); 8) métodos de cadenas (`split`, `strip`, `join`, `replace`), f-strings; 9) validación con `try`/`except`; 10) menú en memoria; 11) entregas por GitHub del repo grupal (carpetas `tp-u1/` a `trabajo-final/`); 12) defensa oral del programa presentado. Dominio: verdulería (producto, kilos, precio, factura, stock). |
| Actividad / metodología | El estudiante tuvo más tiempo para prepararse (diciembre a marzo). La instancia presencial se organiza como taller de verificación: el docente revisa el programa que el estudiante trae preparado y asiste en los puntos que todavía presenten dificultad. Encuentro 1: verificación de objetivos 1 a 6 (entrada, condicionales, bucles, listas, diccionarios). Encuentro 2: verificación de objetivos 7 a 12 (funciones, validación, menú, entrega y defensa). |
| Recursos | VS Code, terminal, repo grupal clonado, guía paso a paso del camino mínimo (impresa desde diciembre), lista de verificación de objetivos por alumno con el registro de diciembre, plantilla README. |

## 4. Desarrollo de los encuentros del momento

Encuentro 1 (120 min): apertura (10 min) — bienvenida a la instancia de marzo, explicación del estándar idéntico al de diciembre, entrega de lista de verificación actualizada. Bloque 1 (45 min): verificación de programa base (`verduleria.py`) con variables, `input()` con conversión, condicionales de stock bajo y descuento. Bloque 2 (45 min): verificación de lista de productos como diccionarios, `append()`, `for` para listar, búsqueda por nombre. Cierre (20 min): registro de objetivos logrados, pase al encuentro 2 o trabajo adicional.

Encuentro 2 (120 min): apertura (10 min) — repaso y objetivos del día. Bloque 1 (45 min): verificación de funciones (`agregar_producto`, `listar_productos`, `buscar_producto`, `vender_producto`), bloque principal `if __name__`, `try`/`except`. Bloque 2 (45 min): verificación de menú completo (opciones 1 a 6), commit final, README básico. Cierre con defensa (20 min): recorrido por los puestos con lista de verificación.

## 5. Criterios de calificación

Criterio: **Apto / No apto aún por objetivo mínimo**. No hay puntaje numérico. No baja el estándar respecto a diciembre.

| Resultado | Condición |
|---|---|
| Apto | El programa compila y ejecuta. Usa `input()`/`print()`, condicionales, bucles, listas, diccionarios, funciones, bloque principal, `try`/`except`, f-strings y menú en memoria. El repo tiene commit y README. El estudiante explica su código durante la defensa. |
| No apto aún por objetivo mínimo | Falta al menos uno de los elementos anteriores. Se especifica qué objetivo(s) no se alcanzó y se informa al estudiante junto con la notificación a dirección. |

## 6. Condiciones de resolución de la prueba

Resolución individual con computadora, VS Code y terminal. No se permite celular. El alumno escribe un único archivo `.py`. Debe tener el repo grupal clonado con su cuenta de GitHub activa. Se permite consultar la guía paso a paso del camino mínimo.

## 7. Regla de equivalencia entre versiones

Misma estructura, mismos objetivos y requisitos, distinto dominio (verdulería vs. videoteca). La versión B se genera desde la versión A mediante sustitución de tokens de la tabla de dominio.

## 8. Mecánica de asignación de versiones

Se asignan por fila de la tabla del curso según orden de lista. Se registra la versión asignada en la planilla de calificaciones.

## 9. Devolución

Al finalizar la defensa: verificación individual con la lista de objetivos, registro de Apto o No apto con detalle de pendientes. Si es No apto, se informa la lista de objetivos pendientes y se notifica a dirección para la recomendación de recursar la materia si el período lo permite.
