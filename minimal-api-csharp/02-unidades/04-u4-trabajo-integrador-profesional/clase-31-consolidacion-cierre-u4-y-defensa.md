# Encuentro 31 — Consolidación, cierre de la Unidad 4 y preparación de la defensa

## 1. Metadatos del encuentro

| Campo | Detalle |
| --- | --- |
| Encuentro | 31 |
| Unidad | Unidad didáctica 4: Trabajo integrador profesional (encuentro 5 de 5, cierre de unidad) |
| Eje temático | Eje 4: Trabajo integrador profesional |
| Carácter | Procedimental |
| Duración | 240 minutos: apertura 15 · teoría mínima 40 · práctica guiada 75 · ejercicio independiente 50 · extensión y consolidación 45 · cierre 15 |
| Concepto nuevo | Consolidación del producto final (todo fusionado a `main`); entrega formal del trabajo-final; defensa técnica individual con guion y rúbrica anticipada |
| Requisitos | Encuentros 27 a 30: proyecto del trabajo final con features fusionadas por PR, issues con trazabilidad y README en progreso |
| Uso del celular | No permitido |
| Trabajo en equipo | Grupos: alumnos presentes ÷ equipos disponibles (mínimo posible); ningún equipo sin usar mientras haya alumnos sin equipo; rotación de integrantes |

## 2. Objetivos de aprendizaje

1. Consolidar el trabajo final: todos los requisitos a-f fusionados en `main`, README completo e issues cerrados.
2. Completar la entrega final del trabajo-final: push final, tablero limpio y repositorio presentable.
3. Construir el guion de la defensa individual: demo en vivo de 5 a 7 minutos recorriendo la consigna por requisito.
4. Anticipar los criterios de la evaluación con la rúbrica, para llegar al encuentro 32 sin sorpresas.

## 3. Teoría mínima

### Apertura (15 min)

Tablero colectivo del sprint: issues cerrados y pendientes por grupo. Acuerdo del día: hoy no se agregan features nuevas si quedan pendientes de fusionar; el objetivo del encuentro es entregar un producto completo y prepararlo para su defensa.

### La defensa técnica: mostrar, explicar, responder

**Analogía — la entrevista de trabajo con proyecto propio:** en una entrevista técnica no alcanza con decir «sé programar»: se muestra el proyecto corriendo, se explica una decisión propia y se responde lo que pregunten. La defensa del trabajo final es eso, en 5 a 7 minutos por alumno, frente a dos fuentes de verdad: el repositorio del grupo y la API corriendo.

Estructura del guion de defensa (individual, con el trabajo grupal de fondo):

| Momento | Duración | Qué se muestra |
| --- | --- | --- |
| Portada | ~1 min | Qué es la API, quiénes son el grupo, qué hizo cada uno (con el README en pantalla) |
| Demo guiada | 3 a 5 min | Los requisitos a-f con `curl` en vivo: cada requisito, su endpoint y sus códigos |
| Cierre | ~1 min | Una decisión técnica propia explicada (por ejemplo, por qué la consulta usa parámetros) |

Reglas de la demo: los comandos `curl` se preparan ANTES (un archivo de texto propio con los comandos listos), el puerto se verifica al arrancar, y si algo falla en vivo se lee el error en voz alta y se razona: eso también puntúa.

### La rúbrica anticipada

La rúbrica de la defensa se muestra HOY, no en el encuentro 32. Cuatro bloques de observación: **entrega** (repositorio completo y empujado), **flujo profesional** (issues, ramas, PRs revisados, `main` protegida), **requisitos a-f** (cada uno funcionando según su criterio de aceptación) y **defensa individual** (demo + explicación del código propio). La versión completa de la rúbrica está en el anexo docente del encuentro y se proyecta en clase.

## 4. Práctica guiada — consolidación del producto

> Trabajo por grupos con rotación de roles: quien consolida el repo, quien prueba los requisitos con `curl` y quien revisa el README cambian de rol por paso.

### Paso 1 — Inventario final del repositorio

Recorrer y resolver, en este orden:

1. PRs abiertos: fusionarlos (o cerrarlos si no llegan) — nada queda «a medio fusionar».
2. Issues abiertos: cada uno con decisión consciente: cerrarlo (si el criterio se cumple y quedó pendiente de tildar) o dejarlo abierto sabiendo que resta trabajo.
3. Ramas viejas en GitHub: borrar las ya fusionadas (botón **Delete branch** o desde la vista de ramas).

Después, alinear el clon local:

```powershell
git switch main
git pull
git status
```

Salida esperada: `nothing to commit, working tree clean` y sin ramas activas de trabajo viejo.

### Paso 2 — Verificación de los requisitos a-f contra main

Con la API corriendo desde `main` (`dotnet run`), probar cada requisito con `curl` y anotar el resultado:

```powershell
# (a) JOIN triple
curl http://localhost:5080/admissions/details

# (b) estadística con GROUP BY
curl http://localhost:5080/stats/specialties

# (c) búsqueda con LIKE: los tres casos
curl "http://localhost:5080/patients/search?term=gar"
curl -i http://localhost:5080/patients/search
curl -i "http://localhost:5080/patients/search?term=zzz"

# (d) escritura validada: alta, baja, y sus errores
curl -i -X POST http://localhost:5080/patients -H "Content-Type: application/json" -d "{\"firstName\":\"Ana\",\"lastName\":\"Garcia\",\"gender\":\"F\",\"birthDate\":\"2001-03-14\",\"provinceId\":\"ON\"}"
curl -i -X DELETE http://localhost:5080/patients/300
curl -i -X POST http://localhost:5080/patients -H "Content-Type: application/json" -d "{\"firstName\":\"Ana\"}"
curl -i -X DELETE http://localhost:5080/patients/99999

# (e) dato sucio
curl http://localhost:5080/admissions/dirty-dates
```

Salida esperada: cada requisito responde según su criterio de aceptación (200, 201, 204, 400 y 404 donde corresponde). Los id `300` y `99999` son ejemplos: usar un id real sin ingresos y uno inexistente de la base del grupo.

### Paso 3 — Cierre del README

1. Tabla de endpoints con TODOS los fusionados, cada uno con un ejemplo curl real y estado `listo`.
2. Secciones «Cómo clonar y correr» y «Integrantes» verificadas (que alguien que no escribió el README las siga y logre correr la API).
3. Commit y push del README final: `trabajo-final: readme final con ejemplos probados`.

### Paso 4 — Rúbrica proyectada y autoevaluación de grupo

Leer la rúbrica bloque por bloque y autoevaluar el repo del grupo con semáforo (logrado / en proceso / no logrado). Los bloques «en proceso» se convierten en la lista de tareas de la práctica siguiente.

## 5. Ejercicio independiente — entrega final del trabajo-final

**Consigna:** cada grupo deja el repositorio en estado de entrega:

1. Resolver los bloques «en proceso» de la autoevaluación (código, README o issues según corresponda).
2. Cerrar los issues que estén cumplidos (los que no, quedarán abiertos y se explican en la defensa).
3. Push final con todo fusionado en `main`; `git status` limpio en el clon.
4. Verificación cruzada: otro integrante repite la prueba de los requisitos a-f desde un clon fresco (`git clone` nuevo en otra carpeta) y confirma que el README alcanza para correr la API sin ayuda.
5. Anotar el estado final del grupo: requisitos cumplidos, pendientes y por qué.

**Pista:** el clon fresco del punto 4 es el ensayo general de la verificación de la entrega: si algo solo funciona en la máquina de quien lo escribió, no está entregado.

## Extensión y consolidación — preparación de la defensa

Para quienes completan la entrega base:

1. **Guion individual:** cada integrante arma su guion personal (portada, demo por requisito, cierre con una decisión técnica) con su propio archivo de comandos `curl` listos.
2. **Ensayo cronometrado:** una pasada completa por grupo, de 5 a 7 minutos, con un integrante cronometrando y anotando desvíos.
3. **Tribunal cruzado:** un grupo hace de tribunal de otro con las preguntas anticipadas del anexo docente proyectadas por el docente; el tribunal pregunta y evalúa con la rúbrica, y se invierte el rol.

Consolidación docente: tres preguntas modelo respondidas en voz alta por integrantes distintos, con corrección de forma (decir qué hace el código antes de leerlo; nombrar el requisito de la consigna que se está mostrando).

## 6. Cierre

### Qué te llevás

- El trabajo final se entrega completo: requisitos a-f fusionados en `main`, README con ejemplos probados, issues cerrados y clon limpio.
- La prueba del clon fresco es el criterio de entrega: si no corre desde cero siguiendo el README, no está entregado.
- La defensa es una demo de 5 a 7 minutos con estructura: portada, demo guiada por requisito y cierre con una decisión técnica propia.
- La rúbrica se conoció ANTES del encuentro de evaluación: entrega, flujo profesional, requisitos y defensa individual.
- Los comandos de la demo se preparan antes: en la defensa se muestra, no se improvisa.

### Lo que viene

Encuentro 32: **evaluación de la Unidad 4**. Verificación de la entrega por GitHub con el historial de issues y PRs, defensa individual del trabajo integrador y verificación práctica individual en versiones A y B. El trabajo del grupo ya está hecho: falta mostrarlo y explicarlo.

## 7. Errores comunes y trampas

| Error | Causa | Fix |
| --- | --- | --- |
| Un PR queda sin fusionar a último momento | Se dejó «para el final» | Regla del encuentro: consolidar primero, features nuevas no; al inventario se entra por los PR abiertos |
| La demo falla en vivo por puerto o API apagada | Se ensayó con otro puerto o sin arrancar `dotnet run` | Ensayar con la terminal real: arrancar la API, leer `Now listening on:`, y tener el archivo de comandos listo |
| Tabla del README con endpoints que no responden | La tabla se escribió «de memoria» y no de lo fusionado | La tabla se genera desde `main` probado: cada ejemplo curl corre antes de entrar al README |
| Issues abiertos que ya estaban cumplidos | Nadie los cerró al fusionar | Cierre con decisión: tildar criterios y cerrar; lo que quede abierto se sabe explicar en la defensa |
| Guion memorizado palabra por palabra | Miedo al vacío | Guion por tópicos (endpoint → código → requisito), no texto; la demo es en vivo a propósito |
| Todo el grupo ensaya la misma parte | Nadie se apropió del resto | Repartir: cada integrante defiende la demo de los requisitos que trabajó y, además, una parte común |
