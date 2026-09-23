# scaffold-clase-mejorado.ps1 — Esqueleto mejorado con frases pulidas y contexto por destinatario
# Versión actualizada del scaffold-clase.ps1 con mejoras de naturalidad (P3-B) y soporte para LAP/LSO
# Genera estructura BOPPPS + GRR con frases estructurales extraídas del corpus y mejoras de naturalidad.
#
# Uso (desde la raíz del repositorio):
#   powershell -File tools\scaffold-clase-mejorado.ps1 -Materia input\materias\LSO -Encuentro 5 -Salida <carpeta> [-Slug mi-slug] [-Destinatario LSO] [-Force]
#
# Mejoras sobre el original:
# - Frases pulidas de P3-B para mayor naturalidad docente
# - Contexto específico por destinatario (LAP/LSO)
# - Placeholder más ricos con ejemplos concretos
# - Soporte integrado para formato integrador (120min)
# - Errores comunes contextualizados

param(
  [string]$Materia,
  [int]$Encuentro = 0,
  [string]$Salida = '.',
  [string]$Slug = '',
  [string]$Destinatario = 'LSO', # LSO (C#) o LAP (Python)
  [switch]$Force
)

$ErrorActionPreference = 'Stop'

# Validar destinatario
if ($Destinatario -notin @('LSO', 'LAP')) {
  Write-Output 'ERROR: Destinatario debe ser LSO (C#) o LAP (Python)'
  exit 1
}

# Validar parámetros básicos (misma lógica que el original)
if ($Materia -eq '') {
  Write-Output 'ERROR: falta -Materia <ruta a la carpeta de la materia (contiene curso-data.json)'
  exit 1
}
if ($Encuentro -le 0) {
  Write-Output 'ERROR: falta -Encuentro <n> (ordinal del encuentro de unidad)'
  exit 1
}
if (-not (Test-Path -LiteralPath $Materia -PathType Container)) {
  Write-Output "ERROR: no se encontro la carpeta de materia: $Materia"
  exit 1
}
$rutaJson = Join-Path $Materia 'curso-data.json'
if (-not (Test-Path -LiteralPath $rutaJson)) {
  Write-Output "ERROR: falta $Materia/curso-data.json"
  exit 1
}

try {
  $data = [System.IO.File]::ReadAllText((Resolve-Path -LiteralPath $rutaJson).Path) | ConvertFrom-Json
} catch {
  Write-Output "ERROR: JSON invalido: $($_.Exception.Message)"
  exit 1
}

# --- Datos del encuentro y de la unidad (misma lógica que el original) ---
$enc = @($data.encuentros | Where-Object { $_.n -eq $Encuentro })
if ($enc.Count -eq 0) {
  Write-Output "ERROR: el encuentro $Encuentro no existe en el curso-data"
  exit 1
}
$enc = $enc[0]

$uniProp = $data.slots.unidades.PSObject.Properties[$enc.unidad]
if ($null -eq $uniProp) {
  Write-Output "ERROR: la unidad '$($enc.unidad)' no existe en slots.unidades"
  exit 1
}
$uni = $uniProp.Value

$ejeProp = $data.slots.ejes.PSObject.Properties["$($enc.eje)"]
if ($null -eq $ejeProp) {
  Write-Output "ERROR: el eje '$($enc.eje)' no existe en slots.ejes"
  exit 1
}
$ejeDatos = @($ejeProp.Value)
$ejeNombre = "$($ejeDatos[0])"

# Denominación de unidad (misma lógica que el original)
$unidadCorta = $uni.denominacion
if ($unidadCorta -match '^Unidad didáctica\s*(\d+)\s*:\s*(.+)$') {
  $unidadCorta = "$($Matches[1]) — $($Matches[2])"
}
$numUnidad = $enc.unidad.Substring(1)

# --- Estructura y formato mejorado ---
$estructura = "$($enc.estructura)"
if ($estructura -ne 'clase' -and $estructura -ne 'cierre') {
  Write-Output "ERROR: estructura no reconocida para el encuentro ${Encuentro}: '$estructura' (valores: clase | cierre)"
  exit 1
}

# Slug (misma lógica que el original)
function Convert-Slug([string]$texto) {
  $t = $texto.ToLowerInvariant().Normalize([System.Text.NormalizationForm]::FormD)
  $t = [regex]::Replace($t, '\p{M}', '')
  $t = [regex]::Replace($t, '[^a-z0-9]+', '-').Trim('-')
  return $t
}
$slug = $Slug
if ($slug -eq '') { $slug = "$($enc.tema)" }
$slug = Convert-Slug $slug
if ($slug -eq '') {
  Write-Output 'ERROR: el slug quedó vacío (revise -Slug o el tema del encuentro en el JSON)'
  exit 1
}

# --- Tabla de tiempos mejorada ---
$tablaTiempos = @()
$secciones = @()
if ($estructura -eq 'clase') {
  if ($Destinatario -eq 'LSO' -and $Encuentro -in @(27,28,29)) {
    # Formato integrador para U4 LSO (120min)
    $tablaTiempos = @(
      '| Apertura y puente | 15 min |',
      '| Teoría mínima | 30 min |',
      '| Práctica guiada | 40 min |',
      '| Ejercicio independiente | 20 min |',
      '| Cierre | 15 min |',
      '| **Total** | **120 min** |'
    )
    $secciones = @(
      '## 3. Teoría mínima (30 min)',
      '## 4. Práctica guiada (40 min)', 
      '## 5. Ejercicio independiente (20 min)'
    )
  } else {
    # Formato estándar (240min)
    $tablaTiempos = @(
      '| Apertura y puente | 20 min |',
      '| Teoría mínima | 40 min |',
      '| Práctica guiada | 70 min |',
      '| Ejercicio independiente | 50 min |',
      '| Extensión y consolidación | 45 min |',
      '| Cierre | 15 min |',
      '| **Total** | **240 min** |'
    )
    $secciones = @(
      '## 3. Teoría mínima (40 min)',
      '## 4. Práctica guiada (70 min)',
      '## 5. Ejercicio independiente (50 min)',
      '## 6. Extensión y consolidación (45 min)'
    )
  }
} else {
  # Cierre de unidad (misma lógica que el original)
  $tablaTiempos = @(
    '| Apertura | 15 min |',
    '| Consolidación | 75 min |',
    '| Trabajo del TP | 90 min |',
    '| Ciclo de entrega | 45 min |',
    '| Cierre | 15 min |',
    '| **Total** | **240 min** |'
  )
  $secciones = @(
    '## 3. Apertura y puente (15 min)',
    '## 4. Consolidación (75 min)',
    '## 5. Trabajo del TP (90 min)',
    '## 6. Ciclo de entrega (45 min)'
  )
}

# --- Cuerpos de cada sección MEJORADOS con frases pulidas ---
$l = [System.Collections.Generic.List[string]]::new()

# Frases estructurales por destinatario
$destinatarioConfig = if ($Destinatario -eq 'LAP') {
  @{
    lenguaje = "Python"
    framework = "Minimal API (Python)"
    dominios = "tickets, bibliotecas, cursos, canciones"
    enfoque = "analítica de datos"
    ejemplos = "gestión de soporte, procesamiento de información"
  }
} else {
  @{
    lenguaje = "C#"
    framework = ".NET Minimal API"
    dominios = "sistemas médicos, bibliotecas, aplicaciones empresariales"
    enfoque = "desarrollo profesional"
    ejemplos = "APIs web, aplicaciones empresariales, gestión de datos"
  }
}

# --- Documento alumno con frases mejoradas ---
$l.Add("# Encuentro $Encuentro — $($enc.tema)")
$l.Add('')
$subtitulo = "> $unidadCorta"
if ($estructura -eq 'cierre') { $subtitulo = "$subtitulo · Encuentro de cierre de unidad" }
$l.Add($subtitulo)
$l.Add('')
$l.Add('## 1. Metadatos de bloque')
$l.Add('')
$l.Add('| Campo | Detalle |')
$l.Add('| --- | --- |')
$l.Add("| Encuentro | $Encuentro de 36 |")
$l.Add("| Unidad | $numUnidad — $($unidadCorta -replace '^\d+\s—\s', '') |")
$l.Add("| Eje temático | $($enc.eje) — $ejeNombre |")
$l.Add("| Carácter/Objetivo | $($enc.caracter) |")
$l.Add("| Estructura | $estructura |")
$$duracionTeorica = if ($estructura -eq 'clase' -and $Destinatario -eq 'LSO' -and $Encuentro -in @(27,28,29)) { '120 minutos (2 horas reloj)' } else { '240 minutos (4 horas reloj)' }
l.Add('| Duración teórica | ' + $duracionTeorica + ' |')
if ($null -ne $enc.tp -and "$($enc.tp)" -ne '') {
  $l.Add("| TP obligatorio | $($enc.tp) |")
}
$l.Add("| Concepto nuevo | $($enc.tema) |")
$l.Add('| Requisitos previos | <!-- prose: requisitos previos del encuentro --> |')
$l.Add("| Uso de celular | $($data.slots.celular) |")
$l.Add('| Organización del trabajo | <!-- prose: organización del trabajo (grupos, rotación de integrantes) --> |')
$l.Add('')

$l.Add('### Reparto de tiempos teóricos')
$l.Add('')
$l.Add('| Momento | Tiempo teórico |')
$l.Add('| --- | --- |')
foreach ($fila in $tablaTiempos) { $l.Add($fila) }
$l.Add('')

$l.Add('## 2. Objetivos de aprendizaje')
$l.Add('')
$l.Add('<!-- prose: 3-5 objetivos accionables, uno por línea numerada -->')
$l.Add('')
$l.Add('<!-- EJEMPLOS DE OBJETIVOS (según destinatario): -->')
$l.Add('')
if ($Destinatario -eq 'LSO') {
  $l.Add('1. Usar condicionales (`if`, `else if`, `else`) para tomar decisiones en un programa C#.')
  $l.Add('2. Implementar bucles (`for`, `foreach`, `while`) para repetir acciones sobre colecciones.')
  $l.Add('3. Definir métodos con parámetros y tipo de retorno para organizar el código en bloques reutilizables.')
  $l.Add('4. Distinguir entre un método que devuelve un valor (`return`) y uno que no devuelve nada (`void`).')
} else {
  $l.Add('1. Usar estructuras de control para procesar información en un programa Python.')
  $l.Add('2. Implementar bucles y condicionales para analizar datos de soporte.')
  $l.Add('3. Definir funciones para organizar el código en bloques reutilizables.')
  $l.Add('4. Distinguir entre funciones que devuelven valores y las que modifican estado.')
}
$l.Add('')

# Secciones 3 a 6 según estructura
$l.Add($secciones[0])
$l.Add('')
$l.Add('### Charla rápida: <!-- prose: analogía breve que ancle el concepto -->')
$l.Add('')
$l.Add('<!-- prose: analogía de apertura (1 párrafo) con ejemplos de ' + $destinatarioConfig.ejemplos + ' -->')
$l.Add('')
$l.Add('### Lo mínimo indispensable')
$l.Add('')
$l.Add('<!-- prose: teoría mínima, solo lo indispensable. Usar ejemplos de ' + $destinatarioConfig.dominios + ' -->')
$l.Add('')

$l.Add($secciones[1])
$l.Add('')
$l.Add('<!-- prose: pasos numerados, código completo listo para copiar, salida esperada verificada -->')
$l.Add('')

$l.Add($secciones[2])
$l.Add('')
$l.Add('<!-- prose: consigna + pista + solución esperada. Usar contexto de ' + $destinatarioConfig.enfoque + ' -->')
$l.Add('')

if ($secciones.Count -gt 3) {
  $l.Add($secciones[3])
  $l.Add('')
  $l.Add('<!-- prose: actividades de extensión y consolidación para quienes terminan la consigna base -->')
  $l.Add('')
}

# Cierre con headings canónicos y frases mejoradas
$numeroCierre = if ($secciones.Count -gt 3) { '7. Cierre (15 min)' } else { '6. Cierre (15 min)' }
l.Add('## ' + $numeroCierre)
$l.Add('')
$l.Add('### Qué te llevás')
$l.Add('')
$l.Add('<!-- prose: takeaways del encuentro con lenguaje natural -->')
$l.Add('')
$l.Add('### Lo que viene')
$l.Add('')
$l.Add('<!-- prose: preview del próximo encuentro con anticipación -->')
$l.Add('')
$l.Add('## 8. Errores comunes y trampas')
$l.Add('')
$l.Add('<!-- prose: 4-6 errores contextualizados para ' + $destinatarioConfig.lenguaje + ', cada uno con su causa y su fix -->')
$l.Add('')

# --- Anexo docente mejorado ---
$a = [System.Collections.Generic.List[string]]::new()
$a.Add("# Anexo docente — Encuentro $Encuentro`: $($enc.tema)")
$a.Add('')
$a.Add('> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.')
$a.Add('')
$a.Add('## 1. Solución del ejercicio independiente')
$a.Add('')
$a.Add('<!-- prose: solución completa (código y explicación) para ' + $destinatarioConfig.lenguaje + ' -->')
$a.Add('')
$a.Add('## 2. Solución de la actividad de extensión')
$a.Add('')
$a.Add('<!-- prose: soluciones de cada actividad de extensión con contexto de ' + $destinatarioConfig.enfoque + ' -->')
$a.Add('')
$a.Add('## 3. Respuesta esperada del ejercicio')
$a.Add('')
$a.Add('<!-- prose: tabla de pedidos y respuestas esperadas, con salida verificada -->')
$a.Add('')
$a.Add('## 4. Criterios de corrección (lista de verificación)')
$a.Add('')
$a.Add('<!-- prose: lista de verificación con casillas para evaluación de proceso -->')
$a.Add('')
$a.Add('## 5. Errores esperados y cómo intervenir')
$a.Add('')
$a.Add('<!-- prose: tabla error observable / causa probable / intervención docente específica para ' + $destinatarioConfig.lenguaje + ' -->')
$a.Add('')
$a.Add('## 6. Registro de la clase')
$a.Add('')
$a.Add('<!-- prose: qué registrar por grupo y para la evaluación de proceso -->')
$a.Add('')

# --- Escritura (UTF-8 sin BOM, LF, como el corpus) ---
$utf8SinBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($rutaBase, ($l -join "`n"), $utf8SinBom)
[System.IO.File]::WriteAllText($rutaAnexo, ($a -join "`n"), $utf8SinBom)

Write-Output "OK: $rutaBase (destinatario: $Destinatario)"
Write-Output "OK: $rutaAnexo (destinatario: $Destinatario)"
Write-Output "NOTA: Este scaffold incluye frases mejoradas y contexto por destinatario"
exit 0