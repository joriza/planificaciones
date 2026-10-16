# Informe — Evaluación auténtica resiliente a la IA

> **Materia:** LPR — Programación en Python (`output/LPR/`)
> **Fecha:** informe de revisión, solo propuestas. No se modificó ningún documento del repositorio.
> **Convención:** archivo `z-` — anotación personal del docente, no vinculante.
> **Nota previa:** no existe materia "LPT" en el repo; este informe cubre **LPR (Python)** según lo confirmado.

---

## 1. Diagnóstico: cómo evalúa LPR hoy

Cada unidad (encuentros 9, 15, 26, 32) se evalúa con tres componentes el mismo encuentro (`output/LPR/06-aprobacion/criterios-aprobacion.md:16-29`):

| Componente | Peso (U1–U3) | U4 |
| --- | --- | --- |
| Prueba práctica individual (escribir programa completo en 70 min, versiones A/B) | 90 pts | 60 pts (modificación guiada) + 20 pts (explicación escrita) |
| Defensa individual del TP grupal | 10 pts | 20 pts |

Material consultable: *"apuntes propios, clases del aula virtual, documentación de Python"* (`evaluacion-u1.md:74`). Sin celulares, entrega por commit + push al repo grupal.

**Fortalezas reales que ya tiene el diseño** (no son menores):

- Evaluación **presencial, cronometrada y sin celulares**.
- **Defensa oral individual** intransferible y obligatoria (`criterios-aprobacion.md:61`).
- **Trazabilidad Git**: commits por avance, repo grupal, y en U4 issues/PRs recorridos en la defensa.
- **U4 es el diseño más resiliente del corpus**: modifica código propio del grupo, con defensa extensa uno a uno (`evaluacion-u4.md:20-25`).
- Distribución de riesgo: 4 evaluaciones + intensificaciones Apto/No apto + diciembre/marzo con defensa — no hay "un solo gran examen" que falsear.

---

## 2. Análisis de vulnerabilidad a IA por componente

| Componente | Vulnerabilidad | Por qué |
| --- | --- | --- |
| Prueba práctica U1–U3 (90 pts): *escribir `kiosco.py`/`club.py`/`libreria.py` desde cero* | **ALTA** | Un LLM resuelve estas consignas en segundos con especificaciones tan precisas como las del enunciado. 90% de la nota depende de producir código, exactamente lo que la IA produce. |
| Ítems conceptuales (10 pts): *"¿qué devuelve `input()` siempre?"* | **ALTA** | Pregunta factual: la IA la responde trivialmente, y además no mide comprensión sino memoria. |
| Versiones A/B | **No protegen contra IA** | Protegen contra copia entre alumnos (para eso sirven y hay que conservarlas), pero ambas son igualmente resolubles por IA. |
| U4 — modificación guiada sobre código propio (60 pts) | **MEDIA-BAJA** | El contexto es específico del repo del grupo; la IA genérica no lo conoce. Pero si el alumno pega el programa en un chat, la IA también lo modifica. |
| Defensa del TP (10 pts) | **BAJA** | Es el dique real, pero con peso 10/100 no compensa los 90 pts de producción asistible. |
| **Brecha estructural** | **CRÍTICA** | La defensa oral cubre el **TP grupal**, no la **prueba individual**: un alumno puede rendir la prueba con IA y defender otro programa sin contradicción detectable (`evaluacion-u1.md:30`). |
| Material consultable | **Ambiguo** | "Documentación de Python" en 2025 incluye webs con chatbots integrados; la regla no es aplicable tal como está escrita. |

**Conclusión del diagnóstico:** el diseño ya tiene los ingredientes auténticos (producto real versionado, defensa oral, proceso versionado), pero el **peso de la nota está invertido**: 90% production-of-code (AI-easy) vs 10% defensa (AI-hard).

---

## 3. Principios rectores de las propuestas

1. **Evaluar comprensión y juicio, no solo artefacto.** El código entregado deja de ser evidencia suficiente; lo es la combinación código + demostración en vivo + explicación.
2. **Autenticidad = lo que un programador junior hace realmente**: leer código ajeno, corregir bugs, extender programas existentes, justificar decisiones. Escribir desde cero es la parte menos auténtica y la más fácil para la IA.
3. **La IA no se combate con prohibición ingenua sino con diseño**: instancias donde usarla sin entender no sirve, y una política declarada de uso permitido/restringido.
4. **El proceso versionado es evidencia**: el historial de commits no se falsifica fácil con generación puntual.

---

## 4. Propuestas

### A. Rediseñar la prueba práctica U1–U3 (impacto alto, esfuerzo medio)

**A1. Partir de código base, no de página en blanco.** Entregar en el encuentro un `kiosco.py` parcialmente escrito (con funciones incompletas o con 2–3 bugs sembrados) y pedir: completar, corregir, extender. Evalúa lectura y comprensión (más auténtico y más difícil de delegar sin entender), y desplaza la ventaja de la IA porque el código base es específico de la clase.

**A2. Consignas de predicción y corrección con justificación escrita** en una línea propia ("¿qué imprime este programa y por qué?", "este bucle tiene un error: identificá la línea y explicá el fallo"). La justificación en palabras propias es lo que la IA no puede escribir por el alumno en 70 min sin que se note, y es lo que la defensa oral puede verificar en 2 minutos.

**A3. Demo con entradas no previstas como criterio de puntaje.** La rúbrica ya puntúa comportamiento (menú 20 pts, registro 40 pts). Cambiar el modo de corrección: el docente valida corriendo **entradas que no están en el anexo** (una letra donde va un número, stock negativo, producto inexistente). El código generado sin comprensión falla aquí, y esto lo puede hacer el docente en el momento.

**A4. Checkpoints de progresión** (encaja con el modelo GRR de la cátedra): para avanzar de Parte 1 a Parte 2, el alumno muestra funcionando la parte anterior. Convierte la prueba en mini-entregables verificados al vuelo; delegar en IA deja de alcanzar si no se puede correr y explicar.

### B. Cerrar la brecha defensa-prueba (impacto alto, esfuerzo bajo) — **la propuesta de mayor relación impacto/costo**

**B5. Verificación oral de la prueba individual.** Al entregar, 2–3 minutos por alumno sobre **lo que acaba de escribir**: "mostrame dónde validás el stock", "¿qué pasa si pongo una letra?", "cambiá esta línea en vivo". No hace falta defender todo: **muestreo de 2 preguntas** elegidas al momento. Esto solo ya vuelve no rentable el uso de IA en la prueba: el artefacto sin comprensión se cae en el primer cruce. Es compatible con la rotación actual si se hace al momento de la entrega/push.

**B6. Pregunta de transferencia en la defensa del TP** ("¿cómo lo modificarías para…?") con peso explícito en la rúbrica: mide juicio, no memoria.

### C. Proceso versionado como evidencia (impacto medio, esfuerzo bajo)

**C7. Formalizar el historial de commits en la rúbrica.** Ya se exige commit por avance (`materia.md`, herramientas de entrega). Convertirlo en puntos visibles: commits distribuidos en el tiempo + mensajes significativos. La generación puntual por IA produce commits-monolito de última hora; el patrón es observable y corrige la evidencia sin perseguir a nadie.

**C8. Extender el estándar U4.** U4 (modificar código propio + explicación + defensa 20 pts) es el diseño más resiliente del corpus. Proponer que U2 y U3 incorporen su lógica parcial: el 30–40% de la prueba aplicada sobre el **TP propio del grupo** (extender o corregir el código que ellos ya escribieron).

### D. Ítems conceptuales (impacto medio, esfuerzo bajo)

**D9. Reemplazar preguntas factuales** ("¿qué devuelve `input()`?") **por diagnóstico de error y predicción con justificación**. Las factuales no solo son triviales para la IA: tampoco detectan comprensión. Ejemplo: mostrar un `try/except` mal ubicado y pedir qué falla y por qué.

### E. Política explícita de IA (impacto alto en encuadre, esfuerzo bajo)

**E10. Sustituir la prohibición implícita por una política graduada declarada** en el encuadre y en cada evaluación: qué se permite siempre (autocompletado, documentación, pedir explicaciones), qué se permite solo en instancias designadas, qué está prohibido (pegar la solución de la prueba). La regla actual ("documentación de Python") es inejecutable en 2025.

**E11. Una instancia "con IA" de bajo peso y alta autenticidad.** En alguna actividad formativa: "generá con IA la función X, corregila hasta que pase estas 3 pruebas, y documentá qué tuviste que cambiar". Evalúa la competencia real de 2025 (supervisión de IA) y **resilientiza el resto**: quien aprendió a auditar código de IA también puede defender el propio. Alineado con evaluación auténtica: la tarea espeja el trabajo profesional actual.

**E12. Declaración breve de uso de IA en la entrega** (2 líneas: "qué usaste y qué cambiaste"). Normaliza el tema, alimenta la defensa y no castiga el uso legítimo.

---

## 5. Matriz de priorización

| # | Propuesta | Impacto anti-IA | Esfuerzo | Prioridad |
| --- | --- | --- | --- | --- |
| B5 | Verificación oral de la prueba individual | Muy alto | Bajo | **1** |
| E10 | Política de IA declarada en encuadre y evaluaciones | Alto | Bajo | **2** |
| D9 | Ítems de predicción/corrección con justificación | Alto | Bajo | **3** |
| C7 | Commits en la rúbrica | Medio | Bajo | 4 |
| E12 | Declaración de uso de IA | Medio | Bajo | 5 |
| A1–A2 | Prueba con código base + justificaciones | Muy alto | Medio | 6 |
| A3–A4 | Demo con entradas no previstas + checkpoints | Alto | Medio | 7 |
| C8 | Lógica U4 extendida a U2/U3 | Alto | Medio | 8 |
| E11 | Instancia formativa "con IA" | Medio | Medio | 9 |

**Nota sobre versiones A/B:** conservarlas (equivalencia y anti-copia entre filas funciona bien vía `tools/generar-version-b.ps1`), pero no contarlas como barrera anti-IA: la sustitución de dominio no cambia la resolubilidad por LLM.

---

## 6. Qué NO cambiar

- Presencialidad, cronómetro y sin celulares.
- Defensa individual intransferible y las mesas de diciembre/marzo con defensa (ya son resilientes).
- El flujo Git/GitHub por unidad y la profesionalización en U4 (issues, PRs, main protegida) — es la mayor palanca estructural anti-IA que tiene la materia.
- La arquitectura del repositorio: las propuestas se implementan como cambios de contenido en `output/LPR/` (regenerables desde `input/materias/LPR/` + canon), sin tocar herramientas.

---

## 7. Próximos pasos posibles (requieren decisión del docente)

1. Priorizar propuestas y definir el alcance (¿solo encuadre y rúbricas, o rediseño de consignas U1–U3?).
2. Con decisiones tomadas, redactar los cambios concretos como propuesta de edición (sin aplicar) o aplicarlos vía el pipeline del repo (`curso-data.json` + canon → render).
