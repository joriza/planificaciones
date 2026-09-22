# Feature: PDFs de anexos docente (-SoloAnexos)

Pedido del docente (+det41 continuidad): los 32 anexos docente de LAP no se
convierten a PDF por filtro intencional del script. Se aprueba un modo aparte
que genere un PDF de anexos por carpeta, sin mezclarlos con los consolidados
de estudiantes. Luego: actualizar README y pushear lo pendiente.

## Tareas

- [x] T1: modo `-SoloAnexos` en tools/convertir-a-pdf.ps1 (un PDF
      `<carpeta>-anexo-docente.pdf` por carpeta con anexos; unidades + 03-06).
- [x] T2: README.md — documentar el modo nuevo en la sección del script.
- [x] T3: correr el modo para LAP y verificar PDFs generados
      (5 PDFs: 4 unidades + 05-continuidad; encuadre/intensificaciones sin anexos).
- [x] T4: commits + push de lo pendiente. z-pdt-planificaciones.md quedó
      fuera (edición del docente, dispuesta sin commitear).

## Decisiones

- PDFs de anexos separados de los de estudiantes: la convención del repo
  (anexos siempre separados, auditada por verificar-curso.ps1) no se toca.
- Los PDFs siguen fuera de git (gitignored, decisión previa del docente).

## Evidencia

- 9a89ec4 feat(pdf): symmetric 15mm margins and default print.css stylesheet
- 2a87a84 feat(pdf): add -SoloAnexos mode for teacher annex PDFs (README + feature doc)
- Push: a5f2875..2a87a84 → origin/feature/lap-completo
- README worker: task muc68zif-1-qo9b (verificación grep SoloAnexos = 1)
