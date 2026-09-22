# Materia — Programación en Python

> Archivo de datos centrales de la materia, referenciado por `prompt-plantilla-planificacion.md` en [Datos particulares].
> Acá viven JUNTOS todos los datos que cambian de una materia a otra: curso, stack, contenidos mínimos, tiempos e institución.
> El formato y las reglas de las evaluaciones NO se declaran acá: los gobierna la sección [Evaluaciones — regla fija] del prompt principal (una evaluación por unidad didáctica y una por momento de intensificación y fortalecimiento, en versiones A y B).

(Curso, stack y contenidos mínimos)
- Tema: impartir clases de Python.
- Nivel y enfoque: empezar desde cero; el alumno solo debe tener conocimiento de programación en algún lenguaje. Es un primer acercamiento, básico, sin patrones de diseño, sin POO (clases) y sin programación funcional. Las funciones (def) sí se usan como unidad de organización, pero no como abstracciones del nivel de un patrón. En resumen: programación imperativa con funciones sencillas.
- Conocimientos previos de los alumnos: cero Python.
- Entorno de trabajo: VS Code + terminal.
- Uso de celular: no permitido; el alumno no lo necesita para este curso.
- Ejemplos: cortos y directos, que compilen y ejecuten correctamente, y sirvan como ejemplo didáctico. No superar 150 líneas por archivo.
- Tipos de datos básicos: int, float, str, bool.
- Declaración de variables, asignación y mutabilidad (inmutable vs mutable: int, str, tuple frente a list, dict, set).
- Operadores: aritméticos (+, -, *, /, //, %, **), de comparación (==, !=, <, >, <=, >=) y lógicos (and, or, not).
- bloque de ejecución principal.
- Entrada y salida por consola: print() e input().
- Estructuras de control: if / elif / else.
- Bucles: for (sobre rangos y colecciones) y while.
- Funciones: def, parámetros, return. Ámbito local (lo necesario).
- Estructuras de datos: listas (con append, pop, index, sort), tuplas, set y diccionarios (con keys, values, items).
- Métodos de cadenas: split, strip, join, replace — lo mínimo para procesar entrada del usuario.
- Formateo de cadenas: f-strings.
- Slicing: operador [i:j] sobre strings y listas.
- Excepciones: try / except para validación de entrada.
- Módulos: solo mención de import para built-ins (random, math); no se desarrolla como tema.
- Acceso a datos: Se excluye este tema. Todo se resuelve en memoria. Sin archivos de texto plano, sin base de datos, sin archivos CSV, sin archivos JSON, sin persistencia de ningún tipo.
- Herramientas de entrega: contenidos mínimos de Git y GitHub, web y terminal. Un único repositorio por grupo para todo el curso, con una carpeta por trabajo (tp-u1, tp-u2, tp-u3, trabajo-final) y mono-rama main hasta la última unidad; el ciclo completo de entrega (gitignore en la raíz, init, commits, repo remoto, remote add, push) se enseña una sola vez en el primer encuentro con entrega y de ahí en adelante cada entrega es carpeta nueva + commits + push. La última unidad profesionaliza el mismo repositorio: README de portada, issues, ramas por feature, pull requests revisados y main protegida. Un commit con mensaje que refiera al avance, por cada fin de encuentro o de clase que quede sin terminar.
- Base de datos: no se trata este tema; ninguna, de ningún tipo.
- Restricción de archivos: resolver cada trabajo en un solo archivo .py, sin dividir en módulos propios, salvo cuando no haya alternativa posible. Esto simplifica la cantidad de archivos que debe recordar el alumno. Los ejemplos rara vez superarán las 150 líneas.
- Código de ejemplo: agregue una buena dosis de comentarios para que los estudiantes puedan comprender mejor las acciones del código presentado.
- Convenciones técnicas: input/materias/LAP/convenciones-tecnicas.md — fuente única de tipos, formatos y estructura de código de este curso; leerla antes de generar cualquier ejemplo.

(Tiempo)
- Cantidad de horas por encuentro: 2.
- Tiempo efectivo disponible por encuentro: 50%.

(Institución)
- Modalidad: escuela técnica (el Encuentro 1 incluye seguridad e higiene y EPP).
