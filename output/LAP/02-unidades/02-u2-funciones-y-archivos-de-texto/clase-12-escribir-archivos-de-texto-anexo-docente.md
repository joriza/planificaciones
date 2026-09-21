# Anexo docente — Encuentro 12: Escribir archivos de texto

## Encuadre

Tercer encuentro de la Unidad 2. La agenda ya carga desde el archivo y hoy aprende a escribir: `guardar_contactos()` reescribe todo con modo `"w"` al salir o a pedido, y el ejercicio agrega `agregar_al_archivo()` con modo `"a"` para que cada alta quede registrada al toque. En el ejercicio progresivo único, este es el encuentro en que los datos dejan de perderse: el ciclo abrir → usar → guardar queda completo salvo por la eliminación, que cierra el Encuentro 13.

El eje conceptual del día es la decisión del modo: `"w"` reescribe el conjunto, `"a"` pega un registro. Ese criterio se consolida en el Encuentro 13, cuando eliminar obligue a reescribir.

## Qué observar durante la clase

- Usar `"w"` donde corresponde `"a"` (o al revés): no hay error en pantalla, hay datos perdidos o duplicados. Hacer el experimento de guardar dos veces con `"a"` en la opción 6 para ver el archivo crecer.
- `write` sin `"\n"`: el archivo «funciona» pero la segunda carga revienta o mezcla campos; mostrar el archivo crudo para verlo.
- `TypeError` por concatenar la edad sin `str()`: es el mismo error de tipos de la Unidad 1, ahora en la escritura.
- Alumnos que no verifican el archivo tras correr: exigir la verificación (VS Code o `type contactos.txt`) como parte del paso, no como opcional.
- Mensajes de confirmación ausentes: la escritura exitosa también se informa («Agenda guardada en ...»).

## Solución completa del ejercicio independiente

```python
def agregar_al_archivo(contacto):
    # Agregar un contacto al final del archivo sin borrar lo anterior.
    with open(RUTA_DATOS, "a", encoding="utf-8") as f:
        linea = contacto[0] + "," + contacto[1] + "," + str(contacto[2]) + "\n"
        f.write(linea)
```

Con la opción 1 del menú actualizada:

```python
        if opcion == "1":
            contacto = pedir_contacto()
            contactos.append(contacto)
            agregar_al_archivo(contacto)
            print("Contacto agregado a", RUTA_DATOS)
```

Detalle didáctico: con el alta escribiendo con `"a"` y la salida guardando con `"w"`, el archivo queda siempre correcto: la reescritura total de la salida reemplaza lo que el alta agregó. La trampa aparece si alguien guarda la salida con `"a"`: entonces el contacto dado de alta queda dos veces (una del alta, una del guardado). No corregirlo en silencio: es el argumento que explica por qué la agenda completa se guarda con `"w"`, y la puerta de entrada al Encuentro 13.

## Errores previsibles

1. **Abrir con `"w"` queriendo agregar:** `"w"` trunca el archivo; tras dos escrituras queda solo la última (observado en el spike). Corrección: `"a"` para agregar, `"w"` solo para reescribir todo.
2. **`write` sin `"\n"` final:** los registros quedan pegados en una línea y la próxima carga los lee mal. Corrección: concatenar `"\n"` al final de cada línea.
3. **Concatenar sin `str()`:** `"Ana," + 23` lanza `TypeError`; el archivo guarda texto, siempre. Corrección: `str(contacto[2])`.
4. **`split` de relectura con espacios:** si el archivo quedó escrito con espacios tras la coma (copiado a mano), `split(",")` sin `strip()` deja los espacios. Corrección: mantener el `.strip()` de campo del Encuentro 11 en la carga.
5. **`except:` desnudo:** rodea la escritura, atrapa cualquier error y el programa sigue sin decir por qué. Corrección: excepciones específicas; la escritura local en disco no requiere `try` en este esquema.
6. **Guardar la salida con `"a"`:** el contacto dado de alta con `"a"` queda dos veces en el archivo (una del alta, una del guardado de salida). Con `"w"` no ocurre: la reescritura total reemplaza el archivo entero. Es la transición pensada hacia el Encuentro 13; si aparece, usarse como pregunta y no como corrección silenciosa.

## Criterios de logro (4-8)

| Nivel | Descripción |
|---|---|
| 4 | Escribe algo en el archivo, pero sin `"\n"` o sin `str()`: la relectura falla. |
| 5 | `guardar_contactos` con `"w"` funciona y el archivo se verifica; la opción 6 no informa su resultado. |
| 6 | Guardado automático al salir funcionando; el alta con `"a"` mezcla modos o duplica líneas sin notarlo. |
| 7 | Ambos modos bien elegidos y probados; archivo verificado tras cada corrida; mensajes claros en ambos caminos. |
| 8 | Explica cuándo `"w"` y cuándo `"a"`, y argumenta por qué la salida no puede guardar con `"a"` (el contacto dado de alta quedaría duplicado). |

## Agrupamiento

Individual, en parejas solo si faltan máquinas. La verificación del archivo (`type contactos.txt`) se hace en la propia terminal de cada estudiante.

## Ajustes para la siguiente edición

- Si el experimento de duplicado (alta con `"a"` + salida con `"w"`) desorienta a la mayoría, moverlo al Encuentro 13 como apertura y dejar el alta solo en memoria hasta entonces.
- Si la concatenación de la línea les resulta frágil, escribir en pizarra la línea pieza por pieza (`nombre + "," + telefono + "," + str(edad) + "\n"`) antes de la práctica.
- Si sobra tiempo, anticipar el `promedio_edades` del Encuentro 14 o una opción extra de conteo por ciudad.
