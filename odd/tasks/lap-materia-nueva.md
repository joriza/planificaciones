# Feature: lap-materia-nueva

> **ESTADO: CANCELADA por el docente (2026-09-21) tras el freno de Fase 0.** No se ejecutaron Fases 1-4. Los artefactos de Fase 0 quedan en el working tree SIN commitear (curso-data.json validado, convenciones-tecnicas.md, digest-codigo.md, canon compartido genericizado, parche de generar-readme.ps1). Decisiones quedadas sin resolver: parche de escala mayor-resto, tabla-dominio LAP, work-unit commit. Para reanudar: retomar desde este documento y el freno de Fase 0.

## Goal

Ejecutar `prompt-plantilla-planificacion.md` para la materia LAP (Programación en Python) en modo **materia nueva** (no existe `input/materias/LAP/curso-data.json`), hasta el freno por defecto del modo: pausa tras el curso-data validado para revisión del docente.

## Contexto

- Orden vigente del docente (`z-pdt-planificaciones.md` §Indicaciones de ejecución): ejecutar el prompt plantilla para LAP; modo y frenos derivados del canon (materia nueva → pausa tras curso-data validado); sin consultar memoria; autonomía para lo mecánico; consultar antes de tocar contenido pedagógico irreducible; reporte final de toda modificación fuera del flujo canónico.
- Datos de la materia: `input/materias/LAP/materia.md` (Python desde cero, imperativo con funciones, 2 h/encuentro, escuela técnica, sin BD/archivos/persistencia, GitHub por grupo con profesionalización en U4), `pedido.md` (libro ≤35 chars, 4 continuidades, sin frenos adicionales), `nota-catedra.md`.
- Decisión del docente (consulta 2026, opción elegida «Genericizar el banco compartido»): los insumos compartidos de `input/plantillas/` con vocabulario específico de LSO se reescriben como textos neutros. El corpus vigente de LSO NO se toca; su futura regeneración saldrá genérica y deberá re-validarse (deriva conocida, registrada aquí).
- Única extensión de herramienta autorizada por esa decisión: `generar-readme.ps1` gana `cargaHoraria` paramétrica vía slot opcional `slots.horasPorEncuentro` (sin slot → texto actual de 4 h; LSO no lo define → byte-idéntico).

## Tasks

- [x] T1: Genericizar el canon compartido — `tramos-invariantes.json` (33 sustituciones ×3 variantes), `libro-filas-invariantes.json` (4), `readme-plantilla.md` (3) — writer delegado, verificado con diff propio + grep (0 coincidencias LSO) + JSON parse (12 tramos, 16 filas). `generar-readme.ps1` (cargaHoraria paramétrica) — worker 3 en curso (verificación A/B LSO).
- [x] T2: Fase 0 — `input/materias/LAP/curso-data.json` redactado y validado (`validar-curso-data.ps1` OK). Secuenciación verificada: operadores aritméticos movidos a E4 (uso en E7), quitada insinuación de EOF (sin archivos). Git: sin git E4-E7; ciclo completo E8 con primer TP; flujo profesional U4. Smoke render a temp OK (16 filas anual, 36/72 libro, escala 2 h).
- [ ] T3: Fase 0 — spike ejecutado (3 corridas Python 3.11, evidencias en la hoja); convenciones + digest delegados a worker 2 (en curso).
- [ ] T4: Validación final, freno y reporte. Hallazgo para el freno: la escala `-HorasPorEncuentro 2` infla +5 min las cajas impares (45→25, 15→10, AwayFromZero a múltiplos de 5): secuencias escaladas suman 125 ≠ 120 en encuadre, previos, cierres c1/c2 y secuencia fija de unidades. Propuesta: parche de escala por mayor-resto en `Convert-EscalaMinutos` (factor 1 no toca nada: LSO intacta). Pendiente de decisión del docente.

## Evidencia

- T1 (2026-09-21): worker genericizó tramos (33 sustituciones ×3 variantes), filas de libro (4) y readme-plantilla (3); verificación propia: grep LSO-specific = 0 coincidencias, JSON parse ok (12 tramos/16 filas), slots {{celular}}/{{tp.uX}} intactos, sin BOM. Parche `generar-readme.ps1` (cargaHoraria por `slots.horasPorEncuentro`, 9 líneas): verificación A/B del worker con hash idéntico `598eddf1…` para LSO; bloque confirmado por lectura propia.
- T2 (2026-09-21): `validar-curso-data.ps1 -Materia input/materias/LAP` → OK (20 encuentros, slots completos, celdas ≤35). Smoke render a temp (`-HorasPorEncuentro 2`): 16 filas anual, 36/72 libros, tramos genéricos + unidades compuestas desde el JSON.
- T3 (2026-09-21): spike 3 corridas Python 3.11 (conversiones/ValueError, / vs //, mutabilidad str/tuple, append/sort→None, sorted, index, pop, slicing tolerante, KeyError/.get, split/strip/join/replace, f-strings, ámbito/NameError, return None, `__name__`). Ejemplo canónico de la hoja compilado y ejecutado (ruta feliz + reintento). Hoja: 9 secciones, sin BD (secciones 4/5/6 adaptadas a tipos canónicos, E/S en memoria y validación). Digest Python junto a la materia.
- T4 (2026-09-21): FRENO del modo materia nueva aplicado tras el curso-data validado. Pendientes de decisión: escala +5 min (propuesta: mayor-resto en Convert-EscalaMinutos), tabla-dominio LAP en Fase 3, work-unit commit sin autorización explícita aún.

## Pendientes y deriva registrada

- `output/LSO/01-planificacion/*.csv` queda derivado de las plantillas PRE-genericización: la próxima regeneración de LSO cambiará los tramos genericizados y deberá re-validarse (aceptado por el docente al elegir la opción).
- `input/materias/LSO/curso-data.json` no declara `contenido` ni `actividadesAnual` por encuentro (campos que usan los generadores actuales): regeneración completa de LSO requerirá completarlos (deriva preexistente, no introducida por esta feature).
- Fases 1-4 de LAP (administrativos, prosa, evaluaciones, cierre) quedan pendientes del freno de Fase 0.
- `input/plantillas/tabla-dominio.json` es LSO-specific (tokens de dominio para `generar-version-b.ps1`): en Fase 3 se agregan dominios propios de LAP bajo `dominios` (mecanismo previsto por el propio archivo). `readme-descripciones.json` y `esqueletos-unidad.json` ya son genéricos (verificado).
