# Anexo docente — Encuentro 31: Cierre U4: entrega final

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

**Consigna final:** Cada grupo prepara su repositorio para la defensa.

**Solución completa del programa integrador verificada:**

```python
# main.py — Programa integrador Verdulería
# Compila y ejecuta sin errores en Python 3.

from productos import register_product, list_products, find_product
from ventas import sell_product
from factura import show_invoice


def read_int(prompt):
    while True:
        try:
            return int(input(prompt))
        except ValueError:
            print("Eso no es un número entero; intenta de nuevo.")


def main():
    product_list = [
        {"name": "manzana", "price": 2.50, "kilos": 10.0},
        {"name": "banana", "price": 1.80, "kilos": 15.0},
        {"name": "naranja", "price": 1.20, "kilos": 20.0},
    ]
    current_invoice = []
    
    options = [
        "Registrar producto",
        "Listar productos",
        "Vender producto",
        "Ver factura actual",
        "Salir"
    ]
    
    while True:
        print("\n=== VERDULERÍA — Sistema de venta ===")
        for i, option in enumerate(options, start=1):
            print(f"{i}. {option}")
        
        choice = read_int("Opción: ")
        
        if choice == 1:
            register_product(product_list)
        elif choice == 2:
            list_products(product_list)
        elif choice == 3:
            sell_product(product_list, current_invoice)
        elif choice == 4:
            show_invoice(current_invoice)
        elif choice == 5:
            print("Gracias por usar Verdulería. ¡Hasta la próxima!")
            break
        else:
            print("Opción inválida. Elegí un número del 1 al 5.")


if __name__ == "__main__":
    main()
```

**`DEFENSA.md` completo esperado:**

```markdown
# Defensa del trabajo final integrador

## Integrante: Ana López

### Módulo a cargo
Registro de productos (productos.py): register_product(), list_products(), find_product().
Validación de precio y kilos con read_float().

### Error corregido
Olvidé normalizar el nombre con .strip().lower(). "Manzana" no coincidía con "manzana"
en find_product(). Lo corregí aplicando .strip().lower() en todas las búsquedas.

### PR revisado
Revisé el PR de Bruno (#4 — ventas.py). Verifiqué que validara stock suficiente
antes de descontar y que usara .append() para acumular items en la factura.

### Pregunta preparada
¿Qué pasa si dos integrantes modifican el mismo archivo en distintas ramas?
Se produce un conflicto de merge. GitHub lo marca y hay que resolverlo manualmente
eligiendo qué cambios conservar.
```

## 2. Solución de la actividad de extensión

**Para grupos que completaron todo — mejoras opcionales:**

**Opción "Actualizar precio" (extensión — issue #7):**

En `productos.py`:

```python
def update_price(product_list):
    name = input("Nombre del producto: ").strip().lower()
    product = find_product(product_list, name)
    if product is None:
        print(f"Producto '{name}' no encontrado.")
        return
    new_price = read_float("Nuevo precio por kilo ($): ")
    if new_price <= 0:
        print("El precio debe ser mayor a cero.")
        return
    product["price"] = new_price
    print(f"✓ Precio actualizado a ${new_price:.2f}/kg.")
```

En `main.py`, agregar opción 6 y el condicional `elif choice == 6: update_price(product_list)`.

**Refactor a `utils.py`:**

```python
# utils.py
def read_int(prompt):
    while True:
        try:
            return int(input(prompt))
        except ValueError:
            print("Eso no es un número entero; intenta de nuevo.")

def read_float(prompt):
    while True:
        try:
            return float(input(prompt))
        except ValueError:
            print("Eso no es un número válido; intenta de nuevo.")
```

## 3. Respuesta esperada del ejercicio

| Elemento | Esperado | Verificación |
| --- | --- | --- |
| `python main.py` funciona | Sin errores | Ejecutar en la máquina del docente |
| 10 pruebas pasan (checklist) | Todas ✅ | Ejecutar secuencia de prueba |
| Issues cerrados | 6 en Closed | Pestaña Issues |
| PRs mergeados | ≥ 3 | Pestaña Pull requests |
| `DEFENSA.md` con secciones | 1 por integrante | Leer archivo |
| Último commit pusheado "cierre" | Mensaje visible | `git log --oneline -1` |
| README actualizado | Estado del proyecto | Leer |
| `.gitignore` existe | `__pycache__/` | `cat .gitignore` |
| Sin persistencia | No hay `open(` | `grep -r "open(" *.py` (vacío) |

**Secuencia de prueba completa para el docente:**

```
1. python main.py
2. Opción 1 → "papa", 1.2, 25  → ✓ registrado
3. Opción 2 → papa aparece al final
4. Opción 3 → "papa", 3 → ✓ venta registrada $3.60
5. Opción 3 → "banana", 100 → "Stock insuficiente. Hay 15.00 kg disponibles."
6. Opción 4 → muestra papa + banana + total
7. Opción 3 → "banana", 5 → ✓ venta registrada $9.00
8. Opción 4 → factura actualizada con tres items
9. Opción 6 → "Opción inválida"
10. Opción "hola" → "Eso no es un número entero"
11. Opción 5 → "Gracias por usar Verdulería."
```

## 4. Criterios de corrección (lista de verificación)

| ✔ | Criterio | Peso |
| --- | --- | --- |
| ☐ | Programa ejecutable sin errores | 20% |
| ☐ | Todas las operaciones funcionan (registrar, listar, vender, factura) | 20% |
| ☐ | Validación de entrada (try/except en opciones, precio, kilos) | 15% |
| ☐ | Manejo de casos borde (factura vacía, stock insuficiente, opción inválida) | 15% |
| ☐ | Repositorio profesional (README, issues, PRs, main protegida) | 15% |
| ☐ | DEFENSA.md completo con todos los integrantes | 10% |
| ☐ | Sin persistencia (no hay open, csv, json) | 5% |

**Rúbrica breve para evaluación del TP:**

| Nivel | Descripción | Rango |
| --- | --- | --- |
| Destacado | Programa completo, validación en todas las entradas, repo impecable, DEFENSA.md completa | 9-10 |
| Aprobado | Programa funciona pero falta alguna validación o DEFENSA.md incompleta | 7-8 |
| Mínimo | Programa funciona con limitaciones, repo con algunas fallas | 6 |
| Insuficiente | Programa no funciona o repo sin flujo profesional | 1-5 |

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| El programa crashea con opción inválida | Falta el `else` en el menú | "`if choice == 1:` ... pero si el usuario elije 6, ¿qué pasa?" |
| La factura se ve vacía después de vender | `current_invoice` se pasa mal o se reinicia | "¿Estás pasando la misma lista `current_invoice` que se usa en `sell_product`?" |
| No hay tag de versión | Se olvidaron | No es obligatorio; si quieren, crear tag ahora |
| DEFENSA.md con una sola sección | El resto no editó | "Cada uno escribe su sección, commit en su rama, PR y merge." |
| Repositorio local desactualizado vs remoto | El último push quedó pendiente | "Verificá en GitHub que el último commit esté. Si no, `git push`." |
| El alumno no sabe qué va a decir en la defensa | No practicó | "Contame en 2 minutos qué hace tu módulo. Si no podés ahora, practicá 3 veces antes del Encuentro 32." |

## 6. Registro de la clase

**Por grupo, registrar:**

- [ ] `python main.py` funciona en la máquina del docente: Sí / No
- [ ] Pruebas de la checklist: 0-10 pasaron _____
- [ ] Integrantes presentes: _____/_____
- [ ] DEFENSA.md completo: Sí / No
- [ ] Último commit pusheado: Sí / No
- [ ] Nota TP estimada: Destacado / Aprobado / Mínimo / Insuficiente
- [ ] Grupo necesita recuperación antes de la defensa: Sí (¿qué?) / No
- [ ] Observaciones: _____

**Preparación para la defensa (Encuentro 32):**

- Recordar a los alumnos: la defensa es individual (10-15 min por persona).
- Llevar la rúbrica de defensa impresa o en pantalla para evaluar en el momento.
- Si un grupo no completa la entrega, coordinar una mesa de examen para el Encuentro 32 con prioridad sobre quienes ya están listos.
- El commit final con `git tag v1.0` es un hito del curso: celebralo con el grupo. Llegaron al final de un ciclo completo de programación y trabajo colaborativo.