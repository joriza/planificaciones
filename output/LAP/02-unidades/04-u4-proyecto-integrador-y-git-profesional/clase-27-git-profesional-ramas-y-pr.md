# Encuentro 27 — Git profesional: ramas y PR

## Datos del encuentro

| Campo | Valor |
|---|---|
| Unidad | 4 — Proyecto integrador y Git profesional |
| Encuentro | 27 de 36 |
| Eje temático | 4 — Proyecto integrador y Git profesional |
| Carácter/Objetivo | Procedimental |
| Duración | 120 minutos (2 horas reloj) |
| Requisitos | Repositorio del grupo con `tp-u1` a `tp-u3`, Git configurado, cuenta de GitHub |
| Concepto nuevo | Issues, ramas por feature y pull requests |

## Objetivos de aprendizaje

- Explicar para qué sirve una rama y por qué `main` se mantiene estable.
- Crear un issue con alcance claro y una rama `feature/` asociada.
- Abrir un pull request, someterlo a revisión entre pares y fusionarlo.
- Verificar en el historial que el cambio quedó integrado a `main`.

## Reparto de tiempos (120 minutos)

| Bloque | Minutos |
|---|---|
| Apertura y motivación | 10 min |
| Desarrollo teórico-práctico | 60 min |
| Consolidación y cierre | 20 min |
| Actividad complementaria | 30 min |
| **Total** | **120 min** |

## Apertura y motivación (10 min)

La Unidad 4 cambia el foco: del programa individual al repositorio profesional del grupo. Hasta acá cada entrega se subía directo a `main`; a partir de hoy todo cambio entra por un camino visible: issue → rama → pull request → revisión → merge. Es el mismo flujo que usan los equipos de desarrollo reales y es condición para el trabajo final de la unidad.

Se abre el repositorio de un grupo voluntario en el proyector y se pregunta al resto: ¿quién cambió qué, cuándo y por qué? El historial lineal de `main` no responde bien esas preguntas; de esa necesidad nace el flujo con ramas.

## Desarrollo teórico-práctico (60 min)

### Conceptos: issue, rama y pull request

| Concepto | Qué es | Ejemplo del curso |
|---|---|---|
| Issue | Unidad de trabajo con título y objetivo: algo concreto a cambiar | «Validar la edad al cargar un contacto» |
| Rama `feature/` | Línea de trabajo paralela donde se hace ese cambio sin romper `main` | `feature/validar-edad` |
| Pull request (PR) | Pedido de fusionar la rama a `main`, con revisión antes del merge | PR del issue anterior |

Reglas del curso para la unidad:

- `main` es la única rama estable: siempre debería poder ejecutarse.
- Un issue = una rama = un PR: cambios chicos y revisables.
- Ningún merge sin una revisión de otro integrante del grupo.

### Paso 1: crear el issue

En GitHub, pestaña **Issues** → **New issue**. Título en una línea, cuerpo con dos partes: qué se propone y dónde se aplica. Ejemplo del curso:

> **Título:** Validar la edad al cargar un contacto
> **Cuerpo:** hoy `int(input(...))` se cae con `ValueError` si se escribe un número inválido. Agregar reintentos en la carga de contactos de `tp-u3/agenda.py`.

### Paso 2: crear la rama y trabajar

```bash
git switch main
git pull
git switch -c feature/validar-edad
```

El cambio en `tp-u3/agenda.py`: agregar esta función y usarla en la carga de contactos.

```python
def pedir_entero(mensaje):
    # Pide un numero entero y reintenta hasta recibir uno valido.
    while True:
        dato = input(mensaje)
        try:
            return int(dato)
        except ValueError:
            # Entrada no numerica: se avisa y se vuelve a pedir.
            print("Debe ingresar un numero valido")
```

### Paso 3: commit y push de la rama

```bash
git add .
git commit -m "tp-u3: valida la edad con reintentos"
git push -u origin feature/validar-edad
```

### Paso 4: abrir y revisar el pull request

En GitHub aparece el botón **Compare & pull request**. Base: `main`; compare: la rama `feature/`. En la descripción se escribe `Closes #N` (el número del issue) para que el merge lo cierre automáticamente.

La revisión la hace otro integrante del grupo: pestaña **Files changed**, lectura línea por línea, y **Review changes** → **Approve** (o **Comment** si hay algo por corregir; entonces se corrige en la misma rama y se vuelve a pedir revisión).

### Paso 5: merge y limpieza

Con la revisión aprobada: **Merge pull request** → **Confirm merge** → **Delete branch** (en GitHub). En la máquina local:

```bash
git switch main
git pull
git log --oneline --graph -5
```

Salida esperada (ejemplo):

```
* a1b2c3d (origin/main, main) tp-u3: valida la edad con reintentos (#4)
* 9f8e7d6 tp-u3: agenda migrada a json
```

El commit del merge aparece en `main` con la referencia al PR: el historial responde quién, qué y por qué.

## Consolidación y cierre (20 min)

Verificación por grupo, en orden:

- [ ] Un issue creado con alcance claro.
- [ ] Una rama `feature/` con al menos un commit.
- [ ] Un PR revisado y aprobado por otro integrante.
- [ ] Merge hecho y rama remota eliminada.
- [ ] `git switch main` + `git pull` en la máquina de cada integrante.

### Qué te llevás

- Un issue es una unidad de trabajo con nombre y objetivo, no una tarea vaga.
- Todo cambio se hace en una rama `feature/`; `main` no se toca directo.
- El PR es la puerta de entrada a `main`: sin revisión de un par, no hay merge.
- El historial de `main` pasa a documentar el trabajo del grupo.

## Actividad complementaria (30 min)

Cada integrante del grupo completa el ciclo una vez más, con rotación de roles (quien revisó ahora propone y viceversa). Consignas posibles sobre `tp-u3/agenda.py`, una por integrante:

- Mejorar un mensaje de salida para que sea más claro.
- Agregar la opción de listar contactos ordenados por nombre.
- Corregir un texto con tildes que haya quedado dentro del código (el código no lleva tildes).

Cada consigna: issue propio, rama `feature/` propia, PR propio y revisión cruzada dentro del grupo. Si el tiempo alcanza para uno solo, se completa en casa; el repositorio debe quedar con al menos dos PR fusionados al cierre de la unidad.

## Lo que viene

En el Encuentro 28 el repositorio gana su portada y sus reglas: se redacta el README del grupo y se activa la protección de `main`, de modo que ningún push directo la vuelva a tocar; todo cambio entrará solo por pull request revisado.
