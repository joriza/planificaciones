# Anexo docente — Encuentro 5: Git y GitHub: primer repo

> Documento de uso docente. No se distribuye a estudiantes.

## Solución esperada de la primera entrega

Endpoint en `Program.cs`:

```csharp
app.MapGet("/estado", () => "en servicio");
```

Comandos de la entrega (desde la carpeta del proyecto):

```powershell
git add .
git commit -m "Endpoint de estado"
git push
```

La entrega se valida desde la web: el repositorio en GitHub debe mostrar el endpoint en `Program.cs` y «Endpoint de estado» como último commit de la rama `main`.

## Checklist del ciclo completo de entrega

- [ ] **Config:** `git config --global user.name` y `user.email` cargados y verificados.
- [ ] **Init:** `git init` ejecutado dentro de la carpeta del proyecto; rama `main` (renombrar con `git branch -M main` si corresponde).
- [ ] **Gitignore:** `.gitignore` en la raíz con `bin/` y `obj/` creado antes del primer commit.
- [ ] **Add:** `git add .` sin archivos generados en escena (verificar con `git status`).
- [ ] **Commit:** mensaje referente, no genérico.
- [ ] **Remote:** `git remote -v` muestra la URL correcta del repositorio del grupo.
- [ ] **Push:** rama `main` publicada y código visible en la web de GitHub.

## Criterios de logro mínimos del encuentro

- [ ] Repositorio local iniciado y con al menos dos commits con mensajes referentes.
- [ ] Repositorio remoto en GitHub con nombre del tipo `tp-hospital-<grupo>`, sin carpetas `bin/` ni `obj/` versionadas.
- [ ] Endpoint `/estado` funcionando y publicado (visible en GitHub).
- [ ] Push final realizado por los propios estudiantes, no por el docente.

## Qué observar durante la práctica

- **Credenciales:** los grupos que quedan fuera por identidad de Git sin configurar o por sesión de GitHub no iniciada en el navegador; suelen bloquearse en el Paso 6.
- **Nombres de repositorio:** repos creados fuera de la convención `tp-hospital-<grupo>`, con mayúsculas, espacios o nombres personales; corregirlo temprano evita problemas de corrección posterior.
- **README inicial:** detectar antes del push qué grupos crearon el repositorio remoto con README; recrearlo en ese momento es barato, después ya no.
- **Autonomía:** distinguir los grupos que repiten el ciclo `add`/`commit`/`push` por su cuenta de los que esperan la orden del docente; los segundos necesitan refuerzo del ciclo, no Git avanzado.

## Registro de la primera entrega (seguimiento)

Completar al cierre del encuentro. Esta tabla es la línea de base del seguimiento de entregas de la unidad.

| Grupo | Usuario de GitHub | URL del repositorio | Último commit recibido | Observaciones |
| --- | --- | --- | --- | --- |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |

> Criterio de cierre de la primera entrega: fila completa y repositorio accesible en la web. Si un grupo no llega al push, registrar el estado exacto (config, init o commit pendiente) para retomar en el encuentro siguiente.
