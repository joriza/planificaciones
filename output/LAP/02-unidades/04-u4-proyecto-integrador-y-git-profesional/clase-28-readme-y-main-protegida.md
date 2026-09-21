# Encuentro 28 — README y main protegida

## Datos del encuentro

| Campo | Valor |
|---|---|
| Unidad | 4 — Proyecto integrador y Git profesional |
| Encuentro | 28 de 36 |
| Eje temático | 4 — Proyecto integrador y Git profesional |
| Carácter/Objetivo | Procedimental |
| Duración | 120 minutos (2 horas reloj) |
| Requisitos | Flujo issue → rama → PR → merge (Encuentro 27), repositorio del grupo con `tp-u1` a `tp-u3` |
| Concepto nuevo | README de portada y protección de la rama `main` |

## Objetivos de aprendizaje

- Redactar un README de portada que presente el repositorio del grupo.
- Activar la protección de `main` exigiendo pull request para fusionar.
- Demostrar que un push directo a `main` protegida es rechazado.
- Completar un PR revisado bajo la nueva regla de trabajo.

## Reparto de tiempos (120 minutos)

| Bloque | Minutos |
|---|---|
| Apertura y motivación | 10 min |
| Desarrollo teórico-práctico | 60 min |
| Consolidación y cierre | 20 min |
| Actividad complementaria | 30 min |
| **Total** | **120 min** |

## Apertura y motivación (10 min)

Un repositorio profesional se presenta y se protege. La portada (README) responde en un vistazo qué es el proyecto, qué hay en cada carpeta y cómo ejecutarlo; la rama protegida evita que un push directo rompa lo estable. Ambas cosas se piden en cualquier equipo real de desarrollo y son requisitos del trabajo final.

Se abre en el proyector el README de un proyecto público conocido y se pide identificar: ¿qué explica primero?, ¿dónde dice cómo ejecutarlo?, ¿qué NO explica? Esas tres respuestas definen el contenido mínimo del README del grupo.

## Desarrollo teórico-práctico (60 min)

### El README de portada

Ubicación: `README.md` en la raíz del repositorio. Contenido mínimo del curso, en cinco secciones cortas:

```markdown
# Programación en Python — Grupo N

Repositorio de trabajos de la materia Programación en Python.

## Integrantes

- Apellido, Nombre
- Apellido, Nombre

## Contenido

- `tp-u1/` — programa de consola: variables, condicionales y bucles.
- `tp-u2/` — agenda con persistencia en archivo de texto.
- `tp-u3/` — agenda con datos en JSON.
- `trabajo-final/` — proyecto integrador de la Unidad 4.

## Cómo ejecutar

Se necesita Python 3.11 (sin librerías externas).

    python tp-u3/agenda.py

## Cómo trabajamos

Cada cambio entra por issue, rama `feature/` y pull request revisado.
`main` está protegida: no se aceptan pushes directos.
```

La sección «Cómo trabajamos» se completa en este encuentro y quedará como regla fija para el trabajo final.

### Proteger `main`

En GitHub: **Settings** → **Branches** → **Add branch protection rule**:

- **Branch name pattern:** `main`
- Marcar **Require a pull request before merging**.
- Guardar (Save changes).

Efecto inmediato: `git push` directo a `main` es rechazado. Verificación en la terminal:

```bash
git switch main
echo "# prueba" >> temporal.txt
git add .
git commit -m "repo: prueba de push directo"
git push
```

Salida esperada:

```
remote: error: GH006: Protected branch update failed
To github.com:curso/grupo-n.git
 ! [remote rejected] main -> main (protected branch hook declined)
error: failed to push some refs to 'github.com:curso/grupo-n.git'
```

Ese rechazo es la regla funcionando. Limpieza del commit de prueba:

```bash
git reset --hard HEAD~1
```

### El PR obligatorio: README por flujo

Con `main` protegida, la portada entra como cualquier cambio: issue → rama → PR → revisión → merge.

```bash
git switch main
git pull
git switch -c feature/readme-portada
# crear y editar README.md
git add .
git commit -m "repo: readme de portada del grupo"
git push -u origin feature/readme-portada
```

En GitHub: PR con base `main`, descripción con `Closes #N`, revisión de otro integrante, merge, borrado de la rama y `git switch main` + `git pull` en cada máquina. Al terminar, la portada se ve en la página principal del repositorio.

## Consolidación y cierre (20 min)

Verificación por grupo, en orden:

- [ ] `README.md` en la raíz, con las cinco secciones mínimas.
- [ ] Protección de `main` activa (captura o muestra en pantalla).
- [ ] Push directo rechazado: evidencia observada en la terminal.
- [ ] README fusionado por PR revisado.
- [ ] `git pull` al día en la máquina de cada integrante.

### Qué te llevás

- El README es la portada técnica del repositorio: qué es, qué contiene, cómo ejecutarlo, cómo se trabaja.
- `main` protegida convierte la regla «todo entra por PR» en algo que Git hace cumplir.
- Un rechazo de push (`remote rejected`) ya no es un error a temer: es la protección trabajando.
- Desde hoy, todo cambio del trabajo final pasa por issue → rama → PR revisado.

## Actividad complementaria (30 min)

El grupo completa el estado profesional del repositorio y ensaya el flujo una vez más:

- Completar la lista de integrantes y las descripciones de `tp-u1` a `tp-u3` si quedaron incompletas.
- Agregar al README una línea por trabajo con el comando exacto de ejecución, probado en la terminal.
- Un último PR de mejora (ortografía de la portada, una sección «Estado» con los trabajos terminados), con issue, rama y revisión cruzada.

Quien termine antes, documenta en un issue las dos o tres ideas candidatas de proyecto integrador para traer al Encuentro 29.

## Lo que viene

En el Encuentro 29 arranca el trabajo final: el grupo elige su proyecto integrador, lo descompone en issues y programa el núcleo del menú con funciones; cada parte entra por su propia rama y su pull request revisado.
