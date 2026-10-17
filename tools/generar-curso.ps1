# generar-curso.ps1 — Runner del pipeline de un curso: encadena las fases deterministas y la puerta de salida.
# Higiene 2026-10 (feature odd/tasks/higiene-tools-historial.md, S5): un solo comando en lugar de cinco,
# con corte al primer fallo y propagacion del exit code de la herramienta que falla.
#
# Uso (desde la raiz del repositorio):
#   powershell -File tools\generar-curso.ps1 -Materia input\materias\<m> [-Curso output\<m>] [-HorasPorEncuentro <h>] [-Force] [-SoloVerificacion]
#   -HorasPorEncuentro es opcional: si no se pasa, se deriva de curso-data.json (campo
#   slots.horasPorEncuentro cuando existe, suma de tiempos[].min / 60 si falta). El flag
#   sigue existiendo para overrides manuales o materias sin campo declarado.
#
# Pasos (cada uno es el script existente; este runner no duplica logica):
#   [1/5] validar-curso-data      firma del docente en verde (corte si falla)
#   [2/5] generar-administrativos render CSV a <Curso>\01-planificacion (idempotente)
#   [3/5] generar-readme          README derivado; protege el existente salvo -Force
#   [4/5] verificar-curso         integridad del corpus
#   [5/5] lint-canon              canon del corpus (-HorasPorEncuentro; deriva de curso-data si no se pasa)
# Con -SoloVerificacion corre solo [4/5] y [5/5] (puerta de salida de una corrida ya renderizada).
#
# Exit codes: 0 = todo en verde | el exit code del primer paso que falla (1 uso/parseo, 2 hallazgos ERROR).
param(
  [string]$Materia = '',
  [string]$Curso = '',
  [int]$HorasPorEncuentro = 0,
  [switch]$Force,
  [switch]$SoloVerificacion
)
$ErrorActionPreference = 'Stop'

if ($Materia -eq '') {
  Write-Output 'ERROR: falta -Materia <ruta a la carpeta de la materia (contiene curso-data.json)>'
  exit 1
}
if ($Curso -eq '') {
  $Curso = Join-Path 'output' (Split-Path -Leaf $Materia)
}

# Derivacion automatica de horas por encuentro cuando el flag no se paso explicitamente.
if ($HorasPorEncuentro -eq 0) {
  Import-Module (Join-Path $PSScriptRoot '_comun.psm1') -Force
  $HorasPorEncuentro = [int](Get-HorasPorEncuentro $Materia)
}

$steps = @()
if (-not $SoloVerificacion) {
  $steps += @(
    @{ N = '1/5'; Nombre = 'validar-curso-data';      Script = 'validar-curso-data.ps1';      Args = @{ Materia = $Materia } },
    @{ N = '2/5'; Nombre = 'generar-administrativos'; Script = 'generar-administrativos.ps1'; Args = @{ Materia = $Materia; Salida = (Join-Path $Curso '01-planificacion'); HorasPorEncuentro = $HorasPorEncuentro } },
    @{ N = '3/5'; Nombre = 'generar-readme';          Script = 'generar-readme.ps1';          Args = @{ Materia = $Materia; Curso = $Curso; Salida = (Join-Path $Curso 'README.md') } }
  )
}
$steps += @(
  @{ N = '4/5'; Nombre = 'verificar-curso'; Script = 'verificar-curso.ps1'; Args = @{ Curso = $Curso } },
  @{ N = '5/5'; Nombre = 'lint-canon';      Script = 'lint-canon.ps1';      Args = @{ Curso = $Curso; HorasPorEncuentro = $HorasPorEncuentro } }
)

foreach ($paso in $steps) {
  Write-Output ("=== [{0}] {1} ===" -f $paso.N, $paso.Nombre)
  # Splatting del hashtable de argumentos: las claves se pasan como nombres de parametro
  # (el splatting de array pasaria los tokens como posicionales y romperia el binding).
  $argumentos = $paso.Args
  if ($Force -and $paso.Nombre -eq 'generar-readme') { $argumentos['Force'] = $true }
  & (Join-Path $PSScriptRoot $paso.Script) @argumentos
  if ($LASTEXITCODE -ne 0) {
    Write-Output ("FALLA en {0} (exit {1}). Pipeline cortado." -f $paso.Nombre, $LASTEXITCODE)
    exit $LASTEXITCODE
  }
}
Write-Output ("OK: pipeline de {0} en verde ({1})." -f $Curso, $(if ($SoloVerificacion) { 'solo verificacion' } else { '5 pasos' }))
exit 0
