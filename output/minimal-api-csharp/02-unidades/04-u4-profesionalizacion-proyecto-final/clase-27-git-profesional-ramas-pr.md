# Encuentro 27 — Git profesional: ramas y PR

**Unidad 4:** Profesionalización y proyecto final
**Carácter:** Procedimental
**Duración:** 240 minutos

---

## Objetivos de aprendizaje

- Crear issues en GitHub para organizar el trabajo del grupo.
- Abrir ramas `feature/<tema>` a partir de un issue.
- Realizar Pull Requests con revisión entre pares.
- Integrar los trabajos anteriores en un repositorio único por grupo.

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

Hasta la Unidad 3, cada grupo trabajó en un repositorio con una sola rama (`main`) y una carpeta por trabajo práctico. A partir de ahora, el flujo de trabajo se profesionaliza: se usan ramas por feature, pull requests con revisión y la rama `main` protegida.

### El repositorio único del grupo

Cada grupo mantiene **un solo repositorio** con esta estructura:

```
nombre-del-repo/
├── tp-u1/
├── tp-u2/
├── tp-u3/
├── trabajo-final/
├── .gitignore       (bin/, obj/)
└── README.md        (se crea en el encuentro 28)
```

### Issues como entrada de trabajo

Un issue es una tarea o bug registrado en GitHub. Sirve para:

- Asignar responsabilidades entre los integrantes del grupo.
- Llevar un hilo de discusión antes de escribir código.
- Vincularlo con un Pull Request para que se cierre automáticamente.

### Ramas por feature

Cada cambio significativo se desarrolla en una rama separada:

```bash
git checkout -b feature/readme-portada    # desde main
```

Convención de nombres: `feature/<tema>` en inglés y con guiones. Algunos ejemplos para la unidad:

- `feature/readme-portada`
- `feature/endpoint-conteo`
- `feature/filtros-adicionales`

### Pull Request con revisión

Una vez terminado el trabajo en la rama:

1. Se sube la rama: `git push origin feature/readme-portada`
2. Se abre un Pull Request en GitHub desde la rama hacia `main`.
3. Otro integrante del grupo revisa el código y aprueba o solicita cambios.
4. Se fusiona (merge) y se elimina la rama remota.

### Main protegida

La rama `main` se protege con reglas en GitHub:

- No se permite pushear directo a `main`.
- Todo cambio entra por Pull Request.
- Se requiere al menos una aprobación antes de mergear.

---

## Práctica guiada

### Paso 1: Organizar el repositorio grupal

Cada grupo verifica que su repositorio tenga las carpetas `tp-u1/`, `tp-u2/`, `tp-u3/` y `trabajo-final/` en `main`. Si falta alguna, se crea desde `main`:

```bash
git checkout main
git pull origin main
mkdir -p trabajo-final
```

### Paso 2: Crear un issue de ejemplo

En GitHub, cada grupo crea un issue con el título "Agregar README de portada al repositorio". El cuerpo describe qué debe contener el README: nombre del proyecto, integrantes, tecnologías usadas, instrucciones de ejecución.

### Paso 3: Abrir una rama feature desde el issue

Desde GitHub, se convierte el issue en rama usando el enlace "Create a branch" dentro del issue. El nombre sugerido es `feature/readme-portada`. También se puede crear desde la terminal:

```bash
git checkout main
git pull origin main
git checkout -b feature/readme-portada
```

### Paso 4: Simular un cambio y abrir PR

Cada grupo agrega un archivo `README.md` con el título del proyecto y los integrantes (se completará en el encuentro 28). Luego:

```bash
git add README.md
git commit -m "readme: agregar portada inicial del repositorio"
git push origin feature/readme-portada
```

En GitHub, se abre un Pull Request desde `feature/readme-portada` hacia `main`. Se asigna a otro integrante para revisión.

### Paso 5: Revisar y mergear

El revisor agrega un comentario aprobando o pidiendo cambios. Luego de la aprobación, se mergea el PR y se elimina la rama remota.

---

## Ejercicio independiente

Tomando como base el trabajo final que cada grupo está desarrollando (carpeta `trabajo-final/`):

1. Crear un issue en GitHub titulado "Agregar endpoint que devuelva cantidad de pacientes por provincia".
2. Abrir una rama `feature/pacientes-por-provincia` desde `main`.
3. Implementar el endpoint de conteo (puede ser un bosquejo, se completa en encuentros siguientes).
4. Subir la rama y abrir un Pull Request.
5. Solicitar revisión a un compañero.

**Pista:** el endpoint puede ser tan simple como:

```csharp
app.MapGet("/patients/count-by-province", () =>
{
    using var connection = new SqliteConnection(connectionString);
    var result = connection.Query(@"
        SELECT p.province_id AS ProvinceId,
               p.province_name AS ProvinceName,
               COUNT(pa.patient_id) AS PatientCount
        FROM province_names p
        LEFT JOIN patients pa ON pa.province_id = p.province_id
        GROUP BY p.province_id, p.province_name
    ").ToList();
    return Results.Ok(result);
});
```

**Solución esperada:** un PR aprobado y mergeado, con el endpoint integrado en la rama `main`.

---

## Cierre

**Qué te llevás:** el flujo profesional de Git (issues, ramas feature, PR, revisión y main protegida) protocoliza el trabajo en equipo y evita conflictos. Cada cambio queda registrado con un issue que lo originó y una revisión que lo aprobó.

**Lo que viene:** en el próximo encuentro completaremos el README de portada, configuraremos la protección de `main` en GitHub y dejaremos el repositorio listo para la entrega final.

---

## Errores comunes y trampas

| Error | Causa | Solución |
|---|---|---|
| Pushear directo a `main` | Se protegió main pero se sigue usando `git push origin main` | Crear rama feature y abrir PR; si el push falla, la protección ya funciona. |
| PR sin descripción | El Pull Request se abre con título genérico "Update main" | Vincular el PR al issue correspondiente y describir qué cambia. |
| Rama que no se elimina tras el merge | Se mergeó pero queda la rama local | `git branch -d feature/readme-portada` y `git push origin --delete feature/readme-portada`. |
| Conflictos al mergear | Dos integrantes modificaron el mismo archivo en ramas distintas | Resolver el conflicto en GitHub o localmente, revisando qué cambios conservar. |
| Olvidar `.gitignore` en la raíz | `bin/` y `obj/` se suben al repositorio | Agregar `.gitignore` desde el primer commit: `bin/` y `obj/` en líneas separadas. |