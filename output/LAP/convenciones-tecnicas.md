# Convenciones técnicas — Programación en Python

> **Canon del curso.** Esta hoja es la fuente única de verdad de tipos, formatos y estructura de código de la materia «Programación en Python». Todos los documentos de la materia la obedecen: **toda divergencia con esta hoja es un defecto**, no una variación de estilo.

| Campo | Valor |
| --- | --- |
| Curso | Programación en Python |
| Registro | Docente y alumnos |
| Archivos de datos canónicos | Archivos planos junto al programa, creados y leídos por el propio programa: `.txt` (texto libre), `.csv` (una fila por línea, campos separados por coma), `.json` (colección completa). **Sin base de datos de ningún tipo.** |
| Referencias de apoyo | Ficha de la materia (`materias/LAP/materia.md`) y documentación oficial de Python 3 (biblioteca estándar: `open`, `json`) |

## 1. Propósito y alcance

- Esta hoja define los **tipos de datos, formatos y estructura del código** de todo el curso: ejemplos de clase, anexos docentes, evaluaciones y trabajos de alumnos (TP-U1, TP-U2, TP-U3 y trabajo final).
- Ante cualquier duda técnica, **esta hoja decide**: el ajuste se hace primero acá y recién después se propaga a los documentos derivados. Nunca al revés.
- **Alcance:** entorno y estructura del proyecto, estilo de código, tipos canónicos entre archivos planos y Python, lectura y escritura de archivos de texto y JSON, entradas y salidas del programa con su manejo de errores, control de versiones y prueba del programa.
- **Fuera de alcance:** el contenido de cada encuentro (lo fija la planificación anual) y el formato pedagógico de los documentos (lo fija `estructura-de-la-clase.md`).

## 2. Entorno y estructura del proyecto

- **Entorno:** VS Code + terminal. Python 3.11 (verificar con `python --version`).
- **Proyecto:** no hay proyecto ni compilación: el programa es un archivo `.py` que se ejecuta con `python archivo.py` desde la terminal y se corta con `Ctrl+C`.
- **Dónde vive el código:** **un único archivo `.py` por trabajo**, en la carpeta del trabajo dentro del repositorio del grupo (`tp-u1/`, `tp-u2/`, `tp-u3/`, `trabajo-final/`). Prohibidas las carpetas-paquete propias (con `__init__.py`), los módulos propios múltiples y los entornos virtuales (no se usan librerías externas).
- **Archivos de datos:** junto al `.py`, con ruta relativa (nunca absoluta). Los crea y lee el propio programa.
- **Archivos extra:** ninguno más que los de datos. `.gitignore` en la raíz del repositorio desde el primer commit, con `__pycache__/`.
- **Esqueleto del archivo (orden fijo, verificado en el spike):**
  1. `import` de la biblioteca estándar, solo los que se usan (`json`, `sys`)
  2. Constantes en `MAYUSCULAS_CON_GUIONES_BAJOS` (rutas de datos, textos de menú)
  3. Funciones con `def` (sin clases)
  4. `def main():` como punto de entrada
  5. `if __name__ == "__main__":` llamando a `main()`, siempre al final

  Observación del spike: ejecutado directamente, `__name__` vale `"__main__"` y corre `main()`; **importado como módulo, el guard no ejecuta `main()`** pero el código a nivel de módulo sí se corre — por eso nada de lógica suelta fuera de funciones.

## 3. Estilo de código

- **Idiomas:** identificadores, nombres de archivo, comentarios y mensajes visibles **en español**, en `snake_case` y **sin tildes ni eñes dentro del código** (`lista_alumnos`, `cargar_datos`, `opcion = input("Elija una opcion: ")`). La prosa de los documentos del curso lleva tildes; el código, no.
- **Comentarios:** un comentario por cada acción del código, para que se entienda sin explicación oral. Ejemplo:
  ```python
  # Calcular el promedio del alumno
  promedio = suma_notas / cantidad
  ```
- **Ejemplos:** mínimos, completos, que corren tal cual con `python archivo.py`. Sin pseudocódigo ni fragmentos incompletos.
- **Prohibido:** clases, decoradores, librerías externas (nada de `pip install`), ORM, patrones de abstracción (repositorio, inyección de dependencias), módulos propios múltiples y construcciones «inteligentes» (comprensiones anidadas, `lambda` encadenadas): primero el bucle claro.
- **Errores:** `try/except` siempre con la excepción específica. Prohibido el `except:` desnudo.

## 4. Tipos canónicos (archivo ↔ Python)

> **Advertencia del spike de verificación.** Todas las reglas de esta sección se verificaron ejecutando Python 3.11 real contra archivos planos. El archivo siempre guarda **texto**: las conversiones de tipo ocurren en el borde del programa, con `int()`, `float()` o `json.load`.

| Dato en el archivo | Tipo Python | Ejemplo | Regla (comportamiento observado) |
| --- | --- | --- | --- |
| Texto (`.txt`/`.csv`/`.json`) | `str` | `nombre = "Ana"` | Tipo base de todo archivo plano. |
| Entero escrito en texto | `int` | `edad = int("23")` | `int(" 23 ")` convierte bien (ignora espacios); `int("23.5")` lanza `ValueError` observado. Convertir recién al leer el campo. |
| Decimal escrito en texto | `float` | `altura = float("1.75")` | `float("23")` devuelve `23.0` (observado): acepta enteros. Para decimales, siempre `float`. |
| Valor vacío o ausente | `None` o `""` | `apodo = None` | En JSON: `None` viaja como `null` y vuelve como `None` (round-trip observado). En texto plano se conviene campo vacío `""` y se valida con `if campo == "":`. |
| Booleano (solo JSON) | `bool` | `becado = True` | `json.dump` escribe `true`/`false` y `json.load` devuelve `True`/`False` (observado). En `.txt`/`.csv` no se usan bools: se conviene `"si"/"no"`. |
| Fecha | `str` ISO `AAAA-MM-DD` | `"2025-06-12"` | Sin `datetime` en el curso: el texto ISO se compara y ordena bien como string. Convertir solo al presentar, si hiciera falta. |

**Mapeo de nombres:** archivos y campos en `snake_case` sin tildes; el nombre del dato en el archivo es el mismo del código (`promedio` en el JSON ↔ variable `promedio`).

**Números desde el teclado:** `input()` **siempre devuelve `str`** (observado con entrada canalizada). Operar sin convertir lanza `TypeError` (`"1" + 1`). Convertir en el mismo renglón: `edad = int(input("Edad: "))`.

## 5. Archivos de texto y JSON

- **Apertura:** SIEMPRE `with open(ruta, modo, encoding="utf-8") as f:` — el `with` cierra el archivo solo y `encoding="utf-8"` es **obligatorio**: observado que sin `encoding=`, `open()` usa la codificación del sistema (cp1252 en el laboratorio; `locale.getpreferredencoding()` lo confirmó) y una ñ escrita así queda como byte `0xf1`, que la relectura UTF-8 rechaza con `UnicodeDecodeError`.
- **Modos (lista cerrada):** `"r"` leer; `"w"` escribir (¡**sobrescribe todo el archivo**: observado que tras dos escrituras con `"w"` queda solo la última!); `"a"` agregar al final.
- **CSV a mano:** una línea por registro, campos separados por coma; separar con `split(",")` y limpiar con `.strip()`. Observado: `"Ana, 23".split(",")` devuelve `['Ana', ' 23']` (deja espacios); la línea vacía `"".split(",")` devuelve `['']` — un campo vacío, no cero campos: filtrarla con `if linea.strip() == "": continue`.
- **JSON (biblioteca estándar):** `json.load(f)` para leer la colección completa, `json.dump(datos, f, ensure_ascii=False)` para escribir. Observado: por defecto `json.dump` escapa ñ y tildes como `\u00f1` (JSON válido pero ilegible); con `ensure_ascii=False` quedan los caracteres reales en UTF-8. `indent=2` produce el archivo multi-línea legible de los ejemplos.

Ejemplo canónico mínimo (carga segura de la colección, ejecutado en el spike):

```python
import json

RUTA_DATOS = "alumnos.json"   # constante arriba, en mayusculas

def cargar_alumnos():
    # Devuelve la lista de alumnos guardada en el archivo JSON.
    try:
        with open(RUTA_DATOS, "r", encoding="utf-8") as f:
            return json.load(f)
    except FileNotFoundError:
        # Primera corrida: todavia no existe el archivo de datos.
        return []

def guardar_alumnos(alumnos):
    # Sobrescribe el archivo con la coleccion completa.
    with open(RUTA_DATOS, "w", encoding="utf-8") as f:
        json.dump(alumnos, f, ensure_ascii=False, indent=2)
```

## 6. Entradas, salidas y errores del programa

El programa de consola no tiene HTTP: su interfaz son `input()`, `print()` y el código de salida.

- **Entrada:** `input("Mensaje: ")` muestra el mensaje y devuelve siempre `str`.
- **Salida:** `print()` con mensajes en español; un mensaje claro por cada resultado y por cada error esperado.
- **Código de salida:** `0` normal (por defecto); ante datos dañados o irrecuperables, avisar con `print` y terminar con `sys.exit(1)` (observado: el proceso devuelve `1`).

| Situación | Error que lanza Python | Manejo canónico | Mensaje del curso |
| --- | --- | --- | --- |
| Archivo de datos inexistente | `FileNotFoundError` | `except FileNotFoundError` → valor inicial (`[]`) o aviso | «No existe el archivo de datos: se empieza de cero» |
| Número mal escrito | `ValueError` | reintentar el `input()` | «Debe ingresar un numero valido» |
| JSON malformado | `json.JSONDecodeError` | avisar y `sys.exit(1)` | «El archivo de datos esta dañado» |
| Clave ausente en un dict | `KeyError` | validar con `in` antes de leer | — |

- **Excepciones específicas siempre:** `except ValueError:`, `except FileNotFoundError:`, `except json.JSONDecodeError:`. El `except:` desnudo queda prohibido: oculta el error real.
- **Al alumno nunca llega un traceback** de una situación prevista: toda lectura/escritura de archivo y toda conversión numérica van dentro de su `try/except` específico.
- Mensajes en español, sin tildes dentro del código.

## 7. Control de versiones del alumno

- **Repositorio:** uno por grupo para todo el curso, con una carpeta por trabajo (`tp-u1/`, `tp-u2/`, `tp-u3/`, `trabajo-final/`), en mono-rama `main` hasta la Unidad 4.
- **Ciclo completo de entrega, una sola vez** (Encuentro 7): `.gitignore` en la raíz (con `__pycache__/`), `git init`, `add`/`commit`, repo remoto en GitHub, `git remote add origin`, `push`. Desde ahí, cada entrega es carpeta nueva + commits + push.
- **Ignorados:** `__pycache__/` desde el primer commit (Python no genera más basura que eso en este curso).
- **Rutina de cierre de cada encuentro:**
  ```bash
  git add .
  git commit -m "<carpeta>: <resumen en espanol, sin tildes>"
  git push
  ```
  Un commit que refiera al avance al final de cada encuentro, o de la clase que quede sin terminar.
- **Unidad 4 — profesionalización del mismo repositorio:** README de portada, issues, ramas por feature, pull requests revisados y `main` protegida.

## 8. Probar el programa

- **Correr:** `python archivo.py` desde la terminal (la de VS Code sirve). `Ctrl+C` para cortar.
- **Probar siempre dos caminos:** el caso normal (datos válidos) y el caso de error (archivo ausente, número inválido): la tabla de la sección 6 se verifica acá, no en teoría.
- **Verificar los datos:** tras cada corrida, abrir el `.txt`/`.csv`/`.json` generado (en VS Code, o `type archivo` en la terminal) para confirmar qué quedó escrito.
- **No hay servidor, puerto ni herramientas HTTP:** la «respuesta» del programa es su salida en la terminal.

## 9. Checklist de defectos frecuentes

> Cada defecto fue observado en el spike de verificación con Python 3.11 real, contra archivos planos.

| ✔ | Defecto | Comportamiento observado | Corrección |
| --- | --- | --- | --- |
| ☐ | `open()` sin `encoding="utf-8"` | usa la codificación del sistema (cp1252 observado); la ñ escrita así queda como byte `0xf1` y la relectura UTF-8 lanza `UnicodeDecodeError` | Siempre `with open(ruta, modo, encoding="utf-8")`. |
| ☐ | Operar `input()` sin convertir | `input()` devuelve `str`; `"1" + 1` lanza `TypeError` | `int(input(...))` o `float(input(...))` en el renglón. |
| ☐ | `int("23.5")` | `ValueError: invalid literal for int() with base 10: '23.5'` | `float()` para decimales; `int()` solo para enteros. |
| ☐ | `split(",")` sin `strip()` | `"Ana, 23".split(",")` → `['Ana', ' 23']`: queda el espacio (a `int` no le importa, a las comparaciones de texto sí) | `.strip()` en cada campo. |
| ☐ | Procesar líneas sin filtrar vacías | `"".split(",")` → `['']`: la línea vacía entra como un registro de un campo | `if linea.strip() == "": continue`. |
| ☐ | Comparar líneas recién leídas | cada línea conserva el `\n` (`repr` → `'Ana\n'`) | `.strip()` (o `.rstrip("\n")`) al leer. |
| ☐ | Abrir con `"w"` queriendo agregar | `"w"` trunca: tras dos escrituras queda solo la última | `"a"` para agregar; `"w"` solo para reescribir todo. |
| ☐ | `json.dump` sin `ensure_ascii=False` | escribe `\u00f1` en lugar de ñ | `json.dump(datos, f, ensure_ascii=False)`. |
| ☐ | `except:` desnudo | atrapa cualquier error y el programa «sigue» roto sin decir por qué | `except ValueError:`, `except FileNotFoundError:`, etc. |
| ☐ | Lógica suelta fuera de funciones | al importar el archivo, el código a nivel de módulo se ejecuta igual (observado) | Constantes → funciones → `main()` → guard `if __name__ == "__main__":`. |
