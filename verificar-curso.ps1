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
#   6) Mojibake: sin secuencias de doble codificacion en los .md del curso
#   7) Titulo de cierre uniforme '### Qué te llevás' en clase-*.md (alumno, sin anexos)
#   8) Records de unidades con BD (u2 en adelante): ids long, fechas string
#      (segun minimal-api-csharp\convenciones-tecnicas.md)
#   9) Cobertura informativa contra la estructura fija de 36 (ver 0-prompt-plantilla-planificacion.md, seccion [Estructura del ciclo lectivo]):
#      clases regulares, evaluaciones dedicadas y momentos de intensificacion presentes/faltantes.
#      No afecta el exit code: reporta avance, no validez formal.
# Los incumplimientos en archivos con deuda conocida se reportan como PENDIENTE (no bloquean).
param(
  [string]$Curso = '',
  [int]$Encuentros = 36,
  [int]$MaxCell = 35
)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path

# Deuda conocida del corpus (rutas relativas a la raiz; reparada la entrada, quitar de aqui):
$deudaConocida = @{}

function Test-EsCurso([string]$dir) {
  return (Test-Path -LiteralPath (Join-Path $dir '01-planificacion\planificacion-anual.csv'))
}

function Format-Rangos([int[]]$nums) {
  if (-not $nums -or $nums.Count -eq 0) { return '(ninguno)' }
  $partes = @(); $ini = $nums[0]; $prev = $nums[0]
  for ($i = 1; $i -lt $nums.Count; $i++) {
    if ($nums[$i] -ne $prev + 1) {
      $partes += $(if ($ini -eq $prev) { "$ini" } else { "$ini-$prev" })
      $ini = $nums[$i]
    }
    $prev = $nums[$i]
  }
  $partes += $(if ($ini -eq $prev) { "$ini" } else { "$ini-$prev" })
  return ($partes -join ', ')
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
$totalPendientes = 0
foreach ($course in $cursos) {
  $nombre = if ($course -eq $root) { '<raiz>' } else { $course.Substring($root.Length + 1) }
  $fails = @()
  $pendientes = @()

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

  # 9) Cobertura informativa contra la estructura fija del ciclo (espeja 0-prompt-plantilla-planificacion.md, seccion [Estructura del ciclo lectivo]).
  #    No afecta el exit code: reporta avance, no validez formal.
  $instanciasAnual = @(1, 16, 33, 36)
  $evaluacionesDedicadas = [ordered]@{ 9 = 'u1'; 15 = 'u2'; 26 = 'u3'; 32 = 'u4' }
  $especialesAnual = @(2, 3, 17, 18, 19, 20, 34, 35)
  $especialesMomentos = 6   # 4 momentos en la anual (2 encuentros c/u) + diciembre + marzo
  $ocupados = @($instanciasAnual + $especialesAnual + @($evaluacionesDedicadas.Keys))
  $regularesEsperados = @(1..$Encuentros | Where-Object { $ocupados -notcontains $_ })

  $mdCurso = @(Get-ChildItem -LiteralPath $course -Filter '*.md' -Recurse | Where-Object { $_.Name -notlike '*anexo*' })
  $clasesPresentes = @($mdCurso | Where-Object { $_.Name -match '^clase-(\d+)-' } | ForEach-Object { [int]$Matches[1] } | Sort-Object -Unique)
  $evalsPresentes = @($mdCurso | Where-Object { $_.Name -match '^evaluacion-(u\d+)' } | ForEach-Object { $Matches[1].ToLowerInvariant() } | Sort-Object -Unique)
  $especialesPresentes = @($mdCurso | Where-Object { $_.Name -like 'intensificaciones-*.md' })
  $regularesPresentes = @($clasesPresentes | Where-Object { $regularesEsperados -contains $_ })
  $faltanRegulares = @($regularesEsperados | Where-Object { $clasesPresentes -notcontains $_ })
  $faltanEvals = @($evaluacionesDedicadas.GetEnumerator() | Where-Object { $evalsPresentes -notcontains $_.Value } | ForEach-Object { "$($_.Value) (encuentro $($_.Key))" })

  Write-Output 'COBERTURA (informativa; no afecta el resultado):'
  Write-Output "  Clases regulares: $($regularesPresentes.Count)/$($regularesEsperados.Count) -> presentes $(Format-Rangos $regularesPresentes) | faltan $(Format-Rangos $faltanRegulares)"
  $evalsTxt = if ($evalsPresentes.Count -gt 0) { $evalsPresentes -join ', ' } else { '(ninguna)' }
  $faltanEvalsTxt = if ($faltanEvals.Count -gt 0) { $faltanEvals -join ', ' } else { '(ninguna)' }
  Write-Output "  Evaluaciones dedicadas: presentes $evalsTxt | faltan $faltanEvalsTxt"
  $especialesTxt = if ($especialesPresentes.Count -gt 0) { ': ' + (($especialesPresentes | ForEach-Object { $_.Name }) -join ', ') } else { '' }
  Write-Output "  Momentos de intensificacion: $($especialesPresentes.Count)/$especialesMomentos documento(s)$especialesTxt"
  Write-Output '  Encuadre y cierres del ciclo (encuentros 1, 16, 33 y 36): sin patron de nombres definido en la plantilla; no se chequean.'
  Write-Output ''

  # 6) Mojibake: secuencias de doble codificacion en los .md del curso
  $patronMojibake = "[ÃÂ$([char]0xFFFD)]"
  foreach ($f in @(Get-ChildItem -LiteralPath $course -Filter '*.md' -Recurse)) {
    $raw = [System.IO.File]::ReadAllText($f.FullName)
    if ($raw -match $patronMojibake) { $fails += "MOJIBAKE en $($f.FullName.Substring($course.Length + 1))" }
  }

  # 7) Titulo de cierre uniforme en documentos de clase del alumno
  $dirUnidades = Join-Path $course '02-unidades'
  if (Test-Path -LiteralPath $dirUnidades) {
    foreach ($f in @(Get-ChildItem -LiteralPath $dirUnidades -Filter 'clase-*.md' -Recurse | Where-Object { $_.Name -notlike '*anexo*' })) {
      $relRoot = $f.FullName.Substring($root.Length + 1)
      $raw = [System.IO.File]::ReadAllText($f.FullName)
      if ($raw -notmatch '(?m)^###\s+Qué te llevás') {
        $msg = if ($raw -match '(?m)^###\s+Qué nos llevamos') {
          "CIERRE DRIFT en $($f.FullName.Substring($course.Length + 1)): usa Que nos llevamos (canonico: Que te llevas)"
        } else {
          "CIERRE FALTA en $($f.FullName.Substring($course.Length + 1)): no se encontro el titulo de cierre"
        }
        if ($deudaConocida.ContainsKey($relRoot)) { $pendientes += "$relRoot — $($deudaConocida[$relRoot])" }
        else { $fails += $msg }
      }
    }
  }

  # 8) Tipos canonicos en records de unidades con base de datos (u2 en adelante)
  if (Test-Path -LiteralPath $dirUnidades) {
    $unidades = @()
    foreach ($u in @(Get-ChildItem -LiteralPath $dirUnidades -Directory)) {
      if ($u.Name -match '^(\d{2})-u\d+' -and [int]$Matches[1] -ge 2) { $unidades += $u }
    }
    foreach ($u in $unidades) {
      foreach ($f in @(Get-ChildItem -LiteralPath $u.FullName -Filter '*.md' -Recurse)) {
        $relRoot = $f.FullName.Substring($root.Length + 1)
        $raw = [System.IO.File]::ReadAllText($f.FullName)
        foreach ($m in [regex]::Matches($raw, '(?m)^\s*record\s+\w+\s*\(([^)]*)\)')) {
          foreach ($p in ($m.Groups[1].Value -split ',')) {
            $p = $p.Trim()
            if ($p -match '^(\S+)\s+(Id\w*|\w*Id)$' -and $Matches[1] -match '^int\??$') {
              if ($deudaConocida.ContainsKey($relRoot)) { $pendientes += "$relRoot — $($deudaConocida[$relRoot])" }
              else { $fails += "RECORD int en $($f.FullName.Substring($course.Length + 1)): '$p' (canonico: long)" }
            }
            if ($p -match '^(DateOnly|DateTime)\??\s') {
              $fails += "RECORD fecha en $($f.FullName.Substring($course.Length + 1)): '$p' (canonico: string)"
            }
          }
        }
      }
    }
  }

  if ($fails.Count -eq 0) {
    Write-Output "OK: $nombre"
  } else {
    Write-Output "PROBLEMAS en ${nombre} ($($fails.Count)):"
    $fails | ForEach-Object { Write-Output " - $_" }
    $totalFails += $fails.Count
  }
  $uniques = @($pendientes | Sort-Object -Unique)
  if ($uniques.Count -gt 0) {
    $uniques | ForEach-Object { Write-Output "PENDIENTE (deuda conocida, no bloquea): $_" }
    $totalPendientes += $uniques.Count
  }
}

Write-Output ''
if ($totalFails -eq 0) {
  $msg = "TODO OK: $($cursos.Count) curso(s) verificado(s): BOM, filas, suma $Encuentros, celdas <=$MaxCell, links, anexos separados, corpus (mojibake, cierre, tipos)."
  if ($totalPendientes -gt 0) { $msg += " PENDIENTES conocidos: $totalPendientes (no bloquean)." }
  Write-Output $msg
  exit 0
} else {
  Write-Output "TOTAL PROBLEMAS: $totalFails"
  exit 1
}