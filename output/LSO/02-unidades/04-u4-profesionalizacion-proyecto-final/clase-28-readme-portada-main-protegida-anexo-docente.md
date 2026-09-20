# Anexo docente — Encuentro 28: README de portada y main protegida

---

## Preguntas guía para la apertura

1. "¿Alguna vez entraron a un repositorio en GitHub y no entendieron de qué se trataba?"
2. "¿Qué información esperan ver en la página principal de un proyecto open source?"
3. "¿Qué pasaría si alguien del grupo hiciera un push con código que rompe todo en main?"

---

## Resumen teórico para el pizarrón

- README.md: nombre, requisitos, instalación, estructura, tecnologías, integrantes.
- Protección de main: Settings > Branches > Add rule, PR requerido, 1 approval.
- Gitignore correcto: `bin/` y `obj/` desde el principio; si ya están trackeados se corrigen con `git rm --cached`.

---

## Ejemplo de README completo (para proyectar)

```markdown
# Hospital API

API REST Minimal con C# .NET 6 para gestionar pacientes, doctores y admisiones
de un hospital, utilizando SQLite y Dapper.

## Requisitos previos

- SDK .NET 6 o superior
- Git
- SQLite3 (incluido en la base hospital.db)

## Instalacion

git clone https://github.com/grupo/hospital-api
cd hospital-api
dotnet run

## Estructura del repositorio

- tp-u1/ — Minimal API GET
- tp-u2/ — SQLite y Dapper basico
- tp-u3/ — CRUD completo
- trabajo-final/ — API completa con Dapper

## Tecnologias

.NET 6, Minimal API, Dapper, SQLite, Git/GitHub

## Integrantes

- Ana Lopez
- Carlos Martinez
- Sofia Rodriguez
```

---

## Rúbrica de evaluación del ejercicio independiente

| Criterio | Logrado (2 pts) | En desarrollo (1 pt) | No logrado (0 pts) |
|---|---|---|---|
| README profesional completo | README con nombre, requisitos, instalación, estructura, tecnologías e integrantes | Falta una o dos secciones | README ausente o incompleto |
| Sección de pruebas agregada | README incluye endpoints curl de ejemplo | Sección presente pero incompleta | No hay sección de pruebas |
| `.gitignore` verificado | `.gitignore` presente con `bin/` y `obj/`, sin archivos trackeados de esas carpetas | Existe pero hay archivos trackeados | No hay `.gitignore` |
| Protección de main configurada | Regla activa, push directo falla | Regla creada pero no probada | No hay protección |
| PR mergeado | PR aprobado y mergeado | PR abierto sin merge | No se abrió PR |

---

## Solución del ejercicio independiente

El README debe incluir al final una sección adicional como:

```markdown
## Pruebas con Thunder Client

### Obtener todos los pacientes
GET http://localhost:5000/patients

### Obtener paciente por ID
GET http://localhost:5000/patients/1

### Crear paciente
POST http://localhost:5000/patients
Content-Type: application/json

{
  "firstName": "Juan",
  "lastName": "Perez",
  "gender": "M",
  "birthDate": "1990-05-15",
  "city": "Buenos Aires",
  "provinceId": 1,
  "allergies": null,
  "height": null,
  "weight": null
}

### Actualizar paciente
PUT http://localhost:5000/patients/1
Content-Type: application/json

{
  "firstName": "Juan",
  "lastName": "Perez",
  "allergies": "Penicilina"
}

### Eliminar paciente
DELETE http://localhost:5000/patients/1
```

---

## Notas para el docente

- Algunos grupos pueden tener problemas con la protección de main si el repositorio está en una organización de GitHub. Verificar que tengan permisos de administrador para modificar las reglas de ramas.
- Si un grupo no logra que el push a `main` falle, revisar en Settings > Branches que la regla esté aplicada al branch correcto y no tenga excepciones.
- Para grupos avanzados, sugerir que agreguen shields de badges al README (`![NET](https://img.shields.io/badge/.NET-6-blue)`) como elemento extra.
- Recordar que en el encuentro 31 se defiende el trabajo final. El README debe estar completo para esa fecha.