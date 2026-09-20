# Evaluación de la Unidad 1 — Versión A: Guardia del hospital

## Datos

| Campo | Detalle |
|---|---|
| Grupo | ................................ |
| Versión | A — Guardia del hospital |
| Encuentro | 9 — Evaluación de la Unidad 1 |
| Duración teórica | 4 h |
| Entrega | Carpeta `tp-u1` del repositorio del grupo (commit y push antes del cierre) |

## Consigna

El hospital necesita administrar sus medicos de guardia. Construyan en Program.cs un CRUD en memoria de medicos de guardia con una Minimal API.

Modelo a usar:

```csharp
record MedicoGuardia(int Id, string Nombre, string Especialidad);
```

## Requisitos

1. Crear un proyecto Minimal API nuevo (`dotnet new web`) dentro de la carpeta `tp-u1` del repositorio del grupo.
2. Definir el record `MedicoGuardia` y una lista en memoria (`List<MedicoGuardia>`) con al menos 2 medicos precargados.
3. Implementar `GET /medicos` (devuelve la lista completa) y `GET /medicos/{id:int}` (devuelve un medico por Id; responde 404 si no existe).
4. Implementar `POST /medicos` que agregue un medico y responda 201.
5. Implementar `DELETE /medicos/{id:int}` que responda 204 al eliminar y 404 si el medico no existe.
6. Validar en el POST: si el Id ya está registrado, rechazar la operación con 400 y un mensaje claro.
7. Entregar con Git: `git add`, commit con mensaje referente y push antes del cierre del encuentro.

## Pautas de trabajo

- Sin abstracciones: todo el código va en Program.cs, tal como se trabajó en la unidad.
- Incluir comentarios que expliquen las decisiones tomadas (qué hace cada endpoint y por qué se eligió cada código de respuesta).
- Las consultas al docente son solo sobre la consigna, no sobre el código.
- El trabajo se realiza en grupo sobre el repositorio propio; no se comparte código con otros grupos.

## Qué se evalúa

| Criterio | Puntaje |
|---|---|
| API funcionando sin errores | 30 |
| Estructura y claridad del código en Program.cs | 20 |
| Códigos de respuesta y validaciones correctos | 20 |
| Entrega por Git (carpeta tp-u1, commits referentes, push) | 15 |
| Defensa individual (explicar y modificar algo menor del código) | 15 |
| **Total** | **100** |

Se aprueba con 60 puntos o más y defensa individual realizada.
