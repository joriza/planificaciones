# Evaluación de la instancia de diciembre — Versión A: útiles escolares

## Metadatos

| Campo | Valor |
|---|---|
| Versión | A |
| Dominio de datos | Útiles escolares (`utiles.txt` legado → `utiles.json`, campo numérico `precio`) |
| Instancia | Instancia de intensificación de diciembre — evaluación del camino mínimo completo del curso |
| Duración | 90 minutos (desarrollo y entrega) |
| Destinatarios | Estudiante o grupo con la versión A asignada |
| Entrega | Carpeta `intensificacion-diciembre/` del repositorio: `camino_minimo.py`, `utiles.txt` y `utiles.json`, en rama propia con push |
| Acreditación | Apto / No apto aún por objetivo mínimo (criterios de la consigna maestra) |

## Consigna

Desarrollar `intensificacion-diciembre/camino_minimo.py` en el repositorio: un programa de consola que administra la lista de útiles escolares, partiendo de un legado en `utiles.txt` (una línea por ítem, `nombre,rubro`) y terminando con la colección completa en `utiles.json`.

Archivo legado (crear `utiles.txt` con este contenido):

```
Lapicera,escritura
Cuaderno,libreria
Mochila,accesorios
Regla,libreria
```

1. Cargar el legado al inicio desde `utiles.txt` con `with open(..., "r", encoding="utf-8")`; si el archivo no existe, mostrar «No existe el archivo de datos: se empieza de cero» y arrancar con la lista vacía. Cada línea se separa con `split(",")`, cada campo se limpia con `.strip()` y las líneas vacías se descartan.
2. Mostrar un menú con las opciones: 1) Importar legado, 2) Agregar ítem, 3) Listado, 0) Salir. La opción se lee con `int()`; ante un valor no numérico, mostrar «Debe ingresar un numero valido» y volver a pedir.
3. Importar legado: convertir cada línea del legado en un diccionario con las claves `nombre` y `rubro`, y agregarlo a la colección con `append`; si la colección ya tiene registros, mostrar «La coleccion ya tiene registros» y no importar de nuevo.
4. Agregar ítem: pedir nombre, rubro y precio (numérico, con la misma validación de conversión y reintento); construir el diccionario campo por campo y agregarlo con `append`.
5. Listado: recorrer la colección con `for` y mostrar nombre y rubro de cada ítem; validar con `in` antes de leer el precio — si está, mostrar la condición decidida con `if/elif/else` (menor que 500: «Barato»; entre 500 y 2.000: «Accesible»; mayor que 2.000: «Caro») y contar cuántos «Barato» con un acumulador; si no está, mostrar «(sin precio)». Al final, mostrar el total de ítems y la cantidad de baratos. Con la lista vacía, mostrar «No hay items cargados».
6. Salir: guardar la colección completa en `utiles.json` con `json.dump(coleccion, f, ensure_ascii=False, indent=2)` y terminar.

## Requisitos técnicos (canon de la materia)

- Esqueleto canónico: `import json`, constantes (`RUTA_LEGADO`, `RUTA_DATOS`), funciones con `def`, `def main():` y guard `if __name__ == "__main__":` al final.
- Al menos cuatro funciones con `def`; el menú repite con `while` y delega con `if/elif/else`.
- Toda conversión numérica en el renglón del `input()`, bajo `try/except ValueError`, con reingreso; sin `except:` desnudo.
- Apertura de archivos siempre con `with open(ruta, modo, encoding="utf-8")`; `FileNotFoundError` manejado con valor inicial y aviso.
- `split(",")` + `.strip()` en cada línea del legado; líneas vacías filtradas.
- Colección en JSON con `json.load`/`json.dump(..., ensure_ascii=False, indent=2)`; validación con `in` antes de leer el precio.
- Mensajes y comentarios en español, sin tildes ni eñes dentro del código; un comentario por cada acción.

## Pruebas mínimas

- Caso normal: importar el legado, agregar un ítem con precio, salir, reabrir y listar; abrir `utiles.json` desde VS Code y verificar qué quedó escrito (tildes reales, `indent=2`).
- Caso de error: renombrar `utiles.txt` y reabrir; el programa avisa y arranca con la lista vacía. Ingresar una letra en la opción del menú y en el precio; el programa vuelve a pedir.

## Entrega

```bash
git checkout -b diciembre-camino-minimo
git add .
git commit -m "intensificacion-diciembre: version A del grupo"
git push -u origin diciembre-camino-minimo
```

Verificar en GitHub la rama, los commits con mensajes claros y el `.gitignore` con `__pycache__/`.

## Checklist antes de entregar

- [ ] Esqueleto canónico: `import json`, constantes, funciones con `def`, `main()` y guard.
- [ ] Legado leído con `with open(..., encoding="utf-8")`, `split(",")` + `.strip()` y `FileNotFoundError` manejado.
- [ ] Colección en JSON con `json.load`/`json.dump(..., ensure_ascii=False, indent=2)`; precio validado con `in` antes de leerlo.
- [ ] Condición de tres salidas con `if/elif/else` y contador con acumulador.
- [ ] Ciclo importar/agregar-salir-reabrir-listar verificado con el `.json` abierto en VS Code.
- [ ] Rama propia con commits por avance y push verificado; `.gitignore` con `__pycache__/`.
- [ ] Mensajes y comentarios en español, sin tildes ni eñes en el código.
