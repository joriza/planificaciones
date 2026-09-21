# Encuentro 23 — JSON con la stdlib

## Metadatos de bloque

| Campo | Valor |
|---|---|
| **Duración** | 120 minutos |
| **Unidad** | 3 — Datos estructurados y JSON |
| **Tipo** | Procedimental |
| **Requiere** | Encuentro 22: agenda persistida en `agenda.csv` con `split`/`strip`/`join`. Encuentro 21: lista de dicts en memoria. Canon de JSON: `json.load`, `json.dump` con `ensure_ascii=False` e `indent=2`, `encoding="utf-8"`. |
| **Nuevo concepto** | `json.load` y `json.dump` de la biblioteca estándar, colección completa en un archivo, `json.JSONDecodeError` con aviso y `sys.exit(1)` |

## Reparto de tiempos (120 minutos)

| Bloque | Duración |
|---|---|
| Apertura y motivación | 10 min |
| Desarrollo teórico-práctico | 60 min |
| Consolidación y cierre | 20 min |
| Actividad complementaria | 30 min |

## Objetivos de aprendizaje

- Guardar la colección completa en JSON con `json.dump(datos, f, ensure_ascii=False, indent=2)` dentro de `with open(..., encoding="utf-8")`.
- Cargar el archivo con `json.load(f)` y recibir la lista de dicts lista para usar, sin conversiones a mano.
- Distinguir los dos errores previstos: `FileNotFoundError` (primera corrida, arranca vacía) y `json.JSONDecodeError` (archivo dañado, aviso y `sys.exit(1)`).
- Verificar el archivo generado y justificar `ensure_ascii=False` e `indent=2`.

## Apertura y motivación

Se abre el `agenda.csv` del encuentro 22 frente al grupo: los datos están ahí, pero el programa tuvo que cortar y limpiar cada línea, y los campos siguen identificados solo por su posición. El JSON resuelve las dos cosas: guarda **la colección completa** en un único archivo y conserva la estructura de la lista de dicts tal como vive en memoria. Cargar es una sola llamada y el archivo queda legible para una persona.

## Teoría mínima

### Las dos funciones de la biblioteca estándar

- `json.load(f)`: lee el archivo abierto y devuelve la colección completa (acá, una lista de dicts).
- `json.dump(datos, f, ensure_ascii=False, indent=2)`: escribe la colección completa. `ensure_ascii=False` deja las ñ y tildes como caracteres reales en UTF-8 (sin él, `json.dump` las escapa como `\u00f1`: JSON válido pero ilegible); `indent=2` produce el archivo multilínea legible.

### Demo completa para correr

`json_basico.py`:

```python
# Demo minima de JSON: guardar y cargar la coleccion completa.

import json

RUTA_JSON = "agenda.json"

def guardar_contactos(contactos):
    # Sobrescribe el archivo con la coleccion completa.
    with open(RUTA_JSON, "w", encoding="utf-8") as f:
        json.dump(contactos, f, ensure_ascii=False, indent=2)

def cargar_contactos():
    # Devuelve la lista de contactos; si no existe el archivo, arranca vacia.
    try:
        with open(RUTA_JSON, "r", encoding="utf-8") as f:
            return json.load(f)
    except FileNotFoundError:
        # Primera corrida: todavia no existe el archivo de datos.
        return []

def main():
    # Guardar, cargar y mostrar; despues verificar el archivo en VS Code.
    contactos = [
        {"nombre": "Ana", "telefono": "2664-555123", "correo": "ana@gmail.com"},
        {"nombre": "Bruno", "telefono": "2664-555456", "correo": "bruno@gmail.com"}
    ]
    guardar_contactos(contactos)
    leidos = cargar_contactos()
    print("Contactos leidos:", len(leidos))
    for persona in leidos:
        print(persona["nombre"], "-", persona["correo"])

if __name__ == "__main__":
    main()
```

Salida esperada, y contenido de `agenda.json`:

```text
Contactos leidos: 2
Ana - ana@gmail.com
Bruno - bruno@gmail.com
```

```json
[
  {
    "nombre": "Ana",
    "telefono": "2664-555123",
    "correo": "ana@gmail.com"
  },
  {
    "nombre": "Bruno",
    "telefono": "2664-555456",
    "correo": "bruno@gmail.com"
  }
]
```

### Los dos errores previstos

| Situación | Error que lanza Python | Manejo canónico del curso |
|---|---|---|
| Primera corrida, archivo inexistente | `FileNotFoundError` | `except FileNotFoundError` → devolver `[]` |
| Archivo dañado (JSON malformado) | `json.JSONDecodeError` | Avisar «El archivo de datos esta corrupto.» y terminar con `sys.exit(1)` |

Para el archivo dañado, `main` se protege así:

```python
    try:
        contactos = cargar_contactos()
    except json.JSONDecodeError:
        # El archivo existe pero su contenido no es JSON valido.
        print("El archivo de datos esta corrupto.")
        sys.exit(1)
```

El `import json` del encabezado del archivo se completa con `import sys`. Las excepciones siempre específicas: el `except:` desnudo está prohibido.

## Ejercicio progresivo: agenda persistida en JSON

Ejercicio único de la clase, en un solo archivo `agenda_json.py`, que migra la agenda del encuentro 22.

### Etapa 1 — Cambiar el formato de persistencia (en el desarrollo teórico-práctico)

Copiar `agenda_csv.py` a `agenda_json.py` y reemplazar `guardar_contactos` y `cargar_contactos` por las versiones JSON de la demo. Correr el menú completo, dar de alta un contacto y abrir `agenda.json` en VS Code: la colección completa, multilínea, con claves con nombre.

**Pista:** el resto del programa (menú, alta, listado, búsqueda) no cambia: la estructura en memoria es la misma lista de dicts.

### Etapa 2 — Experimento dirigido sobre el formato (en el desarrollo teórico-práctico)

Con la agenda ya guardada, probar y observar, restaurando después cada cambio:

1. Quitar `ensure_ascii=False`, guardar con un nombre que tenga tilde o ñ y abrir el archivo: aparece `\u00f1`. Restaurar.
2. Quitar `indent=2`: todo queda en una sola línea. Restaurar.
3. Quitar `encoding="utf-8"` del `open` de escritura: la relectura con `encoding="utf-8"` puede rechazar el archivo. Restaurar.

**Pista:** cada observación se anota en una línea: qué cambió en el archivo y por qué el canon pide esa opción.

### Etapa 3 — Archivo dañado (en la actividad complementaria)

Con `agenda.json` abierto en VS Code, borrar una coma o una llave y volver a correr el programa: aparece `json.JSONDecodeError`. Incorporar el manejo canónico (aviso y `sys.exit(1)`), reparar el archivo corriendo un alta y volver a probar: ahora el programa avisa y termina sin `traceback`.

**Pista:** el `try`/`except json.JSONDecodeError` va alrededor de la llamada a `cargar_contactos()` en `main`.

## Consolidación y cierre

- Puesta en común: comparar `agenda.csv` y `agenda.json` lado a lado (mismo dato, dos formatos).
- Verificación de los tres caminos: primera corrida sin archivo (arranca vacía), corrida normal (carga y guarda) y archivo dañado (aviso y salida ordenada).
- Verificar que ningún `traceback` aparezca en los casos previstos.
- Rutina de Git de cierre: `git add .`, `git commit -m "u3: agenda persistida en json"` y `git push`.
- Próximo encuentro: con tres formatos sobre la mesa (TXT de U2, CSV y JSON), el encuentro 24 los compara y elige, y agrega búsquedas y filtros combinados sobre la colección.

## Actividad complementaria

- Terminar la Etapa 3 (manejo de `json.JSONDecodeError` verificado dos veces).
- Desafío: agregar al menú una opción que muestre la cantidad de contactos guardados leyéndolos del archivo (no de la memoria).
- Desafío: detectar y avisar contactos con el mismo correo al dar de alta.

## Errores comunes

| Error | Causa | Corrección |
|---|---|---|
| `\u00f1` en el archivo | `json.dump` sin `ensure_ascii=False` | Siempre `json.dump(datos, f, ensure_ascii=False, indent=2)`. |
| Archivo en una sola línea, difícil de leer | `json.dump` sin `indent=2` | Agregar `indent=2`: no cambia el dato, cambia la legibilidad. |
| `json.JSONDecodeError` al cargar | Se apunta a un archivo que no es JSON (por ejemplo, el CSV anterior) | Revisar `RUTA_JSON`; cada formato usa su propio archivo. |
| Cambios perdidos al salir | Alta en memoria sin guardar antes de `break` | Guardar en cada alta y al salir, como en el encuentro 22. |
| `NameError: sys is not defined` | Falta `import sys` cuando se usa `sys.exit(1)` | Importar solo lo que se usa: `json` y, si se usa, `sys`. |
| `except:` desnudo alrededor del `json.load` | Intento de atrapar «cualquier cosa» | `except FileNotFoundError` y `except json.JSONDecodeError`, cada uno con su manejo. |
