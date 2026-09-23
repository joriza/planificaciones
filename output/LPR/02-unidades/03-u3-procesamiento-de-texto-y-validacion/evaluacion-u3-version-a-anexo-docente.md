# Anexo docente — Evaluación de la Unidad 3 — Encuentro 26 — Versión A

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión A, las respuestas esperadas de los ítems conceptuales, los criterios de corrección ítem por ítem y la pauta de devolución.

## 1. Solución completa (`libreria.py`)

```python
# libreria.py — Gestion de inventario de una libreria escolar
# Evaluacion U3 — Version A
# Permite registrar libros con parseo de texto y validacion

import random

# Lista de libros en memoria
book_list = []


def parse_book(record_text):
    # Recibe un texto con formato "titulo, autor, cantidad"
    # Devuelve un dict con title, author y copies (int)
    # o lanza ValueError si la cantidad no es numerica
    parts = record_text.split(",")
    if len(parts) != 3:
        print("Formato invalido. Usá: titulo, autor, cantidad.")
        return None

    title = parts[0].strip()
    author = parts[1].strip()
    copies_text = parts[2].strip()

    # Validar que los campos no esten vacios
    if not title or not author or not copies_text:
        print("Formato invalido. Usá: titulo, autor, cantidad.")
        return None

    # Convertir cantidad (lanza ValueError si no es numerico)
    copies = int(copies_text)

    # Validar cantidad positiva
    if copies <= 0:
        print("La cantidad de copias debe ser un valor positivo.")
        return None

    return {
        "title": title,
        "author": author,
        "copies": copies
    }


def valid_isbn(isbn):
    # Limpia espacios y verifica que tenga exactamente 13 digitos
    clean = isbn.strip()
    return clean.isdigit() and len(clean) == 13


def add_book():
    # Pide una linea de texto, la parsea y agrega el libro a la lista
    print()
    print("=== ALTA DE LIBRO ===")
    line = input("Ingresa: titulo, autor, cantidad: ")

    try:
        book = parse_book(line)
    except ValueError:
        print("Error: la cantidad no es un numero valido.")
        return

    if book is None:
        return

    # Pedir y validar ISBN
    while True:
        isbn = input("ISBN del libro (13 digitos): ")
        if valid_isbn(isbn):
            break
        print("ISBN invalido. Debe tener exactamente 13 digitos numericos.")

    book["isbn"] = isbn.strip()
    register = random.randint(1000, 9999)
    book["register"] = register

    book_list.append(book)
    print(f"Libro registrado correctamente. Nro de registro: {register}")


def list_books():
    # Muestra todos los libros registrados
    print()
    print("=== LISTA DE LIBROS ===")
    if not book_list:
        print("No hay libros registrados.")
        return
    print(f"{'Titulo':<25} {'Autor':<20} {'Copias':<8} {'ISBN':<15}")
    print("-" * 70)
    for b in book_list:
        print(f"{b['title']:<25} {b['author']:<20} {b['copies']:<8} {b.get('isbn', '-'):<15}")


if __name__ == "__main__":
    # Bloque de ejecucion principal (spike 9.10)
    print("=== SISTEMA DE INVENTARIO DE LA LIBRERIA ESCOLAR ===")
    running = True

    while running:
        print()
        print("1. Alta de libro")
        print("2. Listar libros")
        print("3. Salir")
        option = input("Elegi una opcion: ")

        if option == "1":
            add_book()
        elif option == "2":
            list_books()
        elif option == "3":
            running = False
            print("Saludos!")
        else:
            print("Opcion invalida.")
```

**Aceptaciones válidas menores:**
- `book_list` puede llamarse `inventory` o `books`.
- `parse_book` puede retornar una tupla en lugar de dict.
- La validación del ISBN puede usar `len(clean) >= 13` en lugar de exactamente 13.
- El menú puede tener opción 0 para salir en lugar de 3.

## 2. Salidas de referencia para la corrección

| Prueba | Entrada | Salida esperada |
| --- | --- | --- |
| Opción 1 + "El Principito, Saint-Exupery, 5" + ISBN "1234567890123" | `1`, `El Principito, Saint-Exupery, 5`, `1234567890123` | "Libro registrado. Nro de registro: (4 dígitos)" |
| Opción 1 + "El Principito, Saint-Exupery" | `1`, `El Principito, Saint-Exupery` | "Formato inválido. Usá: titulo, autor, cantidad." |
| Opción 1 + "El Principito, Saint-Exupery, cinco" | `1`, `El Principito, Saint-Exupery, cinco` | "Error: la cantidad no es un número válido." |
| Opción 1 + ISBN "abc" | `1`, libro válido, `abc` | "ISBN inválido. Debe tener exactamente 13 dígitos numéricos." |
| Opción 2 | `2` con 1 libro | Tabla con título, autor, copias, ISBN |
| Opción 3 | `3` | "Saludos!" |

## 3. Criterios de corrección ítem por ítem

| Ítem | Pts | Qué puntúa | Error previsto |
| --- | --- | --- | --- |
| 1a — parse_book | 15 | split, strip, return dict | Sin split ni strip → 0 pts; no devuelve dict → descontar 5 pts |
| 1b — Validar 3 campos | 10 | len(parts) != 3 | No valida cantidad de campos → 0 pts |
| 1c — ValueError | 5 | Captura excepción | Sin try/except → 0 pts |
| 2a — add_book | 15 | Llama parse, try/except, agrega | No agrega a la lista → 0 pts |
| 2b — valid_isbn | 10 | strip + isdigit + len == 13 | Sin limpieza → descontar 5 pts |
| 2c — Validar ISBN | 10 | Reintento while True | Sin reintento → descontar 5 pts |
| 2d — Registro aleatorio | 5 | random.randint | Sin import random → 2 pts |
| 3a — Menú | 5 | 3 opciones, while | Menos opciones → descontar 2 pts |
| 3b — Listar | 10 | Itera book_list, formato | Sin formato alineado → descontar 3 pts |
| 3c — Opción inválida | 5 | Mensaje y retorno | Crashing → 0 pts |
| 4a — split sin coma | 5 | "Devuelve lista de 1 elemento" | Respuesta incorrecta → 0 pts |
| 4b — try mejor que if | 5 | "Maneja cualquier caracter no numérico" | Sin justificación → descontar 3 pts |

## 4. Pauta de devolución

Encuentro 27. Recuperación al inicio del encuentro 28 si menos de 60 pts. Se devuelve con nota numérica y observación por ítem: qué funcionó, qué falta y qué corregir antes de la recuperación.