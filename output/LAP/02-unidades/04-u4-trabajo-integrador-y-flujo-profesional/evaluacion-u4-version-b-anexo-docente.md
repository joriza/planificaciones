# Anexo docente — Evaluación de la Unidad 4 — Encuentro 32 — Versión B

> Documento docente formal. Solución de referencia y criterios de corrección.

## 1. Solución de referencia (modificación sobre el integrador del grupo)

No hay una solución única. La siguiente es una solución de referencia para un integrador típico de videoteca que usa `main.py` con un menú y `movieList` como lista de diccionarios.

**Fragmento a agregar en el menú (`main.py`):**

```python
# Opcion 5 del menu (dentro del while del menu principal)
elif option == "5":
    find_movie()
```

**Función `find_movie()` (agregar antes del `if __name__ == "__main__":`):**

```python
def find_movie():
    # Busca una pelicula por titulo en movieList y muestra su info
    title = input("Titulo de la pelicula a buscar: ").strip().lower()
    if not title:
        print("El titulo no puede estar vacio.")
        return

    for movie in movie_list:
        if movie["movieTitle"].strip().lower() == title:
            print()
            print("=== PELICULA ENCONTRADA ===")
            print(f"Titulo: {movie['movieTitle']}")
            print(f"Precio de alquiler: ${movie['moviePrice']:.2f}")
            print(f"Copias disponibles: {movie['stockCopies']}")
            return

    print("Pelicula no encontrada.")
```

**Aceptaciones válidas:**
- Nombre de función puede ser `search_movie`, `lookup_movie`, etc.
- Búsqueda case-insensitive o exacta.

## 2. Criterios de corrección

### Parte 1 — Modificación guiada (60 pts)

| Ítem | Pts | Puntúa | Error previsto |
| --- | --- | --- | --- |
| 1a — Opción en menú | 10 | La opción 5 aparece y es invocable | No agregó la opción → 0 pts |
| 1b — Función find_movie | 20 | Recorre movieList, busca por movieTitle | No itera → 0 pts |
| 1c — Mostrar info | 15 | Muestra título, moviePrice y stockCopies | Sin f-strings → -5 pts |
| 1d — Validar título vacío | 15 | `if not title:` | Sin validación → 0 pts |

### Parte 2 — Explicación (20 pts) y Parte 3 — Defensa (20 pts)

Idénticos a la versión A (ver `evaluacion-u4-version-a-anexo-docente.md`).

## 3. Pauta de devolución

Idéntica a versión A.