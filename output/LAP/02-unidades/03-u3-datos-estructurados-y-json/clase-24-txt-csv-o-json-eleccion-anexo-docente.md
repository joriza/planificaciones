# Encuentro 24 — Anexo docente: TXT, CSV o JSON: elección

## Resumen de la clase

| Bloque | Duración | Actividad |
|---|---|---|
| Apertura y motivación | 10 min | Mostrar `agenda.txt` (U2), `agenda.csv` (E22) y `agenda.json` (E23) con el mismo dato. Plantear la pregunta de la elección con criterios. |
| Desarrollo teórico-práctico | 60 min | Teoría: tabla comparativa y migración con `migrar_agenda.py` (25 min). Etapa 1 y Etapa 2 de `agenda_filtros.py` (35 min). |
| Consolidación y cierre | 20 min | Correr la migración frente al grupo, revisar justificaciones escritas de elección, commit de cierre. |
| Actividad complementaria | 30 min | Etapa 3: filtro combinado, exportación a `resultado.json` y justificación de la elección de formato. Desafíos: negación y contador por dominio. |

## Preparación previa

- VS Code y terminal abiertos; `python --version` en 3.11.
- Tener los tres archivos con el mismo dato proyectables: `agenda.txt` (de la carpeta tp-u2 de ejemplo), `agenda.csv` y `agenda.json`.
- Tener `migrar_agenda.py` y `agenda_filtros.py` resueltos (versiones de este anexo).
- Tener el `agenda.json` del encuentro 23 intacto: la migración y los filtros no deben alterarlo.

## Solución completa del ejemplo

`migrar_agenda.py`:

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

## Soluciones del ejercicio progresivo

### Etapa 1 — Filtro por nombre parcial

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

Opción de menú:

```python
        elif opcion == 4:
            texto = input("Texto a buscar en el nombre: ").strip()
            encontrados = filtrar_por_nombre(contactos, texto)
            print("Coincidencias:", len(encontrados))
            listar_contactos(encontrados)
```

### Etapa 2 — Filtro por dominio de correo

```python
def filtrar_por_dominio(contactos, dominio):
    # Devuelve los contactos cuyo correo termina en el dominio.
    resultado = []
    dominio = dominio.lower()
    for contacto in contactos:
        if contacto["correo"].lower().endswith(dominio):
            resultado.append(contacto)
    return resultado
```

### Etapa 3 — Filtros combinados y exportación

```python
def filtrar_combinado(contactos, texto, dominio):
    # Devuelve los contactos que cumplen las dos condiciones.
    resultado = []
    texto = texto.lower()
    dominio = dominio.lower()
    for contacto in contactos:
        nombre_coincide = texto in contacto["nombre"].lower()
        correo_coincide = contacto["correo"].lower().endswith(dominio)
        if nombre_coincide and correo_coincide:
            resultado.append(contacto)
    return resultado
```

Opción de menú con exportación (el JSON de la agenda no se toca):

```python
        elif opcion == 6:
            texto = input("Texto en el nombre (Enter = cualquiera): ").strip()
            dominio = input("Dominio del correo (Enter = cualquiera): ").strip()
            if texto == "" and dominio == "":
                print("Debe ingresar al menos un criterio.")
            else:
                if texto == "":
                    encontrados = filtrar_por_dominio(contactos, dominio)
                elif dominio == "":
                    encontrados = filtrar_por_nombre(contactos, texto)
                else:
                    encontrados = filtrar_combinado(contactos, texto, dominio)
                print("Coincidencias:", len(encontrados))
                listar_contactos(encontrados)
                with open("resultado.json", "w", encoding="utf-8") as f:
                    json.dump(encontrados, f, ensure_ascii=False, indent=2)
                print("Resultado exportado a resultado.json")
```

Justificación de la elección (comentario inicial del archivo, ejemplo):

```python
# Eleccion de formato: JSON.
# Motivos: guarda la coleccion completa con claves con nombre, conserva la
# estructura de memoria y se carga con una sola llamada (json.load).
# El CSV queda para intercambio tabular simple y el TXT para texto libre.
```

### Desafíos de la actividad complementaria

Negación del dominio:

```python
def filtrar_dominio_distinto(contactos, dominio):
    # Devuelve los contactos cuyo correo NO termina en el dominio.
    resultado = []
    dominio = dominio.lower()
    for contacto in contactos:
        if not contacto["correo"].lower().endswith(dominio):
            resultado.append(contacto)
    return resultado
```

Contador por dominio:

```python
def contar_dominios(contactos):
    # Muestra cuantos contactos usan cada dominio presente en la agenda.
    dominios = []
    for contacto in contactos:
        correo = contacto["correo"].lower()
        if "@" in correo:
            dominio = correo[correo.index("@"):]
            if dominio not in dominios:
                dominios.append(dominio)
    for dominio in dominios:
        print(dominio, "-", len(filtrar_por_dominio(contactos, dominio)))
```

## Errores anticipados y corrección

| Error esperado | Dónde aparece | Corrección en clase |
|---|---|---|
| Filtro que devuelve `None` | Etapa 1, cuando no hay coincidencias | Faltaría el `return resultado` final; la lista vacía `[]` es un resultado válido y el listado avisa. |
| Agenda original alterada por el filtro | Etapa 1-2, con `remove` o reasignación | Insistir: filtrar es **leer**; el resultado es una lista nueva. |
| `resultado.json` exportado sobre `agenda.json` | Etapa 3 | Salida y entrada son archivos distintos; verificar con `type` que la agenda sigue completa. |
| Dominio sin arroba filtra de más | Etapa 2, `"gmail"` con `endswith` | El dominio completo es `"@gmail.com"`; mostrar un caso de falso positivo. |
| Migración corre dos veces y «pierde» datos | `agenda.csv` viejo pisa un `agenda.json` más nuevo | La migración va de CSV a JSON una sola vez; después, la fuente de verdad es el JSON. |
| Justificación por gusto («JSON es más lindo») | Etapa 3, comentario inicial | Exigir criterios de la tabla: estructura, tipos, esfuerzo de código, herramientas que lo leen. |
| `FileNotFoundError` sin mensaje en la migración | Corrida sin `agenda.csv` | El aviso y `sys.exit(1)` están en la demo; completarlos si el grupo partió de cero. |

## Observación en el aula

- Verificar que cada filtro devuelva una lista nueva y que `agenda.json` quede intacto tras las corridas.
- Verificar el uso de `.lower()` en ambos lados de todas las comparaciones de texto.
- Verificar que la exportación use `ensure_ascii=False, indent=2` y `encoding="utf-8"`.
- Leer al menos dos justificaciones escritas por grupo: el criterio técnico es parte del objetivo del encuentro.

## Preparación del próximo encuentro

- Los archivos `agenda_filtros.py` resueltos son material de repaso para el encuentro 25.
- Tener la consigna del TP-U3 impresa o proyectada (está en la clase del encuentro 25).
