# Feature: Piloto evaluación U1 resiliente a IA (LPR)

El docente aprueba el informe `z-informe-evaluacion-resiliente-ia-LPR.md` y pide
los "equivalentes resilientes". Decisiones tomadas: piloto solo U1; documento
único en la raíz (convención `z-`, no vinculante); profundidad completa con
anexo docente. No toca el corpus regenerable de `output/`; si el docente lo
aprueba, el paso a producción es vía canon + render (input → output).

## Tareas

- [x] T1: relevar canon U1 completo (evaluacion-u1.md, versión A, anexo
      docente A), convenciones-técnicas.md y tabla-dominio.json.
- [x] T2: redactar `z-evaluacion-u1-resiliente-LPR.md` (instancia + versión A
      + anexo docente, en un único documento).
- [x] T3: verificar consistencia (puntajes = 100, tiempos = 120, convenciones
      técnicas, defectos sembrados independientes y observables, lint markdown).
- [x] T4: cierre (actualizar tracking, memoria, informe al docente; commit solo
      si el docente lo pide explícitamente).

## Decisiones

- Rúbrica nueva (100 pts): 18 diagnóstico de defectos + 30 completar
  `register_sale` + 10 predicción de salida + 18 extensión (recargar stock) +
  4 convenciones + 10 verificación oral de la prueba + 10 defensa del TP
  (sin cambios, canon).
- 3 defectos sembrados independientes y observables (input() str comparado con
  int; f-string sin llaves; bandera del menú que no cambia) + stub de
  `register_sale` con la especificación 2a–2f del canon.
- Propuestas del informe aplicadas: A1, A2, A3, A4, B5, B6, D9, E10.
  E12 (declaración de IA) no aplica dentro de una prueba presencial sin IA:
  queda anotado para la política del TP. E11 (instancia con IA) y C7/C8
  completos quedan para instancias posteriores.
- Versión B (biblioteca): la base es derivable con `generar-version-b.ps1`
  (tokens de tabla-dominio u1); faltan filas para los identificadores nuevos
  (register_sale, restock_item, total_units, total_money): decisión del
  docente agregarlas o renombrar al vocabulario de la tabla.

## Evidencia

- Entregable: `z-evaluacion-u1-resiliente-LPR.md` (raíz, ~640 líneas, Parte I
  instancia + Parte II versión A + Parte III anexo docente).
- Verificación estructural: rúbrica 18+30+10+18+4+10+10 = 100 pts; encuentros
  10+70+30+10 = 120 min; headings MD (1×H1, 3×H2 PARTE, H3 secciones); lint
  markdown limpio (MD025/MD036/MD040 corregidos).
- Verificación funcional: base con defectos ejecutada — opción 1 → "Opcion
  invalida" (D1), resumen imprime literal `$total_money` (D2), opción 4 →
  "Saludos!" y vuelve al menú (D3): los 3 defectos observables e independientes.
  Solución ejecutada con 14 aserciones: venta 3 uds $150.00, venta 7 uds
  $350.00/$35.00/$315.00, bordes del descuento (5 sin, 6 con), código 999,
  "abc", cantidad 0/-3 rechazada, resumen unidades=10 y dinero=$465.00,
  recarga stock 30 sin sumar a dinero, salir termina. Todo OK.
- Sin commits: el docente no pidió versionar; archivos `z-` quedan sin commitear
  por decisión del docente (precedente z-pdt-planificaciones.md).
