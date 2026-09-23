# Propuesta de canonización: formato integrador U4 sprint/mentoría

**Origen**: P2-D del plan de mejoras (secuencia §10)
**Estado**: requiere decisión del docente
**Propósito**: sancionar formalmente el formato de clases 27-29 U4 y corregir falsos ERROR del linter

## Hallazgo actual

### Formato estándar (unidades 1-3)
- **Duración**: 240 minutos (4 horas)
- **Estructura**: BOPPPS + GRR completo
- **Tabla de tiempos**: reparto detallado por momentos
- **Ejemplos**: clases 1-26 de LAP y LSO

### Formato integrador U4 (clases 27-29)
- **Duración**: 120 minutos (2 horas) 
- **Propósito**: trabajo final intensivo (sprint formativo)
- **Estructura**: versión intensiva de BOPPPS + GRR
- **Características**: 
  - Teoría mínima consolidada
  - Práctica guiada extendida
  - Ejercicio integrador complejo
  - Tiempo reducido por naturaleza del trabajo final

### Evidencia comparativa

| Clase | Formato | Duración | Estructura | Linter |
|-------|---------|----------|------------|---------|
| clase-26 (U3) | Estándar | 240 min | Tabla completa | ✅ OK |
| clase-27 (U4) | Integrador | 120 min | Tabla reducida | ❌ ERROR timebox |
| clase-28 (U4) | Integrador | 120 min | Tabla reducida | ❌ ERROR timebox |
| clase-29 (U4) | Integrador | 120 min | Tabla reducida | ❌ ERROR timebox |

## Propuesta de canonización

### 1. Agregar extensión a `input/estructura-de-la-clase.md`

**Formato integrador (120 min)**: Para encuentros de unidad 4 (integrador), con estructura intensiva y tiempo reducido por naturaleza del trabajo final.

**Características canónicas**:
- Duración: 120 minutos fijos (no configurable)
- Reparto de tiempos: adaptado a intensidad del trabajo final
- Enfoque: consolidación + integración de núcleos del año
- Validación: solo aplica a clases 27-29 de U4

### 2. Regla de supresión del linter

Agregar excepción en `tools/lint-canon.ps1` para evitar falsos ERROR:
- Archivos: `clase-2[7-9].md` (27, 28, 29)
- Regla: suprimir checks `tipo-estructura` y `timebox` 
- Condición: solo para archivos con estructura `clase-2[7-9]` y U4

## Decisión requerida

**¿Aprueba el docente canonizar el formato integrador U4 (120 min) y la regla de supresión del linter?**

- **Opción 1**: Aprobar formato integrador como extensión canónica
- **Opción 2**: Modificar duración linter a 120 min para U4 (no recomendado)
- **Opción 3**: Mantener formato actual y crear workaround alternativo

## Próximos pasos

1. **Validación docente** → decisión sobre canonización propuesta
2. **Actualización canon** → modificar `input/estructura-de-la-clase.md`
3. **Corrección linter** → agregar regla supresión en `tools/lint-canon.ps1`
4. **Commit work-unit** → implementación final del formato canonizado