# Evaluación del momento especial 2 y 3 — Saberes previos — Versión B

> Dominio de esta versión: playlist de una aplicación de música (canciones). Ejercicio individual en papel: 25 minutos, sin computadora, sin celular, sin material consultable salvo esta hoja. Las condiciones completas y la regla de equivalencia están en `evaluacion-especiales-02-03.md`.

## Parte 1 — URL y respuesta

Un navegador abre esta dirección:

```text
https://api.musica.ejemplo.org/playlist/12
```

| Ítem | Consigna |
| --- | --- |
| a | Escribí las tres partes de la URL: protocolo, dominio y ruta. |
| b | En este ciclo, ¿quién hace la petición y quién la responde? Nombrá a los dos con su rol (cliente y servidor). |
| c | La respuesta a esa dirección es este texto: `{"titulo": "Cancion animal", "anio": 1990}`. ¿Este texto es la petición o la respuesta? ¿Quién lo produjo? |

## Parte 2 — Lectura de un JSON corto

La aplicación devuelve estos datos de una playlist:

```json
{
  "titulo": "Clasicos del rock",
  "creador": "Valentina",
  "anio": 2023,
  "canciones": ["Luces", "Viento", "Sur"],
  "publica": true
}
```

| Ítem | Consigna |
| --- | --- |
| a | ¿Cuántos pares clave-valor tiene el documento? |
| b | Completá la tabla con el tipo de cada valor: texto, número, verdadero/falso o arreglo. |

| Clave | Tipo de valor |
| --- | --- |
| `titulo` | |
| `creador` | |
| `anio` | |
| `canciones` | |
| `publica` | |

| Ítem | Consigna |
| --- | --- |
| c | ¿Cuántos elementos tiene el arreglo `canciones` y de qué tipo son? |

## Parte 3 — Archivos y terminal en papel

En una máquina hay esta estructura de carpetas:

```text
Documentos
└── curso
    ├── material
    └── trabajos
```

| Ítem | Consigna |
| --- | --- |
| a | Estando parado en `Documentos`, escribí el comando para entrar a la carpeta `curso`. |
| b | Escribí el comando (o los comandos) para crear, dentro de `trabajos`, una carpeta nueva que se llame `tp0`. |
| c | Escribí el comando para listar el contenido de la carpeta en la que estás parado. |
| d | Escribí, en orden, los pasos para: entrar a la carpeta `tp0` y ejecutar desde ahí el programa `saludo`, que está guardado dentro de esa carpeta. Numerá los pasos. |

Al terminar, entregá la hoja al docente.
