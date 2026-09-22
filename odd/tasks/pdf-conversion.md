# Feature: pdf-conversion

## Goal

Implementar una herramienta determinista (PowerShell) que convierta todos los archivos markdown del corpus de una materia (`output/<m>/`) a PDF, usando una plantilla CSS compartida. Es una **acción manual del docente**, no parte del flujo de creación del material didáctico.

## Contexto

- El docente ya implementó conversión a PDF para otro proyecto en `d:\Desarrollo\z-material-didactico\README.md` §10, que usa pandoc + plantilla CSS.
- Este repositorio genera el corpus en output/ con estructura: 01-planificacion (CSV, no se convierte), 02-unidades (clases y evaluaciones), 03-encuadre-y-cierres, 04-intensificaciones, 05-continuidad, 06-aprobacion y README.md.
- Requisitos: misma plantilla CSS (reusable del otro proyecto), mejoras evaluadas, documentado en el README raíz, herramienta en tools/.

## Evaluación de alternativas

| Opción | Pros | Contras |
|--------|------|---------|
| **A) pandoc + CSS (recomendada)** | Maduro, mismo enfoque que z-material-didactico, CSS externo da control visual, produce PDF limpio | Requiere pandoc + LaTeX engine (MiKTeX/WSL) instalados en la máquina del docente; no es portable "cero dependencias" |
| **B) pandoc + wkhtmltopdf** | Menos dependencias pesadas (HTML intermedio), mantiene CSS | wkhtmltopdf está discontinued; calidad inferior a LaTeX |
| **C) Markdown Processor + PowerShell + MD2PDF nativo** | Portable, sin dependencias externas | Ninguna librería .NET da salida profesional; resultado tosco |
| **D) Script en Python con weasyprint** | CSS completo, produce PDF bonito | Requiere weasyprint (Cairo, complicado en Windows) |

**Elección:** A (pandoc + CSS), por ser el stack probado del docente. Se requiere pandoc + un backend LaTeX instalado (el docente ya lo tiene del otro proyecto o puede usar WSL).

## Mejoras evaluadas respecto a la referencia

1. **Por archivo (igual a la referencia)**: cada .md produce su PDF, listo para imprimir individualmente o distribuir.
2. **Combinado por unidad (mejora)**: pandoc puede concatenar varios markdown en un PDF único por carpeta (p. ej. todas las clases de 02-unidades/ en un solo PDF). Menos archivos, mejor para el docente — requiere decidir qué archivos se concatenan (ej. solo clase-*.md, sin evaluaciones). Se implementa como flag opcional `-Combinado`.
3. **Encabezado/pie automático**: pandoc con `--metadata` extrae el curso-data.json para incluir materia y encuentro en el header/footer del PDF.
4. **Tabla de contenidos en PDF combinado**: flag `--toc` de pandoc genera TOC para el PDF combinado.

## Propuesta de herramienta

`tools/convertir-a-pdf.ps1`

**Firma:**
`powershell -File tools/convertir-a-pdf.ps1 -Materia <nombre> [-Css <ruta>] [-Combinado] [-Salida <dir>]`

**Comportamiento:**
1. Escanea `output/<Materia>/` en busca de archivos .md (ignora README.md como índice, pero incluye el resto).
2. Para cada archivo (o por carpeta si -Combinado), ejecuta `pandoc <archivo>.md -f markdown -t pdf --css=<plantilla.css> -o <archivo>.pdf`.
3. Si -Combinado: pandoc recibe todos los .md de una subcarpeta como entrada concatenada → `unidad.pdf`.
4. Preserva la estructura de carpetas de output/ (los PDFs se generan junto a los .md fuente).
5. No se incluye en `verificar-curso.ps1` ni en el flujo de creación (acción manual).

**Dependencias requeridas:**
- pandoc (`pandoc --version`)
- LaTeX engine (MiKTeX: `xelatex --version`, o similar)
- Verificación al inicio del script (error claro si faltan)

## README

Se agrega a README.md → sección Herramientas (tools/) una fila para `convertir-a-pdf.ps1` que indique su uso y dependencias, y una sección breve en Convenciones operativas o como subsección de "Crear un curso nuevo": "Conversión a PDF (manual)".

## Verificación del plan
1. El documento existe con las secciones completas (Goal, Contexto, Evaluación, Mejoras, Propuesta, README).
2. No hay contradicciones: la herramienta es manual, no toca el flujo de creación.
3. La referencia cruzada al proyecto externo está (d:\Desarrollo\z-material-didactico\README.md §10).