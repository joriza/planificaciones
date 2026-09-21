# Encuentro 22 — CSV plano a mano

## Metadatos de bloque

| Campo | Valor |
|---|---|
| **Duración** | 120 minutos |
| **Unidad** | 3 — Datos estructurados y JSON |
| **Tipo** | Procedimental |
| **Requiere** | Encuentro 21: agenda `agenda_dict.py` en memoria con lista de dicts, menú validado y búsqueda. Unidad 2: `with open`, modos `r`/`w`/`a`, `except FileNotFoundError`. |
| **Nuevo concepto** | Leer CSV con `split(",")` y `.strip()`, filtrar líneas vacías, escribir línea por línea con `join(",")` y `"\n"`, sobrescritura completa con modo `"w"` |

## Reparto de tiempos (120 minutos)

| Bloque | Duración |
|---|---|
| Apertura y motivación | 10 min |
| Desarrollo teórico-práctico | 60 min |
| Consolidación y cierre | 20 min |
| Actividad complementaria | 30 min |

## Objetivos de aprendizaje

- Escribir un archivo CSV a mano: una línea por registro, campos separados por coma, con `join(",")`.
- Leer un CSV con `split(",")` y `.strip()`, filtrando las líneas vacías.
- Reconstruir la lista de dicts en memoria a partir del archivo y conservarla entre corridas.
- Aplicar el manejo canónico de errores: `FileNotFoundError` en la primera corrida y sobrescritura segura con modo `"w"`.

## Apertura y motivación

Se corre la agenda del encuentro 21: se agregan dos contactos, se corta el programa con `Ctrl+C` y se vuelve a correr. Todo desapareció: la agenda vive solo en la memoria del proceso. El problema de hoy es la **persistencia**: que los registros queden en un archivo junto al programa.

El formato elegido para el primer paso es el CSV más simple posible: una línea por contacto y los campos separados por coma, escritos y leídos a mano con lo que el curso ya conoce (`open`, `split`, `strip`, `join`). Sin librerías externas: la biblioteca estándar alcanza.

## Teoría mínima

### Escribir el CSV: una línea por registro

Para escribir, la lista de dicts en memoria se vuelca completa al archivo: el modo `"w"` **sobrescribe todo**, y esa característica se usa a favor — el archivo siempre queda espejo exacto de la lista. La línea se arma con `join` y termina en `"\n"`.

### Leer el CSV: `split`, `strip` y líneas vacías

Para leer, cada línea se corta con `split(",")` y cada campo se limpia con `.strip()`. Dos comportamientos verificados del canon:

- `"Ana, 2664".split(",")` devuelve `['Ana', ' 2664']`: deja el espacio, por eso cada campo lleva su `.strip()`.
- `"".split(",")` devuelve `['']`: la línea vacía entra como un registro de un campo. Se filtra con `if linea.strip() == "": continue`.

### Demo completa para correr

`csv_basico.py` — escribe dos contactos, los vuelve a leer y los muestra:

```python
# Demo minima de CSV: escribir y leer una agenda de dos contactos.

RUTA_CSV = "agenda.csv"

def guardar_contactos(contactos):
    # Reescribe el archivo completo: una linea por contacto.
    with open(RUTA_CSV, "w", encoding="utf-8") as f:
        for contacto in contactos:
            linea = ",".join([contacto["nombre"], contacto["telefono"], contacto["correo"]])
            f.write(linea + "\n")

def cargar_contactos():
    # Lee el archivo y devuelve la lista de contactos como dicts.
    try:
        with open(RUTA_CSV, "r", encoding="utf-8") as f:
            contactos = []
            for linea in f:
                if linea.strip() == "":
                    continue
                campos = linea.strip().split(",")
                contacto = {"nombre": campos[0].strip(), "telefono": campos[1].strip(), "correo": campos[2].strip()}
                contactos.append(contacto)
            return contactos
    except FileNotFoundError:
        # Primera corrida: todavia no existe el archivo de datos.
        return []

def main():
    # Escribir dos contactos, volver a leerlos y mostrarlos.
    contactos = [
        {"nombre": "Ana", "telefono": "2664-555123", "correo": "ana@gmail.com"},
        {"nombre": "Bruno", "telefono": "2664-555456", "correo": "bruno@gmail.com"}
    ]
    guardar_contactos(contactos)
    leidos = cargar_contactos()
    for persona in leidos:
        print(persona["nombre"], "-", persona["telefono"], "-", persona["correo"])

if __name__ == "__main__":
    main()
```

Salida esperada, y verificación del archivo con `type agenda.csv`:

```text
Ana - 2664-555123 - ana@gmail.com
Bruno - 2664-555456 - bruno@gmail.com
```

```text
Ana,2664-555123,ana@gmail.com
Bruno,2664-555456,bruno@gmail.com
```

### El límite del formato

El CSV a mano no admite comas **dentro** de un campo: la coma es el separador y `split` cortaría el dato en dos. Los campos del curso (nombre, teléfono, correo) no llevan comas; esta restricción explícita es una de las razones por las que el encuentro 23 pasa a JSON. Sin `encoding="utf-8"`, además, la codificación del sistema corrompe nombres con ñ o tildes: el `encoding` es obligatorio en cada `open`.

## Ejercicio progresivo: agenda con persistencia en CSV

Ejercicio único de la clase, en un solo archivo `agenda_csv.py`, que parte de `agenda_dict.py` del encuentro 21.

### Etapa 1 — Guardar (en el desarrollo teórico-práctico)

Copiar `agenda_dict.py` a `agenda_csv.py` y agregar `guardar_contactos()` de la demo. Probarla desde `main` con la lista de ejemplo y abrir `agenda.csv` con `type agenda.csv` para verificar qué quedó escrito.

**Pista:** el modo es `"w"` y el `encoding="utf-8"` es obligatorio.

### Etapa 2 — Cargar (en el desarrollo teórico-práctico)

Agregar `cargar_contactos()` de la demo, con el `except FileNotFoundError` que devuelve `[]` en la primera corrida. Verificar el ciclo completo: correr una vez (crea el archivo), borrar `agenda.csv`, correr de nuevo (arranca vacía, sin `traceback`).

**Pista:** el filtro de líneas vacías y el `.strip()` de cada campo evitan registros fantasma.

### Etapa 3 — Integrar el menú (en la actividad complementaria)

Conectar la persistencia al menú de la unidad: cargar al inicio de `main`, guardar después de cada alta y también al salir con la opción 0, con el aviso «Cambios guardados.».

**Pista:** guardar es reescribir la colección completa: el momento de guardar no cambia el contenido, solo protege ante un corte inesperado.

## Consolidación y cierre

- Puesta en común: abrir `agenda.csv` de 2 o 3 grupos y comparar contenido.
- Verificación de los dos caminos del canon: caso normal (alta + listado persistido) y caso de error (archivo ausente en la primera corrida).
- Verificar el mensaje de la opción inválida del menú y que ningún `traceback` llegue a la pantalla.
- Rutina de Git de cierre: `git add .`, `git commit -m "u3: agenda persistida en csv"` y `git push`.
- Próximo encuentro: el CSV sirve, pero los campos siguen viajando por posición y todo es texto; el encuentro 23 guarda la colección completa en JSON con la biblioteca estándar.

## Actividad complementaria

- Terminar la Etapa 3 (menú con carga al inicio y guardado en cada alta y al salir).
- Desafío: rechazar en el alta un nombre que ya exista (búsqueda previa con la función del encuentro 21).
- Desafío: opción de menú que cuente cuántos contactos hay guardados y lo muestre.

## Errores comunes

| Error | Causa | Corrección |
|---|---|---|
| Los campos llegan con espacios (`' Ana'`) | `split(",")` conserva los espacios después de la coma. | `.strip()` en cada campo al leer. |
| Aparece un registro de un solo campo vacío | La línea vacía `"".split(",")` devuelve `['']`. | Filtrar con `if linea.strip() == "": continue`. |
| Se pierden contactos al agregar de a uno | Se abre con modo `"w"` en cada escritura parcial: `"w"` trunca el archivo. | Con la estrategia del curso no pasa: siempre se reescribe la lista completa desde memoria. |
| `UnicodeDecodeError` al releer | `open()` sin `encoding="utf-8"` usa la codificación del sistema. | Siempre `with open(ruta, modo, encoding="utf-8")`. |
| `IndexError: list index out of range` | Una línea con menos de tres campos (archivo editado a mano). | Trabajar con archivos que escribe el propio programa; validar el largo de `campos` si se edita a mano. |
| El teléfono con cero inicial se corrompe | Tratar el teléfono como número y convertirlo con `int()`. | El teléfono es texto: no se convierte, se guarda y se muestra tal cual. |
