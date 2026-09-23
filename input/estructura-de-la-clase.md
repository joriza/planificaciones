# Estructura de la clase — Formato de encuentro didáctico

> Documento de referencia para el docente. Define cómo se estructura cada encuentro del curso y cómo reproducir este formato en otros equipos o modelos LLM.

## Nombre canónico

**Estructura de encuentro BOPPPS + GRR (Gradual Release of Responsibility), con cierre de errores comunes.**

Es un híbrido de modelos de diseño instruccional consolidados — no un formato inventado. Este es el término que cualquier docente o equipo de formación va a reconocer.

## Secciones y el modelo que las respalda

| Sección del encuentro | Modelo que la respalda |
|---|---|
| Objetivos + metadatos (duración, requiere) | **BOPPPS** — "O" de Outcomes |
| **Charla rápida / analogía** (hotel, recepción) | **BOPPPS** — "B" de Bridge-in (puente de motivación) |
| Teoría mínima + código completo | **BOPPPS** — Participatory Learning |
| Práctica guiada → Ejercicio independiente | **Gradual Release of Responsibility (GRR)** — "yo hago → hacés vos" |
| Cierre: takeaway + preview | **BOPPPS** — Post-assessment + Summary |
| Errores comunes y trampas | **Rosenshine** — chequear comprensión / errores típicos anticipados |
| Timeboxing (30/45/20/10) | Planeación de **bloque formativo** clásica |

## Spec portable (para delegar a otro equipo o a un LLM)

Pasar tal cual cuando se pide crear un encuentro:

> **Formato de encuentro (BOPPPS + GRR):** documento único por sesión de 2h con estas secciones, en este orden:
>
> 1. **Metadatos de bloque** (duración, concepto nuevo, requisitos).
> 2. **Objetivos de aprendizaje** (3-5, accionables).
> 3. **Teoría mínima** — solo lo indispensable, con una **analogía breve** ("charla rápida") que ancle el concepto.
> 4. **Práctica guiada** — pasos numerados, código completo listo para copiar (un solo archivo `Program.cs`), con la salida esperada verificada.
> 5. **Ejercicio independiente** — consigna + pista + solución esperada.
> 6. **Cierre** — "Qué te llevás" (takeaway) + "Lo que viene" (preview del próximo).
> 7. **Errores comunes y trampas** — 4-6, cada uno con su causa y su fix.
>
> Reglas: sin abstracciones innecesarias, progresión incremental entre encuentros, lenguaje didáctico neutro, identificadores en inglés, texto en español.

## Extensiones disponibles

| Extensión | Dónde se usa |
|---|---|
| Comentario breve sobre `() =>` (expresión lambda) | Encuentro 1 — despeja la incógnita sin profundizar |
| Cuadro "Referencia rápida: verbos HTTP y códigos de respuesta" | Encuentro 4 — consolidación al completar el CRUD |
| **Formato integrador (120 min)** | Encuentros 27-29 de U4 — sprint intensivo con reparto de tiempos ajustado |

## Formatos canónicos

El proyecto define dos formatos de encuentro válidos:

| Formato | Duración | Aplicación | Característica |
|---|---|---|---|
| **Estándar (BOPPPS + GRR)** | 240 minutos | Unidades 1-3 | Formato completo con reparto detallado de tiempos |
| **Integrador (BOPPPS + GRR Sprint)** | 120 minutos | Unidad 4, clases 27-29 | Formato intensivo para trabajo final consolidador |

**Nota**: El formato integrador es válido por diseño y no constituye un error de estructura. Se aplica exclusivamente a las clases finales de integración del curso.