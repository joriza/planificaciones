# Encuentro 31 — Cierre U4: entrega final

**Unidad 4:** Profesionalización y proyecto final
**Carácter:** Actitudinal (cierre de unidad)
**Duración:** 240 minutos

---

## Objetivos de aprendizaje

- Presentar y defender individualmente el trabajo final ante el docente.
- Demostrar comprensión de los conceptos fundamentales del curso (tipos canónicos, Dapper, HTTP, Git).
- Evaluar el propio proceso de aprendizaje a lo largo de las cuatro unidades.
- Integrar el repositorio profesional como portafolio de la materia.

---

## Reparto de tiempos (240 minutos)

| Bloque | Minutos |
|---|---|
| Apertura y repaso integrador | 25 |
| Presentación y defensa individual | 130 |
| Retroalimentación y cierre | 25 |
| Cierre de unidad y entrega de notas | 60 |
| **Total** | **240** |

---

## Apertura y repaso integrador (25 min)

### Mapa conceptual del curso

Se proyecta y discute el recorrido completo:

```
Eje 1: Introduccion a C# y .NET 6         ┐
Eje 2: Minimal API y endpoints HTTP       ├─ Unidades 1-2
Eje 3: SQLite y SQL basico                ┘
Eje 4: Dapper y consultas parametrizadas  ┐
Eje 5: CRUD con Dapper                    ├─ Unidad 3
Eje 6: Profesionalizacion y Git           ─ Unidad 4
```

Logro integrador: una API REST funcional, con base de datos real, consultas JOIN, CRUD completo y flujo Git profesional.

### Recordatorio de la dinámica de defensa

- Cada integrante pasa al frente con su computadora.
- Tiene 8 minutos para presentar y 2 minutos para preguntas.
- Debe mostrar el repositorio en GitHub con el README profesional.
- Debe ejecutar la API y probar al menos dos endpoints en vivo.
- Debe explicar una porción del código (asignada por el docente al momento de la defensa).
- El resto del grupo espera su turno y no interrumpe.

---

## Presentación y defensa individual (130 min)

### Orden de presentación

Se sortea el orden al inicio. Cada presentación sigue esta estructura:

1. **Abrir el repositorio en GitHub** (30 segundos).
2. **Mostrar el README** y explicar brevemente el proyecto (1 minuto).
3. **Ejecutar la API** con `dotnet run` (30 segundos).
4. **Probar dos endpoints** en vivo (2 minutos):
   - Un endpoint GET con JOIN (`/patients/with-province` o `/patients/count-by-province`).
   - Un endpoint POST con validación y creación.
5. **Explicar una sección de código** asignada por el docente (2 minutos):
   - El docente elige al azar entre: el record de Patient, un endpoint con JOIN, el bloque de validación del POST, o el flujo Git de una rama feature.
6. **Responder preguntas conceptuales** (2 minutos).

### Preguntas conceptuales posibles (el docente elige 2-3 por alumno)

- "¿Por qué los IDs se declaran como `long` en los records?"
- "¿Qué hace `ExecuteScalar<long>` y por qué se usa en el POST?"
- "¿Cuál es la diferencia entre `Results.Ok`, `Results.Created` y `Results.NoContent`?"
- "¿Por qué usamos alias `AS` en el SELECT?"
- "¿Qué protege la regla de branch protection en main?"
- "¿Qué pasa si no cerramos la conexión con `using`?"
- "¿Cuándo usarías LEFT JOIN en lugar de INNER JOIN?"
- "¿Por qué las fechas son `string` en los records en lugar de `DateTime`?"

---

## Retroalimentación y cierre (25 min)

Luego de las presentaciones, el docente comparte una devolución general:

- Fortalezas observadas en las presentaciones.
- Errores conceptuales recurrentes para aclarar.
- Aspectos técnicos a mejorar para futuros proyectos.

### Rúbrica de evaluación del trabajo final

| Dimensión | Peso | Criterios |
|---|---|---|
| Funcionalidad técnica | 30% | CRUD completo, JOINs, endpoints probados |
| Calidad del código | 20% | Tipos canónicos correctos, alias, `using`, `Results.*` |
| Git profesional | 20% | Issues, ramas, PR revisados, main protegida |
| README profesional | 10% | Completo con instalación, endpoints, integrantes |
| Defensa individual | 20% | Claridad, precisión técnica, respuestas correctas |

---

## Cierre de unidad y entrega de notas (60 min)

### Checklist de entrega final

Cada grupo verifica que su repositorio tenga:

- [ ] Carpeta `trabajo-final/` con `Program.cs` funcional.
- [ ] `hospital.db` junto al `.csproj`.
- [ ] `.gitignore` con `bin/` y `obj/`.
- [ ] README.md completo (nombre, requisitos, instalación, estructura, tecnologías, integrantes, endpoints).
- [ ] Protección de `main` activa.
- [ ] Al menos 2 Pull Requests mergeados en la unidad.
- [ ] Carpetas `tp-u1/`, `tp-u2/`, `tp-u3/` con los trabajos anteriores.

### Recorrido completo del curso

El docente cierra el curso destacando:

1. **Unidad 1:** Fundamentos de C# y primera Minimal API con GET.
2. **Unidad 2:** SQLite, Dapper y consultas parametrizadas.
3. **Unidad 3:** CRUD completo con POST, PUT, DELETE.
4. **Unidad 4:** Profesionalización con Git, README, trabajo final integrador y defensa.

### Entrega de notas y devolución individual

El docente entrega la nota final a cada alumno, con comentarios personalizados sobre su desempeño en la defensa y el trabajo final.

---

## Errores comunes en la defensa

| Error | Causa | Cómo evitarlo |
|---|---|---|
| No poder ejecutar la API porque falta `hospital.db` | La base no se copió al repositorio | Verificar que `hospital.db` esté en el repo y junto al `.csproj`. |
| README incompleto o sin formato | Se dejó para último momento | Completar el README en el encuentro 28 y actualizarlo en el 30. |
| No recordar conceptos básicos (por qué `long`, qué es Dapper) | Estudiar de memoria sin entender | Repasar las convenciones técnicas y el digest de código antes de la defensa. |
| Git: no hay PR, todo en main | No se usaron ramas durante la unidad | Mostrar al menos un PR en el historial del repositorio. |
| Nervios al exponer | Falta de práctica | Practicar la presentación de 5 minutos con un compañero antes del encuentro 31. |