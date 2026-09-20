# generar-administrativos.ps1 — Render determinista de los 3 administrativos CSV de una materia
# a partir de curso-data.json + plantillas (tramos invariantes, filas de libro y esqueletos de unidad).
#
# Uso (desde la raíz del repositorio):
#   powershell -File tools\generar-administrativos.ps1 -Materia materias\LSO -Salida <carpeta> [-Variante 1]
#
# Parametros:
#   -Materia   (obligatorio) carpeta de la materia (contiene curso-data.json).
#   -Salida    carpeta destino (por defecto, la carpeta actual; se crea si no existe). Escribe:
#                planificacion-anual.csv
#                libro-de-aula-1-linea-por-encuentro.csv
#                libro-de-aula-2-lineas-por-encuentro.csv
#   -Variante  variante de fraseos 1-3 para los tramos invariantes (por defecto, la varianteFraseos del JSON).
#
# Determinismo: sin azar ni dependencia del entorno; mismas entradas -> mismos bytes.
# Formato: UTF-8 con BOM, todos los campos entre comillas dobles, separador ';' y lineas LF
# (idéntico byte a byte a los CSV vigentes del corpus).
# Errores duros (exit 1): JSON invalido, tramo/fila/esqueleto faltante, slot {{...}} desconocido, variante invalida.

param(
  [string]$Materia,
  [string]$Salida,
  [int]$Variante
)

$ErrorActionPreference = 'Stop'

# Valores por defecto explicitos (equivalentes a los defaults inline del param).
if ($null -eq $Materia -or $Materia -eq '') { $Materia = '' }
if ($null -eq $Salida -or $Salida -eq '') { $Salida = '.' }
if ($null -eq $Variante) { $Variante = 0 }

if ($Materia -eq '') {
  Write-Output 'ERROR: falta -Materia <ruta a la carpeta de la materia (contiene curso-data.json)>'
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

# La raiz del repositorio es la carpeta padre de tools\ (donde vive este script).
$raiz = Split-Path -Parent $PSScriptRoot
$rutaTramos = Join-Path $raiz 'plantillas\tramos-invariantes.json'
$rutaFilasLibro = Join-Path $raiz 'plantillas\libro-filas-invariantes.json'
$rutaEsqueletos = Join-Path $raiz 'plantillas\esqueletos-unidad.json'
foreach ($ruta in @($rutaJson, $rutaTramos, $rutaFilasLibro, $rutaEsqueletos)) {
  if (-not (Test-Path -LiteralPath $ruta)) {
    Write-Output "ERROR: no se encontro el archivo requerido: $ruta"
    exit 1
  }
}

try {
  function Read-Json([string]$ruta) {
    [System.IO.File]::ReadAllText((Resolve-Path -LiteralPath $ruta).Path) | ConvertFrom-Json
  }
  $data = Read-Json $rutaJson
  $tramos = Read-Json $rutaTramos
  $filasLibro = @($(Read-Json $rutaFilasLibro))
  $esqueletos = Read-Json $rutaEsqueletos
} catch {
  Write-Output "ERROR: JSON invalido: $($_.Exception.Message)"
  exit 1
}

# --- Variante de fraseos ---
$nVariante = $Variante
if ($nVariante -le 0) { $nVariante = [int]$data.varianteFraseos }
if ($nVariante -lt 1 -or $nVariante -gt 3) {
  Write-Output "ERROR: -Variante $nVariante invalida (se esperaba 1-3)"
  exit 1
}
$claveVariante = "v$nVariante"

# --- Sustitucion de slots ---
# Mapa global: {{celular}} y {{tp.uX}} (la misma convencion de plantillas\tramos-invariantes.json).
$slotsGlobales = @{}
$propCelular = $data.slots.PSObject.Properties['celular']
if ($null -eq $propCelular -or $null -eq $propCelular.Value) {
  Write-Output 'ERROR: slots.celular ausente en el curso-data'
  exit 1
}
$slotsGlobales['celular'] = [string]$propCelular.Value
foreach ($u in @('u1', 'u2', 'u3', 'u4')) {
  $prop = $data.slots.tps.PSObject.Properties[$u]
  if ($null -eq $prop -or $null -eq $prop.Value) {
    Write-Output "ERROR: slots.tps.$u ausente en el curso-data"
    exit 1
  }
  $slotsGlobales["tp.$u"] = [string]$prop.Value
}

# Reemplaza cada aparicion del patron por el valor del mapa; slot desconocido = error duro.
function Expand-Plantilla([string]$texto, [hashtable]$valores, [string]$patron, [string]$contexto) {
  if ($null -eq $texto) { throw "CAMPO AUSENTE en $contexto" }
  $sb = New-Object System.Text.StringBuilder
  $pos = 0
  foreach ($m in [regex]::Matches($texto, $patron)) {
    [void]$sb.Append($texto.Substring($pos, $m.Index - $pos))
    $clave = $m.Groups[1].Value.Trim()
    if (-not $valores.ContainsKey($clave)) { throw "SLOT DESCONOCIDO '{{${clave}}}' en $contexto" }
    [void]$sb.Append([string]$valores[$clave])
    $pos = $m.Index + $m.Length
  }
  [void]$sb.Append($texto.Substring($pos))
  return $sb.ToString()
}

$patronSlots = '\{\{([^{}]+)\}\}'      # slots de datos: {{celular}}, {{tp.uX}}
$patronMolde = '\{([A-Za-z]+)\}'       # tokens del molde de esqueletos: {items}, {cierre}, ...

# --- Utilidades CSV ---
function Get-LineaCsv([string[]]$campos) {
  ($campos | ForEach-Object { '"' + $_.Replace('"', '""') + '"' }) -join ';'
}
function Write-Csv([string]$ruta, [string[]]$lineas) {
  # UTF-8 con BOM, LF de terminador en cada linea (incluida la ultima), como los CSV vigentes.
  $contenido = ($lineas -join "`n") + "`n"
  [System.IO.File]::WriteAllText($ruta, $contenido, (New-Object System.Text.UTF8Encoding($true)))
}

# --- Carpeta de salida ---
if (-not (Test-Path -LiteralPath $Salida)) { New-Item -ItemType Directory -Path $Salida -Force | Out-Null }
$salidaAbsoluta = (Resolve-Path -LiteralPath $Salida).Path

# --- Encuentros por n (los 20 de unidad vienen del curso-data) ---
$encuentroPorN = @{}
foreach ($e in @($data.encuentros)) {
  $n = [int]$e.n
  if ($encuentroPorN.ContainsKey($n)) { throw "ENCUENTRO DUPLICADO n=$n en el curso-data" }
  $encuentroPorN[$n] = $e
}
$ejeNombre = {
  param([int]$nEje)
  $prop = $data.slots.ejes.PSObject.Properties[[string]$nEje]
  if ($null -eq $prop) { throw "SLOT DESCONOCIDO: eje $nEje ausente en slots.ejes" }
  [string]$prop.Value[0]
}

# --- 1) planificacion-anual.csv ---
$ordenTramos = @(
  'encuadre-1', 'previos-2-3',
  'u1', 'evaluacion-u1-9',
  'u2', 'evaluacion-u2-15',
  'cierre-c1-16', 'intensificacion-17-18', 'integradora-19-20',
  'u3', 'evaluacion-u3-26',
  'u4', 'evaluacion-u4-32',
  'cierre-c2-33', 'intensificacion-34-35', 'cierre-integral-36'
)
$camposAnual = @('unidadTematica', 'tiempo', 'contenidos', 'expectativas', 'actividades', 'tp', 'tecnicas', 'recursos', 'metodologia')
$lineasAnual = @(
  Get-LineaCsv @('Unidad temática', 'Tiempo', 'Contenidos', 'Expectativas de logro', 'Actividades', 'TP obligatorio', 'Técnicas/Capacidades', 'Recursos', 'Metodología de evaluación')
)

foreach ($clave in $ordenTramos) {
  if ($clave -match '^u[1-4]$') {
    # --- Tramo de unidad: se compone desde curso-data + esqueletos ---
    $contexto = "tramo $clave"
    $propEsq = $esqueletos.PSObject.Properties[$clave]
    if ($null -eq $propEsq) { throw "ESQUELETO AUSENTE: $clave en plantillas\esqueletos-unidad.json" }
    $esq = $propEsq.Value
    $propUni = $data.slots.unidades.PSObject.Properties[$clave]
    if ($null -eq $propUni) { throw "SLOT AUSENTE: slots.unidades.$clave en el curso-data" }
    $uni = $propUni.Value

    # Encuentros de la unidad (incluido el cierre), ordenados por n.
    $encuentrosUnidad = @($data.encuentros | Where-Object { [string]$_.unidad -eq $clave } | Sort-Object { [int]$_.n })
    if ($encuentrosUnidad.Count -eq 0) { throw "SIN ENCUENTROS: el curso-data no tiene encuentros para $clave" }

    # Contenidos: join de contenidos con "; " + ". " + transversales + ("; " + nota + "." | ".")
    $joinContenidos = ($encuentrosUnidad | ForEach-Object { [string]$_.contenido }) -join '; '
    $propNota = $uni.PSObject.Properties['nota']
    $finalContenidos = '.'
    if ($null -ne $propNota -and $null -ne $propNota.Value -and ([string]$propNota.Value).Trim() -ne '') {
      $finalContenidos = '; ' + [string]$propNota.Value + '.'
    }
    $contenidos = $joinContenidos + '. ' + [string]$uni.transversales + $finalContenidos

    # Actividades: molde del esqueleto (apertura + secuencia fija + items por encuentro + cierre + rotacion + extension + celular).
    $clases = @($esq.clases | Sort-Object)
    $items = ($clases | ForEach-Object {
      Expand-Plantilla ([string]$esq.formatoItem) @{ n = $_; actividadesAnual = [string]$encuentroPorN[[int]$_].actividadesAnual } $patronMolde "$contexto (item encuentro $_)"
    }) -join [string]$esq.separadorItems
    $nCierre = [int]$esq.cierre
    $cierreTexto = Expand-Plantilla ([string]$esq.formatoCierre) @{ cierre = $nCierre; actividadesAnual = [string]$encuentroPorN[$nCierre].actividadesAnual } $patronMolde "$contexto (cierre)"
    $actividades = Expand-Plantilla ([string]$esq.plantilla) @{
      actividadesApertura = [string]$uni.actividadesApertura
      secuenciaFija       = [string]$esq.secuenciaFija
      items               = $items
      cierre              = $cierreTexto
      rotacion            = [string]$esq.rotacion
      extension           = [string]$uni.extension
      celular             = [string]$data.slots.celular
    } $patronMolde "$contexto (plantilla)"

    # Columnas casi invariantes por unidad: viven en el esqueleto y admiten slots {{...}}.
    $tecnicas = Expand-Plantilla ([string]$esq.tecnicas) $slotsGlobales $patronSlots "$contexto (tecnicas)"
    $recursos = Expand-Plantilla ([string]$esq.recursos) $slotsGlobales $patronSlots "$contexto (recursos)"
    $metodologia = Expand-Plantilla ([string]$esq.metodologia) $slotsGlobales $patronSlots "$contexto (metodologia)"

    $lineasAnual += Get-LineaCsv @(
      [string]$uni.denominacion,
      '5',
      $contenidos,
      [string]$uni.expectativas,
      $actividades,
      [string]$slotsGlobales["tp.$clave"],
      $tecnicas,
      $recursos,
      $metodologia
    )
  } else {
    # --- Tramo invariante: fila de plantillas\tramos-invariantes.json en la variante elegida ---
    $contexto = "tramo $clave"
    $propTramo = $tramos.PSObject.Properties[$clave]
    if ($null -eq $propTramo) { throw "TRAMO AUSENTE: $clave en plantillas\tramos-invariantes.json" }
    $propFila = $propTramo.Value.PSObject.Properties[$claveVariante]
    if ($null -eq $propFila) { throw "VARIANTE AUSENTE: $claveVariante en el tramo $clave" }
    $fila = @()
    foreach ($campo in $camposAnual) {
      $propCampo = $propFila.Value.PSObject.Properties[$campo]
      if ($null -eq $propCampo -or $null -eq $propCampo.Value) { throw "CAMPO AUSENTE: $campo en $contexto ($claveVariante)" }
      $textoCampo = [string]$propCampo.Value
      $fila += (Expand-Plantilla $textoCampo $slotsGlobales $patronSlots "$contexto.$campo")
    }
    $lineasAnual += Get-LineaCsv $fila
  }
}

# --- 2) y 3) Libros de aula: 20 filas de unidad + 16 invariantes, ordenadas 1..36 ---
$filaPorN = @{}
foreach ($f in $filasLibro) { $filaPorN[[int]$f.n] = $f }

$camposLibro = @('Nº Clase', 'Eje Temático', 'Nº Eje', 'Carácter/Objetivo', 'Tema del Día', 'Actividades', 'Fecha', 'Material')
$encLibro = [string[]]$camposLibro
$lineasLibro1 = @(Get-LineaCsv $encLibro)
$lineasLibro2 = @(Get-LineaCsv $encLibro)

for ($n = 1; $n -le 36; $n++) {
  $esInvariante = $filaPorN.ContainsKey($n)
  $esUnidad = $encuentroPorN.ContainsKey($n)
  if (-not $esInvariante -and -not $esUnidad) { throw "ENCUENTRO FALTANTE: n=$n no esta ni en el curso-data ni en libro-filas-invariantes.json" }

  if ($esInvariante) {
    $f = $filaPorN[$n]
    $tema = [string]$f.tema
    $a1 = [string]$f.act1linea
    $a2 = @($f.act2lineas)
    if ($a2.Count -ne 2) { throw "FILA LIBRO INVALIDA: n=$n sin exactamente 2 lineas en act2lineas" }
    $eje = [string]$f.eje
    $nombreEje = [string]$f.ejeNombre
    $caracter = [string]$f.caracter
  } else {
    $e = $encuentroPorN[$n]
    $tema = [string]$e.tema
    $a1 = [string]$e.actividadesLibro1
    $a2 = @($e.actividadesLibro2)
    if ($a2.Count -ne 2) { throw "ENCUENTRO INVALIDO: n=$n sin exactamente 2 items en actividadesLibro2" }
    $eje = [string]$e.eje
    $nombreEje = & $ejeNombre ([int]$e.eje)
    $caracter = [string]$e.caracter
  }

  # Libro de 1 linea por encuentro
  $lineasLibro1 += Get-LineaCsv @([string]$n, $nombreEje, $eje, $caracter, $tema, $a1, '', '')

  # Libro de 2 lineas por encuentro: la segunda repite eje y caracter con Tema del Dia vacio
  $lineasLibro2 += Get-LineaCsv @([string]$n, $nombreEje, $eje, $caracter, $tema, [string]$a2[0], '', '')
  $lineasLibro2 += Get-LineaCsv @([string]$n, $nombreEje, $eje, $caracter, '', [string]$a2[1], '', '')
}

# --- Escritura ---
$rutas = @{
  anual   = Join-Path $salidaAbsoluta 'planificacion-anual.csv'
  libro1  = Join-Path $salidaAbsoluta 'libro-de-aula-1-linea-por-encuentro.csv'
  libro2  = Join-Path $salidaAbsoluta 'libro-de-aula-2-lineas-por-encuentro.csv'
}
Write-Csv $rutas.anual $lineasAnual
Write-Csv $rutas.libro1 $lineasLibro1
Write-Csv $rutas.libro2 $lineasLibro2

Write-Output "OK: 3 administrativos generados en $salidaAbsoluta (variante $claveVariante)."
Write-Output "  planificacion-anual.csv: $($lineasAnual.Count - 1) filas"
Write-Output "  libro-de-aula-1-linea-por-encuentro.csv: $($lineasLibro1.Count - 1) filas"
Write-Output "  libro-de-aula-2-lineas-por-encuentro.csv: $($lineasLibro2.Count - 1) filas"
exit 0
