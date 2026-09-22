# Evaluación del momento de intensificación de diciembre — Camino mínimo completo

> Evaluación de la instancia «Intensificación de diciembre — Camino mínimo completo» · Curso: Programación en Python. Documento de **metadatos y acuerdos de la instancia**, en registro docente formal. El material del alumno es la versión `evaluacion-intensificaciones-diciembre-version-a` y sus versiones equivalentes generadas.

## 1. Identificación

| Campo | Detalle |
| --- | --- |
| Instancia | Intensificación de diciembre — Camino mínimo completo |
| Momento | Intensificación de diciembre (fuera de la estructura anual) |
| Carácter/Objetivo | Evaluar el camino mínimo completo del curso mediante un programa integrador de consola con defensa oral. Dominio: verdulería (productos, kilos, precio, factura, stock). |
| Destinatarios | Estudiantes que no alcanzaron los objetivos mínimos del curso durante el ciclo lectivo |
| Duración teórica | 240 minutos (4 horas reloj) |
| Uso de celular | No permitido |
| Documentos de la instancia | `evaluacion-intensificaciones-diciembre.md` · `evaluacion-intensificaciones-diciembre-version-a.md` (más las versiones equivalentes B generadas desde la A) |

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
| Contenidos | Camino mínimo completo: 1) entrada/salida con `print()` / `input()`; 2) variables y tipos (`int`, `float`, `str`, `bool`); 3) condicionales (`if`/`elif`/`else`); 4) bucles (`for`, `while`); 5) listas y diccionarios; 6) funciones con `def`, parámetros y `return`; 7) bloque principal (`if __name__ == "__main__"`); 8) métodos de cadenas (`split`, `strip`, `join`, `replace`), f-strings; 9) validación con `try`/`except`; 10) menú en memoria; 11) entregas por GitHub (carpetas `tp-u1/` a `trabajo-final/`); 12) defensa oral. Dominio: verdulería (productos, kilos, precio, factura, stock). |
| Actividad / metodología | Recorrido acelerado por los contenidos mínimos del año. Cada estudiante reconstruye o completa un programa integrador de consola sobre verdulería en dos encuentros. |
| Recursos | VS Code, terminal, repo grupal clonado, guía paso a paso del camino mínimo (impresa), lista de verificación de objetivos por alumno, plantilla README. |

## 4. Desarrollo de los encuentros del momento

Encuentro 1 (120 min): apertura (10 min) — explicación de la modalidad, entrega de lista de verificación individual. Bloque 1 (45 min): programa base (`verduleria.py`) con variables, `input()` con conversión, condicionales de stock bajo y descuento, menú simple con `while`. Bloque 2 (45 min): lista de productos como diccionarios, agregar con `append()`, mostrar con `for`, buscar por nombre. Cierre (20 min): verificación individual, commit con mensaje `"feat: verduleria base y listado"`.

Encuentro 2 (120 min): apertura (10 min) — repaso y objetivos del día. Bloque 1 (45 min): refactorización con funciones (`agregar_producto`, `listar_productos`, `buscar_producto`, `vender_producto`), bloque principal `if __name__`, validación con `try`/`except`. Bloque 2 (45 min): menú completo (opciones 1 a 6: agregar, listar, buscar, vender, factura, salir), commit final, README básico. Cierre con defensa (20 min): recorrido por los puestos con lista de verificación.

## 5. Criterios de calificación

Criterio: **Apto / No apto aún por objetivo mínimo**. No hay puntaje numérico.

| Resultado | Condición |
|---|---|
| Apto | El programa compila y ejecuta. Usa `input()`/`print()`, condicionales, bucles, listas, diccionarios, funciones, bloque principal, `try`/`except`, f-strings y menú en memoria. El repo tiene commit y README. El estudiante explica su código durante la defensa. |
| No apto aún por objetivo mínimo | Falta al menos uno de los elementos anteriores. Se especifica qué objetivo(s) no se alcanzó y se sugiere la instancia de marzo como siguiente oportunidad con el mismo estándar. |

## 6. Condiciones de resolución de la prueba

Resolución individual con computadora, VS Code y terminal. No se permite celular. El alumno escribe un único archivo `.py`. Debe tener el repo grupal clonado con su cuenta de GitHub activa. Se permite consultar la guía paso a paso del camino mínimo.

## 7. Regla de equivalencia entre versiones

Misma estructura, mismos objetivos y requisitos, distinto dominio (verdulería vs. videoteca). La versión B se genera desde la versión A mediante sustitución de tokens de la tabla de dominio.

## 8. Mecánica de asignación de versiones

Se asignan por fila de la tabla del curso según orden de lista. Se registra la versión asignada en la planilla de calificaciones.

## 9. Devolución

Al finalizar la defensa: verificación individual con la lista de objetivos, registro de Apto o No apto con detalle de pendientes. Si es No apto, se informa la instancia de marzo como siguiente oportunidad con el mismo estándar, y se entrega la lista de objetivos pendientes para que el estudiante se prepare.