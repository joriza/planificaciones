# P2-A: Banco frases estructurales + scaffolds

**Origen**: P2-A del plan de mejoras (secuencia §10)
**Estado**: iniciado
**Objetivo**: crear banco de frases estructurales y mejorar scaffolds existentes

## Tarea actual

### 1. frases-estructurales.json
**Qué implica**: Extraer frases reutilizables del corpus existente para estructuras pedagógicas

**Estructuras identificadas**:
- **BOPPPS + GRR**: Metadatos, objetivos, teoría mínima, práctica guiada, ejercicio independiente, cierre, errores comunes
- **Evaluaciones**: Metadatos, consignas, soluciones, criterios de corrección
- **Anexos docentes**: Soluciones completas, respuestas esperadas, intervenciones

**Tasks:**
- [x] Analizar scaffolds existentes (clase.ps1, evaluacion.ps1)
- [ ] Extraer frases estructurales del corpus
- [ ] Crear frases-estructurales.json con categorías
- [ ] Documentar patrones de uso

### 2. scaffolds actualizados
**Qué implica**: Mejorar los scaffolds existentes con mejoras de P3-B

**Tasks:**
- [ ] Actualizar scaffold-clase.ps1 con frases pulidas
- [ ] Actualizar scaffold-evaluacion.ps1 con mejoras de naturalidad
- [ ] Agregar generación automática de versiones B/C/D
- [ ] Validar scaffolds mejorados contra corpus

## Proceso de extracción

### Fase 1: Análisis de scaffolds existentes
- **scaffold-clase.ps1**: Genera estructura BOPPPS + GRR con placeholders
- **scaffold-evaluacion.ps1**: Genera evaluaciones con versión A y anexo docente
- **P3-B**: Fraseos mejorados para naturalidad

### Fase 2: Extracción de patrones
- Identificar frases recurrentes en metadatos
- Extraer plantillas de consignas
- Consolidar estructuras de cierre y errores

### Fase 3: Banco de frases estructurales
- Categorizar por sección (objetivos, teoría, práctica, cierre)
- Incluir variantes por destinatario (LAP/LSO)
- Agregar contexto de uso y ejemplos

## Categorías de frases estructurales

### Metadatos y objetivos
- Formatos de presentación de unidad
- Estructura de objetivos accionables
- Descripción de ejes temáticos

### Teoría mínima
- Patrones de analogías breves
- Explicaciones concisas de conceptos
- Puentes con conocimientos previos

### Práctica guiada
- Formatos de pasos numerados
- Estructuras de código completo
- Salidas esperadas verificadas

### Ejercicio independiente
- Consignas con pista + solución esperada
- Formatos de verificación
- Dificultad progresiva

### Cierre y errores
- Patrones de takeaways
- Errores comunes con causas y fixes
- Preview del próximo encuentro

## Resultados esperados

- **frases-estructurales.json**: Banco centralizado de frases reutilizables
- **scaffolds mejorados**: Generación más natural y contextualizada
- **Consistencia**: Mismo lenguaje en todo el corpus generado
- **Eficiencia**: Menor tiempo en creación de nuevo contenido

## Próximos pasos

1. [x] Extraer frases estructurales del corpus existente
2. [x] Crear frases-estructurales.json con categorías
3. [x] Actualizar scaffolds con frases pulidas
4. [x] Validar scaffolds mejorados contra corpus
5. [x] Commit work-unit con banco de frases y scaffolds actualizados