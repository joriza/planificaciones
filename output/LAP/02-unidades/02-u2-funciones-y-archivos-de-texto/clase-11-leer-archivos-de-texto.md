# Encuentro 11: Leer archivos de texto

## Datos del encuentro

| Campo | Valor |
|---|---|
| Unidad | U2: Funciones y archivos de texto |
| Encuentro | 11 de 20 |
| Duración | 120 minutos |
| Carácter | Procedimental |

## Objetivos de aprendizaje

- Abrir un archivo para leer con `with open(ruta, "r", encoding="utf-8")`.
- Recorrer el archivo línea por línea y limpiar cada línea con `.strip()`.
- Separar los campos de una línea con `split(",")`.
- Manejar `FileNotFoundError` con un mensaje claro y un valor inicial.

## Reparto de tiempos (120 minutos)

| Bloque | Minutos |
|---|---|
| Apertura y motivación | 10 |
| Desarrollo teórico-práctico | 60 |
| Consolidación y cierre | 20 |
| Actividad complementaria | 30 |

## Charla rápida

La agenda del Encuentro 10 tenía un problema: al cortar el programa, todos los contactos volaban. Hoy la agenda empieza a parecerse a la de papel: lo anotado sigue ahí después de cerrar el cuaderno. Un archivo de texto plano junto al `.py` cumple ese papel: cada contacto es una línea, y los campos van separados por coma. Al abrir el programa, primero se lee el archivo; si el cuaderno todavía no existe, no es un error del programa: es la primera corrida, y se empieza de cero.

## Teoría mínima

### Abrir y leer con `with open`

Siempre igual, con `encoding="utf-8"` obligatorio:

```python
with open(RUTA_DATOS, "r", encoding="utf-8") as f:
    for linea in f:
        # Procesar cada linea del archivo
        print(linea)
```

El `with` cierra el archivo solo, aun si algo falla adentro. Sin `encoding=`, `open()` usa la codificación del sistema (cp1252 en el laboratorio): una ñ escrita así queda como byte `0xf1` y la relectura como UTF-8 falla con `UnicodeDecodeError`.

### Cada línea llega con su `\n`

Cada línea leída conserva el salto de renglón: `repr("Ana\n")` lo muestra. Antes de usar la línea, limpiarla:

```python
linea = linea.strip()
```

### Separar campos con `split(",")`

Una línea `Ana,4567,23` se convierte en lista con `split(",")`; cada campo se limpia con `.strip()` porque `split` deja los espacios (`"Ana, 23".split(",")` devuelve `['Ana', ' 23']`). La línea vacía, filtrada antes: `"".split(",")` devuelve `['']` — un campo, no cero campos.

```python
if linea == "":
    continue
campos = linea.split(",")
```

### El archivo puede no existir: `FileNotFoundError`

La primera corrida no encuentra `contactos.txt`. No es un crash: es una situación prevista, con su `except` específico y su mensaje:

```python
try:
    with open(RUTA_DATOS, "r", encoding="utf-8") as f:
        ...
except FileNotFoundError:
    print("No existe el archivo de datos: se empieza de cero")
    return []
```

## Práctica guiada: cargar la agenda desde el archivo

**Paso 1:** agregar la constante de la ruta arriba de todo, debajo de `TEXTO_MENU`:

```python
RUTA_DATOS = "contactos.txt"
```

**Paso 2:** agregar la función de carga (con las demás funciones, antes de `main()`):

```python
def cargar_contactos():
    # Leer el archivo y devolver la lista de contactos guardados.
    try:
        with open(RUTA_DATOS, "r", encoding="utf-8") as f:
            contactos = []
            for linea in f:
                linea = linea.strip()
                if linea == "":
                    continue
                campos = linea.split(",")
                nombre = campos[0].strip()
                telefono = campos[1].strip()
                edad = int(campos[2].strip())
                contactos.append([nombre, telefono, edad])
            return contactos
    except FileNotFoundError:
        # Primera corrida: todavia no existe el archivo de datos.
        print("No existe el archivo de datos: se empieza de cero")
        return []
```

**Paso 3:** en `main()`, reemplazar la lista vacía por la carga:

```python
    contactos = cargar_contactos()
```

**Paso 4:** ejecutar sin archivo, para ver el camino de la primera corrida:

```bash
python agenda.py
```

```
No existe el archivo de datos: se empieza de cero
```

**Paso 5:** crear a mano `contactos.txt` junto al `.py` (en VS Code), con este contenido:

```
Ana,4567,23
Luis,7890,35
Mara,3210,19
```

**Paso 6:** ejecutar de nuevo y elegir la opción 2. Salida esperada:

```
=== Contactos ===
0 - Ana | Tel: 4567 | Edad: 23
1 - Luis | Tel: 7890 | Edad: 35
2 - Mara | Tel: 3210 | Edad: 19
```

**Paso 7:** probar los dos caminos: renombrar el archivo y correr (mensaje de primera corrida), y agregar una línea en blanco al medio del archivo (no aparece ningún contacto fantasma).

## Ejercicio independiente: ver el archivo tal cual

Agregar la opción `5) Ver el archivo de datos` con una función `mostrar_archivo()` que imprima el contenido crudo, línea por línea, sin convertir nada. Si el archivo está vacío, avisar; si no existe, avisar.

**Pista:** mismo `with open(...)` con `"r"`, mismo `try/except FileNotFoundError`; llevar un contador de líneas mostradas y, si terminó en cero, imprimir el aviso. No llamar a `split` ni a `int`: la idea es ver el texto tal cual queda en el disco.

**Solución esperada:**

```python
def mostrar_archivo():
    # Mostrar el archivo tal cual, una linea por registro.
    try:
        with open(RUTA_DATOS, "r", encoding="utf-8") as f:
            cantidad = 0
            for linea in f:
                linea = linea.strip()
                if linea == "":
                    continue
                print(linea)
                cantidad = cantidad + 1
            if cantidad == 0:
                print("El archivo no tiene contactos guardados")
    except FileNotFoundError:
        print("No existe el archivo de datos: se empieza de cero")
```

## Actividad complementaria

Sobre la extensión de la unidad: si el archivo trae una edad mal escrita (por ejemplo `23.5` o `veinte`), `int()` lanza `ValueError` y la carga se corta. Agregar al `cargar_contactos()` un `except ValueError` que avise «Hay una linea con datos invalidos en el archivo» y omita esa línea con `continue`, para que el resto de la agenda cargue igual.

## Rutina de cierre (git)

```bash
git add .
git commit -m "tp-u2: lectura de contactos desde archivo"
git push
```

## Cierre

**Qué te llevas:** la lectura tiene forma fija: `with open(ruta, "r", encoding="utf-8")`, recorrer con `for`, limpiar cada línea con `.strip()`, filtrar las vacías y separar campos con `split(",")`. `FileNotFoundError` es la primera corrida, no un error: mensaje claro y lista vacía.

**Lo que viene:** hoy se lee, pero la agenda sigue sin poder guardar lo nuevo. En el Encuentro 12 se escribe el archivo: modo `"w"` para reescribir todo y modo `"a"` para agregar al final.

## Errores comunes y trampas

| Error | Causa | Solución |
|---|---|---|
| `open()` sin `encoding="utf-8"` | Usa la codificación del sistema (cp1252 observado); la ñ queda como byte `0xf1` y la relectura UTF-8 lanza `UnicodeDecodeError`. | Siempre `with open(ruta, modo, encoding="utf-8")`. |
| Comparar la línea recién leída | Cada línea conserva el `\n` (`repr` → `'Ana\n'`), y ninguna búsqueda coincide. | `.strip()` (o `.rstrip("\n")`) al leer cada línea. |
| `split(",")` sin `strip()` en los campos | `"Ana, 23".split(",")` deja el espacio: a `int` no le importa, a las comparaciones de texto sí. | `.strip()` en cada campo. |
| Procesar líneas sin filtrar vacías | `"".split(",")` devuelve `['']`: la línea vacía entra como un registro de un campo. | `if linea.strip() == "": continue`. |
| Capturar el archivo ausente con `except ValueError` | La excepción equivocada: el `FileNotFoundError` pasa de largo y el programa se corta. | `except FileNotFoundError:` con su mensaje canónico. |
| Olvidar el `return contactos` | La función carga bien pero devuelve `None`, y `main()` recibe nada. | `return contactos` al terminar el bucle, adentro del `try`. |
