# Anexo docente — Encuentro 4: Primer proyecto Minimal API

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente (Program.cs completo)

```csharp
// Program.cs - Encuentro 4: ejercicio independiente (solucion del docente)
// Tres endpoints de texto agregados por el grupo sobre la base de la practica.

// 1) Prepara el programa
var builder = WebApplication.CreateBuilder(args);

// 2) Construye la aplicacion
var app = builder.Build();

// Endpoint guiado de la practica: se conserva como referencia
app.MapGet("/hola", () => "Hola desde la primera Minimal API!");

app.MapGet("/estado", () => "La API esta funcionando");

// ---- Endpoints del ejercicio independiente ----

// /equipo: los integrantes del grupo, separados por coma
app.MapGet("/equipo", () => "Integrantes: Ana, Bruno, Carla, Diego");

// /escuela: nombre de la escuela y especialidad que cursa el grupo
app.MapGet("/escuela", () => "EETP - Especialidad: Programacion");

// /frase: una frase elegida por el grupo
app.MapGet("/frase", () => "Primero funciona, despues se embellece");

// 4) Deja la API escuchando pedidos
app.Run();
```

Los textos entre comillas son de ejemplo: cada grupo escribe los suyos. Lo verificable es la estructura: tres `MapGet` adicionales, cada uno con su ruta y su string a la derecha de la flecha.

## 2. Solución de la actividad de extensión

1. **`/version`**, con el mismo patrón de `MapGet`: `app.MapGet("/version", () => "v1.0 - clase 4");`
2. **Recorrida de 404:** el navegador responde con su página `HTTP ERROR 404` para cualquier ruta no definida (`/inexistente`, `/chau`, `/HOLA` en mayúsculas). Conclusión esperada: la API solo conoce las rutas declaradas con `MapGet`, y distingue el texto exacto de la ruta.

3. **Experimento de memoria:** tras `Ctrl+C` y `dotnet run`, todos los endpoints responden igual. El estado «vivo» de la API se reconstruye en cada ejecución desde `Program.cs`; en la Unidad 1 eso es suficiente, y en la Unidad 2 el estado pasará a vivir en `hospital.db`.

4. **Lectura en voz alta:** orden correcto del archivo: `CreateBuilder` → `Build` → los `MapGet` → `Run`. Si un `MapGet` quedó después de `app.Run()`, no se ejecuta nunca: `Run` deja el programa esperando pedidos y todo lo que esté debajo no corre.

## 3. Respuesta esperada del ejercicio

Con la API corriendo (`dotnet run`) y el puerto informado por la terminal:

| Pedido en el navegador | Respuesta esperada |
| --- | --- |
| `http://localhost:5080/hola` | `Hola desde la primera Minimal API!` |
| `http://localhost:5080/estado` | `La API esta funcionando` |
| `http://localhost:5080/equipo` | Lista de integrantes del grupo, separados por coma |
| `http://localhost:5080/escuela` | Nombre de escuela + especialidad |
| `http://localhost:5080/frase` | La frase elegida por el grupo |
| `http://localhost:5080/noexiste` | Página `HTTP ERROR 404` del navegador |

## 4. Criterios de corrección (lista de verificación)

| ✔ | Criterio |
| --- | --- |
| ☐ | El proyecto compila y corre con `dotnet run` sin errores |
| ☐ | Los tres endpoints del ejercicio existen con las rutas pedidas (`/equipo`, `/escuela`, `/frase`) |
| ☐ | Cada endpoint devuelve texto plano, no un 404 ni un error |
| ☐ | Los cambios quedaron guardados en `Program.cs` y la API fue reiniciada antes de probar |
| ☐ | Al menos un integrante por grupo explica qué hace la flecha `=>` con sus palabras |
| ☐ | El grupo identifica el origen del 404 (ruta no definida) sin confundirlo con un programa roto |

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| El navegador sigue mostrando el texto viejo | No reinició después de guardar | Pedir que muestre la terminal: ¿hay un `Ctrl+C` + `dotnet run` posterior a la edición? Guiar la rutina guardar → cortar → correr |
| `dotnet run` falla con «MSBUILD : error MSB1003» o similar | Se ejecutó fuera de la carpeta del proyecto | Verificar carpeta con `pwd`; volver a `cd HospitalApi` y repetir |
| Pantalla de error 404 en `/equipo` | Ruta escrita distinta a la del `MapGet` (mayúscula, guión, espacio) | Cotejar caracter por caracter la ruta del navegador con la del código |
| `dotnet new web` creó una carpeta dentro de otra | Comando lanzado en la carpeta equivocada | Ubicar el proyecto anidado, acordar con el grupo cuál conservar y recrear en la carpeta del curso |
| El endpoint no aparece aunque el código está | `MapGet` escrito debajo de `app.Run()` | Releer el archivo en voz alta marcando las cuatro partes; mover el endpoint antes de `Run` |
| Terminal «congelada» sin prompt | La API sigue corriendo | Explicar que es el comportamiento esperado: `Ctrl+C` devuelve el prompt |

## 6. Registro de la clase

- Revisar por grupo los tres endpoints funcionando y registrar la participación en la explicación oral (insumo para la evaluación de proceso de la Unidad 1).
- Anotar los grupos que completaron la extensión: reciben los desafíos de profundización de los encuentros siguientes.
