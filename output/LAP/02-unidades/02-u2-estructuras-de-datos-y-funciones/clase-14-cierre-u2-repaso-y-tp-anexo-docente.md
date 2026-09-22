# Anexo docente — Encuentro 14: Cierre U2: repaso y TP

> Documento docente formal. No se entrega a los alumnos.

## 1. Solución del ejercicio independiente

En el encuentro 14 no hay un ejercicio independiente separado del TP. El trabajo práctico es la actividad principal.

### Solución de referencia del TP-U2

**Archivo esperado:** `tp-u2/main.py`

```python
# === TP-U2: Administración del club de barrio ===
# Funciones primero, bloque principal al final.

def read_int(message):
    """Pide un número entero con validación."""
    while True:
        try:
            return int(input(message))
        except ValueError:
            print("Eso no es un número entero; intentá de nuevo.")


def read_bool(message):
    """Pide sí/no y devuelve True o False."""
    answer = input(message + " (s/n): ").strip().lower()
    return answer == "s" or answer == "si"


def precargar_socios():
    """Devuelve un diccionario con socios precargados."""
    return {
        "Ana García": {"age": 17, "category": "menor", "fee_paid": True},
        "Luis Pérez": {"age": 15, "category": "menor", "fee_paid": False},
        "Sofía Martínez": {"age": 18, "category": "adulto", "fee_paid": True},
    }


def mostrar_todos(club):
    """Muestra todos los socios con todos sus datos."""
    if len(club) == 0:
        print("No hay socios registrados.")
        return

    print("\n=== Lista completa de socios ===")
    for nombre, datos in club.items():
        estado = "al día" if datos["fee_paid"] else "adeuda"
        print(f"  {nombre} | Edad: {datos['age']} | Categoría: {datos['category']} | Cuota: {estado}")
    print(f"Total: {len(club)} socios\n")


def agregar_socio(club):
    """Pide datos y agrega un socio al diccionario."""
    nombre = input("Nombre del socio: ")
    if nombre in club:
        print("Ese nombre ya está registrado.")
        return

    edad = read_int("Edad: ")
    print("Categorías disponibles: menor, adulto, vitalicio")
    categoria = input("Categoría: ").strip().lower()
    if categoria not in ("menor", "adulto", "vitalicio"):
        print("Categoría inválida. Se asigna 'menor'.")
        categoria = "menor"

    pagado = read_bool("¿Tiene la cuota al día?")

    club[nombre] = {"age": edad, "category": categoria, "fee_paid": pagado}
    print(f"{nombre} fue agregado correctamente.")


def buscar_socio(club):
    """Busca un socio por nombre y muestra sus datos."""
    nombre = input("Nombre del socio a buscar: ")
    datos = club.get(nombre, None)
    if datos is None:
        print(f"{nombre} no está registrado.")
        return

    estado = "al día" if datos["fee_paid"] else "adeuda"
    print(f"\n--- {nombre} ---")
    print(f"  Edad: {datos['age']}")
    print(f"  Categoría: {datos['category']}")
    print(f"  Cuota: {estado}")


def dar_de_baja(club):
    """Elimina un socio si existe."""
    nombre = input("Nombre del socio a dar de baja: ")
    if nombre in club:
        club.pop(nombre)
        print(f"{nombre} fue dado de baja.")
    else:
        print(f"{nombre} no está registrado.")


def mostrar_al_dia(club):
    """Muestra solo los socios que tienen la cuota al día."""
    al_dia = {nombre: datos for nombre, datos in club.items() if datos["fee_paid"]}

    if len(al_dia) == 0:
        print("Ningún socio tiene la cuota al día.")
        return

    print("\n=== Socios con cuota al día ===")
    for nombre, datos in al_dia.items():
        print(f"  {nombre} | Edad: {datos['age']} | Categoría: {datos['category']}")
    print(f"Total: {len(al_dia)} socios\n")


def mostrar_menu():
    """Imprime el menú de opciones."""
    print("\n=== Club de Barrio — Sistema de Administración ===")
    print("1. Ver todos los socios")
    print("2. Agregar socio")
    print("3. Buscar socio")
    print("4. Dar de baja")
    print("5. Socios con cuota al día")
    print("6. Salir")


# === BLOQUE PRINCIPAL ===
if __name__ == "__main__":
    club = precargar_socios()
    print("¡Bienvenido al sistema del club de barrio!")

    while True:
        mostrar_menu()
        opcion = read_int("Elegí una opción: ")

        if opcion == 1:
            mostrar_todos(club)
        elif opcion == 2:
            agregar_socio(club)
        elif opcion == 3:
            buscar_socio(club)
        elif opcion == 4:
            dar_de_baja(club)
        elif opcion == 5:
            mostrar_al_dia(club)
        elif opcion == 6:
            print("¡Gracias por usar el sistema! Hasta la próxima.")
            break
        else:
            print("Opción inválida. Elegí un número del 1 al 6.")
```

## 2. Solución de la actividad de extensión

Como es encuentro de cierre, las actividades de extensión son los ejercicios de repaso de la sección Consolidación. No hay extensión extra del TP.

## 3. Respuesta esperada del TP

| Opción | Acción del usuario | Salida esperada |
| --- | --- | --- |
| 1 (inicio) | — | Muestra Ana, Luis y Sofía con datos |
| 2 | Nombre: "Pedro", Edad: 16, Cat: menor, Pagó: s | `Pedro fue agregado correctamente.` |
| 3 | Buscar: "Ana García" | Muestra edad, categoría, cuota |
| 3 | Buscar: "Inexistente" | `Inexistente no está registrado.` |
| 4 | Dar de baja: "Pedro" | `Pedro fue dado de baja.` |
| 5 | — | Muestra solo Ana y Sofía (Luis adeuda) |
| 6 | — | Despedida y salida del bucle |

## 4. Criterios de corrección (lista de verificación)

| ✔ | Aspecto | Peso |
| --- | --- | --- |
| ☐ | Archivo `tp-u2/main.py` existe y compila | obligatorio |
| ☐ | Diccionario de diccionarios como estructura de datos | 2 pts |
| ☐ | Funciones arriba del `if __name__ == "__main__":` | 1 pt |
| ☐ | Menú con las 6 opciones y función separada por opción | 3 pts |
| ☐ | `read_int` con validación `try/except ValueError` | 1 pt |
| ☐ | Búsqueda con `.get()` o `in` para evitar `KeyError` | 2 pts |
| ☐ | Filtro de socios con cuota al día (opción 5) | 1 pt |
| ☐ | Precarga de 3 socios al iniciar | 1 pt |
| ☐ | Comentarios en español, f-strings con tildes | 1 pt |
| ☐ | Commit con mensaje `tp-u2: programa con colecciones y funciones` | 1 pt |
| **Total** | | **13 pts** |

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| Estructura plana: `club = {"Ana": 17}` en vez de anidado | No comprendió el dict de dicts | Dibujar en pizarrón: un diccionario donde cada valor es OTRO diccionario. |
| Opción 5 no funciona o no existe | Olvidó implementar el filtro | Recordar que la opción 5 es un requisito del TP; revisar la consigna. |
| Código sin funciones o todo en el bloque principal | No aplicaron la organización del encuentro 13 | Mostrar el archivo de referencia: funciones arriba, `if __name__` al final. |
| No entregan el TP (sin commit/push) | Se quedaron sin tiempo o no crearon la carpeta | El ciclo de entrega los últimos 15 minutos es obligatorio. Quien no termina, commit así incompleto. |
| Error de `KeyError` al acceder al diccionario anidado | Usaron `club[nombre]` sin verificar | Revisar búsqueda: `.get()` para primer nivel, `in` para verificar antes de acceder. |
| El programa se rompe si el usuario ingresa texto en opción de menú | No usaron `read_int` en la opción del menú | `input()` devuelve `str`; si no se convierte, la comparación `== 1` es siempre `False`. |

## 6. Registro de la clase

**Para cada grupo o estudiante, registrar:**

- ¿Pudieron completar el TP dentro del tiempo?
- ¿Usaron la estructura de datos correcta (dict de dicts)?
- ¿Entregaron con commit y push?

**Para la evaluación de proceso:**

- Quiénes entregaron TP completo, quiénes parcial, quiénes no entregaron.
- Nivel de autonomía: ¿necesitaron ayuda constante o resolvieron solos?
- Detectar estudiantes que no dominan funciones para reforzar antes de la evaluación (encuentro 15).
- Esto cierra la Unidad 2 en el registro del curso. El resultado del TP-U2 y la evaluación del encuentro 15 definen la nota de la unidad.