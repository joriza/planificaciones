# Evaluación de la Unidad 2 — Versión B: inventario de productos

## Metadatos

| Campo | Valor |
|---|---|
| Versión | B |
| Dominio de datos | Inventario de productos |
| Instancia | Evaluación de la Unidad 2 — Encuentro dedicado 15 |
| Duración | 120 minutos (desarrollo, entrega y defensa) |
| Destinatarios | Grupo con la versión B asignada |
| Entrega | Carpeta `evaluacion-u2/` del repositorio del grupo: `registro_productos.py` + `productos.txt` |
| Aprobación | 60 puntos o más de 100 (rúbrica de la consigna maestra) y defensa individual apta |

## Consigna

Desarrollar `evaluacion-u2/registro_productos.py` en el repositorio del grupo: un programa de consola con menú que persiste el inventario en el archivo de datos `productos.txt` (junto al `.py`, creado y leído por el propio programa; formato: una línea por registro con `producto,rubro,stock`).

1. Al abrir, cargar los productos desde `productos.txt` a memoria. Si el archivo no existe, avisar «No existe el archivo de datos: se empieza de cero» y arrancar con la colección vacía.
2. Ofrecer un menú con las opciones:
   - `1` Agregar un producto: pedir nombre, rubro y stock entero (con reingreso ante valor inválido); agregar el registro a memoria y la línea al archivo con modo `"a"`.
   - `2` Listar los productos: listado numerado desde memoria.
   - `3` Buscar por producto: coincidencia exacta del nombre; mostrar todas las coincidencias o el aviso correspondiente.
   - `4` Stock promedio por producto: promedio de todos los stocks guardados; con la colección vacía, informar 0 y avisar.
   - `5` Eliminar por producto: quitar de memoria todos los registros de ese producto y reescribir el archivo completo con modo `"w"`.
   - `0` Salir.
3. Toda lectura y escritura con `with open(ruta, modo, encoding="utf-8")`.
4. Al leer: `.strip()` en cada línea y campo, filtrado de líneas vacías y conversión del stock con `int()` bajo `try/except ValueError`.
5. Excepciones específicas siempre; sin `traceback` en situaciones previstas; un comentario por acción; identificadores y mensajes en español, sin tildes ni eñes dentro del código.

## Requisitos técnicos (canon de la materia)

- Esqueleto canónico: constantes (`RUTA_DATOS`, texto del menú), funciones con `def` (una por operación), `def main():` y guard al final.
- Modos de archivo correctos: `"a"` en el alta, `"w"` en la eliminación, `"r"` en la carga.
- `FileNotFoundError` capturado con el mensaje canónico de primera corrida.
- Excepciones específicas siempre; sin `except:` desnudo.
- Sin clases, sin librerías externas, sin módulos propios.

## Pruebas mínimas

- Primera corrida sin `productos.txt`: aviso canónico y arranque vacío.
- Ciclo completo: alta, listar, buscar, stock promedio, eliminar y verificar el contenido de `productos.txt` tras cada operación.
- Error de entrada: una letra donde va el stock (el programa vuelve a pedir).

## Entrega

```bash
git add .
git commit -m "evaluacion-u2: entrega de la version B"
git push
```

Verificar en GitHub que `evaluacion-u2/registro_productos.py` quedó publicado con el último commit. El archivo `productos.txt` es un archivo de datos generado por el programa: entregarse solo si el grupo lo considera evidencia de las pruebas.

## Defensa individual

Cada integrante explica, sin leer y en no más de tres minutos:

1. Qué hace el programa, mostrando una alta y un listado.
2. Qué modo de apertura usa cada operación y por qué.
3. Qué ocurre la primera vez, sin archivo de datos (mostrarlo en vivo).

## Checklist antes de entregar

- [ ] Esqueleto canónico completo: constantes, funciones por operación, `main()` y guard.
- [ ] `with open(..., encoding="utf-8")` en toda apertura; modos `"r"`, `"a"` y `"w"` correctos.
- [ ] `FileNotFoundError` con el mensaje canónico de primera corrida.
- [ ] `.strip()` por línea y por campo; líneas vacías filtradas; stock convertido bajo `try/except ValueError`.
- [ ] Stock promedio protegido con la colección vacía.
- [ ] Mensajes y comentarios en español, sin tildes ni eñes en el código.
- [ ] `commit` y `push` hechos y verificados en GitHub.
