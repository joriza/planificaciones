# Documentación de la Base de Datos — hospital.db

Carpeta generada a partir de los datos de `LSO/minimal-api-csharp/bbdd/` según el prompt de planificación.

## Archivos

| Archivo | Descripción |
|---------|-------------|
| `01-esquema-bd.md` | Esquema completo: tablas, columnas, relaciones, claves foráneas |
| `02-diccionario-datos.md` | Diccionario de datos detallado con valores ejemplo, estadísticas y consultas SQL de referencia |
| `03-modelos-csharp-dapper.md` | Records C# listos para usar con Dapper + ejemplos de consultas parametrizadas |
| `04-resumen-para-curso.md` | Resumen pedagógico: volúmenes, progresión de consultas por unidad, casos edge, consultas "gancho" |

## Uso en el curso Minimal API C#

Estos documentos contienen **solo la información de la base de datos** (lo declarado en `[Datos particulares] > Qué tomar de memoria`), ignorando el resto del repositorio LSO.

La base de datos original está en:
```
LSO/minimal-api-csharp/bbdd/hospital.db
```

Los scripts de recreación:
```
LSO/minimal-api-csharp/bbdd/0-crear-tablas.sql
LSO/minimal-api-csharp/bbdd/1-province_names.sql
LSO/minimal-api-csharp/bbdd/2-patients.sql
LSO/minimal-api-csharp/bbdd/3-doctors.sql
LSO/minimal-api-csharp/bbdd/4-admissions.sql
```