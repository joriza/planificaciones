# Anexo docente — Evaluación de la Unidad 3 — Encuentro 26 — Versión B

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión B, las respuestas esperadas de los ítems conceptuales, los criterios de corrección ítem por ítem y la pauta de devolución.

## 1. Solución completa (`biblioteca.py`)

```python
# biblioteca.py — Gestion de prestamos de una biblioteca del barrio
# Evaluacion U3 — Version B
# Permite registrar prestamos con parseo de texto y validacion

import random

# Lista de prestamos en memoria
loan_list = []


def parse_loan(loan_text):
    # Recibe un texto con formato "titulo, dni, dias"
    # Devuelve un dict con bookTitle, memberDni y loanDays (int)
    # o lanza ValueError si los dias no son numericos
    parts = loan_text.split(",")
    if len(parts) != 3:
        print("Formato invalido. Usá: titulo, dni, dias.")
        return None

    book_title = parts[0].strip()
    dni_text = parts[1].strip()
    days_text = parts[2].strip()

    # Validar que los campos no esten vacios
    if not book_title or not dni_text or not days_text:
        print("Formato invalido. Usá: titulo, dni, dias.")
        return None

    # Convertir dias (lanza ValueError si no es numerico)
    loan_days = int(days_text)

    # Validar dias positivos
    if loan_days <= 0:
        print("Los dias deben ser un valor positivo.")
        return None

    return {
        "bookTitle": book_title,
        "memberDni": dni_text,
        "loanDays": loan_days
    }


def valid_dni(dni):
    # Limpia espacios y verifica que tenga exactamente 8 digitos
    clean = dni.strip()
    return clean.isdigit() and len(clean) == 8


def add_loan():
    # Pide una linea de texto, la parsea y agrega el prestamo a la lista
    print()
    print("=== NUEVO PRESTAMO ===")
    line = input("Ingresa: titulo, dni, dias: ")

    try:
        loan = parse_loan(line)
    except ValueError:
        print("Error: los dias no son un numero valido.")
        return

    if loan is None:
        return

    # Pedir y validar DNI
    while True:
        dni = input("DNI del socio (8 digitos): ")
        if valid_dni(dni):
            break
        print("DNI invalido. Debe tener exactamente 8 digitos numericos.")

    loan["memberDni"] = dni.strip()
    loan_number = random.randint(1000, 9999)
    loan["loanNumber"] = loan_number

    loan_list.append(loan)
    print(f"Prestamo registrado correctamente. Nro de prestamo: {loan_number}")


def list_loans():
    # Muestra todos los prestamos registrados
    print()
    print("=== LISTA DE PRESTAMOS ===")
    if not loan_list:
        print("No hay prestamos registrados.")
        return
    print(f"{'Titulo':<25} {'DNI Socio':<12} {'Dias':<6} {'Nro Prestamo':<12}")
    print("-" * 55)
    for l in loan_list:
        print(f"{l['bookTitle']:<25} {l.get('memberDni', '-'):<12} "
              f"{l['loanDays']:<6} {l.get('loanNumber', '-'):<12}")


if __name__ == "__main__":
    # Bloque de ejecucion principal (spike 9.10)
    print("=== SISTEMA DE PRESTAMOS DE LA BIBLIOTECA DEL BARRIO ===")
    running = True

    while running:
        print()
        print("1. Nuevo prestamo")
        print("2. Listar prestamos")
        print("3. Salir")
        option = input("Elegi una opcion: ")

        if option == "1":
            add_loan()
        elif option == "2":
            list_loans()
        elif option == "3":
            running = False
            print("Saludos!")
        else:
            print("Opcion invalida.")
```

**Aceptaciones válidas menores:**
- `loan_list` puede llamarse `loans` o `prestamos`.
- `parse_loan` puede retornar una tupla en lugar de dict.
- La validación del DNI puede usar `len(clean) >= 8` en lugar de exactamente 8.
- El menú puede tener opción 0 para salir en lugar de 3.

## 2. Salidas de referencia para la corrección

| Prueba | Entrada | Salida esperada |
| --- | --- | --- |
| Opción 1 + "Cien Años de Soledad, 12345678, 7" + DNI "12345678" | `1`, `Cien Años de Soledad, 12345678, 7`, `12345678` | "Préstamo registrado. Nro de préstamo: (4 dígitos)" |
| Opción 1 + "Cien Años de Soledad, 12345678" | `1`, `Cien Años de Soledad, 12345678` | "Formato inválido. Usá: titulo, dni, dias." |
| Opción 1 + "Cien Años de Soledad, 12345678, siete" | `1`, `Cien Años de Soledad, 12345678, siete` | "Error: los días no son un número válido." |
| Opción 1 + DNI "abc" | Préstamo válido + `abc` | "DNI inválido. Debe tener exactamente 8 dígitos numéricos." |
| Opción 2 | `2` con 1 préstamo | Tabla con título, DNI, días, número de préstamo |
| Opción 3 | `3` | "Saludos!" |

## 3. Criterios de corrección ítem por ítem

| Ítem | Pts | Qué puntúa | Error previsto |
| --- | --- | --- | --- |
| 1a — parse_loan | 15 | split, strip, return dict | Sin split ni strip → 0 pts; no devuelve dict → descontar 5 pts |
| 1b — Validar 3 campos | 10 | len(parts) != 3 | No valida cantidad de campos → 0 pts |
| 1c — ValueError | 5 | Captura excepción | Sin try/except → 0 pts |
| 2a — add_loan | 15 | Llama parse, try/except, agrega | No agrega a la lista → 0 pts |
| 2b — valid_dni | 10 | strip + isdigit + len == 8 | Sin limpieza → descontar 5 pts |
| 2c — Validar DNI | 10 | Reintento while True | Sin reintento → descontar 5 pts |
| 2d — Número aleatorio | 5 | random.randint | Sin import random → 2 pts |
| 3a — Menú | 5 | 3 opciones, while | Menos opciones → descontar 2 pts |
| 3b — Listar | 10 | Itera loan_list, formato | Sin formato alineado → descontar 3 pts |
| 3c — Opción inválida | 5 | Mensaje y retorno | Crashing → 0 pts |
| 4a — split sin coma | 5 | "Devuelve lista de 1 elemento" | Respuesta incorrecta → 0 pts |
| 4b — try mejor que if | 5 | "Maneja cualquier caracter no numérico" | Sin justificación → descontar 3 pts |

## 4. Pauta de devolución

Idéntica a versión A (ver `evaluacion-u3-version-a-anexo-docente.md`). Encuentro 27. Recuperación al inicio del encuentro 28 si menos de 60 pts.