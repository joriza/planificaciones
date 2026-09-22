# Encuentro 8 — Cierre U1: repaso y TP

> Unidad 1 — Fundamentos de C# y Minimal API

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 8 de 36 |
| Unidad | 1 — Fundamentos de C# y Minimal API |
| Eje temático | 2 — Minimal API y endpoints HTTP |
| Carácter/Objetivo | Actitudinal |
| Estructura | cierre |
| Duración teórica | 240 minutos (4 horas reloj) |
| Uso de celular | No permitido |
| Concepto nuevo | Cierre U1: repaso y TP |
| Requisitos previos | Encuentros 4 a 7 de la Unidad 1 |
| Organización del trabajo | Grupos de 3-4 personas; un repositorio compartido por grupo para todo el curso; presentes ÷ equipos disponibles para recalcular el tamaño de los grupos |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y motivación | 20 min |
| Desarrollo teórico-práctico | 120 min |
| Consolidación y cierre | 20 min |
| Actividad complementaria | 80 min |
| **Total** | **240 min** |

## 2. Objetivos de aprendizaje

1. Repasar los conceptos clave de la Unidad 1: tipos de datos, estructuras de control, métodos, Minimal API y endpoints GET.
2. Ejecutar el TP-U1 completo: crear una Minimal API con al menos 3 endpoints GET funcionales.
3. Realizar el ciclo completo de Git/GitHub: init, add, commit, remote add, push.
4. Entregar el TP-U1 en GitHub con el mensaje de commit correcto.
5. Prepararse para la evaluación individual de la Unidad 1.

## 3. Apertura y motivación (20 min)

### Charla rápida: ¿Qué aprendimos en esta unidad?

Hemos recorrido un camino: desde entender qué es .NET y C#, hasta crear nuestros propios endpoints web con Minimal API. Cada encuentro construyó sobre el anterior. Hoy vamos a repasar todo y a entregar el trabajo práctico.

### Repaso rápido en grupos

Cada grupo responde en una hoja:

1. ¿Qué es .NET y qué rol cumple C#?
2. ¿Cuál es la diferencia entre `dotnet new console` y `dotnet new web`?
3. ¿Qué hace `app.MapGet`?
4. ¿Cuál es la diferencia entre un parámetro de ruta y un parámetro de query string?
5. ¿Qué es un commit en Git y por qué lo hacemos al final de cada encuentro?

Se comparten 3 respuestas al plenario.

## 4. Desarrollo teórico-práctico (120 min)

### 4.1 Repaso de conceptos clave (30 min)

El docente recorre los siguientes temas con ejemplos rápidos en el pizarrón:

- **Estructura de Program.cs:** `CreateBuilder` → `Build` → `MapGet` → `Run`.
- **Tipos de datos:** `string`, `int`, `long`, `bool`, `double`.
- **Condicionales:** `if`/`else if`/`else`.
- **Bucles:** `for`, `foreach`, `while`.
- **Métodos:** declaración con parámetros y retorno.
- **Endpoints GET:** con y sin parámetros de ruta, con query strings.

### 4.2 TP-U1: Minimal API GET (50 min)

El TP-U1 consiste en crear una Minimal API que cumpla con los siguientes requisitos:

1. **Endpoint `/`** — devuelve `{"mensaje":"API de la unidad 1"}`.
2. **Endpoint `/saludo/{nombre}`** — devuelve `{"saludo":"Hola, {nombre}!"}`.
3. **Endpoint `/suma/{a:double}/{b:double}`** — devuelve `{"resultado":a+b}`.
4. **Endpoint `/productos`** — devuelve una lista de al menos 3 productos como JSON.
5. **Endpoint `/productos/{id:long}`** — devuelve un producto por ID o `404` si no existe.

El código debe estar en un único archivo `Program.cs`, con comentarios en español (sin tildes ni eñes en el código) y records al final si se usan.

### 4.3 Repaso del ciclo Git/GitHub (20 min)

Este es el primer encuentro de entrega. Se enseña el ciclo completo de Git/GitHub:

```bash
# 1. Verificar que .gitignore esta en la raiz del repositorio
# El archivo .gitignore debe contener:
# bin/
# obj/

# 2. Inicializar el repositorio (solo la primera vez)
git init

# 3. Agregar todos los archivos
git add .

# 4. Hacer el commit con mensaje descriptivo
git commit -m "tp-u1: api minimal con endpoints get implementados"

# 5. Crear el repositorio en GitHub (desde la web de GitHub)
# No se hace desde la terminal; se crea en github.com

# 6. Agregar el repositorio remoto
git remote add origin https://github.com/usuario/nombre-repo.git

# 7. Subir el commit al repositorio remoto
git push -u origin main
```

**Reglas del repositorio:**
- Un repositorio por grupo para todo el curso.
- Carpeta `tp-u1/` para este trabajo práctico.
- Rama única `main`.
- Un commit al final de cada encuentro que referencie el progreso realizado.
- El mensaje del commit va en español, minúsculas después de los dos puntos, sin tildes.

### 4.4 Trabajo en grupo: completar y entregar el TP (20 min)

Cada grupo:
1. Verifica que su API tenga todos los endpoints requeridos.
2. Prueba cada endpoint en el navegador o con `curl`.
3. Hace el commit final del TP-U1 con el mensaje: `tp-u1: entrega final minimal api get`.
4. Sube el commit con `git push`.

## 5. Consolidación y cierre (20 min)

- Cada grupo muestra su API funcionando en el navegador.
- Se verifica que todos los grupos tengan el commit de entrega en GitHub.
- Se repasan los errores más frecuentes de la unidad.
- Se anuncia el Encuentro 9: Evaluación de la Unidad 1 (entrega y defensa individual).

## 6. Actividad complementaria (80 min)

### Preparación para la evaluación de la Unidad 1

La evaluación de la Unidad 1 será individual y constará de:
1. **Entrega del TP-U1** en GitHub (ya realizada en este encuentro).
2. **Defensa individual** en el próximo encuentro: cada alumno deberá explicar los conceptos clave de la unidad y demostrar que puede modificar un endpoint existente.

### Repaso con ejercicios de refuerzo

Los grupos que terminan la entrega del TP-U1 pueden trabajar en estos ejercicios de refuerzo:

1. **Agregar un endpoint `/productos/{id:long}/detalle`** que devuelva un objeto con el producto y un mensaje de descripción.
2. **Crear un endpoint `/suma` con query strings** en lugar de parámetros de ruta: `/suma?a=3&b=5`.
3. **Agregar validación** al endpoint `/saludo/{nombre}`: si el nombre está vacío, devolver `Results.BadRequest(new { mensaje = "El nombre no puede estar vacio" })`.

### Entrega final del TP-U1 en GitHub

Verificar que:
- El repositorio del grupo tiene la carpeta `tp-u1/`.
- El archivo `Program.cs` contiene todos los endpoints requeridos.
- El último commit tiene el mensaje de entrega.
- El `.gitignore` en la raíz contiene `bin/` y `obj/`.
- El commit se hizo en la rama `main`.

## 7. Cierre (15 min)

### Qué te llevás

- .NET es la plataforma y C# es el lenguaje para programar sobre ella.
- Una Minimal API se crea con `dotnet new web` y tiene `Program.cs` como archivo único.
- `MapGet` define endpoints que responden a solicitudes GET.
- Los parámetros de ruta se definen entre llaves en la URL; los de query string van después del `?`.
- Se puede filtrar datos en los endpoints usando parámetros de query string.
- El ciclo de Git/GitHub incluye: init, add, commit, remote add, push.
- El TP-U1 se entrega en GitHub con la carpeta `tp-u1/` y commits que referencien el progreso.

### Lo que viene

**Encuentro 9: Evaluación de la Unidad 1** — Entrega y defensa individual del TP-U1. Cada alumno deberá explicar los conceptos clave de la unidad y demostrar que puede modificar un endpoint existente.

## 8. Errores comunes y trampas

1. **No hacer `git init` antes de `git add`** — Sin inicializar el repositorio, los comandos de Git no funcionan. Verificar que exista la carpeta `.git` antes de hacer commit.
2. **Commitar archivos de `bin/` y `obj/`** — Estos archivos son generados por la compilación y no deben versionarse. Verificar que `.gitignore` en la raíz contenga `bin/` y `obj/`.
3. **Olvidar `git push` después del commit** — El commit local no se comparte con el equipo ni con el repositorio remoto. Siempre hacer `git push` al final de cada encuentro.
4. **Mensaje de commit con tildes** — Los mensajes de commit no llevan tildes ni eñes. Usar `e` o `ee` como reemplazo (ejemplo: `entrega`, no `entrega`).
5. **No crear la carpeta `tp-u1/`** — El TP debe estar en una carpeta específica dentro del repositorio del grupo. Verificar que la estructura sea `tp-u1/Program.cs`.
6. **Mezclar el repositorio del curso con el del TP** — Cada grupo tiene un solo repositorio para todo el curso. No crear repositorios separados para cada encuentro.
