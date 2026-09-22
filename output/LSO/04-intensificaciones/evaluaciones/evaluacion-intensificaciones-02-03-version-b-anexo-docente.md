# Anexo docente — Evaluación del momento 02-03 — Versión B

> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión B, las respuestas esperadas de los ítems conceptuales, los criterios de corrección ítem por ítem y la pauta de devolución.

## 1. Solución completa

No aplica para esta versión (sin C# aún). La corrección se realiza en papel contra las respuestas esperadas que se detallan a continuación.

## 2. Salidas de referencia para la corrección

| Prueba | Pedido | Respuesta esperada | Comando de verificación |
| --- | --- | --- | --- |
| 1.1 | Pasos para hacer un café con máquina | Secuencia numerada de al menos 6 pasos lógicos (ej.: 1. Llenar el tanque con agua, 2. Encender la máquina, 3. Colocar la cápsula o café, 4. Posar la taza, 5. Iniciar la extracción, 6. Apagar la máquina) | Revisión de coherencia y orden lógico |
| 1.2 | Ubicación de `notas.txt` | Carpeta `proyecto-final` dentro de `descargas`; el comando que lo crea es `touch notas.txt` | Verificar que el alumno identifique `mkdir proyecto-final` y `touch notas.txt` |
| 1.3 | Diagrama de flujo de temperatura | Óvalo (inicio) → Rectángulo (leer temperatura) → Rombo (temperatura > 30) → Rectángulo (mostrar «Día caluroso») o Rectángulo (mostrar «Día normal») → Óvalo (fin) | Verificar que el rombo tenga dos salidas (sí/no) y que cada una lleve a un rectángulo de salida |
| 2.1 | Diagrama de flujo del mayor de cinco números | Rombo con comparaciones encadenadas o anidadas (mayor ← primer número; para cada siguiente: si número > mayor, mayor ← número); rectángulos para asignación y salida final | Verificar que el diagrama cubre los cinco números y que la salida ocurre una sola vez al final |
| 2.2 | Pseudocódigo de suma 1-50 | `suma ← 0`, `para i desde 1 hasta 50`, `suma ← suma + i`, `mostrar suma` | Verificar que la variable de acumulación se inicializa en 0 y se actualiza dentro del bucle |
| 2.3 | Cantidad de iteraciones | 7 iteraciones (valores de i: 2, 5, 8, 11, 14, 17, 20) | Verificar el cálculo: (20 - 2) / 3 + 1 = 7 |
| 3.1 | Identificación de estructuras (vending machine) | Decisión: condición de moneda suficiente; Repetición: no aplica (o validación de entrada si se incluye) | Verificar que identifica correctamente la estructura de decisión |
| 3.2 | Relación símbolo-código | Óvalo → inicio/fin del programa; Rectángulo → proceso/asignación; Rombo → `if`/`while`; Flecha → flujo de ejecución | Verificar cada correspondencia |

## 3. Criterios de corrección ítem por ítem

- **1.1 (10 pts):** Se puntúa cada paso lógico correcto y en orden. Mínimo 6 pasos para puntaje completo. Pasos redundantes o fuera de orden restan puntos.
- **1.2 (10 pts):** 5 pts por identificar correctamente la carpeta de destino (`proyecto-final` dentro de `descargas`). 5 pts por identificar el comando correcto (`touch notas.txt`).
- **1.3 (10 pts):** 5 pts por el diagrama completo con los símbolos correctos. 5 pts por las flechas de flujo correctas (sí → «Día caluroso», no → «Día normal»).
- **2.1 (15 pts):** 10 pts por el diagrama con las comparaciones correctas (cinco números). 5 pts por la salida correcta (mostrar el mayor).
- **2.2 (15 pts):** 10 pts por el pseudocódigo correcto con variable de acumulación y bucle. 5 pts por el resultado final correcto (1275).
- **2.3 (10 pts):** 10 pts por la respuesta correcta (7) y la justificación correcta.
- **3.1 (15 pts):** 10 pts por identificar la decisión (moneda suficiente / insuficiente). 5 pts por indicar si hay o no repetición.
- **3.2 (15 pts):** 3 pts por cada correspondencia correcta (4 ítems × 3 pts = 12 pts). Se puntúa la relación conceptual, no la memorización exacta del término.

**Total:** 100 puntos. Criterio de Apto: ≥ 60 puntos.

**Errores previstos y criterio de intervención:**
- Si el alumno confunde secuencia con decisión, pedirle que identifique dónde hay un punto de bifurcación.
- Si el alumno no distingue `cd` de `mkdir`, reforzar con el ejemplo de la carpeta `proyecto-final`.
- Si el alumno no logra el diagrama del mayor de cinco números, aceptar una versión con comparaciones encadenadas o con un acumulador «mayor hasta ahora».

## 4. Pauta de devolución

La devolución se realiza en el encuentro siguiente. Se devuelve con nota de Apto o No apto aún por objetivo mínimo. Si el objetivo mínimo queda pendiente, se ofrece la instancia de intensificación de los encuentros 17-18 como primera capa de recuperación y la de diciembre como segunda capa. Se registra la nota en la planilla de evaluación y se anota la letra de la versión asignada.
