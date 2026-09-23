# Encuentro 28 — Ramas y pull requests

> Trabajo integrador y flujo profesional

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 28 de 36 |
| Unidad | 4 — Trabajo integrador y flujo profesional |
| Eje temático | 5 — Git, GitHub y trabajo colaborativo |
| Carácter/Objetivo | Procedimental |
| Estructura | clase |
| Duración teórica | 120 minutos (2 horas reloj) |
| Concepto nuevo | Ramas y pull requests |
| Requisitos previos | Encuentro 27 completado: README de portada creado y 6 issues abiertos en el repositorio grupal. Cada integrante tiene su cuenta de GitHub y el repositorio clonado localmente en su equipo. |
| Uso de celular | No permitido |
| Organización del trabajo | Grupos de 3-4 integrantes. Durante la práctica guiada, un integrante proyecta su pantalla; los demás siguen los pasos en su propia consola. Para el ejercicio independiente, cada grupo se divide los issues y trabaja en paralelo. |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y puente | 10 min |
| Teoría mínima | 20 min |
| Práctica guiada | 35 min |
| Ejercicio independiente | 25 min |
| Extensión y consolidación | 20 min |
| Cierre | 10 min |
| **Total** | **120 min** |

## 2. Objetivos de aprendizaje

1. Crear una rama por feature a partir de main con `git switch -c feature/<nombre>`.
2. Publicar la rama en GitHub con `git push -u origin feature/<nombre>`.
3. Abrir un pull request en GitHub y asignar a un compañero como revisor.
4. Revisar el código de un compañero y dejar comentarios en el PR.
5. Fusionar (merge) un PR aprobado a main y configurar la protección de main en GitHub.

## 3. Teoría mínima (20 min)

### Charla rápida: La rama como escritorio de trabajo particular

Imaginá que el grupo trabaja en una cocina profesional. `main` es el plato que se sirve al cliente: tiene que estar siempre impecable. Cada cocinero necesita su propia mesa de preparación para picar, probar y hasta equivocarse sin manchar el plato final. Esa mesa individual es tu **rama** (`feature/registro-producto`, `feature/menu-principal`, etc.). Cuando la preparación está lista, la llevás al jefe de cocina (tu revisor) para que la pruebe antes de incorporarla al plato. Ese proceso de prueba y autorización es el **pull request**. Recién cuando el revisor da el visto bueno, el plato se sirve (se fusiona a `main`).

### Lo mínimo indispensable

**Ramas por feature.** Hasta ahora trabajaste en `main` siempre. En un proyecto profesional, cada tarea (issue) se resuelve en su propia rama. Esto permite:

- Trabajar en paralelo sin pisar el código de otro.
- Aislar cambios incompletos del código estable.
- Revisar el código antes de incorporarlo.

| Comando | Qué hace |
| --- | --- |
| `git branch` | Lista las ramas locales; la actual tiene `*` |
| `git switch -c feature/algo` | Crea una nueva rama y se posiciona en ella |
| `git switch main` | Vuelve a la rama main |
| `git push -u origin feature/algo` | Publica la rama local en GitHub |

**Pull request (PR).** Es una solicitud para fusionar los cambios de una rama a `main`. GitHub muestra el diff línea a línea, permite comentarios y discusión. Nadie puede saltarse la revisión: el PR se abre, se asigna un revisor, se espera aprobación y recién entonces se mergea.

**Main protegida.** En GitHub se configura una regla que impide pushear directo a `main`. Todo cambio entra por PR con al menos una aprobación. Así `main` siempre está estable.

## 4. Práctica guiada (35 min)

Vamos a crear una rama, hacer un cambio, abrir un PR y mergearlo. El docente guía paso a paso; un integrante proyecta.

**Paso 1: Crear una rama desde main**

```bash
# Posicionate en main y asegurate de tener la última versión
git switch main
git pull origin main

# Creá una rama para mejorar el README
git switch -c feature/readme-mejoras
```

**Paso 2: Hacer un cambio y pushearlo a GitHub**

```bash
# Agregá una línea al README desde la consola
echo "" >> README.md
echo "## Estado" >> README.md
echo "" >> README.md
echo "En desarrollo — Unidad 4" >> README.md

# Versioná el cambio
git add .
git commit -m "README: agregar sección Estado"

# Publicá la rama en GitHub
git push -u origin feature/readme-mejoras
```

**Paso 3: Abrir un pull request en GitHub**

1. Andá al repositorio en GitHub.
2. Aparece un banner que dice "feature/readme-mejoras had recent pushes" con un botón **Compare & pull request**.
3. Completá:
   - **Título:** "Agregar sección Estado al README"
   - **Descripción:** "Agrega la sección Estado con el texto 'En desarrollo — Unidad 4' para indicar en qué etapa está el proyecto."
   - **Revisor:** asigná a otro integrante del grupo.
   - **Labels:** mejora.
4. Hacé clic en **Create pull request**.

**Paso 4: Revisar y aprobar el PR**

El integrante asignado como revisor:

1. Va a la pestaña **Pull requests** → abre el PR.
2. En la pestaña **Files changed** ve el diff línea por línea.
3. Hacé clic en **Review changes** → **Approve** → **Submit review**.
4. Opcional: dejá un comentario como "LGTM" (Looks Good To Me).

**Paso 5: Merge del PR aprobado**

El autor del PR (o cualquier integrante con acceso):

1. En la página del PR, hacé clic en **Merge pull request** → **Confirm merge**.
2. Opcional: hacé clic en **Delete branch** para limpiar la rama remota.

**Paso 6: Actualizar main local**

```bash
git switch main
git pull origin main
```

Verificá que el cambio está: `cat README.md` debe mostrar la nueva sección.

## 5. Ejercicio independiente (25 min)

**Consigna:** Cada grupo repite el flujo de rama-PR-merge para los 6 issues del plan, distribuyendo las responsabilidades:

1. Cada integrante toma uno o dos issues y crea su rama: `git switch -c feature/<nombre-corto>`.
2. En cada rama, hace un cambio mínimo relacionado con el issue (por ahora puede ser un archivo vacío o un esqueleto de función).
3. Publica la rama y abre un PR asignando a otro integrante como revisor.
4. Cada integrante revisa al menos un PR de un compañero y lo aprueba.
5. Cada PR se mergea a main después de la revisión.

**Pista:** Si no tenés código real todavía, podés crear un archivo con un comentario. Por ejemplo, para el issue #2 "Menú principal":

```bash
git switch -c feature/menu-principal
echo "# menu.py - placeholder para el menú principal" > trabajo-final/menu.py
git add .
git commit -m "menu: crear placeholder del menú principal"
git push -u origin feature/menu-principal
```

Luego abrí el PR desde GitHub.

**Solución esperada:** Al finalizar, el repositorio debe tener 6 PRs mergeados (uno por issue), cada uno revisado por un compañero distinto, y main con todos los placeholders de los archivos del trabajo final.

## 6. Extensión y consolidación (20 min)

**Para los grupos que terminaron:**

1. **Proteger main:** Andá a Settings → Branches → Add rule. Elegí `main` como branch name, activá "Require a pull request before merging" y "Require approvals" en 1. Guardá. Ahora nadie puede pushear directo a main.
2. **Conectar issues con PRs:** En la descripción de un PR, escribí `Closes #2` (donde 2 es el número del issue). Cuando el PR se mergea, GitHub cierra el issue automáticamente. Actualizá los PRs existentes para que cierren su issue correspondiente.
3. **Rama adicional:** Creá una rama `feature/gitignore` y agregá un archivo `.gitignore` con `__pycache__/` y `.vscode/`. Abrí PR, revisalo y mergealo.

## 7. Cierre (10 min)

### Qué te llevás

- Las ramas aíslan tu trabajo del de tus compañeros y de main.
- `git switch -c feature/algo` es el comando clave del flujo profesional.
- El pull request es el punto de control: no se mergea código no revisado.
- La protección de main fuerza el flujo profesional: no hay atajos.
- Conectar un issue a un PR (`Closes #N`) mantiene el plan actualizado automáticamente.

### Lo que viene

En el **Encuentro 29** arranca el **desarrollo del integrador**: cada grupo implementa las funciones del programa verdulería trabajando por issues y ramas, con revisiones entre pares. Vas a escribir código Python real dentro del flujo profesional que aprendiste hoy.

## 8. Errores comunes y trampas

1. **Olvidar `-u` en el primer push de la rama.** *Causa:* git no sabe adónde publicar. *Fix:* siempre `git push -u origin <rama>` la primera vez; después solo `git push`.

2. **Merge conflict por editar el mismo archivo en dos ramas.** *Causa:* dos personas modifican README.md en paralelo. *Fix:* dividir archivos por integrante (uno README, otro menu.py, otro productos.py). Si el conflicto ocurre, resolverlo en GitHub o en local.

3. **Aprobar el PR sin mirar el código.** *Causa:* apuro o confianza excesiva. *Fix:* establecer la regla del grupo: "no aprobar sin leer el diff". El revisor es responsable de lo que se mergea.

4. **PR sin descripción.** *Causa:* pensar que el título basta. *Fix:* usar la descripción para explicar qué cambia y por qué.

5. **Hacer el merge sin esperar la revisión.** *Causa:* querer terminarlo rápido. *Fix:* con la protección de main activada no es posible; si no está activada, el grupo debe acordar la disciplina.

6. **Mezclar cambios de otro issue en la misma rama.** *Causa:* un integrante trabaja dos tareas en la misma rama para ahorrar tiempo. *Fix:* cada rama resuelve un solo issue. Si se mezclan, separar con `git cherry-pick` o crear una rama nueva desde main.
