# Anexo docente — Encuentro 27: Git profesional: ramas y PR

## Encuadre

Primer encuentro de la Unidad 4. El grupo ya entrega por Git desde la Unidad 1 (ciclo completo del Encuentro 7), pero siempre sobre `main` en mono-rama. Hoy se introduce el flujo profesional completo: issue → rama `feature/` → PR → revisión → merge. Es la infraestructura de trabajo con la que se desarrollará el trabajo final integrador (Encuentros 29 a 31) y es requisito previo: nadie puede llegar al Encuentro 29 sin haber fusionado al menos un PR.

## Qué observar durante la clase

- Ramas creadas desde una `main` desactualizada: forzar `git switch main` + `git pull` antes de `git switch -c`.
- Issues redactados como tareas vagas («mejorar el programa»): exigir alcance, lugar y criterio de listo.
- PRs abiertos sin revisión o auto-aprobados: la revisión debe ser de otro integrante del grupo.
- Confusión entre borrar la rama en GitHub (remota) y la copia local: mostrar `git branch` antes y después.
- `git push` de la rama sin `-u origin`: mostrar el error y su significado (rama sin upstream).

## Desarrollo esperado del flujo (solución de referencia)

Estado inicial: repositorio del grupo con `tp-u1/`, `tp-u2/`, `tp-u3/` y `.gitignore` en la raíz.

```bash
# 1. Alinear main
git switch main
git pull

# 2. Crear la rama del feature
git switch -c feature/validar-edad

# 3. Editar tp-u3/agenda.py y verificar la ejecucion
python tp-u3/agenda.py

# 4. Confirmar y subir la rama
git add .
git commit -m "tp-u3: valida la edad con reintentos"
git push -u origin feature/validar-edad
```

En GitHub: **Compare & pull request** → base `main`, compare `feature/validar-edad` → descripción con `Closes #N` → **Create pull request**. Revisión por **Files changed** → **Approve** → **Merge pull request** → **Delete branch**. Cierre local:

```bash
git switch main
git pull
git log --oneline --graph -5
```

Función de referencia para `tp-u3/agenda.py` (canon: `try/except` específico, reintento, mensajes sin tildes):

```python
def pedir_entero(mensaje):
    # Pide un numero entero y reintenta hasta recibir uno valido.
    while True:
        dato = input(mensaje)
        try:
            return int(dato)
        except ValueError:
            # Entrada no numerica: se avisa y se vuelve a pedir.
            print("Debe ingresar un numero valido")
```

Uso en la carga de contactos (reemplaza el `int(input(...))` directo):

```python
# Pedir la edad validada con reintentos
edad = pedir_entero("Edad: ")
```

Prueba de los dos caminos (canon de convenciones, sección 8): entrada válida `23` y entrada inválida `abc` seguida de `23`.

## Errores previsibles

1. **Push directo a `main` por costumbre:** ocurre en los primeros minutos; se corrige moviendo el commit a la rama (`git switch -c feature/...` antes del push) o deshaciendo el push con orientación docente. Aprovechar el error para anticipar la protección de `main` del Encuentro 28.
2. **Merge sin revisión:** el botón lo permite si nadie configuró protección; por eso la revisión es controlada en el checklist de cierre.
3. **Rama con el trabajo de dos features:** exigir un issue = una rama = un PR.
4. **Olvido de `git pull` al volver a `main`:** el grupo ve «su merge no está» cuando sí está en el remoto; mostrar la diferencia entre local y remoto con `git log --oneline -3` en cada máquina.
5. **Comillas o tildes en el nombre de la rama:** los nombres de rama van en minúsculas, sin tildes y con guiones (`feature/validar-edad`).

## Criterios de logro (4-8)

| Nivel | Descripción |
|---|---|
| 4 | Crea el issue pero no logra crear la rama o empujarla. |
| 5 | Rama creada y empujada; el PR quedó sin revisión o sin merge. |
| 6 | PR fusionado con revisión; no completa el flujo en la actividad complementaria. |
| 7 | Dos ciclos issue → rama → PR → merge completados con revisión cruzada. |
| 8 | Explica con sus palabras por qué `main` estable + PR revisado mejora el trabajo en grupo, y verifica el historial con `git log --graph`. |

## Agrupamiento

Grupos de trabajo habituales (mismo repositorio). En el primer ciclo, un integrante conduce y el resto revisa; en la actividad complementaria se rota: quien revisó ahora propone. Ningún grupo con un solo integrante activo: si hay ausencias, el docente oficia de revisor del PR.

## Ajustes para la siguiente edición

- Si el grupo completa el primer PR en menos de 30 minutos, adelantar la consigna de escribir el issue con criterio de «listo» (lista de verificación dentro del issue).
- Si más del 40 % del curso no llega al merge, recortar la actividad complementaria a un solo PR por grupo y retomar la rotación en el Encuentro 28.
