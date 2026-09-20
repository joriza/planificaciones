# verificar-curso.ps1 — Chequeos de integridad de un curso antes de cada entrega formal
# Funciona para cualquier curso generado con la plantilla de planificacion.
# Un "curso" es cualquier carpeta que contenga 01-planificacion\planificacion-anual.csv
# (se busca en la raiz, en subcarpetas y en sub-subcarpetas).
#
# Uso (desde la raiz comun de los cursos):
#   powershell -File verificar-curso.ps1                                verifica todos los cursos detectados
#   powershell -File verificar-curso.ps1 -Curso LSO\minimal-api-csharp  verifica solo ese curso
#   powershell -File verificar-curso.ps1 -Encuentros 36 -MaxCell 35     otros valores configurables
#
# Chequeos:
#   1) planificacion-anual.csv: BOM, parseo y suma de Tiempo == Encuentros
#   2) libro-de-aula*.csv: BOM, filas == N o 2N (ambas versiones presentes) y celdas <= MaxCell
#   3) README.md: todo link relativo apunta a un archivo existente
#   4) Ningun '## Anexo docente' dentro de archivos entregables (anexos siempre separados)
#   5) Cada *-anexo-docente.md tiene su archivo base
param(
  [string]$Curso = '',
  [int]$Encuentros = 36,
  [int]$MaxCell = 35
)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path

function Test-EsCurso([string]$dir) {
  return (Test-Path -LiteralPath (Join-Path $dir '01-planificacion\planificacion-anual.csv'))
}

# --- Deteccion de cursos ---
if ($Curso -ne '') {
  $cursos = @((Join-Path $root $Curso))
  if (-not (Test-EsCurso $cursos[0])) {
    Write-Output "ERROR: '$Curso' no es un curso (falta 01-planificacion\planificacion-anual.csv)"
    exit 1
  }
} else {
  $cursos = @()
  if (Test-EsCurso $root) { $cursos += $root }
  foreach ($d in @(Get-ChildItem -Directory -LiteralPath $root)) {
    if (Test-EsCurso $d.FullName) { $cursos += $d.FullName }
    else {
      $cursos += @(Get-ChildItem -Directory -LiteralPath $d.FullName | Where-Object { Test-EsCurso $_.FullName } | ForEach-Object { $_.FullName })
    }
  }
  if ($cursos.Count -eq 0) {
    Write-Output 'ERROR: no se encontro ningun curso (carpeta con 01-planificacion\planificacion-anual.csv)'
    exit 1
  }
}

$totalFails = 0
foreach ($course in $cursos) {
  $nombre = if ($course -eq $root) { '<raiz>' } else { $course.Substring($root.Length + 1) }
  $fails = @()

  # 1) Planificacion anual: BOM + parseo + suma de Tiempo
  $anualPath = Join-Path $course '01-planificacion\planificacion-anual.csv'
  $bytes = [System.IO.File]::ReadAllBytes($anualPath)
  if (-not ($bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF)) { $fails += 'SIN BOM: planificacion-anual.csv' }
  $anual = @(Import-Csv -Delimiter ';' -LiteralPath $anualPath)
  $suma = ($anual | Measure-Object -Property Tiempo -Sum).Sum
  if ($suma -ne $Encuentros) { $fails += "SUMA: planificacion-anual suma $suma clases (se esperaban $Encuentros)" }

  # 2) Libros de aula: BOM + filas + limite de celdas
  $libros = @(Get-ChildItem -LiteralPath (Join-Path $course '01-planificacion') -Filter 'libro-de-aula*.csv')
  if ($libros.Count -eq 0) { $fails += 'FALTA: no hay ningun libro-de-aula*.csv' }
  $v1 = 0; $v2 = 0
  foreach ($l in $libros) {
    $b = [System.IO.File]::ReadAllBytes($l.FullName)
    if (-not ($b[0] -eq 0xEF -and $b[1] -eq 0xBB -and $b[2] -eq 0xBF)) { $fails += "SIN BOM: $($l.Name)" }
    $rows = @(Import-Csv -Delimiter ';' -LiteralPath $l.FullName)
    if ($rows.Count -eq $Encuentros) { $v1++ }
    elseif ($rows.Count -eq (2 * $Encuentros)) { $v2++ }
    else { $fails += "FILAS: $($l.Name) tiene $($rows.Count) filas (se esperaban $Encuentros o $(2 * $Encuentros))" }
    if ($MaxCell -gt 0) {
      foreach ($r in $rows) {
        $t = "$($r.'Tema del Día')"; $a = "$($r.Actividades)"
        if ($t.Length -gt $MaxCell -or $a.Length -gt $MaxCell) {
          $fails += "CELDA >$MaxCell en $($l.Name): [clase $($r.'Nº Clase')][$t][$a]"
        }
      }
    }
  }
  if (($libros.Count -gt 0) -and (($v1 -eq 0) -or ($v2 -eq 0))) {
    $fails += "VERSIONES: falta un libro con $Encuentros filas o uno con $(2 * $Encuentros)"
  }

  # 3) Links del README: todo destino relativo debe existir
  $readmePath = Join-Path $course 'README.md'
  if (Test-Path -LiteralPath $readmePath) {
    $readme = Get-Content -Raw -Encoding UTF8 -LiteralPath $readmePath
    $links = [regex]::Matches($readme, '\]\(([^)#]+?)(#[^)]*)?\)') | ForEach-Object { $_.Groups[1].Value } | Where-Object { $_ -notmatch '^https?://' } | Sort-Object -Unique
    foreach ($lk in $links) {
      $target = Join-Path $course ($lk -replace '/', '\')
      if (-not (Test-Path -LiteralPath $target)) { $fails += "LINK ROTO en README: $lk" }
    }
  }

  # 4) Sin '## Anexo docente' dentro de archivos entregables
  $entregables = @(Get-ChildItem -LiteralPath $course -Filter '*.md' -Recurse | Where-Object { $_.Name -notlike '*anexo*' })
  foreach ($f in $entregables) {
    if (@(Get-Content -LiteralPath $f.FullName -Encoding UTF8 | Where-Object { $_ -like '## Anexo docente*' }).Count -gt 0) {
      $fails += "ANEXO DENTRO: $($f.FullName.Substring($course.Length + 1))"
    }
  }

  # 5) Cada *-anexo-docente.md debe tener su archivo base
  foreach ($f in @(Get-ChildItem -LiteralPath $course -Filter '*anexo*.md' -Recurse)) {
    $base = $f.FullName -replace '-anexo-docente\.md$', '.md'
    if (-not (Test-Path -LiteralPath $base)) { $fails += "ANEXO HUERFANO: $($f.Name) no tiene su archivo base" }
  }

  if ($fails.Count -eq 0) {
    Write-Output "OK: $nombre"
  } else {
    Write-Output "PROBLEMAS en ${nombre} ($($fails.Count)):"
    $fails | ForEach-Object { Write-Output " - $_" }
    $totalFails += $fails.Count
  }
}

Write-Output ''
if ($totalFails -eq 0) {
  Write-Output "TODO OK: $($cursos.Count) curso(s) verificado(s): BOM, filas, suma $Encuentros, celdas <=$MaxCell, links y anexos separados."
  exit 0
} else {
  Write-Output "TOTAL PROBLEMAS: $totalFails"
  exit 1
}