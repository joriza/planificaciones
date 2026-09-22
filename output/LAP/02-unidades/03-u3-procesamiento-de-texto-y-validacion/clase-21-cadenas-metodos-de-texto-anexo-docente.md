# Anexo docente — Encuentro 21: Cadenas: métodos de texto

> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.

## 1. Solución del ejercicio independiente

**Consigna:** `telefono_cleaner.py` — recibe nombre, dirección y teléfono separados por `;`, limpia el teléfono y muestra los datos.

**Código solución:**

```python
def clean_phone(phone_text):
    # Saca espacios y guiones: replace devuelve nueva cadena
    clean = phone_text.replace(" ", "").replace("-", "")
    return clean


if __name__ == "__main__":
    raw = input("Ingresá nombre; dirección; teléfono: ")
    # Separar por ; y limpiar bordes de cada campo
    fields = [f.strip() for f in raw.split(";")]
    if len(fields) == 3:
        name, address, phone = fields
        clean_phone_text = clean_phone(phone)
        print(f"Nombre: {name}")
        print(f"Dirección: {address}")
        print(f"Teléfono: {clean_phone_text}")
    else:
        print("Formato incorrecto. Usá: nombre; dirección; teléfono")
```

**Salida verificada:**
```
Ingresá nombre; dirección; teléfono: María García; Av. Siempre Viva 123; 11 2345 6789
Nombre: María García
Dirección: Av. Siempre Viva 123
Teléfono: 1123456789
```

## 2. Solución de la actividad de extensión

**Extensión 1 — Formato con separador de miles:**
```python
monto = 1234567.50
print(f"${monto:,.2f}")  # $1,234,567.50
```

**Extensión 2 — Validación mínima:**
```python
if len(clean_phone_text) < 7:
    print(f"⚠️ El teléfono '{clean_phone_text}' parece incompleto (solo {len(clean_phone_text)} dígitos).")
```

**Extensión 3 — Procesamiento batch (tres líneas):**
```python
if __name__ == "__main__":
    print("Ingresá 3 líneas con formato: nombre; dirección; teléfono")
    all_entries = []
    for i in range(3):
        raw = input(f"Línea {i+1}: ")
        fields = [f.strip() for f in raw.split(";")]
        if len(fields) == 3:
            name, address, phone = fields
            clean = phone.replace(" ", "").replace("-", "")
            all_entries.append((name, address, clean))
    print("\n=== Datos limpios ===")
    for name, address, phone in all_entries:
        print(f"{name} | {address} | {phone}")
```

## 3. Respuesta esperada del ejercicio

| Entrada | Salida esperada |
| --- | --- |
| `María García; Av. Siempre Viva 123; 11 2345 6789` | Nombre: María García / Dirección: Av. Siempre Viva 123 / Teléfono: 1123456789 |
| `Juan Pérez; Calle Falsa 456; 15-6789-0123` | Nombre: Juan Pérez / Dirección: Calle Falsa 456 / Teléfono: 1567890123 |
| `Ana; Blvd. 123; 11-1111` (short) | Se muestra con 6 dígitos (extensión lo detecta) |

## 4. Criterios de corrección (lista de verificación)

- [ ] Usa `split(";")` para separar los campos
- [ ] Aplica `strip()` a cada campo para limpiar bordes
- [ ] Usa `replace(" ", "")` y `replace("-", "")` sobre el teléfono
- [ ] Muestra los datos con f-strings
- [ ] El programa es un solo archivo `.py`
- [ ] Funciones definidas arriba, ejecución en `if __name__ == "__main__":`

## 5. Errores esperados y cómo intervenir

| Error observable | Causa probable | Intervención docente |
| --- | --- | --- |
| El programa no separa los campos | Usa `split()` sin argumento en vez de `split(";")` | Preguntar: "¿Qué carácter separa los tres datos?" y señalar el `;` en el ejemplo |
| Los campos tienen espacios al principio/final | Olvida `strip()` | Mostrar el resultado crudo: "`\" Ana\"` no es lo mismo que `\"Ana\"`" |
| El teléfono conserva espacios | No usa `replace` | Preguntar: "¿Qué método de cadena reemplaza una parte por otra?" |
| Error al hacer `phone.replace(" ", "").replace("-", "")` en la misma línea | No conoce el encadenamiento | Mostrar que `replace` devuelve un nuevo `str` y se puede llamar otro método sobre él |
| Usa `+` para concatenar mensajes en vez de f-string | Hábito de clases anteriores | Recordar la regla del curso: "mostrar mensajes compuestos siempre con f-strings" |

## 6. Registro de la clase

- **Por grupo:** anotar qué pareja termina el ejercicio independiente antes de los 25 min y cuál necesita más tiempo. Registrar si algún grupo no logra completar la consigna base (no solo la extensión).
- **Para la evaluación de proceso:** el próximo encuentro arranca con validación; registrar si la mayoría entiende el flujo `split → strip → procesar`. Sirve para decidir si repasar métodos de texto al inicio de la clase 22.
- **Bitácora:** fecha, grupo que avanzó más, grupo que más dificultades tuvo, concepto que generó más preguntas.