# Corrida completa LPR (Programación en Python)

**Origen**: orden del docente — "ejecute prompt maestro para materia LPR" + PDFs consolidados.
**Modo derivado**: curso-data vigente en `input/materias/LPR/` + sin `output/LPR/` → **regeneración completa, corrida continua** (pedido.md declara: frenos ninguno).
**Estado**: ✅ COMPLETO — corrida en verde (verificar TODO OK, lint 0 errores/9 avisos baseline).

## Contexto de la materia

- Python imperativo desde cero, sin POO, sin persistencia, sin BD (todo en memoria).
- 2 horas por encuentro (50% efectivo) → `-HorasPorEncuentro 2` obligatorio en administrativos y lint.
- Escuela técnica: E1 incluye seguridad e higiene y EPP.
- Git/GitHub: un repo único por grupo, mono-rama hasta U4 (profesionaliza con PR/issues).
- Continuidad: 4 documentos (inicio + tras eval U1, U2, U3).
- Convenciones: `input/materias/LPR/convenciones-tecnicas.md` (leer antes de generar código).

## Tasks

- [x] Rama de seguridad `regen/lpr` creada
- [x] Fase 1: administrativos CSV render determinista (`generar-administrativos.ps1 -HorasPorEncuentro 2`)
- [x] Fase 2: unidades 1-4 (`02-unidades/`, E4-8, 10-14, 21-25, 27-31, con anexos docente)
- [x] Fase 2: encuadre y cierres (`03-encuadre-y-cierres/`, E1, 16, 33, 36)
- [x] Fase 2: intensificaciones (`04-intensificaciones/`, 6 momentos: 2-3, 17-18, 19-20, 34-35, diciembre, marzo)
- [x] Fase 2: continuidad (`05-continuidad/`, 4 documentos)
- [x] Fase 3: evaluaciones (4 de unidad + 6 de momento, versiones A/B con anexos docente)
- [x] Fase 4: criterios-aprobacion.md
- [x] Fase 4: README del curso (`generar-readme.ps1`, 117 documentos indexados)
- [x] Fase 4: cierre anual (`generar-cierre-anual.ps1`)
- [x] Puerta de salida: `verificar-curso.ps1` TODO OK
- [x] Puerta de salida: `lint-canon.ps1 -HorasPorEncuentro 2` sin regresiones (0 errores, 9 avisos: 5 preview-libro + 4 prosa-estampada por diseño del scaffold, patrón baseline LAP)
- [ ] Commit work-unit de la corrida + push
- [ ] PDFs consolidados: `-Combinado` + `-SoloAnexos`

## Reglas de la corrida

- Cascada data-first Fase 0→4 sin saltear; curso-data y convenciones son propiedad del docente (no se re-redactan).
- Writers por carpeta en subagentes: cada uno recibe solo su slice de curso-data + convenciones + `input/estructura-de-la-clase.md` + digest de código.
- Principio "base=docente, versiones=alumno": toda evaluación con `-anexo-docente` separado (lección P2-E).
- Formato integrador U4: clases 27-29 a 120 min (canonizado en P2-D).
- Banco de frases estructurales (P2-A) y fraseos v2/v3 (P3-B) aplican a tramos invariantes.

## Evidencia

- Ejecución: 8 workers gentle-ai-worker en paralelo (superficies disjuntas) + 3 relanzamientos: U3 dividió en clases/evaluación (worker original murió sin reportar tras dejar esqueletos), U3-clases reanudado tras consulta de ajuste 240→120 min. U1 y U4 murieron al reportar dejando el trabajo completo (patrón conocido). Intensificaciones completó 36/36 sin reportar texto.
- Paridad P2-E completa en LPR: las 30 evaluaciones de momentos incluyen -anexo-docente para A y B (LAP solo tenía 1).
- Defectos menores corregidos por el orquestador: header "Versión A" en evaluacion-u1-version-b, typo "del biblioteca".
- Deuda heredada de LAP flaggeada al docente: base de criterios U3 particiona Parte 3 (10+10) distinto de las versiones alumno (20); replicado fielmente, no alterado.
- Scaffold default filtra dominio C# (Program.cs, records): mitigado por workers que lo sobrescribieron; candidata a mejora del scaffold (pendiente, no bloquea).
