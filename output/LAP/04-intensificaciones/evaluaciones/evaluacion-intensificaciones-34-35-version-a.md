# Evaluación del momento 34-35 — Versión A

> Dominio de esta versión: pizzería (pedidos, ingredientes, teléfono, comprador). Duración: 90 minutos. Puntaje total: apto/no apto por objetivo mínimo. Resolución individual, con computadora, sin celular. Las condiciones completas están en `evaluacion-intensificaciones-34-35.md`.

## Antes de empezar

- Aprendiste a procesar texto con `split`, `strip`, `join`, `replace` y a validar entrada con `try`/`except`.
- También practicaste el flujo profesional del repositorio: README, issues, ramas y PR.
- Creá un archivo `pizzeria.py` en la carpeta `tp-u3/` de tu repo grupal.
- No se permite celular. Trabajo individual.
- Al terminar, hace commit y push al repo grupal.

## Objetivos de la prueba

- Procesar texto de entrada con métodos de cadenas (`split`, `strip`, `join`, `replace`).
- Escribir f-strings con formato legible.
- Validar datos de entrada con `try`/`except` capturando `ValueError`.
- Construir un menú en memoria con diccionario como almacenamiento.
- Verificar el flujo profesional del repositorio (README, issues, ramas, PR).

## Parte 1 — Procesamiento de texto de pedidos de pizzería

### 1A — Parsear un pedido (15 puntos conceptuales)

El texto de entrada de un **pedido** tiene este formato separado por `|`:

```
Muzzarella|Tomate|Aceitunas|Jamon
```

Escribí una función `parseOrder(orderText)` que reciba ese texto, lo divida con `split("|")`, limpie espacios con `strip()` y devuelva una lista de **ingredientes**.

Ejemplo:
```python
# Llamada:
resultado = parseOrder(" Muzzarella | Tomate | Aceitunas | Jamon ")
# Devuelve:
# ["Muzzarella", "Tomate", "Aceitunas", "Jamon"]
```

### 1B — Mostrar detalle del pedido (15 puntos conceptuales)

Escribí una función `mostrar_pedido(comprador, ingredientes, orderPrice)` que reciba el nombre del **comprador**, la lista de **ingredientes** y el **precio** (`orderPrice`), y muestre usando f-strings:

```
Pedido de Ana:
  Ingredientes: Muzzarella, Tomate, Aceitunas, Jamon
  Precio: $1200.00
  Teléfono de contacto: 1145678901
```

Usá `join(", ")` para unir los ingredientes.

### 1C — Validar teléfono (15 puntos conceptuales)

Escribí una función `validPhone(telefono)` que verifique que el string tenga exactamente 10 caracteres y todos sean dígitos (usá `len()` y `isdigit()`). Si no cumple, debe devolver `False`. Integrá esta validación en el programa.

## Parte 2 — Menú en memoria con pedidos

Implementá un mini-menú que permita:

```
=== PIZZERÍA ===
1. Cargar pedido
2. Ver todos los pedidos
3. Buscar pedido por nombre del comprador
4. Salir
```

Los **pedidos** se guardan en un diccionario donde la clave es el nombre del **comprador** (`customerName`) y el valor es otro diccionario con los datos del pedido: ingredientes, precio y teléfono.

Usá `try`/`except` al cargar el **precio** (`orderPrice`) para que, si el usuario ingresa un texto no numérico, el programa muestre "Precio inválido. Ingrese un número." y pida el dato de nuevo.

### Función validada con `try`/`except`

```python
def read_float(mensaje):
    while True:
        try:
            return float(input(mensaje))
        except ValueError:
            print("Precio inválido. Ingrese un número.")
```

## Parte 3 — Flujo profesional del repositorio (verificación)

Además del código en `tp-u3/pizzeria.py`, verificá que en el repositorio grupal:

1. El README.md tenga al menos título, descripción y cómo ejecutar el programa.
2. Exista al menos un **issue** abierto con una tarea (por ejemplo, "Agregar opción de modificar pedido").
3. El **trabajo final** esté en una rama `feature/trabajo-final` con un **pull request** abierto hacia `main`.
4. Se haya hecho al menos un code review (comentario en el PR).

## Al terminar

Commit con mensaje `"feat: evaluacion 34-35 pizzeria"` y push al repo grupal. Avisá al docente para que verifique tanto el código como el flujo profesional del repositorio.