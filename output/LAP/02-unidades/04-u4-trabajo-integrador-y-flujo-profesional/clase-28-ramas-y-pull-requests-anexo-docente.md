# Anexo docente — Encuentro 28: Ramas y pull requests

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

**Consigna:** Cada grupo repite el flujo de rama-PR-merge para los 6 issues, distribuyendo responsabilidades.

**Flujo esperado por cada issue:**

```bash
# Cada integrante, en su máquina:
git switch main
git pull origin main
git switch -c feature/<nombre-issue>

# Ejemplo: feature/menu-principal
# Crear un placeholder
echo "# menu.py — Placeholder del menú principal" > trabajo-final/menu.py

git add .
git commit -m "menu: crear placeholder del menú principal"
git push -u origin feature/menu-principal
```

Luego, desde GitHub:

1. Abrir PR con título descriptivo y descripción.
2. Asignar revisor (un integrante distinto del autor).
3. Revisor: ir a Files changed, leer el diff, aprobar.
4. Autor o revisor: Merge pull request → Confirm merge.
5. Opcional: Delete branch.

**Resultado final esperado:**

- 6 PRs mergeados a main (uno por issue).
- Cada PR con al menos un approve de un compañero.
- Al menos 3 integrantes distintos como autores de PRs.
- Al menos 3 integrantes distintos como revisores.
- `main` con los 6 placeholders: `README.md` (mejorado), `menu.py`, `productos.py`, `ventas.py`, `factura.py`, `.gitignore`.

## 2. Solución de la actividad de extensión

**Proteger main:**

1. GitHub → Settings → Branches → Add rule.
2. Branch name pattern: `main`.
3. Activar: "Require a pull request before merging".
4. Activar: "Require approvals" (1).
5. Guardar.

**Conectar issues con PRs:**

En la descripción del PR, agregar `Closes #2` (número del issue correspondiente). Al mergear el PR, GitHub cierra el issue automáticamente.

**Rama `.gitignore`:**

```bash
git switch main
git pull origin main
git switch -c feature/gitignore

echo "__pycache__/
.vscode/
" > .gitignore

git add .
git commit -m "gitignore: agregar exclusiones de pycache y vscode"
git push -u origin feature/gitignore

# Abrir PR, revisar, mergear
```

## 3. Respuesta esperada del ejercicio

| Indicador | Esperado | Cómo verificar |
| --- | --- | --- |
| 6 PRs mergeados | 6 PRs en estado "Merged" | Pestaña Pull requests → Filter: Merged |
| Al menos 1 approve por PR | Sí, comentario "Approved" | Abrir cada PR → pestaña Conversation |
| Autores distintos | ≥ 3 | Ver columna Author en cada PR |
| Revisores distintos | ≥ 2 | Ver columna Reviewers en cada PR |
| Rama main protegida | Regla activa | Settings → Branches → Branch protection rules |
| `.gitignore` existe | `__pycache__/` y `.vscode/` | `cat .gitignore` en la raíz |

## 4. Criterios de corrección (lista de verificación)

| ✔ | Criterio | Peso |
| --- | --- | --- |
| ☐ | Cada integrante abrió al menos un PR | 25% |
| ☐ | Cada PR fue revisado y aprobado por un compañero | 25% |
| ☐ | Los 6 PRs están mergeados a main | 20% |
| ☐ | Main está protegida con requerimiento de PR | 15% |
| ☐ | `.gitignore` existe con `__pycache__/` | 10% |
| ☐ | Los PRs usan `Closes #N` (al menos uno) | 5% |

**Observación:** Un grupo que no logró activar la protección de main necesita asistencia directa del docente. Si GitHub Settings no está disponible (plan educativo), documentar la intención y trabajar con disciplina de equipo: "no pushear directo a main sin PR".

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| PR con 0 commits | El push local no se hizo antes de abrir el PR | "Hiciste `git push` antes de abrir el PR?" |
| Merge conflict | Dos ramas tocaron el mismo archivo | "Vamos a resolverlo juntos. Abrí el archivo, buscá las marcas <<<<<<, elegí qué versión conservar." |
| Aprobación sin leer el diff | Apuro o confianza | "Decime en voz alta qué cambió este PR antes de aprobarlo." |
| PR sin descripción | Pereza | "Sin descripción, el revisor no sabe qué revisar. Agregá al menos una línea." |
| Merge directo a main sin PR (protección no activada) | Omisión | "Activemos la protección ahora. Mientras tanto, borrá el commit de main y repetí por PR." |
| Rama con cambios de dos issues | Querer ahorrar tiempo | "Partí los cambios en dos ramas con `git cherry-pick` o creá una rama nueva desde main y rehacé los cambios." |

## 6. Registro de la clase

**Por grupo, registrar:**

- [ ] Cantidad de PRs mergeados: _____
- [ ] ¿Cada integrante abrió al menos un PR? Sí / No
- [ ] ¿Cada integrante revisó al menos un PR? Sí / No
- [ ] Main protegida activada: Sí / No / No disponible
- [ ] Conflictos de merge resueltos: 0 / 1 / 2+
- [ ] Grupo que necesita refuerzo en ramas: Sí / No
- [ ] Observaciones: _____

**Para la evaluación de proceso:**

- Si un grupo no completó los 6 PRs, el desarrollo del Encuentro 29 arrancará con deuda técnica.
- Los conflictos de merge son normales y deseables: indican que el grupo está trabajando en paralelo.
- Registrar qué integrantes no revisaron ningún PR: necesitan recordatorio sobre la responsabilidad compartida del código.