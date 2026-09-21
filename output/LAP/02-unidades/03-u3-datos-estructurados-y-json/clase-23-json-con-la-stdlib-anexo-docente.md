# Encuentro 23 — Anexo docente: JSON con la stdlib

## Resumen de la clase

| Bloque | Duración | Actividad |
|---|---|---|
| Apertura y motivación | 10 min | Abrir `agenda.csv` de E22 y mostrar sus límites: campos por posición, todo texto, corte y limpieza línea por línea. |
| Desarrollo teórico-práctico | 60 min | Teoría mínima con `json_basico.py` (20 min). Etapa 1 (migrar la persistencia a JSON) y Etapa 2 (experimento sobre `ensure_ascii`, `indent` y `encoding`) (40 min). |
| Consolidación y cierre | 20 min | Comparación CSV vs JSON lado a lado, verificación de los tres caminos (sin archivo, normal, dañado), commit de cierre. |
| Actividad complementaria | 30 min | Etapa 3 (archivo dañado con aviso y `sys.exit(1)`) y desafíos: contador desde el archivo y detección de correos duplicados. |

## Preparación previa

- VS Code y terminal abiertos; `python --version` en 3.11.
- Conservar el `agenda.csv` del encuentro 22: es el punto de comparación de la apertura y la puesta en común.
- Tener `agenda_json.py` resuelto (versión de este anexo) para proyectar.
- Tener un `agenda.json` dañado de muestra (coma borrada) por si algún grupo no logra romper el propio.

## Solución completa del ejemplo

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

## Soluciones del ejercicio progresivo

### Etapa 1 — Migrar la persistencia

`agenda_json.py` reutiliza íntegras las funciones del encuentro 22 (`pedir_contacto`, `listar_contactos`, `buscar_contacto`) y reemplaza solo la persistencia:

```python
import json
import sys

RUTA_JSON = "agenda.json"

def cargar_contactos():
    # Devuelve la lista de contactos guardada en el archivo JSON.
    try:
        with open(RUTA_JSON, "r", encoding="utf-8") as f:
            return json.load(f)
    except FileNotFoundError:
        # Primera corrida: todavia no existe el archivo de datos.
        return []

def guardar_contactos(contactos):
    # Sobrescribe el archivo con la coleccion completa.
    with open(RUTA_JSON, "w", encoding="utf-8") as f:
        json.dump(contactos, f, ensure_ascii=False, indent=2)
```

`main()` con el manejo del archivo dañado (se agrega formalmente en la Etapa 3):

```python
def main():
    # Punto de entrada: carga con proteccion y menu completo.
    try:
        contactos = cargar_contactos()
    except json.JSONDecodeError:
        # El archivo existe pero su contenido no es JSON valido.
        print("El archivo de datos esta corrupto.")
        sys.exit(1)
    while True:
        print("1) Alta  2) Listado  3) Buscar  0) Salir")
        texto_opcion = input("Elija una opcion: ").strip()
        try:
            opcion = int(texto_opcion)
        except ValueError:
            print("Debe ingresar un numero valido.")
            continue
        if opcion == 1:
            contactos.append(pedir_contacto())
            guardar_contactos(contactos)
            print("Contacto agregado y guardado.")
        elif opcion == 2:
            listar_contactos(contactos)
        elif opcion == 3:
            nombre = input("Nombre a buscar: ").strip()
            contacto = buscar_contacto(contactos, nombre)
            if contacto is None:
                print("No existe un contacto con ese nombre.")
            else:
                print(contacto["nombre"], "-", contacto["telefono"], "-", contacto["correo"])
        elif opcion == 0:
            guardar_contactos(contactos)
            print("Cambios guardados. Hasta pronto.")
            break
        else:
            print("Opcion no valida.")

if __name__ == "__main__":
    main()
```

### Etapa 2 — Experimento dirigido (guion de observaciones esperadas)

| Prueba | Qué se observa en `agenda.json` | Conclusión para el grupo |
|---|---|---|
| Sin `ensure_ascii=False` | Un nombre con ñ o tilde queda como `\u00f1` | JSON válido, pero ilegible para una persona; el canon pide `ensure_ascii=False`. |
| Sin `indent=2` | Todo el archivo en una línea | El dato es el mismo; la legibilidad se pierde; el canon pide `indent=2`. |
| Sin `encoding="utf-8"` al escribir | La relectura con `encoding="utf-8"` puede lanzar `UnicodeDecodeError` | El `encoding` es obligatorio en cada `open`, escritura y lectura. |

### Etapa 3 — Archivo dañado

Secuencia de clase: borrar una coma de `agenda.json` → correr → observar el `json.JSONDecodeError` sin manejo → agregar el `try`/`except json.JSONDecodeError` de `main` → correr de nuevo (aviso y salida ordenada, sin `traceback`) → reparar dando de alta un contacto (el programa reescribe el archivo completo) → correr una vez más (funciona).

### Desafíos de la actividad complementaria

Contador leyendo del archivo:

```python
        elif opcion == 4:
            guardados = cargar_contactos()
            print("Contactos guardados en el archivo:", len(guardados))
```

Correo duplicado — antes del alta:

```python
            nuevo = pedir_contacto()
            existe = False
            for contacto in contactos:
                if contacto["correo"].lower() == nuevo["correo"].lower():
                    existe = True
            if existe:
                print("Ya existe un contacto con ese correo.")
            else:
                contactos.append(nuevo)
                guardar_contactos(contactos)
                print("Contacto agregado y guardado.")
```

## Errores anticipados y corrección

| Error esperado | Dónde aparece | Corrección en clase |
|---|---|---|
| `\u00f1` en el archivo | Etapa 2, prueba sin `ensure_ascii=False` | Es el comportamiento por defecto de `json.dump`; restituir el canon y volver a guardar. |
| `AttributeError: 'list' object has no attribute 'keys'` o confusión list/dict | Alumno que carga y trata la colección como un único dict | `json.load` devuelve exactamente lo que se guardó: la lista completa de dicts. |
| `json.JSONDecodeError` persistente tras reparar | El programa sigue leyendo un archivo viejo o mal cerrado | Revisar que el editor guardó el archivo; regenerar el JSON con un alta del propio programa. |
| `sys` no importado con `sys.exit(1)` en uso | `NameError` en la Etapa 3 | Importar `sys` junto con `json` en el encabezado. |
| `try`/`except` desnudo alrededor de la carga | Intento de cubrir los dos errores con un solo `except:` | Dos excepciones específicas: `FileNotFoundError` (devuelve `[]`) y `json.JSONDecodeError` (avisa y sale con 1). |
| Guardar dentro del `try` de lectura | Mezcla de responsabilidades en `main` | La protección cubre la carga; el guardado va en las acciones del menú, como en E22. |

## Observación en el aula

- Verificar que `agenda.json` se abra en VS Code y sea legible para una persona (tildes reales, sangría de 2).
- Verificar los tres caminos probados de verdad: sin archivo, archivo sano, archivo dañado.
- Verificar que el mensaje de archivo dañado llega por `print` y el proceso termina con código 1 (no hay `traceback`).
- Recordar el commit de cierre con mensaje sin tildes.

## Preparación del próximo encuentro

- Conservar `agenda.json` y, si está, el `agenda.txt` de la Unidad 2: el encuentro 24 compara los tres formatos y migra.
- Tener lista la tabla comparativa TXT/CSV/JSON para la apertura.
