# generar-readme.ps1 — Render determinista del README índice de una materia
# a partir del árbol del corpus + curso-data.json + plantillas (readme-plantilla.md,
# readme-descripciones.json) + nota de la cátedra manual (materias/<materia>/nota-catedra.md, opcional).
#
# Uso (desde la raíz del repositorio):
#   powershell -File tools\generar-readme.ps1 -Materia input\materias\LSO -Curso output\LSO [-Salida <archivo>] [-Force]
#
# Parametros:
#   -Materia (obligatorio) carpeta de la materia (contiene curso-data.json; p. ej. input\materias\LSO).
#   -Curso   (obligatorio) carpeta del corpus del curso (p. ej. output/LSO).
#   -Salida  archivo de salida (por defecto <curso>\README.md; si existe y no se pasa -Force, aborta).
#   -Force   permite sobrescribir el archivo de salida existente.
#
# Qué genera: presentación del curso (slots del curso-data), índice completo del corpus
# (clasificación por convenciones de nombres + descripciones interpoladas), orden de creación
# derivado del árbol, fundamentación pedagógica de la plantilla y nota de la cátedra manual.
# Archivos no reconocidos por las convenciones de nombres: se listan en "Otros documentos" (nunca se descartan).
#
# Determinismo: sin azar ni dependencia del entorno; mismas entradas -> mismos bytes.
# Formato: UTF-8 sin BOM, líneas LF.
# Errores duros (exit 1): JSON inválido, plantilla/descripciones ausentes, slot desconocido,
# archivo de clase sin dato en el curso-data, salida existente sin -Force.

param(
  [string]$Materia,
  [string]$Curso,
  [string]$Salida,
  [switch]$Force
)

$ErrorActionPreference = 'Stop'

if ($Materia -eq '') {
  Write-Output 'ERROR: falta -Materia <ruta a la carpeta de la materia (contiene curso-data.json)>'
  exit 1
}
if ($Curso -eq '') {
  Write-Output 'ERROR: falta -Curso <carpeta del corpus del curso>'
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

# La raíz del repositorio es la carpeta padre de tools\ (donde vive este script).
$raiz = Split-Path -Parent $PSScriptRoot
$rutaCurso = Join-Path $raiz $Curso
if (-not (Test-Path -LiteralPath $rutaCurso)) {
  Write-Output "ERROR: no se encontro la carpeta del curso: $rutaCurso"
  exit 1
}
$rutaCursoAbs = (Resolve-Path -LiteralPath $rutaCurso).Path
$rutaPlantilla = Join-Path $raiz 'input\plantillas\readme-plantilla.md'
$rutaDescripciones = Join-Path $raiz 'input\plantillas\readme-descripciones.json'
foreach ($ruta in @($rutaJson, $rutaPlantilla, $rutaDescripciones)) {
  if (-not (Test-Path -LiteralPath $ruta)) {
    Write-Output "ERROR: no se encontro el archivo requerido: $ruta"
    exit 1
  }
}

function Read-Texto([string]$ruta) {
  $t = [System.IO.File]::ReadAllText((Resolve-Path -LiteralPath $ruta).Path)
  return $t.Replace("`r`n", "`n")
}

try {
  $data = Read-Texto $rutaJson | ConvertFrom-Json
  $plantilla = Read-Texto $rutaPlantilla
  $desc = Read-Texto $rutaDescripciones | ConvertFrom-Json
} catch {
  Write-Output "ERROR: entrada inválida (JSON o plantilla): $($_.Exception.Message)"
  exit 1
}

# --- Sustitución de slots ---
# Slots de datos {{...}}; los marcadores de sección generada ({{INDICE}}, {{ORDEN}}, {{NOTA_CATEDRA}})
# se dejan en su lugar durante la expansión y se resuelven al final.
$patronSlots = '\{\{([^{}]+)\}\}'
$marcadoresReservados = @('INDICE', 'ORDEN', 'NOTA_CATEDRA')

function Expand-Plantilla([string]$texto, [hashtable]$valores, [string]$contexto) {
  if ($null -eq $texto) { throw "CAMPO AUSENTE en $contexto" }
  $sb = New-Object System.Text.StringBuilder
  $pos = 0
  foreach ($m in [regex]::Matches($texto, $patronSlots)) {
    [void]$sb.Append($texto.Substring($pos, $m.Index - $pos))
    $clave = $m.Groups[1].Value.Trim()
    if ($marcadoresReservados -contains $clave) {
      [void]$sb.Append($m.Value)
    } elseif (-not $valores.ContainsKey($clave)) {
      throw "SLOT DESCONOCIDO '{{${clave}}}' en $contexto"
    } else {
      [void]$sb.Append([string]$valores[$clave])
    }
    $pos = $m.Index + $m.Length
  }
  [void]$sb.Append($texto.Substring($pos))
  return $sb.ToString()
}

# --- Utilidades de texto ---
function Upper-Primera([string]$s) {
  if ([string]::IsNullOrEmpty($s)) { return $s }
  $c = [char]::ToUpperInvariant($s[0])
  return [string]$c + $s.Substring(1)
}

# 'saberes-previos' -> 'Saberes previos'; 'unidades-1-2' -> 'Unidades 1 y 2'.
function Get-TituloSlug([string]$slug) {
  $toks = $slug.Split('-')
  if ($toks.Length -ge 2 -and $toks[$toks.Length - 1] -match '^\d+$' -and $toks[$toks.Length - 2] -match '^\d+$') {
    $n1 = [int]$toks[$toks.Length - 2]
    $n2 = [int]$toks[$toks.Length - 1]
    $base = ($toks[0..($toks.Length - 3)] -join ' ')
    return (Upper-Primera ($base + ' ' + $n1 + ' y ' + $n2))
  }
  return (Upper-Primera ($toks -join ' '))
}

# --- Consultas al curso-data y a las plantillas de descripción ---
function Get-Seccion([string]$clave) {
  $s = $desc.secciones.PSObject.Properties[$clave]
  if ($null -eq $s) { throw "SECCION AUSENTE en readme-descripciones.json: $clave" }
  return [string]$s.Value
}
function Get-DescripcionTipo([string]$tipo, [string]$campo) {
  $t = $desc.tipos.PSObject.Properties[$tipo]
  if ($null -eq $t) { throw "TIPO SIN PLANTILLA EN readme-descripciones.json: $tipo" }
  $c = $t.Value.PSObject.Properties[$campo]
  if ($null -eq $c) { throw "CAMPO '$campo' AUSENTE para el tipo $tipo en readme-descripciones.json" }
  return [string]$c.Value
}
function Get-DenominacionUnidad([string]$u) {
  $p = $data.slots.unidades.PSObject.Properties[$u]
  if ($null -eq $p -or $null -eq $p.Value) { throw "UNIDAD SIN DATOS EN CURSO-DATA: $u" }
  return [string]$p.Value.denominacion
}
function Get-NombreUnidad([string]$u) {
  if ($u -match '^u(\d+)$') { return 'Unidad ' + $Matches[1] }
  return $u
}

# Encuentros del curso-data agrupados por unidad y ordenados por n.
$encuentrosPorUnidad = @{}
foreach ($e in @($data.encuentros)) {
  $u = [string]$e.unidad
  if (-not $encuentrosPorUnidad.ContainsKey($u)) { $encuentrosPorUnidad[$u] = New-Object System.Collections.Generic.List[object] }
  [void]$encuentrosPorUnidad[$u].Add($e)
}
$clavesUnidades = @($encuentrosPorUnidad.Keys)
foreach ($u in $clavesUnidades) {
  $encuentrosPorUnidad[$u] = @($encuentrosPorUnidad[$u] | Sort-Object { [int]$_.n })
}
$encuentroPorClave = @{}
$minEncuentro = 0
foreach ($u in $clavesUnidades) {
  foreach ($e in $encuentrosPorUnidad[$u]) {
    $encuentroPorClave[$u + '|' + [int]$e.n] = $e
    if ($minEncuentro -eq 0 -or [int]$e.n -lt $minEncuentro) { $minEncuentro = [int]$e.n }
  }
}
function Get-EvalN([string]$u) {
  if (-not $encuentrosPorUnidad.ContainsKey($u)) { throw "UNIDAD SIN DATOS EN CURSO-DATA: $u" }
  $max = 0
  foreach ($e in $encuentrosPorUnidad[$u]) { if ([int]$e.n -gt $max) { $max = [int]$e.n } }
  return ($max + 1)
}

# --- Slots globales (curso-data + rutas canónicas) ---
$slotsGlobales = @{}
$slotsGlobales['denominacion'] = [string]$data.denominacion
$slotsGlobales['materia'] = Split-Path $Materia -Leaf
$propCelular = $data.slots.PSObject.Properties['celular']
if ($null -eq $propCelular -or $null -eq $propCelular.Value) {
  Write-Output 'ERROR: slots.celular ausente en el curso-data'
  exit 1
}
$slotsGlobales['celular'] = [string]$propCelular.Value
foreach ($u in @('u1', 'u2', 'u3', 'u4')) {
  $p = $data.slots.tps.PSObject.Properties[$u]
  if ($null -eq $p -or $null -eq $p.Value) {
    Write-Output "ERROR: slots.tps.$u ausente en el curso-data"
    exit 1
  }
  $slotsGlobales["tp.$u"] = [string]$p.Value
  $slotsGlobales["unidad.$u"] = Get-DenominacionUnidad $u
}
$slotsGlobales['cargaHoraria'] = '36 encuentros de 4 horas reloj (240 minutos teóricos por encuentro): 144 horas anuales, 18 encuentros por cuatrimestre'
$materiaNorm = ($Materia -replace '\\', '/').TrimEnd('/')
$slotsGlobales['rutaData'] = $materiaNorm + '/curso-data.json'
$slotsGlobales['linkConvenciones'] = '../../' + $materiaNorm + '/convenciones-tecnicas.md'
$slotsGlobales['rutaTool'] = 'tools/generar-administrativos.ps1'
$slotsGlobales['rutaReadmeTool'] = 'tools/generar-readme.ps1'

# Filas opcionales de la tabla de presentación: presentes solo si el curso-data define el slot.
$slotsGlobales['FILA_STACK'] = ''
$propStack = $data.slots.PSObject.Properties['stack']
if ($null -ne $propStack -and $null -ne $propStack.Value) {
  $stackTxt = $propStack.Value
  if ($stackTxt -is [System.Array]) { $stackTxt = @($stackTxt) -join ', ' }
  $slotsGlobales['FILA_STACK'] = '| Stack tecnológico | ' + [string]$stackTxt + " |`n"
}
$slotsGlobales['FILA_ENTORNO'] = ''
$propEntorno = $data.slots.PSObject.Properties['entorno']
if ($null -ne $propEntorno -and $null -ne $propEntorno.Value) {
  $entornoTxt = $propEntorno.Value
  if ($entornoTxt -is [System.Array]) { $entornoTxt = @($entornoTxt) -join ', ' }
  $slotsGlobales['FILA_ENTORNO'] = '| Entorno de trabajo | ' + [string]$entornoTxt + " |`n"
}

function New-FilaSlots([hashtable]$extras) {
  $f = $slotsGlobales.Clone()
  foreach ($k in $extras.Keys) { $f[$k] = $extras[$k] }
  return $f
}

# --- Recorrido y clasificación del árbol del corpus ---
$archivos = New-Object System.Collections.Generic.List[object]
Get-ChildItem -LiteralPath $rutaCursoAbs -Recurse -File | ForEach-Object {
  $rel = $_.FullName.Substring($rutaCursoAbs.Length + 1).Replace('\', '/')
  [void]$archivos.Add(@{ rel = $rel })
}
$archivos = @($archivos | Sort-Object { $_.rel })

# Clasificación por convenciones de nombres; devuelve $null solo para README.md (el índice mismo).
function Get-Clasificacion([string]$rel) {
  if ($rel -eq 'README.md') { return $null }
  if ($rel -match '^[^/]+$') {
    if ($rel -match '^convenciones') { return @{ tipo = 'convenciones' } }
    return @{ tipo = 'otros' }
  }
  if ($rel -match '^01-planificacion/planificacion-anual\.csv$') { return @{ tipo = 'anual' } }
  if ($rel -match '^01-planificacion/libro-de-aula-1-linea-por-encuentro\.csv$') { return @{ tipo = 'libro1' } }
  if ($rel -match '^01-planificacion/libro-de-aula-2-lineas-por-encuentro\.csv$') { return @{ tipo = 'libro2' } }
  if ($rel -match '^01-planificacion/') { return @{ tipo = 'otros' } }

  if ($rel -match '^02-unidades/\d+-u(\d+)-[^/]+/(.+)$') {
    $unidad = 'u' + $Matches[1]
    $nombre = $Matches[2]
    if ($nombre -match '^clase-(\d+)-.*-anexo-docente\.md$') { return @{ tipo = 'clase-anexo'; unidad = $unidad; n = [int]$Matches[1] } }
    if ($nombre -match '^clase-(\d+)-[^.]+\.md$') { return @{ tipo = 'clase'; unidad = $unidad; n = [int]$Matches[1] } }
    if ($nombre -match '^evaluacion-u\d+-version-([a-z])-anexo-docente\.md$') { return @{ tipo = 'evaluacion-version-anexo'; unidad = $unidad; letra = $Matches[1] } }
    if ($nombre -match '^evaluacion-u\d+-version-([a-z])\.md$') { return @{ tipo = 'evaluacion-version'; unidad = $unidad; letra = $Matches[1] } }
    if ($nombre -match '^evaluacion-u\d+\.md$') { return @{ tipo = 'evaluacion-unidad'; unidad = $unidad } }
    return @{ tipo = 'otros' }
  }

  if ($rel -match '^03-encuadre-y-cierres/encuadre-(\d+)-[^/]+\.md$') { return @{ tipo = 'encuadre'; n = [int]$Matches[1] } }
  if ($rel -match '^03-encuadre-y-cierres/cierre-(\d+)-cuatrimestre-(\d+)\.md$') { return @{ tipo = 'cierre-cuatrimestre'; n = [int]$Matches[1]; k = [int]$Matches[2] } }
  if ($rel -match '^03-encuadre-y-cierres/cierre-(\d+)-integral\.md$') { return @{ tipo = 'cierre-integral'; n = [int]$Matches[1] } }
  if ($rel -match '^03-encuadre-y-cierres/') { return @{ tipo = 'otros' } }

  if ($rel -match '^04-intensificaciones/evaluaciones/evaluacion-intensificaciones-(.+)-version-([a-z])-anexo-docente\.md$') { return @{ tipo = 'intens-evaluacion-version-anexo'; clave = $Matches[1]; letra = $Matches[2] } }
  if ($rel -match '^04-intensificaciones/evaluaciones/evaluacion-intensificaciones-(.+)-version-([a-z])\.md$') { return @{ tipo = 'intens-evaluacion-version'; clave = $Matches[1]; letra = $Matches[2] } }
  if ($rel -match '^04-intensificaciones/evaluaciones/evaluacion-intensificaciones-(.+)\.md$') { return @{ tipo = 'intens-evaluacion-base'; clave = $Matches[1] } }
  if ($rel -match '^04-intensificaciones/evaluaciones/') { return @{ tipo = 'otros' } }
  if ($rel -match '^04-intensificaciones/intensificaciones-(.+)\.md$') {
    $resto = $Matches[1]
    if ($resto -match '^(\d{2})-(\d{2})-(.+)$') { return @{ tipo = 'intensificacion-doc'; clave = $Matches[1] + '-' + $Matches[2]; rangoA = [int]$Matches[1]; rangoB = [int]$Matches[2]; slug = $Matches[3] } }
    if ($resto -match '^([a-z]+)-') { return @{ tipo = 'intensificacion-doc'; clave = $Matches[1]; slug = $Matches[1] } }
    if ($resto -match '^([a-z]+)$') { return @{ tipo = 'intensificacion-doc'; clave = $Matches[1]; slug = $Matches[1] } }
    return @{ tipo = 'otros' }
  }
  if ($rel -match '^04-intensificaciones/') { return @{ tipo = 'otros' } }

  if ($rel -match '^05-continuidad/continuidad-(\d+)-(.+)-anexo-docente\.md$') { return @{ tipo = 'continuidad-anexo'; i = [int]$Matches[1]; slug = $Matches[2] } }
  if ($rel -match '^05-continuidad/continuidad-(\d+)-(.+)\.md$') { return @{ tipo = 'continuidad'; i = [int]$Matches[1]; slug = $Matches[2] } }
  if ($rel -match '^05-continuidad/') { return @{ tipo = 'otros' } }

  if ($rel -match '^06-aprobacion/criterios-aprobacion\.md$') { return @{ tipo = 'criterios' } }
  return @{ tipo = 'otros' }
}

$porTipo = @{}
$totalIndexados = 0
foreach ($a in $archivos) {
  $c = Get-Clasificacion $a.rel
  if ($null -eq $c) { continue }
  $c.rel = $a.rel
  $t = $c.tipo
  if (-not $porTipo.ContainsKey($t)) { $porTipo[$t] = New-Object System.Collections.Generic.List[object] }
  [void]$porTipo[$t].Add($c)
  $totalIndexados = $totalIndexados + 1
}

function Get-Lista([string]$tipo) {
  if ($porTipo.ContainsKey($tipo)) { return $porTipo[$tipo].ToArray() }
  return @()
}
function Get-Primero([string]$tipo) {
  $l = @(Get-Lista $tipo)
  if ($l.Count -gt 0) { return $l[0] }
  return $null
}

# La hoja de convenciones vive con la materia (input/materias/<m>/), fuera del corpus
# generado: si el arbol del curso no la clasifica pero existe en la carpeta de materia,
# se indexa con link relativo al README del curso (../../input/materias/<m>/...).
$rutaConvMateria = Join-Path $Materia 'convenciones-tecnicas.md'
if ((-not $porTipo.ContainsKey('convenciones')) -and (Test-Path -LiteralPath $rutaConvMateria)) {
  $relConv = '../../' + $materiaNorm + '/convenciones-tecnicas.md'
  $porTipo['convenciones'] = New-Object System.Collections.Generic.List[object]
  [void]$porTipo['convenciones'].Add(@{ tipo = 'convenciones'; rel = $relConv })
  $totalIndexados = $totalIndexados + 1
}

# --- Sección 2: índice completo del corpus ---
$li = New-Object System.Collections.Generic.List[string]
$script:nSub = 0
function Add-Indice([string]$linea) { $script:li.Add($linea) }
function Add-Subtitulo([string]$titulo) {
  $script:nSub = $script:nSub + 1
  Add-Indice ('### 2.' + $script:nSub + ' ' + $titulo)
  Add-Indice ''
}
function Add-Tabla2([object[]]$filas) {
  Add-Indice '| Documento | Qué es y cuándo se usa |'
  Add-Indice '| --- | --- |'
  foreach ($f in $filas) { Add-Indice $f }
  Add-Indice ''
}

Add-Indice (Get-Seccion 'indice')
Add-Indice ''

# 2.x Raíz del corpus — canon técnico
if (Get-Primero 'convenciones') {
  $c = Get-Primero 'convenciones'
  Add-Subtitulo 'Canon técnico — hoja de convenciones'
  $d = Expand-Plantilla (Get-DescripcionTipo 'convenciones' 'descripcion') $slotsGlobales "convenciones ($($c.rel))"
  Add-Tabla2 @('| [' + (Split-Path -Leaf $c.rel) + '](' + $c.rel + ') | ' + $d + ' |')
}

# 2.x Carpeta 01-planificacion — documentos administrativos (CSV derivados)
if ((Get-Primero 'anual') -or (Get-Primero 'libro1') -or (Get-Primero 'libro2')) {
  Add-Subtitulo 'Carpeta `01-planificacion/` — documentos administrativos'
  $filas = @()
  foreach ($t in @('anual', 'libro1', 'libro2')) {
    $c = Get-Primero $t
    if ($null -ne $c) {
      $d = Expand-Plantilla (Get-DescripcionTipo $t 'descripcion') $slotsGlobales "$t ($($c.rel))"
      $filas += '| [' + $c.rel + '](' + $c.rel + ') | ' + $d + ' |'
    }
  }
  Add-Tabla2 $filas
}

# 2.x Carpeta 02-unidades — una subsección por unidad, con tabla de clases y evaluación
$unidadesArbol = @()
$carpetaUnidad = @{}
foreach ($t in @('clase', 'clase-anexo', 'evaluacion-unidad', 'evaluacion-version', 'evaluacion-version-anexo')) {
  foreach ($c in @(Get-Lista $t)) {
    if ($unidadesArbol -notcontains $c.unidad) { $unidadesArbol += $c.unidad }
    $partes = $c.rel.Split('/')
    $carpetaUnidad[$c.unidad] = $partes[1]
  }
}
$unidadesArbol = @($unidadesArbol | Sort-Object)

if ($unidadesArbol.Count -gt 0) {
  Add-Subtitulo 'Carpeta `02-unidades/` — unidades didácticas y sus evaluaciones'
  Add-Indice (Get-Seccion 'unidades')
  Add-Indice ''
  foreach ($u in $unidadesArbol) {
    $desde = 0
    foreach ($e in $encuentrosPorUnidad[$u]) { if ($desde -eq 0 -or [int]$e.n -lt $desde) { $desde = [int]$e.n } }
    $hasta = Get-EvalN $u
    Add-Indice ('#### ' + (Get-DenominacionUnidad $u) + ' (`' + $carpetaUnidad[$u] + '/`, encuentros ' + $desde + ' a ' + $hasta + ')')
    Add-Indice ''
    Add-Indice '| Encuentro | Documento del alumno | Qué trabajó | Anexo docente (solo docente) |'
    Add-Indice '| --- | --- | --- | --- |'

    $nsCubiertos = @()
    foreach ($e in $encuentrosPorUnidad[$u]) {
      $n = [int]$e.n
      $base = @(Get-Lista 'clase' | Where-Object { $_.unidad -eq $u -and $_.n -eq $n })
      $anexo = @(Get-Lista 'clase-anexo' | Where-Object { $_.unidad -eq $u -and $_.n -eq $n })
      if ($base.Count -eq 0 -and $anexo.Count -eq 0) { continue }
      $nsCubiertos += $n
      $descClase = Expand-Plantilla (Get-DescripcionTipo 'clase' 'descripcion') (New-FilaSlots @{
          n         = $n
          tema      = [string]$e.tema
          contenido = (Upper-Primera ([string]$e.contenido))
        }) "clase ($u, encuentro $n)"
      if (-not $descClase.EndsWith('.')) { $descClase = $descClase + '.' }
      $celdaDoc = '—'
      if ($base.Count -gt 0) { $celdaDoc = '[' + (Split-Path -Leaf $base[0].rel) + '](' + $base[0].rel + ')' }
      $celdaAnexo = '—'
      if ($anexo.Count -gt 0) { $celdaAnexo = '[anexo clase ' + $n + '](' + $anexo[0].rel + ')' }
      Add-Indice ('| ' + $n + ' | ' + $celdaDoc + ' | ' + $descClase + ' | ' + $celdaAnexo + ' |')
    }

    # Archivos de clase presentes en el árbol sin dato asociado en el curso-data: error duro.
    foreach ($t in @('clase', 'clase-anexo')) {
      foreach ($c in @(Get-Lista $t)) {
        if ($c.unidad -eq $u -and ($nsCubiertos -notcontains [int]$c.n)) {
          Write-Output "ERROR: archivo de clase sin dato en el curso-data: $($c.rel)"
          exit 1
        }
      }
    }

    # Evaluación de la unidad: documento base primero y versiones equivalentes con sus anexos.
    $evBase = @(Get-Lista 'evaluacion-unidad' | Where-Object { $_.unidad -eq $u })
    $versiones = @(Get-Lista 'evaluacion-version' | Where-Object { $_.unidad -eq $u } | Sort-Object { $_.letra })
    if ($evBase.Count -gt 0) {
      $d = Expand-Plantilla (Get-DescripcionTipo 'evaluacion-unidad' 'descripcion') (New-FilaSlots @{
          n             = $hasta
          unidadNombre  = (Get-NombreUnidad $u)
          'unidad.denominacion' = (Get-DenominacionUnidad $u)
        }) "evaluacion-unidad ($($evBase[0].rel))"
      Add-Indice ('| ' + $hasta + ' | [' + (Split-Path -Leaf $evBase[0].rel) + '](' + $evBase[0].rel + ') | ' + $d + ' | — |')
    }
    if ($versiones.Count -gt 0) {
      $celdaVersiones = @()
      $celdaAnexos = @()
      foreach ($v in $versiones) {
        $L = $v.letra.ToUpper()
        $celdaVersiones += '[' + (Split-Path -Leaf $v.rel) + '](' + $v.rel + ')'
        $anexoV = @(Get-Lista 'evaluacion-version-anexo' | Where-Object { $_.unidad -eq $u -and $_.letra -eq $v.letra })
        if ($anexoV.Count -gt 0) { $celdaAnexos += ('[anexo versión ' + $L + '](' + $anexoV[0].rel + ')') }
      }
      $d = Expand-Plantilla (Get-DescripcionTipo 'evaluacion-version' 'descripcion') (New-FilaSlots @{ unidadNombre = (Get-NombreUnidad $u) }) "evaluacion-version ($u)"
      $celdaAnexoFin = '—'
      if ($celdaAnexos.Count -gt 0) { $celdaAnexoFin = $celdaAnexos -join ' · ' }
      Add-Indice ('| ' + $hasta + ' | ' + ($celdaVersiones -join ' · ') + ' | ' + $d + ' | ' + $celdaAnexoFin + ' |')
    }
    Add-Indice ''
  }
}

# 2.x Carpeta 03-encuadre-y-cierres
$cierres = @()
foreach ($c in @(Get-Lista 'encuadre')) { $cierres += @{ c = $c; w = 0; n = 0 } }
foreach ($c in @(Get-Lista 'cierre-cuatrimestre')) { $cierres += @{ c = $c; w = 1; n = [int]$c.n } }
foreach ($c in @(Get-Lista 'cierre-integral')) { $cierres += @{ c = $c; w = 1; n = [int]$c.n } }
$cierres = @($cierres | Sort-Object { $_.w }, { $_.n })
if ($cierres.Count -gt 0) {
  Add-Subtitulo 'Carpeta `03-encuadre-y-cierres/` — encuadre y cierres del ciclo anual'
  Add-Indice (Get-Seccion 'encuadre')
  Add-Indice ''
  $filas = @()
  foreach ($item in $cierres) {
    $c = $item.c
    $f = New-FilaSlots @{ n = [int]$c.n; k = $(if ($null -ne $c.k) { [int]$c.k } else { 0 }) }
    $d = Expand-Plantilla (Get-DescripcionTipo $c.tipo 'descripcion') $f "$($c.tipo) ($($c.rel))"
    $filas += '| [' + (Split-Path -Leaf $c.rel) + '](' + $c.rel + ') | ' + $d + ' |'
  }
  Add-Tabla2 $filas
}

# 2.x Carpeta 04-intensificaciones — momentos y sus evaluaciones
$momentos = @()
foreach ($m in @(Get-Lista 'intensificacion-doc')) {
  if ($null -ne $m.rangoA) {
    $m.momentoTitulo = Get-TituloSlug $m.slug
    $m.alcance = ' (encuentros ' + [int]$m.rangoA + '-' + [int]$m.rangoB + ')'
    $m.orden = '{0:d4}' -f [int]$m.rangoA
  } else {
    $m.momentoTitulo = Upper-Primera $m.clave
    $m.alcance = ' (fuera de la planificación anual)'
    $m.orden = '9999-' + $m.clave
  }
  $momentos += $m
}
$momentos = @($momentos | Sort-Object { $_.orden })
$intensEvals = @{}
foreach ($t in @('intens-evaluacion-base', 'intens-evaluacion-version', 'intens-evaluacion-anexo', 'intens-evaluacion-version-anexo')) {
  foreach ($c in @(Get-Lista $t)) {
    if (-not $intensEvals.ContainsKey($c.clave)) {
      $intensEvals[$c.clave] = @{ bases = @(); versiones = @(); anexosBase = @(); anexosVersion = @{} }
    }
    $g = $intensEvals[$c.clave]
    if ($t -eq 'intens-evaluacion-base') { $g.bases += $c }
    elseif ($t -eq 'intens-evaluacion-version') { $g.versiones += $c }
    elseif ($t -eq 'intens-evaluacion-anexo') { $g.anexosBase += $c }
    else { $g.anexosVersion[$c.letra] = $c }
  }
}
if ($momentos.Count -gt 0 -or $intensEvals.Count -gt 0) {
  Add-Subtitulo 'Carpeta `04-intensificaciones/` — momentos de intensificación y fortalecimiento y sus evaluaciones'
  Add-Indice (Get-Seccion 'intensificaciones')
  Add-Indice ''
  Add-Indice '| Momento | Documento del momento | Evaluaciones (subcarpeta `evaluaciones/`) |'
  Add-Indice '| --- | --- | --- |'
  $claves = @($momentos | ForEach-Object { $_.clave })
  foreach ($k in $intensEvals.Keys) { if ($claves -notcontains $k) { $claves += $k } }
  $claves = @($claves | Sort-Object)
  foreach ($k in $claves) {
    $m = $null
    foreach ($cand in $momentos) { if ($cand.clave -eq $k) { $m = $cand } }
    $celdaMomento = $k + ' (momento sin documento)'
    $celdaDoc = '—'
    if ($null -ne $m) {
      $celdaMomento = $m.momentoTitulo + $m.alcance
      $celdaDoc = '[' + (Split-Path -Leaf $m.rel) + '](' + $m.rel + ')'
    }
    $celdaEvals = '—'
    if ($intensEvals.ContainsKey($k)) {
      $g = $intensEvals[$k]
      $partes = @()
      foreach ($b in @($g.bases | Sort-Object { $_.rel })) { $partes += '[base](' + $b.rel + ')' }
      foreach ($v in @($g.versiones | Sort-Object { $_.letra })) {
        $L = $v.letra.ToUpper()
        $partes += '[versión ' + $L + '](' + $v.rel + ')'
        if ($g.anexosVersion.ContainsKey($v.letra)) { $partes += '[anexo ' + $L + '](' + $g.anexosVersion[$v.letra].rel + ')' }
      }
      foreach ($a in @($g.anexosBase | Sort-Object { $_.rel })) { $partes += '[anexo docente](' + $a.rel + ')' }
      if ($partes.Count -gt 0) { $celdaEvals = $partes -join ' · ' }
    }
    Add-Indice ('| ' + $celdaMomento + ' | ' + $celdaDoc + ' | ' + $celdaEvals + ' |')
  }
  Add-Indice ''
  $secCierre = Get-Seccion 'intensificacionesCierre'
  if ($secCierre -ne '') { Add-Indice $secCierre; Add-Indice '' }
}

# 2.x Carpeta 05-continuidad
$conts = @(Get-Lista 'continuidad' | Sort-Object { $_.i })
if ($conts.Count -gt 0) {
  Add-Subtitulo 'Carpeta `05-continuidad/` — continuidad pedagógica'
  Add-Indice (Get-Seccion 'continuidad')
  Add-Indice ''
  Add-Indice '| Documento | Qué es y cuándo se usa | Anexo docente (solo docente) |'
  Add-Indice '| --- | --- | --- |'
  $total = $conts.Count
  foreach ($c in $conts) {
    if ($c.slug -eq 'saberes-previos') { $alcance = 'repaso de saberes previos antes de la primera unidad didáctica' }
    elseif ($c.slug -match '^tras-evaluacion-u(\d+)$') { $alcance = 'repaso de los contenidos trabajados hasta la evaluación de la Unidad ' + $Matches[1] }
    else { $alcance = 'actividades de repaso y fijación de contenidos' }
    $d = Expand-Plantilla (Get-DescripcionTipo 'continuidad' 'descripcion') (New-FilaSlots @{ i = [int]$c.i; total = $total; alcance = $alcance }) "continuidad ($($c.rel))"
    $anexo = @(Get-Lista 'continuidad-anexo' | Where-Object { $_.i -eq $c.i })
    $celdaAnexo = '—'
    if ($anexo.Count -gt 0) { $celdaAnexo = '[anexo continuidad ' + [int]$c.i + '](' + $anexo[0].rel + ')' }
    Add-Indice ('| [' + (Split-Path -Leaf $c.rel) + '](' + $c.rel + ') | ' + $d + ' | ' + $celdaAnexo + ' |')
  }
  Add-Indice ''
}

# 2.x Carpeta 06-aprobacion
if (Get-Primero 'criterios') {
  $c = Get-Primero 'criterios'
  Add-Subtitulo 'Carpeta `06-aprobacion/` — criterios de aprobación'
  $d = Expand-Plantilla (Get-DescripcionTipo 'criterios' 'descripcion') $slotsGlobales "criterios ($($c.rel))"
  Add-Tabla2 @('| [' + $c.rel + '](' + $c.rel + ') | ' + $d + ' |')
}

# 2.x Otros documentos (archivos no reconocidos: nunca se descartan en silencio)
$otros = @(Get-Lista 'otros' | Sort-Object { $_.rel })
if ($otros.Count -gt 0) {
  Add-Subtitulo 'Otros documentos'
  Add-Indice (Get-Seccion 'otros')
  Add-Indice ''
  $filas = @()
  foreach ($c in $otros) {
    $d = Expand-Plantilla (Get-DescripcionTipo 'otros' 'descripcion') $slotsGlobales "otros ($($c.rel))"
    $filas += '| [' + $c.rel + '](' + $c.rel + ') | ' + $d + ' |'
  }
  Add-Tabla2 $filas
}

$indiceTxt = ($li -join "`n").TrimEnd()

# --- Sección 3: orden de creación de los documentos (derivado del mismo árbol) ---
$lo = New-Object System.Collections.Generic.List[string]
$script:nItem = 0
function Add-Orden([string]$linea) {
  $script:nItem = $script:nItem + 1
  $script:lo.Add([string]$script:nItem + '. ' + $linea)
}
function Link-Md([string]$texto, [string]$rel) { return '[' + $texto + '](' + $rel + ')' }

$lo.Add((Get-Seccion 'orden'))
$lo.Add('')

# 1) Canon técnico (y mapa maestro del encargo, fuera del corpus).
$cConv = Get-Primero 'convenciones'
if ($null -ne $cConv) {
  Add-Orden ('**Mapa maestro del encargo** (fuera del corpus, en el repositorio de planificación) y hoja de canon técnico: ' + (Link-Md (Split-Path -Leaf $cConv.rel) $cConv.rel) + '.')
}
# 2) Anual y libros de aula (renders deterministas de la firma pedagógica).
$cAnual = Get-Primero 'anual'
if ($null -ne $cAnual) {
  $linea = '**Planificación anual**, documento madre (render determinista de la firma pedagógica `' + $slotsGlobales['rutaData'] + '` mediante `' + $slotsGlobales['rutaTool'] + '`): ' + (Link-Md $cAnual.rel $cAnual.rel)
  $libros = @()
  foreach ($t in @('libro1', 'libro2')) {
    $c = Get-Primero $t
    if ($null -ne $c) { $libros += (Link-Md $c.rel $c.rel) }
  }
  if ($libros.Count -gt 0) { $linea = $linea + '; y **libro de aula**, derivado directo de la anual: ' + ($libros -join ', ') }
  Add-Orden ($linea + '.')
}
# 3) Encuadre del ciclo.
$cEnc = Get-Primero 'encuadre'
if ($null -ne $cEnc) {
  Add-Orden ('**Encuadre del ciclo**: ' + (Link-Md (Split-Path -Leaf $cEnc.rel) $cEnc.rel) + '.')
}
# 4) Momentos de saberes previos (previos a la primera unidad).
foreach ($m in $momentos) {
  if ($null -ne $m.rangoA -and [int]$m.rangoA -lt $minEncuentro) {
    Add-Orden ('**' + $m.momentoTitulo + '** (momento de intensificación previo a las unidades): ' + (Link-Md (Split-Path -Leaf $m.rel) $m.rel) + ', con su evaluación en `04-intensificaciones/evaluaciones/`.')
  }
}
# 5) Clases de las unidades didácticas, con sus anexos docentes.
foreach ($u in $unidadesArbol) {
  $clases = @(Get-Lista 'clase' | Where-Object { $_.unidad -eq $u } | Sort-Object { $_.n })
  if ($clases.Count -eq 0) { continue }
  $links = @()
  foreach ($c in $clases) {
    $texto = Split-Path -Leaf $c.rel
    if ($texto -match '^(clase-\d+)') { $texto = $Matches[1] }
    $links += (Link-Md $texto $c.rel)
  }
  $denom = (Get-DenominacionUnidad $u) -replace ':', ' —'
  Add-Orden ('**' + $denom + '** (encuentros ' + [int]$clases[0].n + ' a ' + [int]$clases[$clases.Count - 1].n + '), cada clase con su anexo docente: ' + ($links -join ', ') + '.')
}
# 6) Evaluaciones de unidad (base, versiones equivalentes y anexos en la carpeta de cada unidad).
$evs = @()
foreach ($u in $unidadesArbol) {
  $ev = @(Get-Lista 'evaluacion-unidad' | Where-Object { $_.unidad -eq $u })
  foreach ($c in $ev) {
    $texto = Split-Path -Leaf $c.rel
    if ($texto -match '^(evaluacion-u\d+)\.md$') { $texto = $Matches[1] }
    $evs += (Link-Md $texto $c.rel)
  }
}
if ($evs.Count -gt 0) {
  Add-Orden ('**Evaluaciones de unidad** (documento base, versiones equivalentes y anexos docentes en la carpeta de cada unidad): ' + ($evs -join ', ') + '.')
}
# 7) Cierres del ciclo.
$linksCierres = @()
foreach ($item in $cierres) {
  if ($item.w -eq 1) { $linksCierres += (Link-Md (Split-Path -Leaf $item.c.rel) $item.c.rel) }
}
if ($linksCierres.Count -gt 0) {
  Add-Orden ('**Cierres del ciclo**: ' + ($linksCierres -join ', ') + '.')
}
# 8) Momentos de intensificación del ciclo y de diciembre y marzo, con sus evaluaciones.
$linksIntens = @()
foreach ($m in $momentos) {
  if ($null -ne $m.rangoA -and [int]$m.rangoA -lt $minEncuentro) { continue }
  $linksIntens += (Link-Md (Split-Path -Leaf $m.rel) $m.rel)
}
if ($linksIntens.Count -gt 0) {
  Add-Orden ('**Momentos de intensificación y fortalecimiento** del ciclo y de diciembre y marzo (cada uno con su evaluación —base, versiones equivalentes y anexos docentes— en `04-intensificaciones/evaluaciones/`): ' + ($linksIntens -join ', ') + '.')
}
# 9) Continuidad pedagógica.
if ($conts.Count -gt 0) {
  $linksCont = @()
  foreach ($c in $conts) { $linksCont += (Link-Md (Split-Path -Leaf $c.rel) $c.rel) }
  Add-Orden ('**Continuidad pedagógica** (con anexos docentes): ' + ($linksCont -join ', ') + '.')
}
# 10) Criterios de aprobación.
$cCrit = Get-Primero 'criterios'
if ($null -ne $cCrit) {
  Add-Orden ('**Criterios de aprobación**: ' + (Link-Md $cCrit.rel $cCrit.rel) + '.')
}
# 11) README índice.
Add-Orden ('**README índice**: este documento, generado con `' + $slotsGlobales['rutaReadmeTool'] + '` a partir del árbol del corpus y de la firma pedagógica (`' + $slotsGlobales['rutaData'] + '`).')

$ordenTxt = ($lo -join "`n").TrimEnd()

# --- Nota de la cátedra (prosa manual por materia, fuera de toda plantilla) ---
$notaTxt = ''
$rutaNota = Join-Path $raiz ('input\materias\' + (Split-Path $Materia -Leaf) + '\nota-catedra.md')
if (Test-Path -LiteralPath $rutaNota) {
  $notaTxt = '---' + "`n`n" + '## Nota de la cátedra' + "`n`n" + (Read-Texto $rutaNota).Trim() + "`n"
}

# --- Composición final ---
$contenido = Expand-Plantilla $plantilla $slotsGlobales 'input/plantillas/readme-plantilla.md'
$contenido = $contenido.Replace('{{INDICE}}', $indiceTxt)
$contenido = $contenido.Replace('{{ORDEN}}', $ordenTxt)
$contenido = $contenido.Replace('{{NOTA_CATEDRA}}', $notaTxt)

$resto = [regex]::Matches($contenido, $patronSlots)
if ($resto.Count -gt 0) {
  $claves = @($resto | ForEach-Object { $_.Groups[1].Value.Trim() } | Select-Object -Unique)
  Write-Output ("ERROR: slots sin resolver en la salida: " + ($claves -join ', '))
  exit 1
}

$contenido = $contenido.TrimEnd("`n") + "`n"

if ($Salida -eq '') { $Salida = Join-Path $rutaCursoAbs 'README.md' }
if ([System.IO.Path]::IsPathRooted($Salida)) {
  $salidaAbs = $Salida
} else {
  $salidaAbs = Join-Path (Get-Location).Path $Salida
}
if ((Test-Path -LiteralPath $salidaAbs) -and -not $Force) {
  Write-Output "ERROR: la salida ya existe (use -Force para sobrescribir): $salidaAbs"
  exit 1
}
[System.IO.File]::WriteAllText($salidaAbs, $contenido, (New-Object System.Text.UTF8Encoding($false)))

Write-Output "README generado: $salidaAbs ($totalIndexados documentos indexados)"
exit 0
