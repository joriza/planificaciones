# Anexo docente — Encuentro 7: Git y GitHub: ciclo completo

## Encuadre

Encuentro transversal (eje 5): no hay conceptos nuevos de Python; el programa queda congelado en la versión 3 y el contenido es el ciclo completo de entrega, que en este curso se hace **una sola vez** en toda la materia. El riesgo real del encuentro no es conceptual sino logístico: cuentas de GitHub, tokens y redes del laboratorio. El docente conviene tener preparado un repositorio demo propio y haber verificado ese día que `push` funciona desde el laboratorio. El `.gitignore` con `__pycache__/` es requisito del canon desde el primer commit: es parte de la nota de la entrega.

## Qué observar durante la clase

- Grupos que crean el repo en GitHub **con** README y luego no pueden hacer `push`: decidir de antemano (repo sin README) y tener a mano la corrección.
- `git init` anidado: un grupo que inicializa en `Documentos` en vez de en `registro-notas/`; detectarlo con `git status` antes de avanzar.
- Identidad de Git sin configurar: los commits salen con un nombre genérico o el commit falla pidiendo identidad. Verificar el Paso 1 en cada máquina antes del primer commit.
- Mensajes de commit sin convención («cambios», «asd»): corregir en el momento, es el hábito más barato de instalar hoy.
- Un integrante que hace todo y tres que miran: el ejercicio exige un commit por integrante; el docente controla el historial en GitHub (los autores se ven en los commits).
- Archivos subidos de más (copias locales, `__pycache__/`): revisar el árbol del repo en el navegador al cierre.

## Solución completa del ejercicio independiente

El programa no cambia de comportamiento: cada integrante agrega una línea propia y la sube. La secuencia completa, por integrante:

```bash
# Editar tp-u1/gestion_notas.py: una mejora minima propia
# Por ejemplo, en main():
#     print("=== Registro de notas - Grupo 1 ===")

git add .
git commit -m "tp-u1: ajusta mensaje de bienvenida"
git push
```

Salida esperada del `push` (resumida):

```
Enumerating objects: 7, done.
...
To https://github.com/<organizacion-del-grupo>/registro-notas.git
   a1b2c3d..e4f5g6h  main -> main
```

Verificación final del grupo:

```bash
git log --oneline
```

Salida esperada (un commit por integrante más el inicial):

```
e4f5g6h (HEAD -> main) tp-u1: ajusta mensaje de bienvenida
b7c8d9e tp-u1: agrega linea de cierre al programa
c3d4e5f tp-u1: completa comentario de cabecera
a1b2c3d tp-u1: primera version del registro de notas
```

En GitHub, la pestaña de historial debe mostrar los mismos commits con el autor de cada uno: ese es el comprobante del ejercicio.

## Errores previsibles

1. **`.gitignore` ausente o tardío:** `__pycache__/` termina en el repo; el canon exige ignorarlo desde el primer commit (checklist de la hoja: ignorados desde el primer commit).
2. **Repo de GitHub con README inicial:** el `push` es rechazado porque el remoto tiene un commit que el local no tiene; resolver con `git pull` o recreando el repo sin README.
3. **Commit sin `add`:** «nothing to commit, working tree clean» confunde: se committeó «nada» porque nada fue elegido; `git status` siempre antes.
4. **Lógica suelta fuera de funciones en la «mejora mínima»:** la línea propia se agrega dentro de `main()`; código a nivel de módulo se ejecutaría igual al importar (defecto observado en el spike).
5. **Mensaje con tildes o sin carpeta:** «Aggregación» o «arreglo» violan la convención `<carpeta>: <resumen sin tildes>`; corregir en el siguiente commit, no reescribir el historial.
6. **Token vencido o mal pegado:** la autenticación falla en el `push` de un integrante; resolver en la actividad complementaria sin bloquear al resto del grupo.

## Criterios de logro (4-8)

| Nivel | Descripción |
|---|---|
| 4 | Inicializa el repositorio pero el commit queda vacío o se hizo en la carpeta equivocada. |
| 5 | Commit local logrado; el `push` no llega a GitHub (remoto o autenticación sin resolver). |
| 6 | Entrega en GitHub lograda con `.gitignore`; falta el commit propio de algún integrante. |
| 7 | Repositorio completo en GitHub: `.gitignore`, `tp-u1/` con el programa, un commit con mensaje convencional por integrante. |
| 8 | Además, diagnostica y resuelve en vivo un `push` rechazado o un `add` olvidado, y explica qué versión quedó en GitHub. |

## Agrupamiento

Grupos de 2 o 3 estudiantes: el repositorio es del grupo y el historial con autores distintos es la evidencia del ejercicio. Un ciclo completo por grupo en una máquina (la del proyecto o el proyector), y después el ejercicio por integrante en turnos sobre la misma carpeta compartida o sincronizando con `pull` desde su máquina.

## Ajustes para la siguiente edición

- Si la autenticación con token frena a varios grupos, dedicar los primeros 10 minutos de la actividad complementaria a generar el PAT juntos y dejarlo guardado en el gestor de credenciales.
- Si el grupo ya usó Git en otro trabajo, comprimir la teoría y usar el tiempo del desarrollo en el ejercicio por integrante y en la revisión de mensajes de commit.
