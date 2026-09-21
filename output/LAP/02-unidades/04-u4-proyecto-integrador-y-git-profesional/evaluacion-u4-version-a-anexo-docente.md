# Anexo docente — Evaluación de la Unidad 4, Versión A (gestor de entregas)

> Documento de uso exclusivo del docente: no entregar a alumnos ni a administración.

## Encuadre docente

La versión A aplica la estructura del ejemplo guiado de la unidad (gestor de préstamos) al dominio de entregas de trabajos prácticos: registro de cuatro claves con fecha ISO y campo booleano, menú de cinco opciones con marcación de estado, persistencia JSON con carga segura y flujo Git profesional completo. La evaluación valora el estado final del repositorio y la defensa individual sobre el guion de cuatro puntos.

## Solución completa (código canon)

```python
import json
import sys

RUTA_DATOS = "entregas.json"

TEXTO_MENU = """
=== Gestor de entregas de trabajos practicos ===
1 - Registrar una entrega
2 - Listar entregas
3 - Buscar por alumno
4 - Registrar correccion
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
    # Pedir los datos de la entrega y agregar el registro.
    registro = {}
    # Pedir cada campo obligatorio
    registro["alumno"] = pedir_campo("Alumno: ")
    registro["trabajo"] = pedir_campo("Trabajo: ")
    registro["fecha"] = pedir_campo("Fecha (AAAA-MM-DD): ")
    # Toda entrega arranca sin corregir
    registro["corregido"] = False
    registros.append(registro)
    # Guardar la coleccion completa tras cada alta
    guardar_registros(registros)
    print("Entrega registrada")

def mostrar_registro(registro, posicion):
    # Mostrar un registro con su posicion y su estado de correccion.
    if registro["corregido"]:
        estado = "Si"
    else:
        estado = "No"
    print(posicion, "-", registro["alumno"], "|", registro["trabajo"], "|", registro["fecha"], "| Corregido:", estado)

def listar(registros):
    # Mostrar el listado numerado de entregas.
    if len(registros) == 0:
        print("No hay entregas registradas")
        return
    for i in range(len(registros)):
        mostrar_registro(registros[i], i + 1)

def buscar(registros):
    # Buscar entregas por alumno sin distinguir mayusculas.
    buscado = pedir_campo("Alumno a buscar: ").lower()
    encontrado = False
    for i in range(len(registros)):
        registro = registros[i]
        if registro["alumno"].lower() == buscado:
            mostrar_registro(registro, i + 1)
            encontrado = True
    if not encontrado:
        print("No hay entregas de ese alumno")

def registrar_correccion(registros):
    # Marcar como corregida la primera entrega sin corregir del alumno indicado.
    buscado = pedir_campo("Alumno: ").lower()
    for i in range(len(registros)):
        registro = registros[i]
        if registro["alumno"].lower() == buscado and not registro["corregido"]:
            # Marcar la entrega como corregida y guardar el cambio
            registro["corregido"] = True
            guardar_registros(registros)
            print("Correccion registrada")
            return
    print("No hay entregas sin corregir de ese alumno")

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
            registrar_correccion(registros)
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

## Contenido esperado de `entregas.json` tras un alta y una corrección

```json
[
  {
    "alumno": "ana perez",
    "trabajo": "tp-u2",
    "fecha": "2025-06-12",
    "corregido": true
  }
]
```

Con `ensure_ascii=False` e `indent=2`: caracteres reales en UTF-8 y archivo multi-línea legible.

## Criterios de corrección (100 puntos)

| Criterio | Puntos | Logro completo | Recorte sugerido |
|---|---|---|---|
| Funcionalidad del integrador | 25 | Cinco opciones operativas; registro con `alumno`/`trabajo`/`fecha`/`corregido`; corrección que marca y guarda | Opción sin funcionar: 15; corrección sin persistir: 18 |
| Persistencia JSON y errores | 20 | Tres caminos de carga (vacío/normal/dañado + `sys.exit(1)`); campos vacíos rechazados; guardado por alta y al salir | Falta un camino: 12; sin validación de vacíos: 12 |
| Git profesional | 25 | Mínimo cinco issues cerrados, cinco PR revisados y mergeados, `main` protegida, README probado | Menos de cinco PR: 15; README sin probar: 12; `main` sin proteger: 10 |
| Calidad del código | 15 | Canon completo: esqueleto, `try/except ValueError` en el menú, comentarios por acción, sin tildes | Tildes o comentarios faltantes: 8; lógica suelta: 4 |
| Entrega final | 15 | `main` al día, push verificado, sin issues abiertos, sin archivos extra | Pendientes locales: 8; archivos de más: 8 |

## Defensa: preguntas sugeridas y respuestas esperadas

| Pregunta | Respuesta esperada |
|---|---|
| ¿Qué opción del menú resuelve el problema central y cómo? | La 4: marca la corrección sobre el registro existente y guarda; sin ella, el estado quedaría solo en memoria. |
| ¿Qué recibe y qué devuelve `pedir_campo`? | Recibe el mensaje a mostrar; devuelve el texto limpio (`strip`) y no nulo: repite hasta obtener un campo con contenido. |
| ¿Qué pasa si `entregas.json` está dañado? | `json.JSONDecodeError`: aviso y `sys.exit(1)`; no continúa para no pisar datos irrecuperables. |
| ¿Por qué la fecha se guarda como texto ISO? | `AAAA-MM-DD` se compara y ordena bien como string, sin `datetime` en el curso. |
| ¿Qué muestra el PR que elige del historial? | La rama `feature/*`, los cambios revisados y el comentario de revisión que precedió al merge. |

## Errores previsibles

1. Alta sin validación de campos vacíos: el registro queda con claves vacías y rompe las búsquedas.
2. Corrección que no guarda: el estado cambia en memoria pero el JSON queda con `corregido: false`.
3. `json.dump` sin `ensure_ascii=False`: `\u00f1` en lugar de ñ.
4. Merge directo a `main` sin PR: el historial deja de ser solo merges de PR.
5. README con comandos no probados: la instrucción publicada falla al ejecutarse desde la raíz.
6. Issues abiertos al entregar: la entrega exige el tablero cerrado.

## Equivalencia con la versión B

| Elemento | Versión A (entregas) | Versión B (pedidos) |
|---|---|---|
| Registro (4 claves) | `alumno`, `trabajo`, `fecha`, `corregido` | `producto`, `sector`, `fecha`, `recibido` |
| Estado booleano | `corregido` (`False` en el alta) | `recibido` (`False` en el alta) |
| Marcación (opción 4) | Registrar corrección | Registrar recepción |
| Búsqueda | Por alumno, sin mayúsculas distintivas | Por producto, sin mayúsculas distintivas |
| Flujo Git | Mismos requisitos: 5 issues, 5 PR, `main` protegida, README | Mismos requisitos |
| Carga segura | `[]` / aviso + `sys.exit(1)` | `[]` / aviso + `sys.exit(1)` |

Mismo programa, mismos requisitos técnicos y de Git, misma rúbrica: solo cambia el dominio de los datos.
