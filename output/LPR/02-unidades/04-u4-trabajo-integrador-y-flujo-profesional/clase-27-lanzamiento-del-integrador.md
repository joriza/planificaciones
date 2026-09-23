# Encuentro 27 — Lanzamiento del integrador

> Trabajo integrador y flujo profesional

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 27 de 36 |
| Unidad | 4 — Trabajo integrador y flujo profesional |
| Eje temático | 4 — Trabajo integrador profesional |
| Carácter/Objetivo | Conceptual |
| Estructura | clase |
| Duración teórica | 120 minutos (2 horas reloj) |
| Concepto nuevo | Lanzamiento del integrador |
| Requisitos previos | Unidad 3 finalizada (procesamiento de texto y validación); Git instalado y verificado en el equipo; repositorio grupal creado en GitHub con las carpetas `tp-u1/`, `tp-u2/` y `tp-u3/` del trabajo del año. Cada integrante tiene su fork local clonado. |
| Uso de celular | No permitido |
| Organización del trabajo | Grupos de 3-4 integrantes (los mismos de la Unidad 3). Cada grupo trabaja sobre su repositorio compartido. Se recomienda que un integrante proyecte su pantalla durante la práctica guiada para que todo el grupo vea los pasos. |

### Reparto de tiempos teóricos

| Momento | Tiempo teórico |
| --- | --- |
| Apertura y puente | 10 min |
| Teoría mínima | 20 min |
| Práctica guiada | 35 min |
| Ejercicio independiente | 25 min |
| Extensión y consolidación | 20 min |
| Cierre | 10 min |
| **Total** | **120 min** |

## 2. Objetivos de aprendizaje

1. Redactar un README de portada del repositorio grupal que describa el trabajo final, los integrantes y las tecnologías usadas.
2. Descomponer el trabajo final en tareas concretas y crear issues en GitHub con asignación de responsables.
3. Distinguir entre un repositorio mono-rama (usado hasta ahora) y un repositorio profesional con issues y ramas.
4. Reconocer la consigna del trabajo final integrador como la síntesis de todos los núcleos del año.

## 3. Teoría mínima (20 min)

### Charla rápida: El repositorio como vidriera profesional

Imaginá que tu repositorio de GitHub es la vidriera de un negocio. Hasta ahora tuviste un taller en el fondo: código funcional pero sin cartel que diga qué se vende, sin plan de tareas a la vista y con una sola puerta. En la Unidad 4 convertís esa vidriera en profesional: un README que presente el proyecto al mundo, issues que muestren el plan de trabajo y ramas que aíslen cada mejora antes de mostrarla al público. No es más código; es mejor organización del código que ya sabés escribir.

### Lo mínimo indispensable

**README de portada.** Es el archivo `README.md` en la raíz del repositorio. GitHub lo muestra automáticamente cuando alguien visita el repo. Un README profesional incluye:

| Elemento | Descripción |
| --- | --- |
| Título del proyecto | Nombre del trabajo final (ej: "Verdulería — Sistema de venta") |
| Descripción breve | 2-3 líneas sobre qué hace el programa |
| Integrantes | Lista con nombres y rol tentativo |
| Tecnologías | Python 3, Git, GitHub |
| Cómo ejecutar | `python main.py` desde la terminal |
| Estado del proyecto | En desarrollo / Completado (para el final) |

**Issues como plan de trabajo.** Un issue en GitHub es una tarea con título, descripción, etiqueta y responsable. Para el trabajo final vas a crear un issue por cada módulo del programa, por ejemplo:

- #1 — README de portada y documentación inicial
- #2 — Menú principal con navegación por consola
- #3 — Registro de productos (nombre, precio, kilos en stock)
- #4 — Búsqueda de producto por nombre
- #5 — Control de venta con actualización de stock
- #6 — Gestión de factura por venta
- #7 — Protección de main y revisión final

**El trabajo final integrador.** Es un programa de consola en Python, dominio **verdulería**, que integra:

| Núcleo del año | Cómo se refleja en el integrador |
| --- | --- |
| Entrada validada | `read_int` y `read_float` con `try/except ValueError` para precio y kilos |
| Condicionales | Validar stock suficiente antes de vender, menú con `if/elif/else` |
| Bucles | `while True` para el loop del menú y para reintentar entradas inválidas |
| Funciones | Una función por operación: `show_menu`, `register_product`, `sell_product`, `show_invoice` |
| Colecciones | `list` de productos, `dict` para el producto individual (nombre, precio, kilos) |
| Menú en memoria | Toda la información vive en variables, nada se guarda en archivos |

## 4. Práctica guiada (35 min)

Vamos a crear el README de portada del repositorio del grupo y abrir los issues del plan de trabajo. El docente proyecta y cada grupo sigue los pasos en su propia máquina.

**Paso 1: Redactar el README.md en la rama main**

Desde la terminal, en la carpeta raíz del repositorio:

```bash
# Asegurate de estar en main y con los últimos cambios
git checkout main
git pull origin main

# Creá el README con un editor de texto o desde la terminal:
echo "# Verdulería — Sistema de venta

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
" > README.md
```

**Paso 2: Abrir issues desde la web de GitHub**

1. Entrá a github.com, abrí el repositorio del grupo.
2. Andá a la pestaña **Issues** → botón **New issue**.
3. Cada integrante crea al menos un issue siguiendo este modelo:

```
Título: [Módulo] Menú principal con navegación
Descripción:
  Crear un menú interactivo que muestre opciones numeradas:
  1. Registrar producto
  2. Vender producto
  3. Ver factura
  4. Salir
  El menú debe ejecutarse en un bucle hasta que el usuario elija Salir.
Asignado a: @BrunoDiaz
Labels: mejora, módulo
```

Crear los siguientes issues:
- #1 — README de portada (responsable: quien redactó)
- #2 — Menú principal
- #3 — Registro de producto
- #4 — Venta y control de stock
- #5 — Factura de la venta
- #6 — Protección de main y merge final

**Paso 3: Verificar que los issues se ven en el repositorio**

Volvé a la pestaña **Code** del repositorio: ahora el README se muestra en la página principal. Los issues deberían estar visibles en la pestaña Issues. ¡Ya tenés un repositorio profesional!

## 5. Ejercicio independiente (25 min)

**Consigna:** Cada grupo completa su README de portada y sus issues sin ayuda del docente. Usen el modelo de la práctica guiada pero personalicen:

1. **README:** agreguen una sección "Estado del proyecto" donde diga "En desarrollo — Unidad 4" y una sección "Cómo contribuir" que enumere los pasos: clonar, crear rama, abrir PR.
2. **Issues:** revisen los 6 issues creados y agreguen etiquetas de prioridad (alta/media/baja) y una descripción más detallada. Cada issue debe tener al menos una tarea concreta en su descripción.

**Pista:** Para editar el README después de crearlo, podés usar `echo "Nueva línea" >> README.md` para agregar contenido al final, o abrirlo en VS Code y editarlo directamente.

**Solución esperada:** Un README con 6 secciones completas y 6 issues con título, descripción, etiqueta y asignado. El docente verificará que cada integrante tenga al menos un issue asignado.

## 6. Extensión y consolidación (20 min)

**Para los grupos que terminaron:** sigan estos pasos para profundizar:

1. **README avanzado:** agreguen un badge de "Python 3" usando shields.io. Busquen en Google "shields.io python badge" y copien el Markdown. También pueden agregar una tabla con la estructura del proyecto:

   ```
   tp-u1/
   tp-u2/
   tp-u3/
   trabajo-final/
       main.py
       README.md
   ```

2. **Issue adicional:** creen un issue de mejora opcional que no esté en la lista base, por ejemplo: "Validar que el precio ingresado sea mayor a cero" o "Mostrar fecha y hora en la factura".
3. **Plantilla de issue:** andá a Settings → Issues → Set up templates y creá una plantilla simple para los próximos issues del grupo.

## 7. Cierre (10 min)

### Qué te llevás

- El README de portada es la cara de tu repositorio: sin él, el proyecto parece abandonado.
- Los issues son el plan de trabajo visible: todo el grupo sabe qué hay que hacer y quién lo hace.
- El trabajo final integrador no es código nuevo: es juntar todo lo que ya sabés en un solo programa con dominio verdulería.
- Un repositorio profesional se ve distinto a uno de práctica: tiene README, issues, y pronto ramas y PRs.

### Lo que viene

En el **Encuentro 28** vas a aprender a trabajar con **ramas por feature y pull requests**: cada issue se resuelve en su propia rama, se revisa entre pares y se fusiona con main protegida. Vas a distribuir las responsabilidades del grupo por issue y a experimentar el flujo real de un equipo de desarrollo.

## 8. Errores comunes y trampas

1. **README vacío o con solo el título.** *Causa:* creer que el README es un trámite. *Fix:* mostrar ejemplos de READMEs reales de proyectos chicos en GitHub y explicar que es lo primero que ve un reclutador.

2. **Issues sin descripción o sin asignado.** *Causa:* pensar que el título alcanza. *Fix:* establecer la regla del grupo: "sin descripción no se abre el issue". Usar la plantilla de la práctica guiada.

3. **Un solo integrante crea todos los issues.** *Causa:* el que sabe Git hace todo. *Fix:* cada integrante debe abrir al menos un issue desde su cuenta de GitHub.

4. **Issues duplicados.** *Causa:* dos integrantes crean el mismo issue sin comunicarse. *Fix:* antes de crear, revisar los issues existentes y coordinarse en voz alta.

5. **README con errores de Markdown.** *Causa:* no conocer la sintaxis (encabezados con `#`, listas con `-`). *Fix:* mostrar una referencia rápida de Markdown y verificar con la vista previa de GitHub antes de cerrar el archivo.

6. **El README se edita pero no se versiona.** *Causa:* el grupo edita el archivo pero olvida `git add` y `git commit`. *Fix:* recordar el ritual: editar → `git add .` → `git commit -m "README: portada inicial"` → `git push`.
