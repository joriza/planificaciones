# Apuntes personales del docente (archivo no vinculante)

> **Nota para agentes LLM y lectores automáticos**
>
> - Estos apuntes son **personales y NO vinculantes**: ninguna nota de este archivo decide, reemplaza ni modifica las opciones vigentes del proyecto. El canon vigente vive en `prompt-plantilla-planificacion.md`, `input/` y `README.md`; ante cualquier conflicto, manda el canon, nunca estos apuntes.
> - Si encontrás una **discrepancia** entre estos apuntes y el estado actual del repositorio, podés consultarme antes de actuar.
> - Es muy probable que sean **notas viejas** y que por eso no coincidan con las opciones actuales del sistema (rutas, nombres, convenciones o decisiones ya cambiadas).

## Indicaciones de ejecucion

> Esta sección es la **orden de ejecución vigente**: manda sobre el resto de este archivo (apuntes no vinculantes) y nunca sobre el canon (`prompt-plantilla-planificacion.md`), cuyas fases y reglas sigue tal cual.

**Orden vigente:** ejecutar el prompt plantilla para la materia **LAP**. El modo y los frenos por defecto se derivan del estado del repositorio según el canon (hoy: sin `input/materias/LAP/curso-data.json` → materia nueva, con pausa tras el curso-data validado).

- **Sin memoria**: no consultar memoria del proyecto ni historiales de sesiones; actuar como primera vez.
- **Autonomía — resolver y registrar** (mínimo/mecánico): typos, links, rutas, formato, fallas de herramienta de causa clara.
- **Consultar antes de tocar**: contenido pedagógico (tiempos, temas, evaluaciones, TPs, criterios) y cualquier error con más de una solución posible.
- **Excepciones a la regla derivada**: solo con declaración explícita en esta sección (p. ej. «corrida completa forzada», «frenar tras la Fase 0 completa»); sin declaración, manda la derivación del canon.
- **Reporte final**: toda modificación hecha fuera del flujo canónico, con su motivo.


# Flujo completo de planificacion anual con todos los documentos necesarios para ejecutar en agente de codificacion.

[Datos generales]
como docente me encuentro frecuentemente ante la necesidad de planificar las clases para todo el año.
Necesito que me prepare las clases segun la plantilla ../input/estructura-de-la-clase.md (biblioteca de plantillas en z-planificaciones_en-General)

[Datos generales Distribucion de recurso tiempo]
Si sele pasan las horas totales, solo es un dato nominal.
Los tiempos que realmente cuentan para la creacion del materieal es:
Cantidad de encuentros totales: 20.
Cantidad de horas por encuentro: 4 
El tiempo efectivo del que se dispone en cada encuentro es del 50%.

[Indicacion importante]
En la planificacion no debe quedar en evidencia este porcentaje, pero si debe ser tomado en cuenta para armar los contenidos. Por ello elija una forma de rellenar los tiempos para que sume el tiempo teórico, ya sea inflando el estimado de tiempos o agregando actividad complementaria explícita, o si son actividades grupales rotar integrantes si el tiempo lo permite, lo que considere de apariencia mas profesional y menos evidente. Tambien puede ir rotando de alternativa o un mix de ellas.


Dividir la planificacion obligatoriamente en 4 unidades didacticas.
Yo le pasaré los contenidos minimos.
Todo el contenido debe generarse en una subcarpeta con un nombre acorde.
Cada clase debe guardarse en un documento por separado.
Si considera necesario genere otros documento que me puedan servir como docente.



[Entregas por parte de los alumnos]
Se organizarán por grupos, siendo la cantidad de integrantes la minima posible entre equipos disponibles y cantidad de alumnos cursantes.



[Datos particulares]
Los contenidos minimos son:
Necesito impartir clases de minimal api con C# netcore 6.
Empezar desde cero, la ideea es un el alumno solo conozca como funciona minimal api, es un primer acercamiento, que sea basico sin conceptos complicados como patron repositorio o inyeccion de dependencia. En resumen, sin abstracciones.
Conocimientos previos de los alumnos: Cero C#
Entorno de trabajo: Vs Code + Terminal
Evaluacion: En documento por separado, 2 versiones para cada instancia de evaluacion.
Exponer los tiempos teoricos en cada documento sin exponer el recorte efectivo.
Que contenga ejemplos muy mininimos funcionales.
No utilice Entity Framework, utilice dapper que es mas comprensible para quien solo ha utilizado unas pocas clases consultas sql.
Es necesario agregar contenido minimos de git y github tanto web como terminal de comandos para poder realizar las entregas.
Tengo una pequeña base de datos en sqlite para utilizar en los ejemplos. La base se llama hospital.db
Busque la forma de se toque solo Program.cs, otros archivos solo si es estrictamente necesariode esta forma se simplifica la cantidad de archivos que debe recordar el alumno. 
Agregue una buena dosis de comentarios al codigo de ejemplo para que los estudiantes puedan comprender mejor las acciones del codigo presentado.



[Dato muy particular - puntual]
Para este pedido particular frene luego de generer archivos para los encuentros de la unidad 1. Luego le pediré que continúe.



[Indicaciones Finales]
Si tiene planificaciones anteriores en memoria ignórelas, Necesito verificar que le estoy pasando todas las indicaciones necesarias en esta solicitud. Solo debe tomar de la memoria las especificaciones de la base de datos.
Siempre que pueda ejecute en sub agentes para preservar el contexto principal y acelerar el proceso de creacion.
Consulte todos lo que considere necesario antes de comenzar a realizar.


### Agregado al prompt plantilla

Estos son los agregados a fusionar ordenadamente con lo anterios

Antes de comenzar con el armado de cada encuentro, presente el detalle genereal completo a modo de readme, para analizar antes del trabajo que mas tiempo consume.

Frenar aqui, hasta confirmar lo entregado y continuar.

Armar un documento con los encuentros en formato planificacion anual, yo la cargaré manualmente en la plantilla que presenta cada escuela. El documento debe contener informacion en formato tabla con las columnas: Unidad temática (con denominación), TIEMPO (cantidad de clases), CONTENIDOS, Espectativas de Logro, ACTIVIDADES (especificar uso de celular), TP OBLIGATORIO, TÉCNICAS/CAPACIDADES, RECURSOS, METODOLOGÍA DE EVALUACIÓN. En la cantidad de clases solo colocar el numero.

Armar otro documento en formato tabla con la sintesis del plan de clases para completar el libro de aula. Debe armar 1 con 1 linea por cada encuentro y otro con 2 lineas por cada encuentro para mayor detalle, (cada escuela tiene un formato diferente y lo desconozco de antemano). Ambos documentos deben contener las columnas:
- Nº Clase: Secuencia numérica correspondiente.
- Eje Temático: Nombre del Eje temático
- Nº Eje: Identificador del eje temático.
- Carácter/Objetivo: Selección obligatoria del listado técnico adjunto.
- Tema del Día: Descripción sintética del contenido.
- Actividades: Detalle de las acciones pedagógicas a desarrollar.
- Fecha: - Fecha: (No estimar, lo colocará el docente manualmente)
- Material: (No estimar, lo colocará el docente manualmente)

Volver a frenar aqui y esperar confirmacion para armar el resto de los documentos.

Luego de armados todos los documentos para todos los encuentros, debe crear documentos de encuentros especiales, llamados intensificacion y fortalecimiento.
Estas clases especiales constan de 2 encuentros, se producen al final de la unidad 2 y la unidad 4 para 2 grupos de alumnos en diferente condicion.
El grupo de intensificación: Aquellos alumnos que han presentado dificultades para alcanzar los objetivos mininimos. Está orientado a ayudarlos a alcanzar los objetivos.
El grupo de fortalecimiento: Aquellos alumnos que han alcanzado los objetivos minimos. Para que puedan profundizar en los conocimientos adquiridos.
En cada documento del tipo intensificacion debe conener en formato tabla los siguientes datos.
* CONTENIDOS MÍNIMOS IRRENUNCIABLES.
* ACTIVIDAD Y/O METODOLOGÍA ACORDADA (Ultra-Condensada).
* RECURSOS ACORDADOS (Condensado al 25%).

### Indicaciones para adecuar el prompt plantilla

Adecuar este prompt con los agregados que ademas le paso

Entregue el resultado en un nuevo documento.
Antes de comenzar realice todas las consultas que considere necesarias.

### indicaciones adicionales para la nueva plantilla

El uso de celular es un dato particular de cada curso.
Debe ser indicado explicitamente.
Para este curso no está permitido el uso de celular, no es necesario por parte del alumno.
Adecuar el archivo de prompt plantilla con este dato.
En cuanto al Carácter/Objetivo del libro en este caso coloque lo que considere necesario, debe ser preferentemente una sola palabra. No modificar el prompt plantilla todavía con este dato.

### + detalle

Me gusta como ha denominado Clases regulares a los 20 encuentros. Son los que realmente se imparte contenido nuevo a los alumnos.
Si considera necesario adecue el prompt plantilla y el readme con esta informacion.
Una aclaración, las versiones A y B es solo para los encuentros de evaluacion.
Acraración Adiciones, deben ser ejercicios pequeños que incluyan el contenido de la unidad a evaluar y los contenidos anteriores si fuera estrictamente necesarios. Adecue el promp plantilla y el readme con esta informacion.

### + detalle 2

Consulta: Git y github no deberían ser pre-requisitos particulares del curso (conocimientos necesarios y transversales) y por lo tanto ser parte del inicio del curso?
Las bases de datos pueden ser impartidas en un punto necesario, esto no es problema.

Actualice 

### + detalle 3

A ver. Se me ocurre lo siguiente.
Las entregas de las 3 primeras unidades se hacen en repositorios separados, mono rama. Entonces para todas las entregas realizan los mismos simpleles pasos.
y recien en la ultima unidad realizar los comandos mas complejos de git.
Que te parece?

### + detalle 4

O mejor.
En un solo repositorio, cada trabajo nuevo en una carpeta del mismo repositorio.
Así como docente no tengo 200 repos antes de comenzar la unidad 4

### + det 5

Y esta propuesta?
Unidades de 1 a 3 en un solo repo. y unidad 4 agregan al mismo repo todo lo necesario para hacerlo mas profesional.

### + det 6

Dato adicional.
Las columnas "Tema del Día" y "Actividades", su contenido solo me permite cargar 35 caractees, se que es poco espacio para ser claro, pero es el espacio que tengo.
Adecue el prompt plantilla y actualice ambos documentos de libro de aula.

###  + det 7

Cada vez que el prompt plantilla indica que debe frenar. Me parece bien que lo haya denominado "Fase" Actualice el promp plantilla con esta nueva denominación.

### + det 8

Consulta para un paso posterior que si está de acuerdo luego se lo indicaré.
Ahora que el prompt plantilla ha crecido bastante, considera buena practica separar las fases en documentos separados? así como lo está estructura de la clase

### + det 9

un cambio de nombre de archivos para un jerarquia humana.
0-encuentros-especiales.md cambiar a encuentros-especiales.md cambiar
0-estructura-de-la-clase.md cambiar a encuentros-especiales.md cambiar
pdt-planificaciones.md cambiar a z-pdt-planificaciones.md
adecue en todos los archivos necesarios para mantener integridad

### + det 10

Una pequeña modificacion para los libros de aula.
En ambos archivos generar una version en formato .csv solo de la tabla.
Gene para determinar si procede.

### + de 11

Agregar un nuevo conjunto de documentos que se me había olvidado.
Se llama continuidad pedagógica.
Son actividades que deben realizar los alumnos en una clase con lo realizado hasta el momento. Estas actividade se entregan a la administracion para los casos en el que docente no pueda asistir.
En general son actividades para repasar y fijar los conocimientos vistos hasta el momento. En el caso de la primer continuidad se piensa en la utilizacion de conocimientos previos, debido a que no se han visto temas todavía.
Realizar 4 documentos con el contenido equitativamente repartido segun el contenido anual. Con la salvedad del primero.
Presentar los documentos antes de adecuar el prompt plantilla.

### +det12

Agregar el siguiente comantario a los documentos de continuidad pedagogica, esta actividad debe presentarse en la proxima clase como una actividad mas de la materia. 
Este comentario necesito agregarlo porque los alumnos son muy piolas encontrando excusas para zafar de cumplir sus obligaciones.
adapte el comentario para que sea politicamente correcto para el ambito académico.

### +det13

agregar en donde considere necesario que la resolucion es de forma habitual, pero la entrega es individual en forma manuscrita

### +det14

Segun lo veo, el prompt plantilla cubre todo el ciclo lectivo para una mataria.
Ahora vamos por partes que son mas que nada afinar la completitud de ciertos documentos formales.
Una planificacion anual debe constar de 36 clases/encuentros, 18 para primer cuatrimestre y 18 para el segundo. Esto es algo teórico, porque la realidad indica otra cosa, pueden surgir muchos eventos durante el año que impiquen menos clases efectivas, pero debo presentarlo segun el diseño teórico.
Para poder estandarizar necesito definir una estructura rigida sobre los encuentros
El numero es el ordinal de los encuentros.
1 - Presentacion y diagnóstico. Si es una escuela tecnica agregar Seguridad y elementos de protección personal (EPP).
2 a 3 - Intensificación y fortalecimiento (saberes previos)
4 a 8 - Unidad 1. con consolidacion y cierre de la unidad.
9 - Evaluacion de la unidad
10 a 14 Unidad 2. con consolidacion y cierre de la unidad.
15 - Evaluacion de la unidad
16 - Cierre de cuatrimestre 1
17 a 18 - Intensificacion y fortalecimiento de la unidad 1 y 2

19 a 20 - Intensificacion y fortalecimiento de la unidad 1 y 2
21 a 25 - Unidad 3. con repaso y cierre de la unidad.
26 - Evaluacion de la unidad
27 a 31 - Unidad 4. con repaso y cierre de la unidad.
32 - Evaluacion de la unidad
33 - Cierre de cuatrimestre 2
34 a 35 - Intensificacion y fortalecimiento de la unidad 3 y 4
36 Cierre de la materias

Complete segun le parezca el resto de las columnas para armar la planificion anual completa.

Los encuentros 19 y 20 parecen redundantes, pero así debo realizarlos.
Adecue mis terminos a terminos formalmente pedagógicos.
Se aceptan sugerencias, sobretodo en lo pedagógico.
Al igual que el libro de aula, genere documento .csv solo con los datos de la tabla.
Antes de realizar Realice cualquier consulta que condere neceesarias.

op
1a + 1b + 1c
2 Estoy de acuerdo. Por tramo.
3 En este caso es escuela tecnica. pero no siempre. Ver como manejar este dato.
Acepto todas las sugerencias pedagógicas.

## +det15

Consulta. Yo manejo cada eje como unidad, es eso correcto. Expiqueme diferencias.
Creo que debería crear mas documentos de encuentros especiales. De intensificacion y Fortalecimiento.
En total los 4 que figuran en la planificacion anual. uno para cada momento de 2 encuentros cada uno.

## +det16

Ducumentos adicionales que conviene crear y adecuar el prompt plantilla con lo nuevo.
Agregar 2 momentos de intensificacion de 2 encuentros cada uno. El nombre de estos nuevos documentos debe ser referencia, pero a su vez deben quedar ordenados de tal forma que alfabeticamente queden en orden de uso.
Estos estan fuera de la planificacion anual.
uno es en diciembre, finalizado el tiempo de cursada, solo para los que no lograron alcanzar los objetivos minimos.
el otro es en marzo, para los que no alcanzaron en diciembre y tuvieron mas tiempo para prepararse.
Los 6 momentos de intensificacion tienen su evaluacion, armar tambien version A y B.

## +det17

Los placeholders de matrícula nunca los conozco de antemano y es variable a lo largo del año, sobretodo por la disposicion del parque informático. modifiquelo para que se exprese de forma general, intentando optimizar los recursos en funcion del alumno.
Ejecute las sugerencias.
Excepto el punto 4, esta es solo una prueba preliminar con datos reales, Anote esto como pendiente para cuando comience a realizar planes anuales reales.
Adecue todos los documentos necesarios.

## Estructura jerárquica

Estoy muy contento con el trabajo realizado hasta ahora.
Ahora vamos por una revision muy profunda de lo realizado previamente.
Me interesa de sobremanera cuidar mucho el lenguaje docente formal.
Ahora lo que considero el flujo normal de una planificacion anual, se aceptan sugerencias.
Una vez presentados los datos de la materia (contenido, horas por encuentro y demás)
Se debe armar la planificacion anual respetando esos preceptos. Los demás documentos deben respetarla o adecuar la planificacion para que siempre, y digo siempre tengan una correlaccion impecable derivada de la planificacion anual.
La cascada operacional para crear los otros documentos lo dejo a su criterio.
Agregue al prompt plantilla que agregue al readme el orden de creacion de todos los documentos.
Necesito reorganizar la estructura de carpetas. Sin entrar en sobre ingenieria, que prevalezca la jerarquia para un mejor entendimiento humano.
Relice todo lo que considere en subagentes, para preservar el contexto principal y el uso de tokens de cada consulta.

## Restructuracion de prompt, propuesta

Fijo y General

[Datos generales]
@input/estructura-de-la-clase.md
[Flujo de trabajo por fases — regla fija]
@estructura-anual-36.md
@encuentros-especiales.md


[Correlación con la planificación anual — regla fija]
[Distribución del recurso tiempo — regla fija]
[Estructura de la planificación — regla fija]
[Documentos administrativos — regla fija]
[Entregas por parte de los alumnos — regla fija]
[Evaluaciones — regla fija]
[Encuentros especiales — regla fija]
[Instancias del ciclo — regla fija]
[Continuidad pedagógica — regla fija]
[Indicaciones finales — reglas fijas]
[Datos particulares]
[Datos particulares]



## Modelos opencode zen free

- big-pickle (stealth, free) 200k/32k output
- deepseek-v4-flash-free (200k in / 128k out)
- mimo-v2.5-free (200k/32k)
- ling-3.0-flash-free / ling-3.0-flash-fin-free / ling-3.0-tiny-free (262k/32k)
- nemotron-3-ultra-free (1M/128k out — Nemotron 3 Ultra 550B A55B)
- nemotron-3.5-lightning-free (262k/262k)
- north-mini-code-free (256k/64k)
- laguna-s-2.1-free (256k/32k)
- longcat-2.0-free (1M/131k)


## +det18

mueva el archivo @verificar-curso.ps1 a la carpeta raiz, para que sirva para cualquier proyecto. realice los cambios que considere necesarios.


## inicio desde cero sin historial.

realiza las acciones indicadas en el documento @prompt-plantilla-planificacion.md
todo lo necesario está en la ruta raiz del proyecto + la sub carpeta input/database-docs y sus subcarpetas que contiene la informacion de la base de datos, ignore las otras sub carpetas, son de otros proyectos que algunos son parecidos y pueden generar mucho ruido.
Solo por esta ejecucion respete los frenos humanos indicados, le tengo fe a la ejecucion.
A) Utilice sub agentes todo lo que sea posible, para preservar el contexto principal.
B) Utilice sub agentes con el mismo modelo que el principal todo lo que sea posible, para mejorar los tiempos debido al procesamiento paralelo y para preservar el contexto principal.

## +det19

Entiendo el punto 5. Observación honesta sobre el recorte efectivo del 50%. Ser completamente honesto es lo mejor. Solo que no debe figurar este factor de eficacia en ningun documento generado, es el estimado implicito para todas las tareas.
Muesteme con un ejemplo de un documento existente la variante que resiste un revision formal.

## +det20

Actualice el documento @z-analisis-pi-agent-glm53flash.md y el punto 5. **Observación honesta sobre el recorte efectivo del 50%.** Modifiquelo para que tenga un nombre tecnico acompañado de florituras en lenguaje pedagógico que indiquen un comportamiento politicamente correcto. (Es que me dá verguenza reconocer un engaño directo y además dejarlo documentado)
Actualice el prompt plantilla y el readme del proyecto en todos los lugares donde sea necesario.

## +det21

Las evaluaciones son una por cada unidad didáctica, no recuerdo si lo he cambiado en algun lugar, pero son un error las evaluaciones que están en la carpeta instancias, ademas se contradice con la planificion anual. Pensandolo mejor, creo que instancias son las evaluaciones incluidas en la intensificacion. La carpeta instancias creo que tiene cosas mezcladas

## Reestructuracion de documentos fuente.

- Me parece que como humano, la subseccion denominada (Curso, stack y contenidos mínimos), de la seccion [Indicaciones finales — reglas fijas] debería estan en un archivo por separado, esto cambia con cada materia, que es el centro del armado de toda esta documentacion docente.
- Y creo que la redundancia del armado de evaluaciones está justamente en la linea que dice: - Evaluación: en documento por separado, 2 versiones para cada instancia de evaluación.
- La seccion (Tiempo) tambien deberia pertenecer a este nuevo archivo
- La seccion (Institución), tambien deberia pertenecer a este nuevo archivo, aunque no es el mas adecuado, porque hay cuestiones particulares de cada escuela aun cuando la materia sea la misma, como son pocas especificaciones es el lugar mas parecido al correcto.
 
- La carpeta denominada especiales, debería llamarse intensificaciones, porque contiene documentos y evaluaciones de intensificacion y fortalecimiento.

Ahora el momento de juntar indicaciones, el contenido de @encuentros-especiales.md y @estructura-anual-36.md debería estar en el prompt principal, hacen mas a cuestiones generales que se realizan siempre, sin impotar para que materia son.

el carchivo @input/estructura-de-la-clase.md debe permanecer por separado, depende el tipo de materia, porque ejemplo una materia netamente teorica es muy distinta a una materia netamente practica o una balanceada, cambian las formas de encararla. Tambien cambia si cambia el alumnado, no es lo mismo adolescentes y que adultos.

Luego de validar y conciliar diferencias, actualice promp plantilla y readme.
Realice todas las consultas que considere necesarias.

## Estimacion superficial

Estime muy superficial y rapidamente, cuanto tiempo en horas le lllevaría a un humano promedio leer toda la documentacion generada en este proyecto. Y cuanto tiempo le llevaria armar, estructutar y escribir el mismo proyecto desde cero con poca experiencia en el dictado de esa materia puntual.


## Necesito optimizar los tiempos y consumos de token del proyecto

arme un plan para analizar y debatir.
con estrategias como:
- generar apps deterministas para los pasos que sea posible.
- re-organizar las carpetas o la cascada de procesos.
- proponga otras alternativas posibles.
luego de analizado y debatido el plan le indicaré cuando aplicarlo


## Plan de ahorro de recursos.

### 1
- Derivados, concuerdo, anual y libros de aula puede cambiarse a generar solo archivos .csv
- Derivados. Aun mejor, en la anual, lo que mas cambia son los 20 encuentros en los que se imparte contenido, los que pertenecen las las 4 unidades didacticas, si se redacta de forma genérica pero que suene bonito pedagogicamante los otros encuentros pueden ser siempre iguales, o tener algunas plantilla de ejemplo con contenido equivalente para ir alternando.
- Las opciones B de las evaluaciones, si se elige con cuidado el contenido de la consigna A, reemplazar estrategicamente los datos de contexto sirve para otras opciones. Siendo mucho mas barato crear hasta opcion C o D con menos gasto que el actual.

## Error en el nuevo flujo a solucionar

@convenciones-tecnicas.md no es un archivo generado manualmente por mi, no es un archivo facil de crear, necesito solucionar eso, es distinto para cada materia, está muy acoplado a la materia.

## Nueva instruccion

Antes de hacer lio pregunto.
si elimino la carpeta minimal-api-csharp y ejecuto la orden:
Regeneración completa del corpus de la materia ubicada en input/materias/minimal-api-csharp.md, según @prompt-plantilla-planificacion.md en modo CORRIDA COMPLETA. 
Va a funcionar, o hay un forma mas adecuada de simular la generacion de una materia por primera vez?
Al menos en esta ejecucion necesito mas frenos que antes, hubo muchos cambios.


## +det22

Tiene alguna skill para que muestre en el cuadro de estatus algunos datos adicionales como como los tokens consumidos y el modelo que está utilizando?


## Datos de la primera ejecucion mixta de inicio a fin

Algunas cosas para pulir.

Todos los documentos y carpetas generados deben ir dentro de la subcarpeta output, asi los docuementos de todas las materia queden en una carpeta comun.

- Planificacion
En la planificacion, acotar un poco la cantidad de texto, mas que nada en las columnas contenido y actividades, es mucho para el espacio que dispongo.
En actividades: quitar algo que se repite mucho al comienzo de cada actividad "Encuentro de 240 minutos: " para cada uno de los encuentros no colocar la palabra "encuentro", solo colocar los numeros entre parentesis.

- Libro de temas
El primer eje temático debe ser presentación y diagnóstico. (o 2 palabras pedagógicas para ello)
Los otros ejes que digan "Diagnóstico, integración y metacognición" deben decir "Intensificación y Fortalecimiento"


## Modificaciones luego de ejecucion completa de version mixta.

modificacion solicitada, cada materia debe estar contenida en una sub carpeta de la ruta actual. El nombre de la carpeta la elijo yo y es la que me va a servir para indicar al prompt plantilla la materia que debe renerar la documentacion. consulta. cual es la diferencia de contenido del archivo @nota-catedra-minimal-api-csharp.md y de minimal-api-csharp.md. Generalizar el nombre para que sirva para cualquier materia. Adecuar segun eston cambios en todos los documentos que sea necesario.   


## +det23

analice los 2 archivos dentro de la carpeta input/materias/LAP analice coherencia entre ambos, corrija prosa y consulte inconsitencias o faltantes de contenido basico.


## +det24
adecue el promp principal para la materia LAP. Que es la siguiente materia a generar documentacion. Analice y proponga la posibilidad de externalizar ese dato / parámetro, es uno variable para cada materia y no es correcto tanto acoplamiento.


## +det25
Tener en cuenta que no todas las materias tienen la misma cantidad de horas por encuentro. Eso debe contemplarse.


## +det26
quite los frenos por defecto, el proyecto va tomando forma, le pediré explicitamente si necesito que aplique frenos.
consulta. como se trabaja ahora en el pedido sobre la materia a generar los documentos?


## +det27
El repo remoto es https://github.com/joriza/planificaciones.git pushee todo allí.


## +det28
Genere la documentación de la materia LAP según @prompt-plantilla-planificacion.md sin consultar la memoria, como una materia nueva sin historial.


## +det29
Indique en el archivo LAP/materia.md que el manejo de archivos de texto plano debe impartirse luego del encuentro 27.
Que no se imparte Menú con persistencia, tampoco csv ni json
Tampoco se imparte Comparar formatos y migrar

---

## +det30
Indique en el readme de la raiz del proyecto. como es el orden de creacion y como como estan conformadas las fases.

## +det31

Necesito que unifique la ubicacion de los archivos generados, el archivo curso-data.json debe generarlo en la carpeta de salida para la materia correspondientes, a la par de convenciones-tecnicas.md
Indique si hay algun otro archivo que no lo está creando en la ruta /output/<materia>

## Otro refactor.

Ahora que el proyecto ha tomado cierta dimension.
Necesito armar un plan para organizar la estructura actual. 
basicamente es mover carpetas y archivos. Y actualizar las referencias necesarias para que el sistema siga funionando.
Todo lo generado debe ir carpeta output y subcarpetas.
Todo lo que alimenta al corpus en carpeta input y subcarpetas.
En la carpeta raiz del proyecto queda la menor cantidad de archivos posibles. 0-prompt-plantilla-planificacion.md que debe renombrarse, quitar el prefijo 0-
tambien queda el readme
y mi archivo de notas z-pdt-planificaciones.md que no es vinculante.
Se aceptan sugerencias y consulte todo lo que considere antes de continuar.


## +det31

consulta de openrouter. Por que en el listado de modelos disponible no tengo modelos deepseek flash con opcion floor, para los workers me viene bien.

