# Digest de código para writers — Programación en Python

> Digest de trabajo para writers — canon completo: `input/materias/LPR/convenciones-tecnicas.md`; ante conflicto manda el canon completo.

- **Entorno:** VS Code + terminal, Python 3; el programa corre con `python <archivo>.py` y se corta con `Ctrl+C`.
- **Un solo archivo:** todo el código del ejemplo o trabajo en un único `.py`; funciones `def` arriba, bloque `if __name__ == "__main__":` al final; sin carpetas ni módulos propios, sin `models/` ni `services/`.
- **Sin persistencia:** nada de archivos, CSV, JSON ni bases de datos; el estado vive en variables y colecciones en memoria.
- **Alcance del lenguaje:** programación imperativa con funciones sencillas. Prohibido: clases (POO), lambda, map/filter/reduce, comprehensions avanzadas, patrones de diseño, type hints.
- **Tipos canónicos:** `int`, `float`, `str`, `bool`, `list`, `tuple`, `set`, `dict`. `input()` SIEMPRE devuelve `str`: convertir al leer con `int()`/`float()` dentro de `try/except ValueError`.
- **Operadores:** `/` división real (`3.5`), `//` entera, `%`, `**`; comparaciones `== != < > <= >=` y `and/or/not`.
- **Mensajes al usuario:** SIEMPRE f-strings (`f"Total: ${total:.2f}"`), en español con tildes correctas; identificadores en inglés y `snake_case`, sin tildes ni eñes.
- **Comentarios:** un comentario en español por acción relevante del código.
- **Cadenas:** `split` (sin argumento colapsa espacios repetidos), `strip` (solo bordes), `join`, `replace`; `str` es inmutable.
- **Listas:** `append`/`pop`/`index`/`sort` devuelven `None`: nunca `xs = xs.sort()`; `sorted()` para copia ordenada.
- **Diccionarios:** `keys()`/`values()`/`items()`; `.get(clave, default)` para claves dudosas; `in` para membresía.
- **Validación:** patrón `while True:` + `try/except ValueError` con reintento y mensaje accionable en español; `except:` desnudo prohibido.
- **Ejemplos:** mínimos, completos, ejecutables tal cual, ≤150 líneas por archivo.
- **Git del alumno:** repositorio grupal con carpetas `tp-u1/`…`trabajo-final/`, mono-rama `main` hasta la Unidad 4; en la Unidad 4: README de portada, issues, ramas por feature, pull requests revisados y `main` protegida. Commit por fin de encuentro: `git commit -m "tp-u1: <avance>"` (español, minúsculas tras los dos puntos).