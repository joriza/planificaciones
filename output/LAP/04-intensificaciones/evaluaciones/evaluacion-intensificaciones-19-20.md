# Evaluación del momento de intensificación y fortalecimiento 19-20

> Evaluación de la instancia «Evaluación del momento de intensificación y fortalecimiento 19-20» · Curso: Programación en Python. Documento de **metadatos y acuerdos de la instancia**, en registro docente formal. El material del alumno es la versión `evaluacion-intensificaciones-19-20-version-a` y sus versiones equivalentes generadas; sus soluciones y criterios de corrección van en el anexo docente separado (`evaluacion-intensificaciones-19-20-version-a-anexo-docente.md`).

## 1. Identificación

| Campo | Detalle |
| --- | --- |
| Instancia | Evaluación del momento de intensificación y fortalecimiento 19-20 |
| Momento | Intensificación y fortalecimiento — encuentros 19-20 (proyecto puente) |
| Carácter/Objetivo | Evaluar la integración de las Unidades 1 y 2 mediante un proyecto integrador de consola con rúbrica de 100 puntos. Función recuperatoria: los estudiantes que no alcanzaron los objetivos mínimos en las unidades 1 o 2 tienen aquí una instancia de aprobación. |
| Destinatarios | Todo el curso |
| Duración teórica | 240 minutos (4 horas reloj) |
| Uso de celular | No permitido |
| Documentos de la instancia | `evaluacion-intensificaciones-19-20.md` · `evaluacion-intensificaciones-19-20-version-a.md` (más las versiones equivalentes B generadas desde la A) |

## 2. Estructura del encuentro (240 min)

| Momento | Tiempo | Qué ocurre |
| --- | --- | --- |
| Apertura y consigna | 10 min | Presentación del proyecto puente y la rúbrica de 100 puntos. |
| Bloque 1 — Estructura base y opciones 1 y 2 | 45 min | Implementar el esqueleto del programa, menú principal, opción de agregar y opción de listar. |
| Bloque 2 — Opciones 3, 4 y 5 | 45 min | Completar búsqueda, filtrado de activos y filtrado de vencidos. |
| Bloque 3 — Bloque principal, pulido y entrega | 45 min | Refactorizar con `if __name__`, validación mínima, comentarios y commit final. |
| Cierre con defensa | 20 min | Defensa individual: cada estudiante explica su programa, estructura de datos y una función compleja. |
| **Total** | **240 min** | |

## 3. Acuerdo pedagógico por grupo de condición

Única pista para todo el curso. Todos los estudiantes reciben la misma consigna y trabajan con la misma rúbrica de 100 puntos. No hay pistas diferenciadas porque el proyecto puente es recuperatorio: quienes ya aprobaron U1 y U2 completan el proyecto como consolidación; quienes no aprobaron lo usan como instancia de recuperación.

Contenidos: proyecto integrador que articula entrada/salida (`print`, `input`), condicionales (`if`/`elif`/`else`), bucles (`while`, `for`), listas, diccionarios y funciones (`def`, parámetros, `return`). Dominio: sistema de gestión de un club de barrio (socios, cuotas, vencimientos).

Actividad/metodología: construcción progresiva del programa en dos encuentros. Encuentro 19: consigna, planificación grupal, opciones 1 y 2. Encuentro 20: opciones 3-5, refactorización, defensa y entrega.

Recursos: VS Code, terminal, repo grupal clonado, consigna impresa con rúbrica de 100 puntos, ejemplos resueltos de U1 y U2.

## 4. Desarrollo de los encuentros del momento

Encuentro 19 (120 min): apertura (10 min) — lectura de la consigna, explicación de la rúbrica. Bloque 1 (45 min): planificación en parejas de la estructura del programa (funciones necesarias, estructura de datos, flujo del menú) y puesta en común. Bloque 2 (45 min): implementación de opción 1 (agregar socio con diccionario) y opción 2 (listar socios con `for`). Cierre (20 min): verificación de avances, commit con mensaje `"feat: agregar socio y listar socios"`.

Encuentro 20 (120 min): apertura (10 min) — repaso y objetivos del día. Bloque 1 (45 min): opción 3 (buscar socio por nombre con función `findMember`), opción 4 (socios activos), opción 5 (socios vencidos). Bloque 2 (45 min): refactorización con `if __name__`, validación con `try`/`except` básico, comentarios. Cierre con defensa (20 min): recorrido por los puestos, defensa individual y registro de puntajes en la rúbrica.

## 5. Criterios de calificación — rúbrica (100 puntos)

| Dimensión | Puntaje | Indicadores |
|---|---|---|
| Entrada y condicionales | 20 pts | Usa `input()` y `int()`/`float()` correctamente. Aplica `if`/`elif`/`else` para decidir flujo del menú y validar datos. |
| Bucles | 15 pts | Usa `while` para el menú principal (hasta que el usuario elija salir). Usa `for` para recorrer listas y diccionarios. |
| Listas y diccionarios | 25 pts | Almacena socios como diccionarios dentro de una lista. Opera sobre la lista (agregar, eliminar, buscar, listar). |
| Funciones y bloque principal | 20 pts | Define funciones con `def`, parámetros y `return`. Organiza el programa con `if __name__ == "__main__"`. |
| Calidad del código | 10 pts | Nombres descriptivos, comentarios útiles, código sin líneas muertas, entrada de datos validada mínimamente. |
| Entrega y defensa | 10 pts | Repositorio GitHub actualizado con commit del proyecto. Breve explicación oral del programa y las decisiones tomadas. |

**Aprobado**: ≥ 60 puntos. **Destacado**: ≥ 85 puntos. **No aprobado**: < 60 puntos.

## 6. Condiciones de resolución de la prueba

Resolución individual con computadora, VS Code y terminal. No se permite celular. El alumno escribe un único archivo `.py`. Debe cerrar con commit y push al repo grupal. Se permite consultar la guía impresa de la consigna y los ejemplos resueltos de U1 y U2.

## 7. Regla de equivalencia entre versiones

Misma estructura, mismos objetivos, mismo puntaje por dimensión, distinto dominio (club vs. taller). La versión B se genera desde la versión A mediante sustitución de tokens de la tabla de dominio.

## 8. Mecánica de asignación de versiones

Se asignan por fila de la tabla del curso según orden de lista. Se registra la versión asignada en la planilla de calificaciones.

## 9. Devolución

Al finalizar el encuentro 20: entrega del puntaje parcial por dimensión de la rúbrica y el resultado (aprobado / no aprobado). Los estudiantes no aprobados pasan al grupo de intensificación en los momentos siguientes (encuentros 34-35 o diciembre).