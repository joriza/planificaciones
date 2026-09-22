# Anexo docente — Evaluación de la Unidad 4 — Encuentro 32 — Versión A

> Documento docente formal. Solución de referencia y criterios de corrección.

## 1. Solución de referencia (modificación sobre el integrador del grupo)

No hay una solución única: cada grupo tiene su propio programa integrador. La siguiente es una solución de referencia para un integrador típico de verdulería que usa `main.py` con un menú y `productList` como lista de diccionarios.

**Fragmento a agregar en el menú (`main.py`):**

```python
# Opcion 5 del menu (dentro del while del menu principal)
elif option == "5":
    find_product()
```

**Función `find_product()` (agregar antes del `if __name__ == "__main__":`):**

```python
def find_product():
    # Busca un producto por nombre en productList y muestra su info
    name = input("Nombre del producto a buscar: ").strip().lower()
    if not name:
        print("El nombre no puede estar vacio.")
        return

    for product in product_list:
        if product["productName"].strip().lower() == name:
            print()
            print("=== PRODUCTO ENCONTRADO ===")
            print(f"Nombre: {product['productName']}")
            print(f"Precio: ${product['productPrice']:.2f}")
            print(f"Stock disponible: {product['stockWeight']} kilos")
            return

    print("Producto no encontrado.")
```

**Aceptaciones válidas:**
- El nombre de la función puede ser `search_product`, `lookup_product`, etc.
- Puede usar `for` con `break` o un bucle con índice.
- Puede estar en un archivo separado si el grupo ya modularizó.
- La búsqueda puede ser case-insensitive (como en el ejemplo) o exacta.

## 2. Criterios de corrección

### Parte 1 — Modificación guiada (60 pts)

| Ítem | Pts | Puntúa | Error previsto |
| --- | --- | --- | --- |
| 1a — Opción en menú | 10 | La opción 5 aparece y es invocable | No agregó la opción → 0 pts; está comentada → descontar 5 pts |
| 1b — Función find_product | 20 | Recorre productList, busca por nombre, devuelve dict o None | No itera la lista → 0 pts; no usa `in` o comparación → descontar 5 pts |
| 1c — Mostrar info | 15 | Muestra nombre, precio y stock con f-strings | Sin f-strings → descontar 5 pts; no muestra stock → descontar 5 pts |
| 1d — Validar nombre vacío | 15 | `if not name:` o similar | Sin validación → 0 pts |
| **Total** | **60** | | |

### Parte 2 — Explicación (20 pts)

| Ítem | Pts | Puntúa |
| --- | --- | --- |
| 2a — Archivos modificados | 10 | Menciona main.py (o el archivo correcto) y el nombre de la función |
| 2b — Verificación | 10 | "Ejecuté el programa y probé con un producto existente y uno inexistente." |

### Parte 3 — Defensa (20 pts)

| Ítem | Pts | Puntúa |
| --- | --- | --- |
| 3a — Repositorio en orden | 10 | README visible, issues cerrados, PR mergeados, main protegida |
| 3b — Respuestas del estudiante | 10 | Explica su módulo, responde preguntas del docente |

## 3. Pauta de devolución

Encuentro 33. Menos de 60 pts → recuperación a coordinar con el docente. La rama `evaluacion-u4` se revisa durante la defensa y puede mergearse a `main` como evidencia si el estudiante lo desea.