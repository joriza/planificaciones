# Feature: documentos de cierre del ciclo anual (seguimiento + memoria + informes de mesa)

> Implementación de P1-B + P2-B + P2-C de `docs/plan-de-mejoras-del-proyecto.md` (confirmados por el
> docente el 2026-09-22; P1-A declinado por ahora). Tres tipos documentales derivados del curso-data,
> generados como esqueletos completos que el docente completa a mano durante/el cierre del ciclo.
> **Cero LLM en los documentos**: solo estructura y prosa fija de registro docente formal; el análisis
> lo escribe el docente; los ajustes que surjan entran por el curso-data.

## Regla de propiedad (la decisión de diseño central)

Estos documentos son **derivados una sola vez y luego propiedad del docente** (mismo patrón que
`curso-data.json`): el generador los crea SOLO si no existen (protege sin `-Force`, avisa); el modo
actualización jamás los toca; la regeneración completa los re-crea vacíos (una memoria completada no se
regenera en la práctica). Motivo: contienen llenado manual (fechas, resultados, prosa de cierre) que un
re-render destruiría.

## Entregables

Una herramienta nueva `tools/generar-cierre-anual.ps1` + primer corpus en `output/LAP/07-cierre-anual/`:

| Archivo | Qué es | Uso |
|---|---|---|
| `seguimiento-anual.csv` | 38 filas (36 encuentros + mesas diciembre/marzo): Nº, Instancia, Eje temático, Tema del día derivados; Fecha, TPs entregados (grupos), Defensas/Resultados, Observaciones vacías para el docente | Semanal |
| `memoria-anual.md` | Esqueleto de memoria de cátedra: datos de referencia, desarrollo efectivo (38 filas), resultados por instancia (12 instancias), TPs, continuidad, intensificación, balance y ajustes (espacio de prosa del docente), firma | Cierre del ciclo |
| `informe-mesa-diciembre.md` | Esqueleto del informe formal de la mesa de diciembre: datos, destinatarios (manual), alcance evaluado (camino mínimo derivado), metodología fija (Apto/No apto aún), instrumento (referencia a las evaluaciones del corpus), resultados (manual), firmas | Mesa de diciembre |
| `informe-mesa-marzo.md` | Ídem, marco de marzo (mismo estándar, más tiempo de preparación) | Mesa de marzo |

## Spec técnica para el worker

### Comando

`powershell -File tools\generar-cierre-anual.ps1 -Materia input\materias\LPR -Salida output\LAP\07-cierre-anual [-Force]`

- Sin `-Force`: crea solo los archivos faltantes y AVISA los existentes (patrón de `generar-readme.ps1`).
- Con `-Force`: sobrescribe (idempotente: misma entrada → mismos bytes).
- PS 5.1 puro (sin `?:`, `??`, `&&`), comentarios en español, patrón de params de `tools/generar-readme.ps1`.

### Fuentes de datos

- `input/materias/<m>/curso-data.json`: `encuentros` (20, campos `n/unidad/caracter/eje/estructura/tema`),
  `slots` (denominaciones, tps, unidades, ejes, stack, entorno).
- `input/plantillas/libro-filas-invariantes.json`: los 16 encuentros invariantes (`n/eje/ejeNombre/tema`).
- Estructura fija del ciclo (canón, 36 + 2 mesas): mapping fijo en el script (mismo criterio que
  `tramos-invariantes.json` codifica lo invariante).

### Composición de las 38 filas del seguimiento (y tabla §2 de la memoria)

- 20 filas de unidad desde `encuentros` (tema = campo `tema`; instancia = `Unidad {u}` + ` (cierre)` si
  `estructura == "cierre"`).
- 16 filas invariantes desde `libro-filas-invariantes.json` (instancia derivada del Nº según la tabla
  del canon: 1=Encuadre y diagnóstico; 2-3=Saberes previos; 9/15/26/32=Evaluación U1/U2/U3/U4;
  16/33=Cierre de cuatrimestre; 36=Cierre integral; 17-18 y 34-35=Intensificación y fortalecimiento;
  19-20=Proyecto puente).
- 2 filas de mesa: Nº `D` (Mesa de diciembre) y `M` (Mesa de marzo), tema e instancia fijos.
- Columna Instancia/TP: en cierres de unidad añade el TP (`slots.tps.uX`); en evaluaciones «Evaluación U{n}».

### Formato

- CSV: separador `;`, celdas con `;` entre comillas dobles, UTF-8 **con BOM**, finales LF (idéntico a
  `generar-administrativos.ps1`). Celdas manuales: vacías.
- .md: encoding igual al corpus vigente (verificar BOM de un .md existente de `output/LAP`); registro
  docente formal; celdas/espacios manuales marcados `—`; secciones de prosa del docente con blockquote
  de instrucción (`> Completar al cierre del ciclo...`).

### Memoria: secciones

1. Datos de referencia (materia, denominación, stack, entorno, 36 encuentros teóricos, nota de diseño
   teórico vs. calendario real).
2. Desarrollo efectivo del ciclo (tabla 38 filas + columnas manuales Fecha real / Estado / Motivo de desvío).
3. Resultados por instancia (tabla 12 instancias: 4 evaluaciones de unidad, 6 momentos, 2 mesas; columnas
   manuales).
4. Trabajos prácticos (tabla desde `slots.tps` + columnas manuales de entrega/defensa).
5. Continuidad pedagógica (tabla de 4 documentos en las posiciones estándar del canon + nota de ajuste
   según el pedido de la materia).
6. Intensificación y fortalecimiento (tabla de los 6 momentos + columnas manuales).
7. Balance del ciclo (blockquote de instrucción + espacio).
8. Ajustes propuestos para el próximo ciclo (blockquote: los ajustes entran por el curso-data y se
   re-deriva el corpus).
9. Firma (Aclaración / Firma / Fecha).

### Informes de mesa: secciones

1. Datos de la mesa (instancia fija, marco: fuera de la estructura anual, fecha/espacio/docente `—`).
2. Destinatarios (tabla manual: alumno, condición, metas pendientes).
3. Alcance evaluado (derivado: camino mínimo completo — por unidad, denominación + expectativas de
   `slots.unidades` — más los TPs de `slots.tps`).
4. Metodología (prosa fija del canon: criterio Apto / No apto aún por objetivo mínimo; el estándar de
   marzo es idéntico al de diciembre: no baja, cambia el tiempo de preparación).
5. Instrumento (referencia a `evaluaciones/evaluacion-intensificaciones-diciembre(-marzo)` versiones A/B
   del corpus).
6. Resultados (tabla manual: alumno, versión, resultado, observaciones).
7. Firmas.

### Integración de canon y README

- `prompt-plantilla-planificacion.md`: nueva sección `[Seguimiento y cierre del ciclo — regla fija]`
  (después de [Continuidad pedagógica]): los tres tipos, la carpeta `07-cierre-anual/`, la regla de
  propiedad (generar solo si faltan; actualización jamás los toca; regeneración los re-crea vacíos) y el
  registro docente formal. En la Fase 4, agregar la generación con el comando. En la tabla «Orden de
  creación» del README raíz, insertar la fila de Fase 4 (antes de la puerta de salida, que pasa a #13).
- `README.md` (raíz): fila en la tabla de herramientas + mencionar `07-cierre-anual/` en la fila de
  `output/`.
- `input/plantillas/readme-descripciones.json`: entrada para `07-cierre-anual` (para futuros READMEs
  derivados). El README del curso LAP: editar manualmente SOLO la sección índice (no regenerar con
  `-Force`: la fundamentación derivada pisaría la vigente).

### Reglas duras

- NO commitear ni ejecutar comandos git que muten estado (rama `regen/lso` compartida con otra sesión).
- NO tocar: `output/LSO/**` (regeneración en curso), `input/materias/**`, otros `tools/**`, `z-*.md`.
- Si `verificar-curso.ps1` o `lint-canon.ps1` fallan por causas que requieran editar OTROS scripts:
  detenerse y reportar (no editarlos en esta feature).
- Reporte compacto ≤ 15 líneas: archivos, batería de verificación (comando + resultado), desvíos.

## Registro de verificación (cierre)

- lint-canon -HorasPorEncuentro 2 = 0 errores / 4 avisos (baseline).
- verificar-curso = 1 link roto preexistente (input/materias/LAP del renombre, fuera de alcance por decisión del docente).
- Idempotencia -Force OK.
- Protección sin -Force OK.
- 0 mojibake / 0 U+201D en script y salidas.
- Fix aplicado: H1 informes «Intensificación de …».

## Mapa de tareas

| # | Tarea | Estado |
|---|---|---|
| T1 | Spec + decisiones registradas (este doc + plan §6.1) | ✅ |
| T2 | Worker: `tools/generar-cierre-anual.ps1` + corpus `output/LAP/07-cierre-anual/` | ✅ |
| T3 | Worker: integración canon (prompt plantilla) + READMEs + descripciones | ✅ |
| T4 | Verificación: idempotencia (-Force ×2 byte-idéntico), protección sin -Force, `verificar-curso` y `lint-canon` sin regresiones | ✅ |
| T5 | Cierre del odd doc + reporte (sin commit: rama regen/lso compartida) | ✅ (cierre por orquestador; sin commit: rama regen/lso compartida) |

## Mirror Engram

- topic_key: `odd/documentos-cierre-anual/tasks`
