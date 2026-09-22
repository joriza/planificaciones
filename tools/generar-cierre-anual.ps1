# generar-cierre-anual.ps1 — Genera los documentos de cierre del ciclo anual
# (seguimiento, memoria, informes de mesa diciembre y marzo) para una materia.
#
# Uso (desde la raíz del repositorio):
#   powershell -File tools\generar-cierre-anual.ps1 -Materia input\materias\LPR -Salida output\LAP\07-cierre-anual
#   powershell -File tools\generar-cierre-anual.ps1 -Materia input\materias\LPR -Salida output\LAP\07-cierre-anual -Force
#
# Parametros:
#   -Materia (obligatorio) carpeta de la materia (contiene curso-data.json; p. ej. input\materias\LPR).
#   -Salida  carpeta destino (por defecto, output\LAP\07-cierre-anual).
#   -Force   permite sobrescribir archivos existentes. Sin -Force: crea solo los faltantes y AVISA los existentes.
#
# Qué genera: seguimiento-anual.csv, memoria-anual.md, informe-mesa-diciembre.md, informe-mesa-marzo.md.
#
# Regla de propiedad: estos documentos se generan SOLO si no existen (protege sin -Force, avisa).
# El modo actualización jamás los toca; la regeneración completa los re-crea vacíos.
#
# Determinismo: sin azar ni dependencia del entorno; misma entrada -> mismos bytes.
# Formato: CSV UTF-8 con BOM, separador ;, LF. Markdown: UTF-8 sin BOM, LF.
# Errores duros (exit 1): JSON inválido, archivo de entrada ausente, salida existente sin -Force.

param(
  [string]$Materia,
  [string]$Salida,
  [switch]$Force
)

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

# La raiz del repositorio es la carpeta padre de tools\ (donde vive este script).
$raiz = Split-Path -Parent $PSScriptRoot
$rutaInvariantes = Join-Path $raiz 'input\plantillas\libro-filas-invariantes.json'
if (-not (Test-Path -LiteralPath $rutaInvariantes)) {
  Write-Output "ERROR: no se encontro el archivo requerido: $rutaInvariantes"
  exit 1
}

# Determinar la carpeta de salida.
if ($Salida -eq '') {
  $nombreMateria = Split-Path -Leaf (Resolve-Path -LiteralPath $Materia).Path
  $salidaAbs = Join-Path $raiz ('output\' + $nombreMateria + '\07-cierre-anual')
} else {
  if ([System.IO.Path]::IsPathRooted($Salida)) {
    $salidaAbs = $Salida
  } else {
    $salidaAbs = Join-Path $raiz $Salida
  }
}

# Crear la carpeta de salida si no existe.
if (-not (Test-Path -LiteralPath $salidaAbs)) {
  New-Item -ItemType Directory -Path $salidaAbs -Force | Out-Null
}

# Leer las fuentes de datos.
function Read-Texto([string]$ruta) {
  $t = [System.IO.File]::ReadAllText((Resolve-Path -LiteralPath $ruta).Path)
  return $t.Replace("`r`n", "`n")
}

try {
  $data = Read-Texto $rutaJson | ConvertFrom-Json
  $invariantes = Read-Texto $rutaInvariantes | ConvertFrom-Json
} catch {
  Write-Output "ERROR: entrada invalida (JSON): $($_.Exception.Message)"
  exit 1
}

# Construir indice de encuentros por n.
$encuentroPorN = @{}
foreach ($e in @($data.encuentros)) {
  $n = [int]$e.n
  if ($encuentroPorN.ContainsKey($n)) { throw "ENCUENTRO DUPLICADO n=$n en el curso-data" }
  $encuentroPorN[$n] = $e
}

# Construir indice de invariantes por n.
$invarPorN = @{}
foreach ($f in $invariantes) {
  $n = [int]$f.n
  if ($invarPorN.ContainsKey($n)) { throw "INVARIANTES DUPLICADO n=$n" }
  $invarPorN[$n] = $f
}

# Obtener nombre de eje desde slots.ejes.
function Get-EjeNombre([int]$nEje) {
  $prop = $data.slots.ejes.PSObject.Properties[[string]$nEje]
  if ($null -eq $prop) { return '' }
  return [string]$prop.Value
}

# Obtener denominacion de unidad desde slots.unidades.
function Get-DenominacionUnidad([string]$u) {
  $prop = $data.slots.unidades.PSObject.Properties[$u]
  if ($null -eq $prop -or $null -eq $prop.Value) { return $u }
  return [string]$prop.Value.denominacion
}

# Obtener TP de unidad desde slots.tps.
function Get-TPUnidad([string]$u) {
  $prop = $data.slots.tps.PSObject.Properties[$u]
  if ($null -eq $prop -or $null -eq $prop.Value) { return '' }
  return [string]$prop.Value
}

# --- Proteccion sin -Force: avisar archivos existentes ---
$archivosGenerados = @(
  'seguimiento-anual.csv',
  'memoria-anual.md',
  'informe-mesa-diciembre.md',
  'informe-mesa-marzo.md'
)

foreach ($arch in $archivosGenerados) {
  $rutaArch = Join-Path $salidaAbs $arch
  if ((Test-Path -LiteralPath $rutaArch) -and -not $Force) {
    Write-Output "AVISO: archivo existente protegido (use -Force para sobrescribir): $rutaArch"
  }
}

# --- Utilidades CSV ---
function Get-LineaCsv([string[]]$campos) {
  ($campos | ForEach-Object { '"' + $_.Replace('"', '""') + '"' }) -join ';'
}
function Write-Csv([string]$ruta, [string[]]$lineas) {
  # UTF-8 con BOM, LF de terminador en cada linea (incluida la ultima).
  $contenido = ($lineas -join "`n") + "`n"
  [System.IO.File]::WriteAllText($ruta, $contenido, (New-Object System.Text.UTF8Encoding($true)))
}

# --- Construir las 38 filas del seguimiento (36 encuentros + 2 mesas) ---
$camposSeguimiento = @('Nº', 'Instancia', 'Eje temático', 'Tema del día', 'Fecha', 'TPs entregados (grupos)', 'Defensas/Resultados', 'Observaciones')
$lineasCsv = @(Get-LineaCsv $camposSeguimiento)

# Orden de los 36 encuentros: 1..36.
$ordenEncuentros = @(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36)

foreach ($n in $ordenEncuentros) {
  $numero = [string]$n
  $instancia = ''
  $eje = ''
  $tema = ''
  $tp = ''

  if ($encuentroPorN.ContainsKey($n)) {
    # Fila de unidad desde curso-data.json.
    $e = $encuentroPorN[$n]
    $u = [string]$e.unidad
    $eje = Get-EjeNombre ([int]$e.eje)
    $tema = [string]$e.tema
    if ($e.estructura -eq 'cierre') {
      $instancia = 'Unidad ' + $u.Substring(1) + ' (cierre)'
      $tp = Get-TPUnidad $u
    } else {
      $instancia = 'Unidad ' + $u.Substring(1)
    }
  } elseif ($invarPorN.ContainsKey($n)) {
    # Fila invariante desde libro-filas-invariantes.json.
    $f = $invarPorN[$n]
    $eje = [string]$f.ejeNombre
    $tema = [string]$f.tema
    switch ($n) {
      1  { $instancia = 'Encuadre y diagnóstico' }
      2  { $instancia = 'Saberes previos' }
      3  { $instancia = 'Saberes previos' }
      9  { $instancia = 'Evaluación U1' }
      15 { $instancia = 'Evaluación U2' }
      16 { $instancia = 'Cierre de cuatrimestre 1' }
      17 { $instancia = 'Intensificación y fortalecimiento U1-U2' }
      18 { $instancia = 'Intensificación y fortalecimiento U1-U2' }
      19 { $instancia = 'Proyecto puente' }
      20 { $instancia = 'Proyecto puente' }
      26 { $instancia = 'Evaluación U3' }
      32 { $instancia = 'Evaluación U4' }
      33 { $instancia = 'Cierre de cuatrimestre 2' }
      34 { $instancia = 'Intensificación y fortalecimiento U3-U4' }
      35 { $instancia = 'Intensificación y fortalecimiento U3-U4' }
      36 { $instancia = 'Cierre integral' }
      default { $instancia = [string]$f.tema }
    }
  } else {
    # No deberia llegar aqui, pero por seguridad.
    $instancia = 'Desconocido'
    $eje = ''
    $tema = ''
  }

  $lineasCsv += Get-LineaCsv @($numero, $instancia, $eje, $tema, '', $tp, '', '')
}

# Filas de mesa (despues del 36).
$lineasCsv += Get-LineaCsv @('D', 'Mesa de diciembre', 'Evaluación', 'Mesa de diciembre', '', '', '', '')
$lineasCsv += Get-LineaCsv @('M', 'Mesa de marzo', 'Evaluación', 'Mesa de marzo', '', '', '', '')

# Escribir CSV.
$rutaCsv = Join-Path $salidaAbs 'seguimiento-anual.csv'
if (-not (Test-Path -LiteralPath $rutaCsv) -or $Force) {
  Write-Csv $rutaCsv $lineasCsv
  Write-Output "CSV generado: $rutaCsv ($($lineasCsv.Count - 1) filas)"
}

# --- Generar memoria-anual.md ---
function Build-Memoria([string]$raiz, [object]$data, [string]$salidaAbs) {
  $denominacion = [string]$data.denominacion
  $stack = ''
  $propStack = $data.slots.PSObject.Properties['stack']
  if ($null -ne $propStack -and $null -ne $propStack.Value) { $stack = [string]$propStack.Value }
  $entorno = ''
  $propEntorno = $data.slots.PSObject.Properties['entorno']
  if ($null -ne $propEntorno -and $null -ne $propEntorno.Value) { $entorno = [string]$propEntorno.Value }

  $sb = New-Object System.Text.StringBuilder

  # Titulo H1 + blockquote.
  [void]$sb.AppendLine('# Memoria anual — ' + $denominacion)
  [void]$sb.AppendLine('')
  [void]$sb.AppendLine('> Documento de cierre de cátedra en registro docente formal. Se completa al cierre del ciclo; los ajustes que surjan entran por el curso-data y se re-deriva el corpus. Las celdas «—» quedan a cargo del docente.')
  [void]$sb.AppendLine('')

  # Seccion 1: Datos de referencia.
  [void]$sb.AppendLine('## 1. Datos de referencia')
  [void]$sb.AppendLine('')
  [void]$sb.AppendLine('| Campo | Detalle |')
  [void]$sb.AppendLine('| --- | --- |')
  [void]$sb.AppendLine('| Materia | ' + $denominacion + ' |')
  [void]$sb.AppendLine('| Ciclo lectivo | — |')
  [void]$sb.AppendLine('| Stack tecnológico | ' + $stack + ' |')
  [void]$sb.AppendLine('| Entorno de trabajo | ' + $entorno + ' |')
  [void]$sb.AppendLine('| Encuentros teóricos | 36 |')
  [void]$sb.AppendLine('| Nota de diseño | El diseño teórico (36 encuentros) se presenta formalmente; el calendario real puede reducir las clases efectivas. Los documentos de cierre reflejan el diseño, no el recorte del calendario. |')
  [void]$sb.AppendLine('')

  # Seccion 2: Desarrollo efectivo del ciclo.
  [void]$sb.AppendLine('## 2. Desarrollo efectivo del ciclo')
  [void]$sb.AppendLine('')
  [void]$sb.AppendLine('> Completar al cierre del ciclo con las fechas reales de dictado, el estado de cada encuentro y los motivos de los desvíos respecto al diseño teórico.')
  [void]$sb.AppendLine('')
  [void]$sb.AppendLine('| Nº | Instancia | Eje temático | Tema del día | Fecha real | Estado | Motivo de desvío |')
  [void]$sb.AppendLine('| --- | --- | --- | --- | --- | --- | --- |')

  foreach ($n in $ordenEncuentros) {
    $numero = [string]$n
    $instancia = ''
    $eje = ''
    $tema = ''

    if ($encuentroPorN.ContainsKey($n)) {
      $e = $encuentroPorN[$n]
      $u = [string]$e.unidad
      $eje = Get-EjeNombre ([int]$e.eje)
      $tema = [string]$e.tema
      if ($e.estructura -eq 'cierre') {
        $instancia = 'Unidad ' + $u.Substring(1) + ' (cierre)'
      } else {
        $instancia = 'Unidad ' + $u.Substring(1)
      }
    } elseif ($invarPorN.ContainsKey($n)) {
      $f = $invarPorN[$n]
      $eje = [string]$f.ejeNombre
      $tema = [string]$f.tema
      switch ($n) {
        1  { $instancia = 'Encuadre y diagnóstico' }
        2  { $instancia = 'Saberes previos' }
        3  { $instancia = 'Saberes previos' }
        9  { $instancia = 'Evaluación U1' }
        15 { $instancia = 'Evaluación U2' }
        16 { $instancia = 'Cierre de cuatrimestre 1' }
        17 { $instancia = 'Intensificación y fortalecimiento U1-U2' }
        18 { $instancia = 'Intensificación y fortalecimiento U1-U2' }
        19 { $instancia = 'Proyecto puente' }
        20 { $instancia = 'Proyecto puente' }
        26 { $instancia = 'Evaluación U3' }
        32 { $instancia = 'Evaluación U4' }
        33 { $instancia = 'Cierre de cuatrimestre 2' }
        34 { $instancia = 'Intensificación y fortalecimiento U3-U4' }
        35 { $instancia = 'Intensificación y fortalecimiento U3-U4' }
        36 { $instancia = 'Cierre integral' }
        default { $instancia = [string]$f.tema }
      }
    }

    [void]$sb.AppendLine('| ' + $numero + ' | ' + $instancia + ' | ' + $eje + ' | ' + $tema + ' | — | — | — |')
  }

  # Filas de mesa en la tabla de desarrollo efectivo.
  [void]$sb.AppendLine('| D | Mesa de diciembre | Evaluación | Mesa de diciembre | — | — | — |')
  [void]$sb.AppendLine('| M | Mesa de marzo | Evaluación | Mesa de marzo | — | — | — |')
  [void]$sb.AppendLine('')

  # Seccion 3: Resultados por instancia.
  [void]$sb.AppendLine('## 3. Resultados por instancia')
  [void]$sb.AppendLine('')
  [void]$sb.AppendLine('| Instancia | Resultado | Observaciones |')
  [void]$sb.AppendLine('| --- | --- | --- |')
  [void]$sb.AppendLine('| Evaluación U1 | — | — |')
  [void]$sb.AppendLine('| Evaluación U2 | — | — |')
  [void]$sb.AppendLine('| Evaluación U3 | — | — |')
  [void]$sb.AppendLine('| Evaluación U4 | — | — |')
  [void]$sb.AppendLine('| Saberes previos | — | — |')
  [void]$sb.AppendLine('| Intensificación U1-U2 | — | — |')
  [void]$sb.AppendLine('| Proyecto puente | — | — |')
  [void]$sb.AppendLine('| Intensificación U3-U4 | — | — |')
  [void]$sb.AppendLine('| Mesa de diciembre | — | — |')
  [void]$sb.AppendLine('| Mesa de marzo | — | — |')
  [void]$sb.AppendLine('')

  # Seccion 4: Trabajos prácticos.
  [void]$sb.AppendLine('## 4. Trabajos prácticos')
  [void]$sb.AppendLine('')
  [void]$sb.AppendLine('| TP | Denominación | Entrega | Defensa | Observaciones |')
  [void]$sb.AppendLine('| --- | --- | --- | --- | --- |')

  foreach ($u in @('u1', 'u2', 'u3', 'u4')) {
    $tp = Get-TPUnidad $u
    $denom = Get-DenominacionUnidad $u
    [void]$sb.AppendLine('| ' + $tp + ' | ' + $denom + ' | — | — | — |')
  }
  [void]$sb.AppendLine('')

  # Seccion 5: Continuidad pedagógica.
  [void]$sb.AppendLine('## 5. Continuidad pedagógica')
  [void]$sb.AppendLine('')
  [void]$sb.AppendLine('| Documento | Qué es | Ajuste según el pedido de la materia |')
  [void]$sb.AppendLine('| --- | --- | --- |')
  [void]$sb.AppendLine('| [continuidad-01-saberes-previos.md](../05-continuidad/continuidad-01-saberes-previos.md) | Repaso de saberes previos antes de la primera unidad didáctica. | — |')
  [void]$sb.AppendLine('| [continuidad-02-tras-evaluacion-u1.md](../05-continuidad/continuidad-02-tras-evaluacion-u1.md) | Repaso de los contenidos trabajados hasta la evaluación de la Unidad 1. | — |')
  [void]$sb.AppendLine('| [continuidad-03-tras-evaluacion-u2.md](../05-continuidad/continuidad-03-tras-evaluacion-u2.md) | Repaso de los contenidos trabajados hasta la evaluación de la Unidad 2. | — |')
  [void]$sb.AppendLine('| [continuidad-04-tras-evaluacion-u3.md](../05-continuidad/continuidad-04-tras-evaluacion-u3.md) | Repaso de los contenidos trabajados hasta la evaluación de la Unidad 3. | — |')
  [void]$sb.AppendLine('')

  # Seccion 6: Intensificación y fortalecimiento.
  [void]$sb.AppendLine('## 6. Intensificación y fortalecimiento')
  [void]$sb.AppendLine('')
  [void]$sb.AppendLine('| Momento | Encuentros | Resultado | Observaciones |')
  [void]$sb.AppendLine('| --- | --- | --- | --- |')
  [void]$sb.AppendLine('| Saberes previos | 2-3 | — | — |')
  [void]$sb.AppendLine('| Intensificación y fortalecimiento U1-U2 | 17-18 | — | — |')
  [void]$sb.AppendLine('| Proyecto puente | 19-20 | — | — |')
  [void]$sb.AppendLine('| Intensificación y fortalecimiento U3-U4 | 34-35 | — | — |')
  [void]$sb.AppendLine('| Diciembre | Fuera de la estructura anual | — | — |')
  [void]$sb.AppendLine('| Marzo | Fuera de la estructura anual | — | — |')
  [void]$sb.AppendLine('')

  # Seccion 7: Balance del ciclo.
  [void]$sb.AppendLine('## 7. Balance del ciclo')
  [void]$sb.AppendLine('')
  [void]$sb.AppendLine('> Completar al cierre del ciclo: síntesis del recorrido, logros del grupo, dificultades encontradas y aprendizajes del docente.')
  [void]$sb.AppendLine('')

  # Seccion 8: Ajustes propuestos.
  [void]$sb.AppendLine('## 8. Ajustes propuestos para el próximo ciclo')
  [void]$sb.AppendLine('')
  [void]$sb.AppendLine('> Los ajustes entran por el curso-data y se re-deriva el corpus. Complete con las observaciones que surgieron durante el cierre del ciclo.')
  [void]$sb.AppendLine('')

  # Seccion 9: Firma.
  [void]$sb.AppendLine('## 9. Firma')
  [void]$sb.AppendLine('')
  [void]$sb.AppendLine('| Aclaración | Firma | Fecha |')
  [void]$sb.AppendLine('| --- | --- | --- |')
  [void]$sb.AppendLine('| — | — | — |')
  [void]$sb.AppendLine('')

  return $sb.ToString()
}

$rutaMemoria = Join-Path $salidaAbs 'memoria-anual.md'
if (-not (Test-Path -LiteralPath $rutaMemoria) -or $Force) {
  $memoria = Build-Memoria $raiz $data $salidaAbs
  [System.IO.File]::WriteAllText($rutaMemoria, $memoria.TrimEnd("`n") + "`n", (New-Object System.Text.UTF8Encoding($false)))
  Write-Output "Memoria generada: $rutaMemoria"
}

# --- Generar informe-mesa-diciembre.md ---
function Build-InformeMesa([string]$tituloMesa, [string]$mesaNombre, [string]$evaluacionRef, [object]$data, [hashtable]$encuentroPorN, [hashtable]$invarPorN) {
  $denominacion = [string]$data.denominacion
  $stack = ''
  $propStack = $data.slots.PSObject.Properties['stack']
  if ($null -ne $propStack -and $null -ne $propStack.Value) { $stack = [string]$propStack.Value }
  $entorno = ''
  $propEntorno = $data.slots.PSObject.Properties['entorno']
  if ($null -ne $propEntorno -and $null -ne $propEntorno.Value) { $entorno = [string]$propEntorno.Value }

  # Construir alcance evaluado: camino minimo por unidad + TPs.
  $alcanceLines = New-Object System.Collections.Generic.List[string]
  foreach ($u in @('u1', 'u2', 'u3', 'u4')) {
    $denom = Get-DenominacionUnidad $u
    $propUni = $data.slots.unidades.PSObject.Properties[$u]
    $expectativas = ''
    if ($null -ne $propUni -and $null -ne $propUni.Value) {
      $expectativas = [string]$propUni.Value.expectativas
    }
    $expectativas = $expectativas.TrimEnd('.')
    $tp = Get-TPUnidad $u
    [void]$alcanceLines.Add('- **' + $denom + '**: ' + $expectativas + '. TP: ' + $tp + '.')
  }

  $sb = New-Object System.Text.StringBuilder

  [void]$sb.AppendLine('# Informe de mesa — Intensificación de ' + $mesaNombre + ' (' + $denominacion + ')')
  [void]$sb.AppendLine('')
  [void]$sb.AppendLine('> Documento formal de la mesa en registro docente formal. Las celdas «—» quedan a cargo del docente.')
  [void]$sb.AppendLine('')

  [void]$sb.AppendLine('## 1. Datos de la mesa')
  [void]$sb.AppendLine('')
  [void]$sb.AppendLine('| Campo | Detalle |')
  [void]$sb.AppendLine('| --- | --- |')
  [void]$sb.AppendLine('| Instancia | ' + $tituloMesa + ' |')
  [void]$sb.AppendLine('| Marco | Fuera de la estructura anual |')
  [void]$sb.AppendLine('| Fecha | — |')
  [void]$sb.AppendLine('| Espacio | — |')
  [void]$sb.AppendLine('| Docente | — |')
  [void]$sb.AppendLine('')

  [void]$sb.AppendLine('## 2. Destinatarios')
  [void]$sb.AppendLine('')
  [void]$sb.AppendLine('> Completar con los alumnos inscriptos que no alcanzaron los objetivos mínimos.')
  [void]$sb.AppendLine('')
  [void]$sb.AppendLine('| Alumno | Condición | Metas pendientes |')
  [void]$sb.AppendLine('| --- | --- | --- |')
  [void]$sb.AppendLine('| — | — | — |')
  [void]$sb.AppendLine('')

  [void]$sb.AppendLine('## 3. Alcance evaluado')
  [void]$sb.AppendLine('')
  [void]$sb.AppendLine('Camino mínimo completo — por unidad, denominación y expectativas, más los TPs declarados en el curso-data:')
  [void]$sb.AppendLine('')
  foreach ($line in $alcanceLines) {
    [void]$sb.AppendLine($line)
  }
  [void]$sb.AppendLine('')

  [void]$sb.AppendLine('## 4. Metodología')
  [void]$sb.AppendLine('')
  [void]$sb.AppendLine('Criterio **Apto / No apto aún por objetivo mínimo** por cada objetivo del camino mínimo. El estándar de marzo es idéntico al de diciembre: no baja, cambia el tiempo de preparación.')
  [void]$sb.AppendLine('')

  [void]$sb.AppendLine('## 5. Instrumento')
  [void]$sb.AppendLine('')
  [void]$sb.AppendLine('Evaluaciones del corpus: [versión A](../04-intensificaciones/evaluaciones/evaluacion-intensificaciones-' + $evaluacionRef + '-version-a.md) y [versión B](../04-intensificaciones/evaluaciones/evaluacion-intensificaciones-' + $evaluacionRef + '-version-b.md).')
  [void]$sb.AppendLine('')

  [void]$sb.AppendLine('## 6. Resultados')
  [void]$sb.AppendLine('')
  [void]$sb.AppendLine('> Completar con los resultados de la mesa: alumno, versión evaluada, resultado y observaciones.')
  [void]$sb.AppendLine('')
  [void]$sb.AppendLine('| Alumno | Versión | Resultado | Observaciones |')
  [void]$sb.AppendLine('| --- | --- | --- | --- |')
  [void]$sb.AppendLine('| — | — | — | — |')
  [void]$sb.AppendLine('')

  [void]$sb.AppendLine('## 7. Firmas')
  [void]$sb.AppendLine('')
  [void]$sb.AppendLine('| Aclaración | Firma | Fecha |')
  [void]$sb.AppendLine('| --- | --- | --- |')
  [void]$sb.AppendLine('| — | — | — |')
  [void]$sb.AppendLine('')

  return $sb.ToString()
}

$rutaDiciembre = Join-Path $salidaAbs 'informe-mesa-diciembre.md'
if (-not (Test-Path -LiteralPath $rutaDiciembre) -or $Force) {
  $infoDiciembre = Build-InformeMesa 'Mesa de diciembre' 'diciembre' 'diciembre' $data $encuentroPorN $invarPorN
  [System.IO.File]::WriteAllText($rutaDiciembre, $infoDiciembre.TrimEnd("`n") + "`n", (New-Object System.Text.UTF8Encoding($false)))
  Write-Output "Informe mesa diciembre generado: $rutaDiciembre"
}

$rutaMarzo = Join-Path $salidaAbs 'informe-mesa-marzo.md'
if (-not (Test-Path -LiteralPath $rutaMarzo) -or $Force) {
  $infoMarzo = Build-InformeMesa 'Mesa de marzo' 'marzo' 'marzo' $data $encuentroPorN $invarPorN
  [System.IO.File]::WriteAllText($rutaMarzo, $infoMarzo.TrimEnd("`n") + "`n", (New-Object System.Text.UTF8Encoding($false)))
  Write-Output "Informe mesa marzo generado: $rutaMarzo"
}

Write-Output 'OK: documentos de cierre del ciclo anual generados.'
exit 0
