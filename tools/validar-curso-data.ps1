# validar-curso-data.ps1 — Validación del curso-data.json de una materia antes de renderizar administrativos.
#
# Uso (desde la raíz del repositorio):
#   powershell -File tools\validar-curso-data.ps1 -Materia input\materias\LSO
#
# Comportamiento: si todo valida, imprime un resumen OK y sale con 0; si hay incumplimientos,
# los lista TODOS y sale con 1.
#
# Chequeos:
#   1) JSON parseable; materia y denominacion no vacíos; varianteFraseos entero >= 1.
#   2) encuentros: exactamente 20 filas, con n únicos e iguales a 4-8, 10-14, 21-25 y 27-31,
#      y unidad coherente con el rango de n (u1: 4-8, u2: 10-14, u3: 21-25, u4: 27-31).
#   3) caracter del vocabulario canónico (Conceptual, Procedimental, Actitudinal); eje entero 1-6
#      presente en slots.ejes; estructura 'cierre' exactamente en n = 8, 14, 25 y 31 y 'clase' en el resto;
#      tp = slots.tps de la unidad en los cierres y null fuera de ellos.
#   4) tema y actividadesLibro1 no vacíos y <= 35 caracteres; actividadesLibro2 con exactamente
#      2 items, cada uno no vacío y <= 35 caracteres.
#   5) slots.tps con u1..u4 no vacíos; slots.unidades u1..u4 con denominacion, expectativas,
#      transversales, actividadesApertura y extension no vacíos (nota es opcional); slots.ejes con 1..6.

param([string]$Materia = '')

$ErrorActionPreference = 'Stop'

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

try {
  $rutaAbsoluta = (Resolve-Path -LiteralPath $rutaJson).Path
  $data = [System.IO.File]::ReadAllText($rutaAbsoluta) | ConvertFrom-Json
} catch {
  Write-Output "ERROR: JSON invalido en $rutaJson : $($_.Exception.Message)"
  exit 1
}

# --- Aviso de duplicado input/output (regla: vale el de input; nunca se borra) ---
$raizRepo = Split-Path -Parent $PSScriptRoot
$nombreMateria = Split-Path ((Resolve-Path -LiteralPath $Materia).Path) -Leaf
$rutaDuplicado = Join-Path $raizRepo ("output\" + $nombreMateria + "\curso-data.json")
if (Test-Path -LiteralPath $rutaDuplicado) {
  Write-Output "AVISO: curso-data duplicado en output\$nombreMateria\curso-data.json (vale el de input; considere eliminar el duplicado)."
}

$errores = New-Object System.Collections.Generic.List[string]
function Add-Error([string]$mensaje) { $errores.Add($mensaje) | Out-Null }
function Test-NoVacio($valor) { -not [string]::IsNullOrWhiteSpace([string]$valor) }

# --- 1) Encabezado de la materia ---
if (-not (Test-NoVacio $data.materia)) { Add-Error 'materia: vacio o ausente' }
if (-not (Test-NoVacio $data.denominacion)) { Add-Error 'denominacion: vacia o ausente' }
$v = $data.varianteFraseos
if ($null -eq $v -or ($v -isnot [int] -and $v -isnot [long])) {
  Add-Error "varianteFraseos: debe ser entero >= 1 (valor: $v)"
} elseif ($v -lt 1) {
  Add-Error "varianteFraseos: debe ser >= 1 (valor: $v)"
}

# --- 5) Slots globales (se chequean antes de los encuentros para poder validar tp y eje contra ellos) ---
$tpsValores = @{}
$tps = $data.slots.tps
if ($null -eq $tps) {
  Add-Error 'slots.tps: ausente'
} else {
  foreach ($u in @('u1', 'u2', 'u3', 'u4')) {
    $prop = $tps.PSObject.Properties[$u]
    if ($null -eq $prop) { Add-Error "slots.tps: falta $u" }
    elseif (-not (Test-NoVacio $prop.Value)) { Add-Error "slots.tps.$u : vacio" }
    else { $tpsValores[$u] = [string]$prop.Value }
  }
}

$unidades = $data.slots.unidades
if ($null -eq $unidades) {
  Add-Error 'slots.unidades: ausente'
} else {
  foreach ($u in @('u1', 'u2', 'u3', 'u4')) {
    $prop = $unidades.PSObject.Properties[$u]
    if ($null -eq $prop) { Add-Error "slots.unidades: falta $u"; continue }
    $uni = $prop.Value
    foreach ($campo in @('denominacion', 'expectativas', 'transversales', 'actividadesApertura', 'extension')) {
      $p = $uni.PSObject.Properties[$campo]
      if ($null -eq $p -or -not (Test-NoVacio $p.Value)) { Add-Error "slots.unidades.$u.$campo : vacio o ausente" }
    }
    # nota: opcional, sin chequeo de contenido.
  }
}

$ejes = $data.slots.ejes
$ejesPresentes = @{}
if ($null -eq $ejes) {
  Add-Error 'slots.ejes: ausente'
} else {
  foreach ($nEje in 1..6) {
    $prop = $ejes.PSObject.Properties[[string]$nEje]
    if ($null -eq $prop) { Add-Error "slots.ejes: falta $nEje" }
    else { $ejesPresentes[$nEje] = $true }
  }
}

# --- 2) y 3) Encuentros: estructura fija de 36, rango/unidad, vocabulario, cierres y tp ---
$rangos = @(
  @{ unidad = 'u1'; desde = 4; hasta = 8 },
  @{ unidad = 'u2'; desde = 10; hasta = 14 },
  @{ unidad = 'u3'; desde = 21; hasta = 25 },
  @{ unidad = 'u4'; desde = 27; hasta = 31 }
)
$esperados = @()
foreach ($r in $rangos) { $esperados += ($r.desde..$r.hasta) }
$cierresEsperados = @(8, 14, 25, 31)
$caracteresValidos = @('Conceptual', 'Procedimental', 'Actitudinal')

$encs = @($data.encuentros)
if ($encs.Count -ne 20) {
  Add-Error "encuentros: deben ser exactamente 20 filas (hay $($encs.Count))"
}

$ns = @()
$i = 0
foreach ($e in $encs) {
  $i++
  $etiqueta = "encuentros[$i]"
  if ("$($e.n)" -notmatch '^\d+$') {
    Add-Error "$etiqueta : n ausente o no entero"
    continue
  }
  $n = [int]$e.n
  $ns += $n

  $unidadEsperada = $null
  foreach ($r in $rangos) {
    if ($n -ge $r.desde -and $n -le $r.hasta) { $unidadEsperada = $r.unidad }
  }
  if ($null -eq $unidadEsperada) {
    Add-Error "$etiqueta : n=$n fuera de los rangos de unidad (4-8, 10-14, 21-25, 27-31)"
  } elseif ([string]$e.unidad -ne $unidadEsperada) {
    Add-Error "$etiqueta : n=$n debe ser de $unidadEsperada (unidad=$($e.unidad))"
  }

  if ($caracteresValidos -notcontains [string]$e.caracter) {
    Add-Error "$etiqueta (n=$n): caracter '$($e.caracter)' fuera del vocabulario Conceptual/Procedimental/Actitudinal"
  }

  if ("$($e.eje)" -notmatch '^\d+$') {
    Add-Error "$etiqueta (n=$n): eje ausente o no entero"
  } else {
    $nEje = [int]$e.eje
    if ($nEje -lt 1 -or $nEje -gt 6) {
      Add-Error "$etiqueta (n=$n): eje $nEje fuera de 1-6"
    } elseif (-not $ejesPresentes.ContainsKey($nEje)) {
      Add-Error "$etiqueta (n=$n): eje $nEje no esta presente en slots.ejes"
    }
  }

  $esCierreEsperado = $cierresEsperados -contains $n
  $estructura = [string]$e.estructura
  if ($estructura -ne 'clase' -and $estructura -ne 'cierre') {
    Add-Error "$etiqueta (n=$n): estructura '$estructura' debe ser 'clase' o 'cierre'"
  } elseif ($esCierreEsperado -and $estructura -ne 'cierre') {
    Add-Error "$etiqueta : n=$n debe tener estructura 'cierre' (tiene '$estructura')"
  } elseif (-not $esCierreEsperado -and $estructura -ne 'clase') {
    Add-Error "$etiqueta : n=$n debe tener estructura 'clase' (tiene '$estructura')"
  }

  if ($estructura -eq 'cierre' -and $null -ne $unidadEsperada) {
    $tpEsperado = if ($tpsValores.ContainsKey($unidadEsperada)) { $tpsValores[$unidadEsperada] } else { $null }
    if ([string]$e.tp -ne [string]$tpEsperado) {
      Add-Error "$etiqueta (n=$n): tp debe ser '$tpEsperado' (slots.tps.$unidadEsperada) en el cierre (tiene '$($e.tp)')"
    }
  } elseif ($estructura -ne 'cierre' -and $null -ne $e.tp) {
    Add-Error "$etiqueta (n=$n): tp debe ser null fuera de los cierres (tiene '$($e.tp)')"
  }

  # --- 4) Límites de celdas del libro de aula ---
  foreach ($par in @(@('tema', $e.tema), @('actividadesLibro1', $e.actividadesLibro1))) {
    $nombreCampo = $par[0]
    $valorCampo = [string]$par[1]
    if (-not (Test-NoVacio $valorCampo)) {
      Add-Error "$etiqueta (n=$n): $nombreCampo vacio"
    } elseif ($valorCampo.Length -gt 35) {
      Add-Error "$etiqueta (n=$n): $nombreCampo supera 35 caracteres ($($valorCampo.Length))"
    }
  }
  $a2 = @($e.actividadesLibro2)
  if ($a2.Count -ne 2) {
    Add-Error "$etiqueta (n=$n): actividadesLibro2 debe tener exactamente 2 items (tiene $($a2.Count))"
  } else {
    for ($j = 0; $j -lt 2; $j++) {
      if (-not (Test-NoVacio $a2[$j])) {
        Add-Error "$etiqueta (n=$n): actividadesLibro2[$j] vacio"
      } elseif (([string]$a2[$j]).Length -gt 35) {
        Add-Error "$etiqueta (n=$n): actividadesLibro2[$j] supera 35 caracteres ($(([string]$a2[$j]).Length))"
      }
    }
  }
}

# n únicos y exactamente los 20 de la estructura fija
$duplicados = @($ns | Group-Object | Where-Object { $_.Count -gt 1 } | ForEach-Object { $_.Name })
if ($duplicados.Count -gt 0) {
  Add-Error "encuentros: n repetidos: $($duplicados -join ', ')"
}
$faltan = @($esperados | Where-Object { $ns -notcontains $_ })
if ($faltan.Count -gt 0) {
  Add-Error "encuentros: faltan los n: $($faltan -join ', ')"
}
$sobran = @($ns | Where-Object { $esperados -notcontains $_ })
if ($sobran.Count -gt 0) {
  Add-Error "encuentros: n inesperados: $($sobran -join ', ')"
}

# --- Resultado ---
if ($errores.Count -gt 0) {
  Write-Output "PROBLEMAS en $Materia ($($errores.Count)):"
  foreach ($e in $errores) { Write-Output " - $e" }
  exit 1
}
Write-Output "OK: $rutaJson"
Write-Output '  curso-data valido: 20 encuentros (4-8, 10-14, 21-25, 27-31), slots u1..u4 y ejes 1-6 completos,'
Write-Output '  cierres 8/14/25/31 con tp de unidad, celdas de libro <=35.'
exit 0
