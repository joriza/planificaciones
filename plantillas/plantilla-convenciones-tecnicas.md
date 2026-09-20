# Plantilla — Convenciones técnicas — ⟨nombre del curso⟩

> Plantilla en blanco para la hoja de convenciones técnicas de una materia con código. El LLM la usa en la **Fase 0** de `0-prompt-plantilla-planificacion.md` para redactar `<curso>/convenciones-tecnicas.md`.
> Insumos: el **archivo de materia** (`materias/<materia>.md`), la **documentación de la base** (`database-docs/`, si existe) y el **digest de código** (`plantillas/digest-codigo.md`), adaptándolo si el stack no es C#.
> La hoja redactada entra en el **FRENO de Fase 0** junto con el curso-data: una vez validada y editada por el docente, es **canon** de la materia — ante conflicto manda la hoja.
> Al completarla: llenar cada ⟨marcador⟩, conservar la estructura de 9 secciones y borrar las líneas de instrucción y esta nota. Hoja terminada de referencia: `minimal-api-csharp/convenciones-tecnicas.md`.

## Regla de autoría — spike de verificación

**Ninguna regla de tipos, mapeo o respuestas se declara de memoria: toda regla nace de un spike de verificación.** Antes de redactar las secciones 4, 5, 6 y 9:

1. Crear un **proyecto descartable** con el stack real de la materia y la fuente de datos real (la base declarada en el archivo de materia), fuera de la carpeta del curso.
2. **Compilar** y **ejecutar** en él los 2-3 casos límite de las reglas que la hoja va a fijar.
3. Registrar el **comportamiento observado** (no el esperado) y anotar el error o la respuesta observada como evidencia en la sección 9.
4. Borrar el proyecto descartable al terminar.

Ejemplo: con SQLite + Dapper, declarar un record con id `int` en lugar de `long` y lanzar un GET contra la base real: se observa el fallo de mapeo (500) donde con `long` hay 200; ese error observado, no la teoría, es lo que se escribe en la hoja.

Si la hoja se recrea desde cero (la carpeta del curso fue borrada), **el spike es obligatorio**: la hoja nace de ejecutar, como en la corrida original.

---

## Encabezado de la hoja

Título, blockquote de canon y tabla de identificación, con los datos de la materia:

> **Canon del curso.** Esta hoja es la fuente única de verdad de tipos, formatos y estructura de código de la materia «⟨nombre del curso⟩». Todos los documentos de la materia la obedecen: **toda divergencia con esta hoja es un defecto**, no una variación de estilo.

| Campo | Valor |
| --- | --- |
| Curso | ⟨nombre del curso⟩ |
| Registro | ⟨a quién va dirigida la hoja, p. ej. docente y alumnos⟩ |
| Base de datos canónica | ⟨motor, archivo y tablas; borrar la fila si no hay base⟩ |
| Referencias de apoyo | ⟨documentos de apoyo usados, p. ej. `database-docs/`⟩ |

## 1. Propósito y alcance

> Derivar del archivo de materia: qué fija la hoja y qué queda fuera de su alcance.

- Esta hoja define los **⟨tipos de datos, formatos y estructura del código⟩** de todo el curso: ⟨ejemplos de clase, anexos, evaluaciones y trabajos de alumnos⟩.
- Ante cualquier duda técnica, **esta hoja decide**: el ajuste se hace primero acá y recién después se propaga a los documentos derivados. Nunca al revés.
- **Alcance:** ⟨entorno y estructura del proyecto, estilo de código, tipos canónicos, acceso a datos, respuestas HTTP, control de versiones y prueba de la API⟩.
- **Fuera de alcance:** ⟨el contenido de cada encuentro (lo fija la planificación anual) y el formato pedagógico de los documentos (lo fija `estructura-de-la-clase.md`)⟩.

## 2. Entorno y estructura del proyecto

> Derivar del archivo de materia (entorno de trabajo y restricción de archivos) y verificar con el spike.

- **Entorno:** ⟨editor + herramientas del alumno⟩.
- **Proyecto:** ⟨cómo se crea, cómo se ejecuta y cómo se corta⟩.
- **Dónde vive el código:** ⟨archivo(s) permitidos y su organización interna; qué carpetas o archivos quedan prohibidos⟩.
- **Archivos extra:** ⟨solo los estrictamente necesarios, con su ubicación⟩.

## 3. Estilo de código

> Derivar del archivo de materia (idioma de identificadores, densidad de comentarios y estilo de ejemplos).

- **Idiomas:** ⟨idioma de identificadores y rutas; idioma del texto visible y de los comentarios⟩.
- **Comentarios:** ⟨densidad y regla, p. ej. cada acción del código explicada⟩.
- **Ejemplos:** ⟨tamaño y condición de los ejemplos, p. ej. mínimos, completos, que compilen y corran tal cual⟩.
- **Prohibido:** ⟨abstracciones o estructuras fuera del alcance de la materia⟩.

## 4. Tipos canónicos (BD ↔ lenguaje)

> Derivar del esquema de `database-docs/` y del spike: cada fila se verifica contra la base real antes de escribirse.

Tipos únicos para todo el curso, tanto en ejemplos como en trabajos de alumnos:

| Dato en la BD | Tipo en el lenguaje | Ejemplo | Regla |
| --- | --- | --- | --- |
| ⟨clave (id)⟩ | ⟨tipo⟩ | ⟨cómo se declara⟩ | ⟨por qué, con el comportamiento observado en el spike⟩ |
| ⟨fecha⟩ | ⟨tipo⟩ | ⟨cómo se declara⟩ | ⟨regla observada⟩ |
| ⟨texto opcional (NULL)⟩ | ⟨tipo⟩ | ⟨cómo se declara⟩ | ⟨regla⟩ |

**Mapeo de nombres:** ⟨convención de columnas vs. propiedades y cómo se resuelve (alias, atributos, etc.)⟩.

**Fechas:** ⟨cómo viajan y cuándo se convierten⟩.

## 5. Acceso a datos

> Derivar del archivo de materia (tecnología de acceso) y del spike: el ejemplo canónico se ejecuta antes de escribirse.

- **Conexión:** ⟨cadena o patrón de conexión y dónde se abre y cierra⟩.
- **Consultas SIEMPRE parametrizadas:** ⟨mecanismo de parámetros; jamás concatenar datos al texto de la consulta⟩.
- **Operaciones usadas en el curso:** ⟨lista cerrada de métodos o funciones de lectura y escritura⟩.

Ejemplo canónico mínimo, completo y funcional (⟨operación de lectura⟩):

```⟨lenguaje⟩
⟨ejemplo ejecutado en el spike, con comentario en cada acción⟩
```

## 6. Respuestas HTTP y errores

> Derivar del spike: cada código se observa una vez antes de entrar a la tabla.

| Código | Cuándo se usa | Método canónico | Ejemplo |
| --- | --- | --- | --- |
| `200` | ⟨lectura o reemplazo correcto⟩ | ⟨método⟩ | ⟨ejemplo⟩ |
| `201` | ⟨alta correcta⟩ | ⟨método⟩ | ⟨ejemplo⟩ |
| `204` | ⟨borrado o actualización sin cuerpo⟩ | ⟨método⟩ | ⟨ejemplo⟩ |
| `400` | ⟨pedido inválido⟩ | ⟨método⟩ | ⟨ejemplo⟩ |
| `404` | ⟨recurso inexistente⟩ | ⟨método⟩ | ⟨ejemplo⟩ |

> **Regla condicional** ⟨si aplica: una operación con comportamiento distinto según el contexto del curso, con su por qué observado⟩. Borrar este bloque si no hay regla condicional.

- ⟨código de error de servidor⟩ **nunca** se devuelve a propósito: ⟨cómo se diagnostica cuando aparece⟩.
- ⟨formato de los mensajes de error visibles al alumno⟩.

## 7. Control de versiones del alumno

> Derivar del archivo de materia (herramientas de entrega).

- **Repositorio:** ⟨uno por grupo, una carpeta por trabajo, etc.⟩.
- **Ramas:** ⟨política de ramas por tramo del curso⟩.
- **Ignorados:** ⟨qué nunca se versiona y desde cuándo⟩.
- **Rutina de cierre:** ⟨comandos de cada entrega y convención de mensajes⟩.

## 8. Probar la API

> Derivar del stack y verificar con el spike.

- **⟨Lecturas⟩:** ⟨herramienta y modo de uso⟩.
- **⟨Resto de las operaciones⟩:** ⟨herramienta, formato del pedido y cómo se lee la respuesta⟩.
- **Puerto:** ⟨de dónde sale y qué se asume en los ejemplos⟩.

## 9. Checklist de defectos frecuentes

> Derivar del spike y de los defectos conocidos del curso: cada fila cita un comportamiento observado, no una sospecha.

Verificación rápida antes de cerrar cualquier ejemplo o trabajo:

| ✔ | Defecto | Por qué falla | Corrección |
| --- | --- | --- | --- |
| ☐ | ⟨defecto observado en el spike o conocido del curso⟩ | ⟨comportamiento observado⟩ | ⟨corrección canónica⟩ |

---

> Nota: `plantillas/digest-codigo.md` es de la familia C#/Minimal API. Para otro stack, adaptar el digest junto con esta hoja antes de la Fase 2, de modo que los writers reciban una dieta coherente.
