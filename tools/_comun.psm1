# _comun.psm1 — Helpers compartidos de las herramientas deterministas (PowerShell 5.1, cero dependencias).
# Unica fuente de cada helper: los scripts lo importan con
#   Import-Module (Join-Path $PSScriptRoot '_comun.psm1') -Force
# Extraccion (higiene 2026-10, feature odd/tasks/higiene-tools-historial.md): solo helpers que estaban
# duplicados identicos entre scripts. Unificacion documentada: Get-DenominacionUnidad recibe $data por
# parametro (un modulo no ve el scope del script que lo importa) y falla en alto si la unidad no existe
# en el curso-data (antes generar-cierre-anual devolvia $u en silencio; con curso-data validado ambas
# variantes eran equivalentes y los renders no cambian).

function Write-Csv([string]$ruta, [string[]]$lineas) {
  # UTF-8 con BOM, LF de terminador en cada linea (incluida la ultima), como los CSV vigentes.
  $contenido = ($lineas -join "`n") + "`n"
  [System.IO.File]::WriteAllText($ruta, $contenido, (New-Object System.Text.UTF8Encoding($true)))
}

function Convert-Slug([string]$texto) {
  $t = $texto.ToLowerInvariant().Normalize([System.Text.NormalizationForm]::FormD)
  $t = [regex]::Replace($t, '\p{M}', '')
  $t = [regex]::Replace($t, '[^a-z0-9]+', '-').Trim('-')
  return $t
}

function Test-EsCurso([string]$dir) {
  return (Test-Path -LiteralPath (Join-Path $dir '01-planificacion\planificacion-anual.csv'))
}

function Read-Texto([string]$ruta) {
  $t = [System.IO.File]::ReadAllText((Resolve-Path -LiteralPath $ruta).Path)
  return $t.Replace("`r`n", "`n")
}

function Get-LineaCsv([string[]]$campos) {
  ($campos | ForEach-Object { '"' + $_.Replace('"', '""') + '"' }) -join ';'
}

function Get-DenominacionUnidad($data, [string]$u) {
  $prop = $data.slots.unidades.PSObject.Properties[$u]
  if ($null -eq $prop -or $null -eq $prop.Value) { throw "UNIDAD SIN DATOS EN CURSO-DATA: $u" }
  return [string]$prop.Value.denominacion
}

Export-ModuleMember -Function Write-Csv, Convert-Slug, Test-EsCurso, Read-Texto, Get-LineaCsv, Get-DenominacionUnidad
