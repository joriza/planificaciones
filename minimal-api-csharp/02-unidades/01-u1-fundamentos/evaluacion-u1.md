# Evaluación de la Unidad 1 — Encuentro 9

> Evaluación del Encuentro 9 — Evaluación de la Unidad 1 (encuentro dedicado) · Curso: Minimal API con C# .NET 6. Documento de **metadatos y acuerdos de la instancia**, en registro docente formal. El material del alumno son las versiones `evaluacion-u1-version-a.md` y `evaluacion-u1-version-b.md`; sus soluciones y criterios de corrección van en los anexos docentes separados (`-anexo-docente.md`).

## 1. Identificación

| Campo | Detalle |
| --- | --- |
| Instancia | Encuentro 9 — Evaluación de la Unidad 1 (encuentro dedicado) |
| Unidad evaluada | 1 — Fundamentos de Minimal API con C# (encuentros 4 a 8) |
| Eje temático | 1 — Fundamentos de Minimal API |
| Carácter/Objetivo | Procedimental |
| Destinatarios | Todo el curso |
| Duración teórica | 240 minutos (4 horas reloj) |
| Uso de celular | No permitido en ningún momento del encuentro |
| Documentos de la instancia | `evaluacion-u1.md` (este documento) · `evaluacion-u1-version-a.md` · `evaluacion-u1-version-b.md` · `evaluacion-u1-version-a-anexo-docente.md` · `evaluacion-u1-version-b-anexo-docente.md` |

## 2. Estructura del encuentro (240 min)

| Momento | Tiempo | Qué ocurre |
| --- | --- | --- |
| Entrega y verificación por GitHub | 30 min | Cada grupo abre su repositorio en el navegador y verifica el estado de la entrega: carpeta `tp-u1/` en la raíz, `.gitignore` sin `bin/` ni `obj/` visibles, commits con mensajes referentes y push publicado. El docente verifica y registra grupo por grupo |
| Defensa individual del TP-u1 | 90 min | Demo del TP + preguntas, integrante por integrante (sección 4) |
| Prueba práctica individual (versiones A/B) | 90 min | Ejercicio pequeño con computadora sobre la Unidad 1, en memoria y sin base de datos (sección 6) |
| Cierre | 30 min | Recolección de las pruebas, registro de resultados y avisos; se anuncia que la devolución abre el encuentro 10 |
| **Total** | **240 min** | |

Nota organizativa: los bloques de defensa y de prueba pueden escalonarse por mitades del aula (mitad defiende mientras la otra mitad resuelve, y luego se invierten), respetando los 90 minutos de cada bloque.

## 3. Regla canónica de la instancia

- La **entrega del trabajo (tp-u1) por GitHub y la defensa individual se realizan en este encuentro** (Encuentro 9).
- El **encuentro siguiente (10) abre con la devolución**, antes de iniciar la Unidad 2.
- Si la entrega no está completa al llegar el encuentro, se aplica la regla de entrega incompleta de `06-aprobacion/criterios-aprobacion.md`: se evalúa lo presentado, se registran objetivo por objetivo los logros y pendientes, y el repositorio del grupo permanece abierto para completar con nuevos commits y push.

## 4. Defensa individual del TP-u1 (modalidad: demo del TP + preguntas)

Cada integrante defiende individualmente la mini API entregada por su grupo:

1. **Demo (parte práctica):** correr la API con `dotnet run`, ejecutar en vivo un tramo de la batería de pruebas del TP (navegador para los GET, `curl.exe` para el resto) y mostrar el código del endpoint que explica, junto con un commit propio del repositorio.
2. **Preguntas (parte oral):** qué ruta atiende el endpoint, qué verbo y qué código de respuesta usa, qué valida y por qué, dónde vive la lista en memoria, y qué hizo git en la entrega (`.gitignore`, commits, `remote add`, `push`).
3. **Registro:** el docente registra, objetivo por objetivo, los cuatro objetivos mínimos de la unidad (sección 5), con observaciones. Cada integrante debe poder explicar al menos un endpoint del TP.

## 5. Alcance: solo Unidad 1

| Núcleos incluidos (evaluados) | Excluidos (no evaluados en esta instancia) |
| --- | --- |
| Crear y correr la API: `dotnet new web`, `dotnet run`, prueba de endpoints en el navegador | Base de datos, SQLite, `hospital.db`, Dapper y SQL (Unidad 2) |
| Endpoint GET con parámetro de ruta (`{id:long}`) que devuelve JSON | `appsettings.json`, `dotnet publish` (Unidad 3) |
| Verbos HTTP y códigos de respuesta con `Results` (200, 201, 204, 400, 404) | Issues, ramas por feature, pull requests y main protegida (Unidad 4) |
| CRUD en memoria: lista estática compartida, record de entrada (DTO) sin id, contador de ids, validación manual | |
| Git local y ciclo de entrega: `git init`, `.gitignore` (`bin/`, `obj/`), `git add` + `git commit` con mensaje referente, repo remoto y `git push` | |

Los cuatro primeros núcleos incluidos son, además, los objetivos mínimos de la unidad según `06-aprobacion/criterios-aprobacion.md`: 1) crear y correr la API; 2) endpoint GET con parámetro de ruta que devuelva JSON; 3) verbos y códigos en un CRUD en memoria (200, 201, 400, 404); 4) ciclo de entrega por GitHub.

## 6. Prueba práctica individual (versiones A y B)

- Ejercicio **pequeño con computadora**, resuelto en 90 minutos, sobre **una mini API en memoria** (sin base de datos), con cuatro partes:
  1. GET de lista + GET por id con parámetro de ruta (200/404).
  2. POST validado (201/400).
  3. DELETE (204/404).
  4. Ítems conceptuales breves: verbos y códigos; mensaje de commit referente.
- Puntaje total: **100 puntos** (30 + 30 + 25 + 15), idéntico en ambas versiones.
- Cada versión incluye el **esqueleto inicial** de `Program.cs` (lista base, contador de ids y records provistos) y la **salida esperada de cada prueba** (navegador o `curl`).
- Condiciones de resolución: sección 8. Contenido y consignas: versiones A y B.

## 7. Criterios de calificación

| Componente | Qué se observa | Registro |
| --- | --- | --- |
| Entrega por GitHub | Carpeta `tp-u1/` en la raíz del repositorio del grupo; `.gitignore` en la raíz, con `bin/` y `obj/` fuera del versionado; commits con mensajes referentes (`tp-u1: resumen`); push visible en GitHub | Verificado / pendiente por grupo, con observaciones |
| Defensa individual | Demo fluida del propio TP y respuestas que evidencian rutas, verbos, códigos, validación y git; explicación de al menos un endpoint por integrante | Logrado / pendiente por objetivo mínimo, con observaciones |
| Prueba práctica | Funcionalidad de los endpoints con códigos correctos (200, 201, 204, 400, 404); validación con 400 y mensaje en español; convenciones del curso (rutas en inglés plural, ids `long`, fechas `string` ISO, `Results`, records al final); batería de verificación ejecutada | Puntaje ítem por ítem, total sobre 100 |

La acreditación de la unidad se resuelve **por objetivos**: el resultado numérico sobre 100 corresponde a la prueba práctica, y la entrega y la defensa completan el registro objetivo por objetivo. Umbrales de acreditación y capas de recuperación: `06-aprobacion/criterios-aprobacion.md`.

## 8. Condiciones de resolución de la prueba

- Resolución estrictamente **individual**, en la computadora asignada al equipo dentro del aula-taller.
- **Sin celular** en ningún momento del encuentro.
- Material consultable: únicamente el provisto con la prueba (enunciado y esqueleto de `Program.cs`); no se consultan apuntes, repos propios ni la web.
- Todo el código en `Program.cs`; el esqueleto provisto trae la lista base, el contador de ids y los records, y **no se modifican**.
- Convenciones obligatorias del curso: rutas en inglés y plural, ids `long`, fechas `string` ISO (`yyyy-MM-dd`), respuestas siempre con `Results`, comentarios en el código.
- Al terminar (o al agotarse el tiempo), el `Program.cs` queda guardado en la carpeta indicada de la máquina y el docente lo verifica y registra in situ. El tiempo agotado no invalida la prueba: se registra la evidencia parcial alcanzada.

## 9. Regla de equivalencia entre las versiones A y B

- **Misma estructura:** mismas partes, mismos objetivos, mismos requisitos y mismo puntaje ítem por ítem (30 + 30 + 25 + 15 = 100).
- **Distinto dominio:** la versión A trabaja el dominio de contacto/mensajes (tickets de soporte, recurso `tickets`); la versión B, el de biblioteca (libros, recurso `books`). Ambas en memoria, sin base de datos.
- **Sin reglas que una tenga y la otra no:** mismos campos obligatorios (título, segundo campo de texto, fecha ISO), mismas validaciones con mensajes equivalentes, mismos códigos de respuesta y misma batería de verificación.
- Propósito: que la versión asignada no otorgue ventaja ni habilite la copia entre compañeros.

Tabla de equivalencia:

| Aspecto | Versión A | Versión B |
| --- | --- | --- |
| Dominio | Soporte técnico: tickets de contacto/mensajes | Biblioteca: libros |
| Recurso (ruta en inglés plural) | `/tickets` | `/books` |
| Record | `Ticket(TicketId, Title, Priority, CreatedDate)` | `Book(BookId, Title, Author, PublishedDate)` |
| Record de entrada (DTO) | `TicketInput`, sin id | `BookInput`, sin id |
| Datos iniciales | 3 tickets (ids 1 a 3; contador en 4) | 3 libros (ids 1 a 3; contador en 4) |
| Partes y puntaje | 30 + 30 + 25 + 15 = 100 | 30 + 30 + 25 + 15 = 100 |
| Validaciones, códigos y reglas | Idénticas en ambas versiones | Idénticas en ambas versiones |

## 10. Mecánica de asignación de versiones

- La versión (A o B) se asigna por posición en el aula o por grupos, según lo defina el docente al iniciar la prueba (por ejemplo, filas alternadas de máquinas).
- La asignación se comunica al comenzar la prueba y se registra en la planilla de resultados (alumno → versión).
- La prueba es individual: integrantes de un mismo grupo de trabajo pueden tener versiones distintas; eso no afecta ni la prueba ni al grupo.

## 11. Devolución

- El **encuentro 10 abre con la devolución**: corrección escrita individual ítem por ítem (qué puntúa, qué no y por qué) y comentarios generales al curso, antes de iniciar la Unidad 2.
- Los objetivos no alcanzados se traducen en pistas de recuperación según las capas de `06-aprobacion/criterios-aprobacion.md`: devolución y reincorporación en las clases siguientes; intensificaciones 17-18 si el pendiente persiste.
- La planilla de resultados registra: alumno, versión (A/B), puntaje por parte, total sobre 100, objetivos mínimos logrados/pendientes y observaciones de la defensa.
