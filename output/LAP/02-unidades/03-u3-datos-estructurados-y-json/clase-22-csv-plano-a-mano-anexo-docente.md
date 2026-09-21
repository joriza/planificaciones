# Encuentro 22 — Anexo docente: CSV plano a mano

## Resumen de la clase

| Bloque | Duración | Actividad |
|---|---|---|
| Apertura y motivación | 10 min | Correr la agenda en memoria de E21, cortarla y reabrirla: los datos desaparecen. Presentar la persistencia en CSV a mano. |
| Desarrollo teórico-práctico | 60 min | Teoría mínima con `csv_basico.py` (20 min). Etapa 1 (guardar) y Etapa 2 (cargar) del ejercicio `agenda_csv.py` (40 min). |
| Consolidación y cierre | 20 min | Verificación de los dos caminos (caso normal y archivo ausente), inspección de `agenda.csv` con `type`, commit de cierre. |
| Actividad complementaria | 30 min | Etapa 3 (integración del menú: cargar al inicio, guardar en cada alta y al salir) y desafíos: nombre duplicado y contador. |

## Preparación previa

- VS Code y terminal abiertos; `python --version` en 3.11.
- Tener `agenda_dict.py` del encuentro 21 terminado: es el punto de partida del ejercicio.
- Tener un `agenda.csv` de muestra proyectable para mostrar el formato antes de programarlo.
- Tener a mano (sin correr en clase) un CSV editado con una línea vacía para mostrar el filtro.

## Solución completa del ejemplo

`csv_basico.py`:

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

## Soluciones del ejercicio progresivo

### Etapa 1 — Guardar

Las funciones de la demo se copian a `agenda_csv.py` sin cambios. En `main`, después de definir la lista de ejemplo:

```python
    guardar_contactos(contactos)
    print("Agenda guardada en", RUTA_CSV)
```

Verificación esperada en la terminal: `type agenda.csv` muestra dos líneas, una por contacto, sin espacios luego de las comas.

### Etapa 2 — Cargar

`cargar_contactos()` de la demo. Ciclo de prueba guiado:

1. Primera corrida con `agenda.csv` ausente: `cargar_contactos()` devuelve `[]` por el `except FileNotFoundError` y el listado avisa «No hay contactos cargados.».
2. Corrida con archivo: los dos contactos reaparecen como dicts.
3. Editar `agenda.csv` agregando una línea vacía al final: el filtro la descarta.

### Etapa 3 — Integración del menú

`main()` completo de la agenda persistente:

```python
def main():
    # Punto de entrada: carga al inicio, guarda en cada alta y al salir.
    contactos = cargar_contactos()
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

### Desafíos de la actividad complementaria

Nombre duplicado — en la opción 1, antes del alta:

```python
            nombre = input("Nombre: ").strip()
            if buscar_contacto(contactos, nombre) is not None:
                print("Ya existe un contacto con ese nombre.")
            else:
                contactos.append(pedir_contacto())
                guardar_contactos(contactos)
                print("Contacto agregado y guardado.")
```

Contador — nueva opción de menú:

```python
        elif opcion == 4:
            print("Contactos guardados:", len(contactos))
```

## Errores anticipados y corrección

| Error esperado | Dónde aparece | Corrección en clase |
|---|---|---|
| Campos con espacios sobrantes | Etapa 2, si falta el `.strip()` de un campo | Mostrar el registro con `print(contacto)` y la comparación de nombres fallando; agregar `.strip()`. |
| Registro fantasma de un campo | Archivo editado a mano con línea vacía | Recordar `"".split(",")` devuelve `['']`; el filtro `continue` lo descarta. |
| Agenda que «pierde» el último alta | Guardar solo al salir y cortar con `Ctrl+C` antes | Guardar en cada alta (Etapa 3) y al salir; mostrar que `"w"` reescribe todo desde memoria. |
| `UnicodeDecodeError` al releer | `open()` sin `encoding="utf-8"` | Verificar con `locale.getpreferredencoding()` la codificación del sistema; volver al canon. |
| `IndexError` por línea incompleta | Alumno que edita el CSV a mano y borra un campo | El programa asume tres campos por diseño; completar la línea o regenerar el archivo con el programa. |
| Teléfono convertido a número por prolijidad | Alta con `int(telefono)` | El teléfono con `0` inicial pierde el cero como `int` y no se hacen cuentas con él: es texto. |
| Doble guardado innecesario (`"a"` después de `"w"`) | Confusión de modos al integrar | `"a"` duplicaría líneas: la estrategia del curso es siempre reescribir la colección completa con `"w"`. |

## Observación en el aula

- Verificar que `cargar_contactos()` y `guardar_contactos()` usen la constante `RUTA_CSV` (ruta relativa, junto al `.py`).
- Verificar que cada `open` tenga su `with` y su `encoding="utf-8"`.
- Verificar que el caso «archivo ausente» se probó de verdad: borrar el archivo y correr, no solo leer el código.
- Los mensajes visibles en español y sin tildes dentro del código; la prosa del documento, con tildes.

## Preparación del próximo encuentro

- Conservar `agenda.csv`: el encuentro 23 migra esa misma agenda a JSON.
- Tener un `agenda.json` de muestra (producido con `json.dump`) para proyectar el formato destino.
