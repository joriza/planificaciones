# Evaluación de diciembre — Versión A

> Dominio de esta versión: videoteca (películas, copias, tarifa, alquiler, ejemplares). Duración: 90 minutos. Puntaje total: apto/no apto por objetivo mínimo. Resolución individual, con computadora, sin celular. Las condiciones completas están en `evaluacion-intensificaciones-diciembre.md`.

## Antes de empezar

- Esta evaluación verifica el **camino mínimo completo del curso**. Cada objetivo que logres hoy es un objetivo aprobado.
- Creá un archivo `verduleria.py` en la carpeta `trabajo-final/` de tu repo grupal.
- Escribí el programa en un solo archivo `.py`. Funciones arriba, `if __name__ == "__main__":` al final.
- No se permite celular. Trabajo individual.
- Al terminar, commit y push al repo grupal, y preparate para la defensa oral.

## Objetivos de la prueba

- Usar `print()` / `input()` con conversión de tipos (`int()`, `float()`).
- Aplicar condicionales `if`/`elif`/`else`.
- Usar bucles `while` (menú) y `for` (recorrer colecciones).
- Almacenar datos en listas de diccionarios.
- Definir funciones con `def`, parámetros y `return`.
- Validar entrada con `try`/`except`.
- Usar f-strings y métodos de cadenas básicos.
- Entregar en GitHub con commit y README.

## Consigna — Programa integrador de videoteca

Escribí un programa que gestione los **películas** de una **videoteca**. Cada **película** es un diccionario con:

- `"nombre"`: string
- `"tarifa"` (`moviePrice`): float (tarifa por kilo)
- `"copias"` (`stockCopies`): float (copias disponibles en ejemplares)

### Menú completo (con `while`)

```
=== VIDEOTECA ===
1. Agregar película
2. Listar películas
3. Buscar película por nombre
4. Vender película
5. Alquiler
6. Salir
```

### Funciones requeridas

1. `agregar_producto(movieList)` — pide nombre, tarifa por kilo y copias disponibles. Valida que tarifa y copias sean números con `try`/`except`. Agrega el película como diccionario a la lista.
2. `listar_productos(movieList)` — recorre la lista con `for` y muestra cada película.
3. `buscar_producto(movieList, movieTitle)` — busca por nombre exacto, devuelve el diccionario o `None` si no existe.
4. `vender_producto(movieList, ventas)` (`rentMovie`) — pide nombre del película y copias a vender. Verifica que haya ejemplares suficiente. Si el película tiene menos de 1 kilo, muestra "Ejemplares bajo". Si se vende, descuenta los copias y agrega la préstamo a una lista de ventas.
5. `mostrar_factura(ventas)` — recorre la lista de ventas y muestra cada una con el total. Usá f-strings con formato de dos decimales.

### Función de validación con `try`/`except`

```python
def read_float(mensaje):
    while True:
        try:
            return float(input(mensaje))
        except ValueError:
            print("Dato inválido. Ingrese un número.")
```

### Formato de salida esperado

```
=== VIDEOTECA ===
1. Agregar película
2. Listar películas
3. Buscar película por nombre
4. Vender película
5. Alquiler
6. Salir
Opción: 1
Nombre del película: Tomate
Tarifa por kilo: 250.50
Copias disponibles: 15
Película agregado correctamente.

=== VIDEOTECA ===
1. Agregar película
2. Listar películas
3. Buscar película por nombre
4. Vender película
5. Alquiler
6. Salir
Opción: 4
Nombre del película: Tomate
Copias a vender: 2
Préstamo realizada: 2 copias de Tomate por $501.00
```

## Defensa oral (se evalúa durante el cierre)

Preparate para explicar brevemente (2-3 minutos):
- ¿Qué hace tu programa?
- ¿Cómo validás los datos de entrada?
- Elegí una función que te haya costado — ¿cómo la resolviste?

## Al terminar

1. Commit final con mensaje `"feat: verduleria completa camino mínimo"`.
2. Push al repo grupal en la carpeta `trabajo-final/`.
3. Verificá que el README.md tenga al menos título, descripción y cómo ejecutar.
4. Avisá al docente. Te va a hacer la verificación individual y la defensa oral.