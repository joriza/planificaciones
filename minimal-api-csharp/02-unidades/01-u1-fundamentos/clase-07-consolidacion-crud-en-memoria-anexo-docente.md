# Anexo docente — Encuentro 7: Consolidación, CRUD en memoria

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

Se agregan dos endpoints de lectura al `Program.cs` de la práctica guiada. Ubicación: junto a los demás GET, antes de `app.Run()`.

```csharp
// GET /patients/by-gender/{gender}: pacientes de un genero
app.MapGet("/patients/by-gender/{gender}", (string gender) =>
{
    // ToLower en los DOS lados: la comparacion con == distingue mayusculas
    var found = patients.FindAll(p => p.Gender.ToLower() == gender.ToLower());

    // Lista vacia es una respuesta valida: 200 con []
    return Results.Ok(found);
});

// GET /patients/count: cuantos pacientes hay en el cuaderno
app.MapGet("/patients/count", () =>
{
    return Results.Ok(new { total = patients.Count });
});
```

### Tabla de verificación esperada (modelo de respuesta)

| Pedido | Código esperado | Código observado |
| --- | --- | --- |
| `GET /patients` (navegador) | 200 | 200 |
| `GET /patients/2` (navegador) | 200 | 200 |
| `GET /patients/99` | 404 | 404 |
| `POST /patients` completo | 201 | 201 |
| `POST /patients` con `firstName` vacío | 400 | 400 |
| `PUT /patients/1` completo | 200 | 200 |
| `DELETE /patients/3` | 204 | 204 |
| `GET /patients/by-gender/f` | 200 | 200 |
| `GET /patients/count` | 200 | 200 |

La tabla del grupo puede tener más filas, pero debe incluir al menos un 400 y un 404, con los cuerpos de mensaje leídos y coincidentes.

### Respuestas esperadas de los endpoints nuevos

```text
http://localhost:5080/patients/by-gender/F   ->   [{"patientId":1,"firstName":"Ana","lastName":"Garcia","gender":"F","birthDate":"2001-03-14"},{"patientId":3,"firstName":"Carla","lastName":"Perez","gender":"F","birthDate":"2003-07-25"}]

http://localhost:5080/patients/by-gender/x   ->   []

http://localhost:5080/patients/count         ->   {"total":3}
```

## 2. Solución de la actividad de extensión

### Ítems 1 y 2: validaciones extra en POST y PUT

```csharp
// Validacion del genero: solo M o F (ignorando mayusculas).
// Va junto a los demas chequeos, antes de crear el paciente.
var gender = input.Gender?.Trim().ToUpper();
if (gender != "M" && gender != "F")
{
    return Results.BadRequest(new { mensaje = "El genero debe ser M o F" });
}

// Validacion de la fecha: TryParse devuelve true si el texto es interpretable
// como fecha. La fecha sigue viajando como string ISO; solo se valida al entrar.
if (!DateTime.TryParse(input.BirthDate, out _))
{
    return Results.BadRequest(new { mensaje = "La fecha no es valida" });
}
```

Notas para la defensa: el orden de los chequeos se conserva (404 primero en PUT, después los 400); las validaciones nuevas se agregan a POST **y** a PUT; y la fecha sigue guardándose tal como llegó, como string ISO, sin conversiones en el record.

### Ítem 3: búsqueda por texto

```csharp
// GET /patients/search/{text}: nombre o apellido que contenga el texto
app.MapGet("/patients/search/{text}", (string text) =>
{
    var found = patients.FindAll(p =>
        p.FirstName.ToLower().Contains(text.ToLower()) ||
        p.LastName.ToLower().Contains(text.ToLower()));

    // Sin resultados: 200 con lista vacia. El 404 queda para el id inexistente
    return Results.Ok(found);
});
```

### Ítem 4: ensayo de defensa

Se escucha a cada integrante un minuto por endpoint. Criterio de aprobación del ensayo: nombra la ruta exacta, el verbo, los códigos posibles (feliz y de error) y la validación. Las debilidades detectadas se anotan: son la guía del acompañamiento en el trabajo del TP del encuentro 8.

## 3. Respuesta esperada del ejercicio

| Pedido | Respuesta esperada |
| --- | --- |
| `GET /patients/by-gender/f` | Array con Ana y Carla (200) |
| `GET /patients/by-gender/M` | Array con Bruno (200) |
| `GET /patients/by-gender/x` | `[]` (200) |
| `GET /patients/count` | `{"total":3}` o el valor vigente de la lista del grupo |
| `git log --oneline` | Commits del día con mensajes `u1-clase-07: ...` |

## 4. Criterios de corrección (lista de verificación)

| ✔ | Criterio |
| --- | --- |
| ☐ | `/patients/by-gender/{gender}` filtra comparando en minúsculas y devuelve 200, también con lista vacía |
| ☐ | `/patients/count` devuelve `{"total":...}` con `Results.Ok` |
| ☐ | La tabla de verificación del grupo tiene al menos ocho filas, con un 400 y un 404, y los códigos observados coinciden con los esperados |
| ☐ | Los endpoints guiados siguen intactos y pasando su batería |
| ☐ | La rutina de git se cumplió: commit `u1-clase-07: ...` |
| ☐ | Los cuatro integrantes pasaron el ensayo de defensa de un endpoint |

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| El PUT borra la validación existente | El grupo reescribió el endpoint desde cero en lugar de agregar chequeos | Mostrar el diff del commit: qué líneas cambiaron; la validación del PUT debe igualar la del POST |
| `/patients/by-gender/F` devuelve lista vacía | Comparación sensible a mayúsculas | Preguntar qué devuelve `"F" == "f"` en C#; guiar hacia `ToLower()` en los dos lados |
| El count no cambia tras un DELETE | Se probó contra la API sin reiniciar, o el DELETE falló con 404 y nadie leyó el código | Revisar la columna «código observado» de la tabla: si hay filas sin código, no hay batería |
| La búsqueda por texto devuelve 404 cuando no encuentra | Confusión entre recurso puntual y búsqueda | Replantear: la búsqueda existió y su resultado es vacío; 200 con `[]`. El 404 es para el id que no existe |
| Validación de fecha con `==` contra formatos | Quieren comparar el string completo | Mostrar `DateTime.TryParse` y aclarar: se valida que sea fecha, se guarda como string ISO |
| Tabla de verificación «esperado = observado» sin ejecutar | Se completó de memoria | Pedir repetir dos filas al azar frente al docente, con la terminal visible |

## 6. Registro de la clase

- Registrar por grupo: tabla de verificación revisada, endpoints nuevos funcionando, commit del día y resultado del ensayo de defensa (insumo directo para el acompañamiento del TP en el encuentro 8).
- Anotar los grupos con las extensiones 1 y 2 completas: son candidatos a desafíos de profundización en el TP.
