# Anexo docente — Encuentro 31: Cierre U4: entrega y defensa

## Encuadre

Encuentro de cierre de la Unidad 4. No hay contenido nuevo: es sistematización, terminación y ensayo. El trabajo final se entrega como estado del repositorio al final del encuentro; la defensa formal es el Encuentro 32 (evaluación dedicada de la unidad, con defensa individual y prueba práctica). El objetivo de hoy es que ningún grupo llegue al 32 con requisitos incumplidos y que cada integrante llegue con su defensa ensayada.

## Qué observar durante la clase

- Grupos que «verifican» sin correr nada: la lista de requisitos se marca con evidencia en pantalla (programa corriendo, JSON abierto, historial visible).
- README final con instrucciones no probadas: pedir que se ejecute el comando publicado desde la raíz del repositorio en otra máquina o carpeta clonada.
- Issues cerrados a mano sin merge que los respalde: revisar que cada cierre corresponda a un PR fusionado o reabrirlo.
- Defensas ensayadas leyendo el código línea por línea: reencaminar hacia el guion (problema, función, error, PR); la defensa explica decisiones, no recita.
- Reparto desigual del ensayo: los cuatro puntos del guion deben pasar por todos los integrantes antes del cierre.

## Solución de referencia (estado final esperado del repositorio)

Verificación de la entrega, con salidas esperadas:

```bash
git switch main
git pull
git log --oneline --graph
git status
```

Salida esperada (ejemplo; el grafo puede variar según la cantidad de PR):

```
* f4e3d2c (origin/main, main) repo: readme final del trabajo
*   c3b2a1d Merge pull request #9 from curso/feature/ajustes-finales
*| 8d7c6b5 trabajo-final: valida campos vacios con reintentos
*| 7a6b5c4 trabajo-final: devolucion con confirmacion
|/
* 6e5d4c3 trabajo-final: persistencia json con carga segura
*   5d4c3b2 Merge pull request #6 from curso/feature/nucleo-menu
* 4c3b2a1 trabajo-final: nucleo del menu con alta y listado
* 3b2a1d0 repo: readme de portada del grupo
* 2a1b0c9 tp-u3: valida la edad con reintentos
* 1a0b9c8 tp-u3: agenda migrada a json
```

```
On branch main
Your branch is up to date with 'origin/main'.
nothing to commit, working tree clean
```

Lista de requisitos completa del trabajo final (idéntica a la del documento del alumno; es la pauta de aceptación de la entrega):

- [ ] `trabajo-final/prestamos.py` corre con `python prestamos.py`.
- [ ] Menú con las cinco opciones y salida limpia.
- [ ] Registro con `equipo`, `alumno`, `fecha` ISO y `devuelto`.
- [ ] Persistencia en `prestamos.json` verificada entre corridas.
- [ ] Archivo ausente → vacío; JSON dañado → mensaje y `sys.exit(1)`.
- [ ] Campos vacíos rechazados con reintentos.
- [ ] Sin librerías externas; esqueleto canónico.
- [ ] Issues cerrados; `main` solo avanza por merges de PR.

README final esperado en la sección del proyecto: descripción breve, comando de ejecución probado, lista de funciones del programa y mención de la construcción (un archivo, biblioteca estándar, sin dependencias).

## Guion y observación del ensayo de defensa

Los cuatro puntos del guion y qué se espera en cada uno:

| Punto | Expectativa mínima |
|---|---|
| Problema y opción del menú | Conecta el problema real (préstamos del aula) con la solución del programa; nombra la opción que lo resuelve. |
| Una función | Nombra parámetros y retorno (o la ausencia de retorno), y su rol dentro del menú. |
| Un error previsto | Elige entre archivo ausente, JSON dañado, campo vacío u opción inválida; explica qué hace el programa y qué ve el usuario. |
| Un PR del historial | Abre el PR en GitHub y explica qué cambió, quién revisó y qué se ajustó por la revisión. |

Registro docente sugerido por integrante: punto logrado / punto a reforzar, anotado en el issue `devolucion-defensa` del grupo. No se califica hoy: es ensayo con retroalimentación.

## Errores previsibles

1. **Últimos cambios sin push:** la entrega es el remoto; `git status` local limpio no basta si `git pull` en otra máquina no trae el trabajo. Verificar desde un clon fresco si hay dudas.
2. **README final pisado por error en un PR:** recuperable desde el historial; aprovechar para mostrar `git revert` conceptualmente (no es requisito del curso).
3. **Ensayo postergado por ajustes de código:** si el grupo no termina los ajustes, se recortan (es preferible entregar el mínimo funcional completo con defensa ensayada que entregar extra sin ensayo).
4. **JSON de prueba con datos reales de personas:** sugerir datos de ejemplo (nombres inventados); el repositorio es público al curso.
5. **Confusión entre entrega (31) y defensa (32):** recordar en voz alta el calendario; el 32 es evaluación dedicada con prueba práctica además de la defensa.

## Criterios de logro (4-8)

| Nivel | Descripción |
|---|---|
| 4 | El programa no corre o el repositorio no refleja el trabajo (sin push, sin README). |
| 5 | Entrega funcional pero con requisitos menores incumplidos y sin ensayo completo. |
| 6 | Entrega completa; ensayo realizado pero con puntos del guion no cubiertos por todos. |
| 7 | Entrega verificada ítem por ítem; cada integrante ensayó los cuatro puntos y recibió devolución. |
| 8 | Además, el grupo documenta en el issue de devolución sus propias fortalezas y pendientes de cara al Encuentro 32. |

## Agrupamiento

Grupos de trabajo habituales para la verificación y la entrega; parejas cruzadas dentro del grupo para el ensayo (cada integrante defiende ante un par distinto del de siempre). El docente rota escuchando un punto por integrante y prioriza a los grupos con historial de menor participación en PR.

## Ajustes para la siguiente edición

- Si el tiempo de entrega se estira, mover la ronda final frente al curso al inicio del Encuentro 32, antes de las defensas.
- Si un grupo no logra la entrega completa, registrar los faltantes en el issue de devolución y decidir con la regla de la materia para entrega incompleta (criterios de aprobación del curso).
