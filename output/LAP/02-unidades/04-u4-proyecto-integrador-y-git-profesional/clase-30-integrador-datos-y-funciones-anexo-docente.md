# Anexo docente — Encuentro 30: Integrador: datos y funciones

## Encuadre

El integrador pasa de memoria a persistencia. Todo lo de hoy es consolidación de U2 y U3 aplicada a un proyecto propio: `with open(..., encoding="utf-8")`, `try/except` específicos, `json.load`/`json.dump`, y validaciones con reintentos. Lo nuevo es la gestión: tres o cuatro PRs cortos, uno por issue, con revisión que incluye probar el programa. Al cierre del encuentro el trabajo final debe estar funcional y completo; el Encuentro 31 es de entrega y defensa.

## Qué observar durante la clase

- `open()` sin `encoding="utf-8"`: en el laboratorio queda en cp1252 y los acentos se corrompen al releer; es el defecto número uno del día.
- `json.dump` sin `ensure_ascii=False`: el archivo funciona pero muestra `\u00f3`; corregir en revisión.
- `guardar_prestamos` llamado solo al salir: si el programa se corta con `Ctrl+C` se pierde lo cargado; el canon es guardar tras cada cambio.
- Manejo de JSON dañado con `except:` desnudo o con un simple `pass`: exigir `except json.JSONDecodeError` con aviso y `sys.exit(1)`.
- PRs que mezclan dos issues: reencaminar; un issue = una rama = un PR.
- `pedir_texto` sin `.strip()`: un espacio cuenta como contenido; el canon valida sobre el texto limpio.

## Solución de referencia (integrador completo)

`trabajo-final/prestamos.py` al cierre de los issues 2 a 5 (corre con `python prestamos.py` desde `trabajo-final/`):

```python
import json
import sys

RUTA_DATOS = "prestamos.json"

TEXTO_MENU = """
1) Registrar prestamo
2) Listar prestamos
3) Buscar por alumno
4) Registrar devolucion
5) Salir
Elija una opcion: """

def cargar_prestamos():
    # Devuelve la coleccion guardada en el archivo JSON.
    try:
        with open(RUTA_DATOS, "r", encoding="utf-8") as f:
            return json.load(f)
    except FileNotFoundError:
        # Primera corrida: todavia no existe el archivo de datos.
        return []
    except json.JSONDecodeError:
        # Archivo danado: no se puede seguir sin perder datos.
        print("El archivo de datos esta danado")
        sys.exit(1)

def guardar_prestamos(prestamos):
    # Sobrescribe el archivo con la coleccion completa.
    with open(RUTA_DATOS, "w", encoding="utf-8") as f:
        json.dump(prestamos, f, ensure_ascii=False, indent=2)

def pedir_texto(mensaje):
    # Pide un texto y reintenta hasta recibir algo no vacio.
    while True:
        dato = input(mensaje).strip()
        if dato != "":
            return dato
        print("No puede quedar vacio")

def registrar_prestamo(prestamos):
    # Pedir los datos validados del prestamo
    equipo = pedir_texto("Equipo: ")
    alumno = pedir_texto("Alumno: ")
    fecha = pedir_texto("Fecha (AAAA-MM-DD): ")
    # Armar el registro con devuelto en False
    prestamo = {"equipo": equipo, "alumno": alumno, "fecha": fecha, "devuelto": False}
    prestamos.append(prestamo)
    # Guardar el cambio y confirmar el alta
    guardar_prestamos(prestamos)
    print("Prestamo registrado")

def listar_prestamos(prestamos):
    # Caso sin datos cargados
    if len(prestamos) == 0:
        print("No hay prestamos registrados")
        return
    # Recorrer y mostrar cada registro
    for prestamo in prestamos:
        if prestamo["devuelto"]:
            estado = "devuelto"
        else:
            estado = "pendiente"
        print(f'{prestamo["fecha"]} | {prestamo["equipo"]} | {prestamo["alumno"]} | {estado}')

def buscar_prestamos(prestamos):
    # Pedir el nombre a buscar
    texto = pedir_texto("Alumno a buscar: ")
    # Recorrer y mostrar solo las coincidencias
    encontrados = 0
    for prestamo in prestamos:
        if texto == prestamo["alumno"]:
            print(f'{prestamo["fecha"]} | {prestamo["equipo"]} | {prestamo["alumno"]}')
            encontrados = encontrados + 1
    # Avisar si no hubo coincidencias
    if encontrados == 0:
        print("No se encontraron prestamos de ese alumno")

def marcar_devolucion(prestamos):
    # Buscar el prestamo pendiente del alumno
    texto = pedir_texto("Alumno: ")
    for prestamo in prestamos:
        if texto == prestamo["alumno"] and not prestamo["devuelto"]:
            # Mostrar y confirmar la devolucion
            print(f'{prestamo["fecha"]} | {prestamo["equipo"]} | {prestamo["alumno"]}')
            confirma = input("Confirmar devolucion (s/n): ")
            if confirma == "s":
                prestamo["devuelto"] = True
                guardar_prestamos(prestamos)
                print("Devolucion registrada")
            return
    # Solo llega aqui si no hubo pendientes
    print("No hay prestamos pendientes de ese alumno")

def main():
    # Cargar la coleccion al arrancar
    prestamos = cargar_prestamos()
    while True:
        opcion = input(TEXTO_MENU)
        if opcion == "1":
            registrar_prestamo(prestamos)
        elif opcion == "2":
            listar_prestamos(prestamos)
        elif opcion == "3":
            buscar_prestamos(prestamos)
        elif opcion == "4":
            marcar_devolucion(prestamos)
        elif opcion == "5":
            print("Hasta luego")
            break
        else:
            print("Opcion invalida")

if __name__ == "__main__":
    main()
```

`prestamos.json` esperado tras un alta y una devolución:

```json
[
  {
    "equipo": "PC-07",
    "alumno": "Ana Garcia",
    "fecha": "2025-09-15",
    "devuelto": true
  }
]
```

Verificación de la salida con código `1` para el JSON dañado (canon de convenciones, sección 6): dañar el archivo a propósito, correr el programa y en la terminal correr `echo %errorlevel%` (Windows): debe informar `1` después del mensaje «El archivo de datos esta danado».

## Errores previsibles

1. **Guardar dentro del bucle con `"w"` «por si acaso» en cada opción:** el guardado pertenece a las funciones que mutan; guardar en listar o en buscar es un defecto de diseño que la revisión debe señalar.
2. **Claves renombradas en un PR (`alumno` → `nombre`):** `KeyError` en ejecución; el canon valida con `in` antes de leer y los nombres de campo son el mismo del código.
3. **`sys` importado pero `sys.exit(1)` olvidado:** el aviso sin código de salida deja el programa «roto pero vivo»; probar ambos juntos.
4. **Búsqueda con `in` sobre textos parciales y comparación distinta en devolución:** unificar criterio: igualdad exacta en ambos (subcadenas quedan como funcionalidad opcional).
5. **Merge directo en GitHub sin pull local después:** el compañero que sigue no ve los cambios; cerrar siempre con `git switch main` + `git pull`.

## Criterios de logro (4-8)

| Nivel | Descripción |
|---|---|
| 4 | La persistencia no funciona: el JSON no se crea o se corrompe. |
| 5 | Persistencia básica funcionando; faltan validaciones o la devolución. |
| 6 | Menú completo con persistencia y validaciones; PRs sin revisión o issues sin cerrar. |
| 7 | Issues 2 a 5 cerrados por PRs revisados; los seis caminos de prueba verificados. |
| 8 | Además, explica la diferencia de manejo entre archivo ausente y archivo dañado, y justifica dónde y por qué se guarda. |

## Agrupamiento

Grupos de trabajo habituales. Sugerencia de paralelización: mientras un par arma la rama de persistencia, otro prepara la de devolución sobre `main` al día; nunca dos ramas que tocan la misma función al mismo tiempo. La revisión de cada PR incluye ejecutar el programa desde la rama fusionada.

## Ajustes para la siguiente edición

- Si el grupo no alcanza a cerrar todos los issues, priorizar persistencia (issue 4) y validaciones (issue 5); búsqueda y devolución pueden quedar de la actividad complementaria del Encuentro 31.
- Si el grupo avanza veloz, sumar el campo opcional `horas` con `pedir_entero` y reintentos ante `ValueError` para reejercitar la conversión numérica del canon.
