# Resumen de hospital.db para el Curso Minimal API C#

## Qué es
Archivo SQLite (`hospital.db`) con datos reales de un hospital canadiense, regenerado desde scripts SQL. 4 tablas, ~600 registros totales.

## Tablas y volúmenes

| Tabla | Registros | Uso pedagógico principal |
|-------|-----------|--------------------------|
| `province_names` | 13 | JOIN simple, datos de referencia |
| `doctors` | 27 | JOIN, GROUP BY especialidad |
| `patients` | 258 | WHERE, LIKE, agregaciones, rango edades |
| `admissions` | 306+ | JOIN triple, fechas, múltiples ingresos por paciente |

## Puntos clave para ejemplos de clase

### 1. Consultas progresivas (unidad 1 → 4)
- **U1**: SELECT simple, WHERE, ORDER BY → `patients`, `doctors`
- **U2**: JOIN de 2 tablas → `patients + province_names`, `admissions + doctors`
- **U3**: JOIN de 3 tablas → `admissions + patients + doctors`
- **U4**: Agregaciones, GROUP BY, subconsultas → estadísticas por especialidad, por mes, pacientes con múltiples ingresos

### 2. Datos interesantes para filtros
- **Alergias**: Penicillin (más común), Sulfa, Codeine, Peanuts, Eggs, Wheat
- **Especialidades**: 13 distintas, bien distribuidas (2-3 médicos c/u)
- **Fechas**: Junio 2018 – Junio 2019 (13 meses de datos)
- **Edades**: 1 a 98 años (nacidos 1918–2018)
- **Provincias**: 95% Ontario, ideal para mostrar WHERE province_id = 'ON'

### 3. Casos edge para enseñanza
- Pacientes sin ciudad (NULL)
- Ingresos sin fecha de alta (NULL = aún internado)
- Diagnósticos con typos reales: "Amigima", "Stomache Pain", "Rheumataoid Arthritis"
- Fecha de alta errónea: `'1971-01-05'` en varios registros (dato sucio real)
- Múltiples ingresos mismo paciente (historial clínico)

### 4. Consultas "gancho" para alumnos
```sql
-- "¿Cuántos pacientes tienen alergia a Penicillin?"
-- "¿Qué médico tuvo más ingresos?"
-- "¿Qué mes tuvo más ingresos?"
-- "Pacientes que estuvieron internados más de 10 días"
-- "Especialidad que trata más pacientes de 60+ años"
```

## Archivos de referencia en LSO
```
LSO/minimal-api-csharp/bbdd/
├── 0-crear-tablas.sql      -- DDL completo con FKs
├── 1-province_names.sql    -- 13 INSERTs
├── 2-patients.sql          -- 258 INSERTs
├── 3-doctors.sql           -- 27 INSERTs
├── 4-admissions.sql        -- 306+ INSERTs
└── hospital.db             -- Archivo SQLite listo para usar
```

## Cómo usar en clase
1. Copiar `hospital.db` a la raíz del proyecto alumno
2. Connection string: `"Data Source=hospital.db"`
3. Paquete NuGet: `Microsoft.Data.Sqlite` + `Dapper`
4. Solo `Program.cs` — modelos como `record` dentro del mismo archivo

## Restricciones del curso (recordar)
- Solo `Program.cs` (otros archivos solo si estrictamente necesario)
- Dapper, no Entity Framework
- VS Code + terminal
- Comentarios abundantes en código de ejemplo
- Git/GitHub: un repo por grupo, carpetas tp-u1, tp-u2, tp-u3, trabajo-final