# Anexo docente — Evaluación del momento 02-03 — Versión B

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión B, las respuestas esperadas de los ítems conceptuales, los criterios de corrección ítem por ítem y la pauta de devolución.
>
> Esta versión es equivalente a la versión A con dominio sustituido (biblioteca de aula en lugar de kiosco escolar). Las soluciones y criterios son los mismos; solo cambian los datos de ejemplo y el contexto del dominio.

## 1. Solución completa

No aplica para esta versión (sin Python aún). La corrección se realiza en papel contra las respuestas esperadas que se detallan a continuación. Los datos de ejemplo usan el dominio de la biblioteca de aula en lugar del kiosco escolar.

## 2. Salidas de referencia para la corrección

| Prueba | Pedido | Respuesta esperada | Comando de verificación |
| --- | --- | --- | --- |
| 1.1 | Pasos para preparar un mate | Secuencia numerada de al menos 6 pasos lógicos (ej.: 1. Llenar la taza con agua, 2. Encender el termo, 3. Colocar el mate en la base, etc.) | Revisión de coherencia y orden lógico |
| 1.2 | Ubicación de `notas.txt` | Carpeta `proyecto` dentro de `documentos`; el comando que lo crea es `touch notas.txt` | Verificar que el alumno identifique `mkdir proyecto` y `touch notas.txt` |
| 1.3 | Diagrama de flujo de nota | Óvalo (inicio) → Rectángulo (leer nota) → Rombo (nota ≥ 7) → Rectángulo (mostrar Aprobado) o Rectángulo (mostrar Recuperatorio) → Óvalo (fin) | Verificar que el rombo tenga dos salidas (sí/no) y que cada una lleve a un rectángulo de salida |
| 2.1 | Diagrama de flujo del mayor | Rombo con comparación `a > b`, luego comparación del mayor con `c`; rectángulos para asignación y salida | Verificar que el diagrama cubre los tres casos (a mayor, b mayor, c mayor) |
| 2.2 | Pseudocódigo de suma 1-100 | `suma ← 0`, `para i desde 1 hasta 100`, `suma ← suma + i`, `mostrar suma` | Verificar que la variable de acumulación se inicializa en 0 y se actualiza dentro del bucle |
| 2.3 | Cantidad de iteraciones | 50 iteraciones (valores de i: 1, 3, 5, 7, ..., 99) | Verificar el cálculo: (99 - 1) / 2 + 1 = 50 |
| 3.1 | Identificación de estructuras | Decisión: condición de fondos suficientes; Repetición: no aplica (o validación de entrada si se incluye) | Verificar que identifica correctamente la estructura de decisión |
| 3.2 | Relación símbolo-código | Óvalo → inicio/fin del programa; Rectángulo → proceso/asignación; Rombo → `if`/`while`; Flecha → flujo de ejecución | Verificar cada correspondencia |

## 3. Criterios de corrección ítem por ítem

- **1.1 (10 pts):** Se puntúa cada paso lógico correcto y en orden. Mínimo 6 pasos para puntaje completo. Pasos redundantes o fuera de orden restan puntos.
- **1.2 (10 pts):** 5 pts por identificar correctamente la carpeta de destino (`proyecto` dentro de `documentos`). 5 pts por identificar el comando correcto (`touch notas.txt`).
- **1.3 (10 pts):** 5 pts por el diagrama completo con los símbolos correctos. 5 pts por las flechas de flujo correctas (sí → Aprobado, no → Recuperatorio).
- **2.1 (15 pts):** 10 pts por el diagrama con las comparaciones correctas. 5 pts por la salida correcta (mostrar el mayor).
- **2.2 (15 pts):** 10 pts por el pseudocódigo correcto con variable de acumulación y bucle. 5 pts por el resultado final correcto (5050).
- **2.3 (10 pts):** 10 pts por la respuesta correcta (50) y la justificación correcta.
- **3.1 (15 pts):** 10 pts por identificar la decisión (condición de fondos). 5 pts por indicar si hay o no repetición.
- **3.2 (15 pts):** 3 pts por cada correspondencia correcta (4 ítems × 3 pts = 12 pts). Se puntúa la relación conceptual, no la memorización exacta del término.

**Total:** 100 puntos. Criterio de Apto: ≥ 60 puntos.

**Errores previstos y criterio de intervención:**
- Si el alumno confunde secuencia con decisión, pedirle que identifique dónde hay un punto de bifurcación.
- Si el alumno no distingue `cd` de `mkdir`, reforzar con el ejemplo de la carpeta `proyecto`.
- Si el alumno no logra el diagrama del mayor con dos comparaciones, aceptar una versión con comparaciones encadenadas.

## 4. Pauta de devolución

La devolución se realiza en el encuentro siguiente (E4). Se devuelve con nota de Apto o No apto aún por objetivo mínimo. Si el objetivo mínimo queda pendiente, se ofrece la instancia de intensificación de los encuentros 17-18 como primera capa de recuperación y la de diciembre como segunda capa. Se registra la nota en la planilla de evaluación y se anota la letra de la versión asignada.