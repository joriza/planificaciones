# Encuentro 8: Cierre U1 — repaso y TP

## Datos del encuentro

| Campo | Valor |
|---|---|
| Unidad | U1: Fundamentos de Python |
| Encuentro | 8 de 31 (5 de 5 en la unidad) |
| Duración | 120 minutos |
| Carácter | Actitudinal |

## Objetivos de aprendizaje

- Integrar variables, tipos, condicionales, bucles y listas en un solo programa.
- Extender el programa de un estudiante a toda la comisión con contadores y acumuladores.
- Completar el TP-U1 según la checklist y probar los dos caminos (dato válido e inválido).
- Entregar el trabajo por GitHub con `commit` y `push` convencionales.

## Reparto de tiempos (120 minutos)

| Bloque | Minutos |
|---|---|
| Apertura y motivación | 10 |
| Desarrollo teórico-práctico | 70 |
| Consolidación y cierre | 25 |
| Actividad complementaria | 15 |

## Charla rápida

El TP es el examen de manejo sin instructor al lado: la ruta ya se recorrió entera en los encuentros 4 a 7 — variables, decisiones, bucles, listas, cadenas y la entrega por Git — y hoy se recorre completa, integrada en un solo programa. No hay conceptos nuevos: hay una misma herramienta conocida (`gestion_notas.py`) que crece de procesar un estudiante a procesar toda la comisión. Al terminar, el trabajo queda publicado en GitHub: ese es el buzón oficial de entregas de la materia.

## Repaso integrador

### Lo construido en la unidad, encuentro por encuentro

| Encuentro | Lo que se agregó al programa |
|---|---|
| 4 | Variables `str`/`int`/`float`, `input()` con conversión, `print()` con formato, primer `try/except ValueError`. |
| 5 | Reintento con `while True` + `break`, notas con `for` y `range()`, condición con `if/elif/else`, acumuladores. |
| 6 | Notas en una lista (`append`, `len`, recorrido), cadenas con `strip()`/`split()`/`join()`/`upper()`, máximo y mínimo. |
| 7 | Repositorio del grupo: `init`, `add`, `commit`, `remote`, `push`, `.gitignore` y mensajes convencionales. |

### Esqueleto canónico de todo archivo del curso

```
1. import de la biblioteca estandar, solo los que se usan
2. Constantes en MAYUSCULAS_CON_GUIONES_BAJOS
3. Funciones con def
4. def main(): como punto de entrada
5. guard if __name__ == "__main__": llamando a main(), al final
```

### Checklist del TP-U1

- [ ] Carpeta `tp-u1/` del repositorio del grupo, con el archivo `gestion_notas.py`.
- [ ] Esqueleto canónico: lógica dentro de funciones, `main()` y guard `__main__`.
- [ ] Cantidad de estudiantes pedida con reingreso válido (`while` + `try/except ValueError`).
- [ ] Por cada estudiante: nombre completo normalizado (`strip` + `split` + `join`) y tres notas en una lista con reingreso.
- [ ] Promedio por estudiante calculado con `len(notas)`.
- [ ] Condición por estudiante con `if/elif/else`: promedio `8` o más promociona, `6` o más regular, menos de `6` libre.
- [ ] Resumen final: promocionados, regulares, libres, promedio general y mejor estudiante.
- [ ] Cero estudiantes manejado sin romper (sin división por cero).
- [ ] Mensajes y comentarios en español, sin tildes ni ñ dentro del código.
- [ ] Entrega: `commit` y `push` con mensaje convencional.

## Práctica guiada: armado del TP

La transformación central: lo que hoy procesa **un** estudiante pasa a procesar **toda la comisión**. Se pide la cantidad, un `for` exterior recorre los estudiantes, y contadores acumulan el resumen. Lo que ya existía (nombre limpio, notas en lista, promedio, condición) va adentro del `for`, casi sin cambios.

**Paso 1:** abrir `tp-u1/gestion_notas.py` del repositorio del grupo y reemplazar su contenido por la versión del TP:

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
        print(f"Promedio general: {promedio_general}")
        print(f"Mejor estudiante: {mejor_nombre} con promedio {mejor_promedio}")
    else:
        # No se ingresaron estudiantes: no hay promedio general
        print("No se ingresaron estudiantes")


if __name__ == "__main__":
    main()
```

Decisiones del diseño que conviene nombrar en voz alta:

- `mejor_promedio` arranca en `-1` porque las notas no son negativas: el primer estudiante siempre lo supera y queda registrado.
- El resumen se protege con `if cantidad > 0`: dividir por cero es el error que deja el programa roto justo en la entrega.
- Los contadores (`promocionados`, `regulares`, `libres`, `suma_promedios`) se inicializan **antes** del `for` y se actualizan **dentro**, como cualquier acumulador.

**Paso 2:** probar con dos estudiantes, uno por cada rumbo de la condición. Salida esperada:

```
=== Registro de notas de la comision ===
Cantidad de estudiantes: 2
--- Estudiante 1 de 2 ---
Nombre completo: ana perez
Nota 1: 8
Nota 2: 7
Nota 3: 9
Nombre: ana perez
Notas: [8, 7, 9]
Promedio: 8.0
Condicion: Promociona
--- Estudiante 2 de 2 ---
Nombre completo: luis gomez
Nota 1: 6
Nota 2: 5
Nota 3: 7
Nombre: luis gomez
Notas: [6, 5, 7]
Promedio: 6.0
Condicion: Regular
=== Resumen de la comision ===
Promocionados: 1
Regulares: 1
Libres: 0
Promedio general: 7.0
Mejor estudiante: ana perez con promedio 8.0
```

**Paso 3:** probar los caminos de error: una letra en la cantidad, una letra en una nota, y la comisión de `0` estudiantes (debe terminar con el mensaje, no con un traceback).

## Ejercicio independiente: completar y entregar

1. Cada grupo agrega al resumen **una línea propia** elegida por el grupo (por ejemplo, el porcentaje de promocionados sobre la comisión), con su cálculo dentro del `if cantidad > 0`.
2. Probar el programa completo con al menos tres estudiantes y los caminos de error.
3. Entregar con la rutina de cierre:

```bash
git add .
git commit -m "tp-u1: entrega del tp-u1 con resumen de la comision"
git push
```

**Pista para la línea propia:** el porcentaje es `promocionados * 100 / cantidad`; va dentro del `if cantidad > 0` porque divide por la cantidad. Una solución completa está en el anexo docente.

## Rutina de cierre (git)

La entrega del TP queda registrada en GitHub:

```bash
git add .
git commit -m "tp-u1: entrega del tp-u1 con resumen de la comision"
git push
```

Verificar en el navegador que el último commit de `tp-u1/gestion_notas.py` es el entregado, y que ningún archivo de más (copias, `__pycache__/`) entró al repositorio.

## Cierre de la Unidad 1

**Qué llevamos de la U1:**
- Un programa de consola se escribe en un `.py` y corre con `python archivo.py`.
- `input()` devuelve texto; la conversión (`int`, `float`) va en el mismo renglón y bajo `try/except` específico.
- `if/elif/else` decide; `while True` + `break` reintenta; `for` con `range()` recorre una cantidad fija y con una lista recorre sus elementos.
- Las listas (`append`, `len`, recorrido) organizan los datos; `strip`/`split`/`join`/`upper` procesan el texto.
- Git guarda el historial y GitHub entrega el trabajo: `add`, `commit` con mensaje convencional, `push`.

**Lo que viene (Unidad 2):** el programa crece en funciones: `def` y `return` para dividir el trabajo en piezas reutilizables, y los archivos de texto (`with open`, lectura y escritura) para que los datos sobrevivan al cierre del programa. La agenda en archivo de texto del TP-U2 se construye sobre exactamente este esqueleto.

## Errores comunes y trampas (repaso general)

| Error | Causa | Solución |
|---|---|---|
| Operar `input()` sin convertir | `input()` devuelve `str` siempre; sumar o comparar como número lanza `TypeError`. | `int(input(...))` o `float(input(...))` en el renglón, bajo `try`. |
| `int("23.5")` | `int()` rechaza decimales: `ValueError` (observado en el spike). | `float()` para decimales; `int()` solo para enteros. |
| `split(",")` sin `strip()` | Los campos quedan con espacios (`' 23'`) y las comparaciones fallan. | `strip()` en cada campo; para el nombre, `strip().split()` + `join()`. |
| `except:` desnudo | Oculta el error real y el programa «sigue» roto en silencio. | Siempre la excepción específica: `except ValueError:`, `except FileNotFoundError:`. |
| Lógica suelta fuera de funciones | Código a nivel de módulo se ejecuta igual al importar el archivo (observado en el spike). | Constantes → funciones → `main()` → guard `if __name__ == "__main__":`. |
| División por cero en el resumen | `cantidad = 0` y el promedio general divide por cero. | Proteger el cálculo con `if cantidad > 0:`. |
| Trabajar sin entregar | El `commit` quedó local y el `push` no se hizo: en GitHub no hay nada. | El buzón de entregas es GitHub; verificar el último commit en el navegador antes de irse. |
