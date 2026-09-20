# Convenciones técnicas — Desarrollo de APIs con C# .NET 6 (Minimal API)

> Fuente única de verdad para todo agente o persona que genere documentos de este curso.
> Toda divergencia con esta hoja es un **defecto**, no una variación de estilo.
> `verificar-curso.ps1` exige varios de estos puntos (checks 6 a 8).

Estado: v1 — 2026-09-20. Origen: análisis de fallos silenciosos de sub-agentes (drift `int`/`long` y título de cierre detectados en el corpus de U2).

## 1. Proyecto y entorno

- Proyecto de referencia: `HospitalApi` (continuidad desde E13). `hospital.db` junto al `.csproj`.
- .NET 6 Minimal API; VS Code + terminal; TODO el código vive en `Program.cs`.
- Alumnos desde cero: cada concepto nuevo se presenta antes de usarse (secuenciación de saberes).

## 2. Lenguaje del código

- Rutas, identificadores y nombres de endpoints en inglés (`PatientWithProvince`, `/patients/by-city/{city}`).
- Comentarios de código y redacción de documentos en español, registro neutro.

## 3. Tipos canónicos (la regla que causó el drift)

- Ids de records que mapean SQLite: **`long`**. SQLite entrega `Int64`; `int` provoca error 500 con Dapper + records posicionales. Verificado en ejecución real (E11).
- Fechas en DTOs: **`string`**. `DateOnly`/`DateTime` no mapean contra TEXT de SQLite con Dapper.
- Excepción: records de la Unidad 1 (CRUD en memoria, sin base de datos) usan `int`.

## 4. Estructura de Program.cs

- Records SIEMPRE al final del archivo, después de `app.Run()` (CS8803: las top-level statements deben preceder a las declaraciones de tipo).
- Conexión: `using var connection` por handler.
- Parámetros SQL SIEMPRE con objeto anónimo (`new { Id = id }`); nunca concatenación de strings.
- Mapeo de columnas con alias `AS`.

## 5. Documentos de clase

- 7 secciones en orden fijo según `estructura-de-la-clase.md`; tiempos teóricos 30/45/90/55/20 (240').
- Título de cierre FIJO: `### Qué te llevás` (excepción deliberada al registro neutro: identidad de la serie), seguido de «Lo que viene».
- Nunca mencionar BOPPPS, GRR ni metodologías pedagógicas en el documento del alumno.
- Anexos docentes SIEMPRE separados: sufijo `-anexo-docente.md`.
- `hospital.db`: conteos canónicos 13/27/258/306 (province_names/doctors/patients/admissions); el anexo docente debe precorrer las consultas y anotar las cifras reales antes de dictar.

## 6. Creación de archivos (agentes)

- Escribir archivos con la herramienta Write (UTF-8). PROHIBIDO `Get-Content`/`Set-Content` de PowerShell 5.1 para escribir o modificar archivos: corrompen los acentos. Los CSV llevan BOM.
- Agentes en paralelo: solo con conjuntos de archivos disjuntos; cada agente ignora archivos ajenos que aparezcan durante la corrida; esta hoja es la única fuente de convenciones (no los archivos vecinos).
- Si un sub-agente devuelve respuesta vacía o 0 archivos: 1 relanzamiento con el mismo prompt; si reincide, dividir el lote.

## 7. Deuda conocida (a reparar; el verificador la reporta como PENDIENTE)

- Reparado 2026-09-20: cierre «Qué te llevás» en E10 y E11; ids `long` en records de las clases 12, 13 y del anexo de la 14. La tabla de deuda de `verificar-curso.ps1` quedó vacía.
- Reparado 2026-09-20: `database-docs/03-modelos-csharp-dapper.md` actualizado a los tipos canónicos (`long`/`string`); ya puede usarse como referencia.
