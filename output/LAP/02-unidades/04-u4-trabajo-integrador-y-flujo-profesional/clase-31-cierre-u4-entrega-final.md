# Encuentro 31 — Cierre U4: entrega final

> Trabajo integrador y flujo profesional · Encuentro de cierre de unidad

## 1. Metadatos de bloque

| Campo | Detalle |
| --- | --- |
| Encuentro | 31 de 36 |
| Unidad | 4 — Trabajo integrador y flujo profesional |
| Eje temático | 4 — Trabajo integrador profesional |
| Carácter/Objetivo | Actitudinal |
| Estructura | cierre |
| Duración teórica | 120 minutos (2 horas reloj) |
| TP obligatorio | Trabajo final: programa integrador con repositorio profesional |
| Concepto nuevo | Cierre U4: entrega final |
| Requisitos previos | Encuentro 30 completado: programa integrador funcionando con todos los módulos, todos los issues cerrados, `DEFENSA.md` con el plan de cada integrante. Repositorio con `main` protegida y ramas feature mergeadas. |
| Uso de celular | No permitido |
| Organización del trabajo | Grupos de 3-4 integrantes. Primero sesión grupal de cierre y sistematización; luego cada integrante prepara su defensa individual. El docente pasa grupo por grupo para la verificación final del repositorio. |

### Reparto de tiempos teóricos (plantilla de cierre de unidad)

| Momento | Tiempo teórico |
| --- | --- |
| Apertura | 10 min |
| Consolidación | 40 min |
| Trabajo del TP | 45 min |
| Ciclo de entrega | 15 min |
| Cierre | 10 min |
| **Total** | **120 min** |

## 2. Objetivos de aprendizaje

1. Sistematizar el recorrido de la Unidad 4: desde el README y los issues hasta el programa integrador funcionando.
2. Verificar que el repositorio cumple con todos los requisitos del TP (README, issues, PRs, main protegida, programa ejecutable).
3. Preparar la exposición individual de la defensa: qué hace cada parte del programa y cómo se trabajó en equipo.
4. Realizar el commit y etiqueta final de entrega del trabajo integrador.
5. Reconocer los núcleos del año integrados en el programa final (entrada validada, condicionales, bucles, funciones, colecciones, menú en memoria).

## 3. Apertura y puente (10 min)

### Charla rápida: De las piezas sueltas al programa que funciona

Al principio del año programabas lineas sueltas en la consola. Luego aprendiste condicionales, bucles, funciones, listas y diccionarios. En la Unidad 3 empezaste a validar entrada como un profesional. Y en esta unidad no aprendiste nuevas instrucciones de Python: aprendiste a organizar tu trabajo con Git y GitHub como se hace en la industria. El trabajo final no es un ejercicio más: es la prueba de que podés construir un programa completo, solo o en equipo, desde cero, con código limpio y un repositorio profesional. Mañana en la defensa no mostrás código: mostrás que pensás como programador.

### Lo mínimo indispensable

**¿Qué entregás hoy?** El TP "Programa integrador con repositorio profesional" consiste en:

| Requisito | Cómo se verifica |
| --- | --- |
| README de portada | Se ve en la raíz del repositorio en GitHub |
| Issues con plan de trabajo | Pestaña Issues: todos cerrados o con PR mergeado |
| Ramas por feature | Pestaña Branches: deben existir las ramas feature |
| Pull requests con revisión | Pestaña Pull requests: al menos un PR por integrante revisado |
| Main protegida | Settings → Branches: regla activa |
| Programa ejecutable | `python main.py` funciona en el equipo del docente |
| Sin persistencia | No hay `.csv`, `.json`, `open(` en el código |
| DEFENSA.md | Archivo con el plan de cada integrante |

**¿Qué viene después (Encuentro 32)?** La defensa del integrador es individual. Cada integrante se sienta con el docente, abre su repositorio, explica el programa, muestra el flujo de trabajo, ejecuta el programa y responde preguntas. Duración estimada: 10-15 minutos por integrante.

## 4. Consolidación (40 min)

**Actividad de repaso de núcleos.** Cada grupo revisa su programa integrador y completa la siguiente tabla identificando dónde se aplica cada núcleo del año:

| Núcleo | ¿Dónde aparece en nuestro programa? | Archivo |
| --- | --- | --- |
| Entrada validada | `read_int()` y `read_float()` con `try/except ValueError` | `main.py` |
| Condicionales | `if choice == 1:` en el menú; `if kilos > product["kilos"]` en ventas | `main.py`, `ventas.py` |
| Bucles | `while True` del menú; `while True` de validación | `main.py` |
| Funciones | `register_product()`, `sell_product()`, `show_invoice()`, `find_product()` | todos los archivos |
| Colecciones | `list` de productos, `dict` por producto, `list` de factura | `main.py`, `productos.py`, `factura.py` |
| Menú en memoria | Sin archivos ni BD: todo en listas y dicts | `main.py` |

**Repaso del flujo profesional de Git.** Cada grupo verifica en su repositorio:

1. Que el README tenga las 6 secciones del modelo.
2. Que haya al menos 5 issues cerrados con PR mergeados.
3. Que cada integrante haya creado al menos una rama y un PR.
4. Que `main` esté protegida (Settings → Branches).
5. Que exista `.gitignore` con `__pycache__/`.

**Repaso de la defensa.** Cada integrante practica en voz baja su explicación (3-5 minutos):

1. **Apertura:** "Este es el repositorio del grupo. Yo trabajé en el módulo de XX."
2. **Demo del programa:** Ejecutar `python main.py`, mostrar 2-3 operaciones.
3. **Recorrido por issues y PRs:** "Acá está el issue #3 que me asignaron, y acá mi PR con la revisión de mi compañero."
4. **Aprendizaje:** "El error más importante que corregí fue XX."
5. **Cierre:** "Lo que más me costó fue XX y lo resolví haciendo XX."

**Cierre del repositorio.** Hacer el commit final de la unidad:

```bash
git switch main
git pull origin main
git add .
git commit -m "trabajo-final: cierre de la unidad 4 — entrega del integrador"
git push origin main
```

Opcional: crear un tag de versión.

```bash
git tag -a v1.0 -m "Entrega del trabajo final integrador — U4"
git push origin v1.0
```

## 5. Trabajo del TP (45 min)

**Consigna final:** Cada grupo prepara su repositorio para la defensa y resuelve los últimos detalles.

**Paso 1: Verificar el programa completo**

Ejecutar `python main.py` y probar:

1. Registrar "papa" (1.2, 25 kg).
2. Listar productos: debe aparecer papa al final.
3. Vender 3 kg de papa.
4. Ver factura: debe mostrar papa 3 kg × $1.20 = $3.60.
5. Intentar vender 100 kg de banana (stock: 15 kg) → "Stock insuficiente".
6. Vender 5 kg de banana.
7. Ver factura: debe tener papa y banana.
8. Elegir opción inválida (6) → "Opción inválida".
9. Ingresar letra donde va número → mensaje de validación.
10. Salir.

**Paso 2: Verificar el repositorio**

Abrir GitHub y revisar:

- ☐ README.md en la raíz visible y completo.
- ☐ Issues: todos cerrados o en estado Done.
- ☐ Pull requests: al menos 3 mergeados (uno por integrante).
- ☐ Rama `main` protegida (Settings → Branches).
- ☐ `.gitignore` con `__pycache__/` y `.vscode/`.
- ☐ `DEFENSA.md` con el plan de cada integrante.
- ☐ Último commit: mensaje de cierre.

**Paso 3: Preparar la defensa individual**

Cada integrante edita `DEFENSA.md` con su sección personal:

```markdown
# Defensa del trabajo final integrador

## Integrante: Ana López

### Módulo a cargo
Registro de productos (productos.py): funciones register_product(), list_products(),
find_product(). Validación de precio y kilos con read_float().

### Error corregido
Olvidé normalizar el nombre con .strip().lower(), entonces "Manzana" no coincidía
con "manzana" en la búsqueda. Lo corregí en todas las funciones de productos.py.

### PR revisado
Revisé el PR de Bruno (#4 — ventas.py). Verifiqué que validara stock suficiente
antes de descontar y que la factura acumulara items, no los reemplazara.

### Pregunta preparada
¿Qué pasa si dos integrantes modifican el mismo archivo en distintas ramas?
Respuesta: se produce un conflicto de merge. GitHub lo marca y hay que resolverlo
manualmente eligiendo qué cambios conservar.
```

**Pista:** En `DEFENSA.md`, cada integrante escribe su sección debajo de un encabezado con su nombre. No borren las secciones de los demás.

**Solución esperada:** Repositorio completo con todos los checkboxes marcados y `DEFENSA.md` con una sección por integrante.

## 6. Ciclo de entrega (15 min)

**Verificación del docente.** El docente pasa grupo por grupo y verifica:

1. `python main.py` funciona sin errores.
2. El repositorio de GitHub está actualizado con el último commit.
3. `DEFENSA.md` existe con secciones para todos los integrantes.
4. Cada integrante sabe qué va a decir en la defensa.

**Feedback grupal.** El docente comenta:

- **Aciertos:** qué funcionó bien en el trabajo del grupo.
- **Áreas de mejora:** qué podrían hacer distinto en un próximo proyecto.
- **Nota del TP:** confirmación de la nota grupal (aprobado/desaprobado).

**Cierre administrativo.** Cada grupo confirma que el repositorio está en condiciones de ser evaluado. Si falta algo, se anota como deuda técnica para resolver antes del Encuentro 32.

## 7. Cierre (10 min)

### Qué te llevás

- Un programa integrador que funciona y que escribiste vos: entrada validada, condicionales, bucles, funciones, listas y diccionarios, todo en un solo programa de consola.
- Un repositorio profesional: README, issues, ramas, PRs revisados y main protegida.
- El flujo de trabajo real de un equipo de desarrollo: cada tarea en su rama, revisión entre pares, integración continua.
- La experiencia de preparar y ensayar una defensa técnica: explicar tu código, justificar decisiones y mostrar resultados.

### Lo que viene

En el **Encuentro 32 — Defensa del integrador** vas a presentar tu trabajo final individualmente frente al docente. Vas a mostrar tu repositorio, ejecutar el programa, explicar tu módulo y responder preguntas sobre el código y el flujo de trabajo. Es la culminación del curso: demostrar que podés programar y trabajar en equipo como un profesional.

## 8. Errores comunes y trampas

1. **DEFENSA.md incompleto o con una sola sección.** *Causa:* un integrante escribe y los demás no contribuyen. *Fix:* cada integrante edita su propia sección y hace commit en su rama; después se mergea.

2. **Repositorio desactualizado local vs remoto.** *Causa:* hicieron commit local pero olvidaron `git push`. *Fix:* antes del ciclo de entrega, verificar en GitHub que el último commit esté visible.

3. **Programa que funciona en una máquina pero no en otra.** *Causa:* diferencia de versión de Python, archivos faltantes, rutas absolutas. *Fix:* probar `python main.py` en la máquina del docente o pasarle el repositorio clonado a otro grupo para que lo pruebe.

4. **No saber qué decir en la defensa.** *Causa:* no prepararon la explicación de su módulo. *Fix:* practicar 3 veces la explicación con el cronómetro antes del Encuentro 32.

5. **El docente encuentra un error que no vieron.** *Causa:* se saltaron la prueba de casos borde (factura vacía, stock insuficiente, opción inválida). *Fix:* correr la checklist completa antes de la entrega.

6. **No recordar el flujo de Git durante la defensa.** *Causa:* confundir `git pull` con `git push`, o no poder explicar para qué sirve una rama. *Fix:* en `DEFENSA.md`, cada integrante incluye una línea con el comando que más usó.