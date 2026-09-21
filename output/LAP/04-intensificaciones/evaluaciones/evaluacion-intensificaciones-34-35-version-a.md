# Evaluación del momento — Unidades 3 y 4 — Versión A: libros leídos

## Metadatos

| Campo | Valor |
|---|---|
| Versión | A |
| Dominio de datos | Libros leídos (`libros.json`: `titulo`, `autor`, `paginas`) |
| Instancia | Momento de intensificación y fortalecimiento de las Unidades 3 y 4 — Encuentros 34 y 35 |
| Duración | 60 minutos (desarrollo, entrega y ciclo Git) |
| Destinatarios | Grupo con la versión A asignada |
| Entrega | Carpeta `intensificacion-34-35/` del repositorio del grupo: `libros.py` y `libros.json`, en rama `int-34-35` con PR fusionado |
| Acreditación | Apto / No apto aún por objetivo mínimo (criterios de la consigna maestra) |

## Consigna

Desarrollar `intensificacion-34-35/libros.py` en el repositorio del grupo: un programa de consola que administra la colección de libros leídos del grupo, guardada en `libros.json` junto al programa: una lista de diccionarios con las claves `titulo`, `autor` y `paginas` (numérico).

Archivo inicial (crear `libros.json` con este contenido):

```json
[
  {
    "titulo": "Cuentos de la sierra",
    "autor": "Elena Quiroga",
    "paginas": 210
  },
  {
    "titulo": "El mapa del faro",
    "autor": "Marta Leniz",
    "paginas": 168
  }
]
```

1. Cargar la colección al inicio con `json.load`; si `libros.json` no existe, mostrar «No existe el archivo de datos: se empieza de cero» y arrancar con la lista vacía.
2. Mostrar un menú con las opciones: 1) Agregar libro, 2) Listar libros, 0) Salir. La opción se lee con `int()`; ante un valor no numérico, mostrar «Debe ingresar un numero valido» y volver a pedir.
3. Agregar libro: pedir título, autor y páginas (numérico, con la misma validación de conversión y reintento); construir el diccionario campo por campo y agregarlo a la lista con `append`.
4. Listar libros: recorrer la lista con `for` y mostrar título, autor y páginas de cada libro; validar con `in` que las claves existan antes de leerlas; si la lista está vacía, mostrar «No hay libros guardados».
5. Salir: guardar la colección completa con `json.dump(coleccion, f, ensure_ascii=False, indent=2)` en modo `"w"`; abrir `libros.json` desde VS Code y verificar que las tildes se ven correctamente y el formato está indentado.

## Requisitos técnicos (canon de la materia)

- Esqueleto canónico: `import json`, constante `RUTA_DATOS`, funciones con `def`, `def main():` y guard `if __name__ == "__main__":` al final.
- Carga canónica: `try`, `with open(RUTA_DATOS, "r", encoding="utf-8")` y `json.load(f)`; `except FileNotFoundError` → `[]` con aviso.
- Guardado canónico: `with open(RUTA_DATOS, "w", encoding="utf-8")` y `json.dump(..., ensure_ascii=False, indent=2)`.
- Conversión numérica en el renglón del `input()`, bajo `try/except ValueError`, con reingreso; sin `except:` desnudo.
- Validación con `in` antes de leer una clave; listado con `for`.
- Mensajes y comentarios en español, sin tildes ni eñes dentro del código; un comentario por cada acción.

## Pruebas mínimas

- Caso normal: agregar un libro, salir, reabrir y listar; abrir `libros.json` desde VS Code y verificar qué quedó escrito (tildes reales, `indent=2`).
- Caso de error: renombrar `libros.json` y reabrir; el programa avisa y arranca con la lista vacía. Ingresar una letra en las páginas; el programa vuelve a pedir.

## Entrega

```bash
git checkout -b int-34-35
git add .
git commit -m "intensificacion-34-35: version A del grupo"
git push -u origin int-34-35
```

Después: abrir el PR en GitHub, pedir la revisión del par y fusionar una vez aprobado. Verificar en GitHub la rama, el PR y la fusión.

## Checklist antes de entregar

- [ ] Esqueleto canónico: `import json`, constantes, funciones con `def`, `main()` y guard.
- [ ] Carga con `json.load` y `FileNotFoundError` manejado con lista vacía y aviso.
- [ ] Guardado con `json.dump(..., ensure_ascii=False, indent=2)`; tildes visibles en el archivo.
- [ ] Diccionario construido campo por campo y agregado con `append`; listado con `for` y validación con `in`.
- [ ] Ciclo agregar-salir-reabrir-listar verificado con el `.json` abierto en VS Code.
- [ ] Rama `int-34-35` con commits de mensaje claro; PR abierto, revisado por el par y fusionado.
- [ ] Mensajes y comentarios en español, sin tildes ni eñes en el código.
