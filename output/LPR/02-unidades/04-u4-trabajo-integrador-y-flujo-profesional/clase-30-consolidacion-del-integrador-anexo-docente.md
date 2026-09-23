# Anexo docente — Encuentro 30: Consolidación del integrador

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

**Consigna:** Cada grupo termina el integrador y prepara la defensa.

**Checklist de verificación final:**

| Prueba | Entrada | Salida esperada |
| --- | --- | --- |
| Registrar producto | Opción 1, nombre "papa", precio 1.2, kilos 25 | Producto registrado, aparece en la lista |
| Listar productos | Opción 2 | Muestra todos los productos con precio y stock |
| Vender con stock suficiente | Opción 3, "papa", 3 kg | Venta registrada, stock actualizado |
| Vender sin stock suficiente | Opción 3, "banana", 100 kg | "Stock insuficiente" |
| Vender producto inexistente | Opción 3, "xyz" | "Producto no encontrado" |
| Ver factura vacía | Opción 4 (sin ventas previas) | "No hay ventas registradas" |
| Ver factura con ventas | Opción 4 después de vender | Muestra items y total acumulado |
| Opción inválida | Opción 6 | "Opción inválida. Elegí un número del 1 al 5." |
| Entrada no numérica donde va número | Opción 1, luego "abc" para precio | "Eso no es un número válido; intenta de nuevo." |
| Salir | Opción 5 | "Gracias por usar Verdulería. ¡Hasta la próxima!" |

**Archivos esperados en la raíz del repositorio:**
- `main.py` — programa integrador ejecutable
- `productos.py` — módulo de registro y consulta
- `ventas.py` — módulo de venta y stock
- `factura.py` — módulo de facturación
- `README.md` — README de portada completo
- `.gitignore` — con `__pycache__/` y `.vscode/`
- `DEFENSA.md` — con sección por cada integrante
- `.gitignore` — con `__pycache__/` y `.vscode/`

## 2. Solución de la actividad de extensión

**Mejora opcional — Actualizar precio:**

```python
def update_price(product_list):
    """Cambia el precio de un producto existente."""
    name = input("Nombre del producto a actualizar: ").strip().lower()
    product = find_product(product_list, name)
    if product is None:
        print("Producto no encontrado.")
        return
    nuevo_precio = read_float("Nuevo precio por kilo ($): ")
    product["price"] = nuevo_precio
    print(f"Precio de '{product['name'].capitalize()}' actualizado a ${nuevo_precio:.2f}/kg.")
```

**Refactor — Módulo `utils.py`:**

```python
# utils.py
# Funciones de utilidad compartidas para el integrador.


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

Desde `main.py` y los otros módulos: `from utils import read_int, read_float`.

## 3. Respuesta esperada del ejercicio

| Indicador | Esperado | Cómo verificar |
| --- | --- | --- |
| Programa ejecuta sin errores | `python main.py` funciona | Ejecutar en terminal |
| Checklist completa pasa | 8/8 pruebas correctas | Ejecutar cada prueba manualmente |
| DEFENSA.md existe | Archivo en la raíz | `cat DEFENSA.md` |
| DEFENSA.md tiene sección por integrante | Al menos 3 secciones | Leer el archivo |
| Issues todos cerrados | 0 issues abiertos | Pestaña Issues → Filter: Open |
| PRs mergeados | Al menos 3 | Pestaña Pull requests → Filter: Merged |
| README completo | 6 secciones visibles | Página principal del repo |

## 4. Criterios de corrección (lista de verificación)

| ✔ | Criterio | Peso |
| --- | --- | --- |
| ☐ | El programa pasa la checklist canónica (8/8 pruebas) | 30% |
| ☐ | DEFENSA.md existe con sección por cada integrante | 20% |
| ☐ | Todos los issues están cerrados o con PR mergeado | 15% |
| ☐ | README completo y versionado | 10% |
| ☐ | Main protegida y .gitignore existente | 10% |
| ☐ | Cada integrante tiene al menos un PR mergeado | 15% |

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| `import` falla con ModuleNotFoundError | Los archivos .py no están en la misma carpeta | "Verificá que todos los .py estén en `trabajo-final/`." |
| Factura vacía después de vender | Se crea una nueva lista `invoice = []` en `sell_product()` en vez de usar la lista compartida | "La factura tiene que ser la misma lista que pasás como argumento." |
| Menú no vuelve al mostrar la opción | Falta `break` o indentación incorrecta | "Verificá que la opción 5 (Salir) sea la única que interrumpe el `while True`." |
| `int()` crash con float como "3.5" | `read_int()` se usa para precios | "Usá `read_float()` para precio y kilos; `read_int()` solo para opciones del menú." |
| Búsqueda no encuentra "manzana" si se escribe "Manzana" | Falta normalizar con `.strip().lower()` | "Aplicá `.strip().lower()` al leer el nombre y al buscar." |
| Integración no probada antes del merge | Se mergea el PR sin ejecutar `python main.py` | "Probá el programa completo antes de mergear. Si falla, no se mergea." |

## 6. Registro de la clase

**Por grupo, registrar:**

- [ ] Programa pasa la checklist canónica: _____ / 8
- [ ] DEFENSA.md existe y tiene sección por cada integrante: Sí / No
- [ ] Issues pendientes: _____
- [ ] PRs mergeados: _____
- [ ] Integrantes que necesitan refuerzo en código: _____
- [ ] Observaciones: _____

**Para la evaluación de proceso:**

- Si un grupo tiene menos de 6/8 en la checklist, priorizar la corrección en el Encuentro 31.
- Los grupos que completaron todo pueden ayudar a otros grupos como revisores pares.
- Registrar qué integrantes no tienen DEFENSA.md completa: necesitan asistencia individual.
