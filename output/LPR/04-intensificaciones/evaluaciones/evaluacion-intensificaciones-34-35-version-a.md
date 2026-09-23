# Evaluación del momento 34-35 — Versión A

> Dominio de esta versión: pizzería (U3) + videoteca (U4). Duración: 90 minutos. Puntaje total: apto/no apto por objetivo mínimo. Resolución individual, con computadora, sin celular. Las condiciones completas están en `evaluacion-intensificaciones-34-35.md`.

## Antes de empezar

- Crea un archivo `pizzeria_videoteca.py` en la carpeta `tp-u3/` o `tp-u4/` de tu repo grupal.
- Escribí el programa en un solo archivo `.py`. Definí las funciones primero, el bloque de ejecución al final con `if __name__ == "__main__":`.
- Usá `input()` para leer datos y `print()` con f-strings para mostrar resultados.
- No se permite celular. Trabajo individual.
- Al terminar, hace commit y push al repo grupal.

## Objetivos de la prueba

- Usar `print()` / `input()` con conversión de tipos (`int()`, `float()`).
- Usar métodos de cadenas (`split`, `strip`, `join`, `replace`) para procesar la entrada del usuario.
- Aplicar validación con `try`/`except` para manejar errores de entrada.
- Usar un bucle `while` para mantener un menú activo.
- Definir y usar funciones con `def`, parámetros y `return`.

## Consigna — Programa de pizzería con gestión de pedidos y videoteca

Escribí un programa que gestione los pedidos de una **pizzería** y el alquiler de películas de una **videoteca**. El programa debe tener un menú principal con opciones para ambas funcionalidades.

### Datos de ejemplo del dominio

- **ingredientes**: ["Mozzarella", "Jamón", "Aceitunas", "Chorizo"]
- **telefono**: "15-1234-5678" (número de contacto del cliente)
- **producto**: nombre de la película o pizza
- **precio**: precio unitario en pesos
- **stockWeight**: cantidad disponible en kilos o copias

### Requisitos del programa

1. **Menú principal** con `while True` y opciones:
   - 1: Pedir pizza
   - 2: Alquilar película
   - 3: Ver resumen del día
   - 4: Salir

2. **Opción 1 — Pedir pizza**
   - Pedir nombre del **comprador** (cliente).
   - Pedir los **ingredientes** separados por coma y usá `split` para procesarlos.
   - Validar que el teléfono del cliente sea numérico con `try`/`except`.
   - Calcular el precio total según la cantidad de ingredientes.
   - Mostrar el resumen del pedido con f-string.

3. **Opción 2 — Alquilar película**
   - Pedir nombre de la **película** (`movieTitle`).
   - Pedir la cantidad de copias a alquilar.
   - Verificar que haya **stock** suficiente. Si no hay, mostrar "Sin copias disponibles".
   - Calcular el precio del alquiler (`moviePrice` × cantidad).
   - Guardar el alquiler en una lista.

4. **Opción 3 — Ver resumen del día**
   - Mostrar todos los pedidos y alquileres registrados con `for`.
   - Calcular y mostrar el total de ingresos del día.

5. **Opción 4 — Salir**

### Función requerida

Definí al menos una función `parseAppointment(orderText, customerName, orderList)` que reciba los datos del pedido, los procese y devuelva un diccionario con los datos del turno.

### Formato de salida esperado

```
=== PIZZERIA + VIDEOTECA ===
1. Pedir pizza
2. Alquilar película
3. Ver resumen del día
4. Salir
Opción: 1
Nombre del comprador: Ana
Ingredientes: Mozzarella, Jamón, Aceitunas
Teléfono: 15-1234-5678
Pedido registrado: Ana pidió una pizza con 3 ingredientes por $15.00
```

## Al terminar

Commit con mensaje `"feat: evaluacion 34-35 pizzeria_videoteca"` y push al repo grupal. Avisá al docente para que verifique.