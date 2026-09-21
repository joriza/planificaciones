# Evaluación de la instancia de marzo — Versión A: semillas de la huerta

## Metadatos

| Campo | Valor |
|---|---|
| Versión | A |
| Dominio de datos | Semillas de la huerta escolar (`semillas.txt` legado → `semillas.json`, campo numérico `cantidad`) |
| Instancia | Instancia de intensificación de marzo — evaluación del camino mínimo completo del curso |
| Duración | 90 minutos (desarrollo y entrega) |
| Destinatarios | Estudiante o grupo con la versión A asignada |
| Entrega | Carpeta `intensificacion-marzo/` del repositorio: `camino_minimo.py`, `semillas.txt` y `semillas.json`, en rama propia con push |
| Acreditación | Apto / No apto aún por objetivo mínimo (criterios de la consigna maestra) |

## Consigna

Desarrollar `intensificacion-marzo/camino_minimo.py` en el repositorio: un programa de consola que administra la lista de semillas de la huerta escolar, partiendo de un legado en `semillas.txt` (una línea por especie, `especie,sector`) y terminando con la colección completa en `semillas.json`.

Archivo legado (crear `semillas.txt` con este contenido):

```
Tomate,invernadero
Lechuga,canal 1
Zanahoria,campo abierto
Albahaca,invernadero
```

1. Cargar el legado al inicio desde `semillas.txt` con `with open(..., "r", encoding="utf-8")`; si el archivo no existe, mostrar «No existe el archivo de datos: se empieza de cero» y arrancar con la lista vacía. Cada línea se separa con `split(",")`, cada campo se limpia con `.strip()` y las líneas vacías se descartan.
2. Mostrar un menú con las opciones: 1) Importar legado, 2) Agregar especie, 3) Listado, 0) Salir. La opción se lee con `int()`; ante un valor no numérico, mostrar «Debe ingresar un numero valido» y volver a pedir.
3. Importar legado: convertir cada línea del legado en un diccionario con las claves `especie` y `sector`, y agregarlo a la colección con `append`; si la colección ya tiene registros, mostrar «La coleccion ya tiene registros» y no importar de nuevo.
4. Agregar especie: pedir especie, sector y cantidad de sobres (numérico, con la misma validación de conversión y reintento); construir el diccionario campo por campo y agregarlo con `append`.
5. Listado: recorrer la colección con `for` y mostrar especie y sector de cada registro; validar con `in` antes de leer la cantidad — si está, mostrar la condición decidida con `if/elif/else` (menor que 5: «Reponer»; entre 5 y 20: «Suficiente»; mayor que 20: «Sobrante») y contar cuántas «Reponer» con un acumulador; si no está, mostrar «(sin cantidad)». Al final, mostrar el total de registros y la cantidad para reponer. Con la lista vacía, mostrar «No hay especies cargadas».
6. Salir: guardar la colección completa en `semillas.json` con `json.dump(coleccion, f, ensure_ascii=False, indent=2)` y terminar.

## Requisitos técnicos (canon de la materia)

- Esqueleto canónico: `import json`, constantes (`RUTA_LEGADO`, `RUTA_DATOS`), funciones con `def`, `def main():` y guard `if __name__ == "__main__":` al final.
- Al menos cuatro funciones con `def`; el menú repite con `while` y delega con `if/elif/else`.
- Toda conversión numérica en el renglón del `input()`, bajo `try/except ValueError`, con reingreso; sin `except:` desnudo.
- Apertura de archivos siempre con `with open(ruta, modo, encoding="utf-8")`; `FileNotFoundError` manejado con valor inicial y aviso.
- `split(",")` + `.strip()` en cada línea del legado; líneas vacías filtradas.
- Colección en JSON con `json.load`/`json.dump(..., ensure_ascii=False, indent=2)`; validación con `in` antes de leer la cantidad.
- Mensajes y comentarios en español, sin tildes ni eñes dentro del código; un comentario por cada acción.

## Pruebas mínimas

- Caso normal: importar el legado, agregar una especie con cantidad, salir, reabrir y listar; abrir `semillas.json` desde VS Code y verificar qué quedó escrito (tildes reales, `indent=2`).
- Caso de error: renombrar `semillas.txt` y reabrir; el programa avisa y arranca con la lista vacía. Ingresar una letra en la opción del menú y en la cantidad; el programa vuelve a pedir.

## Entrega

```bash
git checkout -b marzo-camino-minimo
git add .
git commit -m "intensificacion-marzo: version A del grupo"
git push -u origin marzo-camino-minimo
```

Verificar en GitHub la rama, los commits con mensajes claros y el `.gitignore` con `__pycache__/`.

## Checklist antes de entregar

- [ ] Esqueleto canónico: `import json`, constantes, funciones con `def`, `main()` y guard.
- [ ] Legado leído con `with open(..., encoding="utf-8")`, `split(",")` + `.strip()` y `FileNotFoundError` manejado.
- [ ] Colección en JSON con `json.load`/`json.dump(..., ensure_ascii=False, indent=2)`; cantidad validada con `in` antes de leerla.
- [ ] Condición de tres salidas con `if/elif/else` y contador con acumulador.
- [ ] Ciclo importar/agregar-salir-reabrir-listar verificado con el `.json` abierto en VS Code.
- [ ] Rama propia con commits por avance y push verificado; `.gitignore` con `__pycache__/`.
- [ ] Mensajes y comentarios en español, sin tildes ni eñes en el código.
