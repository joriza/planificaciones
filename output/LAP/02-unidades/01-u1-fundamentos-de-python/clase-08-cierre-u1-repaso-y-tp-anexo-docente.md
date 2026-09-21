# Anexo docente — Encuentro 8: Cierre U1 — repaso y TP

## Encuadre

Cierre actitudinal: el grupo recorre solo la ruta completa y entrega. El TP-U1 no es un programa nuevo sino la evolución natural del programa de la unidad: de un estudiante a toda la comisión, sumando contadores y el resumen final. No hay conceptos nuevos a enseñar; la labor docente es sostener la checklist, evitar que un grupo se atasque en Git, y hacer que la entrega real ocurra en el encuentro. La línea propia del resumen es la pieza mínima de decisión grupal: fuerza a elegir, justificar y calcular algo que no estaba en el molde.

## Qué observar durante la clase

- Grupos que parten del archivo equivocado (la versión 3 de la carpeta personal en lugar de la de `tp-u1/` del repositorio): verificar la carpeta de trabajo al inicio.
- Contadores inicializados dentro del `for` exterior: el resumen termina en 1 y 1; es el defecto silencioso del TP y se detecta con la corrida de dos estudiantes.
- `mejor_promedio` inicializado en `0` en lugar de `-1`: con notas válidas no se nota; pedir que expliquen por qué `-1` es el punto de partida honesto.
- La protección `if cantidad > 0` omitida: probar `0` estudiantes al entregar; división por cero en la entrega es el final más evitable.
- Camino de error sin probar: un grupo entrega con el caso válido únicamente; la checklist exige los dos caminos (dato válido e inválido).
- Entrega incompleta: `commit` sin `push`. Verificar en el navegador el último commit de cada grupo antes del cierre.

## Solución completa del ejercicio independiente

Versión final del TP con la línea propia del resumen (porcentaje de promocionados) incluida:

```python
def main():
    # Presentar el programa
    print("=== Registro de notas de la comision ===")

    # Pedir la cantidad de estudiantes, repitiendo mientras no sea valida
    while True:
        try:
            cantidad = int(input("Cantidad de estudiantes: "))
            break
        except ValueError:
            print("Debe ingresar un numero valido")

    # Preparar los contadores y acumuladores de la comision
    promocionados = 0
    regulares = 0
    libres = 0
    suma_promedios = 0.0
    mejor_nombre = ""
    mejor_promedio = -1

    # Procesar cada estudiante de la comision
    for i in range(1, cantidad + 1):
        print(f"--- Estudiante {i} de {cantidad} ---")

        # Pedir el nombre completo y dejarlo limpio
        entrada = input("Nombre completo: ")
        partes = entrada.strip().split()
        nombre = " ".join(partes)

        # Pedir las tres notas y guardarlas en una lista
        notas = []
        for numero in range(1, 4):
            # Repetir la lectura de la nota mientras no sea valida
            while True:
                try:
                    nota = int(input(f"Nota {numero}: "))
                    break
                except ValueError:
                    print("Debe ingresar un numero valido")
            # Agregar la nota a la lista
            notas.append(nota)

        # Sumar las notas recorriendo la lista
        suma_notas = 0
        for nota in notas:
            suma_notas = suma_notas + nota

        # Calcular el promedio con la cantidad real de notas
        promedio = suma_notas / len(notas)

        # Decidir la condicion del estudiante y acumularla
        if promedio >= 8:
            condicion = "Promociona"
            promocionados = promocionados + 1
        elif promedio >= 6:
            condicion = "Regular"
            regulares = regulares + 1
        else:
            condicion = "Libre"
            libres = libres + 1

        # Acumular el promedio para el promedio general
        suma_promedios = suma_promedios + promedio

        # Actualizar el mejor promedio de la comision
        if promedio > mejor_promedio:
            mejor_promedio = promedio
            mejor_nombre = nombre

        # Mostrar la ficha del estudiante
        print(f"Nombre: {nombre}")
        print(f"Notas: {notas}")
        print(f"Promedio: {promedio}")
        print(f"Condicion: {condicion}")

    # Mostrar el resumen de la comision
    print("=== Resumen de la comision ===")
    print(f"Promocionados: {promocionados}")
    print(f"Regulares: {regulares}")
    print(f"Libres: {libres}")
    if cantidad > 0:
        promedio_general = suma_promedios / cantidad
        porcentaje_promocionados = promocionados * 100 / cantidad
        print(f"Promedio general: {promedio_general}")
        print(f"Porcentaje de promocionados: {porcentaje_promocionados}")
        print(f"Mejor estudiante: {mejor_nombre} con promedio {mejor_promedio}")
    else:
        # No se ingresaron estudiantes: no hay promedio general
        print("No se ingresaron estudiantes")


if __name__ == "__main__":
    main()
```

Salida esperada del resumen con los mismos dos estudiantes de la práctica guiada (1 de 2 promociona):

```
=== Resumen de la comision ===
Promocionados: 1
Regulares: 1
Libres: 0
Promedio general: 7.0
Porcentaje de promocionados: 50.0
Mejor estudiante: ana perez con promedio 8.0
```

Entrega esperada del grupo:

```bash
git add .
git commit -m "tp-u1: entrega del tp-u1 con resumen de la comision"
git push
```

Y en GitHub: `tp-u1/gestion_notas.py` con el último commit del grupo, sin archivos de más.

## Errores previsibles

1. **Operar `input()` sin convertir:** la cantidad o una nota queda como texto y la primera operación lanza `TypeError` (checklist: `input()` siempre devuelve `str`).
2. **`int("23.5")`:** nota decimal escrita con punto: `ValueError` y reintento; si el grupo quiere admitir decimales, la conversión corresponde a `float()` (checklist).
3. **`split(",")` o comparaciones sin `strip()`:** espacios residuales en los campos y comparaciones que no matchean (checklist).
4. **`except:` desnudo:** atrapa también el `Ctrl+C` y cualquier error propio; prohibido, siempre la excepción específica (checklist).
5. **Lógica suelta fuera de funciones** al agregar la línea propia: todo dentro de `main()`; el código a nivel de módulo se ejecuta al importar (checklist, observado en el spike).
6. **División por cero:** porcentaje o promedio general calculados fuera de la protección `if cantidad > 0`; la corrida con `0` estudiantes es la prueba obligatoria.
7. **Contadores dentro del `for`:** el resumen queda incompleto sin ningún mensaje de error; comparar siempre con la corrida hecha a mano.

## Criterios de logro (4-8)

| Nivel | Descripción |
|---|---|
| 4 | El programa pide los datos pero no calcula ni muestra el resumen de la comisión. |
| 5 | Promedios y condición por estudiante funcionan; el resumen queda incompleto o con contadores mal acumulados. |
| 6 | Resumen completo y corrida sin errores; la entrega no está en GitHub o falta la línea propia del grupo. |
| 7 | TP completo según la checklist, entregado por GitHub, probado con caminos válidos e inválidos. |
| 8 | Además, justifica las decisiones del diseño (por qué `while`, por qué lista, por qué `-1`) y corrige un error en vivo durante la clase. |

## Agrupamiento

Grupos de 2 o 3 estudiantes sobre el repositorio grupal creado en el Encuentro 7, con un commit por integrante a lo largo del trabajo (la historia del `git log` es parte de la evidencia). Para el cierre: revisión cruzada entre grupos — cada grupo corre el TP de otro con datos «sucios» y reporta un hallazgo.

## Ajustes para la siguiente edición

- Si el TP no se completa en el encuentro, la actividad complementaria y el trabajo posterior completan la entrega; fijar la fecha límite según el calendario de la materia y mantener el buzón único en GitHub.
- Si varios grupos repiten el mismo defecto (contadores o división por cero), abrir el próximo encuentro con ese defecto corregido en vivo antes de presentar la Unidad 2.
