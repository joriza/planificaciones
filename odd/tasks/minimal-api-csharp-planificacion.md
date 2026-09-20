# Feature: minimal-api-csharp — planificación anual completa (36 encuentros)

Curso: **Minimal API con C# .NET 6** (desde cero, VS Code + terminal, Dapper + SQLite `hospital.db`, sin abstracciones, solo `Program.cs`).
Salida: corpus completo en `minimal-api-csharp/` según `0-prompt-plantilla-planificacion.md` (fases 2–7, frenos desactivados por el usuario solo para esta ejecución).
Este documento es el **mapa maestro** de la cascada: todo subagente lo lee antes de escribir.

## Decisiones de diseño (fuente: [Datos particulares] + canon)

- 4 h teóricas por encuentro (240 min). El factor de eficacia **no se expone en ningún documento**; cada bloque declara actividades reales (núcleo + extensión/consolidación explícita) que justifican 240 min.
- Uso de celular: **no permitido** (consta en columna Actividades de la anual).
- Grupos: alumnos presentes ÷ equipos disponibles (mínimo posible); ningún equipo sin usar; rotación de integrantes en actividades grupales.
- Git: E5 enseña git **local** como herramienta de trabajo (init, .gitignore, add, commit; rutina de commit por clase). E8 enseña **una sola vez** el ciclo completo de entrega (repo remoto en GitHub web, remote add, push) → primera entrega `tp-u1`. Desde ahí cada entrega = carpeta nueva + commits + push. U4 profesionaliza el mismo repo: README de portada, issues, ramas por feature, PRs revisados, main protegida.
- BD: `hospital.db` (SQLite). **U1 sin BD** (API en memoria); Dapper desde U2. Progresión: U2 SELECT/WHERE/ORDER/LIKE + JOIN 2 tablas + escritura; U3 JOIN 3 tablas + agregaciones/GROUP BY + subconsultas + datos sucios + configuración + publish; U4 proyecto integrador (subconsultas, estadísticas).
- Records: ids `long`, fechas `string` (ISO `yyyy-MM-dd`) — canon de `convenciones-tecnicas.md`.
- Entregas: `tp-u1` (E8), `tp-u2` (E14), `tp-u3` (E25), `trabajo-final` (E31); carpeta por trabajo en un único repo por grupo, mono-rama main hasta U4.
- Evaluaciones: solo instancias de evaluación tienen versiones A/B equivalentes (mismos objetivos y requisitos, distinto dominio/datos). Entrega por GitHub + defensa individual en el encuentro dedicado; el encuentro siguiente abre con la devolución.
- Registro: institucional (anual, libro, criterios, continuidad, metadatos de evaluaciones) en registro docente formal; materiales de clase en registro didáctico. Anexos docentes SIEMPRE en `-anexo-docente.md` separado.
- Carácter/Objetivo (una palabra): Conceptual / Procedimental / Actitudinal.

## Ejes temáticos del libro de aula

| Nº Eje | Eje | Tipo |
|---|---|---|
| 1 | Fundamentos de Minimal API | coincide con U1 |
| 2 | Acceso a datos con Dapper | coincide con U2 |
| 3 | Integración y publicación | coincide con U3 |
| 4 | Trabajo integrador profesional | coincide con U4 |
| 5 | Terminal, Git y GitHub | transversal |
| 6 | Diagnóstico, integración y metacognición | transversal |

## Mapa maestro por encuentro

| Nº | Eje | Carácter | Momento | Contenido (semilla) | TP/eval |
|---|---|---|---|---|---|
| 1 | 6 | Actitudinal | Encuadre y diagnóstico | Presentación, contrato pedagógico, seguridad e higiene y EPP (escuela técnica), diagnóstico de saberes previos | — |
| 2 | 6 | Procedimental | Previos (recup.+profund.) | Nivelación: computadora, archivos y carpetas, terminal básica (navegación, comandos); pista profundización | — |
| 3 | 6 | Procedimental | Previos (recup.+profund.) | La web: URL, petición/respuesta, HTTP informal, JSON por primera vez; pista profundización | — |
| 4 | 1 | Procedimental | U1 · clase | `dotnet new web`, anatomía de Program.cs, run, primer endpoint GET, probar en navegador; comentario breve sobre `() =>` | — |
| 5 | 1 | Procedimental | U1 · clase | Rutas y parámetros de ruta, tipos devueltos, JSON automático; **git local** (init, .gitignore, commit; rutina por clase) | — |
| 6 | 1 | Conceptual | U1 · clase | Verbos HTTP y códigos de respuesta (cuadro referencia rápida); CRUD completo en memoria (lista estática) | — |
| 7 | 1 | Procedimental | U1 · clase | Consolidación: mini API en memoria integrando rutas+parámetros+verbos+estados; errores comunes y fixes | — |
| 8 | 5 | Procedimental | U1 · cierre | Desarrollo del TP-u1 en clase; cierre U1; **ciclo completo de entrega** (GitHub web, remote add, push) | tp-u1 |
| 9 | 1 | Procedimental | Evaluación U1 | Entrega por GitHub (verificación), defensa individual, prueba A/B | Eval u1 A/B |
| 10 | 2 | Procedimental | U2 · clase | Devolución U1; SQLite `hospital.db` primera mirada; Dapper: conexión + primer SELECT → record (`long`/`string`) | — |
| 11 | 2 | Procedimental | U2 · clase | Consultas parametrizadas: WHERE, ORDER BY, parámetros de ruta y query string sobre la BD | — |
| 12 | 2 | Procedimental | U2 · clase | Filtros WHERE y LIKE, búsquedas, validación manual simple, 400/404 | — |
| 13 | 2 | Procedimental | U2 · clase | JOIN de dos tablas (`patients`+`province_names`, `admissions`+`doctors`), records compuestos | — |
| 14 | 2 | Procedimental | U2 · cierre | Escritura con Dapper (INSERT/UPDATE/DELETE parametrizados, 201/400/404); consolidación; cierre U2; entrega tp-u2 | tp-u2 |
| 15 | 2 | Procedimental | Evaluación U2 | Entrega por GitHub, defensa individual, prueba A/B | Eval u2 A/B |
| 16 | 6 | Conceptual | Cierre cuatrimestre 1 | Evaluación integradora cuatrimestral A/B + metacognición | Eval c1 A/B |
| 17 | 6 | Procedimental | Especial U1-U2 | Recuperación y profundización: pistas diferenciadas por condición, núcleos U1-U2 | Eval esp. A/B |
| 18 | 6 | Procedimental | Especial U1-U2 | Ídem (2.º encuentro del momento) | — |
| 19 | 6 | Procedimental | Especial puente | Proyecto puente U1-U2, única pista para todo el curso (1/2) | Eval esp. A/B (rúbrica 100) |
| 20 | 6 | Procedimental | Especial puente | Proyecto puente (2/2), cierre con rúbrica | — |
| 21 | 3 | Procedimental | U3 · clase | Devolución U2; JOIN triple `admissions`+`patients`+`doctors`, endpoints compuestos | — |
| 22 | 3 | Procedimental | U3 · clase | Agregaciones COUNT/AVG/SUM y GROUP BY (por especialidad, por mes) | — |
| 23 | 3 | Procedimental | U3 · clase | Subconsultas simples; datos sucios reales (NULL, typos, fecha errónea): robustez y manejo de errores | — |
| 24 | 3 | Procedimental | U3 · clase | Configuración `appsettings.json` (connection string), `dotnet publish`, correr en release | — |
| 25 | 3 | Procedimental | U3 · cierre | Sprint integrador; cierre U3; entrega tp-u3 | tp-u3 |
| 26 | 3 | Procedimental | Evaluación U3 | Entrega por GitHub, defensa individual, prueba A/B | Eval u3 A/B |
| 27 | 4 | Procedimental | U4 · clase | Devolución U3; lanzamiento del trabajo final (consigna integradora); README de portada del repo | trabajo-final |
| 28 | 5 | Procedimental | U4 · clase | Issues + ramas por feature + flujo de trabajo | — |
| 29 | 5 | Procedimental | U4 · clase | Pull requests, revisión entre pares, main protegida | — |
| 30 | 4 | Procedimental | U4 · clase | Sprint de desarrollo mentorizado (GRR completo) | — |
| 31 | 4 | Procedimental | U4 · cierre | Consolidación, cierre U4, preparación de la defensa, entrega trabajo-final | — |
| 32 | 4 | Actitudinal | Evaluación U4 | Defensa del trabajo integrador | Eval u4 A/B |
| 33 | 6 | Conceptual | Cierre cuatrimestre 2 | Evaluación integradora cuatrimestral A/B + metacognición anual | Eval c2 A/B |
| 34 | 6 | Procedimental | Especial U3-U4 | Recuperación y profundización: pistas diferenciadas, núcleos U3-U4 | Eval esp. A/B |
| 35 | 6 | Procedimental | Especial U3-U4 | Ídem (2.º encuentro del momento) | — |
| 36 | 6 | Actitudinal | Cierre integral | Balance, metacognición y proyección (sin contenido nuevo, sin versión A/B) | — |

Fuera de la anual: `especiales-diciembre-intensificacion` y `especiales-marzo-intensificacion` (camino mínimo completo, Apto/No apto aún, estándar idéntico entre sí).

## Plantillas de tiempos teóricos (240 min por encuentro; nunca mencionar factor de eficacia)

- Clase regular: apertura/puente 20 · teoría mínima 40 · práctica guiada 70 · ejercicio independiente 50 · extensión y consolidación 45 · cierre 15.
- Cierre de unidad: apertura 15 · consolidación 75 · trabajo del TP 90 · ciclo de entrega 45 · cierre 15.
- Evaluación de unidad: entrega y verificación GitHub 30 · defensa individual 90 · prueba práctica A/B 90 · cierre 30.
- Especial (por encuentro): plenaria 20 · bloque 1 90 · bloque 2 90 · plenaria de cierre 40.
- Encuadre (E1): encuadre 60 · SyG+EPP 45 · diagnóstico 90 · cierre 45.
- Cierre cuatrimestral: integradora A/B 120 · metacognición 60 · devolución 30 · cierre 30.
- Cierre integral (E36): balance 60 · metacognición 90 · proyección 60 · cierre 30.
- Continuidad: actividades puntuadas /100 cuyos tiempos suman 240.

## Árbol de archivos del curso (naming obligatorio)

```
minimal-api-csharp/
├── README.md                                  (índice + orden de creación + ejes vs unidades + fundamentación)
├── convenciones-tecnicas.md                   (canon de tipos/formatos/estructura de código)
├── 01-planificacion/
│   ├── planificacion-anual.md / planificacion-anual.csv        (16 filas-tramo; Tiempo suma 36)
│   ├── libro-de-aula-1-linea-por-encuentro.md / .csv           (36 filas)
│   └── libro-de-aula-2-lineas-por-encuentro.md / .csv          (72 filas)
├── 02-unidades/
│   ├── 01-u1-fundamentos/            clase-04…08 (+ anexos) + evaluacion-u1*
│   ├── 02-u2-acceso-datos-sqlite-dapper/   clase-10…14 (+ anexos) + evaluacion-u2*
│   ├── 03-u3-integracion-datos-publicacion/ clase-21…25 (+ anexos) + evaluacion-u3*
│   └── 04-u4-trabajo-integrador-profesional/ clase-27…31 (+ anexos) + evaluacion-u4*
├── 03-instancias/
│   ├── instancia-01-encuadre-y-diagnostico.md
│   ├── instancia-16-cierre-cuatrimestre-1.md + evaluacion-cuatrimestre-1{,-version-a,-version-b,-version-*-anexo-docente}.md
│   ├── instancia-33-cierre-cuatrimestre-2.md + evaluacion-cuatrimestre-2…
│   └── instancia-36-cierre-integral.md
├── 04-especiales/
│   ├── especiales-02-03-saberes-previos.md
│   ├── especiales-17-18-unidades-1-2.md
│   ├── especiales-19-20-integradora-1-2.md
│   ├── especiales-34-35-unidades-3-4.md
│   ├── especiales-diciembre-intensificacion.md
│   ├── especiales-marzo-intensificacion.md
│   └── evaluaciones/  evaluacion-especiales-{02-03,17-18,19-20,34-35,diciembre,marzo}{,-version-a,-version-b}.md + 1 anexo docente por momento
├── 05-continuidad/
│   └── continuidad-0{1..4}-*.md + sus -anexo-docente.md
└── 06-aprobacion/criterios-aprobacion.md
```

Nombres de clases: `clase-04-primer-proyecto-minimal-api`, `clase-05-rutas-parametros-y-git-local`, `clase-06-verbos-http-y-crud-en-memoria`, `clase-07-consolidacion-crud-en-memoria`, `clase-08-mini-proyecto-entrega-y-cierre-u1`, `clase-10-sqlite-y-dapper-primera-consulta`, `clase-11-consultas-parametrizadas-y-orden`, `clase-12-filtros-where-like-y-validacion`, `clase-13-join-de-dos-tablas`, `clase-14-escritura-cierre-u2-y-entrega`, `clase-21-join-triple-y-endpoints-compuestos`, `clase-22-agregaciones-y-group-by`, `clase-23-subconsultas-y-datos-sucios`, `clase-24-configuracion-y-publicacion`, `clase-25-consolidacion-cierre-u3-y-entrega`, `clase-27-trabajo-final-y-readme`, `clase-28-issues-y-ramas-por-feature`, `clase-29-pull-requests-y-main-protegida`, `clase-30-sprint-de-desarrollo-mentoria`, `clase-31-consolidacion-cierre-u4-y-defensa`.

Evaluación de unidad (en la carpeta de su unidad): `evaluacion-uN.md` (metadatos y acuerdos, registro docente formal) + `evaluacion-uN-version-a.md` + `evaluacion-uN-version-b.md` + `evaluacion-uN-version-{a,b}-anexo-docente.md`.

Continuidad: `continuidad-01-saberes-previos`, `continuidad-02-tras-evaluacion-u1` (uso: desde E10), `continuidad-03-tras-evaluacion-u2` (uso: desde E16), `continuidad-04-tras-evaluacion-u3` (uso: desde E27).

## Reglas duras del verificador (`verificar-curso.ps1`)

1. CSVs: UTF-8 **con BOM**, separador `;`, celdas con `;` entre comillas dobles. `planificacion-anual.csv` Tiempo (solo número) suma 36.
2. `libro-de-aula*.csv`: 36 y 72 filas; celdas `Tema del Día` y `Actividades` ≤ 35 caracteres **por línea** (contar espacios).
3. README: todo link relativo apunta a archivo existente.
4. `## Anexo docente` jamás dentro de un entregable; cada `*-anexo-docente.md` tiene su archivo base.
5. Sin mojibake (escribir UTF-8 limpio).
6. `02-unidades/**/clase-*.md` (sin anexos): debe existir heading `### Qué te llevás`.
7. Records de unidades con BD (u2+): ids `long`, fechas `string` (nunca `int`/`DateOnly`/`DateTime`).
8. Cobertura: clases regulares 20, evaluaciones u1–u4, especiales 6 momentos, instancias 4.

## Tareas (cascada de subagentes)

| # | Tarea | Salida | Estado |
|---|---|---|---|
| 1 | Mapa maestro y estructura (este documento) | odd/tasks/minimal-api-csharp-planificacion.md | done |
| 2 | convenciones-tecnicas.md | 1 archivo | done |
| 3 | Planificación anual md+csv | 01-planificacion | done |
| 4 | Libro de aula md+csv ×2 | 01-planificacion | done |
| 5 | Clases U1 (04-08) + anexos | 02-unidades/01-u1 | done |
| 6 | Clases U2 (10-14) + anexos | 02-unidades/02-u2 | done |
| 7 | Clases U3 (21-25) + anexos | 02-unidades/03-u3 | done |
| 8 | Clases U4 (27-31) + anexos | 02-unidades/04-u4 | done |
| 9 | Evaluaciones u1-u4 (base+A+B+anexos) | carpetas de unidad | done |
| 10 | Instancias (01, 16+eval, 33+eval, 36) | 03-instancias | done |
| 11 | Especiales ×6 + evaluaciones | 04-especiales | done |
| 12 | Continuidad ×4 + anexos | 05-continuidad | done |
| 13 | Criterios de aprobación | 06-aprobacion | done |
| 14 | README índice | README.md | done |
| 15 | Verificación final (verificar-curso.ps1 + consistencia) y fixes | — | done |

## Registro de commits (evidencia)

| Commit | Tarea(s) |
|---|---|
| (se completa al cerrar cada tarea) | — |
