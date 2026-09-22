# Anexo docente — Continuidad pedagógica 04: Tras la evaluación de la Unidad 3

> Documento docente formal. No se entrega a los alumnos: contiene las soluciones completas de cada actividad, los criterios de corrección, los errores previstos y su intervención.

## 1. Soluciones de las actividades

### Actividad 1 — Completar código: métodos de cadenas (papel, 10 pts)

**Código incompleto entregado al alumno:**

```python
# Programa: procesar_frase
# Completar con los metodos de cadena apropiados

frase = "  hola, mundo!  "

# 1. Sacar los espacios del principio y del final
frase_limpia = frase._______()
print(f"'{frase_limpia}'")

# 2. Separar la frase en palabras
palabras = frase_limpia._______()
print(palabras)

# 3. Unir las palabras con guion
frase_con_guiones = "─"._______(palabras)
print(frase_con_guiones)

# 4. Reemplazar la coma por punto
frase_sin_coma = frase_limpia._______(",", ".")
print(frase_sin_coma)
```

**Solución esperada:**

```python
frase_limpia = frase.strip()
palabras = frase_limpia.split()
frase_con_guiones = "-".join(palabras)
frase_sin_coma = frase_limpia.replace(",", ".")
```

**Salida esperada completa:**
```
'hola, mundo!'
['hola,', 'mundo!']
hola,-mundo!
hola. mundo!
```

**Criterios de corrección:**
- Cada método correcto (2.5 pts c/u, 10 pts total). Aceptar `strip`, `split`, `join`, `replace` en el lugar correcto.

**Errores frecuentes:**
- Escriben `strip()` sin paréntesis.
- Confunden `split()` (sin argumento: separa por espacios) con `split(",")` (separa por coma).
- Invierten los argumentos de `replace`: escriben `replace(".", ",")`.
- Usan `join` como método de la lista y no de la cadena separadora.
- **Intervención docente:** "`split()` se usa sobre el string y devuelve una lista. `join()` se usa sobre el separador y recibe la lista como argumento. Al revés no funciona."

---

### Actividad 2 — Predecir salida: f-strings con formato (papel, 10 pts)

**Fragmento 1:**

```python
precio = 12.5
print(f"Precio: ${precio:.2f}")
```

**Salida esperada:**
```
Precio: $12.50
```

**Fragmento 2:**

```python
nombre = "Ana"
edad = 17
print(f"{nombre:10} {edad:3}")
```

**Salida esperada:**
```
Ana                17
```

Nota: `nombre:10` alinea a la izquierda en 10 caracteres (Ana seguido de 7 espacios); `edad:3` alinea a la derecha en 3 caracteres.

**Fragmento 3:**

```python
producto = "Pan"
cantidad = 3
precio_unitario = 2.5
total = cantidad * precio_unitario
print(f"{producto:10} x{cantidad:2}  ${total:.2f}")
```

**Salida esperada:**
```
Pan        x 3   $7.50
```

**Fragmento 4 (alineación y precisión combinadas):**

```python
valor = 123.4567
print(f"{valor:10.2f}")
print(f"{valor:.1f}")
```

**Salida esperada:**
```
    123.46
123.5
```

**Criterios de corrección:**
- **Fragmento 1 (2 pts):** `$12.50` (notar el 0 agregado).
- **Fragmento 2 (2 pts):** 10 caracteres con espacios, 3 caracteres.
- **Fragmento 3 (3 pts):** alineación, multiplicación dentro de f-string o fuera.
- **Fragmento 4 (3 pts):** redondeo y ancho total.

**Errores frecuentes:**
- No ponen los dos decimales: escriben `$12.5` en lugar de `$12.50`.
- No entienden el ancho mínimo: creen que `{nombre:10}` imprime "nombre" 10 veces.
- Se olvidan de que `{total:.2f}` redondea.
- **Intervención docente:** "`:10` es el ancho mínimo, no la cantidad de repeticiones. Si el texto es más corto que 10, agrega espacios."

---

### Actividad 3 — Escribir validación (papel, 20 pts)

**Solución esperada:**

```python
def pedir_entero(mensaje):
    """Pide un entero al usuario, validando con try/except."""
    while True:
        entrada = input(mensaje)
        try:
            numero = int(entrada)
            return numero
        except ValueError:
            print("Error: debe ingresar un numero entero. Intente de nuevo.")


if __name__ == "__main__":
    valor = pedir_entero("Ingrese un numero entero: ")
    print(f"El doble de {valor} es {valor * 2}")
```

**Criterios de corrección:**
- **Bucle `while True` (4 pts):** para reintentar hasta obtener un entero válido.
- **`try`/`except` (6 pts):** intenta convertir, captura `ValueError`.
- **Mensaje de error informativo (4 pts):** no solo `pass`, sino que avisa al usuario.
- **`return` del valor convertido (3 pts):** la función devuelve el `int`.
- **Bloque `if __name__` (3 pts):** presente con ejemplo de uso.

**Errores frecuentes:**
- No usan bucle: el programa termina al primer error.
- El `try` abarca todo el programa en lugar de solo la conversión.
- Atrapan la excepción con `except:` genérico sin especificar.
- Devuelven el string original en lugar del entero convertido.
- **Intervención docente:** "Si no ponés `while True`, el `except` solo te avisa del error pero no te da otra chance."

---

### Actividad 4 — Completar un menú (papel, 20 pts)

**Código esqueleto entregado al alumno:**

```python
# Programa: lista_de_tareas (esqueleto)

lista = []

while True:
    print("\n--- MENU ---")
    print("1. Agregar tarea")
    print("2. Listar tareas")
    print("3. Salir")
    opcion = input("Elegi una opcion: ")

    if opcion == "1":
        _______________
        _______________

    elif opcion == "2":
        if not lista:
            print("No hay tareas.")
        else:
            _______________
            _______________

    elif opcion == "3":
        print("¡Hasta luego!")
        _______________

    else:
        print("Opcion invalida.")
```

**Solución esperada (líneas completadas):**

```python
    if opcion == "1":
        tarea = input("Ingrese la tarea: ")
        lista.append(tarea)
        print("Tarea agregada.")

    elif opcion == "2":
        if not lista:
            print("No hay tareas.")
        else:
            print("\n--- Tareas ---")
            for tarea in lista:
                print(f"- {tarea}")

    elif opcion == "3":
        print("¡Hasta luego!")
        break
```

**Criterios de corrección:**
- **Opción 1 (6 pts):** pide texto con `input()`, usa `append()`, confirma.
- **Opción 2 (6 pts):** recorre con `for`, muestra con formato.
- **Opción 3 (4 pts):** `break` para salir del bucle.
- **Caso `else` (4 pts):** ya está escrito, pero debe entender que atrapa opciones inválidas.

**Errores frecuentes:**
- Usan `return` en lugar de `break` dentro de `while True`.
- En opción 2, imprimen `print(lista)` directamente sin formato.
- No verifican si la lista está vacía antes de listar.
- **Intervención docente:** "`break` rompe el bucle más cercano. `return` termina la función. Adentro de `while True` sin función, usá `break`."

---

### Actividad 5 — Tarea de programación: `analizador_texto.py` (computadora, 40 pts)

**Solución completa:**

```python
# analizador_texto.py
# Menu de consola que almacena frases en un diccionario y las analiza

def pedir_opcion():
    """Pide un numero de opcion valido (1-4) con validacion."""
    while True:
        entrada = input("Opcion: ")
        try:
            opcion = int(entrada)
            if opcion >= 1 and opcion <= 4:
                return opcion
            else:
                print("Opcion invalida. Ingrese 1, 2, 3 o 4.")
        except ValueError:
            print("Error: debe ingresar un numero.")


if __name__ == "__main__":
    frases = {}  # diccionario titulo -> frase

    while True:
        print("\n" + "=" * 30)
        print("      ANALIZADOR DE TEXTO")
        print("=" * 30)
        print("1. Ingresar frase")
        print("2. Mostrar palabras")
        print("3. Contar caracteres")
        print("4. Salir")

        opcion = pedir_opcion()

        if opcion == 1:
            titulo = input("Titulo de la frase: ")
            frase = input("Ingrese la frase: ")
            frases[titulo] = frase
            print(f"Frase '{titulo}' guardada.")

        elif opcion == 2:
            if not frases:
                print("No hay frases guardadas.")
            else:
                print("\n--- Frases guardadas ---")
                for titulo, frase in frases.items():
                    palabras = frase.split()
                    print(f"[{titulo}] Palabras: {palabras}")

        elif opcion == 3:
            if not frases:
                print("No hay frases guardadas.")
            else:
                print("\n--- Conteo de caracteres ---")
                for titulo, frase in frases.items():
                    letras = 0
                    espacios = 0
                    signos = 0
                    for caracter in frase:
                        if caracter.isalpha():
                            letras = letras + 1
                        elif caracter == " ":
                            espacios = espacios + 1
                        else:
                            signos = signos + 1
                    print(f"[{titulo}]")
                    print(f"  Letras: {letras:3}")
                    print(f"  Espacios: {espacios:3}")
                    print(f"  Signos:   {signos:3}")

        elif opcion == 4:
            print("¡Hasta luego!")
            break
```

**Salida de prueba (ejemplo de uso):**
```

==============================
      ANALIZADOR DE TEXTO
==============================
1. Ingresar frase
2. Mostrar palabras
3. Contar caracteres
4. Salir
Opcion: 1
Titulo de la frase: saludo
Ingrese la frase: Hola, mundo!
Frase 'saludo' guardada.

Opcion: 2

--- Frases guardadas ---
[saludo] Palabras: ['Hola,', 'mundo!']

Opcion: 3

--- Conteo de caracteres ---
[saludo]
  Letras:   9
  Espacios: 1
  Signos:   2

Opcion: 4
¡Hasta luego!
```

**Criterios de corrección (40 pts):**
| Aspecto | Pts | Qué se evalúa |
|---------|-----|---------------|
| Menú con `while True` | 4 | Bucle principal activo hasta opción "Salir" |
| Diccionario para almacenar frases | 4 | Clave = título, valor = frase |
| Opción 1: ingresar frase | 4 | Pide título y frase, guarda en diccionario |
| Opción 2: mostrar palabras con `split` | 6 | Usa `split()`, recorre `.items()`, muestra |
| Opción 3: contar caracteres | 8 | Diferencia letras, espacios, signos (o similar) |
| Validación de opción con `try`/`except` | 6 | Función separada `pedir_opcion()` o inline |
| Formato f-strings (alineación, decimales) | 4 | Mínimo: `{letras:3}` o similar |
| Comentarios y nombres claros | 4 | snake_case inglés, comentarios español |
| Sin persistencia | 0 | No usa `open()`, `write()`, `read()` |
| **Ejecución sin errores** | — | Verificar con `python analizador_texto.py` |

**Errores frecuentes y soluciones:**
| Error | Solución sugerida |
|-------|-------------------|
| Menú sin `break` en opción 4 (bucle infinito) | "¿Cómo sale el usuario si no ejecuta nunca `break`?" |
| No usan diccionario: sobreescriben una sola variable | "Si el usuario ingresa dos frases, la segunda borra la primera." |
| Validación solo con `isdigit()` sin `try`/`except` | "`isdigit()` no acepta negativos. Mejor `try`/`except`." |
| En el conteo, usan `frase.count(" ")` para contar letras | "Así no contás las letras, contás los espacios." |
| `split()` sin argumento no separa por signos de puntuación | Explicar que `Hola,` queda como una sola palabra con la coma |
| No verifican si el diccionario está vacío antes de listar | "Si no hay frases, mostrar un mensaje claro, no una lista vacía." |

**Verificación de ejecución:**

```bash
python analizador_texto.py
```

Debe compilar, mostrar el menú, responder a opciones 1-4, validar entrada no numérica y terminar con "Salir". No usa persistencia.

---

## 2. Criterios de logro generales

| Condición | Criterio |
|---|---|
| Logrado (≥70 pts) | Procesa cadenas con métodos apropiados, formatea salida con f-strings, valida entrada con `try`/`except`, y construye un menú funcional que integra todas las herramientas. |
| En proceso (40–69 pts) | Reconoce los métodos y la validación pero los aplica con errores de sintaxis o lógica (no separa bien opciones, no captura `ValueError`). |
| Requiere apoyo (<40 pts) | Dificultades en más de dos áreas. Se sugiere intensificación focalizada antes del Trabajo Integrador. |

## 3. Nota para el docente

Esta actividad se aplica **tras la evaluación de la Unidad 3** (encuentro 26). Es la antesala del Trabajo Integrador (U4). Prestar atención a:
- Si el estudiante puede integrar todas las herramientas aprendidas (cadenas, validación, menú) en un solo programa.
- La solidez de la validación (estudiantes que todavía no usan `try`/`except` necesitarán apoyo en U4).
- El uso de diccionario + bucles anidados (opción 3): suele ser el punto más demandante.
- Esta actividad puede usarse como diagnóstico previo al Trabajo Integrador; estudiantes con menos de 40 pts deberían recibir intensificación específica en los encuentros 34-35.