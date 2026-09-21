# Anexo docente — Encuentro 29: Integrador: diseño y núcleo

## Encuadre

Tercer encuentro de la Unidad 4 y arranque del trabajo final integrador. El grupo ya domina el flujo profesional; hoy lo aplica a un proyecto propio. La descomposición en issues es el aprendizaje central: ordenar la construcción (memoria primero, persistencia después) y comprometer alcance por issue. El núcleo del menú recupera funciones (U2) y lista de diccionarios (U3); nada de hoy es sintaxis nueva de Python: lo nuevo es la gestión del trabajo.

## Qué observar durante la clase

- Issues redactados como ideas («hacer el programa»): exigir alcance y criterio de listo por issue.
- Grupos que quieren empezar por la persistencia: sostener el orden; sin núcleo que corra, guardar JSON es prematuro.
- Código fuera del esqueleto canónico: lógica suelta a nivel de módulo o `input()` fuera de funciones se corrige en la revisión del PR.
- Comparación de texto de la opción del menú con `==` (correcto) frente a `int(input())` adelantado sin validación: la validación formal llega con el issue 5; hoy la opción inválida se maneja con `else`.
- PR aprobado sin haber corrido el programa: la revisión del integrador incluye probar, no solo leer.

## Solución de referencia (núcleo completo)

`trabajo-final/prestamos.py` al cierre del issue 1 (corre con `python prestamos.py` desde la carpeta `trabajo-final/`):

```python
TEXTO_MENU = """
1) Registrar prestamo
2) Listar prestamos
3) Salir
Elija una opcion: """

def registrar_prestamo(prestamos):
    # Pedir los datos del prestamo
    equipo = input("Equipo: ")
    alumno = input("Alumno: ")
    fecha = input("Fecha (AAAA-MM-DD): ")
    # Armar el registro con devuelto en False
    prestamo = {"equipo": equipo, "alumno": alumno, "fecha": fecha, "devuelto": False}
    prestamos.append(prestamo)
    # Confirmar el alta
    print("Prestamo registrado")

def listar_prestamos(prestamos):
    # Caso sin datos cargados
    if len(prestamos) == 0:
        print("No hay prestamos registrados")
        return
    # Recorrer y mostrar cada registro
    for prestamo in prestamos:
        if prestamo["devuelto"]:
            estado = "devuelto"
        else:
            estado = "pendiente"
        print(f'{prestamo["fecha"]} | {prestamo["equipo"]} | {prestamo["alumno"]} | {estado}')

def main():
    # Coleccion en memoria: la persistencia llega con el issue 4
    prestamos = []
    while True:
        opcion = input(TEXTO_MENU)
        if opcion == "1":
            registrar_prestamo(prestamos)
        elif opcion == "2":
            listar_prestamos(prestamos)
        elif opcion == "3":
            print("Hasta luego")
            break
        else:
            print("Opcion invalida")

if __name__ == "__main__":
    main()
```

Actividad complementaria (issue 2, búsqueda), a insertar como opción 4 del menú:

```python
def buscar_prestamos(prestamos):
    # Pedir el nombre a buscar
    texto = input("Alumno a buscar: ")
    # Recorrer y mostrar solo las coincidencias
    encontrados = 0
    for prestamo in prestamos:
        if texto == prestamo["alumno"]:
            print(f'{prestamo["fecha"]} | {prestamo["equipo"]} | {prestamo["alumno"]}')
            encontrados = encontrados + 1
    # Avisar si no hubo coincidencias
    if encontrados == 0:
        print("No se encontraron prestamos de ese alumno")
```

Verificación de los dos caminos por cada función: datos válidos y entrada prevista pero inválida (opción `9`, búsqueda sin coincidencias). Aceptación del issue 1: los tres datos del préstamo quedan en el registro, el listado muestra estado `pendiente` y salir corta el programa con el mensaje de despedida.

## Errores previsibles

1. **Comparar la opción con `int(opcion)`:** si escriben letras, `ValueError` corta el programa; en este encuentro la opción se compara como texto y `else` cubre lo inválido.
2. **`prestamos` creada fuera de `main()` o global por error:** la colección nace dentro de `main()` y se pasa por parámetro; anticipar que la persistencia del Encuentro 30 respetará ese diseño.
3. **Fecha escrita libre («15/9»):** se acepta como texto en el núcleo, pero la convención es ISO `AAAA-MM-DD`; corregir en la revisión del PR, no con `datetime` (fuera del curso).
4. **F-string con comillas dobles dentro de dobles:** usar comillas simples afuera (`f'{prestamo["fecha"]}'`) o variables intermedias.
5. **Commit del `.json` de prueba generado por error en E30:** no aplica todavía; si alguien crea archivos de datos a mano, recordar que los datos los crea el programa.

## Criterios de logro (4-8)

| Nivel | Descripción |
|---|---|
| 4 | Crea los issues pero el núcleo no corre (error de sintaxis o esqueleto incompleto). |
| 5 | Núcleo corriendo en memoria; el PR quedó sin revisión o sin merge. |
| 6 | PR del núcleo fusionado con revisión; falta al menos un camino de prueba documentado. |
| 7 | Seis issues creados con alcance, núcleo fusionado por PR probado, y búsqueda iniciada en rama propia. |
| 8 | Además, justifica el orden de construcción (memoria → persistencia) y el alcance de cada issue ante el curso. |

## Agrupamiento

Grupos de trabajo habituales sobre su repositorio. Roles sugeridos por PR: quien propone, quien revisa y prueba, quien fusiona; rotar respecto del Encuentro 28. En grupos con ausencias largas, reducir a cinco issues fusionando búsqueda y devolución.

## Ajustes para la siguiente edición

- Si el grupo completa el núcleo antes de 40 minutos, exigir la búsqueda como segundo PR dentro del encuentro.
- Si el proyecto propio de un grupo excede el alcance del enunciado (inventario, usuarios, fechas calculadas), recortarlo por issues: el mínimo defendible es el menú de cinco opciones con persistencia JSON.
