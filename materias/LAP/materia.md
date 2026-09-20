# Materia — Minimal API con C# .NET 6

> Archivo de datos centrales de la materia, referenciado por `0-prompt-plantilla-planificacion.md` en [Datos particulares].
> Acá viven JUNTOS todos los datos que cambian de una materia a otra: curso, stack, contenidos mínimos, tiempos e institución.
> El formato y las reglas de las evaluaciones NO se declaran acá: los gobierna la sección [Evaluaciones — regla fija] del prompt principal (una evaluación por unidad didáctica y una por momento de intensificación y fortalecimiento, en versiones A y B).

(Curso, stack y contenidos mínimos)
- Tema: impartir clases de Python.
- Nivel y enfoque: empezar desde cero; el alumno solo debe tener conocimiento de programacion en algún lenguaje. Es un primer acercamiento, básico, sin conceptos complicados como patrón repositorio o inyección de dependencias. En resumen: sin abstracciones.
- Conocimientos previos de los alumnos: cero Python.
- Entorno de trabajo: VS Code + terminal.
- Uso de celular: no permitido; el alumno no lo necesita para este curso.
- Ejemplos: muy mínimos y funcionales.
- Acceso a datos: Casi nada, Archivos planos con ejemplos muy basicos. No utlizar ningún ORM.
- Herramientas de entrega: contenidos mínimos de git y github, web y terminal. Un único repositorio por grupo para todo el curso, con una carpeta por trabajo (tp-u1, tp-u2, tp-u3, trabajo-final) y mono-rama main hasta la última unidad; el ciclo completo de entrega (gitignore en la raíz, init, commits, repo remoto, remote add, push) se enseña una sola vez en el primer encuentro con entrega y de ahí en adelante cada entrega es carpeta nueva + commits + push. La última unidad profesionaliza el mismo repositorio: README de portada, issues, ramas por feature, pull requests revisados y main protegida. Un commit con mensaje referente por cada final de encuentro o de clase sin terminar.
- Base de datos: No se trata este tema. Ninguna de ningun tipo.
- Restricción de archivos: busque la forma que todo se resuelva en un solo archivo sin recursos externos, salvo cuando no haya alternativa posible. De esta forma se simplifica la cantidad de archivos que debe recordar el alumno.
- Código de ejemplo: agregue una buena dosis de comentarios para que los estudiantes puedan comprender mejor las acciones del código presentado.
- Convenciones técnicas: output/LAP/convenciones-tecnicas.md — fuente única de tipos, formatos y estructura de código de este curso; leerla antes de generar cualquier ejemplo.

(Tiempo)
- Cantidad de horas por encuentro: 2.
- Tiempo efectivo disponible por encuentro: 50%.

(Institución)
- Modalidad: escuela técnica (el Encuentro 1 incluye seguridad e higiene y EPP).
