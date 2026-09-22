# Anexo docente — Continuidad pedagógica 01: Saberes previos

> Documento docente formal. No se entrega a los alumnos: contiene las soluciones completas de cada actividad, los criterios de corrección, los errores previstos y su intervención.

## 1. Soluciones de las actividades

### Actividad 1 — Algoritmo cotidiano (papel, 20 pts)

**Consigna:** Escribir paso a paso el algoritmo para retirar dinero de un cajero automático.

**Solución esperada (ejemplo completo):**

```
INICIO
1. Dirigirse al cajero automático más cercano
2. Tomar la tarjeta de débito
3. Insertar la tarjeta en la ranura (con el chip hacia adelante)
4. Esperar que la pantalla muestre el menú principal
5. Seleccionar la opción "Extracción" o "Retiro"
6. Elegir el tipo de cuenta (caja de ahorro / cuenta corriente)
7. Ingresar el monto a retirar con el teclado numérico
8. Esperar que el sistema verifique el saldo disponible
9. Confirmar la operación presionando "Aceptar"
10. Retirar el dinero de la bandeja de salida
11. Retirar la tarjeta de la ranura
12. Tomar el comprobante (opcional)
FIN
```

**Criterios de corrección:**
- **Pasos claros (10 pts):** la secuencia tiene al menos 8 pasos identificables, no salta etapas importantes (insertar tarjeta, elegir monto, retirar dinero, retirar tarjeta).
- **Orden correcto (5 pts):** los pasos están en un orden lógico; no se retira dinero antes de insertar la tarjeta.
- **Inicio y fin identificados (5 pts):** marca explícitamente dónde arranca y dónde termina.

**Errores frecuentes:**
- Secuencia incompleta (olvidan retirar la tarjeta).
- Saltan pasos intermedios (ej.: pasan directo de insertar tarjeta a recibir dinero sin elegir monto).
- Confunden "algoritmo" con "explicación general" sin pasos numerados.
- **Intervención docente:** "Un algoritmo tiene que ser tan detallado que cualquier persona pueda seguirlo sin preguntar. Si tuvieras que enseñarle a un robot, ¿le faltaría algún paso?"

---

### Actividad 2 — Decisiones en la vida diaria (papel, 20 pts)

**Consigna:** Leer cada situación y responder escribiendo la condición y la decisión.

**Solución esperada:**

**(a) Salir con paraguas**
- Condición: "¿Está lloviendo?" o "¿Hay probabilidad de lluvia mayor al 50%?"
- Decisión: Si es Sí → llevo paraguas. Si es No → no llevo paraguas.
- Variante aceptable: "Si el cielo está nublado y el pronóstico indica lluvia, llevo paraguas; si no, no llevo."

**(b) Elegir transporte para llegar a horario**
- Condición: "¿La distancia es menor a 2 km?" y "¿Tengo tiempo para caminar?"
- Decisión: Si distancia < 2 km Y tengo tiempo → camino. Si no → tomo colectivo/subte.
- Variante: usan "O" en lugar de "Y" — evaluar si la combinación es lógica.

**(c) Decidir si un número es par o impar**
- Condición: "Si el número dividido por 2 da resto 0 → es par. Si el resto es 1 → es impar."
- Explicación esperada: mencionar el concepto de resto de la división (módulo).

**Criterios de corrección:**
- **Condición bien identificada (10 pts, ~3 pts c/u):** cada respuesta nombra la condición que se evalúa.
- **Decisión clara (10 pts, ~3 pts c/u):** indica el "camino" para cada resultado de la condición.

**Errores frecuentes:**
- Confunden condición con decisión ("la decisión es que llueve").
- No consideran ambos caminos (solo escriben lo que hacen si se cumple).
- En (c): no mencionan el resto o usan "dividir y ver si da exacto" sin explicación.
- **Intervención docente:** "Preguntate siempre: ¿qué pasa si la condición NO se cumple?"

---

### Actividad 3 — Operaciones y prioridad (papel, 20 pts)

**Solución esperada:**

| Expresión | Orden de evaluación | Resultado |
|-----------|---------------------|-----------|
| (a) `2 + 3 × 4` | 1º: 3×4=12 ; 2º: 2+12=14 | **14** |
| (b) `(2 + 3) × 4` | 1º: (2+3)=5 ; 2º: 5×4=20 | **20** |
| (c) `10 − 4 ÷ 2 + 1` | 1º: 4÷2=2 ; 2º: 10−2=8 ; 3º: 8+1=9 | **9** |
| (d) `8 ÷ 2 × (2 + 2)` | 1º: (2+2)=4 ; 2º: 8÷2=4 ; 3º: 4×4=16 | **16** |

**Explicación esperada:** "La regla es: primero paréntesis, luego multiplicación y división (de izquierda a derecha), y por último suma y resta (de izquierda a derecha)."

**Criterios de corrección:**
- **Resultado numérico correcto (12 pts, 3 pts c/u):** cada resultado correcto.
- **Orden de evaluación indicado (4 pts, 1 pt c/u):** muestra o explica el orden parcial.
- **Explicación de la regla (4 pts):** menciona paréntesis, multiplicación/división, suma/resta.

**Errores frecuentes:**
- Resuelven de izquierda a derecha sin aplicar prioridad (ej.: 2+3×4 = 20).
- Confunden paréntesis con prioridad implícita.
- En (d): hacen 8÷2=4, 4×(2+2)=4×4=16... pero muchos hacen (2+2)=4, 8÷2×4 y lo resuelven mal.
- **Intervención docente:** "La multiplicación y la división tienen la misma prioridad, así que se resuelven de izquierda a derecha. No es que la multiplicación 'va primero' siempre."

---

### Actividad 4 — Árbol de directorios (papel, 20 pts)

**Árbol dado en la consigna:**

```
Inicio/
├── Documentos/
│   ├── Trabajos/
│   │   ├── informe.docx
│   │   └── resumen.pdf
│   └── fotos/
│       └── foto.jpg
├── Música/
│   └── canción.mp3
└── receta.txt
```

**Solución esperada:**

(a) `Documentos/` contiene 2 carpetas: `Trabajos/` y `fotos/`.
(b) Ruta desde `Inicio` hasta `foto.jpg`: `Inicio/Documentos/fotos/foto.jpg` (o `Documentos/fotos/foto.jpg` si parte de Inicio).
(c) Desde `Música/` hasta `receta.txt`: volver a `Inicio/` (con `..`) y luego acceder a `receta.txt`: `../receta.txt` o `Inicio/receta.txt` (en concepto, subir un nivel y tomar el archivo).
(d) Dentro de `Trabajos/` están: `informe.docx` y `resumen.pdf`.

**Criterios de corrección:**
- (a) 5 pts: identifica que son carpetas, no archivos.
- (b) 5 pts: la ruta es correcta y completa.
- (c) 5 pts: entiende que hay que "subir" hasta el padre común.
- (d) 5 pts: lista ambos archivos.

**Errores frecuentes:**
- Confunden archivos con carpetas en el conteo.
- En (c), intentan una ruta que pasa por otras carpetas sin volver al padre.
- **Intervención docente:** "Las rutas siempre se escriben desde donde estás hasta donde querés llegar. Si necesitás salir de donde estás, usás `..` (el padre)."

---

### Actividad 5 — Tarea en computadora: estructura de carpetas (terminal, 20 pts)

**Solución completa (secuencia de comandos):**

Abrir la terminal y ejecutar:

```bash
# Crear la estructura principal
mkdir python-curso
mkdir python-curso/unidad-1
mkdir python-curso/unidad-2
mkdir python-curso/unidad-3
mkdir python-curso/trabajo-final

# Crear subcarpetas dentro de unidad-1
mkdir python-curso/unidad-1/ejercicios
mkdir python-curso/unidad-1/tp

# Verificar la estructura
ls -R python-curso
```

**Variante con un solo comando (mkdir -p):**

```bash
mkdir -p python-curso/{unidad-1/{ejercicios,tp},unidad-2,unidad-3,trabajo-final}
ls -R python-curso
```

**Salida esperada de `ls -R python-curso`:**

```
python-curso/:
trabajo-final/  unidad-1/  unidad-2/  unidad-3/

python-curso/unidad-1:
ejercicios/  tp/

python-curso/unidad-2:

python-curso/unidad-3:

python-curso/trabajo-final:
```

**Criterios de corrección:**
- **Estructura correcta (10 pts):** las 4 carpetas principales existen y las 2 subcarpetas dentro de `unidad-1/` están creadas.
- **Comandos anotados (5 pts):** el estudiante escribe los comandos que usó (al menos `mkdir`, `ls`).
- **Verificación (5 pts):** corre `ls` o `dir` para confirmar la estructura.

**Errores frecuentes:**
- Crean carpetas con espacios en el nombre sin escaparlos.
- No verifican con `ls`; asumen que se creó bien.
- Usan el mouse (Explorador de Archivos) en lugar de la terminal.
- **Intervención docente:** "La terminal no tiene 'deshacer'. Si creaste algo mal, borrá con `rmdir` (o `rm -r` con cuidado). La práctica es crear sabiendo lo que ponés."

---

## 2. Criterios de logro generales

| Condición | Criterio |
|---|---|
| Logrado (≥70 pts) | El estudiante escribe algoritmos con pasos ordenados, distingue condiciones y decisiones, opera con prioridad aritmética, lee un árbol de directorios y crea carpetas desde la terminal sin ayuda. |
| En proceso (40–69 pts) | El estudiante reconoce los conceptos pero comete errores de orden, omisión o sintaxis de comandos; requiere práctica adicional. |
| Requiere apoyo (<40 pts) | El estudiante no logra estructurar un algoritmo, confunde condiciones con acciones, o no puede operar la terminal. Se sugiere intensificación específica. |

## 3. Nota para el docente

Esta actividad se aplica **antes del inicio de la Unidad 1** (encuentros 2-3 o en una clase previa). Su función es reactivar saberes previos y detectar estudiantes que requieran intensificación en conceptos pre-Python. No reemplaza el diagnóstico inicial sino que lo complementa como herramienta de nivelación. Los resultados pueden usarse para conformar los grupos de intensificación/fortalecimiento de los primeros encuentros.