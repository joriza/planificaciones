# Encuentro 30 — Integrador: datos y funciones

## Datos del encuentro

| Campo | Valor |
|---|---|
| Unidad | 4 — Proyecto integrador y Git profesional |
| Encuentro | 30 de 36 |
| Eje temático | 4 — Proyecto integrador y Git profesional |
| Carácter/Objetivo | Procedimental |
| Duración | 120 minutos (2 horas reloj) |
| Requisitos | Núcleo del menú en memoria fusionado (Encuentro 29); `json.load`/`json.dump` y `try/except` de U2 y U3 |
| Concepto nuevo | Persistencia JSON segura y cierre de validaciones del integrador |

## Objetivos de aprendizaje

- Cargar la colección desde `prestamos.json` con manejo de archivo ausente y JSON dañado.
- Guardar la colección completa con `json.dump(ensure_ascii=False, indent=2)`.
- Completar búsqueda y devolución conectadas al menú.
- Validar entradas con reintentos y cerrar los issues 2 a 5 mediante pull requests revisados.

## Reparto de tiempos (120 minutos)

| Bloque | Minutos |
|---|---|
| Apertura y motivación | 10 min |
| Desarrollo teórico-práctico | 60 min |
| Consolidación y cierre | 20 min |
| Actividad complementaria | 30 min |
| **Total** | **120 min** |

## Apertura y motivación (10 min)

El núcleo del integrador ya funciona, pero cada ejecución arranca en cero: los préstamos viven solo en la memoria del programa. Hoy la colección pasa a `prestamos.json` y el programa aprende a sobrevivir a sus dos enemigos previstos: el archivo que no existe (primera corrida) y el archivo dañado (edición manual fallida). Con eso, el menú queda completo y el proyecto entra a su etapa de terminación.

## Desarrollo teórico-práctico (60 min)

### Paso 1: carga segura (issue 4)

Constantes e imports nuevos, arriba del archivo según el esqueleto canónico:

```python
import json
import sys

RUTA_DATOS = "prestamos.json"
```

Funciones de persistencia (la ruta es relativa al archivo: los datos viven junto al `.py`):

```python
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
```

`main()` cambia en dos líneas: la colección nace del archivo y cada cambio se guarda.

```python
def main():
    # Cargar la coleccion al arrancar
    prestamos = cargar_prestamos()
    while True:
        opcion = input(TEXTO_MENU)
        ...
        elif opcion == "1":
            registrar_prestamo(prestamos)
            guardar_prestamos(prestamos)
```

### Paso 2: devolución (issue 3)

```python
def marcar_devolucion(prestamos):
    # Buscar el prestamo pendiente del alumno
    texto = input("Alumno: ")
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
```

### Paso 3: validaciones con reintentos (issue 5)

Los campos de texto no pueden quedar vacíos; la validación reintenta hasta obtener contenido:

```python
def pedir_texto(mensaje):
    # Pide un texto y reintenta hasta recibir algo no vacio.
    while True:
        dato = input(mensaje).strip()
        if dato != "":
            return dato
        print("No puede quedar vacio")
```

Se usa en el alta: `equipo = pedir_texto("Equipo: ")`. El JSON dañado ya se maneja en `cargar_prestamos` con `sys.exit(1)`: nunca llega un traceback al usuario.

### Paso 4: verificar los datos y los caminos

Tras cada corrida, abrir `prestamos.json` (o `type prestamos.json` en la terminal):

```json
[
  {
    "equipo": "PC-07",
    "alumno": "Ana Garcia",
    "fecha": "2025-09-15",
    "devuelto": false
  }
]
```

Caminos de prueba obligatorios, en orden: corrida sin archivo (arranca vacía), alta + listado, salida y re-corrida (los datos siguen), devolución confirmada (estado `devuelto` y `true` en el JSON), opción inválida, y JSON dañado a propósito (borrar una llave con el editor) → mensaje y código de salida `1`.

### Paso 5: cada mejora por su PR

Tres ramas cortas sobre `main` al día:

```bash
git switch main
git pull
git switch -c feature/persistencia-json
# implementar, probar y confirmar
git commit -m "trabajo-final: persistencia json con carga segura"
git push -u origin feature/persistencia-json
```

El PR de persistencia cierra el issue 4 (`Closes #4`); búsqueda (issue 2, si quedó de la actividad complementaria) y devolución (issue 3) entran igual. Los issues se cierran solos con el merge; en caso contrario, cerrarlos a mano con un comentario del resultado.

## Consolidación y cierre (20 min)

Verificación por grupo, en orden:

- [ ] `prestamos.json` creado por el propio programa, legible y con acentos correctos.
- [ ] Re-corrida conserva los datos (persistencia real, no memoria).
- [ ] JSON dañado → mensaje claro y salida con código `1`, sin traceback.
- [ ] Campos vacíos rechazados con reintento.
- [ ] Issues 2 a 5 cerrados, cada uno por su PR revisado.

### Qué te llevás

- `json.load` devuelve la colección completa; `json.dump(ensure_ascii=False, indent=2)` la escribe legible y con acentos.
- `FileNotFoundError` no es un error: es la primera corrida; `json.JSONDecodeError` sí es grave: aviso y `sys.exit(1)`.
- La colección en memoria es la fuente de verdad y se guarda completa tras cada cambio.
- Las validaciones con reintentos viven en funciones (`pedir_texto`), no dispersas en el menú.

## Actividad complementaria (30 min)

Dos caminos según el estado del grupo:

- **Si hay issues abiertos:** terminarlos. El integrador debe quedar funcional completo al cierre del encuentro.
- **Si todo está fusionado:** funcionalidad opcional por issue nuevo y rama propia, por ejemplo un campo numérico `horas` con `pedir_entero` (reintentos ante `ValueError`), o un listado que muestre solo los préstamos pendientes.

Con el menú completo, ensayar la explicación de una función cualquiera ante otro integrante: qué recibe, qué devuelve, qué errores maneja. Ese ensayo es el borrador de la defensa del Encuentro 31.

## Lo que viene

En el Encuentro 31 la unidad cierra: se termina el README del proyecto, se hace la entrega final del trabajo por GitHub y cada integrante ensaya su defensa individual, que se sostiene formalmente en el Encuentro 32.
