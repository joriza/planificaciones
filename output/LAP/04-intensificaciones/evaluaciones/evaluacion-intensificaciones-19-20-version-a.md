# Evaluación del momento integrador — Versión A: comisión de examen

## Metadatos

| Campo | Valor |
|---|---|
| Versión | A |
| Dominio de datos | Asistencia de una comisión de examen (`comision.txt`, formato `nombre,apellido,curso,estado`) |
| Instancia | Momento integrador de las Unidades 1 y 2 (proyecto puente) — Encuentros 19 y 20 |
| Duración | 60 minutos (desarrollo, entrega y defensa) |
| Destinatarios | Grupo con la versión A asignada |
| Entrega | Carpeta `intensificacion-19-20/` del repositorio del grupo: `asistencia.py` y `comision.txt` |
| Aprobación | 60 puntos o más de 100 (rúbrica de la consigna maestra) y defensa breve del grupo con resultado apto |

## Consigna

Desarrollar `intensificacion-19-20/asistencia.py` en el repositorio del grupo: un programa de consola que administra la asistencia de una jornada de examen de la comisión, con los datos en `comision.txt` junto al programa, una línea por estudiante en el formato `nombre,apellido,curso,estado`, donde el estado es P (presente), A (ausente) o T (tardío).

Archivo inicial (crear `comision.txt` con este contenido):

```
Ana,Paz,5A,P
Bruno,Diaz,5A,A
Camila,Rojas,5B,T
Diego,Sosa,5B,P
Elena,Vidal,5A,P
```

1. Cargar los registros al inicio desde `comision.txt` con `with open(..., "r", encoding="utf-8")`; si el archivo no existe, mostrar «No existe el archivo de datos: se empieza de cero» y arrancar con la lista vacía. Cada línea se separa con `split(",")` y cada campo se limpia con `.strip()`.
2. Mostrar un menú con las opciones: 1) Listado del día, 2) Cambiar estado, 0) Salir. La opción se lee con `int()`; ante un valor no numérico, mostrar «Debe ingresar un numero valido» y volver a pedir.
3. Listado del día: recorrer los registros con `for` y mostrar cada estudiante con su condición — P muestra «Presente», A muestra «Ausente», T muestra «Tardío» — decidida con `if/elif/else`; al final, mostrar el total de presentes contado con un acumulador. Con la lista vacía, mostrar «No hay registros cargados».
4. Cambiar estado: pedir el apellido, buscar el registro y pedir el nuevo estado; validar con `if/elif/else` que sea P, A o T antes de guardarlo; si el apellido no está, mostrar «No se encontro ese apellido».
5. Salir: guardar todos los registros en `comision.txt` con `with open(..., "w", encoding="utf-8")`, una línea por estudiante, y terminar el programa.

## Requisitos técnicos (canon de la materia)

- Esqueleto canónico: constantes (`RUTA_DATOS`), funciones con `def`, `def main():` y guard `if __name__ == "__main__":` al final.
- Al menos cuatro funciones: `cargar_registros()`, `listado_del_dia()`, `cambiar_estado()` y `guardar_registros()`, cada una con una responsabilidad única.
- Toda conversión numérica en el renglón del `input()`, bajo `try/except ValueError`, con reingreso.
- Apertura de archivos siempre con `with open(ruta, modo, encoding="utf-8")`; `FileNotFoundError` con lista vacía y aviso.
- `split(",")` y `.strip()` en cada línea del archivo de datos; excepciones específicas siempre, sin `except:` desnudo.
- Mensajes y comentarios en español, sin tildes ni eñes dentro del código; un comentario por cada acción.

## Pruebas mínimas

- Caso normal: cambiar un estado, salir, reabrir el programa y listar; abrir `comision.txt` desde VS Code y verificar qué quedó escrito.
- Caso de error: renombrar `comision.txt` y reabrir; el programa avisa y arranca con la lista vacía. Ingresar una letra en la opción del menú; buscar un apellido inexistente; ingresar un estado distinto de P, A o T.

## Entrega

```bash
git add .
git commit -m "intensificacion-19-20: entrega de la version A"
git push
```

Verificar en GitHub que quedó publicada la carpeta `intensificacion-19-20/` con `asistencia.py` y `comision.txt`.

## Defensa breve del grupo

En no más de tres minutos: el programa corriendo con un dato válido; una decisión de diseño; un error anticipado y cómo lo previene el programa.

## Checklist antes de entregar

- [ ] Esqueleto canónico: constantes, funciones con `def`, `main()` y guard.
- [ ] Cuatro funciones con responsabilidad única; el menú repite con `while`.
- [ ] `with open(..., encoding="utf-8")` en lectura y escritura; `FileNotFoundError` manejado con lista vacía.
- [ ] `split(",")` y `.strip()` en cada línea; opción del menú con `int()` y `ValueError` con reintento.
- [ ] Condición P/A/T con `if/elif/else`; total de presentes con acumulador.
- [ ] Ciclo marcar-salir-reabrir-listar verificado con el archivo abierto en VS Code.
- [ ] `commit` y `push` hechos y verificados en GitHub.
