# impacto.ps1 -- Analizador de impacto para el modo actualizacion (Estrategia D, Punto 5)
# Solo lectura: no muta nada. Dado un curso-data JSON y el canon, produce el plan de
# regeneracion en tres listas:
#   (a) DERIVADOS -- se re-renderizan SIEMPRE y todos (generadores idempotentes, costo cero):
#       los 3 administrativos CSV (tools/generar-administrativos.ps1) y el README (tools/generar-readme.ps1).
#   (b) PROSA AFECTADA -- archivos del corpus que el diff alcanza (los abre el LLM), cada uno
#       con su motivo: encuentro/tramo/slot/plantilla/canon que lo toca.
#   (c) INTOCADO -- el resto de la prosa del corpus: nadie lo abre.
#
# Sin caches de hashes: la lista (b) sale del diff git del JSON (+ version de canon).
#
# Uso (desde la raiz del repositorio):
#   powershell -File tools\impacto.ps1 -Materia output\LSO [-Curso output/LSO]
#   powershell -File tools\impacto.ps1 -Materia output\LSO -Desde HEAD~1 [-Json]
#   powershell -File tools\impacto.ps1 -Materia output\LSO -Canon materias\otro-insumo.md
#
# Parametros:
#   -Materia (obligatorio) ruta a la carpeta de la materia (contiene curso-data.json).
#   -Curso   carpeta del corpus (por defecto, el nombre de la carpeta de la materia).
#   -Desde   revision git de referencia (por defecto HEAD; el diff incluye cambios sin commitear).
#   -Canon   rutas adicionales tratadas como canon (cambio canonico -> toda la prosa afectada).
#   -Json    salida machine-parseable (en lugar del texto plano en espanol).
#
# Conjunto canonico diffeado siempre, ademas del JSON de la materia:
#   plantillas/ + 0-prompt-plantilla-planificacion.md + estructura-de-la-clase.md
#
# Heuristicas de mapeo (documentadas, auditable): el diff se toma con -U500 para que cada
# hunk traiga sus anclas de estructura como contexto ("slots", "n": NN del encuentro, id de
# tramo): el curso-data es acotado por diseno (20 encuentros + slots, ~400 lineas) y los
# tramos invariantes ~35 lineas por tramo, asi el contexto siempre cubre el archivo.
#   encuentro n -> clase-NN-*.md del curso (+ su anexo, mismo patron de nombre)
#   slots.unidades.uX o slots.tps.uX -> evaluacion-uX* + clases de la unidad + cierre del cuatrimestre
#   tramo de plantillas/tramos-invariantes.json -> su documento y/o evaluaciones
#   varianteFraseos -> todos los documentos de tramos invariantes
#   canon (prompt plantilla, estructura-de-la-clase, digest-codigo, -Canon) -> TODA la prosa
#   slots globales (celular/recursos/ejes) y campos de identificacion -> solo derivados (nota)
# Exit codes: 0 OK; 1 error de uso o de git.

param(
  [Parameter(Mandatory=$true)][string]$Materia,
  [string]$Curso = '',
  [string]$Desde = 'HEAD',
  [string[]]$Canon = @(),
  [switch]$Json
)

$ErrorActionPreference = 'Stop'
# El script vive en tools\; todas las rutas se anclan a la raiz del repositorio.
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

function Exit-Uso([string]$msg) {
  Write-Output "ERROR: $msg"
  exit 1
}

# --- Validacion de uso y de git ---
$materiaFull = if ([System.IO.Path]::IsPathRooted($Materia)) { $Materia } else { Join-Path $root $Materia }
if (-not (Test-Path -LiteralPath $materiaFull -PathType Container)) { Exit-Uso "no existe la carpeta de materia: $Materia" }
$materiaJson = Join-Path $materiaFull 'curso-data.json'
if (-not (Test-Path -LiteralPath $materiaJson)) { Exit-Uso "falta curso-data.json dentro de: $Materia" }
$materiaRel = ([System.IO.Path]::GetFullPath($materiaJson).Substring($root.Length + 1)) -replace '\\', '/'

& git -C $root rev-parse --verify "$Desde" > $null 2> $null
if ($LASTEXITCODE -ne 0) { Exit-Uso "revision git invalida: $Desde" }

if ($Curso -eq '') { $Curso = [System.IO.Path]::GetFileName($materiaFull) }
$cursoRoot = Join-Path $root $Curso
$cursoUnidades = Join-Path $cursoRoot '02-unidades'
$corpusPresente = Test-Path -LiteralPath $cursoRoot

# --- Deteccion de modo: curso-data sin version previa -> corrida completa ---
& git -C $root cat-file -e "$($Desde):$materiaRel" > $null 2> $null
$modo = if ($LASTEXITCODE -eq 0) { 'actualizacion' } else { 'corrida-completa' }

# --- Diffs (lectura unicamente) ---
# Los avisos de git por stderr (p. ej. LF/CRLF) no deben ser terminantes en PS 5.1.
$ErrorActionPreference = 'Continue'
$jsonDiff = @(& git -C $root diff -U500 $Desde -- $materiaRel 2> $null)
$canonPaths = @('plantillas/', '0-prompt-plantilla-planificacion.md', 'estructura-de-la-clase.md') + $Canon
$canonDiff = @(& git -C $root diff -U500 $Desde -- $canonPaths 2> $null)
$ErrorActionPreference = 'Stop'

# --- Estructuras de salida ---
$prosa = [ordered]@{}   # ruta relativa -> List[string] de motivos
function Add-Prosa([string]$ruta, [string]$motivo) {
  if (-not $script:prosa.Contains($ruta)) { $script:prosa[$ruta] = New-Object System.Collections.Generic.List[string] }
  if (-not $script:prosa[$ruta].Contains($motivo)) { $script:prosa[$ruta].Add($motivo) }
}
$notas = New-Object System.Collections.Generic.List[string]
function Add-Nota([string]$texto) { if (-not $script:notas.Contains($texto)) { $script:notas.Add($texto) } }

function Get-Rel([string]$abs) { return $abs.Substring($script:root.Length + 1) -replace '\\', '/' }

# Resuelve patrones relativos a la carpeta del curso y devuelve rutas relativas a la raiz.
function Add-ProsaPorGlob([string[]]$patrones, [string]$motivo) {
  if (-not $script:corpusPresente) { return }
  foreach ($p in $patrones) {
    $files = @(Get-ChildItem -Path (Join-Path $script:cursoRoot $p) -File -ErrorAction SilentlyContinue | Sort-Object FullName)
    foreach ($f in $files) { Add-Prosa (Get-Rel $f.FullName) $motivo }
  }
}

# Unidad uX del JSON -> evaluacion-uX* + clases de la unidad + cierre de cuatrimestre que la menciona.
function Add-ProsaUnidad([string]$u, [string]$motivo) {
  if (-not $script:corpusPresente) { return }
  $unidadDir = @(Get-ChildItem -LiteralPath $script:cursoUnidades -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*-u$u-*" } | Sort-Object FullName | Select-Object -First 1)
  if ($unidadDir.Count -gt 0) {
    foreach ($f in @(Get-ChildItem -LiteralPath $unidadDir[0].FullName -Filter 'clase-*.md' -File -ErrorAction SilentlyContinue | Sort-Object FullName)) {
      Add-Prosa (Get-Rel $f.FullName) $motivo
    }
    foreach ($f in @(Get-ChildItem -LiteralPath $unidadDir[0].FullName -Filter "evaluacion-u$u*.md" -File -ErrorAction SilentlyContinue | Sort-Object FullName)) {
      Add-Prosa (Get-Rel $f.FullName) $motivo
    }
  }
  $cierre = @{ '1' = 'cierre-16-'; '2' = 'cierre-16-'; '3' = 'cierre-33-'; '4' = 'cierre-33-' }[$u]
  if ($cierre) { Add-ProsaPorGlob @("03-encuadre-y-cierres/$cierre*.md") $motivo }
}

# Tramos invariantes: id -> documentos del corpus que lo materializan.
$tramoGlobs = [ordered]@{
  'encuadre-1'            = @('03-encuadre-y-cierres/encuadre-01-diagnostico.md')
  'previos-2-3'           = @('04-intensificaciones/intensificaciones-02-03-*.md', '04-intensificaciones/evaluaciones/evaluacion-intensificaciones-02-03*.md')
  'evaluacion-u1-9'       = @('02-unidades/*-u1-*/evaluacion-u1*.md')
  'evaluacion-u2-15'      = @('02-unidades/*-u2-*/evaluacion-u2*.md')
  'cierre-c1-16'          = @('03-encuadre-y-cierres/cierre-16-*.md')
  'intensificacion-17-18' = @('04-intensificaciones/intensificaciones-17-18-*.md', '04-intensificaciones/evaluaciones/evaluacion-intensificaciones-17-18*.md')
  'integradora-19-20'     = @('04-intensificaciones/intensificaciones-19-20-*.md', '04-intensificaciones/evaluaciones/evaluacion-intensificaciones-19-20*.md')
  'evaluacion-u3-26'      = @('02-unidades/*-u3-*/evaluacion-u3*.md')
  'evaluacion-u4-32'      = @('02-unidades/*-u4-*/evaluacion-u4*.md')
  'cierre-c2-33'          = @('03-encuadre-y-cierres/cierre-33-*.md')
  'intensificacion-34-35' = @('04-intensificaciones/intensificaciones-34-35-*.md', '04-intensificaciones/evaluaciones/evaluacion-intensificaciones-34-35*.md')
  'cierre-integral-36'    = @('03-encuadre-y-cierres/cierre-36-*.md')
}

# Toda la prosa del corpus (para lista (c) y para cambios de canon): todos los .md salvo el README derivado.
$todaProsa = @()
if ($corpusPresente) {
  $todaProsa = @(Get-ChildItem -LiteralPath $cursoRoot -Filter '*.md' -Recurse -File | Where-Object { $_.Name -ne 'README.md' } | Sort-Object FullName | ForEach-Object { Get-Rel $_.FullName })
}

# --- Modo corrida completa: sin version previa del JSON, la prosa a revisar es toda ---
if ($modo -eq 'corrida-completa') {
  foreach ($p in $todaProsa) { Add-Prosa $p "curso-data sin version previa en '$Desde': modo corrida completa" }
  if (-not $corpusPresente) { Add-Nota "corpus de la materia no encontrado en disco: $Curso" }
} else {
  # --- Parseo del diff del JSON de la materia (maquina de estados por lineas del diff) ---
  $curN = $null; $inSlots = $false; $curUnit = $null; $lastKey = $null
  $encuentros = [ordered]@{}       # n -> List[string] de campos
  $unidades = [ordered]@{}         # u -> List[string] de campos
  $tpsCambios = New-Object System.Collections.Generic.List[string]
  $slotsGlobales = New-Object System.Collections.Generic.List[string]
  $topCambios = New-Object System.Collections.Generic.List[string]

  foreach ($line in $jsonDiff) {
    if ($line -match '^(diff --git|index |--- |\+\+\+ |@@ |new file|deleted file|\\)') { continue }
    if ($line.Length -lt 2) { continue }
    $marker = $line.Substring(0, 1)
    $body = $line.Substring(1)
    # El estado se actualiza con lineas de contexto y de cambio por igual.
    if ($body -match '"slots"\s*:\s*\{') { $inSlots = $true; $curUnit = $null; $curN = $null }
    if ($body -match '"encuentros"\s*:\s*\[') { $inSlots = $false; $curUnit = $null }
    if ($body -match '"(tps|ejes|unidades)"\s*:\s*\{') { $curUnit = $null }
    if ($inSlots -and $body -match '"u(\d)"\s*:\s*\{') { $curUnit = $Matches[1] }
    if (-not $inSlots -and $body -match '"n"\s*:\s*(\d+)') { $curN = [int]$Matches[1]; $curUnit = $null }
    if ($body -match '"([A-Za-z0-9_]+)"\s*:') { $lastKey = $Matches[1] }
    if ($marker -ne '+' -and $marker -ne '-') { continue }
    if ($inSlots) {
      if ($body -match '"u(\d)"\s*:\s*"') {
        $u = $Matches[1]
        if (-not $tpsCambios.Contains($u)) { $tpsCambios.Add($u) }
      } elseif ($body -match '"u(\d)"' -or $curUnit) {
        $u = if ($body -match '"u(\d)"') { $Matches[1] } else { $curUnit }
        if (-not $unidades.Contains($u)) { $unidades[$u] = New-Object System.Collections.Generic.List[string] }
        if ($lastKey -and -not $unidades[$u].Contains($lastKey)) { $unidades[$u].Add($lastKey) }
      } elseif ($body -match '"(celular|recursos|tps|ejes)"') {
        if (-not $slotsGlobales.Contains($Matches[1])) { $slotsGlobales.Add($Matches[1]) }
      } else {
        if (-not $slotsGlobales.Contains('slots')) { $slotsGlobales.Add('slots') }
      }
    } elseif ($curN) {
      # Claves SIEMPRE como string: con [int] el indexador de OrderedDictionary es posicional en PS 5.1.
      if (-not $encuentros.Contains([string]$curN)) { $encuentros[[string]$curN] = New-Object System.Collections.Generic.List[string] }
      if ($lastKey -and -not $encuentros[[string]$curN].Contains($lastKey)) { $encuentros[[string]$curN].Add($lastKey) }
    } else {
      if ($lastKey -and -not $topCambios.Contains($lastKey)) { $topCambios.Add($lastKey) }
    }
  }

  # Encuentro n -> clase-NN-* (+ anexo, mismo patron).
  foreach ($n in @($encuentros.Keys)) {
    $campos = $encuentros[$n] -join ', '
    $motivo = "encuentro $n ($campos) cambio en el curso-data"
    $patron = 'clase-{0:d2}-*.md' -f [int]$n
    Add-ProsaPorGlob @("02-unidades/*/$patron") $motivo
  }
  # slots.unidades.uX / slots.tps.uX -> evaluacion + clases de la unidad + cierre.
  foreach ($u in @($unidades.Keys)) {
    Add-ProsaUnidad $u "slots.unidades.u$u ($($unidades[$u] -join ', ')) cambio en el curso-data"
  }
  foreach ($u in $tpsCambios) {
    Add-ProsaUnidad $u "slots.tps.u$u cambio en el curso-data (TP obligatorio de la unidad)"
  }
  foreach ($g in $slotsGlobales) { Add-Nota "slots globales cambiaron ($g): alcanza solo a los derivados (anual, libro de aula y README)" }
  foreach ($t in $topCambios) {
    if ($t -eq 'varianteFraseos') {
      $motivo = "varianteFraseos cambio en el curso-data: se re-materializan TODOS los tramos invariantes"
      foreach ($id in @($tramoGlobs.Keys)) { Add-ProsaPorGlob $tramoGlobs[$id] $motivo }
    } else {
      Add-Nota "identificacion del curso-data cambio ($t): alcanza solo a los derivados (README y administrativos)"
    }
  }

  # --- Parseo del diff del conjunto canonico ---
  $curFile = $null; $curTramo = $null; $lastKeyT = $null
  $tramosCanon = [ordered]@{}      # id -> List[string] de campos
  $canonOtros = New-Object System.Collections.Generic.List[string]

  foreach ($line in $canonDiff) {
    if ($line -match '^\+\+\+ b/(.+)$') { $curFile = $Matches[1]; $curTramo = $null; $lastKeyT = $null; continue }
    if ($line -match '^(diff --git|index |--- |@@ |new file|deleted file|\\)') { continue }
    if ($null -eq $curFile) { continue }
    if ($line.Length -lt 2) { continue }
    $marker = $line.Substring(0, 1)
    $body = $line.Substring(1)
    if ($curFile -like '*plantillas/tramos-invariantes.json') {
      if ($body -match '^\s{2}"([a-z0-9-]+)"\s*:\s*\{') { $curTramo = $Matches[1] }
      if ($body -match '"([A-Za-z0-9_-]+)"\s*:') { $lastKeyT = $Matches[1] }
      if ($marker -eq '+' -or $marker -eq '-') {
        if ($curTramo) {
          if (-not $tramosCanon.Contains($curTramo)) { $tramosCanon[$curTramo] = New-Object System.Collections.Generic.List[string] }
          if ($lastKeyT -and -not $tramosCanon[$curTramo].Contains($lastKeyT)) { $tramosCanon[$curTramo].Add($lastKeyT) }
        } elseif (-not $canonOtros.Contains('plantillas/tramos-invariantes.json')) {
          $canonOtros.Add('plantillas/tramos-invariantes.json')
        }
      }
    } elseif ($marker -eq '+' -or $marker -eq '-') {
      if (-not $canonOtros.Contains($curFile)) { $canonOtros.Add($curFile) }
    }
  }

  foreach ($id in @($tramosCanon.Keys)) {
    $campos = $tramosCanon[$id] -join ', '
    if ($tramoGlobs.Contains($id)) {
      Add-ProsaPorGlob $tramoGlobs[$id] "canon: plantillas/tramos-invariantes.json, tramo '$id' ($campos) cambio"
    } else {
      Add-Nota "canon: tramo '$id' de tramos-invariantes.json sin mapeo a documentos del corpus"
    }
  }

  # Canon que alcanza a TODA la prosa vs canon que solo alimenta derivados.
  $canonNorm = @($Canon | ForEach-Object { $_ -replace '\\', '/' })
  $canonTodaProsa = @('0-prompt-plantilla-planificacion.md', 'estructura-de-la-clase.md', 'plantillas/digest-codigo.md')
  $canonSoloDerivados = @('plantillas/esqueletos-unidad.json', 'plantillas/libro-filas-invariantes.json', 'plantillas/tabla-dominio.json', 'plantillas/readme-plantilla.md', 'plantillas/readme-descripciones.json')
  $alcanzaToda = @($canonOtros | Where-Object { ($canonTodaProsa -contains $_) -or ($canonNorm -contains $_) })
  if ($alcanzaToda.Count -gt 0) {
    $lista = $alcanzaToda -join ', '
    foreach ($p in $todaProsa) { Add-Prosa $p "canon cambio ($lista): toda la prosa queda afectada" }
  }
  $soloDeriv = @($canonOtros | Where-Object { $canonSoloDerivados -contains $_ })
  foreach ($c in $soloDeriv) { Add-Nota "canon cambio ($c): alimenta solo los derivados (render idempotente)" }
  $sinMapeo = @($canonOtros | Where-Object { ($canonTodaProsa -notcontains $_) -and ($canonSoloDerivados -notcontains $_) -and ($canonNorm -notcontains $_) })
  foreach ($c in $sinMapeo) { Add-Nota "canon cambio ($c): sin mapeo automatico a prosa; revisar manualmente" }
}

# --- Lista (c): prosa restante ---
$afectadas = @($prosa.Keys)
$intocada = @($todaProsa | Where-Object { $afectadas -notcontains $_ })

# --- Salidas ---
$derivados = @(
  [ordered]@{ archivo = "$Curso/01-planificacion/planificacion-anual.csv"; comando = 'tools/generar-administrativos.ps1 -Materia <materia> -Salida <curso>/01-planificacion' },
  [ordered]@{ archivo = "$Curso/01-planificacion/libro-de-aula-1-linea-por-encuentro.csv"; comando = 'tools/generar-administrativos.ps1 -Materia <materia> -Salida <curso>/01-planificacion' },
  [ordered]@{ archivo = "$Curso/01-planificacion/libro-de-aula-2-lineas-por-encuentro.csv"; comando = 'tools/generar-administrativos.ps1 -Materia <materia> -Salida <curso>/01-planificacion' },
  [ordered]@{ archivo = "$Curso/README.md"; comando = 'tools/generar-readme.ps1 -Materia <materia> -Curso <curso> -Force' }
)

if ($Json) {
  $prosaJson = @()
  foreach ($k in $prosa.Keys) {
    $prosaJson += [ordered]@{ archivo = $k; motivos = @($prosa[$k]) }
  }
  $cap = 20
  $intocadosVisibles = @($intocada | Select-Object -First $cap)
  $salida = [ordered]@{
    materia = $materiaRel
    desde = $Desde
    modo = $modo
    derivados = $derivados
    prosaAfectada = $prosaJson
    notas = @($notas)
    intocado = [ordered]@{ total = $intocada.Count; archivos = $intocadosVisibles; omitidos = ($intocada.Count - $intocadosVisibles.Count) }
  }
  $salida | ConvertTo-Json -Depth 5
  exit 0
}

Write-Output "IMPACTO - $($materiaRel) (desde $Desde) - modo: $modo"
Write-Output ''
Write-Output '(a) DERIVADOS - re-render SIEMPRE y todos (generadores idempotentes, costo cero):'
foreach ($d in $derivados) { Write-Output "  - $($d.archivo)  <- $($d.comando)" }
Write-Output ''
if ($prosa.Count -eq 0) {
  Write-Output '(b) PROSA AFECTADA - (vacio: sin cambios que alcancen prosa)'
} else {
  Write-Output "(b) PROSA AFECTADA - el LLM abre SOLO estos $($prosa.Count) archivo(s):"
  foreach ($k in $prosa.Keys) { Write-Output "  - $k" ; Write-Output "      por: $($prosa[$k] -join '; ')" }
}
if ($notas.Count -gt 0) {
  Write-Output ''
  Write-Output 'NOTAS:'
  foreach ($n in $notas) { Write-Output "  * $n" }
}
Write-Output ''
if ($intocada.Count -eq 0) {
  Write-Output '(c) INTOCADO - nadie lo abre: 0 archivos'
} else {
  Write-Output "(c) INTOCADO - nadie lo abre: $($intocada.Count) archivos"
  $cap = [Math]::Min(20, $intocada.Count)
  for ($i = 0; $i -lt $cap; $i++) { Write-Output "  - $($intocada[$i])" }
  if ($intocada.Count -gt $cap) { Write-Output "  ... y $($intocada.Count - $cap) mas" }
}
exit 0
