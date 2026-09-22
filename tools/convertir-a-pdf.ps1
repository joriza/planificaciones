# convertir-a-pdf.ps1 — Conversión determinista de markdown a PDF (acción manual del docente)
# Usa pandoc + wkhtmltopdf (o LaTeX si está disponible) para generar PDFs de una materia.
# No forma parte del flujo de creación del material didáctico: es una acción manual.
#
# Uso (desde la raíz del repositorio):
#   powershell -File tools\convertir-a-pdf.ps1 -Materia LAP
#   powershell -File tools\convertir-a-pdf.ps1 -Materia LAP -Combinado
#   powershell -File tools\convertir-a-pdf.ps1 -Materia LAP -Combinado -Unidad 1
#   powershell -File tools\convertir-a-pdf.ps1 -Materia LAP -Css mi-plantilla.css
#
# Parametros:
#   -Materia   (obligatorio) nombre de la carpeta en output/ (ej. LAP, LSO).
#   -Css       ruta a una plantilla CSS opcional para el PDF.
#   -Combinado  (switch) genera UN PDF por subcarpeta (unidad, encuadre, etc.) en vez de uno por archivo.
#   -Unidad    (opcional, solo con -Combinado) limita la conversión a una unidad numerada (1, 2, 3, 4, etc.).
#   -Salida    carpeta destino (por defecto: output/<Materia>/pdf/).

param(
  [string]$Materia = '',
  [string]$Css = '',
  [switch]$Combinado,
  [switch]$Force,
  [string]$Unidad = '',
  [string]$Salida = ''
)

$ErrorActionPreference = 'Continue'
$raiz = Split-Path -Parent $PSScriptRoot
$rutaMateria = Join-Path $raiz "output\$Materia"

if ($Materia -eq '') {
  Write-Output 'ERROR: falta -Materia <nombre de la carpeta en output/>'
  exit 1
}
if (-not (Test-Path -LiteralPath $rutaMateria)) {
  Write-Output "ERROR: no se encontro la carpeta output\$Materia"
  exit 1
}

# Verificar dependencias
$pandocOk = $false
try { pandoc --version 2>$null | Out-Null; $pandocOk = $true } catch {}
if (-not $pandocOk) {
  Write-Output 'ERROR: pandoc no esta instalado. Instalalo desde https://pandoc.org/'
  exit 1
}
# Verificar al menos un motor PDF
$pdfEngine = $null
try { xelatex --version 2>$null | Out-Null; $pdfEngine = 'xelatex' } catch {}
if (-not $pdfEngine) {
  try { wkhtmltopdf --version 2>$null | Out-Null; $pdfEngine = 'wkhtmltopdf' } catch {}
}
if (-not $pdfEngine) {
  Write-Output 'ERROR: no se encontro un motor PDF (xelatex/MiKTeX o wkhtmltopdf).'
  Write-Output '  Instala wkhtmltopdf desde https://wkhtmltopdf.org/ o MiKTeX desde https://miktex.org/'
  exit 1
}

if ($Salida -eq '') { $Salida = Join-Path $rutaMateria 'pdf' }
if (-not (Test-Path -LiteralPath $Salida)) { New-Item -ItemType Directory -Path $Salida -Force | Out-Null }

# Armar comando base de pandoc
$baseCmd = 'pandoc'
$cssArg = if ($Css -ne '') { @('--css', (Resolve-Path -LiteralPath $Css).Path) } else { @() }
$engineArg = @('--pdf-engine', $pdfEngine)

function Invoke-Pandoc([string[]]$inputFiles, [string]$outFile) {
  $absInputs = $inputFiles | ForEach-Object { (Resolve-Path -LiteralPath $_).Path }
  $outPath = Join-Path $Salida $outFile
  if (-not $Force -and (Test-Path -LiteralPath $outPath)) {
    Write-Output "  Omitido (ya existe, use -Force para sobrescribir): $outFile"
    return
  }
  $pandocArgs = $absInputs + @('-f', 'markdown', '-t', 'pdf') + $cssArg + $engineArg + @('-o', $outPath)
  Write-Output "Generando: $outFile ($($absInputs.Count) archivos)"
  & $baseCmd @pandocArgs 2>$null
  if ($LASTEXITCODE -eq 0) {
    Write-Output "  OK: $outPath"
  } else {
    Write-Output "  ERROR: pandoc fallo con codigo $LASTEXITCODE"
  }
}

# Ignorar README.md y criterios-aprobacion.md (son índices, no material de clase)
$ignorar = @('README.md', 'criterios-aprobacion.md', 'planificacion-anual.csv', 'libro-de-aula-1-linea-por-encuentro.csv', 'libro-de-aula-2-lineas-por-encuentro.csv', 'libro-de-aula-1-linea-por-encuentro.md', 'libro-de-aula-2-lineas-por-encuentro.md', 'planificacion-anual.md')

function Get-MarkdownFiles([string]$dir) {
  return @(Get-ChildItem -LiteralPath $dir -Filter '*.md' -Recurse | Where-Object { $ignorar -notcontains $_.Name })
}

$rutaUnidades = Join-Path $rutaMateria '02-unidades'

if ($Combinado) {
  # Si se especifica -Unidad, buscar dentro de 02-unidades/
  if ($Unidad -ne '') {
    $uniSubs = @(Get-ChildItem -LiteralPath $rutaUnidades -Directory | Where-Object { $_.Name -match "^0*$Unidad-" -or $_.Name -match "^0*$Unidad$" })
    if ($uniSubs.Count -eq 0) { Write-Output "ERROR: no se encontro carpeta para la unidad $Unidad en 02-unidades/"; exit 1 }
    foreach ($sub in $uniSubs) {
      $mds = Get-MarkdownFiles $sub.FullName | Sort-Object Name
      if ($mds.Count -eq 0) { continue }
      invoke-Pandoc ($mds.FullName) ($sub.Name + '.pdf')
    }
  } else {
    # Sin -Unidad: una por carpeta de 02-unidades + otras carpetas toplevel
    # Unidades
    $uniSubs = @(Get-ChildItem -LiteralPath $rutaUnidades -Directory | Sort-Object Name)
    foreach ($sub in $uniSubs) {
      $mds = Get-MarkdownFiles $sub.FullName | Sort-Object Name
      if ($mds.Count -eq 0) { continue }
      invoke-Pandoc ($mds.FullName) ($sub.Name + '.pdf')
    }
    # Otras carpetas toplevel (03-*, 04-*, 05-*, 06-*)
    $otras = @(Get-ChildItem -LiteralPath $rutaMateria -Directory | Where-Object { $_.Name -match '^0[3-6]' } | Sort-Object Name)
    foreach ($sub in $otras) {
      $mds = Get-MarkdownFiles $sub.FullName | Sort-Object Name
      if ($mds.Count -eq 0) { continue }
      invoke-Pandoc ($mds.FullName) ($sub.Name + '.pdf')
    }
  }
} else {
  # Un PDF por archivo
  $mds = Get-MarkdownFiles $rutaMateria | Sort-Object FullName
  if ($Unidad -ne '') {
    $mds = $mds | Where-Object { $_.FullName -match "(\\0*$Unidad-|unidad[^\\]*$Unidad)" }
    if ($mds.Count -eq 0) { Write-Output "ERROR: no se encontraron archivos .md para la unidad $Unidad"; exit 1 }
  }
  foreach ($md in $mds) {
    $rel = $md.FullName.Substring($rutaMateria.Length + 1)
    $pdfName = $rel -replace '\.md$', '.pdf' -replace '\\', '-'
    $outDir = Split-Path (Join-Path $Salida $pdfName) -Parent
    if (-not (Test-Path -LiteralPath $outDir)) { New-Item -ItemType Directory -Path $outDir -Force | Out-Null }
    Invoke-Pandoc @($md.FullName) $pdfName
  }
}

Write-Output "Listo. PDFs en: $Salida"
exit 0