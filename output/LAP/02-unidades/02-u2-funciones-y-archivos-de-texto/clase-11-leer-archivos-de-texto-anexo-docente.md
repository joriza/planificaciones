# Anexo docente — Encuentro 11: Leer archivos de texto

## Encuadre

Segundo encuentro de la Unidad 2. La agenda del encuentro anterior vivía solo en memoria; hoy gana su primera persistencia: `cargar_contactos()` lee `contactos.txt` al arranque. Es el primer contacto del curso con la infraestructura de archivos planos: `with open`, `FileNotFoundError` y el formato línea-por-registro con campos separados por coma. El ejercicio progresivo único avanza: la agenda sobrevive al apagado, pero todavía no puede guardar cambios (eso llega en el Encuentro 12), así que en esta clase el archivo se escribe a mano una vez para tener qué leer.

Momento clave de la clase: la primera corrida sin archivo no es un error, es el camino canónico de la primera vez.

## Qué observar durante la clase

- `open()` sin `encoding="utf-8"`: en el laboratorio el defecto no se nota con datos sin ñ; mostrar con un `Munoz` en el archivo cómo la relectura explota con `UnicodeDecodeError`.
- Filas fantasma: procesar la línea vacía sin filtrarla y ver un «contacto» de un solo campo.
- `split` sin `strip` en los campos cuando copian el ejemplo con espacio después de la coma.
- Intentar leer con `except ValueError` (la excepción «de moda» del encuentro anterior) en lugar de `FileNotFoundError`.
- Colocar `RUTA_DATOS` después de las funciones, o duplicada: la constante va arriba de todo, junto a `TEXTO_MENU`.
- Olvidar el `return contactos`: la función carga, imprime bien dentro de sí misma, pero `main()` recibe `None`.

## Solución completa del ejercicio independiente

```python
def mostrar_archivo():
    # Mostrar el archivo tal cual, una linea por registro.
    try:
        with open(RUTA_DATOS, "r", encoding="utf-8") as f:
            cantidad = 0
            for linea in f:
                linea = linea.strip()
                if linea == "":
                    continue
                print(linea)
                cantidad = cantidad + 1
            if cantidad == 0:
                print("El archivo no tiene contactos guardados")
    except FileNotFoundError:
        print("No existe el archivo de datos: se empieza de cero")
```

Con la opción agregada al menú:

```python
        elif opcion == "5":
            mostrar_archivo()
```

Salida esperada con el archivo de la práctica guiada:

```
Elija una opcion: 5
Ana,4567,23
Luis,7890,35
Mara,3210,19
```

## Errores previsibles

1. **`open()` sin `encoding="utf-8"`:** usa la codificación del sistema (cp1252 observado en el laboratorio); una ñ escrita así queda como byte `0xf1` y la relectura UTF-8 lanza `UnicodeDecodeError`. Corrección: siempre `with open(ruta, modo, encoding="utf-8")`.
2. **Comparar la línea recién leída:** cada línea conserva el `\n` (`repr` → `'Ana\n'`), así que la búsqueda por nombre nunca coincide. Corrección: `.strip()` al leer, antes de cualquier uso.
3. **`split(",")` sin `strip()`:** `"Ana, 23".split(",")` devuelve `['Ana', ' 23']`; queda el espacio y las comparaciones de texto fallan. Corrección: `.strip()` en cada campo.
4. **Líneas vacías sin filtrar:** `"".split(",")` devuelve `['']`, un registro de un campo. Corrección: `if linea.strip() == "": continue`.
5. **Edad mal escrita en el archivo:** `int("23.5")` lanza `ValueError` y corta toda la carga. En la práctica guiada no ocurre; en la actividad complementaria se maneja con un `except ValueError` que avisa y omite la línea dañada.
6. **Pasar del aviso al traceback:** si el `FileNotFoundError` no se captura, el alumno ve un traceback. Recordar la regla del curso: ante una situación prevista, nunca llega un traceback; llega el mensaje «No existe el archivo de datos: se empieza de cero».

## Criterios de logro (4-8)

| Nivel | Descripción |
|---|---|
| 4 | Abre el archivo pero no filtra líneas vacías ni limpia los campos: la lista trae basura. |
| 5 | La carga funciona con archivo presente; el caso sin archivo termina en traceback. |
| 6 | `FileNotFoundError` capturado con mensaje canónico; falta el `return` o el filtrado de vacías. |
| 7 | Carga completa con los dos caminos probados; opción 5 mostrando el archivo crudo. |
| 8 | Explica por qué el `encoding` es obligatorio y distingue el archivo crudo (opción 5) de la lista cargada (opción 2). |

## Agrupamiento

Individual, en parejas solo si faltan máquinas. La creación a mano de `contactos.txt` es individual: cada estudiante debe ver el formato crudo en su propio archivo.

## Ajustes para la siguiente edición

- Si la mayoría no logra ver el `UnicodeDecodeError` con la ñ, dedicar 5 minutos del cierre a correrlo en vivo con el dato `Munoz`/`Muñoz`.
- Si la carga se resuelve rápido, adelantar la actividad complementaria (línea dañada con `ValueError`) como parte del desarrollo.
- Si confunden `RUTA_DATOS` con una variable común, mostrar en pizarra la sección de constantes del esqueleto canónico antes de la práctica.
