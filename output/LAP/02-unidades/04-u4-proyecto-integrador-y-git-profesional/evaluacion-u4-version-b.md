# Evaluación de la Unidad 4 — Versión B: inventario de productos (gestor de pedidos)

## Metadatos

| Campo | Valor |
|---|---|
| Versión | B |
| Dominio de datos | Inventario de productos: gestor de pedidos de insumos |
| Instancia | Evaluación de la Unidad 4 — Encuentro dedicado 32 |
| Asignación | Al inicio de la Unidad 4 (Encuentro 27), al definir los issues del proyecto |
| Desarrollo | Encuentros 27 a 31, con flujo issue → rama → PR |
| Duración de la instancia | 120 minutos (verificación, entrega final y defensa) |
| Destinatarios | Grupo con la versión B asignada |
| Entrega | `trabajo-final/pedidos.py` + `pedidos.json` + sección del proyecto en el README; `main` al día con push |
| Aprobación | 60 puntos o más de 100 (rúbrica de la consigna maestra) y defensa individual apta |

## Consigna

Desarrollar el proyecto integrador del grupo: un gestor de pedidos de insumos, en `trabajo-final/pedidos.py`, con persistencia en `pedidos.json` (junto al `.py`, creado y leído por el propio programa). Cada registro es un diccionario con las claves `producto` (texto), `sector` (texto), `fecha` (texto ISO `AAAA-MM-DD`) y `recibido` (booleano, `False` en el alta).

1. Ofrecer un menú con las opciones:
   - `1` Registrar un pedido: pedir producto, sector y fecha, ninguno vacío (rechazar el campo vacío y volver a pedir); agregar el registro con `recibido` en `False` y guardar la colección completa.
   - `2` Listar pedidos: listado numerado mostrando cada registro y su estado de recepción.
   - `3` Buscar por producto: coincidencia sin distinguir mayúsculas de minúsculas.
   - `4` Registrar recepción: marcar como recibido el primer pedido pendiente del producto indicado y guardar el cambio.
   - `0` Salir: guardar la colección completa y terminar.
2. Cargar la colección al abrir desde `pedidos.json`. Sin archivo: empezar con la colección vacía, sin error. Archivo dañado a mano: avisar y terminar con código de salida 1.
3. Toda lectura y escritura con `with open(ruta, modo, encoding="utf-8")` y `json.dump(..., ensure_ascii=False, indent=2)` en toda escritura JSON.
4. Opción de menú convertida con `int()` dentro de `try/except ValueError`, con reingreso.
5. Excepciones específicas siempre; sin `traceback` en situaciones previstas; un comentario por acción; identificadores y mensajes en español, sin tildes ni eñes dentro del código.

## Requisitos de Git profesional (comunes a las dos versiones)

- `.gitignore` en la raíz del repositorio, con `__pycache__/`.
- Mínimo cinco issues del proyecto, definidos al iniciar la unidad y todos cerrados al entregar (por ejemplo: núcleo del menú, persistencia JSON, búsquedas y recepción, README, ajustes finales).
- Mínimo cinco ramas `feature/*`, una por issue, con su pull request abierto, revisado y mergeado a `main`.
- `main` protegida: el historial de `main` solo contiene merges de PR.
- README con la sección del proyecto: qué hace, cómo ejecutarlo (instrucciones probadas antes del push) y cómo está construido.
- Cada instrucción publicada en el README debe haberse probado: el README miente si el comando no corre desde la raíz del repositorio.

## Pruebas mínimas

- Primera corrida sin `pedidos.json`: arranque vacío sin error.
- `pedidos.json` dañado a mano: aviso y salida con código 1.
- Ciclo completo: alta, listar, buscar, registrar recepción (verificar que el estado cambia a recibido) y re-corrida conservando los datos.
- Campo vacío en el alta: rechazado con reingreso.

## Entrega

```bash
git switch main
git pull
git add .
git commit -m "trabajo-final: entrega final del integrador"
git push
git status
```

Estado esperado: `nothing to commit, working tree clean`, historial de `main` legible con merges de PR y ningún issue abierto. La entrega queda constituida por ese estado del repositorio: no hay archivos por correo ni pendientes locales.

## Defensa individual

Cada integrante sostiene, sin leer y en no más de cinco minutos, el guion de cuatro puntos del curso: problema y opción del menú, una función, un error previsto, un pull request del historial con lo que dijo la revisión.

## Checklist antes de entregar

- [ ] `python pedidos.py` corre desde su carpeta sin `traceback`.
- [ ] Menú con las cinco opciones y salida limpia.
- [ ] Registro con claves `producto`, `sector`, `fecha` (ISO) y `recibido`.
- [ ] Persistencia en `pedidos.json`: re-corrida conserva los datos.
- [ ] Archivo ausente → arranca vacío; JSON dañado → mensaje y salida con código `1`.
- [ ] Campos vacíos rechazados con reingreso.
- [ ] Issues todos cerrados; `main` solo con merges de PR; README probado.
- [ ] `git status` limpio y push verificado en GitHub.
