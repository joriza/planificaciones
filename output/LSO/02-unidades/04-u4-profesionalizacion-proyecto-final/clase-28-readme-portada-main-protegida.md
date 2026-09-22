# Encuentro 28 — README de portada y main protegida

**Unidad 4:** Profesionalización y proyecto final
**Carácter:** Procedimental
**Duración:** 240 minutos

---

## Objetivos de aprendizaje

- Redactar un README.md profesional con secciones completas.
- Configurar reglas de protección de la rama `main` en GitHub.
- Integrar el README al repositorio grupal mediante Pull Request.
- Verificar que el `.gitignore` excluye `bin/` y `obj/`.

---

## Reparto de tiempos (240 minutos)

| Bloque | Minutos |
|---|---|
| Apertura y motivación | 20 |
| Desarrollo teórico-práctico | 120 |
| Consolidación y cierre | 20 |
| Actividad complementaria / trabajo final | 80 |
| **Total** | **240** |

---

## Teoría mínima

### README como portada del proyecto

El README.md es la primera página que ve cualquier persona al entrar al repositorio. Un README profesional de un proyecto académico contiene:

1. **Nombre del proyecto** y descripción breve (una línea).
2. **Tabla de contenidos** (opcional en proyectos pequeños).
3. **Requisitos previos:** SDK .NET 6, SQLite, Git.
4. **Instalación:** clonar, restaurar paquetes, ejecutar.
5. **Estructura del repositorio:** qué hay en cada carpeta.
6. **Tecnologías usadas:** .NET 6, Dapper, SQLite.
7. **Integrantes del grupo.**
8. **Licencia** (opcional, pueden usar MIT).

### Protección de main en GitHub

La rama `main` se protege desde GitHub:

1. Ir a Settings > Branches > Add branch protection rule.
2. En "Branch name pattern": `main`.
3. Marcar "Require a pull request before merging".
4. Marcar "Require approvals" (al menos 1).
5. Marcar "Dismiss stale pull request approvals when new commits are pushed".
6. Marcar "Do not allow bypassing the above settings".
7. Guardar.

Desde ese momento, ningún integrante puede pushear directamente a `main`. Todo cambio debe entrar por PR con al menos una aprobación.

### Gitignore verificado

El archivo `.gitignore` en la raíz del repositorio debe contener al menos:

```
bin/
obj/
```

Si algún grupo omitió este archivo en los primeros commits, se agrega ahora y se eliminan `bin/` y `obj/` del tracking con:

```bash
git rm -r --cached bin/ obj/
git add .gitignore
git commit -m "gitignore: excluir bin y obj del repositorio"
```

---

## Práctica guiada

### Paso 1: Redactar el README.md

Cada grupo, desde su rama `feature/readme-portada` (creada en el encuentro 27), completa el README.md con el siguiente esquema:

```markdown
# Nombre del proyecto

Breve descripción del proyecto (un párrafo).

## Requisitos previos

- SDK .NET 6 o superior
- SQLite3
- Git

## Instalacion

1. Clonar el repositorio:
   ```bash
   git clone <url-del-repo>
   cd <nombre-del-repo>
   ```
2. Ejecutar la API:
   ```bash
   dotnet run
   ```

## Estructura del repositorio

```
tp-u1/          — Minimal API GET
tp-u2/          — SQLite y Dapper basico
tp-u3/          — CRUD completo
trabajo-final/  — Trabajo final integrador
```

## Tecnologias

- .NET 6 + Minimal API
- Dapper (micro-ORM)
- SQLite
- Git + GitHub

## Integrantes

- [Nombre Apellido]
- [Nombre Apellido]
- [Nombre Apellido]
```

### Paso 2: Configurar la proteccion de main

El docente proyecta la configuración y cada grupo la replica en su repositorio:

1. GitHub > Settings > Branches > Add rule.
2. Branch name pattern: `main`.
3. Habilitar "Require a pull request before merging".
4. "Required approvals": 1.
5. Guardar.

### Paso 3: Verificar que main esta protegida

Cada grupo intenta pushear un cambio mínimo directo a `main`:

```bash
git checkout main
echo "# Prueba" >> README.md
git add README.md
git commit -m "main: prueba de proteccion"
git push origin main
```

El push debe fallar con un mensaje similar a:

```
remote: error: GH006: Protected branch update failed for refs/heads/main.
```

Esa es la confirmación de que la protección funciona.

### Paso 4: Subir cambios por PR

Los cambios reales del README se suben desde `feature/readme-portada`:

```bash
git checkout feature/readme-portada
# completar el README.md con el contenido del Paso 1
git add README.md
git commit -m "readme: portada completa del repositorio"
git push origin feature/readme-portada
```

Se abre un Pull Request hacia `main`, se asigna revisor, se aprueba y se mergea.

---

## Ejercicio independiente

Continuando con el trabajo final en `trabajo-final/`:

1. Verificar que el repositorio tenga `.gitignore` con `bin/` y `obj/`. Si no, agregarlo y eliminar del tracking.
2. Redactar una sección adicional en el README: "Instrucciones para probar la API con Thunder Client", con ejemplos de endpoints GET, POST, PUT y DELETE.
3. Abrir una rama `feature/reader-testing`, commitear el README actualizado y abrir un PR.
4. Solicitar revisión y mergear.

**Pista:** la sección de prueba puede incluir comandos curl como:

```
curl http://localhost:5000/patients

curl -X POST http://localhost:5000/patients \
  -H "Content-Type: application/json" \
  -d '{"firstName":"Juan","lastName":"Perez","gender":"M","birthDate":"1990-05-15"}'
```

**Solución esperada:** README completo con sección de pruebas, PR mergeado y main protegida verificada.

---

### Qué te llevás

- El README profesional es la tarjeta de presentación del proyecto.
- La protección de `main` fuerza que todo cambio pase por revisión, manteniendo la rama principal siempre estable.

### Lo que viene

En el Encuentro 29 se consolida el CRUD completo con JOINs y se agrega un endpoint de conteo avanzado: el trabajo final empieza a tomar forma definitiva.

## Errores comunes y trampas

| Error | Causa | Solución |
|---|---|---|
| README vacío o con solo el nombre | Se escribió lo mínimo para cumplir | Seguir la plantilla del paso 1; completar integrantes, requisitos y estructura. |
| Push directo a main no falla | No se configuró la protección en GitHub | Verificar Settings > Branches > Add rule; la regla debe estar activa. |
| `.gitignore` no funciona en archivos ya trackeados | Git ya tiene `bin/` y `obj/` bajo control de versiones | Usar `git rm --cached` para dejar de trackearlos sin borrarlos del disco. |
| PR sin descripción concreta | Se mergea rápido sin documentar qué cambia | Agregar descripción breve al PR, vinculando el issue si existe. |
| Markdown del README no se renderiza | Error de sintaxis (espacios, tildes en identificadores) | Usar https://markdownlivepreview.com para verificar antes de pushear. |