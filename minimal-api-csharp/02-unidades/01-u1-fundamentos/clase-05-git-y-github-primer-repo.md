# Encuentro 5 — Git y GitHub: primer repo

> Unidad 1 — Fundamentos de C#, Git/GitHub y Minimal API

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 5 |
| Unidad | 1 — Fundamentos de C#, Git/GitHub y Minimal API |
| Duración teórica | 4 horas reloj (240 minutos) |
| Concepto nuevo | Control de versiones y ciclo completo de entrega |
| Requisitos previos | Clase 4 completada (proyecto `HospitalApi` funcionando). Cuenta de GitHub creada desde la web (se crea en este encuentro si falta) |
| Uso de celular | No permitido |
| Planificación anual | Encuentro 5: «Git y GitHub: primer repo» |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y puente | 30 min |
| Teoría mínima | 45 min |
| Práctica guiada | 90 min |
| Ejercicio independiente | 55 min |
| Puesta en común y cierre | 20 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

Al finalizar el encuentro, cada estudiante puede:

1. Explicar con palabras propias qué problema resuelve el control de versiones.
2. Configurar la identidad de Git en la máquina (`user.name` y `user.email`).
3. Iniciar un repositorio local con `git init` y un `.gitignore` apropiado para .NET.
4. Registrar cambios con `git add` y `git commit -m` usando un mensaje referente.
5. Publicar el repositorio en GitHub (`git remote add` + `git push`) y verificar el código en la web.

## 3. Teoría mínima (45 min)

### Charla rápida: la historia clínica del paciente

En un hospital, cada atención deja una nota en la historia clínica: fecha, qué se hizo, quién lo hizo. Nadie tira las notas anteriores: sin la historia completa, no se puede atender bien al paciente. El software funciona igual. Cada avance se registra con un **commit** (la nota) y el **repositorio** es la historia completa del proyecto. Perder la historia es, en la práctica, perder el proyecto. Hoy empezamos a llevar la historia clínica de nuestro código.

### Lo mínimo indispensable

- **Control de versiones (Git):** registra el historial de cambios del proyecto; permite volver atrás y trabajar sin miedo a romper lo que ya funciona.
- **Repositorio:** la carpeta del proyecto más su historial completo. Puede ser **local** (en la máquina) o **remoto** (en GitHub, la copia en la nube).
- **Commit:** una "foto" del proyecto en un momento dado, con un **mensaje referente** que explica qué se cerró.
- **`.gitignore`:** lista de archivos y carpetas que no se versionan. En .NET, `bin/` y `obj/` se generan al compilar y no se suben: se reconstruyen desde el código.
- **Ciclo completo de entrega:** configurar → iniciar repo → ignorar generados → `add` → `commit` → conectar remoto → `push`.

## 4. Práctica guiada (90 min)

### Paso 1 — Configurar la identidad de Git (una sola vez por máquina)

```powershell
git config --global user.name "Nombre Apellido"
git config --global user.email "email@ejemplo.com"
```

Verificar (cada comando debe mostrar lo cargado):

```powershell
git config --global user.name
git config --global user.email
```

### Paso 2 — Iniciar el repositorio local

Dentro de la carpeta del proyecto de la clase 4:

```powershell
cd HospitalApi
git init
```

Salida esperada:

```text
Initialized empty Git repository in .../HospitalApi/.git/
```

Nota: si la terminal indica que la rama se llama `master`, ejecutar `git branch -M main` para renombrarla a `main`.

### Paso 3 — Crear el archivo .gitignore

En VS Code, crear el archivo `.gitignore` en la raíz del proyecto (por ejemplo con `code .gitignore`) con este contenido:

```text
bin/
obj/
```

¿Por qué? `bin/` y `obj/` son carpetas que .NET genera al compilar: se pueden reconstruir en cualquier momento a partir del código, así que no se versionan.

### Paso 4 — Primer commit

```powershell
git add .
git commit -m "Primer proyecto Minimal API funcionando"
```

`git add .` prepara los cambios y `git commit` los registra con un mensaje referente. Salida esperada (resumida):

```text
[main (root-commit) 1a2b3c4] Primer proyecto Minimal API funcionando
 5 files changed, 45 insertions(+)
```

> **Regla de oro del curso:** un commit con mensaje referente al cierre de cada encuentro o de clase sin terminar.

### Paso 5 — Crear el repositorio remoto en GitHub (web)

1. Iniciar sesión en `github.com`.
2. Presionar **New repository**.
3. Nombre sugerido: `tp-hospital-<grupo>` (por ejemplo, `tp-hospital-grupo1`).
4. Dejar **sin marcar** la opción "Add a README file": un README inicial crea un commit en el remoto que choca con el primer push.
5. Confirmar con **Create repository** y no cerrar la página: muestra la URL que se usa en el paso siguiente.

### Paso 6 — Conectar y publicar

Reemplazar `<usuario>` y `<repo>` por los datos propios:

```powershell
git remote add origin https://github.com/<usuario>/<repo>.git
git push -u origin main
```

En el primer `push` puede abrirse una ventana del navegador pidiendo iniciar sesión en GitHub: es el gestor de credenciales de Git. Autorizar y volver a la terminal. Salida esperada (resumida):

```text
Enumerating objects: 5, done.
...
To https://github.com/<usuario>/<repo>.git
 * [new branch]      main -> main
```

### Paso 7 — Verificar en la web

Recargar la página del repositorio en GitHub: deben verse `Program.cs`, `.gitignore` y el archivo del proyecto, junto con el mensaje del primer commit. Si el código está en la web, el ciclo completo de entrega quedó cerrado.

## 5. Ejercicio independiente (55 min) — primera entrega de práctica

**Consigna.** Completar la primera entrega del curso:

1. Agregar a la API un endpoint `/estado` que responda el texto `en servicio`.
2. Probar en el navegador que responde.
3. Registrar y publicar el cambio:

```powershell
git add .
git commit -m "Endpoint de estado"
git push
```

**Pista.** La rutina completa ya está en la práctica guiada: el código del endpoint se copia de `MapGet` cambiando ruta y texto, y el ciclo de Git es siempre el mismo (`add` → `commit` → `push`); solo cambia el mensaje del commit.

## 6. Cierre

### Qué te llevás

- El ciclo completo de entrega: config → init → `.gitignore` → add → commit → remote → push.
- Un commit es una nota en la historia clínica del proyecto; el mensaje referente es lo que hace útil esa nota.
- `bin/` y `obj/` no se versionan: se reconstruyen desde el código.
- Con el `push`, el trabajo queda publicado en GitHub: esa es la evidencia de la entrega.

### Lo que viene

Con el proyecto ya versionado, en los próximos encuentros se sigue ampliando la API del hospital con más C#: el historial de Git permite avanzar sin miedo a romper lo que ya funciona.

## 7. Errores comunes y trampas

| Error o trampa | Causa | Fix |
| --- | --- | --- |
| El repositorio en GitHub muestra carpetas `bin/` y `obj/` | Se hizo el primer commit sin crear `.gitignore` | Crear `.gitignore` y volver a registrar con `git add .` y `git commit -m "Agregar .gitignore"`; la limpieza de lo ya subido se hace junto al docente |
| El commit no incluye los cambios | Se ejecutó `git commit` sin `git add` previo | Verificar con `git status`; si hay cambios sin preparar, ejecutar `git add .` y repetir el commit |
| El historial dice solo "cambios" | Mensaje genérico que no explica qué se cerró | Escribir mensajes que nombren el avance; corregir el último con `git commit --amend -m "nuevo mensaje"` |
| `git push` falla indicando que no hay repositorio | Falta el paso `git remote add` o la URL quedó mal copiada | Revisar con `git remote -v` y corregir con `git remote set-url origin <url-correcta>` |
| El commit falla pidiendo nombre o correo | La identidad de Git no está configurada en esa máquina | Ejecutar los dos comandos `git config --global` del Paso 1 y repetir el commit |
| El push inicial es rechazado | El repositorio remoto se creó con README y trae un commit propio | Borrar el repositorio en GitHub y recrearlo sin README; en este curso no se resuelven historias divergentes |
