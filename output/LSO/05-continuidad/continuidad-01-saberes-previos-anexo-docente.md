# Continuidad pedagógica — Anexo docente: Saberes previos

> Documento exclusivo para el docente. Contiene las soluciones y los criterios de corrección.
> No se entrega a los alumnos ni a la administración.

---

## Soluciones

### Actividad 1 — ¿Qué es un algoritmo? (20 ptos.)

**Definición esperada (8 ptos.):**
> Un algoritmo es una secuencia ordenada de pasos finitos y no ambiguos que resuelve un problema o realiza una tarea. No requiere una computadora para existir.

**Ejemplo cotidiano aceptable (6 ptos.):** Cualquier proceso que tenga pasos claros: preparar mate (poner agua a calentar → verter en el termo → cebar), cambiar una rueda (aflojar tuercas → levantar auto → cambiar rueda → bajar auto → ajustar tuercas), etc. Se penaliza si el ejemplo es vago («hacer la tarea» sin descomposición).

**Identificación correcta (6 ptos.):** Debe etiquetar claramente qué parte del ejemplo es entrada (p. ej., agua fría, mate y yerba), qué es procesamiento (calentar, cebar) y qué es salida (el mate listo). Si identifica dos de tres se asignan 4 ptos.

### Actividad 2 — Secuencia de instrucciones (20 ptos.)

**Pseudocódigo esperado:**

```
INICIO
    LEER alturaPersona
    SI alturaPersona <= 2.10 ENTONCES
        ESCRIBIR "Podés pasar"
    SINO
        ESCRIBIR "No podés pasar"
    FIN SI
FIN
```

- Estructura de secuencia correcta (6 ptos.): debe tener INICIO y FIN, los pasos deben estar numerados o claramente ordenados.
- Decisión correcta (6 ptos.): debe incluir una condición `alturaPersona <= 2.10` (o `altura <= 2.10`). Se acepta «menor o igual» o «<=»; no se acepta solo «menor».
- Entrada y salida identificadas (8 ptos.): la entrada es `LEER alturaPersona` y las salidas son los dos mensajes posibles.

### Actividad 3 — Tipos de datos (20 ptos.)

| Valor | Tipo | Justificación |
| --- | --- | --- |
| `25` | Entero | No tiene coma decimal ni comillas. |
| `3.1416` | Decimal | Tiene coma decimal (punto en notación informática). |
| `"Hola mundo"` | Texto / cadena | Está entre comillas. |
| `verdadero` | Valor lógico | Representa un valor booleano (verdadero/falso). |
| `0` | Entero | Es un número entero sin comillas. |
| `"45"` | Texto / cadena | Aunque parece número, está entre comillas, por lo tanto es texto. |

- Cada tipo correcto: 2 ptos. c/u (total 12 ptos.).
- Justificaciones: hasta 2 ptos. c/u si son pertinentes (total 8 ptos.). Se descuentan justificaciones genéricas como «porque sí».

### Actividad 4 — Diagrama de flujo (20 ptos.)

El diagrama debe reflejar exactamente el pseudocódigo de la Actividad 2:

```
[Óvalo: INICIO]
      ↓
[Paralelogramo: LEER alturaPersona]
      ↓
[Rombo: alturaPersona <= 2.10?]
   ⟵ sí ⟶  [Paralelogramo: ESCRIBIR "Podés pasar"]
   ⟵ no ⟶  [Paralelogramo: ESCRIBIR "No podés pasar"]
               ↓
          [Óvalo: FIN]
```

- Figuras correctas (8 ptos.): cada figura debe corresponder a la acción — óvalo en inicio y fin, paralelogramo en E/S, rombo en decisión, rectángulo en proceso. Si mezcla figuras (rombo en entrada), descuento 2 ptos. por cada error.
- Flujo coherente (6 ptos.): las flechas deben conectar sin cruces innecesarios y la dirección debe ser de arriba abajo o izquierda a derecha.
- Correspondencia exacta (6 ptos.): si el diagrama omite o agrega un paso que no está en el pseudocódigo, descuento 3 ptos.

### Actividad 5 — Variables y operaciones lógicas (20 ptos.)

**Tabla de verdad:**

| A | B | A Y B | A O B |
| --- | --- | --- | --- |
| V | V | V | V |
| V | F | F | V |
| F | V | F | V |
| F | F | F | F |

- Tabla correcta (12 ptos.): 3 ptos. por fila. Si una celda está mal, toda la fila se descuenta (no fraccionar por celda).
- Explicación cotidiana (8 ptos.): debe reflejar que la conjunción Y exige ambas condiciones verdaderas. Ejemplo: «Si está lloviendo Y no tengo paraguas → me mojo». Si da un ejemplo con O (OR) en lugar de Y, es incorrecto (0 ptos. en este ítem).

---

## Criterios generales de corrección

- **Puntaje total:** 100 puntos.
- **Presentación:** se descuenta hasta 5 ptos. si la presentación no es manuscrita o si la legibilidad impide la corrección.
- **Aprobación del repaso:** se considera cumplido si el alumno obtiene 60 ptos. o más.
- **Grupo:** se permite la resolución en grupo, pero la entrega es individual y manuscrita. Si dos entregas tienen exactamente el mismo texto, se cita a ambos alumnos a una breve defensa oral antes de descontar puntos.
- **Autoevaluación:** no se puntúa; su función es metacognitiva. El docente la revisa para ajustar el apoyo en los encuentros siguientes.