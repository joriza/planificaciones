-- pdf-numerar-lineas.lua — numeración de líneas para bloques de código en los PDFs generados.
--
-- Reglas:
--   - Solo numera bloques con lenguaje declarado (fenced ```python, ```bash, etc.);
--     los bloques sin lenguaje (salidas de consola, bloques vacíos) quedan sin números.
--   - Solo numera bloques de 2 o más líneas (un bloque de una sola línea no necesita número).
--   - El número va prefijado al texto (alineado a la derecha con espacios), así se conserva
--     el resaltado de sintaxis de pandoc completo; el markdown del corpus NO se modifica:
--     la numeración vive solo en el render del PDF.
--
-- Uso: pandoc --lua-filter tools/pdf-numerar-lineas.lua (lo integra convertir-a-pdf.ps1).

function CodeBlock (cb)
  if #cb.classes == 0 then
    return nil
  end
  local lines = {}
  for line in (cb.text .. "\n"):gmatch("(.-)\n") do
    lines[#lines + 1] = line
  end
  if #lines < 2 then
    return nil
  end
  local width = #tostring(#lines)
  local out = {}
  for i, line in ipairs(lines) do
    out[#out + 1] = string.format("%" .. width .. "d  %s", i, line)
  end
  cb.text = table.concat(out, "\n")
  return cb
end