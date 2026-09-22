# Encuentro 25 — Cierre U3: repaso y TP

> Procesamiento de texto y validación · Encuentro de cierre de unidad

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 25 de 36 |
| Unidad | 3 — Procesamiento de texto y validación |
| Eje temático | 3 — Procesamiento de texto y validación |
| Carácter/Objetivo | Actitudinal |
| Estructura | cierre |
| Duración teórica | 120 minutos (2 horas reloj) |
| TP obligatorio | TP-U3: menú de consola validado |
| Concepto nuevo | Cierre U3: repaso y TP |
| Requisitos previos | Toda la Unidad 3: métodos de texto, validación con `try/except`, módulos, menú en memoria |
| Uso de celular | No permitido |
| Organización del trabajo | Grupos de 2 personas. Hoy se entrega el TP-U3. La primera mitad es repaso guiado; la segunda es trabajo autónomo y entrega. |

### Reparto de tiempos (encuentro de cierre)

| Momento | Tiempo |
| --- | --- |
| Apertura | 10 min |
| Consolidación | 40 min |
| Trabajo del TP | 45 min |
| Ciclo de entrega | 15 min |
| Cierre | 10 min |
| **Total** | **120 min** |

## 2. Objetivos de aprendizaje

1. Sistematizar los conceptos de la Unidad 3: métodos de texto, validación, módulos y menú en memoria.
2. Finalizar el TP-U3 agregando las funcionalidades faltantes y verificando su correcto funcionamiento.
3. Crear la carpeta `tp-u3/` con el programa, realizar commit y push al repositorio grupal.
4. Reflexionar sobre el proceso de integración: cómo se combinan funciones, colecciones, texto y validación en un programa útil.

## 3. Apertura (10 min)

### Charla rápida: la pizza completa

Armar una pizza es juntar ingredientes que vienen de distintos lados: la masa (funciones), la salsa (validación), el queso (colecciones), los toppings (métodos de texto). Solos no son una pizza; juntos, sí. La Unidad 3 fue eso: tomar las piezas que ya conocíamos (funciones, colecciones, `if`, `while`) y agregarles el procesamiento de texto y la validación para que el programa no se rompa ante cualquier cosa que tipee el usuario. Hoy cerramos esa pizza y la entregamos.

### Repaso rápido de 5 minutos

| Concepto clave | Lo que hace | Ejemplo mínimo |
| --- | --- | --- |
| `split()`, `strip()`, `join()`, `replace()` | Procesan texto del usuario | `"  a, b ".split(",")` → `["  a", " b "]` |
| `try/except ValueError` | Atrapa error de conversión | `int("hola")` → `ValueError` |
| Patrón de reintento | `while True` + `try/except` + `return` | Ciclo hasta obtener dato válido |
| `import random` | Números aleatorios | `random.randint(1, 100)` |
| Menú en memoria | `while True` + opciones + `break` | Las opciones son strings, se comparan con `==` |
| Sin persistencia | Todo vive en memoria | Al cerrar, se pierde; en la próxima ejecución arranca vacío |

## 4. Consolidación (40 min)

### Ejercicio de sistematización: armado guiado del TP-U3

**Consigna del TP-U3:**
> Desarrollá un programa de gestión de pedidos para una pizzería. El programa debe:
> 1. Registrar pedidos con nombre del comprador, teléfono, lista de pizzas (cantidad + nombre + precio unitario) y número de ticket.
> 2. Listar todos los pedidos registrados.
> 3. Buscar pedidos por teléfono.
> 4. Mostrar las ventas totales.
> 5. Usar validación `try/except ValueError` para toda entrada numérica.
> 6. Usar métodos de texto (`split`, `strip`, `join`, `replace`) para procesar la entrada.
> 7. Generar número de ticket con `random.randint`.
> 8. Ser un solo archivo `pedidos.py` en la carpeta `tp-u3/`.

### Checklist de verificación del TP-U3 (para que cada grupo lo revise)

- [ ] El programa arranca y muestra el menú
- [ ] Opción 1: Agregar pedido — pide nombre (texto), teléfono (texto, se limpia), pizzas (cant + nombre + precio)
- [ ] La entrada de cantidades y precios valida con `try/except ValueError` y mensaje accionable
- [ ] Opción 2: Listar pedidos — muestra todos los registrados
- [ ] Opción 3: Buscar por teléfono — funciona con o sin espacios/guiones
- [ ] Opción 4: Mostrar ventas totales
- [ ] Opción 0: Salir — corta el programa
- [ ] Opciones inválidas → mensaje "Opción inválida"
- [ ] El código tiene funciones arriba y ejecución en `if __name__ == "__main__":`
- [ ] Sin `except:` desnudo
- [ ] Sin `open()`, archivos, CSV ni JSON
- [ ] Sin clases, lambda ni comprehensions avanzadas

### Si un grupo ya completó todo en la clase 24

Que trabaje en funcionalidades extra para su programa:
- Opción "Modificar pedido": buscar por ticket, cambiar cantidad o precio.
- Opción "Pedido más caro": mostrar el pedido con mayor total.
- Ordenar pedidos por total (de mayor a menor) con `sorted()` y mostrarlos.

## 5. Trabajo del TP (45 min)

### Trabajo autónomo en grupos

Cada grupo trabaja en su programa:
- Los que terminaron: pulen detalles, agregan funcionalidades extra, verifican el checklist.
- Los que no terminaron: completan lo que falta con ayuda del docente.
- El docente circula, resuelve dudas puntuales, verifica avances.

### Pautas para la entrega

1. **Crear la carpeta del TP:** dentro del repositorio grupal, crear `tp-u3/` (si no existe).
2. **Copiar el archivo:** `pedidos.py` adentro de `tp-u3/`.
3. **Verificar ejecución:** `python pedidos.py` desde la terminal, en la carpeta `tp-u3/`.
4. **Probar casos borde:**
   - Entrada no numérica en cantidad → debe pedir de nuevo
   - Teléfono con espacios → debe limpiarlos
   - Pedido sin items → debe rechazar
   - Opción 9 (inexistente) → "Opción inválida"
   - Buscar teléfono que no existe → "No se encontraron pedidos"

## 6. Ciclo de entrega (15 min)

### Pasos de entrega (lo hace cada grupo, guiado por el docente)

```bash
# 1. Verificar que estamos en el repositorio correcto
git status

# 2. Agregar la carpeta tp-u3/ y el archivo
git add tp-u3/pedidos.py

# 3. Commit con mensaje descriptivo
git commit -m "tp-u3: menú de consola validado para pizzería"

# 4. Push al remoto (GitHub)
git push
```

**Nota importante:** si el repositorio usa mono-rama `main`, se pushea directo. No crear ramas hasta la Unidad 4.

### Registro de entrega

El docente registra qué grupos completaron la entrega. Los grupos que no terminan pueden hacerlo en la semana y pushear antes de la clase siguiente. Informar por el medio habitual del curso (grupo de WhatsApp / aula virtual).

## 7. Cierre (10 min)

### Qué te llevás

- La Unidad 3 nos dio las herramientas para que los programas **no se rompan** con la entrada del usuario.
- El TP-U3 muestra cómo integrar todo: funciones, colecciones, texto y validación.
- Git no es solo para código: es la bitácora del avance. Cada commit documenta un paso.
- Sin persistencia: los datos viven en memoria mientras el programa corre. No se necesita archivos para tener un programa útil.
- Próximo paso: la evaluación de la Unidad 3.

### Lo que viene

En el **Encuentro 26** vamos a hacer la **Evaluación de la Unidad 3**: un ejercicio integrador similar al TP, pero individual, para verificar lo que aprendimos.

## 8. Errores comunes y trampas

| Error | Causa | Fix |
| --- | --- | --- |
| El programa no guarda los pedidos entre ejecuciones | Sin persistencia es esperado: el programa arranca vacío cada vez | No es un bug; explicar que la persistencia se ve más adelante |
| Olvida hacer `git add` antes del commit | `git commit` solo commitea lo que está en el stage | `git status` para ver qué falta agregar |
| El commit tiene mensaje genérico como "cambios" | No documenta qué se hizo | Usar el formato del curso: `"tp-u3: <avance>"` |
| `git push` falla porque el remoto no está configurado | Es la primera vez que pushean desde esa máquina | Verificar con `git remote -v` y configurar si falta |
| El programa tiene errores que no se detectaron en clase | No probaron los casos borde | Usar la checklist de verificación antes de entregar |
| La carpeta se llama `TP-U3/` o `Tp3/` en vez de `tp-u3/` | Inconsistencia con la nomenclatura del curso | El nombre debe ser `tp-u3/` (minúsculas, guión) para mantener consistencia con las unidades anteriores |
| Olvida el `if __name__ == "__main__":` | El código suelto se ejecuta al importar | Revisar la convención del curso: funciones arriba, ejecución en el bloque principal |