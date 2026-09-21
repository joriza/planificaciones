# Encuentro 21 — Anexo docente: Diccionarios y registros

## Resumen de la clase

| Bloque | Duración | Actividad |
|---|---|---|
| Apertura y motivación | 10 min | Devolución de la Unidad 2. Recuperar la agenda por posiciones de U2 y presentar el problema: los campos deben viajar con nombre, no con índice. |
| Desarrollo teórico-práctico | 60 min | Teoría mínima con `diccionario_basico.py` (20 min). Etapa 1 y Etapa 2 del ejercicio progresivo `agenda_dict.py` (40 min). |
| Consolidación y cierre | 20 min | Puesta en común, pruebas de errores previstos (opción inválida, clave ausente), tabla de errores comunes y commit de cierre. |
| Actividad complementaria | 30 min | Etapa 3 (búsqueda por nombre) y desafíos de extensión: búsqueda parcial y contador de contactos. |

## Preparación previa

- VS Code y terminal abiertos; verificar `python --version` (3.11).
- Tener a mano la agenda de texto de la Unidad 2 para mostrar el problema de los índices.
- Tener resuelto `agenda_dict.py` completo (versión de este anexo) para proyectar en la puesta en común.
- Recordar la rutina de Git de cierre de encuentro (canon: un commit por encuentro).

## Solución completa del ejemplo

`diccionario_basico.py`:

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

## Soluciones del ejercicio progresivo

### Etapa 1 — Modelo y listado

```python
def listar_contactos(contactos):
    # Muestra todos los contactos numerados.
    if len(contactos) == 0:
        print("No hay contactos cargados.")
        return
    numero = 1
    for contacto in contactos:
        print(numero, "-", contacto["nombre"], "-", contacto["telefono"], "-", contacto["correo"])
        numero = numero + 1

def main():
    # Agenda de ejemplo para probar el listado.
    contactos = [
        {"nombre": "Ana", "telefono": "2664-555123", "correo": "ana@gmail.com"},
        {"nombre": "Bruno", "telefono": "2664-555456", "correo": "bruno@gmail.com"}
    ]
    listar_contactos(contactos)

if __name__ == "__main__":
    main()
```

### Etapa 2 — Alta por teclado con menú validado

```python
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
```

Menú dentro de `main()`:

```python
    while True:
        print("1) Alta  2) Listado  0) Salir")
        texto_opcion = input("Elija una opcion: ").strip()
        try:
            opcion = int(texto_opcion)
        except ValueError:
            print("Debe ingresar un numero valido.")
            continue
        if opcion == 1:
            contactos.append(pedir_contacto())
            print("Contacto agregado.")
        elif opcion == 2:
            listar_contactos(contactos)
        elif opcion == 0:
            break
        else:
            print("Opcion no valida.")
```

### Etapa 3 — Búsqueda por nombre

```python
def buscar_contacto(contactos, nombre):
    # Devuelve el contacto cuyo nombre coincide, o None si no existe.
    for contacto in contactos:
        if contacto["nombre"].lower() == nombre.lower():
            return contacto
    return None
```

Opción 3 del menú:

```python
        elif opcion == 3:
            nombre = input("Nombre a buscar: ").strip()
            contacto = buscar_contacto(contactos, nombre)
            if contacto is None:
                print("No existe un contacto con ese nombre.")
            else:
                print(contacto["nombre"], "-", contacto["telefono"], "-", contacto["correo"])
```

Cierre de `main()` (opción 0), con el gancho para el próximo encuentro:

```python
        elif opcion == 0:
            print("La agenda vive solo en memoria: al cerrar se pierden los cambios.")
            break
```

### Desafíos de la actividad complementaria

```python
def filtrar_por_nombre(contactos, texto):
    # Devuelve los contactos cuyo nombre contiene el texto.
    resultado = []
    texto = texto.lower()
    for contacto in contactos:
        if texto in contacto["nombre"].lower():
            resultado.append(contacto)
    return resultado
```

Contador al salir: `print("Contactos en memoria:", len(contactos))`.

## Errores anticipados y corrección

| Error esperado | Dónde aparece | Corrección en clase |
|---|---|---|
| `KeyError` por clave mal escrita (`Nombre` en vez de `nombre`) | Listado o búsqueda | Mostrar que las claves son sensibles a mayúsculas; revisar el literal del dict. |
| `contacto[0]` para obtener el primer campo | Alumno que viene de la agenda posicional de U2 | El dict no tiene orden posicional de campos: se lee por clave. |
| Construir el registro con `[]` y `:` | Etapa 2, primera alta | `SyntaxError`; el literal de dict usa llaves `{}`. |
| Comparar `opcion == "1"` mezclando texto y número | Menú de la Etapa 2 | Elegir una sola representación; en el curso, convertir a `int` con `try`/`except ValueError`. |
| Búsqueda sensible a mayúsculas (no encuentra "ana" buscando "Ana") | Etapa 3 | Comparar con `.lower()` en ambos lados. |
| `None` mostrado como resultado de la búsqueda | Etapa 3 | Comparar con `is None` antes de mostrar; `None` significa «no existe». |
| Lógica suelta fuera de funciones (lista y menú a nivel de módulo) | Estructura del archivo | Recordar el esqueleto del canon: constantes, funciones, `main()` y guard `if __name__ == "__main__":`. |

## Observación en el aula

Al circular por las máquinas, verificar:

- Que las claves del dict se llamen igual en todo el archivo (`nombre`, `telefono`, `correo`).
- Que el `int()` del menú esté dentro de `try`/`except ValueError` (nunca `except:` desnudo).
- Que las funciones reciban la lista por parámetro y no usen una variable global suelta.
- Que ninguna salida quede sin mensaje: cada acción del menú responde algo.

## Preparación del próximo encuentro

- Tener `agenda_dict.py` terminado: es la base del encuentro 22 (persistencia en CSV).
- Preparar un `agenda.csv` de muestra para mostrar el formato antes de programarlo.
