# z-analisis-pi-agent-glm53flash.md

> **PERSONAL — análisis externo del proyecto, NO vinculante.**
> Convención `z-*`: anotaciones personales del docente; no se corrigen con el estándar institucional.
>
> - **Fecha:** 2026-09-20
> - **Origen:** análisis solicitado a un agente de codificación (pi + gentle-ai, modelo GLM) sobre la raíz `z-planificaciones_en-General`.
> - **Alcance:** solo lectura. 52 archivos: biblioteca de plantillas en raíz, implementación `minimal-api-csharp/`, documentación de base `database-docs/`, validador `verificar-curso.ps1`.

---

## Qué es este proyecto

No es un proyecto de material docente: es un **meta-proyecto de ingeniería de prompts** para generar material docente. La raíz es una biblioteca de reglas (`0-prompt-plantilla-planificacion.md`, `estructura-anual-36.md`, `estructura-de-la-clase.md`, `encuentros-especiales.md`), y `minimal-api-csharp/` es la primera *implementación* de esa plantilla. `z-pdt-planificaciones.md` es el diario de las ~18 rondas de refinamiento que hicieron evolucionar el sistema, y `verificar-curso.ps1` es el validador de integridad.

## Lo que está muy bien

1. **La separación reglas fijas / datos particulares es el corazón del diseño, y está bien lograda.** Todo lo que cambia entre cursos vive en un solo bloque `[Datos particulares]`, con una versión en blanco para cursos nuevos. Es el patrón "código genérico + configuración" bien aplicado a prompts.
2. **La correlación en cascada es disciplina de arquitecto de software.** "La planificación anual es el documento madre, todo lo demás se deriva de ella; si algo cambia, primero el madre y después propagación en cascada" — es *single source of truth + artefactos derivados*, con regla anti-drift explícita. La regla de secuenciación de saberes (nada se usa antes de enseñarse, con verificación antes de cerrar) es la mejor del prompt: previene el error más común de los LLM generando material progresivo, que es asumir conocimientos no dados.
3. **La fundamentación pedagógica es real, no decorativa.** BOPPPS + GRR + Rosenshine están bien mapeados sección por sección en `estructura-de-la-clase.md`, y la tabla del README asocia cada decisión con su referencia (Sweller, Ausubel, Hattie). La decisión de poner Git *después* de la primera API corriendo (encuentro 4→5) está defendida con un argumento pedagógico genuino: la herramienta llega cuando ya hay algo que versionar.
4. **`verificar-curso.ps1` es la pieza más destacable.** Convierte las restricciones formales en checks ejecutables: BOM UTF-8 (para que Excel respete acentos), suma de Tiempo = 36, filas N/2N en libros de aula, límite de 35 caracteres por celda, links del README, anexos siempre separados y sin huérfanos. Además descubre cursos automáticamente. Es la *suite de tests* del material.
5. **Los frenos de fase (FRENO de Fase) + subagentes** muestran conciencia de que el trabajo es largo y de que hay que proteger el contexto. Es un flujo humano-en-el-bucle bien pensado.

## Correcciones y riesgos

1. **No es un repositorio git.** Es el riesgo operativo número uno, por encima de cualquier detalle de contenido. Hay `.gitignore` pero nunca se hizo `git init`. La propia regla de cascada hace que una corrección toque muchos archivos a la vez; sin versionado, una propagación mala es irrecuperable. Se arregla en dos minutos y es lo primero que conviene hacer.
2. **Riesgo de drift entre la plantilla y los documentos de referencia.** La plantilla carga `estructura-anual-36.md` por referencia (bien), pero *además* re-stata parte de esas reglas inline (encuentros especiales, tiempos, correlación). Donde un contenido existe en dos lugares, van a divergir. Recomendación: elegir un canon — o la plantilla solo referencia, o los documentos compañeros se declaran resúmenes no vinculantes. La convención `z-` ya marca lo personal/no vinculante (`z-modelos-zen.md`, `z-pdt-*`); extender esa idea: **cada regla vive en exactamente un archivo**.
3. **Cobertura en progreso — coherente, pero conviene hacerla visible.** Diseñados 36 encuentros; existen clases 4-8 (U1 completa con evaluaciones A/B) y clases 10-14 más evaluación U2 en versiones A/B (generadas al cierre de este análisis). Faltan: encuentros 1-3, unidades 3-4, especiales, continuidad pedagógica, instancias 16/33/36, criterios de aprobación. Es estado WIP legítimo (los frenos lo explican), pero `verificar-curso.ps1` podría también *reportar cobertura*: qué encuentros del 1-36 tienen documento y cuáles no. Hoy el script valida forma, no avance.
4. **Duplicación md/CSV sin chequeo cruzado.** Los libros de aula y la planificación anual existen en ambos formatos, y el script valida solo el CSV. Un check barato: que las filas del md coincidan con las del CSV (misma cantidad y mismos números de clase). Es exactamente el tipo de divergencia silenciosa que la regla de correlación quiere prevenir.
5. **Observación honesta sobre el recorte efectivo del 50%.** Decisión ya tomada por el docente; se respeta. Entre las tres variantes ("inflar tiempos", "actividad complementaria explícita", "rotar integrantes"), la de actividad complementaria explícita es la única defendible ante cualquier auditoría, porque no declara tiempos falsos. Si el sistema se usa algún día en un contexto con revisión formal, esa sería la variante preferida.

## Veredicto

**Muy bueno — arriba del estándar.** El diseño de la plantilla es ingeniería de prompts seria: canon único, derivación en cascada, frenos humanos, validación automatizada, fundamentación pedagógica citada. Las debilidades no son de diseño sino operativas: falta versionado, hay duplicación de reglas con riesgo de drift, y al validador le falta reportar cobertura y consistencia md/CSV.

## Próximos pasos sugeridos (en orden)

1. `git init` + commit inicial. *(ejecutado — ver nota al final)*
2. Extender `verificar-curso.ps1` con cobertura de encuentros y paridad md/CSV.
3. Decidir el canon único para las reglas que hoy viven en dos lugares.

---

## Nota de ejecución (2026-09-20)

- **Corrección 1 ejecutada (git):** `git init` (rama `main`) + commit inicial `53a13ff` con el estado completo del proyecto, incluido este documento.
- **Corrección 2 ejecutada (canon único / anti-drift):** la plantilla (`0-prompt-plantilla-planificacion.md`) ya no re-stata las reglas de los documentos compañeros. Se agregó la sección **[Canon de documentos — regla fija]** (cada regla tiene un único hogar; ante divergencia prevalece el documento canónico y se corrige la repetición en la plantilla) y se reescribieron por deferencia las secciones que duplicaban contenido: Fase 5, distribución del recurso tiempo, estructura de la planificación, evaluaciones (números 9/15/26/32 y criterios de especiales), encuentros especiales (momentos 2-3/17-18/19-20/34-35 y diciembre/marzo), instancias del ciclo (1/16/33/36) y continuidad pedagógica. La plantilla conserva flujo de trabajo, formatos administrativos y datos particulares. Verificado: 0 enumeraciones duplicadas restantes y `verificar-curso.ps1` en OK.
- **Corrección 3 ejecutada (cobertura + unificación de criterios):** `verificar-curso.ps1` sumó el chequeo 9, informativo y no bloqueante: cobertura de encuentros contra la estructura fija de `@estructura-anual-36.md` (clases regulares 4-8/10-14/21-25/27-31, evaluaciones dedicadas 9/15/26/32 → u1-u4, 6 momentos especiales). Durante su edición se detectó trabajo concurrente de otra ventana (chequeos 6-8: mojibake, título de cierre «Qué te llevás», tipos en records, tabla de deuda conocida y la hoja `minimal-api-csharp/convenciones-tecnicas.md` como fuente única de convenciones técnicas). Cerrada esa ventana, se unificaron criterios reparando la deuda declarada — cierre «Qué te llevás» en E10/E11 e ids `long` en records de clases 12, 13 y anexo 14 —, se vació la tabla de deuda del verificador y se actualizó la §7 de la hoja. Estado final verificado: `TODO OK`, 0 PENDIENTES, exit 0. Deuda restante declarada: `database-docs/03-modelos-csharp-dapper.md` (usa `int`/`DateOnly`; su reparación requiere reescribir la sección de helpers de fechas).
- **CodeGraph — resultado verificado:** la inicialización funciona (el requisito es que el workspace sea la raíz de un repositorio Git real; el commit inicial lo cumplió). Pero el índice encontró **0 archivos para indexar** y las consultas no devuelven resultados: es un indexador de *código fuente* (símbolos, referencias) y este proyecto es markdown/CSV/SQL/PowerShell, fuera de sus lenguajes soportados. Queda instalado y operativo para el día en que `minimal-api-csharp/` tenga los proyectos .NET de ejemplo; hasta entonces no aporta valor en esta raíz.
