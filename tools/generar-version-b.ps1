# generar-version-b.ps1 — Genera versiones equivalentes (B/C/D) desde una versión A, por tabla de dominio
#
# ESTRUCTURA DE LA TABLA (plantillas\tabla-dominio.json):
#   dominios.<instancia> — una entrada por instancia del curso: p. ej. "u1" para la mini API
#   en memoria de la Unidad 1, "u2" para hospital.db de la Unidad 2 en adelante, "general"
#   para tokens comunes a varias instancias. El generador consolida TODAS las instancias en
#   un solo pase: los tokens A deben ser únicos en TODA la tabla (repetidos entre instancias
#   es defecto de la tabla). Cada instancia declara:
#     descripcion : qué dominio es y qué representa cada letra.
#     vocabulario : palabras del dominio SIN fila de mapeo (quedan intactas); si aparecen en
#                   la base y parecen sustantivos de dominio, se informan como AVISO al docente.
#     grupos      : una fila por token del dominio: { "A": <token base>, "B": ..., "C": ..., "D": ... }.
#                   Cada letra generada usa SU fila (B->B, C->C, D->D). Las filas B/C/D deben
#                   ser distintas entre sí y distintas de A; si a una letra pedida le falta la
#                   fila de un token presente en la base, es ERROR (no se recicla otra fila).
#
# SUSTITUCIÓN: palabra completa, insensible a mayúsculas, preservando el patrón de caja del
# token hallado A NIVEL DE PALABRA: TODO MAYÚSCULAS -> TODO MAYÚSCULAS (tickets -> BOOKS);
# inicia en mayúscula (PascalCase: TicketId) -> reemplazo con inicial mayúscula (BookId);
# minúsculas o camelCase (ticketId, nextTicketId) -> caja canónica del reemplazo (bookId,
# nextBookId). Todo en UNA sola pasada (un reemplazo nunca se remapea) con alternancia de
# mayor a menor longitud (nextTicketId nunca es partido por ticketId). Genera SOLO las
# letras pedidas.
#
# CHECKLIST DE EQUIVALENCIA (determinista), base vs. cada versión generada:
#   - filas de consignas en secciones "Parte N" (tablas del formato real del corpus),
#   - ítems de lista en secciones "Antes de empezar" / "requisito",
#   - fences de código y headings de sección.
#   Un contador en 0 en LA BASE Y en la versión se marca SUSPECT: la igualdad vacía (0 = 0)
#   no cuenta como PASS.
#
# ERRORES DUROS:
#   exit 1: base o tabla faltante, JSON inválido, letra inválida, token duplicado en la tabla,
#           filas B/C/D repetidas o iguales a A, fila faltante para un token presente en la
#           base, checklist de equivalencia FAIL.
#   exit 2: guarda anti-copia silenciosa: la versión generada sería idéntica byte a byte a la
#           base. Se lista cada token mapeado buscado y sus ocurrencias; nunca se copia en
#           silencio.
#
# Uso (desde la raíz del repositorio):
#   powershell -File tools\generar-version-b.ps1 -Base <carpeta>\evaluacion-uN-version-a.md -Salida <carpeta> [-Letras B,C] [-Tabla plantillas\tabla-dominio.json]
#
# Parametros:
#   -Base    (obligatorio) ruta del documento versión A (fuente de la sustitución).
#   -Salida  carpeta destino (se crea si no existe).
#   -Letras  letras a generar: subset de B, C, D (por defecto B).
#   -Tabla   ruta de la tabla de dominio (por defecto plantillas\tabla-dominio.json).
#
# Salida: <nombre-sin-extensión>-version-<letra>.md por cada letra (la extensión -version-a del
# nombre se reemplaza; si no existe, se agrega el sufijo).

param(
  [string]$Base,
  [string]$Salida,
  [string[]]$Letras,
  [string]$Tabla
)

$ErrorActionPreference = 'Stop'

# Valores por defecto (fuera del bloque param: en PS 5.1 un parámetro omitido llega en $null)
if ($null -eq $Letras -or $Letras.Count -eq 0) { $Letras = @('B') }
if ($null -eq $Salida -or $Salida -eq '') { $Salida = '.' }

if ($null -eq $Base -or $Base -eq '') {
  Write-Output 'ERROR: falta -Base <ruta del documento versión A>'
  exit 1
}
if (-not (Test-Path -LiteralPath $Base)) {
  Write-Output "ERROR: no se encontro la base: $Base"
  exit 1
}

# La raiz del repositorio es la carpeta padre de tools\ (donde vive este script).
$raiz = Split-Path -Parent $PSScriptRoot
if ($null -eq $Tabla -or $Tabla -eq '') { $Tabla = Join-Path $raiz 'plantillas\tabla-dominio.json' }
if (-not (Test-Path -LiteralPath $Tabla)) {
  Write-Output "ERROR: no se encontro la tabla de dominio: $Tabla"
  exit 1
}

# --- Letras válidas ---
# -Letras B,C llega como un único string cuando se invoca con comas: se separa aquí.
# Nota: las variables NO se llaman igual que los parámetros ($letras/$tabla chocabarían con
# $Letras/$Tabla): en PowerShell 5.1 asignar a un nombre que colisiona con un parámetro
# declarado hace que el resultado de un pipeline del lado derecho no quede en la variable.
$letrasPedidas = @()
if ($Letras.Count -eq 1 -and "$($Letras[0])" -match ',') {
  $letrasPedidas = @( "$($Letras[0])" -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' } )
} else {
  $letrasPedidas = @($Letras | ForEach-Object { "$_".Trim() } | Where-Object { $_ -ne '' })
}
$letrasValidas = @('B', 'C', 'D')
foreach ($letra in $letrasPedidas) {
  if ($letrasValidas -notcontains $letra.ToUpperInvariant()) {
    Write-Output "ERROR: letra inválida '$letra' (valores: B, C, D)"
    exit 1
  }
}
$letrasPedidas = @($letrasPedidas | ForEach-Object { $_.ToUpperInvariant() })

try {
  $textoBase = [System.IO.File]::ReadAllText((Resolve-Path -LiteralPath $Base).Path)
  $textoTabla = [System.IO.File]::ReadAllText((Resolve-Path -LiteralPath $Tabla).Path)
  $datosTabla = ConvertFrom-Json -InputObject $textoTabla
} catch {
  Write-Output "ERROR: lectura/JSON invalido: $($_.Exception.Message)"
  exit 1
}

# --- Aplanado de la tabla: grupos de todas las instancias con mapa letra -> token ---
# Clave única por token (insensible a mayúsculas): duplicados son defecto de la tabla.
$mapaGrupos = @{}
$ordenTokens = @()
if ($null -ne $datosTabla -and $null -ne $datosTabla.dominios) {
  foreach ($dom in $datosTabla.dominios.PSObject.Properties) {
    foreach ($g in @($dom.Value.grupos)) {
      $tokenA = "$($g.A)"
      if ($tokenA -eq '') {
        Write-Output "ERROR: grupo sin token A en la instancia '$($dom.Name)'"
        exit 1
      }
      $clave = $tokenA.ToLowerInvariant()
      if ($mapaGrupos.ContainsKey($clave)) {
        Write-Output "ERROR: token duplicado en la tabla de dominio: '$tokenA' (instancias '$($mapaGrupos[$clave].dominio)' y '$($dom.Name)')"
        exit 1
      }
      $mapa = @{}
      foreach ($prop in @($g.PSObject.Properties)) {
        $letraFila = $prop.Name.ToUpperInvariant()
        if (($letraFila -eq 'B' -or $letraFila -eq 'C' -or $letraFila -eq 'D') -and "$($prop.Value)" -ne '') {
          $valorFila = "$($prop.Value)"
          if ($valorFila.ToLowerInvariant() -eq $clave) {
            Write-Output "ERROR: el grupo '$tokenA' mapea $letraFila al mismo token de A ('${tokenA}'); la versión no cambiaría nada"
            exit 1
          }
          foreach ($previa in $mapa.Values) {
            if ("$previa".ToLowerInvariant() -eq $valorFila.ToLowerInvariant()) {
              Write-Output "ERROR: el grupo '$tokenA' repite la fila '$valorFila' para dos letras; las versiones deben diferir"
              exit 1
            }
          }
          $mapa[$letraFila] = $valorFila
        }
      }
      if ($mapa.Count -eq 0) {
        Write-Output "ERROR: el grupo '$tokenA' no declara ningún equivalente (B/C/D) en la instancia '$($dom.Name)'"
        exit 1
      }
      $mapaGrupos[$clave] = @{ dominio = $dom.Name; mapa = $mapa }
      $ordenTokens += $tokenA
    }
  }
}

# Vocabulario consolidado (palabras del dominio sin fila: solo avisan)
$vocabulario = @()
if ($null -ne $datosTabla -and $null -ne $datosTabla.dominios) {
  foreach ($dom in $datosTabla.dominios.PSObject.Properties) {
    foreach ($v in @($dom.Value.vocabulario)) { if ("$v" -ne '') { $vocabulario += "$v" } }
  }
}

# --- Regex de una pasada: alternancia por longitud descendente, palabra completa, sin mayúsculas ---
$patron = ($ordenTokens |
  Sort-Object -Property @{ Expression = { $_.Length }; Descending = $true } |
  ForEach-Object { [regex]::Escape($_) }) -join '|'
$opciones = [System.Text.RegularExpressions.RegexOptions]::IgnoreCase -bor [System.Text.RegularExpressions.RegexOptions]::CultureInvariant
$regex = New-Object System.Text.RegularExpressions.Regex("\b(?:$patron)\b", $opciones)

# --- Pre-escaneo de la base: ocurrencias por token (diagnóstico y control de filas faltantes) ---
$conteosToken = @{}
foreach ($m in $regex.Matches($textoBase)) {
  $claveMatch = $m.Value.ToLowerInvariant()
  if ($claveMatch -eq '') { continue }
  if ($conteosToken.ContainsKey($claveMatch)) { $conteosToken[$claveMatch]++ } else { $conteosToken[$claveMatch] = 1 }
}
$totalOcurrencias = 0
foreach ($c in $conteosToken.Values) { $totalOcurrencias += [int]$c }

# Preserva el patrón de caja del token hallado a nivel de palabra: TODO MAYÚSCULAS se
# vuelve TODO MAYÚSCULAS; si inicia en mayúscula (PascalCase), el reemplazo toma inicial
# mayúscula; minúsculas o camelCase conservan la caja canónica del reemplazo.
function Convert-Caja([string]$hallado, [string]$reemplazo) {
  if ($hallado -ceq $hallado.ToUpperInvariant()) { return $reemplazo.ToUpperInvariant() }
  $inicial = $hallado.Substring(0, 1)
  if ($inicial -ceq $inicial.ToUpperInvariant()) {
    return $reemplazo.Substring(0, 1).ToUpperInvariant() + $reemplazo.Substring(1)
  }
  return $reemplazo
}

# --- Checklist determinista: cantidades que deben ser idénticas entre base y versión ---
function Get-Conteos([string]$texto) {
  $headings = 0
  $fences = 0
  $consignas = 0
  $requisitos = 0
  $seccion = ''
  $enFence = $false
  foreach ($linea in ($texto -split "`r?`n")) {
    if ($linea -match '^\s*```') { $fences++; $enFence = -not $enFence; continue }
    if ($enFence) { continue }
    if ($linea -match '^#{1,6}\s') {
      $headings++
      if ($linea -match '(?i)\bparte\s+\d') { $seccion = 'consignas' }
      elseif ($linea -match '(?i)(requisito|antes de empezar)') { $seccion = 'requisitos' }
      elseif ($linea -match '^##\s') { $seccion = '' }  # un ## nuevo corta la sección; los ### (subítems C1/C2) la conservan
      continue
    }
    if ($linea -match '^\s*\|') {
      if ($seccion -eq 'consignas' -and $linea -notmatch '^\s*\|[\s:\-\|]*\|\s*$') { $consignas++ }
      continue
    }
    if ($seccion -eq 'requisitos' -and $linea -match '^\s*(?:\d+\.|[-*+])\s') { $requisitos++ }
  }
  return @{ headings = $headings; fences = $fences; consignas = $consignas; requisitos = $requisitos }
}

function Test-Checklist([hashtable]$base, [hashtable]$version, [string]$etiqueta) {
  # Devuelve @{ lineas = ...; fallos = n; sospechosos = n }: no escribir al stream de salida acá,
  # porque en PowerShell contaminaría el valor de retorno de la función.
  $fallos = 0
  $sospechosos = 0
  $lineas = @()
  $pares = @(
    @('filas de consignas en secciones Parte', 'consignas'),
    @('ítems de lista en Antes de empezar', 'requisitos'),
    @('líneas de fence de código', 'fences'),
    @('headings de sección', 'headings')
  )
  foreach ($par in $pares) {
    $etiquetaItem = $par[0]
    $clave = $par[1]
    $enBase = [int]$base[$clave]
    $enVersion = [int]$version[$clave]
    if ($enBase -eq 0 -and $enVersion -eq 0) {
      $lineas += ("  [SUSPECT] {0}: 0 en la base Y 0 en {1}: el contador no aplica a este documento; la igualdad vacía no cuenta como PASS" -f $etiquetaItem, $etiqueta)
      $sospechosos++
    } elseif ($enBase -eq $enVersion) {
      $lineas += ("  [PASS] {0}: base={1}, {2}={3}" -f $etiquetaItem, $enBase, $etiqueta, $enVersion)
    } else {
      $lineas += ("  [FAIL] {0}: base={1}, {2}={3}" -f $etiquetaItem, $enBase, $etiqueta, $enVersion)
      $fallos++
    }
  }
  return @{ lineas = $lineas; fallos = $fallos; sospechosos = $sospechosos }
}

# Heurística de AVISO: solo tokens no vacíos que parecen sustantivos de dominio
# (largos, o con mayúscula intermedia/propia tipo TicketId).
function Test-SustantivoDeDominio([string]$token) {
  if ($token -eq '') { return $false }
  return ($token.Length -ge 5) -or ($token -cmatch '[A-ZÁÉÍÓÚÑ]')
}

# --- Sustitución por letra ---
function Convert-Version([string]$texto, [string]$letra) {
  $sb = New-Object System.Text.StringBuilder
  $pos = 0
  foreach ($m in $regex.Matches($texto)) {
    if ($m.Value -eq '') { continue }  # con patrón no vacío no ocurre; defensa contra tabla vacía
    if ($m.Index -gt $pos) { [void]$sb.Append($texto.Substring($pos, $m.Index - $pos)) }
    $clave = $m.Value.ToLowerInvariant()
    $grupo = $mapaGrupos[$clave]
    $destino = $null
    if ($null -ne $grupo -and $grupo.mapa.ContainsKey($letra)) { $destino = $grupo.mapa[$letra] }
    if ($null -eq $destino) {
      [void]$sb.Append($m.Value)
    } else {
      [void]$sb.Append((Convert-Caja $m.Value $destino))
    }
    $pos = $m.Index + $m.Length
  }
  if ($pos -lt $texto.Length) { [void]$sb.Append($texto.Substring($pos)) }
  return $sb.ToString()
}

# --- Preparación de salida ---
if (-not (Test-Path -LiteralPath $Salida)) {
  New-Item -ItemType Directory -Path $Salida -Force | Out-Null
}
$nombreBase = [System.IO.Path]::GetFileNameWithoutExtension($Base)
$utf8SinBom = New-Object System.Text.UTF8Encoding($false)
$conteosBase = Get-Conteos $textoBase
$fallosTotales = 0

foreach ($letra in $letrasPedidas) {
  # Control de filas: cada token presente en la base necesita SU fila para la letra pedida.
  # Más seguro que reciclar otra fila: si falta, se corta con diagnóstico.
  $filasFaltantes = @()
  foreach ($claveT in $conteosToken.Keys) {
    if ([int]$conteosToken[$claveT] -gt 0 -and -not $mapaGrupos[$claveT].mapa.ContainsKey($letra)) {
      $filasFaltantes += $claveT
    }
  }
  if ($filasFaltantes.Count -gt 0) {
    Write-Output "ERROR: la letra $letra no tiene fila de mapeo para tokens presentes en la base:"
    foreach ($f in ($filasFaltantes | Sort-Object)) {
      $disponibles = (@($mapaGrupos[$f].mapa.Keys) | Sort-Object) -join ', '
      Write-Output ("  - '{0}' ({1} ocurrencias): filas disponibles: {2}" -f $f, [int]$conteosToken[$f], $disponibles)
    }
    Write-Output 'Agregue las filas faltantes en la tabla de dominio o pida otras letras.'
    exit 1
  }

  $texto = Convert-Version $textoBase $letra

  # GUARDA ANTI-COPIA SILENCIOSA: idéntico byte a byte a la base es un error, nunca una copia.
  if ($texto -eq $textoBase) {
    Write-Output "ERROR: la versión $letra sería idéntica byte a byte a la base (guarda anti-copia silenciosa); no se genera."
    Write-Output 'Tokens mapeados buscados y ocurrencias halladas en la base:'
    foreach ($t in ($ordenTokens | Sort-Object)) {
      $claveT = $t.ToLowerInvariant()
      $c = 0
      if ($conteosToken.ContainsKey($claveT)) { $c = [int]$conteosToken[$claveT] }
      Write-Output ("  - {0}: {1}" -f $t, $c)
    }
    Write-Output "Total de ocurrencias de tokens mapeados: $totalOcurrencias."
    Write-Output 'Si todas son 0, la tabla no coincide con este documento: revise las instancias de la tabla.'
    exit 2
  }

  # Nombre de salida: reemplaza el sufijo -version-a; si no existe, agrega -version-<letra>
  $letraMin = $letra.ToLowerInvariant()
  $nuevoNombre = $nombreBase -replace '(?i)-version-a$', "-version-$letraMin"
  if ($nuevoNombre -eq $nombreBase) { $nuevoNombre = "$nombreBase-version-$letraMin" }
  $rutaSalida = Join-Path $Salida ($nuevoNombre + '.md')

  # AVISOS: vocabulario del dominio presente en la base, sin grupo en la tabla.
  # Solo sustantivos de dominio no vacíos; nunca nombres de token vacíos.
  $avisos = @()
  foreach ($v in $vocabulario) {
    if (-not (Test-SustantivoDeDominio $v)) { continue }
    if ([regex]::IsMatch($textoBase, ("\b" + [regex]::Escape($v) + "\b"), $opciones)) {
      $avisos += "'$v': presente en la base sin grupo en la tabla; queda intacto (pasada de lectura natural)"
    }
  }

  [System.IO.File]::WriteAllText($rutaSalida, $texto, $utf8SinBom)
  Write-Output "Generado: $rutaSalida (letra $letra)"

  Write-Output "CHECKLIST DE EQUIVALENCIA — base vs versión ${letra}:"
  $conteos = Get-Conteos $texto
  $check = Test-Checklist $conteosBase $conteos $letra
  foreach ($lineaCheck in $check.lineas) { Write-Output $lineaCheck }
  $fallos = [int]$check.fallos
  $sospechosos = [int]$check.sospechosos
  $fallosTotales += $fallos
  Write-Output 'AVISOS (tokens intactos, para la pasada de lectura natural):'
  if ($avisos.Count -eq 0) {
    Write-Output '  (ninguno)'
  } else {
    foreach ($av in ($avisos | Sort-Object -Unique)) { Write-Output "  - $av" }
  }
  if ($fallos -gt 0) {
    Write-Output "Equivalencia: FAIL ($fallos checks en desacuerdo, letra $letra)"
  } elseif ($sospechosos -gt 0) {
    Write-Output "Equivalencia: PASS CON SUSPECT ($sospechosos contador(es) en 0 en ambas versiones; revise si el contador aplica a este documento)"
  } else {
    Write-Output "Equivalencia: PASS (letra $letra)"
  }
  Write-Output ''
}

if ($fallosTotales -gt 0) {
  Write-Output 'ERROR: el checklist de equivalencia reporta FAIL: revise la tabla de dominio'
  exit 1
}
Write-Output 'OK: versiones equivalentes generadas por reglas; la pasada de lectura natural queda para el docente.'
exit 0
