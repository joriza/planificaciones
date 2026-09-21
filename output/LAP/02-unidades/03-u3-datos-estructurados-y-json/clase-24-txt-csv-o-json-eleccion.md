# Encuentro 24 — TXT, CSV o JSON: elección

## Metadatos de bloque

| Campo | Valor |
|---|---|
| **Duración** | 120 minutos |
| **Unidad** | 3 — Datos estructurados y JSON |
| **Tipo** | Procedimental |
| **Requiere** | Encuentros 21 a 23: agenda en memoria (dicts), persistencia CSV y persistencia JSON canónica. `agenda.json` de la clase anterior funcionando. |
| **Nuevo concepto** | Criterios de comparación entre TXT, CSV y JSON; migración de formato; búsquedas y filtros combinados sobre la colección guardada en JSON |

## Reparto de tiempos (120 minutos)

| Bloque | Duración |
|---|---|
| Apertura y motivación | 10 min |
| Desarrollo teórico-práctico | 60 min |
| Consolidación y cierre | 20 min |
| Actividad complementaria | 30 min |

## Objetivos de aprendizaje

- Comparar TXT, CSV y JSON con criterios técnicos: estructura, tipos, legibilidad y esfuerzo de código.
- Migrar la agenda de CSV a JSON con un programa pequeño que lea un formato y escriba el otro.
- Implementar búsquedas y filtros combinados sobre la colección guardada en JSON.
- Fundamentar por escrito la elección de formato para un caso concreto.

## Apertura y motivación

Tres archivos con el mismo dato sobre la mesa: `agenda.txt` de la Unidad 2 (líneas libres, campos por posición), `agenda.csv` del encuentro 22 (una línea por registro, campos por coma) y `agenda.json` del encuentro 23 (la colección completa, con claves). La pregunta de hoy no es «¿cómo se escribe cada uno?» — eso ya se sabe — sino «¿cuándo conviene cada uno?». Primero se comparan con criterios, después se migra el dato al formato elegido y sobre esa colección se construyen búsquedas y filtros combinados.

## Teoría mínima

### Comparación de los tres formatos

| Criterio | TXT (líneas libres) | CSV (a mano) | JSON (stdlib) |
|---|---|---|---|
| Estructura | El programa la decide línea a línea | Tabla: filas y campos por coma | Colección completa con claves |
| Identificación de campos | Por posición, sin nombre | Por posición | Por nombre (clave) |
| Tipos de dato | Todo texto | Todo texto | Texto, número, booleano, `null`, listas y dicts anidados |
| Coma dentro del campo | Sin problema | Rompe el registro | Sin problema |
| Legado y lectura con otras herramientas | Libre | Universal, simple | Universal, formato de intercambio estándar |
| Esfuerzo de código | `split` y posición en cada uso | `split`, `strip`, `join` en cada uso | `json.load` y `json.dump`, una vez |

Consecuencia práctica del canon del curso: en TXT y CSV todo es texto y los booleanos se convienen como `"si"`/`"no"`; en JSON viajan tipos reales (`true`/`false` y de vuelta `True`/`False`). Para colecciones de registros con nombre, JSON es el formato de elección; CSV queda para intercambio tabular simple y TXT para texto libre.

### Migración: leer un formato y escribir el otro

Migrar es un programa pequeño: lee el CSV con lo aprendido en el encuentro 22 y guarda con lo aprendido en el 23. `migrar_agenda.py`:

```python
# Migrar la agenda de CSV a JSON: mismo dato, mejor formato.

import json
import sys

RUTA_CSV = "agenda.csv"
RUTA_JSON = "agenda.json"

def leer_csv(ruta):
    # Lee el CSV y devuelve la lista de contactos como dicts.
    try:
        with open(ruta, "r", encoding="utf-8") as f:
            contactos = []
            for linea in f:
                if linea.strip() == "":
                    continue
                campos = linea.strip().split(",")
                contacto = {"nombre": campos[0].strip(), "telefono": campos[1].strip(), "correo": campos[2].strip()}
                contactos.append(contacto)
            return contactos
    except FileNotFoundError:
        # Sin CSV no hay nada que migrar.
        print("No existe el archivo de datos:", ruta)
        sys.exit(1)

def guardar_json(contactos, ruta):
    # Sobrescribe el JSON con la coleccion completa.
    with open(ruta, "w", encoding="utf-8") as f:
        json.dump(contactos, f, ensure_ascii=False, indent=2)

def main():
    # Leer el CSV y escribir el mismo contenido en JSON.
    contactos = leer_csv(RUTA_CSV)
    guardar_json(contactos, RUTA_JSON)
    print("Migracion lista:", len(contactos), "contactos.")

if __name__ == "__main__":
    main()
```

Salida esperada: `Migracion lista: 2 contactos.` (la cantidad depende del CSV de cada grupo).

## Ejercicio progresivo: filtros sobre la colección en JSON

Ejercicio único de la clase, en un solo archivo `agenda_filtros.py`, que parte de `agenda_json.py` del encuentro 23.

### Etapa 1 — Filtro por nombre parcial (en el desarrollo teórico-práctico)

Agregar `filtrar_por_nombre(contactos, texto)`: devuelve los contactos cuyo nombre **contiene** el texto, sin distinguir mayúsculas. Nueva opción de menú que pide el texto y lista el resultado.

**Pista:** el operador `in` sobre `contacto["nombre"].lower()`; el filtro **devuelve una lista nueva**, no modifica la original.

### Etapa 2 — Filtro por dominio de correo (en el desarrollo teórico-práctico)

Agregar `filtrar_por_dominio(contactos, dominio)`: devuelve los contactos cuyo correo termina en el dominio dado (por ejemplo, `@gmail.com`).

**Pista:** `.endswith()` sobre el correo en minúsculas, con el dominio también en minúsculas.

### Etapa 3 — Filtros combinados y exportación (en la actividad complementaria)

Agregar `filtrar_combinado(contactos, texto, dominio)`: dos condiciones con `and`. La opción de menú exporta el resultado a `resultado.json` con el guardado canónico, sin tocar `agenda.json`. Y la elección fundada: en comentario inicial del archivo, tres líneas que respondan — ¿qué formato elige este grupo para la agenda y por qué?

**Pista:** calcular cada condición en una variable con nombre (`nombre_coincide`, `correo_coincide`) y combinarlas: el `if` queda legible.

## Consolidación y cierre

- Puesta en común: correr `migrar_agenda.py` frente al grupo y comparar `agenda.csv` con `agenda.json` resultante.
- Mostrar dos o tres `resultado.json` y verificar que `agenda.json` original quedó intacto.
- Releer en voz alta dos o tres justificaciones de elección de formato (comentario inicial del archivo): criterio técnico, no gusto.
- Rutina de Git de cierre: `git add .`, `git commit -m "u3: comparacion de formatos y filtros"` y `git push`.
- Próximo encuentro: el 25 cierra la unidad con repaso de dicts, CSV y JSON y la entrega del TP-U3 por GitHub.

## Actividad complementaria

- Terminar la Etapa 3 (filtro combinado, exportación a `resultado.json` y justificación escrita).
- Desafío: opción de menú que liste los contactos cuyo dominio **no** es el preguntado (negación de la condición).
- Desafío: contador por dominio — cuántos contactos usan cada uno de los dominios presentes en la agenda.

## Errores comunes

| Error | Causa | Corrección |
|---|---|---|
| El filtro devuelve `None` en vez de lista | La función no encuentra coincidencias y no llega a `return resultado` | `resultado` arranca como `[]` y se devuelve siempre, con o sin coincidencias. |
| El filtro vacía la agenda | Se hace `contactos.remove(...)` o se reasigna dentro del filtro | El filtro construye y devuelve una lista nueva; la original no se toca. |
| No encuentra nada con mayúsculas mezcladas | Comparar sin normalizar: `"Ana" != "ana"` | `.lower()` en ambos lados, también en el dominio. |
| `agenda.json` queda con el resultado del filtro | Exportar con `RUTA_JSON` en vez de un archivo de salida | El resultado va a `resultado.json`: los archivos de datos de entrada no se pisan. |
| Dominio incompleto que filtra de más | Buscar `"gmail"` con `endswith`: coincide cualquier correo que **termine** en gmail | Usar el dominio completo con su arroba: `"@gmail.com"`. |
| Migración con `FileNotFoundError` sin manejo | Correr `migrar_agenda.py` sin `agenda.csv` | El `except FileNotFoundError` avisa y termina con `sys.exit(1)`: sin datos no hay migración. |
