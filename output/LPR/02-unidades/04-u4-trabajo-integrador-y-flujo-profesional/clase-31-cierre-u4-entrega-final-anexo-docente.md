# Anexo docente — Encuentro 31: Cierre U4 y entrega final

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

**Consigna:** Cada grupo prepara su repositorio para la defensa y resuelve los últimos detalles.

**Checklist de verificación final:**

| Prueba | Entrada | Salida esperada |
| --- | --- | --- |
| Registrar producto | Opción 1, nombre "papa", precio 1.2, kilos 25 | Producto registrado, aparece en la lista |
| Listar productos | Opción 2 | Muestra todos los productos con precio y stock |
| Vender con stock suficiente | Opción 3, "papa", 3 kg | Venta registrada, stock actualizado |
| Vender sin stock suficiente | Opción 3, "banana", 100 kg | "Stock insuficiente" |
| Vender producto inexistente | Opción 3, "xyz" | "Producto no encontrado" |
| Ver factura vacía | Opción 4 (sin ventas previas) | "No hay ventas registradas" |
| Ver factura con ventas | Opción 4 después de vender | Muestra items y total acumulado |
| Opción inválida | Opción 6 | "Opción inválida. Elegí un número del 1 al 5." |
| Entrada no numérica donde va número | Opción 1, luego "abc" para precio | "Eso no es un número válido; intenta de nuevo." |
| Salir | Opción 5 | "Gracias por usar Verdulería. ¡Hasta la próxima!" |

**Archivos esperados en la raíz del repositorio:**
- `main.py` — programa integrador ejecutable
- `productos.py` — módulo de registro y consulta
- `ventas.py` — módulo de venta y stock
- `factura.py` — módulo de facturación
- `README.md` — README de portada completo
- `.gitignore` — con `__pycache__/` y `.vscode/`
- `DEFENSA.md` — con sección por cada integrante

## 2. Respuesta esperada del ejercicio

| Indicador | Esperado | Cómo verificar |
| --- | --- | --- |
| Programa ejecuta sin errores | `python main.py` funciona | Ejecutar en terminal |
| Checklist completa pasa | 10/10 pruebas correctas | Ejecutar cada prueba manualmente |
| DEFENSA.md existe | Archivo en la raíz | `cat DEFENSA.md` |
| DEFENSA.md tiene sección por integrante | Al menos 3 secciones | Leer el archivo |
| Issues todos cerrados | 0 issues abiertos | Pestaña Issues → Filter: Open |
| PRs mergeados | Al menos 3 | Pestaña Pull requests → Filter: Merged |
| README completo | 6 secciones visibles | Página principal del repo |
| Main protegida | Regla activa | Settings → Branches |
| .gitignore existe | `__pycache__/` y `.vscode/` | `cat .gitignore` |
| Último commit de cierre | Mensaje significativo | `git log --oneline -1` |

## 3. Criterios de corrección (lista de verificación)

| ✔ | Criterio | Peso |
| --- | --- | --- |
| ☐ | El programa pasa la checklist canónica (10/10 pruebas) | 25% |
| ☐ | DEFENSA.md existe con sección por cada integrante | 20% |
| ☐ | Todos los issues están cerrados o con PR mergeado | 15% |
| ☐ | README completo y versionado | 10% |
| ☐ | Main protegida y .gitignore existente | 10% |
| ☐ | Cada integrante tiene al menos un PR mergeado | 10% |
| ☐ | Último commit tiene mensaje de cierre | 10% |

## 4. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| DEFENSA.md incompleto | Un integrante no contribuyó | "Cada integrante debe editar su sección. Si no lo hiciste, hacelo ahora." |
| Repositorio desactualizado | Olvidaron `git push` | "Verificá en GitHub que el último commit esté visible." |
| Programa no funciona en otra máquina | Diferencia de versión o archivos faltantes | "Probá `python main.py` en la máquina del docente o pasalo a otro grupo." |
| Estudiante no sabe qué decir | No preparó la defensa | "Practicá 3 veces la explicación con el cronómetro antes del Encuentro 32." |
| Error no detectado en la prueba | Se saltaron casos borde | "Corré la checklist completa antes de la entrega." |
| No recordar el flujo de Git | Confusión con comandos | "En DEFENSA.md, incluí el comando que más usaste." |

## 5. Registro de la clase

**Por grupo, registrar:**

- [ ] Programa pasa la checklist canónica: _____ / 10
- [ ] DEFENSA.md existe y tiene sección por cada integrante: Sí / No
- [ ] Issues pendientes: _____
- [ ] PRs mergeados: _____
- [ ] Integrantes que necesitan refuerzo en código: _____
- [ ] Nota del TP: _____ (aprobado/desaprobado)
- [ ] Observaciones: _____

**Para la evaluación de proceso:**

- Si un grupo tiene menos de 8/10 en la checklist, priorizar la corrección antes de la defensa.
- Los grupos que completaron todo pueden ayudar a otros grupos como revisores pares.
- Registrar qué integrantes no tienen DEFENSA.md completa: necesitan asistencia individual.
- Anotar la nota del TP en la planilla del encuentro.
