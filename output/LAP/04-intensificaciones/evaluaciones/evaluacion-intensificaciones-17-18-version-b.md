# Evaluación del momento — Unidades 1 y 2 — Versión B: películas por ver

## Metadatos

| Campo | Valor |
|---|---|
| Versión | B |
| Dominio de datos | Películas por ver (`peliculas.txt`, formato `titulo,anio`) |
| Instancia | Momento de intensificación y fortalecimiento de las Unidades 1 y 2 — Encuentros 17 y 18 |
| Duración | 60 minutos (desarrollo y entrega) |
| Destinatarios | Grupo con la versión B asignada |
| Entrega | Carpeta `intensificacion-17-18/` del repositorio del grupo: `peliculas.py` y `peliculas.txt` |
| Acreditación | Apto / No apto aún por objetivo mínimo (criterios de la consigna maestra) |

## Consigna

Desarrollar `intensificacion-17-18/peliculas.py` en el repositorio del grupo: un programa de consola que administra la lista de películas que el grupo quiere ver, guardada en `peliculas.txt` junto al programa, con una línea por película en el formato `titulo,anio`, donde el año de estreno es un número mayor que 1895.

1. Cargar las películas al inicio desde `peliculas.txt` con `with open(..., "r", encoding="utf-8")`; si el archivo no existe, mostrar «No existe el archivo de datos: se empieza de cero» y arrancar con la lista vacía.
2. Mostrar un menú con las opciones: 1) Agregar película, 2) Listar películas, 0) Salir. La opción se lee con `int()`; ante un valor no numérico, mostrar «Debe ingresar un numero valido» y volver a pedir.
3. Agregar película: pedir el título y el año de estreno (número mayor que 1895, con la misma validación de conversión y reintento); guardar la película en la lista como una línea `titulo,anio`.
4. Listar películas: recorrer la lista con `for` y mostrar cada película con su año; si la lista está vacía, mostrar «No hay peliculas guardadas».
5. Salir: guardar la lista completa en `peliculas.txt` con `with open(..., "w", encoding="utf-8")`, una línea por película, y terminar el programa.

Datos iniciales para probar (crear `peliculas.txt` con este contenido si el grupo arranca de cero):

```
La odisea del bosque,2016
Vuelo al sur,1998
El faro perdido,2004
```

## Requisitos técnicos (canon de la materia)

- Esqueleto canónico: constantes (`RUTA_DATOS`), funciones con `def`, `def main():` y guard `if __name__ == "__main__":` al final.
- Al menos tres funciones con `def` que reciben parámetros y devuelven datos o modifican la lista; el menú delega con `if/elif/else`.
- Toda conversión numérica en el renglón del `input()`, bajo `try/except ValueError`, con reingreso.
- Apertura de archivos siempre con `with open(ruta, modo, encoding="utf-8")`; `except FileNotFoundError` con lista vacía y aviso.
- Excepciones específicas siempre; sin `except:` desnudo.
- Mensajes y comentarios en español, sin tildes ni eñes dentro del código; un comentario por cada acción.

## Pruebas mínimas

- Caso normal: agregar una película, salir, reabrir el programa y listarla; abrir `peliculas.txt` desde VS Code y verificar qué quedó escrito.
- Caso de error: renombrar `peliculas.txt` y reabrir; el programa avisa y arranca con la lista vacía. Ingresar una letra en el año; el programa vuelve a pedir.

## Entrega

```bash
git add .
git commit -m "intensificacion-17-18: entrega de la version B"
git push
```

Verificar en GitHub que quedó publicada la carpeta `intensificacion-17-18/` con `peliculas.py` y `peliculas.txt`.

## Checklist antes de entregar

- [ ] Esqueleto canónico: constantes, funciones con `def`, `main()` y guard.
- [ ] Al menos tres funciones; el menú repite con `while` y delega con `if/elif/else`.
- [ ] `with open(..., encoding="utf-8")` en lectura y escritura; `FileNotFoundError` manejado con lista vacía.
- [ ] Conversiones con `int()` bajo `try/except ValueError` y reintento, en opción y año.
- [ ] Ciclo agregar-salir-reabrir-listar verificado con el `.txt` abierto en VS Code.
- [ ] Mensajes y comentarios en español, sin tildes ni eñes en el código.
- [ ] `commit` y `push` hechos y verificados en GitHub.
