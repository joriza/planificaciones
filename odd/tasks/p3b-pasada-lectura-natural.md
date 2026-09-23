# P3-B: Pasada de lectura natural: fraseos v2/v3 + tabla dominio

**Origen**: P3-B del plan de mejoras (secuencia §10)
**Estado**: iniciado
**Objetivo**: pulir 24 reescrituras de tramos invariantes para mejorar naturalidad del lenguaje

## Tarea actual

### 1. Pasada de lectura natural: fraseos v2/v3
**Qué implica**: Comparar sistemáticamente las versiones v1, v2, v3 de cada tramo invariantes y pulir los fraseos para mayor naturalidad del lenguaje docente.

**Tramos invariantes (11 total × 3 versiones = 33 reescrituras)**:

| Tramo | v1 | v2 | v3 | Prioridad pulido |
|-------|----|----|----|------------------|
| encuadre-1 | Presentación y diagnóstico | Presentación y diagnóstico | Presentación y diagnóstico | Alta (encuadre crítico) |
| previos-2-3 | Intensificación previos | Intensificación previos | Intensificación previos | Alta (base del curso) |
| evaluacion-u1-9 | Evaluación U1 | Evaluación U1 | Evaluación U1 | Media |
| evaluacion-u2-15 | Evaluación U2 | Evaluación U2 | Evaluación U2 | Media |
| cierre-c1-16 | Cierre C1 | Cierre C1 | Cierre C1 | Media |
| intensificacion-17-18 | Intensificación 17-18 | Intensificación 17-18 | Intensificación 17-18 | Alta (recuperación) |
| integradora-19-20 | Integradora 19-20 | Integradora 19-20 | Integradora 19-20 | Alta (puente) |
| evaluacion-u3-26 | Evaluación U3 | Evaluación U3 | Evaluación U3 | Media |
| evaluacion-u4-32 | Evaluación U4 | Evaluación U4 | Evaluación U4 | Alta (final) |
| cierre-c2-33 | Cierre C2 | Cierre C2 | Cierre C2 | Media |
| intensificacion-34-35 | Intensificación 34-35 | Intensificación 34-35 | Intensificación 34-35 | Alta (segunda recuperación) |
| cierre-integral-36 | Cierre integral | Cierre integral | Cierre integral | Alta (cierre anual) |

**Focos de mejora**:
- Redundancias: "presentación de la asignatura y de su organización anual"
- Precisión: "constatación" vs "verificación" vs "relevamiento"
- Fluidez: secuencias lógicas en actividades
- Terminología consistente: "instancia de evaluación" vs "encuentro reservado"

### 2. Revisión tabla dominio
**Qué implica**: Verificar completitud de filas D y sugerir mejoras de mapeo.

**Estado actual**: tabla dominio completa con A/B/C/D para todos los grupos.
**Acción**: Documentar filas D mejorables y sugerir extensión si aplica.

## Proceso de pulido

### Fase 1: Análisis comparativo (v1 vs v2 vs v3) - COMPLETADO
- Identificar redundancias entre versiones
- Detectar cambios de significado no deseados  
- Marcar mejoras de naturalidad
- Analizados los 3 tramos prioritarios: encuadre-1, previos-2-3, integradora-19-20

**Ejemplo: encuadre-1**
- **CONTENIDOS**: v2 y v3 redundantes con "a lo largo del año/recorrido anual" → consolidar a "organización anual"
- **EXPECTATIVAS**: v3 mejor que v1/v2: "Identificar" más preciso que "Reconocer cómo se organiza" 
- **ACTIVIDADES**: v3 más conciso: "diagnóstico escrito y oral" vs "relevamiento diagnóstico... escrito y oral"

**Ejemplo: previos-2-3**
- **CONTENIDOS**: v3 más preciso con "organización en archivos y carpetas"
- **EXPECTATIVAS**: v3 más pedagógico: "tomando el acceso a la plataforma... como punto de partida"
- **ACTIVIDADES**: v3 mejor terminología: "apoyo dirigido" vs "refuerzo dirigido"

**Ejemplo: integradora-19-20**
- **CONTENIDOS**: v2 usa "articula" (más preciso), v3 mantiene claridad de "entre Unidades 1 y 2"
- **EXPECTATIVAS**: v2 mejor orden lógico: "Articular... en un producto funcional y coherente"
- **ACTIVIDADES**: v3 mejor profesionalismo: "avance asentado en el repositorio" vs "avance registrado"

### Fase 2: Consolidación v2/v3
- Mantener lo mejor de v2 y v3
- Eliminar repeticiones
- Unificar terminología crítica

### Fase 3: Validación docente
- Revisar cambios significativos
- Mantener esencia pedagógica intacta

## Resultados esperados

- **Reducción de tokens**: eliminar redundancias en prosa estructural
- **Mejor fluidez**: phrasing más natural para el docente
- **Consistencia terminológica**: mismo lenguaje en todo el corpus
- **Mantenimiento pedagógico**: conservar estructura y contenido esencial

## Logros en pulido
- **encuadre-1**: eliminada redundancia "de de", mejor precisión "Identificar", simplificación "diagnóstico escrito y oral"
- **previos-2-3**: mejor precisión "organización en archivos", pedagogía "tomando... como punto de partida", terminología "apoyo dirigido"
- **integradora-19-20**: mejor técnica "articula", profesionalismo "asentado en el repositorio"

## Próximos pasos

1. [x] Realizar análisis comparativo de los 3 tramos prioritarios (ejemplo encuadre-1)
2. [x] Aplicar pulido a tramos prioritarios (ejecutado en tramos-pulidos-v2-v3.json)
3. [ ] Documentar mejoras sugeridas para tabla dominio
4. [x] Commit work-unit con consolidación v2/v3 pulida