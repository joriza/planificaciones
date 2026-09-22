# Evaluación del momento 19-20 — Versión A

> Dominio de esta versión: club de barrio (socios, cuotas, vencimientos). Duración: 90 minutos por encuentro. Puntaje total: 100 puntos según rúbrica. Resolución individual, con computadora, sin celular. Las condiciones completas están en `evaluacion-intensificaciones-19-20.md`.

## Antes de empezar

- Crea un archivo `club.py` en la carpeta `tp-u2/` de tu repo grupal.
- Escribí el programa en un solo archivo `.py`. Definí las funciones primero, el bloque de ejecución al final con `if __name__ == "__main__":`.
- No uses archivos ni base de datos: todo se almacena en listas y diccionarios en memoria.
- No se permite celular. Trabajo individual.
- Al terminar cada encuentro, hace commit y push.

## Objetivos de la prueba

- Integrar entrada/salida, condicionales, bucles, listas, diccionarios y funciones en un solo programa.
- Organizar el código con funciones y bloque principal.
- Validar entrada de datos mínimamente.
- Entregar en GitHub con commit y README.

## Consigna — Sistema de gestión de socios de un club de barrio

Escribí un programa que gestione los **socios** de un **club** de barrio. Cada **socio** es un diccionario con las claves:
- `"nombre"`: string
- `"edad"` (`memberAge`): entero
- `"cuota"` (`clubFee`): float (monto de la cuota mensual)
- `"vencimiento"`: string (mes de vencimiento, ej: "marzo")

Los socios se almacenan en una lista de diccionarios.

### Menú principal (con `while True`)

```
=== SISTEMA DE SOCIOS DEL CLUB ===
1. Agregar socio
2. Listar todos los socios
3. Buscar socio por nombre
4. Mostrar socios activos (cuota al día)
5. Mostrar socios con cuota vencida
6. Salir
```

### Funciones requeridas (mínimo)

| Función | Descripción |
|---------|-------------|
| `agregar_socio(memberList)` | Pide nombre, edad, cuota y vencimiento. Crea un diccionario y lo agrega a la lista. Valida que edad y cuota sean números (con `try`/`except`). |
| `listar_socios(memberList)` | Recorre la lista con `for` y muestra cada socio con formato. |
| `buscar_socio(memberList, nombre)` (`findMember`) | Busca por nombre en la lista. Devuelve el diccionario o "Socio no encontrado". |
| `socios_activos(memberList, mes_actual)` (`activeMembers`) | Filtra los socios cuyo vencimiento es igual o posterior al mes actual. Los devuelve en una nueva lista. |
| `socios_vencidos(memberList, mes_actual)` | Filtra los socios con vencimiento anterior al mes actual. |

### Rúbrica de 100 puntos

| Dimensión | Puntaje | Indicadores |
| --- | --- | --- |
| Entrada y condicionales | 20 pts | Usa `input()` y `int()`/`float()` correctamente. Aplica `if`/`elif`/`else` para decidir flujo del menú y validar datos. |
| Bucles | 15 pts | Usa `while` para el menú principal. Usa `for` para recorrer listas y diccionarios. |
| Listas y diccionarios | 25 pts | Almacena socios como diccionarios dentro de una lista. Opera sobre la lista (agregar, eliminar, buscar, listar). |
| Funciones y bloque principal | 20 pts | Define funciones con `def`, parámetros y `return`. Organiza el programa con `if __name__ == "__main__"`. |
| Calidad del código | 10 pts | Nombres descriptivos, comentarios útiles, código sin líneas muertas, entrada validada mínimamente. |
| Entrega y defensa | 10 pts | Repositorio GitHub actualizado con commit del proyecto. Breve explicación oral del programa y las decisiones tomadas. |

**Aprobado**: ≥ 60 puntos. **Destacado**: ≥ 85 puntos.

### Formato de salida esperado

```
=== SISTEMA DE SOCIOS DEL CLUB ===
1. Agregar socio
2. Listar todos los socios
3. Buscar socio por nombre
4. Mostrar socios activos
5. Mostrar socios con cuota vencida
6. Salir
Opción: 1
Nombre: Carlos
Edad: 34
Cuota: 1500
Vencimiento: mayo
Socio agregado correctamente.
```

## Al terminar

Commit final con mensaje `"feat: proyecto puente club completo"` y push al repo grupal. Prepara una breve explicación oral (2 minutos) sobre qué hace tu programa, cómo elegiste las estructuras de datos y qué función te costó más.