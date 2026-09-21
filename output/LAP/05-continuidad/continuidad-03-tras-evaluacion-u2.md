# Continuidad pedagógica 3 — Repaso de las Unidades 1 y 2

> Documento de continuidad pedagógica: actividades de repaso y fijación para desarrollar en una clase sin presencia docente. Se entrega a la administración para los casos de ausencia del docente. Repasa lo visto hasta su momento de uso: las Unidades 1 y 2 completas.

## Datos de referencia

| Campo | Valor |
| --- | --- |
| Curso | Programación en Python |
| Momento de uso | Tramo posterior a la Evaluación de la Unidad 2 (Encuentros 16 a 20) |
| Duración teórica | 120 minutos |
| Modalidad de trabajo | Resolución en grupo, según la organización habitual de la asignatura; presentación individual y manuscrita |
| Requisitos | Computadora con Python 3.11, VS Code y terminal; repositorio del grupo en GitHub con la carpeta `continuidad/` |

## Objetivos

- Reutilizar decisiones, bucles y acumuladores de la Unidad 1 dentro de funciones.
- Definir funciones con parámetros y valor de retorno.
- Leer y escribir archivos de texto con `with open(..., encoding="utf-8")` y los modos `"r"`, `"w"` y `"a"`.
- Manejar `FileNotFoundError` con un mensaje claro y una respuesta definida.
- Mantener la rutina de commits y push del repositorio del grupo.

## Actividades puntuadas (100 puntos · 120 minutos)

| Nº | Actividad | Tiempo | Puntaje |
| --- | --- | --- | --- |
| 1 | Mapa de dos unidades | 15 min | 10 puntos |
| 2 | Corregir los fragmentos | 30 min | 30 puntos |
| 3 | Programa de repaso: agenda mínima | 45 min | 35 puntos |
| 4 | Prueba de resistencia | 15 min | 15 puntos |
| 5 | Entrega y cierre | 15 min | 10 puntos |
| | **Totales** | **120 min** | **100 puntos** |

En cada actividad, la presentación individual manuscrita consiste en transcribir a mano el resultado indicado más una observación propia del integrante.

### Actividad 1 — Mapa de dos unidades (15 min · 10 puntos)

El grupo arma en papel una tabla de dos columnas: herramientas de la Unidad 1 (variables, decisiones, bucles, listas, cadenas) y herramientas de la Unidad 2 (funciones, archivos, manejo de errores, menú con persistencia), con un ejemplo de una línea por herramienta. Agregar una fila extra: ¿qué guarda el modo `"w"` y qué guarda el modo `"a"`?

Presentación manuscrita: la fila extra y la herramienta que a cada integrante le cueste más, con el motivo.

### Actividad 2 — Corregir los fragmentos (30 min · 30 puntos)

Los siguientes fragmentos de la agenda tienen **cinco errores sembrados**. Encontrarlos, corregirlos y anotar el síntoma que produce cada uno:

```python
# Agenda v1 - fragmentos con errores

def contar_lineas(ruta):
    # Contar cuantas lineas tiene el archivo de datos.
    with open(ruta, "r") as f:
        cantidad = 0
        for linea in f:
            cantidad = cantidad + 1
        # (la funcion termina aca)

def pedir_edad():
    # Pedir la edad como numero
    edad = input("Edad: ")
    return edad

def agregar_linea(ruta, linea_nueva):
    # Agregar una linea al final del archivo
    with open(ruta, "w", encoding="utf-8") as f:
        f.write(linea_nueva + "\n")

def cargar_agenda(ruta):
    # Leer la agenda completa
    try:
        with open(ruta, "r", encoding="utf-8") as f:
            return f.readlines()
    except:
        return []

print("Lineas en el archivo:", contar_lineas("agenda.txt"))
```

Presentación manuscrita: los cinco errores con su corrección y su síntoma.

### Actividad 3 — Programa de repaso: agenda mínima (45 min · 35 puntos)

Escribir un programa `agenda.py` con el esqueleto canónico del curso (constantes, funciones, `main()`, guard) que implemente un menú con tres opciones:

```text
1) Alta de contacto: pedir nombre, telefono y edad (la edad con
   reintento try/except ValueError) y agregarlo al final del archivo
   con el modo "a".
2) Lista de contactos: leer el archivo (una linea por contacto, campos
   separados por coma: nombre,telefono,edad), filtrar las lineas vacias
   y mostrar cada contacto con su posicion.
0) Salir: reescribir el archivo completo desde la memoria con el modo
   "w" y terminar.
```

Además: al abrir, el programa debe cargar la agenda; si el archivo no existe, avisar «No existe el archivo de datos: se empieza de cero» y arrancar con la lista vacía (`except FileNotFoundError`).

Probar el ciclo completo: primera corrida sin archivo, alta de dos contactos, salir, reabrir y verificar que la agenda persiste.

Presentación manuscrita: la lista de contactos de la segunda corrida, copiada a mano.

### Actividad 4 — Prueba de resistencia (15 min · 15 puntos)

Sobre la agenda de la Actividad 3, probar y anotar qué ocurre:

1. Borrar `agenda.txt` y volver a ejecutar: ¿qué mensaje aparece y con qué lista arranca?
2. Editar `agenda.txt` a mano dejando una línea sin las tres comas (por ejemplo, `Ana,444`): ¿qué hace el programa al listar? Corregirlo para que avise y descarte la línea dañada sin cortar.

Presentación manuscrita: qué pasaba antes y después de la corrección del caso 2.

### Actividad 5 — Entrega y cierre (15 min · 10 puntos)

Guardar `agenda.py` en la carpeta `continuidad/` del repositorio del grupo y realizar el ciclo de entrega:

```bash
git add .
git commit -m "continuidad: agenda minima con funciones y archivo"
git push
```

Presentación manuscrita: qué función del TP-U2 reutilizarían en esta agenda y por qué.

## Autoevaluación

Marcar con una cruz lo que se pueda afirmar al terminar la clase:

- [ ] Puedo definir una función con parámetros y explicar qué devuelve con `return`.
- [ ] Sé cuándo usar `"r"`, `"w"` y `"a"` y qué pasa si uso `"w"` queriendo agregar.
- [ ] Todos mis `open()` llevan `encoding="utf-8"` y van dentro de un `with`.
- [ ] Mi agenda avisa cuando el archivo no existe y arranca con la lista vacía.
- [ ] Mi programa descarta la línea dañada sin cortar y sin `except:` desnudo.
- [ ] El commit del grupo quedó subido a GitHub con el mensaje pedido.

## Nota académica

La resolución de las actividades se realiza en la forma habitual de la asignatura, por lo general en grupo. Las tareas de programación requieren el uso de la computadora. La presentación es individual y manuscrita, al inicio de la próxima clase, y constituye una actividad más de la asignatura que forma parte del proceso de evaluación.
