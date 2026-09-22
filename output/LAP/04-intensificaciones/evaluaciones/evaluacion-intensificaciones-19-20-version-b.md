# Evaluación del momento 19-20 — Versión A

> Dominio de esta versión: taller de barrio (herramientas, cuotas, vencimientos). Duración: 90 minutos por encuentro. Puntaje total: 100 puntos según rúbrica. Resolución individual, con computadora, sin celular. Las condiciones completas están en `evaluacion-intensificaciones-19-20.md`.

## Antes de empezar

- Crea un archivo `taller.py` en la carpeta `tp-u2/` de tu repo grupal.
- Escribí el programa en un solo archivo `.py`. Definí las funciones primero, el bloque de ejecución al final con `if __name__ == "__main__":`.
- No uses archivos ni base de datos: todo se almacena en listas y diccionarios en memoria.
- No se permite celular. Trabajo individual.
- Al terminar cada encuentro, hace commit y push.

## Objetivos de la prueba

- Integrar entrada/salida, condicionales, bucles, listas, diccionarios y funciones en un solo programa.
- Organizar el código con funciones y bloque principal.
- Validar entrada de datos mínimamente.
- Entregar en GitHub con commit y README.

## Consigna — Sistema de gestión de herramientas de un taller de barrio

Escribí un programa que gestione los **herramientas** de un **taller** de barrio. Cada **herramienta** es un diccionario con las claves:
- `"nombre"`: string
- `"edad"` (`toolCondition`): entero
- `"depósito"` (`toolDeposit`): float (monto de la depósito mensual)
- `"devolución"`: string (mes de devolución, ej: "marzo")

Los herramientas se almacenan en una lista de diccionarios.

### Menú principal (con `while True`)

```
=== SISTEMA DE HERRAMIENTAS DEL TALLER ===
1. Agregar herramienta
2. Listar todos los herramientas
3. Buscar herramienta por nombre
4. Mostrar herramientas activos (depósito al día)
5. Mostrar herramientas con depósito vencida
6. Salir
```

### Funciones requeridas (mínimo)

| Función | Descripción |
|---------|-------------|
| `agregar_socio(toolList)` | Pide nombre, edad, depósito y devolución. Crea un diccionario y lo agrega a la lista. Valida que edad y depósito sean números (con `try`/`except`). |
| `listar_socios(toolList)` | Recorre la lista con `for` y muestra cada herramienta con formato. |
| `buscar_socio(toolList, nombre)` (`findTool`) | Busca por nombre en la lista. Devuelve el diccionario o "Herramienta no encontrado". |
| `socios_activos(toolList, mes_actual)` (`availableTools`) | Filtra los herramientas cuyo devolución es igual o posterior al mes actual. Los devuelve en una nueva lista. |
| `socios_vencidos(toolList, mes_actual)` | Filtra los herramientas con devolución anterior al mes actual. |

### Rúbrica de 100 puntos

| Dimensión | Puntaje | Indicadores |
| --- | --- | --- |
| Entrada y condicionales | 20 pts | Usa `input()` y `int()`/`float()` correctamente. Aplica `if`/`elif`/`else` para decidir flujo del menú y validar datos. |
| Bucles | 15 pts | Usa `while` para el menú principal. Usa `for` para recorrer listas y diccionarios. |
| Listas y diccionarios | 25 pts | Almacena herramientas como diccionarios dentro de una lista. Opera sobre la lista (agregar, eliminar, buscar, listar). |
| Funciones y bloque principal | 20 pts | Define funciones con `def`, parámetros y `return`. Organiza el programa con `if __name__ == "__main__"`. |
| Calidad del código | 10 pts | Nombres descriptivos, comentarios útiles, código sin líneas muertas, entrada validada mínimamente. |
| Entrega y defensa | 10 pts | Repositorio GitHub actualizado con commit del proyecto. Breve explicación oral del programa y las decisiones tomadas. |

**Aprobado**: ≥ 60 puntos. **Destacado**: ≥ 85 puntos.

### Formato de salida esperado

```
=== SISTEMA DE HERRAMIENTAS DEL TALLER ===
1. Agregar herramienta
2. Listar todos los herramientas
3. Buscar herramienta por nombre
4. Mostrar herramientas activos
5. Mostrar herramientas con depósito vencida
6. Salir
Opción: 1
Nombre: Carlos
Edad: 34
Depósito: 1500
Devolución: mayo
Herramienta agregado correctamente.
```

## Al terminar

Commit final con mensaje `"feat: proyecto puente taller completo"` y push al repo grupal. Prepara una breve explicación oral (2 minutos) sobre qué hace tu programa, cómo elegiste las estructuras de datos y qué función te costó más.