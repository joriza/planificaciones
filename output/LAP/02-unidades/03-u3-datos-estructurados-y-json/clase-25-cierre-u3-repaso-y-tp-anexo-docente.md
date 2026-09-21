# Encuentro 25 — Anexo docente: Cierre U3: repaso y TP

## Resumen de la clase

| Bloque | Duración | Actividad |
|---|---|---|
| Apertura y motivación | 10 min | Repaso rápido dirigido: dict vs lista de campos, las dos excepciones de la carga JSON, `ensure_ascii=False` e `indent=2`. Presentación de la consigna del TP-U3. |
| Desarrollo teórico-práctico | 70 min | Etapa 1 (base persistente) y Etapa 2 (menú completo) del TP-U3 en la carpeta `tp-u3/`, con verificación de los tres caminos de carga. |
| Consolidación y cierre | 25 min | Etapa 3: filtro combinado y exportación a `resultado.json`. Lista de verificación. Entrega por GitHub (`add`, `commit`, `push`). |
| Actividad complementaria | 15 min | Extensiones para quienes entregaron: contador por dominio y aviso de correo duplicado. |

## Preparación previa

- VS Code y terminal abiertos; `python --version` en 3.11.
- Tener la solución de referencia del TP-U3 (este anexo) para proyectar en la puesta en común.
- Tener un `agenda.json` dañado de muestra para la verificación cruzada entre grupos.
- Consigna del TP proyectada o impresa (está en el documento de la clase).

## Solución de referencia del TP-U3

`tp-u3/agenda.py`:

```python
# TP-U3: agenda de contactos con persistencia en JSON.
# Eleccion de formato: JSON guarda la coleccion completa con claves con
# nombre, conserva la estructura de memoria y se carga con json.load.

import json
import sys

RUTA_AGENDA = "agenda.json"
RUTA_RESULTADO = "resultado.json"

def cargar_contactos():
    # Devuelve la lista de contactos guardada en el archivo JSON.
    try:
        with open(RUTA_AGENDA, "r", encoding="utf-8") as f:
            return json.load(f)
    except FileNotFoundError:
        # Primera corrida: todavia no existe el archivo de datos.
        return []

def guardar_contactos(contactos):
    # Sobrescribe el archivo con la coleccion completa.
    with open(RUTA_AGENDA, "w", encoding="utf-8") as f:
        json.dump(contactos, f, ensure_ascii=False, indent=2)

def pedir_contacto():
    # Pide los datos por teclado y devuelve el registro como dict.
    while True:
        nombre = input("Nombre: ").strip()
        if nombre != "":
            break
        print("El nombre no puede quedar vacio.")
    telefono = input("Telefono: ").strip()
    correo = input("Correo: ").strip()
    contacto = {"nombre": nombre, "telefono": telefono, "correo": correo}
    return contacto

def listar_contactos(contactos):
    # Muestra todos los contactos numerados.
    if len(contactos) == 0:
        print("No hay contactos cargados.")
        return
    numero = 1
    for contacto in contactos:
        print(numero, "-", contacto["nombre"], "-", contacto["telefono"], "-", contacto["correo"])
        numero = numero + 1

def buscar_contacto(contactos, nombre):
    # Devuelve el contacto cuyo nombre coincide, o None si no existe.
    for contacto in contactos:
        if contacto["nombre"].lower() == nombre.lower():
            return contacto
    return None

def filtrar_por_nombre(contactos, texto):
    # Devuelve los contactos cuyo nombre contiene el texto.
    resultado = []
    texto = texto.lower()
    for contacto in contactos:
        if texto in contacto["nombre"].lower():
            resultado.append(contacto)
    return resultado

def filtrar_por_dominio(contactos, dominio):
    # Devuelve los contactos cuyo correo termina en el dominio.
    resultado = []
    dominio = dominio.lower()
    for contacto in contactos:
        if contacto["correo"].lower().endswith(dominio):
            resultado.append(contacto)
    return resultado

def filtrar_combinado(contactos, texto, dominio):
    # Devuelve los contactos que cumplen las dos condiciones.
    resultado = []
    texto = texto.lower()
    dominio = dominio.lower()
    for contacto in contactos:
        nombre_coincide = texto in contacto["nombre"].lower()
        correo_coincide = contacto["correo"].lower().endswith(dominio)
        if nombre_coincide and correo_coincide:
            resultado.append(contacto)
    return resultado

def exportar_resultado(encontrados):
    # Guarda el resultado del filtro sin tocar la agenda.
    with open(RUTA_RESULTADO, "w", encoding="utf-8") as f:
        json.dump(encontrados, f, ensure_ascii=False, indent=2)
    print("Resultado exportado a", RUTA_RESULTADO)

def opcion_filtro(contactos):
    # Pide los criterios, filtra, muestra y exporta el resultado.
    texto = input("Texto en el nombre (Enter = cualquiera): ").strip()
    dominio = input("Dominio del correo (Enter = cualquiera): ").strip()
    if texto == "" and dominio == "":
        print("Debe ingresar al menos un criterio.")
        return
    if texto == "":
        encontrados = filtrar_por_dominio(contactos, dominio)
    elif dominio == "":
        encontrados = filtrar_por_nombre(contactos, texto)
    else:
        encontrados = filtrar_combinado(contactos, texto, dominio)
    print("Coincidencias:", len(encontrados))
    listar_contactos(encontrados)
    exportar_resultado(encontrados)

def main():
    # Punto de entrada: carga protegida y menu completo.
    try:
        contactos = cargar_contactos()
    except json.JSONDecodeError:
        # El archivo existe pero su contenido no es JSON valido.
        print("El archivo de datos esta corrupto.")
        sys.exit(1)
    while True:
        print("1) Alta  2) Listado  3) Buscar  4) Filtrar  0) Salir")
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
        elif opcion == 4:
            opcion_filtro(contactos)
        elif opcion == 0:
            guardar_contactos(contactos)
            print("Cambios guardados. Hasta pronto.")
            break
        else:
            print("Opcion no valida.")

if __name__ == "__main__":
    main()
```

Archivo de datos esperado, creado por el propio programa (`tp-u3/agenda.json`):

```json
[
  {
    "nombre": "Ana",
    "telefono": "2664-555123",
    "correo": "ana@gmail.com"
  }
]
```

## Rúbrica de corrección del TP-U3

| Criterio | Qué se observa |
|---|---|
| Ejecución limpia | `python agenda.py` corre sin `traceback` en el caso normal, en la primera corrida (sin `agenda.json`) y con el archivo dañado. |
| Persistencia canónica | `with open(..., encoding="utf-8")` en toda lectura y escritura; `json.dump(..., ensure_ascii=False, indent=2)`; `agenda.json` y `resultado.json` creados por el programa. |
| Errores previstos | `FileNotFoundError` → lista vacía; `json.JSONDecodeError` → aviso y `sys.exit(1)`; `except ValueError` en la opción del menú; ninguna excepción desnuda. |
| Modelo de datos | Lista de dicts con claves `nombre`, `telefono`, `correo` consistentes en todo el archivo. |
| Funcionalidad | Alta con nombre obligatorio, listado numerado, búsqueda sin distinguir mayúsculas, filtro combinado con exportación, guardado en cada alta y al salir. |
| Estilo del canon | Esqueleto fijo (imports, constantes, funciones, `main`, guard), un comentario por acción, identificadores y mensajes en español sin tildes, sin clases ni librerías externas. |
| Entrega | Carpeta `tp-u3/` en el repositorio del grupo, commits con mensaje claro sin tildes, `push` verificado en GitHub. |

## Guion de defensa individual

Preguntas de verificación (una por eje, con la respuesta esperada en resumen):

1. ¿Por qué el contacto es un dict y no una lista de valores? — Los campos viajan con nombre; agregar un campo no rompe índices.
2. ¿Qué pasa la primera vez que corre el programa sin `agenda.json`? — `FileNotFoundError` atrapado: arranca con una lista vacía.
3. ¿Qué hace el programa si `agenda.json` está dañado? — Avisa con `print` y termina con `sys.exit(1)`; nunca muestra `traceback`.
4. ¿Por qué `ensure_ascii=False` e `indent=2`? — Tildes y ñ reales en UTF-8 y archivo multilínea legible; sin ellas, `\u00f1` y una sola línea.
5. ¿Dónde convierte el programa los tipos que entran por teclado? — Solo la opción del menú se convierte con `int()` dentro de `try`/`except ValueError`; los campos del contacto son texto.
6. ¿Por qué el filtro exporta a `resultado.json` y no a `agenda.json`? — El filtro lee; la agenda es el archivo de datos de entrada y no se pisa con un resultado parcial.

## Errores anticipados y corrección

| Error esperado | Dónde aparece | Corrección en clase |
|---|---|---|
| Commit sin `push` | Entrega | Verificar en GitHub antes de irse; en la devolución del 27, revisar el historial remoto. |
| `agenda.json` armado a mano con datos que el programa no escribe | Entrega | Borrar y regenerar corriendo el programa; los archivos de datos los crea y lee el propio `.py`. |
| `traceback` al dañar el archivo | Etapa 1, verificación | Falta el `except json.JSONDecodeError` alrededor de la carga en `main`. |
| El filtro pisa la agenda | Etapa 3 | Constantes separadas `RUTA_AGENDA` y `RUTA_RESULTADO`; verificar ambos archivos con `type`. |
| Tildes en mensajes o comentarios | Todo el archivo | Pasar el corrector: el código sin tildes ni eñes; la prosa de los documentos, con tildes. |
| Validación del nombre fuera de `pedir_contacto` | Etapa 2 | La regla vive en una sola función y el resto del programa la reutiliza. |
| Guardado solo al salir | Etapa 2 | Un corte con `Ctrl+C` pierde las altas: guardar en cada alta y al salir. |

## Observación en el aula

- Acompañar la entrega: cada grupo muestra el `push` en GitHub antes de cerrar la máquina.
- Registrar quiénes entregaron y quiénes quedan pendientes, para la devolución del encuentro 27.
- Las extensiones de la actividad complementaria no son requisito del TP: no bloquean la entrega.
