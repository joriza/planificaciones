# Encuentro 25 — Cierre U3: repaso y TP

> Procesamiento de texto y validación · Encuentro de cierre de unidad

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 25 de 36 |
| Unidad | 3 — Procesamiento de texto y validación |
| Eje temático | 3 — Procesamiento de texto y validación |
| Carácter/Objetivo | Actitudinal |
| Estructura | cierre |
| Duración teórica | 120 minutos (2 horas) |
| TP obligatorio | TP-U3: menú de consola validado |
| Concepto nuevo | Cierre U3: repaso y TP |
| Requisitos previos | Encuentros 21–24: cadenas, try/except, módulos, menú del TP |
| Uso de celular | No permitido |
| Organización del trabajo | Trabajo individual; los alumnos entregan su TP-U3 con carpeta nueva, commits y push |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura | 10 min |
| Consolidación | 30 min |
| Trabajo del TP | 35 min |
| Ciclo de entrega | 30 min |
| Cierre | 15 min |
| **Total** | **120 min** |

## 2. Objetivos de aprendizaje

1. Sistematizar los conceptos clave de la Unidad 3: métodos de cadenas, validación con try/except, menús en memoria.
2. Completar y entregar el TP-U3 con menú de consola validado en un solo archivo `.py`.
3. Aplicar el ciclo de entrega con carpeta nueva, commits y push al repositorio del grupo.
4. Reflexionar sobre los errores más frecuentes de la unidad y cómo evitarlos.

## 3. Apertura y puente (10 min)

### Charla rápida: la unidad en una frase

Esta unidad nos enseñó que un programa en Python no se rompe si lo anticipamos: `split`, `strip`, `join` y `replace` nos dan herramientas para procesar el texto que el usuario tipea; `try/except ValueError` nos protege cuando el usuario no tipea lo que esperamos; y un menú en memoria nos organiza todo el programa en un solo archivo, sin archivos ni bases de datos. En síntesis: programas robustos que viven en memoria.

### Lo mínimo indispensable

- La unidad cubrió tres ejes: procesamiento de texto (métodos de cadena), validación de entrada (try/except) e integración (menú en memoria).
- Todo programa del curso se organiza con funciones arriba y bloque `if __name__ == "__main__":` al final.
- La entrada de `input()` siempre es `str`; se convierte con `int()` o `float()` dentro de `try/except ValueError`.
- El estado del programa vive en variables y colecciones en memoria; no hay persistencia de ningún tipo.

## 4. Consolidación (30 min)

**Repaso práctico** — Completá el siguiente programa `repaso_u3.py` que integra los tres ejes de la unidad:

```python
# repaso_u3.py
# Programa de repaso que integra métodos de cadena, try/except y menú.

def procesar_texto():
    # Ejercicio de procesamiento de texto con split, strip, join.
    frase = input("Ingresá una frase: ").strip()
    palabras = frase.split()
    print(f"Palabras: {palabras}")
    print(f"Unidas con guiones: {'-'.join(palabras)}")
    print(f"Cantidad de palabras: {len(palabras)}")


def leer_numero():
    # Ejercicio de validación con try/except.
    while True:
        try:
            return int(input("Ingresá un número entero: "))
        except ValueError:
            print("Eso no es un número entero; intentá de nuevo.")


def menu_principal():
    # Menú que integra los dos ejercicios anteriores.
    while True:
        print("\n--- Menú de Repaso ---")
        print("1. Procesar texto")
        print("2. Leer número validado")
        print("3. Salir")
        opcion = input("Elegí una opción: ").strip()
        if opcion == "1":
            procesar_texto()
        elif opcion == "2":
            numero = leer_numero()
            print(f"Ingresaste el número: {numero}")
        elif opcion == "3":
            print("¡Hasta luego!")
            break
        else:
            print("Opción inválida; elegí 1, 2 o 3.")


if __name__ == "__main__":
    menu_principal()
```

Ejecutá el programa y probá las tres opciones, incluyendo entradas no numéricas en la opción 2.

## 5. Trabajo del TP (35 min)

**Consigna:** Completá, probá y corregí tu TP-U3 (`tp_u3_menu.py` o el nombre que hayas elegido). El programa debe:

1. Vivir en un solo archivo `.py`.
2. Tener un menú textual con al menos 4 opciones.
3. Usar funciones para cada opción del menú.
4. Validar toda entrada numérica con `try/except ValueError`.
5. Usar `strip()` para limpiar entradas de texto.
6. Mostrar resultados con f-strings formateados.
7. No usar persistencia de ningún tipo (sin archivos, sin CSV, sin JSON, sin base de datos).
8. Tener comentarios en español que expliquen las acciones relevantes.

**Pista:** Revisá los errores comunes de la Unidad 3 y asegurate de que tu programa no tenga ninguno. Probalo con datos válidos, datos no numéricos donde se espera un número, y opciones de menú inexistentes.

**Solución esperada:** El programa `tp_u3_menu.py` del encuentro 24, completo y funcional, con todas las opciones implementadas y probadas.

## 6. Ciclo de entrega (30 min)

**Paso 1** — Creá una carpeta nueva para la entrega: `entrega-tp-u3/`.

**Paso 2** — Copiá tu archivo `.py` del TP-U3 dentro de esa carpeta.

**Paso 3** — Desde la terminal, navegá a la carpeta del proyecto y ejecutá:

```bash
git add .
git commit -m "tp-u3: menú de consola validado completado"
git push
```

**Paso 4** — Verificá que el archivo `.gitignore` en la raíz del repositorio tiene `__pycache__/` y `.vscode/` ignorados.

**Paso 5** — Asegurate de que tu programa se ejecuta correctamente con `python tp_u3_menu.py` desde la carpeta de la entrega.

## 7. Cierre (15 min)

### Qué te llevás

- `split()`, `strip()`, `join()` y `replace()` son la caja de herramientas canónica para procesar texto de entrada.
- `try/except ValueError` con `while True` es el patrón canónico para validar que `input()` contiene un número.
- Un menú de consola en memoria integra funciones, colecciones y validación en un solo archivo `.py`.
- El ciclo de entrega es: carpeta nueva + commits + push, sin archivos de basura en el repositorio.
- `str` es inmutable; `list` y `dict` son mutables; `append()` y `sort()` mutan in-place y devuelven `None`.

### Lo que viene

En la próxima unidad vamos a trabajar con el programa integrador final, que incluirá ramas, pull requests y un repositorio profesional.

## 8. Errores comunes y trampas

1. **`lista = lista.append(x)`** — `append()` devuelve `None` y muta la lista; asignar el resultado anula la lista. Usá `lista.append(x)` en su propia línea.
2. **`lista = lista.sort()`** — `sort()` muta la lista y devuelve `None`; asignar el resultado anula la lista. Usá `lista.sort()` en su propia línea.
3. **`int("12.5")` lanza `ValueError`** — `int()` no acepta decimales como texto; para eso usá `float()` primero.
4. **`except:` desnudo** — Captura cualquier excepción, incluyendo `KeyboardInterrupt`, y esconde errores de programación. Siempre nombrá la excepción: `except ValueError`.
5. **`d["clave"]` sin comprobar** — Lanza `KeyError` si la clave no existe; usá `.get()` o verificá con `in` antes de acceder.
6. **Olvidar `strip()` en `input()`** — Los espacios al inicio y al final de la entrada del usuario se conservan; `strip()` los quita.
