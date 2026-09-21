# Encuentro 21 — Diccionarios y registros

## Metadatos de bloque

| Campo | Valor |
|---|---|
| **Duración** | 120 minutos |
| **Unidad** | 3 — Datos estructurados y JSON |
| **Tipo** | Procedimental |
| **Requiere** | Unidad 2 completa: funciones con `def`, menú con `while`, entrada validada con `try`/`except ValueError`, archivos de texto con `with open` y `except FileNotFoundError`. Agenda de la unidad anterior funcionando y devolución del TP-U2 al inicio. |
| **Nuevo concepto** | Diccionario (`dict`), acceso por clave, validación de clave con `in`, lista de diccionarios como colección de registros en memoria |

## Reparto de tiempos (120 minutos)

| Bloque | Duración |
|---|---|
| Apertura y motivación | 10 min |
| Desarrollo teórico-práctico | 60 min |
| Consolidación y cierre | 20 min |
| Actividad complementaria | 30 min |

## Objetivos de aprendizaje

- Representar un registro (un contacto) como diccionario y leer sus campos por nombre.
- Validar que una clave existe con `in` antes de leerla, evitando el `KeyError`.
- Construir una colección de registros como lista de diccionarios en memoria y recorrerla.
- Sostener un menú de alta, listado y búsqueda reutilizando funciones y validaciones de la unidad anterior.

## Apertura y motivación

Devolución de la Unidad 2 y de su TP. Después, recuperar la agenda que el curso construyó: un archivo de texto donde cada línea era un contacto y los campos se leían **por posición** con `split(",")`. Ese diseño tiene un costo conocido: agregar un campo nuevo obliga a revisar todos los índices del programa, y nada en el código dice qué hay en `campos[1]`.

En esta unidad los datos pasan a viajar con **nombre**: cada contacto se representa como un diccionario, donde cada campo se llama por su clave y no por su posición. La agenda de este encuentro vive solo en memoria; los encuentros 22, 23 y 24 se ocupan de hacerla durable en CSV y JSON.

## Teoría mínima

### El registro como diccionario

Un `dict` agrupa campos con nombre. Ejemplo completo para correr con `python diccionario_basico.py`:

```python
# Demo minima de diccionarios: un registro y una lista de registros.

# Crear un registro: cada campo tiene un nombre (clave)
contacto = {"nombre": "Ana", "telefono": "2664-555123", "correo": "ana@gmail.com"}

# Leer un campo por su clave
print(contacto["nombre"])

# Verificar que una clave existe antes de leerla
if "correo" in contacto:
    print(contacto["correo"])

# Cambiar el valor de un campo
contacto["telefono"] = "2664-555999"

# Recorrer el registro campo por campo
for campo in contacto:
    print(campo, "->", contacto[campo])

# Una agenda en memoria: lista de registros
contactos = []
contactos.append(contacto)
contactos.append({"nombre": "Bruno", "telefono": "2664-555456", "correo": "bruno@gmail.com"})

# Recorrer la lista y mostrar un campo de cada registro
for persona in contactos:
    print(persona["nombre"], "-", persona["telefono"])
```

Salida esperada:

```text
Ana
ana@gmail.com
nombre -> Ana
telefono -> 2664-555999
correo -> ana@gmail.com
Ana - 2664-555999
Bruno - 2664-555456
```

### Claves: leer, validar, recorrer

- Se lee con `contacto["nombre"]`. Si la clave no existe, Python lanza `KeyError`.
- Antes de leer una clave opcional, se valida con `if "clave" in contacto:`.
- El recorrido `for campo in contacto:` entrega las claves; el valor se obtiene con `contacto[campo]`.

### Una colección de registros

La agenda completa es una **lista de diccionarios**: cada elemento es un registro. Se agrega con `append`, se recorre con `for contacto in contactos:` y cada campo se lee por su clave. El mismo nombre del dato en el registro se usa como variable en el código (`nombre` en el dict, `nombre` en el programa).

## Ejercicio progresivo: agenda de contactos en memoria

Ejercicio único de la clase, en un solo archivo `agenda_dict.py`, con etapas que agregan capacidad sobre lo ya escrito.

### Etapa 1 — El modelo y el listado (en el desarrollo teórico-práctico)

Definir `contactos` con dos registros de ejemplo (función `main`) y la función `listar_contactos(contactos)` que muestra cada contacto numerado. Correr y verificar la salida.

**Pista:** si la lista está vacía, mostrar un aviso en lugar de un listado vacío.

### Etapa 2 — Alta por teclado con menú validado (en el desarrollo teórico-práctico)

Agregar `pedir_contacto()`: pide nombre, teléfono y correo; el nombre no puede quedar vacío. Sumar el menú con opciones numéricas: la opción se convierte con `int()` dentro de `try`/`except ValueError` y un valor inválido vuelve a pedir el menú.

**Pista:** `while True:` con `break` cuando el nombre tiene contenido, igual que en la Unidad 2.

### Etapa 3 — Búsqueda por nombre (en la actividad complementaria)

Agregar `buscar_contacto(contactos, nombre)`: recorre la lista y devuelve el dict cuyo nombre coincide, o `None` si no existe. La opción 3 del menú muestra el detalle completo o el aviso «No existe un contacto con ese nombre».

**Pista:** comparar con `.lower()` de ambos lados para no distinguir mayúsculas.

## Consolidación y cierre

- Puesta en común: correr 2 o 3 agendas frente al grupo y comparar formatos de listado.
- Verificación de errores previstos: opción de menú `"x"` debe responder «Debe ingresar un numero valido.» y volver al menú; ningún `traceback` en pantalla.
- Recorrer la tabla de errores comunes y marcar los que aparecieron en clase.
- Rutina de Git de cierre del encuentro: `git add .`, `git commit -m "u3: agenda en memoria con diccionarios"` y `git push`.
- Próximo encuentro: la agenda se pierde al cerrar el programa; el encuentro 22 la guarda en un archivo CSV, línea por línea.

## Actividad complementaria

- Terminar la Etapa 3 del ejercicio (búsqueda con detalle o aviso).
- Desafío: búsqueda parcial — listar los contactos cuyo nombre **contiene** un texto, con el operador `in` sobre `contacto["nombre"].lower()`.
- Desafío: mostrar al salir la cantidad de contactos cargados en memoria.

## Errores comunes

| Error | Causa | Corrección |
|---|---|---|
| `KeyError: 'direccion'` | Se lee una clave que el registro no tiene, o el nombre está mal escrito. | Validar con `if "clave" in contacto:` y revisar el nombre exacto de cada clave. |
| `TypeError: list indices must be integers` | Se usa `contacto[0]` sobre un dict. | Los dicts se indexan por clave: `contacto["nombre"]`. |
| `contactos["nombre"]` | Se confunde la lista con el registro: la lista se indexa por posición. | Primero el elemento, después el campo: `contactos[0]["nombre"]`. |
| `SyntaxError` al crear el registro con `[]` | `contacto = ["nombre": "Ana"]` mezcla lista con dict. | El literal de diccionario usa llaves: `{"nombre": "Ana"}`. |
| `TypeError` al concatenar `contactos + contacto` | Se intenta sumar una lista con un dict. | Agregar con `contactos.append(contacto)`. |
| La opción del menú nunca coincide | Se compara `input()` sin convertir: `input()` devuelve `str`. | Convertir con `int()` dentro de `try`/`except ValueError` y reintentar. |
