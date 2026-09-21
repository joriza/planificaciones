# scaffold-evaluacion.ps1 — Esqueletos canónicos de una evaluación (base, versión A y anexo docente)
# Genera la estructura de metadatos y acuerdos, la consigna maestra (versión A) y su anexo,
# sin prosa: solo estructura, metadatos del curso-data y placeholders <!-- prose: ... -->.
# Las versiones equivalentes (B/C/D) no se esqueletizan: se generan con tools\generar-version-b.ps1.
#
# Uso (desde la raíz del repositorio):
#   powershell -File tools\scaffold-evaluacion.ps1 -Materia output\LSO -Instancia u2 -Salida <carpeta> [-Force]
#
# Parametros:
#   -Materia    (obligatorio) ruta a la carpeta de la materia (contiene curso-data.json).
#   -Instancia  (obligatorio) u1 | u2 | u3 | u4 | 02-03 | 17-18 | 19-20 | 34-35.
#   -Salida     carpeta destino (se crea si no existe).
#   -Force      permite sobrescribir archivos existentes.
#
# Escribe tres archivos con la convención de nombres del corpus:
#   unidades : evaluacion-uN.md, evaluacion-uN-version-a.md, evaluacion-uN-version-a-anexo-docente.md
#   momentos : evaluacion-intensificaciones-NN-NN.md, -version-a.md, -version-a-anexo-docente.md
# Encuentros dedicados (canon del prompt): u1 -> 9, u2 -> 15, u3 -> 26, u4 -> 32.
# Errores duros (exit 1): JSON inválido, instancia desconocida, archivos existentes sin -Force.

param(
  [string]$Materia,
  [string]$Instancia = '',
  [string]$Salida = '.',
  [switch]$Force
)

$ErrorActionPreference = 'Stop'

if ($Materia -eq '') {
  Write-Output 'ERROR: falta -Materia <ruta a la carpeta de la materia (contiene curso-data.json)>'
  exit 1
}
if ($Instancia -eq '') {
  Write-Output 'ERROR: falta -Instancia <u1|u2|u3|u4|02-03|17-18|19-20|34-35>'
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
  $data = [System.IO.File]::ReadAllText((Resolve-Path -LiteralPath $rutaJson).Path) | ConvertFrom-Json
} catch {
  Write-Output "ERROR: JSON invalido: $($_.Exception.Message)"
  exit 1
}

# --- Tipo de instancia: unidad didáctica (u1..u4) o momento (02-03, 17-18, 19-20, 34-35) ---
$esUnidad = $Instancia -match '^u[1-4]$'
$esMomento = $Instancia -match '^\d{2}-\d{2}$'
if (-not ($esUnidad -or $esMomento)) {
  Write-Output "ERROR: instancia desconocida: '$Instancia' (valores: u1 | u2 | u3 | u4 | 02-03 | 17-18 | 19-20 | 34-35)"
  exit 1
}

# Datos comunes del curso-data
$numUnidad = 0
$tituloInstancia = ''
$nombreBase = ''
if ($esUnidad) {
  $numUnidad = [int]$Instancia.Substring(1)
  $encuentroDedicado = @{ 1 = 9; 2 = 15; 3 = 26; 4 = 32 }[$numUnidad]
  $claveUnidad = "u$numUnidad"
  $uniProp = $data.slots.unidades.PSObject.Properties[$claveUnidad]
  if ($null -eq $uniProp) {
    Write-Output "ERROR: la unidad '$claveUnidad' no existe en slots.unidades"
    exit 1
  }
  $uni = $uniProp.Value
  $tituloInstancia = "Evaluación de la Unidad $numUnidad — Encuentro $encuentroDedicado"
  $nombreBase = "evaluacion-u$numUnidad.md"
} else {
  $tituloInstancia = "Evaluación del momento de intensificación y fortalecimiento $Instancia"
  $nombreBase = "evaluacion-intensificaciones-$Instancia.md"
}
$nombreVersionA = $nombreBase -replace '\.md$', '-version-a.md'
$nombreAnexo = $nombreBase -replace '\.md$', '-version-a-anexo-docente.md'

# --- Destinos y regla de no sobrescritura ---
if (-not (Test-Path -LiteralPath $Salida)) {
  New-Item -ItemType Directory -Path $Salida -Force | Out-Null
}
$rutaBase = Join-Path $Salida $nombreBase
$rutaVersionA = Join-Path $Salida $nombreVersionA
$rutaAnexo = Join-Path $Salida $nombreAnexo
foreach ($destino in @($rutaBase, $rutaVersionA, $rutaAnexo)) {
  if (Test-Path -LiteralPath $destino) {
    if (-not $Force) {
      Write-Output "ERROR: ya existe $destino (use -Force para sobrescribir)"
      exit 1
    }
  }
}

$l = [System.Collections.Generic.List[string]]::new()

# ============================================================
# 1) Metadatos y acuerdos de la instancia
# ============================================================
$l.Add("# $tituloInstancia")
$l.Add('')
$l.Add("> Evaluación de la instancia «$tituloInstancia» · Curso: $($data.denominacion). Documento de **metadatos y acuerdos de la instancia**, en registro docente formal. El material del alumno es la versión `$(($nombreVersionA -replace '\.md$', ''))` y sus versiones equivalentes generadas; sus soluciones y criterios de corrección van en el anexo docente separado (`$nombreAnexo`).")
$l.Add('')
$l.Add('## 1. Identificación')
$l.Add('')
$l.Add('| Campo | Detalle |')
$l.Add('| --- | --- |')
$l.Add("| Instancia | $tituloInstancia |")
if ($esUnidad) {
  $l.Add("| Unidad evaluada | $numUnidad — $($uni.denominacion) |")
  $l.Add("| Eje temático | <!-- prose: eje temático dominante de la unidad --> |")
} else {
  $l.Add('| Momento | Intensificación y fortalecimiento — encuentros ' + $Instancia + ' |')
}
$l.Add('| Carácter/Objetivo | <!-- prose: carácter dominante de la instancia --> |')
$l.Add('| Destinatarios | Todo el curso |')
$l.Add('| Duración teórica | 240 minutos (4 horas reloj) |')
$l.Add("| Uso de celular | $($data.slots.celular) |")
$l.Add('| Documentos de la instancia | `' + $nombreBase + '` · `' + $nombreVersionA + '` · `' + $nombreAnexo + '` (más las versiones equivalentes B/C/D generadas desde la A) |')
$l.Add('')
$l.Add('## 2. Estructura del encuentro (240 min)')
$l.Add('')
$l.Add('| Momento | Tiempo | Qué ocurre |')
$l.Add('| --- | --- | --- |')
$l.Add('| <!-- prose: momento 1 --> | <!-- prose: minutos --> | <!-- prose: qué ocurre --> |')
$l.Add('| <!-- prose: momento 2 --> | <!-- prose: minutos --> | <!-- prose: qué ocurre --> |')
$l.Add('| <!-- prose: momento 3 --> | <!-- prose: minutos --> | <!-- prose: qué ocurre --> |')
$l.Add('| <!-- prose: momento 4 --> | <!-- prose: minutos --> | <!-- prose: qué ocurre --> |')
$l.Add('| **Total** | **240 min** | |')
$l.Add('')
if ($esUnidad) {
  $l.Add('## 3. Regla canónica de la instancia')
  $l.Add('')
  $l.Add('<!-- prose: entrega y defensa en este encuentro; devolución al inicio del encuentro siguiente; regla ante entrega incompleta -->')
  $l.Add('')
  $l.Add('## 4. Defensa individual del TP (modalidad)')
  $l.Add('')
  $l.Add('<!-- prose: demo + preguntas + registro objetivo por objetivo -->')
  $l.Add('')
  $l.Add('## 5. Alcance')
  $l.Add('')
  $l.Add('<!-- prose: núcleos incluidos y excluidos, con los objetivos mínimos de la unidad -->')
  $l.Add('')
  $l.Add('## 6. Prueba práctica individual (versiones equivalentes)')
  $l.Add('')
  $l.Add('<!-- prose: estructura de la prueba, puntaje por parte, esqueleto provisto, condiciones -->')
  $l.Add('')
  $l.Add('## 7. Criterios de calificación')
  $l.Add('')
  $l.Add('<!-- prose: componentes, qué se observa y registro -->')
  $l.Add('')
  $l.Add('## 8. Condiciones de resolución de la prueba')
  $l.Add('')
  $l.Add('<!-- prose: individualidad, material consultable, convenciones obligatorias, cierre del encuentro -->')
  $l.Add('')
} else {
  $l.Add('## 3. Acuerdo pedagógico por grupo de condición')
  $l.Add('')
  $l.Add('<!-- prose: grupo de intensificación (contenidos mínimos irrenunciables, actividad, recursos) y grupo de fortalecimiento -->')
  $l.Add('')
  $l.Add('## 4. Desarrollo de los encuentros del momento')
  $l.Add('')
  $l.Add('<!-- prose: agenda con tiempos teóricos de cada uno de los 2 encuentros; pistas en paralelo si el momento es diferenciado -->')
  $l.Add('')
}
$l.Add('## 9. Regla de equivalencia entre versiones')
$l.Add('')
$l.Add('<!-- prose: misma estructura, mismos objetivos y requisitos, distinto dominio o datos, sin reglas que una versión tenga y otra no; las versiones equivalentes son A/B/C/D (mínimo dos según los grupos) -->')
$l.Add('')
$l.Add('## 10. Mecánica de asignación de versiones')
$l.Add('')
$l.Add('<!-- prose: cómo se asigna la versión y cómo se registra en la planilla -->')
$l.Add('')
$l.Add('## 11. Devolución')
$l.Add('')
$l.Add('<!-- prose: cuándo y cómo se devuelve; capas de recuperación si el objetivo mínimo queda pendiente -->')
$l.Add('')

# ============================================================
# 2) Consigna maestra — versión A
# ============================================================
$v = [System.Collections.Generic.List[string]]::new()
if ($esUnidad) {
  $v.Add("# $tituloInstancia — Versión A")
} else {
  $v.Add("# Evaluación del momento $Instancia — Versión A")
}
$v.Add('')
$v.Add('> Dominio de esta versión: <!-- prose: dominio declarado de la versión A -->. Duración: 90 minutos. Puntaje total: 100 puntos. Resolución individual, con computadora, sin celular. Las condiciones completas están en `' + $nombreBase + '`.')
$v.Add('')
$v.Add('## Antes de empezar')
$v.Add('')
$v.Add('<!-- prose: requisitos y condiciones (esqueleto provisto, código en un solo archivo, convenciones del curso, mensajes de error, cierre) -->')
$v.Add('')
$v.Add('## Objetivos de la prueba')
$v.Add('')
$v.Add('<!-- prose: objetivos que evalúa esta versión, equivalentes en todas las versiones -->')
$v.Add('')
$v.Add('## Material provisto — Esqueleto de `Program.cs`')
$v.Add('')
$v.Add('<!-- prose: esqueleto inicial (lista base, contador de ids y records provistos, no se modifican) -->')
$v.Add('')
$v.Add('## Parte 1 — <!-- prose: título de la parte 1 -->')
$v.Add('')
$v.Add('<!-- prose: tabla ítem / consigna / puntos -->')
$v.Add('')
$v.Add('## Parte 2 — <!-- prose: título de la parte 2 -->')
$v.Add('')
$v.Add('<!-- prose: tabla ítem / consigna / puntos -->')
$v.Add('')
$v.Add('## Parte 3 — <!-- prose: título de la parte 3 -->')
$v.Add('')
$v.Add('<!-- prose: tabla ítem / consigna / puntos -->')
$v.Add('')
$v.Add('## Parte 4 — Ítems conceptuales')
$v.Add('')
$v.Add('<!-- prose: ítems conceptuales breves, con puntaje -->')
$v.Add('')
$v.Add('## Batería de verificación: salida esperada de cada prueba')
$v.Add('')
$v.Add('<!-- prose: tabla prueba / pedido / salida esperada -->')
$v.Add('')
$v.Add('## Al terminar')
$v.Add('')
$v.Add('<!-- prose: qué deja el alumno y qué avisa al docente -->')
$v.Add('')

# ============================================================
# 3) Anexo docente de la versión A
# ============================================================
$a = [System.Collections.Generic.List[string]]::new()
if ($esUnidad) {
  $a.Add("# Anexo docente — $tituloInstancia — Versión A")
} else {
  $a.Add("# Anexo docente — Evaluación del momento $Instancia — Versión A")
}
$a.Add('')
$a.Add('> Documento docente formal. No se entrega a los alumnos: contiene la solución completa de la versión A, las respuestas esperadas de los ítems conceptuales, los criterios de corrección ítem por ítem y la pauta de devolución.')
$a.Add('')
$a.Add('## 1. Solución completa (`Program.cs`)')
$a.Add('')
$a.Add('<!-- prose: solución completa comentada y aceptaciones válidas menores -->')
$a.Add('')
$a.Add('## 2. Salidas de referencia para la corrección')
$a.Add('')
$a.Add('<!-- prose: tabla pedido / respuesta esperada y comandos de verificación -->')
$a.Add('')
$a.Add('## 3. Criterios de corrección ítem por ítem')
$a.Add('')
$a.Add('<!-- prose: qué puntúa, qué no y por qué; errores previstos y criterio de intervención -->')
$a.Add('')
$a.Add('## 4. Pauta de devolución')
$a.Add('')
$a.Add('<!-- prose: devolución, registro en planilla y pistas de recuperación -->')
$a.Add('')

# --- Escritura (UTF-8 sin BOM, LF, como el corpus) ---
$utf8SinBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($rutaBase, ($l -join "`n"), $utf8SinBom)
[System.IO.File]::WriteAllText($rutaVersionA, ($v -join "`n"), $utf8SinBom)
[System.IO.File]::WriteAllText($rutaAnexo, ($a -join "`n"), $utf8SinBom)

Write-Output "OK: $rutaBase"
Write-Output "OK: $rutaVersionA"
Write-Output "OK: $rutaAnexo"
exit 0
