# Encuentro 29 — Integrador: diseño y núcleo

## Datos del encuentro

| Campo | Valor |
|---|---|
| Unidad | 4 — Proyecto integrador y Git profesional |
| Encuentro | 29 de 36 |
| Eje temático | 4 — Proyecto integrador y Git profesional |
| Carácter/Objetivo | Procedimental |
| Duración | 120 minutos (2 horas reloj) |
| Requisitos | Flujo issue → rama → PR con `main` protegida (Encuentros 27 y 28); funciones y JSON de U2 y U3 |
| Concepto nuevo | Planificación del proyecto por issues y núcleo del menú con funciones |

## Objetivos de aprendizaje

- Descomponer el proyecto integrador en issues con alcance claro y orden de construcción.
- Crear el esqueleto canónico del archivo: constantes, funciones, `main()` y guard.
- Programar el núcleo del menú con `while` y funciones sobre datos en memoria.
- Integrar el núcleo a `main` mediante un pull request revisado.

## Reparto de tiempos (120 minutos)

| Bloque | Minutos |
|---|---|
| Apertura y motivación | 10 min |
| Desarrollo teórico-práctico | 60 min |
| Consolidación y cierre | 20 min |
| Actividad complementaria | 30 min |
| **Total** | **120 min** |

## Apertura y motivación (10 min)

Comienza el trabajo final: un programa integrador que usa todo el recorrido del año. Los datos se organizan con listas y diccionarios (U3), el código se reparte en funciones (U2), las decisiones y los bucles sostienen el menú (U1) y todo se construye en el repositorio profesional que el grupo armó los últimos dos encuentros.

Proyecto de referencia del curso (cada grupo puede proponer uno equivalente y acordarlo con el docente): **gestor de préstamos de equipos del aula-taller**. Registra qué equipo se presta, a quién, en qué fecha y si fue devuelto. Vive en `trabajo-final/prestamos.py`, con datos en `trabajo-final/prestamos.json`.

## Desarrollo teórico-práctico (60 min)

### Paso 1: del enunciado a los issues

Requisitos mínimos del integrador:

- Menú de consola con las opciones: registrar préstamo, listar préstamos, buscar por alumno, registrar devolución y salir.
- Cada préstamo es un diccionario con claves `equipo`, `alumno`, `fecha` (texto ISO `AAAA-MM-DD`) y `devuelto` (booleano).
- Persistencia completa en `prestamos.json` con `json.load` y `json.dump`.
- Validaciones con reintentos: números con `ValueError`, datos dañados con `sys.exit(1)`.
- Un solo archivo `.py`, sin librerías externas, con el esqueleto canónico del curso.

Descomposición en issues (se crean todos hoy, ordenados del 1 al 6):

| Issue | Alcance | Encuentro |
|---|---|---|
| 1. Núcleo del menú | Esqueleto + menú + alta y listado en memoria | 29 (hoy) |
| 2. Búsqueda por alumno | Listar los préstamos de un alumno | 30 |
| 3. Devolución | Marcar `devuelto: True` por búsqueda | 30 |
| 4. Persistencia JSON | Carga segura y guardado completo | 30 |
| 5. Validaciones | `pedir_entero` con reintentos; JSON dañado con `sys.exit(1)` | 30 |
| 6. README final y entrega | Documentación del proyecto y preparación de la defensa | 31 |

Regla de construcción: un issue = una rama `feature/` = un PR revisado. Nada entra a `main` por otro camino.

### Paso 2: el esqueleto canónico

`trabajo-final/prestamos.py` arranca con el orden fijo del curso:

1. `import` solo de lo que se usa (hoy: nada; la persistencia llega con el issue 4).
2. Constantes en `MAYUSCULAS_CON_GUIONES_BAJOS`.
3. Funciones con `def`.
4. `def main():` como punto de entrada.
5. `if __name__ == "__main__":` al final.

### Paso 3: el núcleo en memoria

Código completo del issue 1 (corre tal cual con `python prestamos.py`):

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

Salida esperada de una corrida de prueba (caso normal, canon de convenciones):

```
1) Registrar prestamo
2) Listar prestamos
3) Salir
Elija una opcion: 1
Equipo: PC-07
Alumno: Ana Garcia
Fecha (AAAA-MM-DD): 2025-09-15
Prestamo registrado

...
Elija una opcion: 2
2025-09-15 | PC-07 | Ana Garcia | pendiente
```

Segundo camino de prueba (caso de error previsto): opción `9` → `Opcion invalida`, y el menú vuelve a mostrarse.

### Paso 4: el núcleo entra por PR

```bash
git switch main
git pull
git switch -c feature/nucleo-menu
python prestamos.py        # probar los dos caminos antes de confirmar
git add .
git commit -m "trabajo-final: nucleo del menu con alta y listado"
git push -u origin feature/nucleo-menu
```

PR con `Closes #1`, revisión de otro integrante (probar el programa desde el PR es parte de la revisión), merge y limpieza. El issue 2 (búsqueda) puede arrancar en la actividad complementaria con su propia rama.

## Consolidación y cierre (20 min)

Verificación por grupo, en orden:

- [ ] Los seis issues creados y ordenados por construcción.
- [ ] Esqueleto canónico: constantes → funciones → `main()` → guard.
- [ ] Núcleo probado en los dos caminos (normal e inválida).
- [ ] PR del núcleo revisado (se probó el programa, no solo se leyó el código) y fusionado.
- [ ] `main` al día en la máquina de cada integrante.

### Qué te llevás

- Un proyecto se planifica con issues: cada uno es un paso verificable, no una idea vaga.
- El esqueleto canónico (constantes → funciones → `main()` → guard) es el mapa fijo de cualquier programa del curso.
- Un menú con `while` + funciones + lista de diccionarios ya es un programa completo en memoria.
- La persistencia se agrega después: primero el núcleo corre, después guarda.

## Actividad complementaria (30 min)

Issue 2 en su propia rama: **búsqueda por alumno**.

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

Conectarla al menú como opción 4, probar los dos caminos (con y sin coincidencias) y entrar por su propio PR con `Closes #2`.

## Lo que viene

En el Encuentro 30 el integrador gana memoria permanente: la colección pasa a `prestamos.json` con carga segura, se suman la devolución de equipos y las validaciones con reintentos, y cada mejora entra por su propio pull request.
