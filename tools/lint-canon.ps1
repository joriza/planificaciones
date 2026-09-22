# lint-canon.ps1 — Linter determinista del canon de codigo del corpus de un curso.
# Regla general: cada hallazgo cita la fuente del canon que lo respalda.
# El canon tecnico de tipos/formatos/estructura es minimal-api-csharp\convenciones-tecnicas.md
# (secciones: 3 estilo, 4 tipos canonicos, 6 respuestas HTTP). El tiempo del encuentro
# (240 min) es regla de estructura del ciclo: 01-planificacion\planificacion-anual.csv.
#
# Uso (desde la raiz del repositorio):
#   powershell -File tools\lint-canon.ps1                        revisa todos los cursos detectados
#   powershell -File tools\lint-canon.ps1 -Curso minimal-api-csharp   revisa solo ese curso
#
# Reglas (cada hallazgo = archivo:linea: regla: mensaje + cita del canon):
#   registro-tipos  ERROR  En fences ```csharp, parametros de `record Nombre(...)`: ids con `int`
#                          y fechas con `DateTime`/`DateOnly`. Canon: convenciones-tecnicas.md
#                          seccion 4 (ids SIEMPRE long; fechas SIEMPRE string ISO).
#   results-http    ERROR  En fences ```csharp: uso de `TypedResults` (canon: seccion 6, Results
#                          en .NET 6); `Results.Ok` o `Results.NoContent` dentro de un handler
#                          MapPost (la alta responde 201 Created); `Results.Ok` o
#                          `Results.Created` dentro de MapDelete (el borrado responde 204).
#                          El PUT no se marca: el canon admite 200 (en memoria) o 204 (con BD).
#   identificador-ingles ERROR Identicadores con tildes/eñes dentro de fences ```csharp, y
#                          lexico espanol curado como identificador (Paciente, Medico,
#                          Especialidad, Turno, Libro, Autor, Socio, Alumno, etc.). Canon:
#                          seccion 3 (identificadores en ingles; no aplica a prosa ni a
#                          comentarios dentro del codigo).
#   timebox         ERROR  En clase-*.md sin anexo: la suma de los "min" de la tabla
#                          "Reparto de tiempos" no da 240. Fuente: encuentro de 240 minutos
#                          (planificacion-anual.csv; metadata del propio documento).
#   tipo-estructura ERROR  En clase-*.md sin anexo: falta la tabla de reparto de tiempos.
#   preview-libro   AVISO  En clase-*.md sin anexo: el preview "Lo que viene" no coincide con
#                          el tema del encuentro mencionado en libro-de-aula-1-linea-por-
#                          encuentro.csv (heuristica: al menos una palabra significativa en
#                          comun). Report-only, no afecta el exit code.
#   prosa-estampada AVISO  3 o mas clase-*.md sin anexo comparten identica primera linea de
#                          prosa tras el primer titulo. Report-only, no afecta el exit code.
#   NOTA: los archivos *-anexo-docente.md se revisan igual que su doc base (tienen codigo),
#         salvo en las reglas de estructura (timebox, preview, prosa), que son del doc del
#         alumno. La ruta del archivo siempre figura en el hallazgo.
#
# Exit codes: 0 = sin ERROR (los AVISO no bloquean) | 2 = hay hallazgos ERROR | 1 = error de uso/parseo.
param(
  [string]$Curso = '',
  [int]$HorasPorEncuentro = 4
)
$ErrorActionPreference = 'Stop'
# El script vive en tools\; la deteccion de cursos queda anclada a la raiz del repositorio.
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$minPorEncuentro = $HorasPorEncuentro * 60

function Test-EsCurso([string]$dir) {
  return (Test-Path -LiteralPath (Join-Path $dir '01-planificacion\planificacion-anual.csv'))
}

# --- Deteccion de cursos (mismo patron que verificar-curso.ps1) ---
if ($Curso -ne '') {
  if (-not (Test-Path -LiteralPath $Curso)) {
    Write-Output "ERROR de uso: no existe la carpeta '$Curso'"
    exit 1
  }
  $cursos = @((Resolve-Path -LiteralPath $Curso).Path)
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
    Write-Output 'ERROR de uso: no se encontro ningun curso (carpeta con 01-planificacion\planificacion-anual.csv). Usar -Curso <carpeta>.'
    exit 1
  }
}

# --- Expresiones regulares del canon ---
$rxFence      = '^\s*```'
$rxRecordIni  = '^(?i)\s*record\s+([A-Za-z_][A-Za-z0-9_]*)\s*\('
$rxParamIdInt = '^(?i)int\??\s+(Id\w*|\w*Id)\b'
$rxParamFecha = '^(?i)(DateOnly|DateTime)\??\s+[A-Za-z_]'
$rxMapPostDel = 'app\.Map(Post|Delete)\s*\('
$rxFinHandler = '^\s*\}\)\s*;'
$rxToken      = '[^\W\d][\w]*'      # identificador .NET (letras unicode: toma tildes y enies)
$rxNoAscii    = '[^\x00-\x7F]'      # tildes/enies: prohibidas en identificadores (canon seccion 3)
# Lexico espanol curado como identificador (canon seccion 3: identificadores en ingles).
$rxEspanol    = '^(Pacientes?|Medicos?|Medicas?|Especialidades?|Turnos?|Bibliotecas?|Libros?|Autores?|Socios?|Alumnos?|Alumnas?|Inscripciones?|Facturas?|HistoriaClinica|ObraSocial|Prestamos?|Recetas?|Obras?Sociales?)$'
$rxHeading    = '^#{1,6}\s'
$rxTbHead     = '^#{2,4}\s+.*Reparto de tiempos'
$rxPrevHead   = '^#{2,4}\s+Lo que viene'
$rxFilaTabla  = '^\s*\|'
$rxSeparador  = '^\s*\|[\s:\-\|]+\|\s*$'
$rxMin        = '(\d+)\s*min\b'
$rxEncuentro  = 'Encuentros?\s+(\d+)'
$rxPalabra    = '[^\p{L}\p{Nd}]+'
$vacias       = @('sobre','entre','para','como','desde','hasta','cuando','donde','primer','primera','usando','puede','pueden','dentro','encuentro','encuentros','unidad','clase','cierre','apertura','minutos','trabajo')

function Add-Hallazgo([System.Collections.Generic.List[object]]$lista, [string]$sev, [string]$rel, [int]$num, [string]$regla, [string]$msg) {
  $null = $lista.Add([pscustomobject]@{ Sev = $sev; Rel = $rel; Linea = $num; Regla = $regla; Msg = $msg })
}

# Quita contenido de strings y comentarios de una linea de codigo (barrera contra falsos
# positivos: prosa y comentarios del codigo no son identificadores).
function Get-CodigoLimpio([string]$l) {
  $c = $l -replace '"(?:[^"\\]|\\.)*"', '""'
  $c = $c -replace '//.*$', ''
  $c = $c -replace '--.*$', ''   # comentarios SQL dentro de strings verbatim
  return $c
}

# --- Reglas 1, 2 y 3 sobre el contenido de un fence csharp ---
function Invoke-AnalisisCSharp([string[]]$lineas, [int[]]$nums, [string]$rel, [System.Collections.Generic.List[object]]$hallazgos) {
  $n = $lineas.Count

  # Regla 1: parametros de record (canon seccion 4)
  for ($k = 0; $k -lt $n; $k++) {
    if ($lineas[$k] -match $rxRecordIni) {
      $recName = $Matches[1]
      $buf = $lineas[$k]
      $fin = $k
      while ($fin -lt $n -and $buf -notmatch '\)') { $fin++; $buf += ' ' + $lineas[$fin] }
      $params = $buf -replace '^[^(]*\(', '' -replace '\)[^)]*$', ''
      foreach ($p in ($params -split ',')) {
        $p = (Get-CodigoLimpio $p).Trim()
        if ($p -match $rxParamIdInt) {
          Add-Hallazgo $hallazgos 'ERROR' $rel $nums[$k] 'registro-tipos' ("record ${recName}: id '$($p -replace '\s+', ' ')' con int (canon: convenciones-tecnicas.md seccion 4 - ids SIEMPRE long, nunca int)")
        }
        if ($p -match $rxParamFecha) {
          Add-Hallazgo $hallazgos 'ERROR' $rel $nums[$k] 'registro-tipos' ("record ${recName}: fecha '$($p -replace '\s+', ' ')' con $($Matches[1]) (canon: convenciones-tecnicas.md seccion 4 - fechas SIEMPRE string ISO yyyy-MM-dd, nunca DateTime/DateOnly)")
        }
      }
      $k = $fin   # el record consumido no se re-lee
    }
  }

  # Regla 2: Results vs TypedResults y verbos (canon seccion 6)
  for ($k = 0; $k -lt $n; $k++) {
    if ($lineas[$k] -match 'TypedResults\.') {
      Add-Hallazgo $hallazgos 'ERROR' $rel $nums[$k] 'results-http' 'TypedResults no se usa en este curso (canon: convenciones-tecnicas.md seccion 6 - Results es el canon de .NET 6)'
    }
  }
  for ($k = 0; $k -lt $n; $k++) {
    if ($lineas[$k] -match $rxMapPostDel) {
      $verbo = $Matches[1]
      $fin = $k
      if ($lineas[$k] -notmatch '\);\s*$') {
        $fin = $k + 1
        while ($fin -lt $n -and $lineas[$fin] -notmatch $rxFinHandler) { $fin++ }
      }
      for ($w = $k; $w -le $fin -and $w -lt $n; $w++) {
        if ($verbo -eq 'Post' -and $lineas[$w] -match 'Results\.Ok\s*\(') {
          Add-Hallazgo $hallazgos 'ERROR' $rel $nums[$w] 'results-http' 'MapPost responde Results.Ok (canon: convenciones-tecnicas.md seccion 6 - la alta por POST responde 201 Results.Created)'
        }
        if ($verbo -eq 'Post' -and $lineas[$w] -match 'Results\.NoContent\s*\(') {
          Add-Hallazgo $hallazgos 'ERROR' $rel $nums[$w] 'results-http' 'MapPost responde Results.NoContent (canon: convenciones-tecnicas.md seccion 6 - la alta por POST responde 201 Results.Created; 204 es de DELETE y PUT con BD)'
        }
        if ($verbo -eq 'Delete' -and ($lineas[$w] -match 'Results\.Ok\s*\(' -or $lineas[$w] -match 'Results\.Created\s*\(')) {
          Add-Hallazgo $hallazgos 'ERROR' $rel $nums[$w] 'results-http' 'MapDelete responde con cuerpo (canon: convenciones-tecnicas.md seccion 6 - el borrado responde 204 Results.NoContent)'
        }
      }
      $k = $fin
    }
  }

  # Regla 3: identificadores en ingles, sin tildes ni enies (canon seccion 3)
  for ($k = 0; $k -lt $n; $k++) {
    $c = Get-CodigoLimpio $lineas[$k]
    foreach ($m in [regex]::Matches($c, $rxToken)) {
      $tok = $m.Value
      if ($tok -match $rxNoAscii) {
        Add-Hallazgo $hallazgos 'ERROR' $rel $nums[$k] 'identificador-ingles' ("identificador '$tok' con tildes/enies (canon: convenciones-tecnicas.md seccion 3 - identificadores en ingles, sin caracteres acentuados)")
      } elseif ($tok -cmatch $rxEspanol) {
        Add-Hallazgo $hallazgos 'ERROR' $rel $nums[$k] 'identificador-ingles' ("identificador '$tok' en espanol (canon: convenciones-tecnicas.md seccion 3 - identificadores en ingles)")
      }
    }
  }
}

function Get-PalabrasClave([string]$texto) {
  $salida = @()
  foreach ($t in ([regex]::Split($texto.ToLowerInvariant(), $rxPalabra))) {
    if ($t.Length -ge 5 -and ($vacias -notcontains $t)) { $salida += $t }
  }
  return $salida
}

$totalErrores = 0
$totalAvisos = 0

foreach ($course in $cursos) {
  # El curso puede estar fuera de la raiz (por ejemplo una copia temporal para pruebas).
  $nombre = if ($course -eq $root) { '<raiz>' }
            elseif ($course.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase)) { $course.Substring($root.Length + 1) }
            else { $course }
  $hallazgos = New-Object System.Collections.Generic.List[object]

  # Libro de aula 1 linea (para la regla preview-libro): n -> Tema del Dia.
  # Columnas por posicion: 0 = "N_Clase", 4 = "Tema del D_a" (nombres con caracteres especiales).
  $libro = @{}
  $libroPath = Join-Path $course '01-planificacion\libro-de-aula-1-linea-por-encuentro.csv'
  $tieneLibro = (Test-Path -LiteralPath $libroPath)
  if ($tieneLibro) {
    foreach ($r in @(Import-Csv -Delimiter ';' -LiteralPath $libroPath)) {
      $props = @($r.PSObject.Properties)
      $nClase = 0
      if ([int]::TryParse([string]$props[0].Value, [ref]$nClase)) { $libro[$nClase] = [string]$props[4].Value }
    }
  }

  $primerasLineas = @{}   # texto de primera linea de prosa -> lista de archivos (regla 6)
  $primerasNums = @{}     # archivo -> linea de esa primera prosa

  $archivos = @(Get-ChildItem -LiteralPath $course -Filter '*.md' -Recurse | Sort-Object FullName)
  foreach ($f in $archivos) {
    $rel = $f.FullName.Substring($course.Length + 1)
    $esAnexo = $f.Name -like '*anexo*'
    $esClase = ($f.Name -match '^clase-(\d+)-') -and -not $esAnexo
    $nClase = 0
    if ($f.Name -match '^clase-(\d+)-') { $nClase = [int]$Matches[1] }

    $lineas = $null
    try { $lineas = [System.IO.File]::ReadAllLines($f.FullName, [System.Text.Encoding]::UTF8) }
    catch {
      Write-Output "ERROR de parseo en ${rel}: $($_.Exception.Message)"
      exit 1
    }

    $inFence = $false; $fenceLang = ''
    $fenceTxt = New-Object System.Collections.Generic.List[string]
    $fenceNum = New-Object System.Collections.Generic.List[int]
    $viH1 = $false; $tengoPrimera = $false
    $secTb = $false; $tbSuma = 0; $tbLinea = 0; $hayTb = $false
    $secPrev = $false; $prevTxt = New-Object System.Collections.Generic.List[string]; $hayPrev = $false

    for ($i = 0; $i -lt $lineas.Count; $i++) {
      $linea = $lineas[$i]

      if ($linea -match $rxFence) {
        if (-not $inFence) {
          $inFence = $true; $fenceLang = $linea -replace '^\s*```', ''; $fenceLang = $fenceLang.Trim()
        } else {
          $inFence = $false
          if ($fenceLang -eq 'csharp') { Invoke-AnalisisCSharp $fenceTxt.ToArray() $fenceNum.ToArray() $rel $hallazgos }
          $fenceTxt.Clear(); $fenceNum.Clear()
        }
        continue
      }
      if ($inFence) { $fenceTxt.Add($linea); $fenceNum.Add($i + 1); continue }

      # Regla 4: reparto de tiempos (solo clase del alumno)
      if ($linea -match $rxTbHead) { $secTb = $true; $tbSuma = 0; $tbLinea = $i + 1; $hayTb = $true; continue }
      if ($secTb) {
        if ($linea -match $rxHeading) {
          $secTb = $false
          if ($tbSuma -ne $minPorEncuentro) {
            Add-Hallazgo $hallazgos 'ERROR' $rel $tbLinea 'timebox' ("el reparto de tiempos suma $tbSuma min (regla del ciclo: encuentro de $minPorEncuentro min; ver 01-planificacion\planificacion-anual.csv)")
          }
        } elseif ($linea -match $rxFilaTabla -and $linea -notmatch $rxSeparador -and $linea -notmatch 'Total') {
          if ($linea -match $rxMin) { $tbSuma += [int]$Matches[1] }
        }
      }

      # Regla 5: preview "Lo que viene" (solo clase del alumno)
      if ($linea -match $rxPrevHead) { $secPrev = $true; $hayPrev = $true; continue }
      if ($secPrev) {
        if ($linea -match $rxHeading) {
          $secPrev = $false
          if ($esClase -and $tieneLibro) {
            $prev = ($prevTxt -join ' ') -replace '[*`_>]', ''
            $sig = 0
            if ($prev -match $rxEncuentro) {
              $sig = [int]$Matches[1]
              if (-not $libro.ContainsKey($sig)) {
                Add-Hallazgo $hallazgos 'AVISO' $rel ($i + 1) 'preview-libro' ("el preview anuncia el Encuentro $sig pero el libro de aula no tiene esa clase (fuente: 01-planificacion\libro-de-aula-1-linea-por-encuentro.csv)")
              } else {
                $claves = Get-PalabrasClave ([string]$libro[$sig])
                $prevTokens = Get-PalabrasClave $prev
                $comun = @($claves | Where-Object { $prevTokens -contains $_ })
                if ($comun.Count -eq 0) {
                  Add-Hallazgo $hallazgos 'AVISO' $rel ($i + 1) 'preview-libro' ("el preview del Encuentro $sig no comparte ninguna palabra significativa con el tema del libro: '$($libro[$sig])' (heuristica de solapamiento; fuente: libro-de-aula CSV)")
                }
              }
            } else {
              Add-Hallazgo $hallazgos 'AVISO' $rel ($i + 1) 'preview-libro' 'el preview "Lo que viene" no menciona ningun Encuentro N (no se puede correlacionar con el libro de aula)'
            }
          }
          $prevTxt.Clear()
        } elseif ($linea.Trim() -ne '') {
          $prevTxt.Add($linea)
        }
      }

      # Regla 6: primera linea de prosa tras el primer titulo (solo clase del alumno)
      if ($linea -match '^#\s') { $viH1 = $true; continue }
      if ($esClase -and $viH1 -and -not $tengoPrimera) {
        if ($linea.Trim() -ne '' -and $linea -notmatch $rxHeading -and $linea -notmatch $rxFilaTabla) {
          $tengoPrimera = $true
          $clave = $linea.Trim()
          if (-not $primerasLineas.ContainsKey($clave)) { $primerasLineas[$clave] = New-Object System.Collections.Generic.List[string] }
          $null = $primerasLineas[$clave].Add($rel)
          $primerasNums[$rel] = $i + 1
        }
      }
    }

    # Cierre de seccion timebox al terminar el archivo
    if ($secTb -and $hayTb) {
      if ($tbSuma -ne $minPorEncuentro) {
        Add-Hallazgo $hallazgos 'ERROR' $rel $tbLinea 'timebox' ("el reparto de tiempos suma $tbSuma min (regla del ciclo: encuentro de $minPorEncuentro min; ver 01-planificacion\planificacion-anual.csv)")
      }
    }
    # Regla 4b: clase del alumno sin tabla de reparto de tiempos
    if ($esClase -and -not $hayTb) {
      Add-Hallazgo $hallazgos 'ERROR' $rel 1 'tipo-estructura' "clase sin seccion \"Reparto de tiempos\" (estructura fija del encuentro de $minPorEncuentro min; ver planificacion-anual.csv; use -HorasPorEncuentro si la materia no es de 4 h)"
    }
    # Regla 5b: clase del alumno sin preview
    if ($esClase -and -not $hayPrev -and $nClase -gt 0) {
      Add-Hallazgo $hallazgos 'AVISO' $rel 1 'preview-libro' 'clase sin seccion "Lo que viene" (no se puede correlacionar con el encuentro siguiente del libro de aula)'
    }
  }

  # Regla 6: grupos de 3+ clases con identica primera linea de prosa
  foreach ($clave in @($primerasLineas.Keys)) {
    $grupo = @($primerasLineas[$clave])
    if ($grupo.Count -ge 3) {
      $ancla = $grupo[0]
      Add-Hallazgo $hallazgos 'AVISO' $ancla $primerasNums[$ancla] 'prosa-estampada' ("$($grupo.Count) clases abren con la misma linea de prosa: `"$clave`" -> $($grupo -join ', ')")
    }
  }

  # --- Salida agrupada por severidad ---
  $errores = @($hallazgos | Where-Object { $_.Sev -eq 'ERROR' })
  $avisos = @($hallazgos | Where-Object { $_.Sev -eq 'AVISO' })
  Write-Output "CANON LINT: $nombre ($($archivos.Count) archivos .md)"
  Write-Output "ERRORES ($($errores.Count)):"
  $errores | ForEach-Object { Write-Output (" - {0}:{1}: {2}: {3}" -f $_.Rel, $_.Linea, $_.Regla, $_.Msg) }
  Write-Output "AVISOS ($($avisos.Count)):"
  $avisos | ForEach-Object { Write-Output (" - {0}:{1}: {2}: {3}" -f $_.Rel, $_.Linea, $_.Regla, $_.Msg) }
  Write-Output ''
  $totalErrores += $errores.Count
  $totalAvisos += $avisos.Count
}

Write-Output "RESUMEN: $totalErrores errores, $totalAvisos avisos."
if ($totalErrores -gt 0) { exit 2 }
exit 0
