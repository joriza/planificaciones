# Evaluación de la Unidad 1 — Versión A: gestión de notas

## Metadatos

| Campo | Valor |
|---|---|
| Versión | A |
| Dominio de datos | Gestión de notas de un parcial |
| Instancia | Evaluación de la Unidad 1 — Encuentro dedicado 9 |
| Duración | 120 minutos (desarrollo, entrega y defensa) |
| Destinatarios | Grupo con la versión A asignada |
| Entrega | Carpeta `evaluacion-u1/` del repositorio del grupo: `reporte_notas.py` |
| Aprobación | 60 puntos o más de 100 (rúbrica de la consigna maestra) y defensa individual apta |

## Consigna

Desarrollar `evaluacion-u1/reporte_notas.py` en el repositorio del grupo: un programa de consola que procesa los resultados de un parcial.

1. Solicitar la cantidad de estudiantes del parcial (se admite el valor 0). Ante un valor no numérico, mostrar «Debe ingresar un numero valido» y volver a pedir.
2. Por cada estudiante, solicitar el apellido y sus tres notas, y guardar las tres notas de cada estudiante en una lista.
3. Calcular el promedio de cada estudiante con la cantidad real de notas de su lista y mostrar su ficha: apellido, notas, promedio y condición (Promociona con 8 o más; Regular con 6 o más; Libre por debajo de 6).
4. Emitir al final el resumen del parcial: cantidad de promocionados, regulares y libres; promedio general; porcentaje de promocionados; y el mejor promedio con el apellido correspondiente.
5. Con cantidad 0, terminar mostrando «No se ingresaron estudiantes», sin dividir por cero ni mostrar errores.

## Requisitos técnicos (canon de la materia)

- Esqueleto canónico: funciones con `def`, `def main():` y guard `if __name__ == "__main__":` al final.
- Toda conversión numérica en el renglón del `input()`, bajo `try/except ValueError`, con reingreso mediante `while True` + `break`.
- Listas con `append`, recorrido y `len()`; contadores y acumuladores inicializados antes del `for` y actualizados dentro.
- Excepciones específicas siempre; sin `except:` desnudo.
- Mensajes y comentarios en español, sin tildes ni eñes dentro del código; un comentario por cada acción.
- Sin clases, sin librerías externas, sin módulos propios.

## Pruebas mínimas

- Caso válido: al menos dos estudiantes con rumbos distintos de condición (uno que promociona, otro libre).
- Caso de error: una letra en la cantidad y una letra en una nota; el programa debe volver a pedir.
- Caso límite: cantidad 0.

## Entrega

```bash
git add .
git commit -m "evaluacion-u1: entrega de la version A"
git push
```

Verificar en GitHub que `evaluacion-u1/reporte_notas.py` quedó publicado con el último commit. Esta versión no usa archivos de datos: solo se entrega el `.py`.

## Defensa individual

Cada integrante explica, sin leer y en no más de tres minutos:

1. Qué hace el programa, mostrando su ejecución con un dato válido.
2. Una línea señalada por el docente: qué hace y por qué está ahí.
3. Un error previsto: mostrar en vivo qué ocurre al ingresar una letra donde va un número.

## Checklist antes de entregar

- [ ] Esqueleto canónico completo: constantes, funciones, `main()` y guard.
- [ ] Toda conversión numérica bajo `try/except ValueError` con reingreso.
- [ ] Tres notas por estudiante en una lista; promedio calculado con `len()`.
- [ ] Condición con `if/elif/else`; contadores inicializados antes del `for`.
- [ ] Resumen protegido con `if cantidad > 0` (promedio general y porcentaje).
- [ ] Mensajes y comentarios en español, sin tildes ni eñes en el código.
- [ ] `commit` y `push` hechos y verificados en GitHub.
