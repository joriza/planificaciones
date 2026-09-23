# P1-D: Distribución por destinatario + guías de camino

**Origen**: P1-D del plan de mejoras (secuencia §10)
**Estado**: iniciado  
**Objetivo**: crear distribución específica para LAP (Python) y LSO (C#) con matrices y guías

## Tarea actual

### 1. matriz destinos.json
**Qué implica**: Crear matriz de mapeo de contenido por destinatario (LAP vs LSO)

**Destinatarios identificados**:
- **LAP**: Licenciatura en Analítica y Programación (Python)
- **LSO**: Licenciatura en Software (C#)

**Diferencias clave**:
- **Lenguaje**: Python vs C#
- **API**: Minimal API (Python) vs Minimal API (C#/.NET)
- **Base de datos**: SQLite (común)
- **Enfoque**: Analítica de datos vs Desarrollo software

**Tasks:**
- [x] Identificar corpus existentes (LAP y LSO)
- [ ] Crear matriz destinos.json con mapeo de contenido
- [ ] Validar matriz contra 2 corpus existentes
- [ ] Documentar diferencias técnicas sustanciales

### 2. -PorDestinatario en PDF
**Qué implica**: Generar PDFs específicos para cada destinatario

**Tasks:**
- [ ] Configurar plantilla PDF por destinatario
- [ ] Generar PDF LAP con contenido Python
- [ ] Generar PDF LSO con contenido C#
- [ ] Validar contenido específico en cada PDF

### 3. 3 guías de camino
**Qué implica**: Crear guías de aprendizaje específicas para cada destinatario

**Tasks:**
- [ ] Guía LAP: Python + Analítica de datos
- [ ] Guía LSO: C# + Desarrollo profesional  
- [ ] Guía comparativa: Diferencias y transiciones

## Proceso de distribución

### Fase 1: Análisis de corpus
- **LAP**: Python, minimal API, SQLite, enfoque analítico
- **LSO**: C#, .NET Minimal API, SQLite, enfoque desarrollo

### Fase 2: Matriz de distribución
- Contenido común: SQLite, estructura general, metodología
- Contenido específico: lenguaje, ejemplos, casos de uso

### Fase 3: Validación cruzada (COMPLETADA)
- ✅ Estructura equivalente verificada
- ✅ Objetivos de aprendizaje comparables
- **Diferencias encontradas**:
  - LAP: 1 evaluación de intensificaciones (02-03)
  - LSO: 6 evaluaciones de intensificaciones (02-03, 17-18, 19-20, 34-35, diciembre, marzo)
  - Lenguajes: Python vs C#
  - Dominios: tickets/biblioteca vs médicos/hospital

## Resultados esperados

- **matriz destinos.json**: Mapeo claro de qué contenido va para cada destinatario
- **PDFs específicos**: Documentos optimizados para cada perfil
- **Guías de camino**: Ayuda a los estudiantes a entender su trayectoria específica

## Próximos pasos

1. [x] Crear matriz destinos.json con mapeo LAP/LSO
2. [x] Validar estructura equivalente entre corpus
3. [ ] Configurar generación de PDFs por destinatario
4. [ ] Crear las 3 guías de camino específicas
5. [ ] Commit work-unit con distribución completa