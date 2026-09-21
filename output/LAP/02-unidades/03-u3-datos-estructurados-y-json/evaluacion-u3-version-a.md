# Evaluación de la Unidad 3 — Versión A: gestión de notas

## Metadatos

| Campo | Valor |
|---|---|
| Versión | A |
| Dominio de datos | Gestión de notas |
| Instancia | Evaluación de la Unidad 3 — Encuentro dedicado 26 |
| Duración | 120 minutos (desarrollo, entrega y defensa) |
| Destinatarios | Grupo con la versión A asignada |
| Entrega | Carpeta `evaluacion-u3/` del repositorio del grupo: `notas_json.py` + `notas.json` |
| Aprobación | 60 puntos o más de 100 (rúbrica de la consigna maestra) y defensa individual apta |

## Consigna

Desarrollar `evaluacion-u3/notas_json.py` en el repositorio del grupo: un programa de consola con menú que persiste las notas en el archivo de datos `notas.json` (junto al `.py`, creado y leído por el propio programa). Cada registro es un diccionario con las claves `alumno` (texto), `materia` (texto) y `nota` (entero).

1. Cargar la colección al abrir desde `notas.json`. Sin archivo: empezar con la colección vacía, sin error. Archivo dañado a mano: avisar y terminar con código de salida 1.
2. Ofrecer un menú con las opciones:
   - `1` Alta de nota: pedir alumno (obligatorio: rechazar el campo vacío y volver a pedir), materia y nota entera (con reingreso ante valor inválido); agregar el registro y guardar la colección completa.
   - `2` Listado: listado numerado de todos los registros.
   - `3` Búsqueda por alumno: coincidencia exacta sin distinguir mayúsculas de minúsculas.
   - `4` Filtro por nota mínima: pedir la nota mínima, mostrar los registros con nota mayor o igual y exportarlos a `resultado.json`, sin modificar `notas.json`.
   - `0` Salir: guardar la colección completa en `notas.json` y terminar.
3. Toda lectura y escritura con `with open(ruta, modo, encoding="utf-8")` y `json.dump(..., ensure_ascii=False, indent=2)` en toda escritura JSON.
4. Opción de menú convertida con `int()` dentro de `try/except ValueError`, con reingreso.
5. Excepciones específicas siempre; sin `traceback` en situaciones previstas; un comentario por acción; identificadores y mensajes en español, sin tildes ni eñes dentro del código.

## Requisitos técnicos (canon de la materia)

- Esqueleto canónico: `import json` e `import sys` solo, constantes (`RUTA_DATOS`, `RUTA_RESULTADO`, texto del menú), funciones con `def`, `def main():` y guard al final.
- Carga segura: `except FileNotFoundError` → `[]`; `except json.JSONDecodeError` → aviso y `sys.exit(1)`.
- `json.dump(..., ensure_ascii=False, indent=2)` en toda escritura; guardado en cada alta y al salir.
- Excepciones específicas siempre; sin `except:` desnudo.
- Sin clases, sin librerías externas, sin módulos propios, sin comprensiones anidadas.

## Pruebas mínimas

- Primera corrida sin `notas.json`: arranque vacío sin error.
- `notas.json` dañado a mano: aviso y salida con código 1.
- Ciclo completo: alta, listar, buscar (probando mayúsculas y minúsculas), filtro con exportación y verificación de que `notas.json` queda intacto tras exportar.

## Entrega

```bash
git add .
git commit -m "evaluacion-u3: entrega de la version A"
git push
```

Verificar en GitHub que `evaluacion-u3/notas_json.py` quedó publicado con el último commit. Los archivos de datos (`notas.json`, `resultado.json`) los genera el propio programa: entregarse solo como evidencia de las pruebas, nunca editados a mano.

## Defensa individual

Cada integrante explica, sin leer y en no más de tres minutos:

1. Por qué el registro es un diccionario y no una lista de campos.
2. Las dos excepciones de la carga y qué hace el programa en cada caso (mostrar el archivo dañado).
3. Cómo el filtro exporta a `resultado.json` sin pisar `notas.json` (mostrar ambos archivos).

## Checklist antes de entregar

- [ ] Esqueleto canónico completo: imports justos, constantes, funciones, `main()` y guard.
- [ ] Tres caminos de carga probados: sin archivo, normal, archivo dañado (aviso + código 1).
- [ ] Alta con nombre obligatorio y guardado de la colección en cada alta.
- [ ] Búsqueda sin distinguir mayúsculas; filtro exporta a `resultado.json` sin tocar `notas.json`.
- [ ] `ensure_ascii=False` e `indent=2` en toda escritura JSON; guardado al salir.
- [ ] Opción de menú bajo `try/except ValueError` con reingreso.
- [ ] Mensajes y comentarios en español, sin tildes ni eñes en el código.
- [ ] `commit` y `push` hechos y verificados en GitHub.
