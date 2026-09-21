# Encuentro 25 — Cierre U3: repaso y TP

## Metadatos de bloque

| Campo | Valor |
|---|---|
| **Duración** | 120 minutos |
| **Unidad** | 3 — Datos estructurados y JSON |
| **Tipo** | Actitudinal |
| **Estructura** | Cierre de unidad |
| **Requiere** | Encuentros 21 a 24 completos: dicts y registros, CSV a mano, JSON con la stdlib, comparación de formatos y filtros. Repositorio del grupo con `push` funcionando. |
| **Nuevo concepto** | Sistematización de la unidad; el TP-U3 como integración: `TP-U3: datos en JSON`, con entrega por GitHub |
| **Entrega** | TP-U3 al cierre del encuentro: carpeta `tp-u3/`, commits y `push`; devolución al inicio del encuentro 27 |

## Reparto de tiempos (120 minutos)

| Bloque | Duración |
|---|---|
| Apertura y motivación | 10 min |
| Desarrollo teórico-práctico | 70 min |
| Consolidación y cierre | 25 min |
| Actividad complementaria | 15 min |

## Objetivos de aprendizaje

- Sistematizar los contenidos de la unidad: dicts y registros, CSV a mano, JSON con la stdlib y elección de formato.
- Integrar los contenidos de la unidad en un único programa (TP-U3) que cumple el canon técnico completo.
- Entregar el trabajo por GitHub: carpeta `tp-u3/`, commits con mensaje claro y `push` a `main`.
- Autoevaluar el propio trabajo con la lista de verificación antes de entregar.

## Apertura y motivación

Repaso rápido dirigido (tres preguntas, tres minutos): ¿por qué un registro se representa con un dict y no con una lista de campos? ¿Qué dos excepciones específicas puede lanzar la carga de `agenda.json` y qué hace el programa en cada caso? ¿Por qué `json.dump` lleva `ensure_ascii=False` e `indent=2`? Con eso sobre la mesa, el resto del encuentro es el TP-U3: la agenda que se viene construyendo desde el encuentro 21, integrada en un solo programa y entregada por GitHub.

## Teoría mínima

### La unidad en una tabla

| Encuentro | Aporte a la agenda |
|---|---|
| 21 — Diccionarios y registros | El contacto como dict; la agenda como lista de dicts en memoria; alta, listado y búsqueda |
| 22 — CSV plano a mano | Persistencia con `split`/`strip`/`join`; `FileNotFoundError` → arrancar vacía; `"w"` reescribe todo |
| 23 — JSON con la stdlib | `json.load`/`json.dump` con `ensure_ascii=False` e `indent=2`; `JSONDecodeError` → aviso y `sys.exit(1)` |
| 24 — TXT, CSV o JSON | Comparación con criterios; migración; búsquedas y filtros combinados |

### Consigna del TP-U3: datos en JSON

Un único archivo `agenda.py` en la carpeta `tp-u3/` del repositorio del grupo, con `agenda.json` como archivo de datos creado por el propio programa. El programa ofrece un menú con estas opciones:

1. **Alta** de contacto (nombre obligatorio, teléfono, correo).
2. **Listado** completo numerado.
3. **Búsqueda** por nombre exacto (sin distinguir mayúsculas).
4. **Filtro combinado**: texto en el nombre y/o dominio del correo; muestra el resultado y lo exporta a `resultado.json` sin tocar `agenda.json`.
0. **Salir**, guardando la colección en `agenda.json`.

Requisitos técnicos (canon de la materia):

- Esqueleto fijo: `import` solo de lo usado (`json`, `sys`), constantes en `MAYUSCULAS_CON_GUIONES_BAJOS`, funciones con `def`, `def main():` y guard `if __name__ == "__main__":`.
- Toda lectura y escritura con `with open(ruta, modo, encoding="utf-8")`.
- Carga segura: `except FileNotFoundError` → lista vacía; `except json.JSONDecodeError` → aviso «El archivo de datos esta corrupto.» y `sys.exit(1)`.
- Opción de menú convertida con `int()` dentro de `try`/`except ValueError`; sin `traceback` en los casos previstos.
- Excepciones siempre específicas; un comentario por cada acción del código; identificadores y mensajes en español, sin tildes dentro del código.
- Prohibido: clases, librerías externas, comprensiones anidadas, `except:` desnudo.

### Ejercicio progresivo: el TP-U3 en tres etapas

Ejercicio único del encuentro, en la carpeta `tp-u3/`:

1. **Etapa 1 — Base persistente** (en el desarrollo teórico-práctico): copiar la agenda JSON del encuentro 23 con carga segura y guardado; correr los tres caminos (sin archivo, normal, archivo dañado).
2. **Etapa 2 — Menú completo** (en el desarrollo teórico-práctico): alta, listado y búsqueda del encuentro 24, más la validación del nombre vacío; guardar en cada alta y al salir.
3. **Etapa 3 — Filtro combinado y entrega** (en la consolidación y cierre): opción 4 con filtro combinado y exportación a `resultado.json`; justificación de la elección de formato como comentario inicial; entrega por GitHub.

## Consolidación y cierre

- Lista de verificación antes de entregar (marcar cada ítem probándolo, no leyéndolo):
  - [ ] `python agenda.py` corre desde la terminal sin `traceback`.
  - [ ] Primera corrida sin `agenda.json`: arranca vacía y avisa.
  - [ ] `agenda.json` dañado a mano: aviso y salida ordenada con código 1.
  - [ ] Alta con nombre vacío: rechazada con mensaje.
  - [ ] Filtro combinado exporta `resultado.json` y `agenda.json` queda intacto.
  - [ ] El archivo tiene comentarios por acción y no lleva tildes ni eñes en el código.
- Entrega por GitHub, dentro de `tp-u3/`:
  ```bash
  git add .
  git commit -m "tp-u3: agenda con persistencia json y filtros"
  git push
  ```
- La entrega queda registrada al cierre de este encuentro; la corrección y devolución se presentan al inicio del encuentro 27.
- Próxima unidad: la Unidad 4 retoma la persistencia en JSON de esta agenda y la lleva a un proyecto integrador en equipo, con Git profesional (issues, ramas, pull requests).

## Actividad complementaria

- Extensión para quienes entregaron: opción de menú que informe cuántos contactos usan cada dominio de correo presente en la agenda.
- Extensión: aviso de correo duplicado en el alta, con la comparación en minúsculas del encuentro 23.

## Errores comunes

| Error | Causa | Corrección |
|---|---|---|
| El commit quedó local y no se entregó | Falta el `git push` después del `commit` | Verificar en GitHub que `tp-u3/agenda.py` esté visible antes de irse. |
| `agenda.json` se entrega editado a mano | Se armó el archivo fuera del programa | Borrarlo y regenerarlo corriendo el programa: los datos los crea el propio `agenda.py`. |
| `traceback` en la primera corrida | Falta el `except FileNotFoundError` de la carga | Probar borrando el archivo de datos antes de entregar. |
| El filtro combinado pisa la agenda | Exportar a `agenda.json` en vez de `resultado.json` | Archivos de entrada y salida distintos; verificar con `type` ambos archivos. |
| Tildes o eñes en el código | Mensajes o comentarios copiados de la prosa | El código no lleva tildes ni eñes; la prosa de los documentos, sí. |
| Opciones de menú que no validan la conversión | `int(input())` sin `try`/`except ValueError` | Una letra en el menú no puede romper el programa: convertir y reintentar. |
