# Encuentro 8 — Cierre U1: repaso y TP

> 1 — Fundamentos de Python y control del flujo · Encuentro de cierre de unidad

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 8 de 36 |
| Unidad | 1 — Fundamentos de Python y control del flujo |
| Eje temático | 1 — Fundamentos del lenguaje Python |
| Carácter/Objetivo | Actitudinal |
| Estructura | cierre |
| Duración teórica | 120 minutos (2 horas reloj) |
| Concepto nuevo | Sistematización de U1; TP-U1 (`kiosco escolar`); ciclo de entrega con Git y GitHub |
| Requisitos previos | Encuentro 7: bucles `for` y `while`, contadores, acumuladores |
| TP obligatorio | TP-U1: programa de consola con entrada y control de flujo |
| Uso de celular | Solo para acceder a GitHub |
| Organización del trabajo | Grupos de 2 (quedan fijos para todo el curso); cada grupo usa una computadora |

### Reparto de tiempos

| Momento | Tiempo |
| --- | --- |
| Apertura | 10 min |
| Consolidación | 40 min |
| Trabajo del TP | 45 min |
| Ciclo de entrega | 15 min |
| Cierre | 10 min |
| **Total** | **120 min** |

## 2. Objetivos de aprendizaje

1. Sistematizar los conceptos de la Unidad 1: variables, tipos, entrada/salida, condicionales y bucles.
2. Escribir un programa integrador que combine entrada, validación, condicionales y bucles en un único archivo.
3. Inicializar un repositorio Git local con `.gitignore`, hacer commits y conectar con un repositorio remoto en GitHub.
4. Subir el TP-U1 terminado a GitHub siguiendo el ciclo de entrega.

## 3. Apertura y puente (10 min)

Recorrida rápida de lo que vimos en los encuentros anteriores:

- **E4:** print(), variables, operadores aritméticos.
- **E5:** input(), conversión de tipos, f-strings.
- **E6:** if/elif/else, operadores de comparación y lógicos, try/except.
- **E7:** for con range(), while, contadores y acumuladores.

Hoy juntamos todo en un solo programa: el TP-U1. Además aprendemos a entregarlo con Git y GitHub.

## 4. Consolidación (40 min)

### Sistematización: cómo se arma un programa completo

Entre los 4 encuentros anteriores vimos estos bloques. Hoy los vamos a usar todos juntos:

1. **Entrada con validación** (`while True` + `try/except`)
2. **Menú con condicionales** (`if` / `elif` / `else`)
3. **Bucles que repiten hasta que el usuario quiere salir** (`while` con bandera)
4. **Acumuladores y contadores** para llevar cuentas

Vamos a ver el esqueleto de un programa con menú (sin el tema del TP todavía):

```python
# Esqueleto de programa con menu
# El usuario elige opciones hasta que selecciona "Salir"

print("=== SISTEMA DE GESTION ===")
print("1. Ver datos")
print("2. Agregar item")
print("3. Salir")

option = input("Elegi una opcion: ")

if option == "1":
    print("Mostrando datos...")
elif option == "2":
    print("Agregando item...")
elif option == "3":
    print("Saludos!")
else:
    print("Opcion invalida.")
```

El problema de ese esqueleto es que se ejecuta una sola vez. ¿Cómo hacemos para que el menú se muestre hasta que el usuario elija "Salir"? Con un bucle:

```python
# Programa que repite el menu hasta que el usuario elige Salir

running = True

while running:
    print()
    print("=== SISTEMA DE GESTION ===")
    print("1. Ver datos")
    print("2. Agregar item")
    print("3. Salir")

    option = input("Elegi una opcion: ")

    if option == "1":
        print("Mostrando datos...")
    elif option == "2":
        print("Agregando item...")
    elif option == "3":
        running = False
        print("Saludos!")
    else:
        print("Opcion invalida.")
```

Esa estructura de `while` con bandera (`running = True` / `running = False`) es la que vas a usar en el TP.

## 5. Trabajo del TP (45 min)

### Consigna del TP-U1

**TP-U1: programa de consola con entrada y control de flujo**

Grupos de 2. Escribir un programa `kiosco.py` que simule la atención en un kiosco escolar.

El programa debe:
1. Mostrar un menú principal con estas opciones:
   - **1 — Ver lista de productos** (muestra productos, precios y stock fijos desde variables).
   - **2 — Registrar una venta** (pide un código de producto y una cantidad, valida stock, descuenta y muestra el total con descuento eventual).
   - **3 — Mostrar resumen de ventas** (total de unidades vendidas en la sesión y dinero acumulado).
   - **4 — Salir** (cierra el programa).

2. Definir al menos 4 productos al inicio del programa, cada uno con: código (int), nombre (str), precio (float) y stock (int). Usar listas paralelas o un diccionario (lo que quede más claro).

3. Para la opción **Registrar una venta**:
   - Pedir código de producto.
   - Validar que exista (si no, mostrar error y volver al menú).
   - Pedir cantidad.
   - Validar stock suficiente (si no, mostrar error).
   - Si la cantidad supera las 5 unidades, aplicar un descuento del 10%.
   - Descontar del stock.
   - Acumular en el total de ventas del día.

4. El programa corre hasta que el usuario elige "Salir".

5. Toda entrada numérica debe validarse con `try/except ValueError`.

**Pista:** usá un diccionario para los productos, donde la clave es el código y el valor es una tupla con (nombre, precio, stock). Por ejemplo:
```python
products = {
    101: ("Caramelos", 50.0, 30),
    102: ("Chicles", 25.0, 50),
    103: ("Galletitas", 100.0, 20),
    104: ("Jugos", 150.0, 15)
}
```
Después, para el resumen, llevá dos acumuladores: `total_units` y `total_money`.

## 6. Ciclo de entrega (15 min)

Hoy aprendemos el ciclo completo de entrega con Git y GitHub. Este ciclo lo vas a repetir en cada TP del curso.

**Paso 1: Crear el repositorio en GitHub.**

1. Entrá a [github.com](https://github.com) e iniciá sesión con la cuenta del grupo.
2. Creá un repositorio nuevo con nombre `tp-lap`.
3. **No** marques "Initialize with README". Dejalo vacío.

**Paso 2: Inicializar Git local.**

```bash
# En la terminal, dentro de la carpeta del TP
cd ruta/al/tp-u1

# Inicializar repositorio
git init

# Crear .gitignore para evitar basura
echo "__pycache__/" > .gitignore
echo ".vscode/" >> .gitignore
```

**Paso 3: Primer commit.**

```bash
# Agregar todo al area de preparacion
git add .

# Hacer el primer commit
git commit -m "tp-u1: version inicial del programa"
```

**Paso 4: Conectar con GitHub y subir.**

```bash
# Agregar el repositorio remoto (reemplazar URL con la de tu repo)
git remote add origin https://github.com/tu-usuario/tp-lap.git

# Subir la rama main
git push -u origin main
```

A partir de ahora, cada vez que terminen un avance importante:

```bash
git add .
git commit -m "tp-u1: <descripcion del avance>"
git push
```

## 7. Cierre (10 min)

### Qué te llevás

- Un programa completo combina: entrada, validación, condicionales, bucles y acumuladores.
- El menú con `while` + bandera es la estructura base de cualquier programa interactivo.
- Git guarda versiones de tu código; GitHub las comparte.
- El ciclo de entrega (`init` → `add` → `commit` → `push`) se repite en cada TP del curso.

### Lo que viene

En el **Encuentro 9 — Evaluación de la Unidad 1** vamos a hacer una evaluación individual de la Unidad 1. Vas a tener que demostrar todo lo que aprendiste hasta acá: escribir un programa que use entrada, condicionales y bucles sin ayuda del grupo.

## 8. Errores comunes y trampas

| Error | Causa | Fix |
| --- | --- | --- |
| `git push` pide usuario y contraseña todo el tiempo | No se configuró la autenticación | Usar token de acceso personal (PAT) de GitHub en vez de contraseña |
| `.gitignore` mal escrito: `__pycache__/` sin barra | Sin la barra, Git ignora el archivo `__pycache__` pero no la carpeta | Escribir `__pycache__/` (con barra) para carpetas |
| `git add .` antes de crear `.gitignore` | El `__pycache__/` ya quedó rastreado | Agregar `.gitignore` primero, después hacer `git rm -r --cached __pycache__/` |
| El menú no vuelve a aparecer después de una opción | Faltó el bucle `while` principal | Envolver el menú en `while running:` y solo salir con `running = False` |
| Descuento mal aplicado: `precio * 0.9` pero el usuario ve decimales infinitos | No se formateó la salida | Mostrar con `:.2f` en la f-string |
| `git commit` sin `-m` abre un editor de texto | Git abre el editor por defecto si no se pasa mensaje | Siempre usar `git commit -m "mensaje"` |