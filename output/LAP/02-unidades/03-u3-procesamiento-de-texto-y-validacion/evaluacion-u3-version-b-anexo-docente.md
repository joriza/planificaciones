# Anexo docente — Evaluación de la Unidad 3 — Encuentro 26 — Versión B

> Documento docente formal. Solución completa, salidas de referencia y criterios de corrección.

## 1. Solución completa (`veterinaria.py`)

```python
# veterinaria.py — Gestion de turnos de una veterinaria
# Evaluacion U3 — Version B
# Permite registrar turnos con parseo de texto y validacion

import random

# Lista de turnos en memoria
appointment_list = []


def parse_appointment(appointment_text):
    # Recibe un texto con formato "nombre, precio, cantidad"
    # Devuelve un dict con petName, consultPrice (float), quantity (int)
    parts = appointment_text.split(",")
    if len(parts) != 3:
        print("Formato invalido. Usa: nombre, tarifa, cantidad.")
        return None

    pet_name = parts[0].strip()
    price_text = parts[1].strip()
    qty_text = parts[2].strip()

    if not pet_name or not price_text or not qty_text:
        print("Formato invalido. Usa: nombre, tarifa, cantidad.")
        return None

    consult_price = float(price_text)
    quantity = int(qty_text)

    if consult_price <= 0 or quantity <= 0:
        print("Tarifa y cantidad deben ser valores positivos.")
        return None

    return {
        "petName": pet_name,
        "consultPrice": consult_price,
        "quantity": quantity
    }


def valid_name(name):
    # Limpia espacios y verifica que no este vacio
    clean = name.strip()
    return len(clean) > 0


def add_appointment():
    # Pide una linea de texto, la parsea y agrega el turno a la lista
    print()
    print("=== AGREGAR TURNO ===")
    line = input("Ingresa: nombre de la mascota, tarifa, cantidad: ")

    try:
        appointment = parse_appointment(line)
    except ValueError:
        print("Error: tarifa o cantidad no son numeros validos.")
        return

    if appointment is None:
        return

    # Pedir y validar historial (nombre de la mascota otra vez como confirmacion)
    while True:
        pet_check = input("Nombre de la mascota (confirmacion): ")
        if valid_name(pet_check):
            break
        print("El nombre no puede estar vacio.")

    ticket = random.randint(1000, 9999)
    appointment["ticket"] = ticket
    appointment["history"] = pet_check.strip()

    appointment_list.append(appointment)
    print(f"Turno registrado correctamente. Ticket: {ticket}")


def list_appointments():
    # Muestra todos los turnos registrados
    print()
    print("=== LISTA DE TURNOS ===")
    if not appointment_list:
        print("No hay turnos registrados.")
        return
    print(f"{'Mascota':<20} {'Historial':<15} {'Tarifa':<8} {'Cant':<6} {'Ticket':<6}")
    print("-" * 60)
    for a in appointment_list:
        print(f"{a['petName']:<20} {a.get('history', '-'):<15} "
              f"{a['consultPrice']:<8.2f} {a['quantity']:<6} {a['ticket']:<6}")


if __name__ == "__main__":
    print("=== SISTEMA DE TURNOS DE LA VETERINARIA ===")
    running = True

    while running:
        print()
        print("1. Agregar turno")
        print("2. Listar turnos")
        print("3. Salir")
        option = input("Elegi una opcion: ")

        if option == "1":
            add_appointment()
        elif option == "2":
            list_appointments()
        elif option == "3":
            running = False
            print("Saludos!")
        else:
            print("Opcion invalida.")
```

## 2. Salidas de referencia

| Prueba | Entrada | Salida esperada |
| --- | --- | --- |
| Opción 1 (válido) | `"Firulais, 15.0, 1"` | Turno agregado, ticket aleatorio |
| Opción 1 (mal formato) | `"Firulais, 15.0"` | "Formato inválido. Usá: nombre, tarifa, cantidad." |
| Opción 1 (tarifa no num.) | `"Firulais, quince, 1"` | "Error: tarifa o cantidad no son números válidos." |
| Opción 2 | `2` con 1 turno | Tabla con mascota, historial, tarifa, cantidad, ticket |

## 3. Criterios de corrección

Idénticos a la versión A (ver `evaluacion-u3-version-a-anexo-docente.md`), con ajustes:

| Ítem | Ajuste |
| --- | --- |
| Parte 1 | parseAppointment en lugar de parseOrder; petName en lugar de customerName; consultPrice en lugar de orderPrice; mascota en lugar de comprador |
| Parte 2 | validName en lugar de validPhone; turno en lugar de pedido; veterinaria en lugar de pizzería; appointmentList en lugar de orderList; appointmentText en lugar de orderText; historial en lugar de teléfono |
| Parte 3 | turnos en lugar de pedidos |

## 4. Devolución

Idéntica a versión A.