# Evaluación del momento — Saberes previos — Versión B: inscriptos de un club

## Metadatos

| Campo | Valor |
|---|---|
| Versión | B |
| Dominio de datos | Inscriptos de un club (edades) |
| Instancia | Momento de intensificación y fortalecimiento de saberes previos — Encuentros 2 y 3 |
| Duración | 60 minutos |
| Destinatarios | Grupo con la versión B asignada |
| Entrega | Hoja manuscrita con apellido, nombre y grupo; demostración de terminal frente al docente |
| Acreditación | Apto / No apto aún por objetivo mínimo (criterios de la consigna maestra) |

## Consigna

Resolver en la hoja los cinco puntos, en orden.

1. **Secuencia.** Escribir el pseudocódigo que calcula el promedio de las edades de tres inscriptos: 9, 11 y 14, y muestra el resultado.
2. **Decisión.** Escribir el pseudocódigo que, dada la edad de un inscripto, muestra «Juveniles» si supera 12, «Límite» si es exactamente 12 y «Infantiles» en el resto de los casos. Anotar un caso de verificación por rama, con el valor probado y la salida esperada.
3. **Traza.** Completar la tabla de traza del siguiente algoritmo, indicando el valor del acumulador en cada vuelta:

   ```
   acumulador = 0
   numero = 2
   Mientras numero <= 10:
       acumulador = acumulador + numero
       numero = numero + 2
   Mostrar acumulador
   ```

   | Vuelta | numero | acumulador |
   |---|---|---|
   | 1 | | |
   | 2 | | |
   | 3 | | |
   | 4 | | |
   | 5 | | |

4. **Integrador.** Escribir el pseudocódigo que lee edades de inscriptos hasta que se ingresa 0 (valor centinela), descarta las edades negativas con un aviso, cuenta cuántos inscriptos superan los 12 años, calcula el promedio de esas edades y muestra: cantidad de inscriptos juveniles, promedio de sus edades y total leído. Si ninguno supera el umbral, mostrar «No hubo inscriptos juveniles», sin dividir por cero.
5. **Terminal.** Con los comandos de la guía del curso: crear una carpeta llamada `evaluacion-previos`, ingresar a ella y listar su contenido. Anotar los comandos usados, en el orden en que se escribieron, para demostrarlos frente al docente.

**Extensión opcional**, para quien finalice antes: describir qué mostraría el punto 4 si el primer valor ingresado es 0, y por qué.

## Condiciones de resolución

- Pseudocódigo del curso: una acción por línea, con Leer, Mostrar, Si, Si no, Mientras.
- Sin Python y sin Git: todavía no se usan en la materia.
- Cada decisión se verifica con un caso por rama, anotado en la hoja.
- La traza se completa en tabla, con una fila por vuelta.

## Entrega

- Hoja manuscrita con apellido, nombre y grupo; los cinco puntos en orden.
- Demostración de la terminal frente al docente: crear la carpeta, ingresar y listar, en vivo.

## Checklist antes de entregar

- [ ] Punto 1: promedio con las tres entradas y una única salida.
- [ ] Punto 2: tres salidas posibles y un caso de verificación por rama.
- [ ] Punto 3: valor del acumulador en cada vuelta de la traza.
- [ ] Punto 4: centinela 0, descarte de negativos con aviso y aviso sin división por cero.
- [ ] Punto 5: comandos anotados en orden y demostración realizada.
