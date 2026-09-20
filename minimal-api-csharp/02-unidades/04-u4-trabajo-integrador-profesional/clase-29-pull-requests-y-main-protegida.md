# Encuentro 29 — Pull requests y main protegida

## 1. Metadatos del encuentro

| Campo | Detalle |
| --- | --- |
| Encuentro | 29 |
| Unidad | Unidad didáctica 4: Trabajo integrador profesional (encuentro 3 de 5) |
| Eje temático | Eje 5: Terminal, Git y GitHub |
| Carácter | Procedimental |
| Duración | 240 minutos: apertura y puente 20 · teoría mínima 40 · práctica guiada 70 · ejercicio independiente 50 · extensión y consolidación 45 · cierre 15 |
| Concepto nuevo | Pull request con «Closes #N»; revisión entre pares con checklist; merge a `main`; protección de rama (PR + 1 aprobación requerida) |
| Requisitos | Encuentros 27 y 28: carpeta `trabajo-final/` con el proyecto conectado a la base, issues con criterios de aceptación y al menos una rama `feature/*` empujada |
| Uso del celular | No permitido |
| Trabajo en equipo | Grupos: alumnos presentes ÷ equipos disponibles (mínimo posible); ningún equipo sin usar mientras haya alumnos sin equipo; rotación de integrantes |

## 2. Objetivos de aprendizaje

1. Abrir un pull request con título, descripción y la referencia «Closes #N» que vincule el trabajo con su issue.
2. Revisar el código de un compañero con la checklist del curso (compila, cumple criterios de aceptación, código legible, sin secretos).
3. Aprobar, fusionar (merge) y verificar que el issue se cierra automáticamente.
4. Proteger la rama `main` exigiendo pull request con una aprobación antes de fusionar.

## 3. Teoría mínima

### Apertura y puente (20 min)

Recorrido por las ramas empujadas la clase pasada (vista de ramas de cada grupo). Puente: «las ramas guardan trabajo terminado; hoy aprendemos el mecanismo que lo hace entrar a `main` con garantías». Se anuncia el hito del encuentro: al terminar, `main` queda protegida y el repo funciona como un repo profesional.

### El pull request: un pedido de integración con revisión

**Analogía — el informe revisado por un colega:** antes de presentar un informe al hospital, otro profesional lo lee, marca correcciones y firma su conformidad. Solo la versión aprobada entra al legajo. El pull request (PR) es ese trámite: «tengo trabajo terminado en una rama; pido que se revise y se fusione a `main`». El PR muestra lado a lado qué cambia (pestaña **Files changed**) y da lugar a comentarios por línea.

Las cuatro piezas del PR del curso:

1. **Título:** el feature en una frase (`trabajo-final: búsqueda de pacientes por apellido`).
2. **Descripción:** qué se hizo y, con la palabra clave **`Closes #3`**, la promesa de que al fusionar se cierra el issue `#3` solo.
3. **Revisión con checklist** (la del curso):
   - [ ] Compila y corre (`dotnet run` sin errores).
   - [ ] Cumple los criterios de aceptación del issue (probados con `curl`).
   - [ ] Nombres y código legibles (rutas en inglés, comentarios que explican, records al final).
   - [ ] Sin secretos (no hay contraseñas, tokens ni cadenas de conexión ajenas al canon).
4. **Merge:** la fusión aprobada a `main`; GitHub cierra el issue referenciado y ofrece borrar la rama ya fusionada.

La regla de oro del equipo: **quien escribió el código no es quien lo aprueba**. La revisión entre pares no es desconfianza: es el control de calidad más barato que existe.

### Main protegida: la puerta con llave

Hasta hoy `main` aceptaba push directos. Con la protección de rama, GitHub rechaza todo push directo a `main` y exige el camino completo: rama → PR → revisión aprobada → merge. La protección se configura en **Settings → Branches** con una regla de rama: requerir pull request antes de fusionar y exigir 1 aprobación.

## 4. Práctica guiada

> Trabajo por grupos con rotación: quien abre el PR no es quien lo revisa; los roles (autor, revisor, tester) rotan entre features. El docente modela el ciclo completo con la rama `feature/busqueda-pacientes` del encuentro 28 antes de que los grupos repliquen con las suyas.

### Paso 1 — Abrir el pull request (GitHub web)

Con la rama empujada, GitHub ofrece el botón **Compare & pull request** (también: **Pull requests → New pull request**). Verificar la dirección del compare: **base: `main`** ← **compare: `feature/busqueda-pacientes`**. Completar:

```markdown
Título: trabajo-final: búsqueda de pacientes por apellido

## Qué hace
Endpoint GET /patients/search?term=... que busca pacientes por apellido
con LIKE parametrizado.

## Cómo probarlo
- curl http://localhost:5080/patients/search?term=gar  ->  200
- curl -i http://localhost:5080/patients/search        ->  400
- curl -i http://localhost:5080/patients/search?term=zzz  ->  404

Closes #3
```

Crear con **Create pull request**. El PR queda vinculado al issue `#3` (se ve en la barra lateral del PR).

### Paso 2 — Revisar con la checklist (otro integrante del grupo)

El revisor abre la pestaña **Files changed** y recorre la checklist con el diff a la vista:

1. **Compila y corre:** bajar la rama y probar en local (`git switch feature/busqueda-pacientes` + `dotnet run`).
2. **Criterios de aceptación:** repetir los `curl` de la descripción del PR.
3. **Legibilidad:** comentarios que expliquen, sin código muerto, records al final.
4. **Sin secretos:** nada que no deba estar público.

Para pedir un cambio: **Review changes → Request changes**, con el comentario concreto (por línea con el signo `+` azul). El autor corrige, commitea en la MISMA rama y empuja: el PR se actualiza solo. Para aprobar: **Review changes → Approve** con un comentario que diga qué se probó.

### Paso 3 — Fusionar (merge)

Con la aprobación: **Merge pull request → Confirm merge**. GitHub hace dos cosas que se verifican en el momento:

1. El issue `#3` se cierra automáticamente (gracias a `Closes #3`).
2. Aparece el botón **Delete branch**: borrar la rama remota ya fusionada.

Actualizar el clon local y dejar de usar la rama muerta:

```powershell
git switch main
git pull
git branch
```

Salida esperada: `main` actualizada con el feature, y la rama local `feature/busqueda-pacientes` ya fusionada (se puede eliminar con `git branch -d feature/busqueda-pacientes`).

### Paso 4 — Proteger main (GitHub web)

**Settings → Branches → Add branch protection rule** (o **Add classic branch protection rule**):

| Campo | Valor |
| --- | --- |
| Branch name pattern | `main` |
| Require a pull request before merging | activado |
| Required approvals | 1 |

Guardar con **Save changes** (pide confirmar la contraseña de la cuenta).

### Paso 5 — Comprobar la protección

Desde GitHub web, intentar editar `README.md` directamente sobre `main` (**pen** sobre el archivo → editar → **Commit changes**): GitHub ya no permite commitear directo sobre `main`; en el diálogo de confirmación solo ofrece crear una rama nueva y empezar un pull request. Esa es exactamente la señal buscada: la puerta con llave funciona. Cerrar el borrador de edición sin guardar.

Verificación complementaria desde la terminal (sin generar commits sueltos): el próximo `git push` directo a `main` que alguien intente será rechazado con `GH006: Protected branch update failed`. Si ocurre, no es un error del grupo: es la protección trabajando (ver el anexo docente para la recuperación).

> Nota del curso: la protección de ramas en GitHub Free está disponible en repositorios **públicos**. Verificar que el repo del grupo sea público; en caso contrario, ver el anexo docente.

## 5. Ejercicio independiente

**Consigna:** cada grupo completa el ciclo PR para todas sus ramas empujadas:

1. Abrir un PR por cada rama `feature/*` pendiente, con descripción, cómo probarlo y `Closes #N`.
2. Revisar entre pares con la checklist completa (compila, criterios, legibilidad, secretos); el autor de un PR nunca es su revisor.
3. Solicitar cambio y corregir al menos una vez (que la corrección viaje por el PR, con commit en la misma rama), para ejercitar el ciclo completo.
4. Aprobar, fusionar, verificar el cierre automático del issue y borrar la rama remota.
5. Actualizar el README: los endpoints fusionados pasan a estado `listo`.

**Pista:** la checklist se lee ítem por ítem con el diff abierto; aprobar «porque se ve bien» no es revisar. Si un criterio de aceptación no se puede probar, el PR espera hasta que se pueda.

## Extensión y consolidación

Para quienes completan la consigna base:

- Explorar la pestaña **Conversation** del PR: historial de commits, comentarios y aprobaciones como registro del proceso.
- Revisión cruzada entre grupos: aprobar el PR de otro grupo con la checklist, y defender los comentarios hechos.
- Redactar en el README una sección «Cómo trabajamos»: issue → rama → PR con checklist → merge a `main` protegida.

Consolidación docente: proyectar el historial de un PR completo (comentarios, cambios solicitados, aprobación) y nombrar en voz alta las cuatro causales de rechazo de la checklist.

## 6. Cierre

### Qué te llevás

- El pull request es el pedido de integración: muestra el diff, recibe la revisión y fusiona con garantías.
- `Closes #N` en la descripción cierra el issue automáticamente al fusionar: la trazabilidad issue → PR → `main` queda completa.
- La checklist del revisor tiene cuatro ítems: compila, cumple criterios de aceptación, código legible, sin secretos.
- Quien escribe no aprueba: la revisión entre pares es el control de calidad del equipo.
- `main` quedó protegida: todo cambio entra por PR con una aprobación; el push directo rechazado (GH006) es la protección funcionando.

### Lo que viene

En el encuentro 30 todo ese andamiaje se usa en un **sprint de desarrollo mentorizado**: el docente modela en vivo UN endpoint nuevo (con subconsulta) y los grupos resuelven el resto de sus issues abiertos, integrando por PR, cada vez con menos ayuda.

## 7. Errores comunes y trampas

| Error | Causa | Fix |
| --- | --- | --- |
| PR con dirección invertida | En el compare quedó `base: feature/...` ← `compare: main` | Verificar siempre `base: main` antes de crear; si ya se creó mal, cerrarlo y reabrirlo bien |
| Merge sin revisión | El propio autor se aprueba | Regla de equipo: autor y aprobador distintos; luego de proteger `main`, GitHub exige la aprobación de otro |
| Falta `Closes #N` en la descripción | Se escribió la descripción apurada | Editar la descripción del PR ANTES del merge (botón Edit de la descripción); si ya se fusionó, cerrar el issue manualmente y anotar la lección |
| Seguir commiteando en una rama ya fusionada | La rama quedó activa en local tras el merge | Después del merge: `git switch main`, `git pull`, y el próximo trabajo en una rama nueva |
| Aprobar sin leer el diff | Revisión simbólica («LGTM») | La checklist se recorre con Files changed abierto; el revisor debe poder decir qué probó con `curl` |
| `main` local desactualizada al crear la siguiente rama | Se creó la rama sin `pull` | `git switch main` + `git pull` antes de cada rama nueva; así el diff del PR muestra solo el feature |
