# Anexo docente — Encuentro 28: README y main protegida

## Encuadre

Segundo encuentro de la Unidad 4. Se consolida el flujo profesional del Encuentro 27 y se agregan las dos piezas de infraestructura que faltan: documentación de portada y protección de `main`. Al cierre, cada repositorio debe estar en condiciones de recibir el trabajo final: README legible, reglas activas y el grupo acostumbrado a trabajar por PR. No se introduce contenido nuevo de Python: el día es de Git y documentación técnica.

## Qué observar durante la clase

- READMEs con frases sueltas sin las secciones mínimas: exigir título, integrantes, contenido, ejecución y reglas de trabajo.
- Instrucciones de ejecución que nadie probó: el comando del README debe haberse corrido en la terminal del grupo.
- Protección aplicada a otra rama o sin «Require a pull request before merging»: verificar la configuración en pantalla.
- Grupo que evita el rechazo del push directo borrando la protección: es el momento de nombrar la conducta (la protección existe para el equipo, no contra él).
- `git reset --hard` ejecutado sin entender: insistir en que descarta el commit local de prueba y que solo se usa acá, sobre un commit creado a propósito para esa prueba.

## Desarrollo esperado (solución de referencia)

Orden recomendado de la secuencia completa:

```bash
# 1. Sincronizar
git switch main
git pull

# 2. Crear la rama de portada
git switch -c feature/readme-portada

# 3. Crear README.md en la raiz del repositorio y editarlo

# 4. Confirmar y subir
git add .
git commit -m "repo: readme de portada del grupo"
git push -u origin feature/readme-portada

# 5. Abrir PR, revisar entre pares y fusionar en GitHub

# 6. Activar la proteccion de main en Settings -> Branches
#    (Require a pull request before merging)

# 7. Verificar el rechazo del push directo
git switch main
git pull
echo "# prueba" >> temporal.txt
git add .
git commit -m "repo: prueba de push directo"
git push          # rechazado: protected branch hook declined
git reset --hard HEAD~1   # limpiar el commit de prueba local
```

README de referencia (contenido mínimo defendible; cada grupo lo adapta):

```markdown
# Programación en Python — Grupo N

Repositorio de trabajos de la materia Programación en Python.

## Integrantes

- Apellido, Nombre
- Apellido, Nombre

## Contenido

- `tp-u1/` — programa de consola: variables, condicionales y bucles.
- `tp-u2/` — agenda con persistencia en archivo de texto.
- `tp-u3/` — agenda con datos en JSON.
- `trabajo-final/` — proyecto integrador de la Unidad 4.

## Cómo ejecutar

Se necesita Python 3.11 (sin librerías externas).

    python tp-u3/agenda.py

## Cómo trabajamos

Cada cambio entra por issue, rama `feature/` y pull request revisado.
`main` está protegida: no se aceptan pushes directos.
```

Nota canónica: la prosa del README lleva tildes (no es código); los comandos que muestra deben copiarse tal cual y funcionar.

## Errores previsibles

1. **README en una subcarpeta:** debe estar en la raíz del repositorio; GitHub solo lo muestra como portada si está en la raíz.
2. **Protección probada con la rama equivocada:** el patrón debe ser exactamente `main`.
3. **Push directo «funcionó» porque la protección no se guardó:** verificar en Settings que la regla figure como activa antes de la prueba de rechazo.
4. **Comando de ejecución copiado del README que falla:** casi siempre falta la ruta relativa (`python tp-u3/agenda.py` desde la raíz, no `python agenda.py`).
5. **Miedo al `remote rejected`:** explicar que el rechazo no borra nada; el commit sigue local y sale por PR.

## Criterios de logro (4-8)

| Nivel | Descripción |
|---|---|
| 4 | Crea el README pero fuera de la raíz o sin secciones mínimas. |
| 5 | README correcto en la raíz; la protección de `main` no quedó activa. |
| 6 | Protección activa y README fusionado por PR; falta evidencia del rechazo del push directo. |
| 7 | Flujo completo: README por PR revisado, protección activa, rechazo observado y limpiado correctamente. |
| 8 | Además, deja documentadas en el README las reglas de trabajo del grupo y candidatas de proyecto en issues para el Encuentro 29. |

## Agrupamiento

Grupos de trabajo habituales. La configuración de protección la hace un integrante con rol de «dueño» del repositorio en GitHub; los demás verifican. La revisión del PR de portada es cruzada (otro integrante). Rotar el rol de dueño respecto del Encuentro 27 para que no siempre configure el mismo.

## Ajustes para la siguiente edición

- Si el curso tiene cuentas con restricciones para activar Branch protection (cuentas sin permisos), sustituir por el acuerdo escrito en el README y control docente del historial (`git log --oneline main` sin commits directos).
- Si un grupo no logra el rechazo en pantalla, admitir como evidencia el historial: a partir de hoy, `main` solo avanza por commits de merge de PR.
