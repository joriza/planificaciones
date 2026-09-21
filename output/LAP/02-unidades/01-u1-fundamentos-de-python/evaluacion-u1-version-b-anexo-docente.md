# Anexo docente — Evaluación de la Unidad 1, Versión B (inventario de productos)

> Documento de uso exclusivo del docente: no entregar a alumnos ni a administración.

## Encuadre docente

La versión B evalúa la misma secuencia que la versión A sobre el dominio de inventario: entrada validada con reingreso, lista de tres valores por registro, promedio con `len()`, clasificación con `if/elif/else`, contadores y acumuladores, y reporte final protegido contra la colección vacía. No hay contenidos de unidades posteriores. La defensa verifica los mismos puntos que en la versión A.

## Solución completa (código canon)

```python
def main():
    # Presentar el programa
    print("=== Reporte de stock del inventario ===")

    # Pedir la cantidad de productos, repitiendo mientras no sea valida
    while True:
        try:
            cantidad = int(input("Cantidad de productos: "))
            break
        except ValueError:
            print("Debe ingresar un numero valido")

    # Preparar los contadores y acumuladores del inventario
    criticos = 0
    bajos = 0
    suficientes = 0
    suma_promedios = 0.0
    mejor_nombre = ""
    mejor_promedio = -1

    # Procesar cada producto del inventario
    for i in range(1, cantidad + 1):
        print(f"--- Producto {i} de {cantidad} ---")

        # Pedir el nombre del producto y dejarlo limpio
        entrada = input("Producto: ")
        partes = entrada.strip().split()
        producto = " ".join(partes)

        # Pedir el stock de los tres depositos y guardarlo en una lista
        stocks = []
        for numero in range(1, 4):
            # Repetir la lectura del stock mientras no sea valida
            while True:
                try:
                    stock = int(input(f"Stock en deposito {numero}: "))
                    break
                except ValueError:
                    print("Debe ingresar un numero valido")
            # Agregar el stock a la lista
            stocks.append(stock)

        # Sumar los stocks recorriendo la lista
        suma_stocks = 0
        for stock in stocks:
            suma_stocks = suma_stocks + stock

        # Calcular el promedio con la cantidad real de valores
        promedio = suma_stocks / len(stocks)

        # Decidir la situacion del producto y acumularla
        if promedio < 10:
            situacion = "Critico"
            criticos = criticos + 1
        elif promedio < 25:
            situacion = "Bajo"
            bajos = bajos + 1
        else:
            situacion = "Suficiente"
            suficientes = suficientes + 1

        # Acumular el promedio para el promedio general
        suma_promedios = suma_promedios + promedio

        # Actualizar el mejor promedio de stock del inventario
        if promedio > mejor_promedio:
            mejor_promedio = promedio
            mejor_nombre = producto

        # Mostrar la ficha del producto
        print(f"Producto: {producto}")
        print(f"Stocks: {stocks}")
        print(f"Promedio de stock: {promedio}")
        print(f"Situacion: {situacion}")

    # Mostrar el resumen del inventario
    print("=== Resumen del inventario ===")
    print(f"Criticos: {criticos}")
    print(f"Bajos: {bajos}")
    print(f"Suficientes: {suficientes}")
    if cantidad > 0:
        promedio_general = suma_promedios / cantidad
        porcentaje_suficientes = suficientes * 100 / cantidad
        print(f"Promedio general de stock: {promedio_general}")
        print(f"Porcentaje de productos suficientes: {porcentaje_suficientes}")
        print(f"Mejor producto: {mejor_nombre} con promedio de stock {mejor_promedio}")
    else:
        # No se ingresaron productos: no hay promedio general
        print("No se ingresaron productos")


if __name__ == "__main__":
    main()
```

## Salida esperada (extracto)

```
=== Reporte de stock del inventario ===
Cantidad de productos: 2
--- Producto 1 de 2 ---
Producto: tornillo m8
Stock en deposito 1: 30
Stock en deposito 2: 28
Stock en deposito 3: 32
Producto: tornillo m8
Stocks: [30, 28, 32]
Promedio de stock: 30.0
Situacion: Suficiente
--- Producto 2 de 2 ---
Producto: tuerca m8
Stock en deposito 1: 4
Stock en deposito 2: 6
Stock en deposito 3: 5
Producto: tuerca m8
Stocks: [4, 6, 5]
Promedio de stock: 5.0
Situacion: Critico
=== Resumen del inventario ===
Criticos: 1
Bajos: 0
Suficientes: 1
Promedio general de stock: 17.5
Porcentaje de productos suficientes: 50.0
Mejor producto: tornillo m8 con promedio de stock 30.0
```

Con cantidad 0, la salida esperada se reduce al mensaje «No se ingresaron productos».

## Criterios de corrección (100 puntos)

| Criterio | Puntos | Logro completo | Recorte sugerido |
|---|---|---|---|
| Entrada validada | 20 | Todas las conversiones numéricas bajo `try/except ValueError` con reingreso (cantidad y stocks) | Sin reingreso en un solo punto: 12; sin `try` en algún punto: 5 |
| Estructuras y cálculo | 25 | Tres stocks por producto en lista; promedio con `len()`; situación con `if/elif/else` correcta | Promedio o situación con error puntual: 15; sin lista (tres variables sueltas): 10 |
| Reporte final | 15 | Contadores por situación, promedio general, porcentaje y mejor producto, con guard `if cantidad > 0` | Falta un dato del resumen: 10; sin protección de colección vacía: 5 |
| Estructura y estilo | 20 | Esqueleto canónico, un comentario por acción, identificadores en español sin tildes | Comentarios o tildes: 12; lógica suelta fuera de `main()`: 5 |
| Entrega por GitHub | 20 | Carpeta y archivo correctos, commit convencional, push verificado, sin archivos extra | Commit sin push (verificar en el navegador): 10; carpeta equivocada: 5 |

## Defensa: preguntas sugeridas y respuestas esperadas

| Pregunta | Respuesta esperada |
|---|---|
| ¿Por qué la conversión va en el renglón del `input()`? | Porque `input()` devuelve `str`: sin `int()` la operación numérica lanza `TypeError`. |
| ¿Qué pasa si el usuario escribe una letra en un stock? | `int()` lanza `ValueError`; el `except` avisa y el `while True` vuelve a pedir. |
| ¿Por qué el resumen está dentro de `if cantidad > 0`? | Porque con 0 productos el promedio general y el porcentaje dividen por cero. |
| ¿Qué guarda `stocks` y cómo se recorre? | Una lista con los tres stocks del producto; se suma recorriéndola con `for` y se promedia con `len(stocks)`. |
| ¿Por qué `mejor_promedio` arranca en `-1`? | Porque el stock no es negativo: el primer promedio siempre lo supera y queda registrado. |

## Errores previsibles

1. Operar `input()` sin convertir: `TypeError` en la primera suma o comparación.
2. Contadores inicializados dentro del `for`: el resumen termina en 1; detectarlo con la corrida de dos productos.
3. División por cero con cantidad 0: probar ese camino antes de entregar.
4. `except:` desnudo: prohibido; siempre `except ValueError:`.
5. Umbrales de la situación mal ordenados: `elif promedio < 25` después de descartar `< 10`; invertir el orden rompe la clasificación.
6. `commit` sin `push`: la entrega vale lo publicado en GitHub.

## Equivalencia con la versión A

| Elemento | Versión A (notas) | Versión B (inventario) |
|---|---|---|
| Registro | Estudiante (apellido + 3 notas) | Producto (nombre + stock en 3 depósitos) |
| Promedio por registro | Promedio de notas | Promedio de stock |
| Clasificación | Promociona / Regular / Libre | Crítico / Bajo / Suficiente |
| Resumen | Contadores, promedio general, porcentaje de promocionados, mejor estudiante | Contadores, promedio general, porcentaje de suficientes, mejor producto |
| Caso límite | Cantidad 0 | Cantidad 0 |

Mismas estructuras, mismas exigencias y misma rúbrica: solo cambia el dominio de los datos.
