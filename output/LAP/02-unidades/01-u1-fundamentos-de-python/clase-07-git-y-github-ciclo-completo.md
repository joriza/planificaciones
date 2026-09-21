# Encuentro 7: Git y GitHub: ciclo completo

## Datos del encuentro

| Campo | Valor |
|---|---|
| Unidad | U1: Fundamentos de Python |
| Encuentro | 7 de 31 (4 de 5 en la unidad) |
| Duración | 120 minutos |
| Carácter | Procedimental (eje transversal: Terminal, Git y entrega de trabajos) |

## Objetivos de aprendizaje

- Crear el repositorio local del grupo con `git init` y el `.gitignore` desde el primer commit.
- Registrar una versión con `git add` y `git commit` con mensaje convencional.
- Conectar el repositorio local con GitHub mediante `git remote add origin` y subirlo con `git push`.
- Verificar la entrega desde el navegador (archivos e historial).
- Practicar la rutina de cierre con un commit propio por integrante.

## Reparto de tiempos (120 minutos)

| Bloque | Minutos |
|---|---|
| Apertura y motivación | 10 |
| Desarrollo teórico-práctico | 60 |
| Consolidación y cierre | 20 |
| Actividad complementaria | 30 |

## Charla rápida

Sin control de versiones, la carpeta de un proyecto se llena de copias: `gestion_notas.py`, `gestion_notas_v2.py`, `gestion_notas_final.py`, `gestion_notas_final_bueno.py`. Git reemplaza todas esas copias por un historial: cada `commit` es una foto fechada y comentada del proyecto, y se puede volver a cualquiera de ellas. GitHub es el álbum compartido en la nube: la copia del grupo, accesible desde cualquier máquina, que además es el buzón oficial de entregas de esta materia.

## Teoría mínima

### Conceptos

| Concepto | Idea mínima |
|---|---|
| Repositorio | La carpeta del proyecto + el historial completo de versiones (vive en la carpeta oculta `.git/`). |
| Commit | Una foto del proyecto en un momento dado, con autor, fecha y mensaje. |
| Remoto | La copia del repositorio en GitHub; se sincroniza con `push` (subir) y `pull` (bajar). |
| `main` | El nombre de la rama principal; en este curso se trabaja en mono-rama `main` hasta la Unidad 4. |
| `.gitignore` | Lista de archivos que Git debe ignorar; en la raíz del repositorio desde el primer commit, con `__pycache__/`. |

### El ciclo de la primera entrega (solo se hace una vez)

```bash
git init                      # crear el repositorio local
git add .                     # elegir qué entra en la foto
git commit -m "mensaje"       # tomar la foto con su mensaje
git branch -M main            # nombrar la rama principal
git remote add origin <URL>   # conectar con el repo de GitHub
git push -u origin main       # subir la primera vez
```

Desde este encuentro, cada cierre de trabajo usa la rutina corta de la sección de cierre: `add`, `commit`, `push`.

### Convención de mensajes

Cada mensaje de commit del curso usa el formato `<carpeta>: <resumen en espanol, sin tildes>`:

```bash
git commit -m "tp-u1: primera version del registro de notas"
```

El mensaje describe qué cambió, no que se hizo trabajo: «tp-u1: agrega conteo de aplazadas» sí; «cambios» o «avance» no.

### Autenticación

GitHub ya no acepta la contraseña de la cuenta para `push`: usa un **token de acceso personal** (PAT) o el gestor de credenciales del sistema. Antes de la clase, cada grupo debe tener su cuenta creada; el token se genera en *Settings → Developer settings → Personal access tokens* si el gestor de credenciales no lo resuelve solo.

## Práctica guiada: el repositorio del grupo

El programa `gestion_notas.py` (versión 3 del Encuentro 6, sin cambios) entra hoy al repositorio: es la base sobre la que el TP-U1 crecerá en el próximo encuentro.

**Paso 1:** verificar la instalación y la identidad de Git:

```bash
git --version
git config --global user.name "Nombre Apellido"
git config --global user.email "mail@ejemplo.com"
```

Los dos últimos solo si no se configuraron antes: el nombre y el mail quedan en cada commit.

**Paso 2:** crear el repositorio en GitHub (desde el navegador): botón **New repository**, nombre `registro-notas`, **sin** README ni licencia (si se crea con README, el primer `push` choca con un historial ajeno). Copiar la URL que ofrece GitHub al terminar.

**Paso 3:** preparar la carpeta local del grupo:

1. Crear la carpeta `registro-notas` y abrirla en VS Code.
2. Crear en la raíz el archivo `.gitignore` con un solo contenido: `__pycache__/`.
3. Crear la carpeta `tp-u1/` dentro, y copiar ahí el `gestion_notas.py` de la versión 3.

Estructura final esperada:

```
registro-notas/
├── .gitignore
└── tp-u1/
    └── gestion_notas.py
```

**Paso 4:** crear el repositorio local y mirar el estado:

```bash
git init
git status
```

Salida esperada de `git status` (resumida): rama `main` (o `master` hasta el renombrado), archivos sin seguimiento (`Untracked files`: `.gitignore`, `tp-u1/`).

**Paso 5:** registrar la primera versión:

```bash
git add .
git commit -m "tp-u1: primera version del registro de notas"
```

Salida esperada del `commit` (los códigos cambian en cada máquina):

```
[main (root-commit) a1b2c3d] tp-u1: primera version del registro de notas
 2 files changed, 62 insertions(+)
 create mode 100644 .gitignore
 create mode 100644 tp-u1/gestion_notas.py
```

**Paso 6:** conectar con GitHub y subir por primera vez:

```bash
git branch -M main
git remote add origin https://github.com/<organizacion-del-grupo>/registro-notas.git
git push -u origin main
```

La primera vez, el navegador o el gestor pide autorizar el acceso; con el token o el gestor de credenciales resuelto, la salida termina en `main -> main`.

**Paso 7:** verificar la entrega en el navegador: el archivo `tp-u1/gestion_notas.py` visible en GitHub, y en la pestaña de historial (reloj) el commit con su mensaje y su autor.

## Ejercicio independiente: un commit por integrante

Cada integrante del grupo agrega **una mejora mínima y propia** al programa (una línea: por ejemplo, cambiar el mensaje de bienvenida por uno con el nombre del grupo) y la sube con la rutina completa:

```bash
git add .
git commit -m "tp-u1: ajusta mensaje de bienvenida"
git push
```

Después de los tres o cuatro pushes, ver el historial en conjunto:

```bash
git log --oneline
```

Reglas del ejercicio: un integrante por vez (dos pushes simultáneos desde máquinas distintas al mismo archivo pueden chocar), mensaje convencional siempre, y si un `push` es rechazado porque un compañero subió antes: `git pull` y volver a intentarlo.

## Rutina de cierre (git)

Desde este encuentro, todo cierre de trabajo del curso usa esta rutina:

```bash
git add .
git commit -m "<carpeta>: <resumen en espanol, sin tildes>"
git push
```

Un commit que refiera al avance al final de cada encuentro, o de la clase que quede sin terminar.

## Cierre

**Qué llevamos:** el repositorio guarda el historial completo del proyecto; `add` elige qué entra en la foto, `commit` la toma con mensaje convencional y `push` la comparte en GitHub. El `.gitignore` evita subir basura (`__pycache__/`) desde el primer commit. La primera entrega del curso ya está en línea, y a partir de hoy la rutina de cierre es siempre la misma.

**Lo que viene:** el TP-U1. En el próximo encuentro el programa crece de un estudiante a toda la comisión (cantidad de estudiantes, contadores por condición y resumen final), y esa versión terminada se entrega por GitHub con la rutina de cierre.

## Errores comunes y trampas

| Error | Causa | Solución |
|---|---|---|
| `git init` en la carpeta equivocada | Inicializar una carpeta por encima o por debajo de la del proyecto; quedan repositorios anidados. | Verificar con `git status` que aparezcan `.gitignore` y `tp-u1/`; borrar el `.git/` equivocado y volver a inicializar en la raíz correcta. |
| Commit vacío | `git commit` sin `git add` previo: «nothing to commit». | `git status` antes del commit; `add` primero. |
| Editor abierto en el commit | `git commit` sin `-m` abre un editor de mensajes. | Siempre `-m "mensaje"`; si el editor se abrió, guardar y cerrar para continuar. |
| `push` sin remoto configurado | Falta `git remote add origin <URL>` o la URL está mal tipeada. | `git remote -v` para ver el remoto; corregir con `git remote set-url`. |
| `__pycache__/` subido al repo | `.gitignore` ausente o creado después del primer `add`. | Crear el `.gitignore` antes del primer commit; si ya se subió, pedir corrección guiada en la próxima clase. |
| Contraseña rechazada en `push` | GitHub ya no acepta contraseñas de cuenta para subir código. | Token de acceso personal o gestor de credenciales del sistema. |
| `push` rechazado por avance remoto | Un compañero subió primero y el local quedó atrás. | `git pull` para traer el avance y repetir el `push`. |
