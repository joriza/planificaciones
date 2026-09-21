# Anexo docente — Encuentro 13: Menú con persistencia

## Encuadre

Cuarto encuentro de la Unidad 2, el de consolidación del ejercicio progresivo único: la agenda queda funcional y completa (cargar, alta, listar, buscar, eliminar, ver archivo, guardar), lista para que el Encuentro 14 solo agregue la personalización del TP y la entrega. La novedad técnica del día es `eliminar_contacto`, que obliga a combinar búsqueda validada, `del` en memoria y reescritura total del archivo; alrededor de ella se reorganiza el `.py` completo con el esqueleto canónico.

El listado completo de la práctica guiada es el artefacto central: es la base directa del TP-U2 y conviene que cada estudiante lo tenga corriendo al terminar la clase.

## Qué observar durante la clase

- `del contactos[posicion]` con `posicion == -1`: borra el último elemento sin avisar. Exigir la validación antes del `del`.
- Eliminar en memoria sin reescribir el archivo: el programa «funciona» en la corrida y falla al reabrir. Es el error conceptual más valioso del día: memoria ≠ disco.
- Guardar la salida con `"a"` por analogía con el alta: el archivo crece con la agenda completa en cada salida.
- Doble carga: llamar a `cargar_contactos()` dentro del bucle del menú (por ejemplo, tras cada operación) y ver la lista duplicada.
- Listado desordenado al reorganizar el `.py`: funciones después de `main()` o lógica suelta a nivel de módulo; al importar, se ejecuta igual.
- Copia y pega del listado sin leer: pedir que expliquen qué hace `eliminar_contacto` antes de probarlo.

## Solución completa del ejercicio independiente

```python
def editar_telefono(contactos, nombre, telefono_nuevo):
    # Reemplazar el telefono del contacto y reescribir el archivo.
    posicion = buscar_contacto(contactos, nombre)
    if posicion == -1:
        print("No existe un contacto con ese nombre")
        return
    contactos[posicion][1] = telefono_nuevo
    guardar_contactos(contactos)
    print("Telefono actualizado y archivo reescrito")
```

Con la opción agregada al menú:

```python
        elif opcion == "8":
            nombre = input("Nombre a editar: ")
            telefono_nuevo = input("Telefono nuevo: ")
            editar_telefono(contactos, nombre, telefono_nuevo)
```

Prueba esperada: con `Ana,4567,23` en el archivo, editar su teléfono a `9999` y verificar que `contactos.txt` quedó `Ana,9999,23` — una sola línea, sin duplicados.

## Errores previsibles

1. **`del` sin validar la posición:** `buscar_contacto` devuelve `-1` cuando no existe, y `del contactos[-1]` elimina el último contacto. Corrección: `if posicion == -1:` con su mensaje antes del `del`.
2. **Cambios que no llegan al disco:** eliminar o editar en memoria sin reescribir; al reabrir el programa, el archivo manda. Corrección: toda operación estructural termina con `guardar_contactos(contactos)`.
3. **Guardar con `"a"` la agenda completa:** el modo `"a"` agrega y nunca borra; tras varias salidas, el archivo acumula copias enteras de la agenda. Corrección: la reescritura total con `"w"` es el único modo para el conjunto.
4. **Editar con `"a"`:** la línea vieja queda y la nueva se agrega: el contacto aparece dos veces con teléfonos distintos. Corrección: reescribir todo tras editar.
5. **Cargar más de una vez:** `cargar_contactos()` llamada dentro del bucle duplica los contactos en memoria y, al guardar, en el archivo. Corrección: una sola carga al inicio de `main()`.
6. **Lógica suelta fuera de funciones:** verificada en el spike del curso: al importar el archivo, el código a nivel de módulo se ejecuta igual. Corrección: esqueleto canónico completo, con el guard siempre al final.

## Criterios de logro (4-8)

| Nivel | Descripción |
|---|---|
| 4 | El menú corre, pero eliminar borra sin validar o los cambios no llegan al archivo. |
| 5 | Eliminar funciona para nombres existentes; al reabrir el programa se descubren cambios perdidos. |
| 6 | Eliminar persiste correctamente; faltan la validación del `-1` o el orden canónico del `.py`. |
| 7 | Programa completo con esqueleto canónico, ciclo probar-y-reabrir verificado, y `editar_telefono` reutilizando búsqueda y reescritura. |
| 8 | Explica cuándo alcanza `"a"` y cuándo exige `"w"`, y detecta el duplicado que produciría guardar o editar con `"a"`. |

## Agrupamiento

Individual, en parejas solo si faltan máquinas. El listado completo debe correr en la máquina de cada estudiante; las parejas se separan para la prueba del ciclo completo.

## Ajustes para la siguiente edición

- Si la reorganización del `.py` completo insume demasiado, entregar el listado como base y concentrar la clase en eliminar + editar; el reordenamiento se evalúa en el TP.
- Si aparece de forma generalizada el «cambio perdido al reabrir», armarlo en vivo como demostración de apertura: es la mejor motivación para el ciclo archivo → memoria → archivo.
- Si sobra tiempo, mostrar la opción de la actividad complementaria (conteo memoria vs. archivo) y dejarla como desafío del TP.
