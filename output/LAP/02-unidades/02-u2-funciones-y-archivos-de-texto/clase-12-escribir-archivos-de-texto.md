# Encuentro 12: Escribir archivos de texto

## Datos del encuentro

| Campo | Valor |
|---|---|
| Unidad | U2: Funciones y archivos de texto |
| Encuentro | 12 de 20 |
| Duración | 120 minutos |
| Carácter | Procedimental |

## Objetivos de aprendizaje

- Escribir el archivo completo con el modo `"w"` y agregar al final con el modo `"a"`.
- Armar cada línea con concatenación de campos y `\n` final, convirtiendo los números con `str()`.
- Distinguir cuándo corresponde `"w"` (reescribir todo) y cuándo `"a"` (agregar uno).
- Verificar los datos escritos abriendo el archivo tras cada corrida.

## Reparto de tiempos (120 minutos)

| Bloque | Minutos |
|---|---|
| Apertura y motivación | 10 |
| Desarrollo teórico-práctico | 60 |
| Consolidación y cierre | 20 |
| Actividad complementaria | 30 |

## Charla rápida

Escribir en el archivo es anotar en el cuaderno de la agenda, y hay dos maneras. El modo `"w"` es arrancar de una hoja nueva: lo que había desaparece. El modo `"a"` es agregar al final de la página actual: lo que había sigue. La regla de oro de la unidad: `"w"` escribe todo de nuevo, `"a"` pega uno al final. Elegir el modo equivocado no da error de sintaxis: da una agenda con contactos perdidos, que es peor.

## Teoría mínima

### Modo `"w"`: reescribe todo el archivo

Abre (crea el archivo si no existe) y **borra lo que había**. Verificado en el spike del curso: tras dos escrituras con `"w"` queda solo la última. Para escribir un número, primero `str()`:

```python
def guardar_contactos(contactos):
    # Sobrescribir el archivo con la lista completa, una linea por contacto.
    with open(RUTA_DATOS, "w", encoding="utf-8") as f:
        for contacto in contactos:
            linea = contacto[0] + "," + contacto[1] + "," + str(contacto[2]) + "\n"
            f.write(linea)
```

`write` no agrega el salto de renglón solo: sin el `"\n"` final, toda la agenda queda en una sola línea.

### Modo `"a"`: agrega al final

```python
with open(RUTA_DATOS, "a", encoding="utf-8") as f:
    f.write("Nueva,1111,20\n")
```

El archivo se crea si no existe y lo anterior no se toca. Es el modo natural para registrar un alta.

### Mensajes claros con `try/except`

Toda escritura relevante informa su resultado; toda conversión arriesgada va dentro de su `try` con la excepción específica. Nunca `except:` desnudo, y al alumno nunca le llega un traceback de una situación prevista.

### Verificar los datos

Tras cada corrida, abrir el `contactos.txt` en VS Code (o `type contactos.txt` en la terminal) para confirmar qué quedó escrito. El programa «parece que funcionó» no es evidencia: el archivo es la evidencia.

## Práctica guiada: la agenda aprende a guardar

**Paso 1:** agregar la función `guardar_contactos` (la del modo `"w"` de la teoría) junto a las demás funciones.

**Paso 2:** agregar la opción `6) Guardar ahora` al menú:

```python
        elif opcion == "6":
            guardar_contactos(contactos)
            print("Agenda guardada en", RUTA_DATOS)
```

**Paso 3:** hacer que la salida guarde automáticamente:

```python
        elif opcion == "0":
            guardar_contactos(contactos)
            print("Agenda guardada en", RUTA_DATOS)
            break
```

**Paso 4:** probar el ciclo completo: alta de dos contactos, opción 6, y abrir `contactos.txt` para verificar. Salida esperada en el archivo:

```
Ana,4567,23
Luis,7890,35
```

**Paso 5:** probar la regla de oro con dos experimentos:

1. Dar de alta un contacto y salir (guarda con `"w"`): al reabrir, está todo.
2. Volver a guardar dos veces seguidas: no se duplica nada, porque `"w"` reescribe siempre el conjunto completo.

**Paso 6:** corregir una edad inválida en la carga de datos: verificar que `pedir_edad()` avisa «Debe ingresar un numero valido» y reintenta, sin traceback.

## Ejercicio independiente: alta que escribe al toque

Agregar la función `agregar_al_archivo(contacto)` que agregue un solo contacto al final del archivo con modo `"a"`, y hacer que la opción 1 del menú la llame después del `append`, con su mensaje de confirmación.

**Pista:** mismo armado de línea que en `guardar_contactos`, pero sin `for`: es un solo contacto. La diferencia entre ambas funciones está en el modo, no en el formato.

**Solución esperada:**

```python
def agregar_al_archivo(contacto):
    # Agregar un contacto al final del archivo sin borrar lo anterior.
    with open(RUTA_DATOS, "a", encoding="utf-8") as f:
        linea = contacto[0] + "," + contacto[1] + "," + str(contacto[2]) + "\n"
        f.write(linea)
```

Y en el menú:

```python
        if opcion == "1":
            contacto = pedir_contacto()
            contactos.append(contacto)
            agregar_al_archivo(contacto)
            print("Contacto agregado a", RUTA_DATOS)
```

## Actividad complementaria

Sobre la extensión de la unidad: validar el teléfono antes de aceptar el alta. Escribir `pedir_telefono()` que repita el `input()` mientras el texto esté vacío o tenga menos de 6 caracteres, e integrarla en `pedir_contacto()` junto a `pedir_nombre()` del Encuentro 10. Probar el caso de error: teléfono vacío no entra ni a la lista ni al archivo.

## Rutina de cierre (git)

```bash
git add .
git commit -m "tp-u2: guardado en archivo con modos w y a"
git push
```

## Cierre

**Qué te llevas:** `"w"` reescribe todo el archivo; `"a"` agrega al final; el formato de línea es campos con coma y `"\n"` final, con `str()` para los números. El archivo verificado después de correr es la prueba real de que funcionó.

**Lo que viene:** la agenda ya carga y guarda, pero no sabe sacar un contacto. En el Encuentro 13 se cierra el ciclo: eliminar en memoria, reescribir el archivo y dejar el programa completo en un solo `.py`.

## Errores comunes y trampas

| Error | Causa | Solución |
|---|---|---|
| Abrir con `"w"` queriendo agregar | `"w"` trunca: tras dos escrituras queda solo la última. | `"a"` para agregar; `"w"` solo para reescribir todo. |
| `write` sin `"\n"` final | `write` no agrega el salto de renglón: toda la agenda queda en una línea. | Concatenar `"\n"` al final de cada línea. |
| Olvidar `str()` en la edad | Concatenar un `int` con texto lanza `TypeError`. | `str(contacto[2])` antes de concatenar. |
| Asumir que guardó sin verificar | El programa no avisa o el mensaje pasa desapercibido. | Abrir el `.txt` tras cada corrida (`type contactos.txt`). |
| `except:` desnudo rodeando la escritura | Oculta el error real y el programa sigue roto sin decir por qué. | Excepciones específicas; si no hay error previsto, sin `try`. |
| Guardar con `"a"` en la opción 6 | El archivo crece con la agenda completa cada vez que se guarda. | `"a"` es para un registro; la agenda completa va con `"w"`. |
