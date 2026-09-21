# Evaluación de la instancia de marzo — Versión B: juegos de mesa

## Metadatos

| Campo | Valor |
|---|---|
| Versión | B |
| Dominio de datos | Juegos de mesa (`juegos.txt` legado → `juegos.json`, campo numérico `jugadores`) |
| Instancia | Instancia de intensificación de marzo — evaluación del camino mínimo completo del curso |
| Duración | 90 minutos (desarrollo y entrega) |
| Destinatarios | Estudiante o grupo con la versión B asignada |
| Entrega | Carpeta `intensificacion-marzo/` del repositorio: `camino_minimo.py`, `juegos.txt` y `juegos.json`, en rama propia con push |
| Acreditación | Apto / No apto aún por objetivo mínimo (criterios de la consigna maestra) |

## Consigna

Desarrollar `intensificacion-marzo/camino_minimo.py` en el repositorio: un programa de consola que administra la lista de juegos de mesa del aula, partiendo de un legado en `juegos.txt` (una línea por juego, `juego,estante`) y terminando con la colección completa en `juegos.json`.

Archivo legado (crear `juegos.txt` con este contenido):

```
Ajedrez,estante 1
Cartas del norte,estante 2
Dominio del rio,estante 1
Memotest,estante 3
```

1. Cargar el legado al inicio desde `juegos.txt` con `with open(..., "r", encoding="utf-8")`; si el archivo no existe, mostrar «No existe el archivo de datos: se empieza de cero» y arrancar con la lista vacía. Cada línea se separa con `split(",")`, cada campo se limpia con `.strip()` y las líneas vacías se descartan.
2. Mostrar un menú con las opciones: 1) Importar legado, 2) Agregar juego, 3) Listado, 0) Salir. La opción se lee con `int()`; ante un valor no numérico, mostrar «Debe ingresar un numero valido» y volver a pedir.
3. Importar legado: convertir cada línea del legado en un diccionario con las claves `juego` y `estante`, y agregarlo a la colección con `append`; si la colección ya tiene registros, mostrar «La coleccion ya tiene registros» y no importar de nuevo.
4. Agregar juego: pedir juego, estante y cantidad de jugadores (numérico, con la misma validación de conversión y reintento); construir el diccionario campo por campo y agregarlo con `append`.
5. Listado: recorrer la colección con `for` y mostrar juego y estante de cada registro; validar con `in` antes de leer la cantidad de jugadores — si está, mostrar la condición decidida con `if/elif/else` (menor que 3: «Pocos jugadores»; entre 3 y 6: «Ideal para el grupo»; mayor que 6: «Para todos») y contar cuántos «Pocos jugadores» con un acumulador; si no está, mostrar «(sin dato)». Al final, mostrar el total de juegos y la cantidad con pocos jugadores. Con la lista vacía, mostrar «No hay juegos cargados».
6. Salir: guardar la colección completa en `juegos.json` con `json.dump(coleccion, f, ensure_ascii=False, indent=2)` y terminar.

## Requisitos técnicos (canon de la materia)

- Esqueleto canónico: `import json`, constantes (`RUTA_LEGADO`, `RUTA_DATOS`), funciones con `def`, `def main():` y guard `if __name__ == "__main__":` al final.
- Al menos cuatro funciones con `def`; el menú repite con `while` y delega con `if/elif/else`.
- Toda conversión numérica en el renglón del `input()`, bajo `try/except ValueError`, con reingreso; sin `except:` desnudo.
- Apertura de archivos siempre con `with open(ruta, modo, encoding="utf-8")`; `FileNotFoundError` manejado con valor inicial y aviso.
- `split(",")` + `.strip()` en cada línea del legado; líneas vacías filtradas.
- Colección en JSON con `json.load`/`json.dump(..., ensure_ascii=False, indent=2)`; validación con `in` antes de leer la cantidad de jugadores.
- Mensajes y comentarios en español, sin tildes ni eñes dentro del código; un comentario por cada acción.

## Pruebas mínimas

- Caso normal: importar el legado, agregar un juego con cantidad de jugadores, salir, reabrir y listar; abrir `juegos.json` desde VS Code y verificar qué quedó escrito (tildes reales, `indent=2`).
- Caso de error: renombrar `juegos.txt` y reabrir; el programa avisa y arranca con la lista vacía. Ingresar una letra en la opción del menú y en la cantidad de jugadores; el programa vuelve a pedir.

## Entrega

```bash
git checkout -b marzo-camino-minimo
git add .
git commit -m "intensificacion-marzo: version B del grupo"
git push -u origin marzo-camino-minimo
```

Verificar en GitHub la rama, los commits con mensajes claros y el `.gitignore` con `__pycache__/`.

## Checklist antes de entregar

- [ ] Esqueleto canónico: `import json`, constantes, funciones con `def`, `main()` y guard.
- [ ] Legado leído con `with open(..., encoding="utf-8")`, `split(",")` + `.strip()` y `FileNotFoundError` manejado.
- [ ] Colección en JSON con `json.load`/`json.dump(..., ensure_ascii=False, indent=2)`; jugadores validados con `in` antes de leerlos.
- [ ] Condición de tres salidas con `if/elif/else` y contador con acumulador.
- [ ] Ciclo importar/agregar-salir-reabrir-listar verificado con el `.json` abierto en VS Code.
- [ ] Rama propia con commits por avance y push verificado; `.gitignore` con `__pycache__/`.
- [ ] Mensajes y comentarios en español, sin tildes ni eñes en el código.
