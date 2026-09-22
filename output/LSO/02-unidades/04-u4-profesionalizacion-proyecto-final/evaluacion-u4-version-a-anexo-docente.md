# Anexo docente — Evaluación de la Unidad 4 — Encuentro 32 — Versión A

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión A, las respuestas esperadas de los ítems conceptuales, los criterios de corrección ítem por ítem y la pauta de devolución.

## 1. Solución completa — Flujo de profesionalización

### 1.1 Creación de la rama por feature

```bash
git checkout main
git pull origin main
git checkout -b feature/get-doctors
```

### 1.2 Resolver el issue

El alumno implementa el endpoint `GET /doctors` en su repositorio local, hace commit y push a la rama `feature/get-doctors`.

### 1.3 Abrir la PR

Desde GitHub, se abre una Pull Request de `feature/get-doctors` a `main` con una descripción clara:

```
Implementación del endpoint GET /doctors

- Agrega el record Doctor con tipos canónicos (long para DoctorId)
- Implementa GET /doctors que retorna la lista completa de doctores
- Implementa GET /doctors/{doctorId:long} con manejo de 404
- Usa consultas parametrizadas y alias AS en todos los SELECT
- Sigue las convenciones del curso (convenciones-tecnicas.md)
```

### 1.4 Revisión de la PR

El docente (o un compañero) revisa la PR y agrega al menos un comentario de revisión aprobándola o sugiriendo mejoras.

### 1.5 Merge a main

Una vez aprobada la PR, se realiza el merge a `main`. La rama `feature/get-doctors` se puede eliminar después del merge.

### 1.6 Protección de main

En la configuración del repositorio GitHub:
1. Ir a Settings → Branches → Branch protection rules → Add rule.
2. Branch name pattern: `main`.
3. Marcar "Require a pull request before merging".
4. Marcar "Require approvals" y establecer al menos 1.
5. Marcar "Include administrators" si aplica.
6. Guardar la regla.

## 2. Solución del ejercicio de profesionalización

El ejercicio de profesionalización evalúa que el alumno pueda:
1. Crear una rama por feature desde `main`.
2. Trabajar en la rama sin afectar `main`.
3. Abrir una PR con descripción clara.
4. Recibir y aplicar revisión de PR.
5. Hacer merge a `main` solo después de la aprobación.
6. Demostrar que `main` está protegida contra push directo.

## 3. Respuestas esperadas de los ítems conceptuales

| Ítem | Pregunta | Respuesta esperada |
| --- | --- | --- |
| 4.1 | ¿Por qué se protege la rama `main`? | Para evitar pushes directos que puedan romper la rama principal; toda changes debe pasar por revisión de PR. Esto asegura que solo código revisado y aprobado llegue a la rama principal. |
| 4.2 | ¿Qué diferencia hay entre una rama por feature y trabajar directamente en `main`? | Las ramas por feature aislán los cambios, permiten revisión, y facilitan la trazabilidad de cada mejora. Trabajar directamente en `main` mezcla cambios, dificulta la reversión y no permite revisión previa. |

## 4. Criterios de corrección ítem por ítem

| Ítem | Puntos | Qué se observa | Error previsto | Intervención |
| --- | --- | --- | --- | --- |
| 1.1 Crear rama por feature | 10 | La rama `feature/get-doctors` existe y parte de `main`. | Rama creada desde otra rama; nombre incorrecto. | Verificar la rama y su origen en `main`. |
| 1.2 Resolver el issue en la rama | 10 | El endpoint GET /doctors está implementado en la rama de feature. | Endpoint no funcional; cambios en `main` directamente. | Verificar que los cambios están en la rama de feature y no en `main`. |
| 1.3 Abrir PR con descripción | 10 | La PR está abierta desde `feature/get-doctors` a `main` con descripción clara. | PR sin descripción; dirección incorrecta de la PR. | Verificar la dirección y la descripción de la PR. |
| 1.4 Revisión de la PR | 10 | Al menos un comentario de revisión en la PR. | Sin revisión; revisión genérica sin contenido. | Verificar que existe al menos un comentario de revisión sustantivo. |
| 2.1 Protección de main | 15 | La rama `main` tiene protección que requiere al menos 1 revisión de PR. | Protección no configurada; configuración incorrecta. | Verificar la configuración de protección de ramas en GitHub. |
| 2.2 Demostrar que no es posible push directo | 10 | El alumno explica o demuestra que el push directo a `main` está bloqueado. | No puede explicar la protección; intenta push directo y falla. | Verificar que el alumno entiende el propósito de la protección. |
| 3.1 README de portada | 20 | El README incluye título, descripción, instalación, uso de la API, y convenciones. | README incompleto; sin instrucciones de uso; sin convenciones. | Verificar que todas las secciones requeridas están presentes. |
| 4.1 Pregunta conceptual protección de main | 8 | Respuesta correcta sobre el propósito de proteger `main`. | Respuesta incorrecta o incompleta. | Guiar al alumno a recordar el propósito de las ramas protegidas. |
| 4.2 Pregunta conceptual rama por feature | 7 | Respuesta correcta sobre la diferencia entre rama por feature y `main`. | Respuesta incorrecta o incompleta. | Guiar al alumno a recordar los beneficios del aislamiento de cambios. |

## 5. Pauta de devolución

Se devuelve la evaluación con los puntos obtenidos por cada ítem. Se indica qué ítems están pendientes y qué correcciones se esperan. Si el alumno no alcanza 60 puntos, se le asigna la versión alternativa (B) para recuperación. Se registra la nota en la planilla con los comentarios del docente.