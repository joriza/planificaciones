# scaffold-clase.ps1 — Esqueleto canónico de una clase (encuentro de unidad) desde el curso-data
# Genera la estructura BOPPPS + GRR con los headings canónicos y la tabla de tiempos fija,
# sin prosa: solo estructura, metadatos del curso-data y placeholders <!-- prose: ... -->.
#
# Uso (desde la raíz del repositorio):
#   powershell -File tools\scaffold-clase.ps1 -Materia output\LSO -Encuentro 5 -Salida <carpeta> [-Slug mi-slug] [-Force]
#
# Parametros:
#   -Materia    (obligatorio) ruta a la carpeta de la materia (contiene curso-data.json).
#   -Encuentro  (obligatorio) ordinal del encuentro de unidad (debe existir en el JSON).
#   -Salida     carpeta destino (se crea si no existe).
#   -Slug       sufijo del nombre de archivo; por defecto se deriva del tema (minúsculas, sin tildes, con guiones).
#   -Force      permite sobrescribir archivos existentes.
#
# Escribe dos archivos: clase-NN-<slug>.md y clase-NN-<slug>-anexo-docente.md.
# Secuencia de tiempos fija (canon de estructura-de-la-clase.md y del corpus):
#   clase : apertura y puente 20 / teoría mínima 40 / práctica guiada 70 / ejercicio independiente 50 /
#           extensión y consolidación 45 / cierre 15  (total 240)
#   cierre: apertura 15 / consolidación 75 / trabajo del TP 90 / ciclo de entrega 45 / cierre 15  (total 240)
# Errores duros (exit 1): JSON inválido, encuentro inexistente, slug vacío, archivos existentes sin -Force.

param(
  [string]$Materia,
  [int]$Encuentro = 0,
  [string]$Salida = '.',
  [string]$Slug = '',
  [switch]$Force
)

$ErrorActionPreference = 'Stop'

if ($Materia -eq '') {
  Write-Output 'ERROR: falta -Materia <ruta a la carpeta de la materia (contiene curso-data.json)>'
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

# --- Datos del encuentro y de la unidad ---
$enc = @($data.encuentros | Where-Object { $_.n -eq $Encuentro })
if ($enc.Count -eq 0) {
  Write-Output "ERROR: el encuentro $Encuentro no existe en el curso-data (encuentros de unidad: 4-8, 10-14, 21-25, 27-31)"
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

# Denominacion de unidad al formato del corpus: "1 — Fundamentos de ..."
$unidadCorta = $uni.denominacion
if ($unidadCorta -match '^Unidad didáctica\s*(\d+)\s*:\s*(.+)$') {
  $unidadCorta = "$($Matches[1]) — $($Matches[2])"
}
$numUnidad = $enc.unidad.Substring(1)

# Estructura: 'clase' (secuencia fija) o 'cierre' (cierre de unidad con TP)
$estructura = "$($enc.estructura)"
if ($estructura -ne 'clase' -and $estructura -ne 'cierre') {
  Write-Output "ERROR: estructura no reconocida para el encuentro ${Encuentro}: '$estructura' (valores: clase | cierre)"
  exit 1
}

# --- Slug: minusculas, sin tildes, solo [a-z0-9-] ---
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

# --- Destinos y regla de no sobrescritura ---
if (-not (Test-Path -LiteralPath $Salida)) {
  New-Item -ItemType Directory -Path $Salida -Force | Out-Null
}
$nombreBase = ('clase-{0:d2}-{1}.md' -f $Encuentro, $slug)
$nombreAnexo = ('clase-{0:d2}-{1}-anexo-docente.md' -f $Encuentro, $slug)
$rutaBase = Join-Path $Salida $nombreBase
$rutaAnexo = Join-Path $Salida $nombreAnexo
foreach ($destino in @($rutaBase, $rutaAnexo)) {
  if (Test-Path -LiteralPath $destino) {
    if (-not $Force) {
      Write-Output "ERROR: ya existe $destino (use -Force para sobrescribir)"
      exit 1
    }
  }
}

# --- Tabla de tiempos fija por estructura ---
$tablaTiempos = @()
$secciones = @()
if ($estructura -eq 'clase') {
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
} else {
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

# --- Cuerpos de cada sección (placeholders, sin prosa) ---
$cuerpos = @{
  'teoria' = @(
    '### Charla rápida: <!-- prose: analogía breve que ancle el concepto -->',
    '',
    '<!-- prose: analogía de apertura (1 párrafo) -->',
    '',
    '### Lo mínimo indispensable',
    '',
    '<!-- prose: teoría mínima, solo lo indispensable -->'
  )
  'practica' = @('<!-- prose: pasos numerados, código completo listo para copiar, salida esperada verificada -->')
  'ejercicio' = @('<!-- prose: consigna + pista + solución esperada -->')
  'extension' = @('<!-- prose: actividades de extensión y consolidación para quienes terminan la consigna base -->')
}

$l = [System.Collections.Generic.List[string]]::new()

# --- Documento alumno ---
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
$l.Add('| Duración teórica | 240 minutos (4 horas reloj) |')
if ($null -ne $enc.tp -and "$($enc.tp)" -ne '') {
  $l.Add("| TP obligatorio | $($enc.tp) |")
}
$l.Add("| Concepto nuevo | $($enc.tema) |")
$l.Add('| Requisitos previos | <!-- prose: requisitos previos del encuentro --> |')
$l.Add("| Uso de celular | $($data.slots.celular) |")
$l.Add('| Organización del trabajo | <!-- prose: organización del trabajo (grupos, rotación de integrantes) --> |')
$l.Add('')
$tituloTabla = '### Reparto de tiempos teóricos'
if ($estructura -eq 'cierre') { $tituloTabla = '### Reparto de tiempos teóricos (plantilla de cierre de unidad)' }
$l.Add($tituloTabla)
$l.Add('')
$l.Add('| Momento | Tiempo teórico |')
$l.Add('| --- | --- |')
foreach ($fila in $tablaTiempos) { $l.Add($fila) }
$l.Add('')
$l.Add('## 2. Objetivos de aprendizaje')
$l.Add('')
$l.Add('<!-- prose: 3-5 objetivos accionables, uno por línea numerada -->')
$l.Add('')
# Secciones 3 a 6 según estructura
$l.Add($secciones[0])
$l.Add('')
foreach ($linea in $cuerpos['teoria']) { $l.Add($linea) }
$l.Add('')
$l.Add($secciones[1])
$l.Add('')
foreach ($linea in $cuerpos['practica']) { $l.Add($linea) }
$l.Add('')
$l.Add($secciones[2])
$l.Add('')
foreach ($linea in $cuerpos['ejercicio']) { $l.Add($linea) }
$l.Add('')
$l.Add($secciones[3])
$l.Add('')
foreach ($linea in $cuerpos['extension']) { $l.Add($linea) }
$l.Add('')
# Cierre con headings canónicos
$l.Add('## 7. Cierre (15 min)')
$l.Add('')
$l.Add('### Qué te llevás')
$l.Add('')
$l.Add('<!-- prose: takeaways del encuentro -->')
$l.Add('')
$l.Add('### Lo que viene')
$l.Add('')
$l.Add('<!-- prose: preview del próximo encuentro -->')
$l.Add('')
$l.Add('## 8. Errores comunes y trampas')
$l.Add('')
$l.Add('<!-- prose: 4-6 errores, cada uno con su causa y su fix -->')
$l.Add('')

# --- Anexo docente ---
$a = [System.Collections.Generic.List[string]]::new()
$a.Add("# Anexo docente — Encuentro $Encuentro`: $($enc.tema)")
$a.Add('')
$a.Add('> Documento docente formal. No se entrega a los alumnos: contiene la solución del ejercicio independiente, la solución de la extensión, la respuesta esperada, los criterios de corrección y los errores previstos con su intervención.')
$a.Add('')
$a.Add('## 1. Solución del ejercicio independiente')
$a.Add('')
$a.Add('<!-- prose: solución completa (código y explicación) -->')
$a.Add('')
$a.Add('## 2. Solución de la actividad de extensión')
$a.Add('')
$a.Add('<!-- prose: soluciones de cada actividad de extensión -->')
$a.Add('')
$a.Add('## 3. Respuesta esperada del ejercicio')
$a.Add('')
$a.Add('<!-- prose: tabla de pedidos y respuestas esperadas, con salida verificada -->')
$a.Add('')
$a.Add('## 4. Criterios de corrección (lista de verificación)')
$a.Add('')
$a.Add('<!-- prose: lista de verificación con casillas -->')
$a.Add('')
$a.Add('## 5. Errores esperados y cómo intervenir')
$a.Add('')
$a.Add('<!-- prose: tabla error observable / causa probable / intervención docente -->')
$a.Add('')
$a.Add('## 6. Registro de la clase')
$a.Add('')
$a.Add('<!-- prose: qué registrar por grupo y para la evaluación de proceso -->')
$a.Add('')

# --- Escritura (UTF-8 sin BOM, LF, como el corpus) ---
$utf8SinBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($rutaBase, ($l -join "`n"), $utf8SinBom)
[System.IO.File]::WriteAllText($rutaAnexo, ($a -join "`n"), $utf8SinBom)

Write-Output "OK: $rutaBase"
Write-Output "OK: $rutaAnexo"
exit 0
