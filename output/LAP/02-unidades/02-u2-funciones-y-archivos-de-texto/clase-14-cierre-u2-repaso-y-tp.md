# Encuentro 14: Cierre U2 — repaso y TP

## Datos del encuentro

| Campo | Valor |
|---|---|
| Unidad | U2: Funciones y archivos de texto |
| Encuentro | 14 de 20 |
| Duración | 120 minutos |
| Carácter | Actitudinal |

## Objetivos de aprendizaje

- Integrar funciones y archivos de texto en el TP-U2 completo.
- Personalizar la agenda con un campo propio del grupo, tocando carga, guardado y presentación.
- Entregar el trabajo en la carpeta `tp-u2/` con commit y push.
- Revisar los errores frecuentes de la unidad sobre el código propio.

## Reparto de tiempos (120 minutos)

| Bloque | Minutos |
|---|---|
| Apertura y motivación | 10 |
| Desarrollo teórico-práctico | 70 |
| Consolidación y cierre | 25 |
| Actividad complementaria | 15 |

## Charla rápida

El TP-U2 es la agenda terminada: la misma que se armó encuentro a encuentro desde el 10, ahora completa, personalizada y entregada. No hay receta nueva: la receta la escribieron ustedes en cinco clases. Lo que cambia hoy es el estándar: el programa tiene que correr completo, guardar y reabrir sin perder datos, y quedar publicado en el repositorio del grupo con su commit. Piensen en el TP como cerrar el cuaderno de la agenda y ponerle el nombre: lo de adentro ya estaba, lo que falta es la entrega ordenada.

## Repaso integrador

### El ciclo completo de la unidad

```
E10 funciones (def/return)  ->  E11 leer (with open, split/strip)
->  E12 escribir (w y a)    ->  E13 menu con persistencia ->  E14 TP y entrega
```

### Esqueleto canónico, checklist mental

```
1. import (solo si se usa)
2. Constantes: TEXTO_MENU, RUTA_DATOS
3. Funciones: cargar, guardar, agregar_al_archivo, buscar, mostrar, eliminar, extras
4. def main(): carga al abrir, menu while, guarda al salir
5. if __name__ == "__main__": main()
```

### Checklist de lo que debe tener el TP-U2

- [ ] Carpeta `tp-u2/` en el repositorio del grupo, con un único `agenda.py`.
- [ ] `contactos.txt` junto al `.py`, con formato `nombre,telefono,edad` por línea.
- [ ] Constantes en `MAYUSCULAS_CON_GUIONES_BAJOS` y el menú como texto constante.
- [ ] `with open(ruta, modo, encoding="utf-8")` en toda lectura y escritura.
- [ ] `FileNotFoundError` capturado con el mensaje «No existe el archivo de datos: se empieza de cero».
- [ ] `.strip()` en cada línea y cada campo; líneas vacías filtradas.
- [ ] `str()` al escribir números; `int()` al leer la edad, con reintento ante `ValueError`.
- [ ] Excepciones específicas, sin `except:` desnudo; sin traceback en situaciones previstas.
- [ ] Alta con `"a"`; eliminar/editar y guardado de salida con `"w"`.
- [ ] Commit con formato `tp-u2: <resumen en espanol, sin tildes>` y push.

## Práctica guiada: personalizar y entregar

**Paso 1:** repaso relámpago de cuatro preguntas en el código propio: ¿dónde se carga?, ¿dónde se guarda?, ¿qué modo usa cada operación?, ¿qué pasa la primera vez sin archivo?

**Paso 2:** campo propio del grupo. La agenda de cada grupo agrega un cuarto campo: `ciudad`. El formato del archivo pasa a `nombre,telefono,edad,ciudad`. Los puntos a tocar son siempre los mismos cuatro:

```python
def pedir_contacto():
    # Pedir los datos y devolver el contacto como lista.
    nombre = input("Nombre: ")
    telefono = input("Telefono: ")
    edad = pedir_edad()
    ciudad = input("Ciudad: ")
    return [nombre, telefono, edad, ciudad]
```

```python
def mostrar_contacto(contacto, posicion):
    # Mostrar un contacto con su posicion en la lista.
    print(posicion, "-", contacto[0], "| Tel:", contacto[1], "| Edad:", contacto[2], "| Ciudad:", contacto[3])
```

```python
            campos = linea.split(",")
            nombre = campos[0].strip()
            telefono = campos[1].strip()
            edad = int(campos[2].strip())
            ciudad = campos[3].strip()
            contactos.append([nombre, telefono, edad, ciudad])
```

```python
            linea = contacto[0] + "," + contacto[1] + "," + str(contacto[2]) + "," + contacto[3] + "\n"
            f.write(linea)
```

La misma línea de armado vive en `guardar_contactos` (con `for`) y en `agregar_al_archivo` (un solo contacto).

**Paso 3:** probar el ciclo completo con el campo nuevo: alta, guardar, reabrir, eliminar. Verificar `contactos.txt` con la cuarta columna.

**Paso 4:** entrega en el repositorio del grupo:

```bash
git add .
git commit -m "tp-u2: agenda en archivo de texto"
git push
```

**Paso 5:** verificar la entrega: `git log --oneline` muestra los commits de la unidad, y el repositorio en GitHub muestra `tp-u2/agenda.py` y `tp-u2/contactos.txt`.

## Ejercicio independiente: estadística de cierre

Agregar la opción `9) Promedio de edad` con una función `promedio_edades(contactos)` que devuelva el promedio. Si la agenda está vacía, devolver `0` y avisar.

**Pista:** recorrer con un acumulador sobre `contactos[i][2]`; el promedio es la división de la suma por `len(contactos)`, y esa división da un número con decimales: para mostrarlo no hace falta convertir nada.

**Solución esperada:**

```python
def promedio_edades(contactos):
    # Calcular el promedio de edad de la agenda.
    if len(contactos) == 0:
        return 0
    suma = 0
    for i in range(len(contactos)):
        suma = suma + contactos[i][2]
    return suma / len(contactos)
```

```python
        elif opcion == "9":
            print("Promedio de edad:", promedio_edades(contactos))
```

## Actividad complementaria

Pulido de entrega: revisar el código propio contra la checklist del TP, corregir mensajes sin tilde dentro del código (`Telefono`, `opcion`), completar comentarios que falten (uno por acción) y probar una última vez los dos caminos: con archivo y sin archivo.

## Rutina de cierre (git)

```bash
git add .
git commit -m "tp-u2: entrega de la agenda"
git push
```

> **Importante:** la entrega vale el estado publicado en GitHub: lo que no está en el último push, no está entregado.

## Cierre de la Unidad 2

**Qué te llevas de la U2:**
- Una función se define una vez (`def`, parámetros, `return`) y se llama muchas veces.
- El esqueleto canónico del `.py`: constantes, funciones, `main()` y guard.
- `with open(ruta, modo, encoding="utf-8")` para todo: `"r"` lee, `"w"` reescribe, `"a"` agrega.
- `FileNotFoundError` es la primera corrida, con su mensaje canónico.
- `split(",")` y `.strip()` al leer; `str()` y `"\n"` al escribir.
- El ciclo archivo → memoria → archivo es la persistencia mínima de todo programa.

**Lo que viene (Unidad 3 — Datos estructurados y JSON):** la agenda guarda texto plano, pero los campos sueltos se vuelven difíciles cuando un registro tiene muchos datos. En la U3 aparecen los diccionarios para armar registros, el CSV procesado con `split` y `strip`, y el JSON de la biblioteca estándar con `json.load` y `json.dump`: la misma agenda, con formato de intercambio real.

## Errores comunes y trampas (repaso general)

| Error | Causa | Solución |
|---|---|---|
| `open()` sin `encoding="utf-8"` | Usa la codificación del sistema; la ñ queda como byte `0xf1` y la relectura lanza `UnicodeDecodeError`. | Siempre `encoding="utf-8"` en toda apertura. |
| Comparar líneas recién leídas | Cada línea conserva el `\n` (`repr` → `'Ana\n'`). | `.strip()` al leer, antes de usar. |
| `split(",")` sin `strip()` | Quedan espacios: a `int` no le importa, a las comparaciones de texto sí. | `.strip()` en cada campo. |
| Líneas vacías sin filtrar | `"".split(",")` devuelve `['']`: registro fantasma de un campo. | `if linea.strip() == "": continue`. |
| Abrir con `"w"` queriendo agregar | `"w"` trunca: tras dos escrituras queda solo la última. | `"a"` agrega; `"w"` reescribe todo. |
| `except:` desnudo | Oculta el error real y el programa sigue roto sin decir por qué. | Excepciones específicas siempre. |
| Lógica suelta fuera de funciones | Al importar, el código a nivel de módulo se ejecuta igual. | Esqueleto canónico completo. |
| Entregar sin push | El commit local no publica: en GitHub no hay nada. | `git push` y verificar el repositorio en el navegador. |
