# Anexo docente — Encuentro 6: Formato JSON y rutas

> Material de uso interno docente. No se distribuye a estudiantes.
> Curso: Desarrollo de APIs con C# .NET 6 (Minimal API) · Unidad 1 — Fundamentos de C#, Git/GitHub y Minimal API

## Encuadre

| Campo | Detalle |
| --- | --- |
| Encuentro | 6 — «Formato JSON y rutas» (planificación anual) |
| Ejercicio evaluado | `GET /recepcion/{paciente}` con objeto JSON de tres campos |
| Momento del bloque | Ejercicio independiente (55 min) + puesta en común y cierre (20 min) |
| Insumos | Proyecto `FichasApi` de la práctica guiada, con `/ficha`, `/expediente/{id:int}` y `/saludo` funcionando |

## Solución esperada

Se agrega al `Program.cs` de la práctica, junto a los demás endpoints:

```csharp
// Solucion del ejercicio: endpoint de recepcion.
// Parametro de ruta de texto + objeto anonimo con tres campos.
app.MapGet("/recepcion/{paciente}", (string paciente) => new
{
    Nombre = paciente,   // el valor viaja en la URL
    Sala = "Admisión",   // texto fijo
    Prioridad = 1        // numero: sin comillas
});
```

Salida esperada para `GET /recepcion/Ana` (claves en camelCase, como se explicó en la observación de la práctica):

```json
{
  "nombre": "Ana",
  "sala": "Admisión",
  "prioridad": 1
}
```

Se acepta cualquier nombre probado en la ruta (responde 200 con el texto recibido) y la declaración de `Prioridad` como valor directo `1`.

No se considera logro: devolver texto interpolado con `$"..."` en lugar de un objeto; agregar campos de más o de menos; escribir `Prioridad = "1"` (texto en lugar de número); colocar el objeto dentro de corchetes (devuelve un arreglo con un objeto adentro).

## Criterios de logro

| # | Criterio | Evidencia observable |
| --- | --- | --- |
| 1 | La ruta `/recepcion/{paciente}` responde para cualquier nombre | 200 en el navegador con el texto enviado |
| 2 | La respuesta es JSON, no texto plano | Llaves y claves entre comillas, igual que `/ficha` |
| 3 | El objeto tiene exactamente `Nombre`, `Sala` y `Prioridad` | Tres claves en la salida, sin extras |
| 4 | Los tipos son correctos: `Nombre` y `Sala` texto, `Prioridad` número | `"Admisión"` entre comillas; `1` sin comillas |
| 5 | Sabe explicar la diferencia con `/saludo` | Menciona texto plano versus JSON con palabras propias |

## Qué observar durante la práctica

- **Comprensión de JSON versus texto plano:** es el núcleo conceptual del encuentro. Pedir que comparen `/saludo` con `/recepcion` y expliquen cuál es JSON y por qué. Quien dice "son casi iguales" todavía no distingue estructura de contenido.
- **Predicción antes de probar:** que anuncien la salida esperada antes de abrir el navegador. Quien no predice está copiando.
- **Coincidencia de nombres:** el parámetro de la ruta (`{paciente}`) y el del handler (`string paciente`) deben llamarse igual; si no coinciden, el valor no llega.
- **Prueba rápida de cambio:** pedir cambiar `Prioridad` a `2` y predecir la salida antes de recargar; detecta copia mecánica.

## Ajustes

- **Si avanza con facilidad:** agregar un cuarto campo `Alergias` como arreglo de textos (`new[] { "Ninguna conocida" }`), o un segundo endpoint `/recepcion/{paciente}/sala` que devuelva solo la sala.
- **Si se traba:** partir de `/ficha` y reemplazar los valores fijos por el parámetro; recordar que el objeto va después de `=>` sin `return`; revisar la coincidencia de nombres ruta/handler.
- **Error frecuente a anticipar:** envolver el objeto en corchetes y devolver un arreglo con un elemento. Mostrar la diferencia de salida en la puesta en común.

## Recordatorio operativo

Verificar en los últimos minutos que cada estudiante haya hecho commit y push del proyecto de la clase (rutina desde el Encuentro 5): `git add .` → `git commit -m "Clase 6: formato JSON y rutas con parametros"` → `git push`.
