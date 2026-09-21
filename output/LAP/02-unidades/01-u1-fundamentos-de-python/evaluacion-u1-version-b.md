# Evaluación de la Unidad 1 — Versión B: inventario de productos

## Metadatos

| Campo | Valor |
|---|---|
| Versión | B |
| Dominio de datos | Inventario de stock en tres depósitos |
| Instancia | Evaluación de la Unidad 1 — Encuentro dedicado 9 |
| Duración | 120 minutos (desarrollo, entrega y defensa) |
| Destinatarios | Grupo con la versión B asignada |
| Entrega | Carpeta `evaluacion-u1/` del repositorio del grupo: `reporte_stock.py` |
| Aprobación | 60 puntos o más de 100 (rúbrica de la consigna maestra) y defensa individual apta |

## Consigna

Desarrollar `evaluacion-u1/reporte_stock.py` en el repositorio del grupo: un programa de consola que procesa el stock de un inventario.

1. Solicitar la cantidad de productos del inventario (se admite el valor 0). Ante un valor no numérico, mostrar «Debe ingresar un numero valido» y volver a pedir.
2. Por cada producto, solicitar su nombre y el stock registrado en cada uno de sus tres depósitos, y guardar los tres valores de cada producto en una lista.
3. Calcular el promedio de stock de cada producto con la cantidad real de valores de su lista y mostrar su ficha: nombre, stocks, promedio y situación (Crítico con promedio menor a 10; Bajo con promedio menor a 25; Suficiente con 25 o más).
4. Emitir al final el resumen del inventario: cantidad de productos críticos, bajos y suficientes; promedio general de stock; porcentaje de productos suficientes; y el mejor promedio de stock con el nombre del producto correspondiente.
5. Con cantidad 0, terminar mostrando «No se ingresaron productos», sin dividir por cero ni mostrar errores.

## Requisitos técnicos (canon de la materia)

- Esqueleto canónico: funciones con `def`, `def main():` y guard `if __name__ == "__main__":` al final.
- Toda conversión numérica en el renglón del `input()`, bajo `try/except ValueError`, con reingreso mediante `while True` + `break`.
- Listas con `append`, recorrido y `len()`; contadores y acumuladores inicializados antes del `for` y actualizados dentro.
- Excepciones específicas siempre; sin `except:` desnudo.
- Mensajes y comentarios en español, sin tildes ni eñes dentro del código; un comentario por cada acción.
- Sin clases, sin librerías externas, sin módulos propios.

## Pruebas mínimas

- Caso válido: al menos dos productos con situaciones distintas (uno crítico, uno suficiente).
- Caso de error: una letra en la cantidad y una letra en un stock; el programa debe volver a pedir.
- Caso límite: cantidad 0.

## Entrega

```bash
git add .
git commit -m "evaluacion-u1: entrega de la version B"
git push
```

Verificar en GitHub que `evaluacion-u1/reporte_stock.py` quedó publicado con el último commit. Esta versión no usa archivos de datos: solo se entrega el `.py`.

## Defensa individual

Cada integrante explica, sin leer y en no más de tres minutos:

1. Qué hace el programa, mostrando su ejecución con un dato válido.
2. Una línea señalada por el docente: qué hace y por qué está ahí.
3. Un error previsto: mostrar en vivo qué ocurre al ingresar una letra donde va un número.

## Checklist antes de entregar

- [ ] Esqueleto canónico completo: constantes, funciones, `main()` y guard.
- [ ] Toda conversión numérica bajo `try/except ValueError` con reingreso.
- [ ] Tres stocks por producto en una lista; promedio calculado con `len()`.
- [ ] Situación con `if/elif/else`; contadores inicializados antes del `for`.
- [ ] Resumen protegido con `if cantidad > 0` (promedio general y porcentaje).
- [ ] Mensajes y comentarios en español, sin tildes ni eñes en el código.
- [ ] `commit` y `push` hechos y verificados en GitHub.
