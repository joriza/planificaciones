# Proyecto puente integrador de las Unidades 1 y 2 — Encuentros 19 y 20

## Metadatos

| Campo | Valor |
|---|---|
| Momento | Proyecto puente integrador de las Unidades 1 y 2 |
| Encuentros | 19 y 20 |
| Duración | 2 encuentros × 120 min (240 min total) |
| Destinatarios | Totalidad del curso (una sola pista) |
| Requisitos | Haber completado los TP-U1 y TP-U2; tener el repo grupal clonado con los dos TP commiteados; conocer variables, tipos, entrada/salida, condicionales, bucles, listas, diccionarios y funciones en Python |
| Lugar | Aula de informática con VS Code, terminal y repo grupal GitHub |

## Acuerdo pedagógico

| Dimensión | Única pista para todo el curso |
|---|---|
| **Contenidos** | Proyecto integrador (programa de consola) que articula: entrada/salida (`print`, `input`), condicionales (`if`/`elif`/`else`), bucles (`while` `for`), listas, diccionarios y funciones (`def`, parámetros, retorno). Dominio: sistema de gestión de un club de barrio (socios, cuotas, vencimientos). |
| **Actividad / metodología** | Construcción progresiva del programa (de consola, sin persistencia). Encuentro 19: consigna, planificación grupal y primera parte con commits. Encuentro 20: finalización, puesta en común y cierre con defensa. Trabajo individual con revisión entre pares. |
| **Recursos** | VS Code, terminal, repo grupal clonado, consigna del proyecto puente impresa con rúbrica de 100 puntos, ejemplos resueltos de U1 y U2. |

## Criterios de evaluación — rúbrica (100 puntos)

| Dimensión | Puntaje | Indicadores |
|---|---|---|
| Entrada y condicionales | 20 pts | Usa `input()` y `int()`/`float()` correctamente. Aplica `if`/`elif`/`else` para decidir flujo del menú y validar datos. |
| Bucles | 15 pts | Usa `while` para el menú principal (hasta que el usuario elija salir). Usa `for` para recorrer listas y diccionarios. |
| Listas y diccionarios | 25 pts | Almacena socios como diccionarios dentro de una lista. Opera sobre la lista (agregar, eliminar, buscar, listar). |
| Funciones y bloque principal | 20 pts | Define funciones con `def`, parámetros y `return`. Organiza el programa con `if __name__ == "__main__"`. |
| Calidad del código | 10 pts | Nombres descriptivos, comentarios útiles, código sin líneas muertas, entrada de datos validada mínimamente. |
| Entrega y defensa | 10 pts | Repositorio GitHub actualizado con commit del proyecto. Breve explicación oral del programa y las decisiones tomadas. |

---

## Desarrollo del Encuentro 19

### Apertura (10 min)

El docente presenta el proyecto puente: "Van a construir un programa de consola para gestionar los socios de un club de barrio. No es un TP nuevo: es integrar todo lo que ya saben de U1 y U2 en un solo programa. No usamos archivos ni base de datos — todo se hace en memoria." **No se permite celular.** Se entrega la consigna impresa y se explica la rúbrica de 100 puntos.

### Desarrollo (45 min + 45 min)

**Bloque 1 — Consigna y planificación grupal (45 min)**

1. **(10 min)** Lectura colectiva de la consigna. El docente aclara el alcance: el programa debe ofrecer un menú con las opciones:
   - 1: Agregar socio (\(socio\))
   - 2: Listar todos los socios (\(socios\))
   - 3: Buscar socio por nombre (\(findMember\))
   - 4: Mostrar socios activos (\(activeMembers\)), es decir, con cuota al día
   - 5: Mostrar socios con cuota vencida
   - 6: Salir
2. **(15 min)** Planificación en parejas: cada estudiante diagrama la estructura del programa (funciones necesarias, lista de diccionarios como estructura de datos, flujo del menú).
3. **(20 min)** Puesta en común de los diagramas. El docente valida y sugiere nombres de funciones: `agregar_socio()`, `listar_socios()`, `buscar_socio()`, `socios_activos()`, `socios_vencidos()`. Se define la estructura de datos: cada socio es un diccionario con claves `"nombre"`, `"edad"` (`memberAge`), `"cuota"` (`clubFee`), `"vencimiento"` (mes como string).

**Bloque 2 — Primera parte: estructura base y opciones 1 y 2 (45 min)**

1. **(15 min)** Implementar opción 1 (agregar socio): pedir nombre, edad, cuota (\(clubFee\)) y vencimiento por `input()`. Crear el diccionario del socio (\(socio\)) y agregarlo a la lista global. Validar que edad y cuota sean números.
2. **(15 min)** Implementar opción 2 (listar socios): recorrer la lista de socios (\(socios\)) con `for` y mostrar cada uno con formato.
3. **(15 min)** Probar ambas opciones. Commit y push al repo grupal con mensaje `"feat: agregar socio y listar socios"`.

### Cierre (20 min)

Puesta en común de pantallas: el docente verifica que cada estudiante tenga las opciones 1 y 2 funcionando. Revisa commits en GitHub. Anticipa las opciones del próximo encuentro (3, 4 y 5) y recuerda que la opción 6 (salir) debe cerrar el bucle `while` con `break`.

---

## Desarrollo del Encuentro 20

### Apertura (10 min)

Repaso de lo creado en el encuentro anterior. El docente muestra una versión completa del programa en el proyector y recorre las opciones que faltan. Recuerda que hoy se finaliza, se hace la defensa y se entrega con la rúbrica completa. **No se permite celular.**

### Desarrollo (45 min + 45 min)

**Bloque 1 — Opciones 3, 4 y 5 (45 min)**

1. **(15 min)** Opción 3 (buscar socio por nombre): implementar función \(findMember\) que recorra la lista de diccionarios con un bucle `for` y compare el nombre ingresado con el campo `"nombre"` de cada socio (\(socio\)). Si no encuentra, mostrar mensaje "Socio no encontrado".
2. **(15 min)** Opción 4 (socios activos): implementar función \(activeMembers\) que filtre la lista por cuota al día (comparar vencimiento con el mes actual ingresado al iniciar el programa). Mostrar solo los cumplidores.
3. **(15 min)** Opción 5 (socios con cuota vencida): función análoga que muestre los que tienen vencimiento anterior al mes actual. Probar todo el ciclo del menú.

**Bloque 2 — Bloque principal, pulido y entrega (45 min)**

1. **(15 min)** Refactorizar: envolver todo el programa en funciones y agregar `if __name__ == "__main__"`. Mover la lista de socios como variable global o pasarla como parámetro.
2. **(15 min)** Pulido: verificar nombres de variables, agregar comentarios donde la lógica no sea obvia, validar que la entrada del menú sea numérica (con `try`/`except` básico).
3. **(15 min)** Commit final (`"feat: proyecto puente completo"`) y push al repo grupal. Cada estudiante verifica que GitHub muestre el archivo `.py` correctamente.

### Cierre con defensa (20 min)

El docente recorre los puestos y cada estudiante explica brevemente:
- Qué hace el programa
- Cómo eligió las estructuras de datos (por qué diccionarios dentro de una lista)
- Una función que le haya costado y cómo la resolvió

El docente registra los puntajes parciales en la rúbrica de 100 puntos. Entrega el resultado al final del encuentro.

---

## Criterios de logro

| Condición | Criterio |
|---|---|
| Aprobado (≥ 60 pts) | El programa compila y ejecuta. Menú funcional con al menos opciones 1, 2, 3 y 6. Usa diccionarios, listas, funciones y bloque principal. Hay commit en el repo. |
| Destacado (≥ 85 pts) | Cumple el criterio anterior + completa las opciones 4 y 5 con lógica correcta de vencimiento. El código está bien comentado, las funciones son reutilizables, y la defensa muestra comprensión de las decisiones de diseño. |
| No aprobado (< 60 pts) | El programa no compila, no corre, o falta funcionalidad central (no usa funciones, no usa diccionarios, no hay commit). El estudiante pasa al grupo de intensificación en los momentos siguientes (encuentros 34-35 o diciembre). |