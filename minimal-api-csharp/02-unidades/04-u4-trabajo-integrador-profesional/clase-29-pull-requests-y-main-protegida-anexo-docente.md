# Anexo docente — Encuentro 29: pull requests y main protegida

> Registro docente formal. Documento interno del docente: no se entrega a los alumnos.

| Campo | Detalle |
| --- | --- |
| Encuentro | 29 — Unidad didáctica 4 (3 de 5) |
| Contenido | Pull requests con «Closes #N»; revisión entre pares; merge; protección de `main` |
| Insumos | Ramas `feature/*` del encuentro 28; consigna canónica (encuentro 27) |

## 1. Solución de referencia: PR modelo completo

Contenido íntegro del PR modelado en la práctica (ajustar el número de issue al repo real):

```markdown
Título: trabajo-final: búsqueda de pacientes por apellido

## Qué hace
Endpoint GET /patients/search?term=... que busca pacientes por apellido
con LIKE parametrizado. Incluye validación manual del término y
404 con mensaje cuando no hay coincidencias.

## Cómo probarlo
- curl http://localhost:5080/patients/search?term=gar     ->  200 con lista
- curl -i http://localhost:5080/patients/search           ->  400 con mensaje
- curl -i http://localhost:5080/patients/search?term=zzz  ->  404 con mensaje

Closes #3
```

Puntos de corrección al proyectar: la dirección del compare (`base: main`), la referencia del issue y que la sección «Cómo probarlo» contenga los mismos casos que los criterios de aceptación del issue.

## 2. Checklist del revisor (para proyectar o imprimir)

| ✔ | Ítem | Qué verifica el revisor en concreto |
| --- | --- | --- |
| ☐ | Compila y corre | Baja la rama, `dotnet run`, sin errores en la terminal |
| ☐ | Cumple los criterios de aceptación | Repite con `curl` cada caso del issue; los códigos coinciden |
| ☐ | Nombres y código legibles | Rutas en inglés y plural, comentarios que explican, records al final, ids `long`, fechas `string` |
| ☐ | Sin secretos | No hay contraseñas, tokens ni cadenas de conexión que no sean el canon `Data Source=hospital.db` |

Protocolo de revisión que se espera del grupo: comentario por línea cuando el cambio es puntual; `Request changes` con lista concreta cuando hay más de un problema; `Approve` con un comentario que diga qué se probó.

## 3. Guía de protección de main

Camino exacto en GitHub web: **Settings → Branches → Add branch protection rule** (según la vista del repo: **Add classic branch protection rule**):

1. **Branch name pattern:** `main`.
2. Activar **Require a pull request before merging**.
3. **Required approvals:** `1`.
4. **Save changes** (pide reingresar la contraseña de la cuenta).

Verificación en clase: intentar editar un archivo directamente sobre `main` desde la web; el diálogo solo ofrece crear rama nueva y abrir PR.

**Nota institucional:** la protección de ramas de GitHub Free está disponible en repositorios públicos. Si el grupo trabajó con repo privado y la cuenta es gratuita, la regla no se aplica. Intervención esperada (en orden): (1) hacer público el repo del grupo, si la institución lo autoriza; (2) si no, dejar asentado en el README la convención de equipo «ningún push directo a `main`» y aplicar la revisión entre pares como control social; el resto del flujo (issues, ramas, PRs, merge) funciona idéntico.

## 4. Receta docente: push directo rechazado (GH006)

Situación esperada tras proteger `main`: un grupo commitea sobre `main` local y empuja; GitHub rechaza con `GH006: Protected branch update failed` y la rama local queda con un commit que el remoto no tiene.

Recuperación (la realiza el docente o el grupo asistido, nunca de manera automática):

1. Identificar el commit atrapado: `git log --oneline -3` en `main`.
2. Si el commit es basura de prueba (el caso más común): alinear con el remoto con `git reset --hard origin/main`. Es una operación destructiva para el commit local: verificar antes que no contenga trabajo real.
3. Si el commit tiene trabajo real: rescatarlo en una rama ANTES de alinear: `git switch -c feature/rescate` y desde ahí seguir el flujo normal de PR; recién entonces `git switch main`, `git reset --hard origin/main`.
4. Cerrar la escena con el grupo: el flujo correcto era rama → PR, nunca push directo a `main`.

## 5. Criterios de observación de la clase

| Criterio | Se observa cuando |
| --- | --- |
| PR completo | Descripción con qué hace, cómo probarlo y `Closes #N`; el compare apunta a `main` |
| Revisión real | El revisor baja la rama o lee el diff; sus comentarios citan líneas o criterios concretos |
| Ciclo de corrección | Al menos un `Request changes` con su corrección posterior viajando por la misma rama |
| Merge con trazabilidad | El issue se cierra solo; la rama remota se borra; el README pasa el endpoint a `listo` |
| Protección operativa | El grupo puede explicar qué cambió en el repo y por qué el push directo ya no es posible |

## 6. Errores esperados e intervención

| Error esperado | Intervención docente |
| --- | --- |
| El autor se aprueba a sí mismo | Preguntar «¿quién controla al controlador?»; reasignar la revisión; proteger `main` antes de lo previsto si la tentación se repite |
| Revisión de superficie («se ve bien») | Pedir al revisor que nombre UNA línea que leyó y UN caso que probó; sin eso, no hay aprobación |
| Conflicto de merge cuando dos ramas tocaron `Program.cs` | Oportunidad didáctica: resolverlo juntos en el PR (GitHub ofrece resolver en la web o desde local); reforzar «un endpoint por issue/rama» como prevención |
| Miedo al botón merge («¿y si rompo todo?») | Recordar el mapa: `main` es recuperable, el historial no se pierde; mostrar el commit de merge y cómo `git pull` trae todo al clon |
| Desactivar la protección «porque molesta» | Negativa docente y devolución: la fricción ES la función; sin fricción no hay revisión |
| PR kilométrico con cinco features | Cerrarlo como «no revisable» y reabrir por partes; verificar que la causa sea ramas multi-issue del encuentro 28 |
