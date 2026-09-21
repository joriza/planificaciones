# Evaluación de la Unidad 2 — Versión A: gestión de notas

## Metadatos

| Campo | Valor |
|---|---|
| Versión | A |
| Dominio de datos | Gestión de notas (libreta de notas) |
| Instancia | Evaluación de la Unidad 2 — Encuentro dedicado 15 |
| Duración | 120 minutos (desarrollo, entrega y defensa) |
| Destinatarios | Grupo con la versión A asignada |
| Entrega | Carpeta `evaluacion-u2/` del repositorio del grupo: `libreta_notas.py` + `notas.txt` |
| Aprobación | 60 puntos o más de 100 (rúbrica de la consigna maestra) y defensa individual apta |

## Consigna

Desarrollar `evaluacion-u2/libreta_notas.py` en el repositorio del grupo: un programa de consola con menú que persiste las notas en el archivo de datos `notas.txt` (junto al `.py`, creado y leído por el propio programa; formato: una línea por registro con `alumno,materia,nota`).

1. Al abrir, cargar las notas desde `notas.txt` a memoria. Si el archivo no existe, avisar «No existe el archivo de datos: se empieza de cero» y arrancar con la colección vacía.
2. Ofrecer un menú con las opciones:
   - `1` Agregar una nota: pedir alumno, materia y nota entera (con reingreso ante valor inválido); agregar el registro a memoria y la línea al archivo con modo `"a"`.
   - `2` Listar las notas: listado numerado desde memoria.
   - `3` Buscar por alumno: coincidencia exacta del nombre; mostrar todas las coincidencias o el aviso correspondiente.
   - `4` Promedio general: promedio de todas las notas guardadas; con la colección vacía, informar 0 y avisar.
   - `5` Eliminar por alumno: quitar de memoria todas las notas de ese alumno y reescribir el archivo completo con modo `"w"`.
   - `0` Salir.
3. Toda lectura y escritura con `with open(ruta, modo, encoding="utf-8")`.
4. Al leer: `.strip()` en cada línea y campo, filtrado de líneas vacías y conversión de la nota con `int()` bajo `try/except ValueError`.
5. Excepciones específicas siempre; sin `traceback` en situaciones previstas; un comentario por acción; identificadores y mensajes en español, sin tildes ni eñes dentro del código.

## Requisitos técnicos (canon de la materia)

- Esqueleto canónico: constantes (`RUTA_DATOS`, texto del menú), funciones con `def` (una por operación), `def main():` y guard al final.
- Modos de archivo correctos: `"a"` en el alta, `"w"` en la eliminación, `"r"` en la carga.
- `FileNotFoundError` capturado con el mensaje canónico de primera corrida.
- Excepciones específicas siempre; sin `except:` desnudo.
- Sin clases, sin librerías externas, sin módulos propios.

## Pruebas mínimas

- Primera corrida sin `notas.txt`: aviso canónico y arranque vacío.
- Ciclo completo: alta, listar, buscar, promedio, eliminar y verificar el contenido de `notas.txt` tras cada operación.
- Error de entrada: una letra donde va la nota (el programa vuelve a pedir).

## Entrega

```bash
git add .
git commit -m "evaluacion-u2: entrega de la version A"
git push
```

Verificar en GitHub que `evaluacion-u2/libreta_notas.py` quedó publicado con el último commit. El archivo `notas.txt` es un archivo de datos generado por el programa: entregarse solo si el grupo lo considera evidencia de las pruebas.

## Defensa individual

Cada integrante explica, sin leer y en no más de tres minutos:

1. Qué hace el programa, mostrando una alta y un listado.
2. Qué modo de apertura usa cada operación y por qué.
3. Qué ocurre la primera vez, sin archivo de datos (mostrarlo en vivo).

## Checklist antes de entregar

- [ ] Esqueleto canónico completo: constantes, funciones por operación, `main()` y guard.
- [ ] `with open(..., encoding="utf-8")` en toda apertura; modos `"r"`, `"a"` y `"w"` correctos.
- [ ] `FileNotFoundError` con el mensaje canónico de primera corrida.
- [ ] `.strip()` por línea y por campo; líneas vacías filtradas; nota convertida bajo `try/except ValueError`.
- [ ] Promedio general protegido con la colección vacía.
- [ ] Mensajes y comentarios en español, sin tildes ni eñes en el código.
- [ ] `commit` y `push` hechos y verificados en GitHub.
