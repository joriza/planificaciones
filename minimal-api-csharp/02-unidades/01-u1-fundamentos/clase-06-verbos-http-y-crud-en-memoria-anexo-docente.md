# Anexo docente — Encuentro 6: Verbos HTTP y CRUD en memoria

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

El ejercicio se resuelve **sobre** el `Program.cs` de la práctica guiada: se agrega un endpoint y se ejecuta el ciclo completo con `curl`. No se reemplaza ningún endpoint.

### Código agregado (ubicación: junto a los demás GET, antes de `app.Run()`)

```csharp
// GET /doctors/count: cuantos doctors hay en el cuaderno
// Ruta literal: "count" no es un numero, asi que no choca con {id:long}
app.MapGet("/doctors/count", () =>
{
    // Count cuenta los elementos de la lista
    return Results.Ok(new { total = doctors.Count });
});
```

### Ciclo completo esperado (con salida verificada)

```powershell
# 1) POST: alta del doctor propio del grupo -> 201
curl.exe -i -X POST http://localhost:5080/doctors -H "Content-Type: application/json" -d "{\"firstName\":\"Sofia\",\"lastName\":\"Vera\",\"specialty\":\"Oftalmologia\"}"
```

```text
HTTP/1.1 201 Created
Location: http://localhost:5080/doctors/5

{"doctorId":5,"firstName":"Sofia","lastName":"Vera","specialty":"Oftalmologia"}
```

```powershell
# 2) GET por id -> 200
curl.exe -i http://localhost:5080/doctors/5

# 3) PUT reemplazo -> 200
curl.exe -i -X PUT http://localhost:5080/doctors/5 -H "Content-Type: application/json" -d "{\"firstName\":\"Sofia\",\"lastName\":\"Vera De Luduena\",\"specialty\":\"Oftalmologia\"}"

# 4) DELETE -> 204
curl.exe -i -X DELETE http://localhost:5080/doctors/5

# 5) GET final -> 404
curl.exe -i http://localhost:5080/doctors/5
```

Códigos observados en orden: **201 → 200 → 200 → 204 → 404**. La última respuesta 404 es correcta: el recurso ya no existe.

### Comportamiento esperado de `/doctors/count`

| Momento | Respuesta esperada |
| --- | --- |
| Antes del DELETE del ciclo | `{"total":4}` o el valor que corresponda a la lista del grupo |
| Después del DELETE del ciclo | El total baja en 1 (por ejemplo `{"total":3}`) |

## 2. Solución de la actividad de extensión

1. **Filtro por especialidad** — con comparación insensible a mayúsculas en los dos lados; una búsqueda sin resultados devuelve 200 con lista vacía, no 404 (el 404 queda reservado para el id inexistente de un recurso puntual). Decisión de diseño para comentar con el grupo.
2. **Exploración del 415:** el POST sin `Content-Type: application/json` responde `415 Unsupported Media Type`. Conclusión esperada: el header le dice a la API cómo leer el cuerpo.
3. **Cuadro propio:** se corrige en el pizarrón comparando contra el cuadro del encuentro; las rutas deben quedar en inglés y plural.
4. **Auditoría del cuaderno:** los commits del día deben seguir la convención `u1-clase-06: ...` con resumen en minúsculas y sin tildes.

### Implementación de referencia del ítem 1

```csharp
// GET /doctors/by-specialty/{specialty}: doctors de una especialidad
app.MapGet("/doctors/by-specialty/{specialty}", (string specialty) =>
{
    // ToLower en los DOS lados: la comparacion con == distingue mayusculas
    var found = doctors.FindAll(d => d.Specialty.ToLower() == specialty.ToLower());

    // Lista vacia no es error: es una respuesta valida con codigo 200
    return Results.Ok(found);
});
```

## 3. Respuesta esperada del ejercicio

| Pedido | Código esperado | Cuerpo esperado |
| --- | --- | --- |
| `GET /doctors/count` (antes del ciclo) | 200 | `{"total":<n>}` |
| `POST /doctors` (datos completos) | 201 | Doctor nuevo + header `Location` |
| `GET /doctors/{id}` recién creado | 200 | JSON del doctor |
| `PUT /doctors/{id}` (datos completos) | 200 | JSON reemplazado |
| `DELETE /doctors/{id}` | 204 | Sin cuerpo |
| `GET /doctors/{id}` final | 404 | `{"mensaje":"No existe el doctor"}` |
| `GET /doctors/count` (después del ciclo) | 200 | `{"total":<n-1>}` |

## 4. Criterios de corrección (lista de verificación)

| ✔ | Criterio |
| --- | --- |
| ☐ | `GET /doctors/count` existe y devuelve `{"total":...}` con `Results.Ok` |
| ☐ | El total baja después de un DELETE (estado compartido verificado) |
| ☐ | El grupo ejecutó el ciclo completo POST → GET → PUT → DELETE → GET y anotó los cinco códigos |
| ☐ | Los códigos anotados coinciden con 201, 200, 200, 204 y 404 |
| ☐ | La rutina de git se cumplió: commit con mensaje `u1-clase-06: ...` |
| ☐ | El cuadro de referencia rápida quedó disponible para el grupo (cuaderno o apuntes) |
| ☐ | Al menos un integrante explica por qué el record se reemplaza y no se edita |

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| Error CS8803 al compilar | Records declarados antes de `app.Run()` | Leer juntos el mensaje del compilador; mover los records al final del archivo |
| Los datos «desaparecen» entre pedidos | Lista declarada dentro de un handler | Replantear con la analogía del cuaderno: un cuaderno por ventanilla no funciona; la lista vive una sola vez, arriba |
| POST responde 415 | Falta el header `Content-Type: application/json` | Mostrar la línea del comando incompleta; comparar con el comando de la guía |
| POST responde 404 | Faltó `-X POST` (curl mandó GET) | Hacer notar la diferencia entre la ruta `GET /doctors` y `POST /doctors` |
| PUT no compila: asignación sobre record | `doctor.FirstName = ...` sobre un record inmutable | Explicar la inmutabilidad del record y mostrar el reemplazo con `IndexOf` |
| Borrar dos veces el mismo id «falla» | Segunda respuesta 404 leída como error | Validar que es el comportamiento correcto: el recurso ya no estaba |
| El total de `/doctors/count` no cambia | Probaron contra una API sin reiniciar tras editar | Rutina de siempre: `Ctrl+S`, `Ctrl+C`, `dotnet run` |

## 6. Registro de la clase

- Registrar por grupo: CRUD completo funcionando, códigos verificados y commit del día (insumo de la evaluación de proceso de la Unidad 1).
- Guardar los cuadros de referencia de los grupos: se usan en el encuentro 7 como diseño previo de la API de pacientes.
