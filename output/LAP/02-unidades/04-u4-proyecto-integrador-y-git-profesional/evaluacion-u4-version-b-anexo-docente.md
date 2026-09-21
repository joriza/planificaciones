# Anexo docente — Evaluación de la Unidad 4, Versión B (gestor de pedidos)

> Documento de uso exclusivo del docente: no entregar a alumnos ni a administración.

## Encuadre docente

La versión B aplica la estructura del ejemplo guiado de la unidad (gestor de préstamos) al dominio de pedidos de insumos: registro de cuatro claves con fecha ISO y campo booleano, menú de cinco opciones con marcación de estado, persistencia JSON con carga segura y flujo Git profesional completo. La evaluación valora el estado final del repositorio y la defensa individual sobre el guion de cuatro puntos.

## Solución completa (código canon)

```python
import json
import sys

RUTA_DATOS = "pedidos.json"

TEXTO_MENU = """
=== Gestor de pedidos de insumos ===
1 - Registrar un pedido
2 - Listar pedidos
3 - Buscar por producto
4 - Registrar recepcion
0 - Salir
"""

def cargar_registros():
    # Devolver la coleccion guardada en el archivo JSON.
    try:
        with open(RUTA_DATOS, "r", encoding="utf-8") as f:
            return json.load(f)
    except FileNotFoundError:
        # Primera corrida: todavia no existe el archivo de datos.
        return []
    except json.JSONDecodeError:
        # El archivo esta danado: avisar y terminar con codigo 1.
        print("El archivo de datos esta danado")
        sys.exit(1)

def guardar_registros(registros):
    # Sobrescribir el archivo con la coleccion completa.
    with open(RUTA_DATOS, "w", encoding="utf-8") as f:
        json.dump(registros, f, ensure_ascii=False, indent=2)

def pedir_campo(mensaje):
    # Pedir un texto obligatorio y repetir mientras quede vacio.
    while True:
        texto = input(mensaje).strip()
        if texto != "":
            return texto
        print("El campo no puede quedar vacio")

def alta(registros):
    # Pedir los datos del pedido y agregar el registro.
    registro = {}
    # Pedir cada campo obligatorio
    registro["producto"] = pedir_campo("Producto: ")
    registro["sector"] = pedir_campo("Sector: ")
    registro["fecha"] = pedir_campo("Fecha (AAAA-MM-DD): ")
    # Todo pedido arranca sin recibir
    registro["recibido"] = False
    registros.append(registro)
    # Guardar la coleccion completa tras cada alta
    guardar_registros(registros)
    print("Pedido registrado")

def mostrar_registro(registro, posicion):
    # Mostrar un registro con su posicion y su estado de recepcion.
    if registro["recibido"]:
        estado = "Si"
    else:
        estado = "No"
    print(posicion, "-", registro["producto"], "|", registro["sector"], "|", registro["fecha"], "| Recibido:", estado)

def listar(registros):
    # Mostrar el listado numerado de pedidos.
    if len(registros) == 0:
        print("No hay pedidos registrados")
        return
    for i in range(len(registros)):
        mostrar_registro(registros[i], i + 1)

def buscar(registros):
    # Buscar pedidos por producto sin distinguir mayusculas.
    buscado = pedir_campo("Producto a buscar: ").lower()
    encontrado = False
    for i in range(len(registros)):
        registro = registros[i]
        if registro["producto"].lower() == buscado:
            mostrar_registro(registro, i + 1)
            encontrado = True
    if not encontrado:
        print("No hay pedidos de ese producto")

def registrar_recepcion(registros):
    # Marcar como recibido el primer pedido pendiente del producto indicado.
    buscado = pedir_campo("Producto: ").lower()
    for i in range(len(registros)):
        registro = registros[i]
        if registro["producto"].lower() == buscado and not registro["recibido"]:
            # Marcar el pedido como recibido y guardar el cambio
            registro["recibido"] = True
            guardar_registros(registros)
            print("Recepcion registrada")
            return
    print("No hay pedidos pendientes de ese producto")

def main():
    # Cargar la coleccion al abrir el programa
    registros = cargar_registros()
    # Repetir el menu hasta que se elija salir
    while True:
        # Mostrar el menu y pedir la opcion convertida a numero
        print(TEXTO_MENU)
        while True:
            try:
                opcion = int(input("Elija una opcion: "))
                break
            except ValueError:
                print("Debe ingresar un numero valido")
        if opcion == 1:
            alta(registros)
        elif opcion == 2:
            listar(registros)
        elif opcion == 3:
            buscar(registros)
        elif opcion == 4:
            registrar_recepcion(registros)
        elif opcion == 0:
            # Guardar la coleccion completa al salir
            guardar_registros(registros)
            break
        else:
            print("Opcion invalida")
    print("Hasta luego")


if __name__ == "__main__":
    main()
```

## Contenido esperado de `pedidos.json` tras un alta y una recepción

```json
[
  {
    "producto": "tornillo m8",
    "sector": "taller",
    "fecha": "2025-06-12",
    "recibido": true
  }
]
```

Con `ensure_ascii=False` e `indent=2`: caracteres reales en UTF-8 y archivo multi-línea legible.

## Criterios de corrección (100 puntos)

| Criterio | Puntos | Logro completo | Recorte sugerido |
|---|---|---|---|
| Funcionalidad del integrador | 25 | Cinco opciones operativas; registro con `producto`/`sector`/`fecha`/`recibido`; recepción que marca y guarda | Opción sin funcionar: 15; recepción sin persistir: 18 |
| Persistencia JSON y errores | 20 | Tres caminos de carga (vacío/normal/dañado + `sys.exit(1)`); campos vacíos rechazados; guardado por alta y al salir | Falta un camino: 12; sin validación de vacíos: 12 |
| Git profesional | 25 | Mínimo cinco issues cerrados, cinco PR revisados y mergeados, `main` protegida, README probado | Menos de cinco PR: 15; README sin probar: 12; `main` sin proteger: 10 |
| Calidad del código | 15 | Canon completo: esqueleto, `try/except ValueError` en el menú, comentarios por acción, sin tildes | Tildes o comentarios faltantes: 8; lógica suelta: 4 |
| Entrega final | 15 | `main` al día, push verificado, sin issues abiertos, sin archivos extra | Pendientes locales: 8; archivos de más: 8 |

## Defensa: preguntas sugeridas y respuestas esperadas

| Pregunta | Respuesta esperada |
|---|---|
| ¿Qué opción del menú resuelve el problema central y cómo? | La 4: marca la recepción sobre el registro existente y guarda; sin ella, el estado quedaría solo en memoria. |
| ¿Qué recibe y qué devuelve `pedir_campo`? | Recibe el mensaje a mostrar; devuelve el texto limpio (`strip`) y no nulo: repite hasta obtener un campo con contenido. |
| ¿Qué pasa si `pedidos.json` está dañado? | `json.JSONDecodeError`: aviso y `sys.exit(1)`; no continúa para no pisar datos irrecuperables. |
| ¿Por qué la fecha se guarda como texto ISO? | `AAAA-MM-DD` se compara y ordena bien como string, sin `datetime` en el curso. |
| ¿Qué muestra el PR que elige del historial? | La rama `feature/*`, los cambios revisados y el comentario de revisión que precedió al merge. |

## Errores previsibles

1. Alta sin validación de campos vacíos: el registro queda con claves vacías y rompe las búsquedas.
2. Recepción que no guarda: el estado cambia en memoria pero el JSON queda con `recibido: false`.
3. `json.dump` sin `ensure_ascii=False`: `\u00f1` en lugar de ñ.
4. Merge directo a `main` sin PR: el historial deja de ser solo merges de PR.
5. README con comandos no probados: la instrucción publicada falla al ejecutarse desde la raíz.
6. Issues abiertos al entregar: la entrega exige el tablero cerrado.

## Equivalencia con la versión A

| Elemento | Versión A (entregas) | Versión B (pedidos) |
|---|---|---|
| Registro (4 claves) | `alumno`, `trabajo`, `fecha`, `corregido` | `producto`, `sector`, `fecha`, `recibido` |
| Estado booleano | `corregido` (`False` en el alta) | `recibido` (`False` en el alta) |
| Marcación (opción 4) | Registrar corrección | Registrar recepción |
| Búsqueda | Por alumno, sin mayúsculas distintivas | Por producto, sin mayúsculas distintivas |
| Flujo Git | Mismos requisitos: 5 issues, 5 PR, `main` protegida, README | Mismos requisitos |
| Carga segura | `[]` / aviso + `sys.exit(1)` | `[]` / aviso + `sys.exit(1)` |

Mismo programa, mismos requisitos técnicos y de Git, misma rúbrica: solo cambia el dominio de los datos.
