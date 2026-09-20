# Anexo docente — Encuentro 27: lanzamiento del trabajo final y README de portada

> Registro docente formal. Documento interno del docente: no se entrega a los alumnos.

| Campo | Detalle |
| --- | --- |
| Encuentro | 27 — Unidad didáctica 4 (1 de 5) |
| Contenido | Devolución U3; consigna canónica del trabajo final; README de portada |
| Insumos | `convenciones-tecnicas.md`, `database-docs/04-resumen-para-curso.md`, planificación anual (tramo 27-31) |

## 1. Solución de referencia: README de portada completo

Ejemplo completo para proyectar cuando los grupos terminen el ejercicio. Reemplazar los datos por los de cada grupo.

````markdown
# Gestión hospitalaria — trabajo final

API Minimal con C# .NET 6 sobre la base SQLite `hospital.db`. El proyecto integra
consultas, estadísticas y escritura validada sobre datos reales de un hospital.

## Integrantes

| Nombre | Usuario de GitHub |
| --- | --- |
| Nombre Apellido | @usuario-grupo-1 |
| Nombre Apellido | @usuario-grupo-2 |
| Nombre Apellido | @usuario-grupo-3 |

## Cómo clonar y correr

1. `git clone https://github.com/usuario/repo-del-grupo.git`
2. `cd repo-del-grupo/trabajo-final`
3. Requiere el SDK de .NET 6. `hospital.db` va junto al `.csproj`.
4. `dotnet run` y abrir `http://localhost:5080`.

En Windows PowerShell usar `curl.exe` (el alias `curl` puede apuntar a `Invoke-WebRequest`).

## Endpoints

| Método | Ruta | Qué hace | Estado |
| --- | --- | --- | --- |
| GET | /patients/{id} | Devuelve un paciente por id | listo |
| GET | /admissions/details | Ingresos con paciente, médico y especialidad (JOIN triple) | pendiente |
| GET | /stats/specialties | Cantidad de ingresos por especialidad (GROUP BY) | pendiente |
| GET | /patients/search?term=gar | Búsqueda de pacientes por apellido (LIKE validada) | pendiente |
| POST | /patients | Alta de paciente validada | pendiente |
| DELETE | /patients/{id} | Baja de paciente validada | pendiente |
| GET | /admissions/dirty-dates | Ingresos con fecha de alta anterior a la de ingreso | pendiente |

### Ejemplos curl

```powershell
# Un paciente por id
curl http://localhost:5080/patients/1

# Alta de paciente (responde 201 con la URL del recurso nuevo)
curl -X POST http://localhost:5080/patients -H "Content-Type: application/json" -d "{\"firstName\":\"Ana\",\"lastName\":\"Garcia\",\"gender\":\"F\",\"birthDate\":\"2001-03-14\",\"provinceId\":\"ON\"}"

# Baja de paciente (responde 204 sin cuerpo)
curl -X DELETE http://localhost:5080/patients/300
```
````

Nota de corrección: la tabla de endpoints se escribe solo con comandos que funcionan en la base del grupo; la columna Estado refleja la realidad del repo al cierre de cada encuentro.

## 2. Matriz canónica de la consigna (requisito → criterio de aceptación)

Esta matriz es la versión docente de la consigna: cada fila se convierte en un issue en el encuentro 28 y en una pregunta de la defensa del encuentro 32.

| Req | Endpoint | Criterio de aceptación verificable |
| --- | --- | --- |
| a | `GET /admissions/details` | 200 con fecha de ingreso, alta, diagnóstico, paciente, médico y especialidad; JOIN de `admissions` + `patients` + `doctors`; orden descendente por ingreso |
| b | `GET /stats/specialties` | 200 con una fila por especialidad y el total de ingresos con `COUNT(*)` y `GROUP BY`, ordenado por cantidad descendente |
| c | `GET /patients/search?term=...` | 200 con coincidencias de apellido por `LIKE` parametrizado; 400 si falta o queda vacío `term`; 404 si no hay coincidencias; mensajes en español |
| d | `POST /patients` · `DELETE /patients/{id}` | POST: 201 con datos validados (obligatorios, género `M`/`F`, fecha ISO, provincia existente) o 400; DELETE: 204, 404 si no existe, 400 si el paciente tiene ingresos |
| e | `GET /admissions/dirty-dates` | 200 con los ingresos cuya `discharge_date` es anterior a `admission_date` (el caso real `'1971-01-05'`), comparación de fechas ISO como texto |
| f | `README.md` en la raíz | Proyecto, integrantes, cómo clonar y correr, tabla de endpoints con ejemplos curl que funcionan |

## 3. Solución del ejercicio independiente

El ejercicio queda completo cuando el repositorio del grupo muestra, al cierre del encuentro:

1. Carpeta `trabajo-final/` con `.csproj`, `Program.cs`, `hospital.db` y `bin/` y `obj/` ignoradas por el `.gitignore` de la raíz.
2. Endpoint de prueba `GET /patients/{id}` respondiendo 200 y 404 con mensajes en español.
3. `README.md` en la raíz con las cuatro secciones obligatorias y la tabla de siete endpoints (prueba + a-f) con estado `pendiente`, salvo el de prueba en `listo`.
4. Historial de commits con la convención `trabajo-final: ...` y todo empujado a GitHub.

## 4. Criterios de observación de la clase

| Criterio | Se observa cuando |
| --- | --- |
| Lectura de la consigna | El grupo puede decir, sin mirar la planilla, qué pide cada requisito y con qué códigos se prueba |
| Entorno correcto | `hospital.db` junto al `.csproj`; solo `Program.cs`; records al final del archivo |
| Rutina de commit | Commits referentes y push al cierre; nadie termina el encuentro con trabajo sin guardar |
| README como tablero | La columna Estado refleja el avance real; no hay endpoints «aspiracionales» con comandos que no funcionan |
| Rotación de roles | Quien teclea, quien dicta y quien prueba cambian al menos una vez |

## 5. Errores esperados e intervención

| Error esperado | Intervención docente |
| --- | --- |
| Proyecto creado fuera de la raíz del repo | Que el grupo compare con `dir` la estructura esperada del repo y mueva la carpeta antes de commitear; no corregirlo el docente |
| README con ejemplos curl inventados | Preguntar «¿probaron ese comando?»; regla: solo comandos ejecutados entran al README |
| Confusión entre portada del repo y documentación del proyecto | Mostrar en GitHub qué se ve al entrar al repo: el README de la raíz es el único que se renderiza en la portada |
| Grupo copia el README del anexo sin adaptarlo | Exigir datos reales del grupo (integrantes, rutas y estados propios); el anexo es referencia de estructura, no plantilla para completar al vacío |
| Ansiedad por «no saber cómo empezar» | Volver a la matriz de la consigna: cada requisito es un endpoint conocido de U2-U3; el trabajo nuevo es organizar, no resolver SQL desconocida |
