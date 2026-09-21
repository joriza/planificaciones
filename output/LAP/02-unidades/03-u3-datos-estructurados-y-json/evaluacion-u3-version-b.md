# Evaluación de la Unidad 3 — Versión B: inventario de productos

## Metadatos

| Campo | Valor |
|---|---|
| Versión | B |
| Dominio de datos | Inventario de productos |
| Instancia | Evaluación de la Unidad 3 — Encuentro dedicado 26 |
| Duración | 120 minutos (desarrollo, entrega y defensa) |
| Destinatarios | Grupo con la versión B asignada |
| Entrega | Carpeta `evaluacion-u3/` del repositorio del grupo: `inventario_json.py` + `inventario.json` |
| Aprobación | 60 puntos o más de 100 (rúbrica de la consigna maestra) y defensa individual apta |

## Consigna

Desarrollar `evaluacion-u3/inventario_json.py` en el repositorio del grupo: un programa de consola con menú que persiste el inventario en el archivo de datos `inventario.json` (junto al `.py`, creado y leído por el propio programa). Cada registro es un diccionario con las claves `producto` (texto), `rubro` (texto) y `stock` (entero).

1. Cargar la colección al abrir desde `inventario.json`. Sin archivo: empezar con la colección vacía, sin error. Archivo dañado a mano: avisar y terminar con código de salida 1.
2. Ofrecer un menú con las opciones:
   - `1` Alta de producto: pedir producto (obligatorio: rechazar el campo vacío y volver a pedir), rubro y stock entero (con reingreso ante valor inválido); agregar el registro y guardar la colección completa.
   - `2` Listado: listado numerado de todos los registros.
   - `3` Búsqueda por producto: coincidencia exacta sin distinguir mayúsculas de minúsculas.
   - `4` Filtro por stock máximo: pedir el stock máximo, mostrar los productos con stock menor o igual (a reponer) y exportarlos a `resultado.json`, sin modificar `inventario.json`.
   - `0` Salir: guardar la colección completa en `inventario.json` y terminar.
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

- Primera corrida sin `inventario.json`: arranque vacío sin error.
- `inventario.json` dañado a mano: aviso y salida con código 1.
- Ciclo completo: alta, listar, buscar (probando mayúsculas y minúsculas), filtro con exportación y verificación de que `inventario.json` queda intacto tras exportar.

## Entrega

```bash
git add .
git commit -m "evaluacion-u3: entrega de la version B"
git push
```

Verificar en GitHub que `evaluacion-u3/inventario_json.py` quedó publicado con el último commit. Los archivos de datos (`inventario.json`, `resultado.json`) los genera el propio programa: entregarse solo como evidencia de las pruebas, nunca editados a mano.

## Defensa individual

Cada integrante explica, sin leer y en no más de tres minutos:

1. Por qué el registro es un diccionario y no una lista de campos.
2. Las dos excepciones de la carga y qué hace el programa en cada caso (mostrar el archivo dañado).
3. Cómo el filtro exporta a `resultado.json` sin pisar `inventario.json` (mostrar ambos archivos).

## Checklist antes de entregar

- [ ] Esqueleto canónico completo: imports justos, constantes, funciones, `main()` y guard.
- [ ] Tres caminos de carga probados: sin archivo, normal, archivo dañado (aviso + código 1).
- [ ] Alta con producto obligatorio y guardado de la colección en cada alta.
- [ ] Búsqueda sin distinguir mayúsculas; filtro exporta a `resultado.json` sin tocar `inventario.json`.
- [ ] `ensure_ascii=False` e `indent=2` en toda escritura JSON; guardado al salir.
- [ ] Opción de menú bajo `try/except ValueError` con reingreso.
- [ ] Mensajes y comentarios en español, sin tildes ni eñes en el código.
- [ ] `commit` y `push` hechos y verificados en GitHub.
