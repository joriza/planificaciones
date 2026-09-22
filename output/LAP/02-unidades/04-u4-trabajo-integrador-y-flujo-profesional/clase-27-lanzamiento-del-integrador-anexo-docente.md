# Anexo docente — Encuentro 27: Lanzamiento del integrador

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

**Consigna:** Cada grupo completa su README de portada y sus 6 issues sin ayuda del docente.

**README esperado** (en la raíz del repositorio):

```markdown
# Verdulería — Sistema de venta

> Trabajo final integrador — Programación en Python

## Descripción

Programa de consola para gestionar productos, stock y ventas de una verdulería.
Permite registrar productos por nombre, precio y kilos disponibles; realizar ventas
con descuento de stock; y emitir una factura de la venta actual.

## Integrantes

- Ana López — README y documentación
- Bruno Díaz — Menú principal y navegación
- Carla Méndez — Registro de productos y stock
- Diego Paz — Control de ventas y factura

## Tecnologías

- Python 3
- Git + GitHub

## Cómo ejecutar

Abrí la terminal y ejecutá:

    python main.py

## Estado del proyecto

En desarrollo — Unidad 4

## Cómo contribuir

1. Cloná el repositorio: `git clone <url>`
2. Creá una rama: `git switch -c feature/<nombre>`
3. Hacé cambios y commit: `git add . && git commit -m "mensaje"`
4. Pusheá: `git push -u origin feature/<nombre>`
5. Abrí un Pull Request desde GitHub
```

**Issues esperados** (6 issues, todos con título, descripción, etiqueta y asignado):

| # | Título | Asignado | Descripción esperada |
| --- | --- | --- | --- |
| 1 | README de portada y documentación inicial | Quien redactó | Crear el README.md con descripción, integrantes, tecnologías, cómo ejecutar, estado y cómo contribuir. |
| 2 | Menú principal con navegación | Integrante A | Crear un menú interactivo con opciones numeradas en un bucle while hasta elegir Salir. |
| 3 | Registro de producto y stock | Integrante B | Función que pida nombre, precio y kilos; lo guarde en una lista de diccionarios. |
| 4 | Venta y control de stock | Integrante C | Función que descuente kilos del stock, valide existencia y precio, y acumule en factura. |
| 5 | Factura de la venta | Integrante D | Mostrar items vendidos con subtotal y total acumulado. |
| 6 | Protección de main y merge final | Todo el grupo | Configurar branch protection en GitHub y verificar que el programa funciona. |

## 2. Solución de la actividad de extensión

**README avanzado con badge y estructura:**

```markdown
![Python](https://img.shields.io/badge/python-3-blue.svg)

## Estructura del proyecto

tp-u1/
tp-u2/
tp-u3/
trabajo-final/
    main.py
    productos.py
    ventas.py
    factura.py
    README.md
```

**Issue adicional de mejora opcional** (ejemplo):

> **Título:** Validar que el precio ingresado sea mayor a cero
> **Descripción:** Agregar en `register_product()` una validación que verifique
> que `precio > 0` y `kilos > 0`. Si no, mostrar mensaje y volver a pedir.
> **Labels:** mejora, validación

**Plantilla de issue** (Settings → Issues → Set up templates):

```markdown
### Descripción
<!-- ¿Qué hay que hacer? -->

### Criterios de aceptación
- [ ] <!-- condición 1 -->
- [ ] <!-- condición 2 -->

### Asignado a
@usuario
```

## 3. Respuesta esperada del ejercicio

| Elemento | Esperado | Verificación |
| --- | --- | --- |
| README.md existe | Sí | `cat README.md` desde la raíz |
| README tiene título | "# Verdulería — Sistema de venta" | Primera línea del archivo |
| README tiene 6 secciones | Descripción, Integrantes, Tecnologías, Ejecución, Estado, Contribuir | Leer archivo |
| Hay 6 issues en GitHub | Al menos 6 | Pestaña Issues: contar |
| Cada issue tiene asignado | Un integrante distinto | Pestaña Issues: columna Assignee |
| Cada issue tiene descripción | Al menos 2 líneas | Abrir cada issue y leer |
| Cada integrante abrió un issue | 3-4 authors distintos | Pestaña Issues: columna Author |

## 4. Criterios de corrección (lista de verificación)

| ✔ | Criterio | Peso |
| --- | --- | --- |
| ☐ | README completo con 6 secciones | 30% |
| ☐ | 6 issues creados con título y descripción | 25% |
| ☐ | Cada integrante tiene al menos un issue asignado | 20% |
| ☐ | Los issues tienen etiquetas (labels) | 10% |
| ☐ | README versionado con `git add / commit / push` | 15% |

**Nota:** Si un integrante no participó (no abrió ningún issue ni aparece en el README), registrarlo en el acta del encuentro y conversar con el grupo antes del siguiente encuentro.

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| El README tiene solo el título | Piensan que es un trámite | Mostrar un README real de GitHub y preguntar: "¿Entrarías a un repo que no dice nada?" |
| Issues sin descripción | Creen que el título basta | Pedirles que lean un issue de otro grupo sin descripción: "¿Entendés qué hay que hacer?" |
| Todos los issues los creó la misma persona | Desequilibrio en el equipo | Asignar issues en voz alta: "Bruno, creá el issue del menú desde tu cuenta." |
| Issues duplicados | Falta de comunicación | Marcar los dos issues como duplicados y pedir que coordinen oralmente |
| Error de sintaxis Markdown | No conocen el formato | Mostrar hoja de referencia rápida: encabezados con #, listas con -, negrita con ** |
| README no versionado | Olvidan el ritual git | "¿Lo guardaron? Bien. Ahora `git add .`, `git commit -m '...'`, `git push`." |

## 6. Registro de la clase

**Por grupo, registrar:**

- [ ] README creado y versionado (s/n)
- [ ] Cantidad de issues abiertos: _____
- [ ] Cantidad de integrantes que abrieron al menos un issue: _____
- [ ] Integrantes ausentes: _____
- [ ] Grupo necesita refuerzo en Git: Sí / No
- [ ] Observaciones: _____

**Para la evaluación de proceso:**

- El README y los issues son el primer indicador de organización del grupo.
- Si un grupo no completó los 6 issues, es señal de que necesita más estructura: programar una reunión breve al inicio del Encuentro 28.
- Registrar qué integrante no participó: puede necesitar seguimiento individual.