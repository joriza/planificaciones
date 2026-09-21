# Evaluación del momento — Unidades 1 y 2 — Versión A: tareas pendientes

## Metadatos

| Campo | Valor |
|---|---|
| Versión | A |
| Dominio de datos | Lista de tareas pendientes (`tareas.txt`, formato `descripcion,prioridad`) |
| Instancia | Momento de intensificación y fortalecimiento de las Unidades 1 y 2 — Encuentros 17 y 18 |
| Duración | 60 minutos (desarrollo y entrega) |
| Destinatarios | Grupo con la versión A asignada |
| Entrega | Carpeta `intensificacion-17-18/` del repositorio del grupo: `tareas.py` y `tareas.txt` |
| Acreditación | Apto / No apto aún por objetivo mínimo (criterios de la consigna maestra) |

## Consigna

Desarrollar `intensificacion-17-18/tareas.py` en el repositorio del grupo: un programa de consola que administra la lista de tareas pendientes del grupo, guardada en `tareas.txt` junto al programa, con una línea por tarea en el formato `descripcion,prioridad`, donde la prioridad es un número del 1 al 3.

1. Cargar las tareas al inicio desde `tareas.txt` con `with open(..., "r", encoding="utf-8")`; si el archivo no existe, mostrar «No existe el archivo de datos: se empieza de cero» y arrancar con la lista vacía.
2. Mostrar un menú con las opciones: 1) Agregar tarea, 2) Listar tareas, 0) Salir. La opción se lee con `int()`; ante un valor no numérico, mostrar «Debe ingresar un numero valido» y volver a pedir.
3. Agregar tarea: pedir la descripción y la prioridad (número del 1 al 3, con la misma validación de conversión y reintento); guardar la tarea en la lista como una línea `descripcion,prioridad`.
4. Listar tareas: recorrer la lista con `for` y mostrar cada tarea con su prioridad; si la lista está vacía, mostrar «No hay tareas guardadas».
5. Salir: guardar la lista completa en `tareas.txt` con `with open(..., "w", encoding="utf-8")`, una línea por tarea, y terminar el programa.

Datos iniciales para probar (crear `tareas.txt` con este contenido si el grupo arranca de cero):

```
Estudiar para el parcial,1
Comprar materiales,3
Entregar el trabajo,2
```

## Requisitos técnicos (canon de la materia)

- Esqueleto canónico: constantes (`RUTA_DATOS`), funciones con `def`, `def main():` y guard `if __name__ == "__main__":` al final.
- Al menos tres funciones con `def` que reciben parámetros y devuelven datos o modifican la lista; el menú delega con `if/elif/else`.
- Toda conversión numérica en el renglón del `input()`, bajo `try/except ValueError`, con reingreso.
- Apertura de archivos siempre con `with open(ruta, modo, encoding="utf-8")`; `except FileNotFoundError` con lista vacía y aviso.
- Excepciones específicas siempre; sin `except:` desnudo.
- Mensajes y comentarios en español, sin tildes ni eñes dentro del código; un comentario por cada acción.

## Pruebas mínimas

- Caso normal: agregar una tarea, salir, reabrir el programa y listarla; abrir `tareas.txt` desde VS Code y verificar qué quedó escrito.
- Caso de error: renombrar `tareas.txt` y reabrir; el programa avisa y arranca con la lista vacía. Ingresar una letra en la prioridad; el programa vuelve a pedir.

## Entrega

```bash
git add .
git commit -m "intensificacion-17-18: entrega de la version A"
git push
```

Verificar en GitHub que quedó publicada la carpeta `intensificacion-17-18/` con `tareas.py` y `tareas.txt`.

## Checklist antes de entregar

- [ ] Esqueleto canónico: constantes, funciones con `def`, `main()` y guard.
- [ ] Al menos tres funciones; el menú repite con `while` y delega con `if/elif/else`.
- [ ] `with open(..., encoding="utf-8")` en lectura y escritura; `FileNotFoundError` manejado con lista vacía.
- [ ] Conversiones con `int()` bajo `try/except ValueError` y reintento, en opción y prioridad.
- [ ] Ciclo agregar-salir-reabrir-listar verificado con el `.txt` abierto en VS Code.
- [ ] Mensajes y comentarios en español, sin tildes ni eñes en el código.
- [ ] `commit` y `push` hechos y verificados en GitHub.
