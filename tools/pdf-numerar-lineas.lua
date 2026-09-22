-- pdf-numerar-lineas.lua — numeración de líneas para bloques de código en los PDFs generados.
--
-- Reglas:
--   - Solo numera bloques con lenguaje declarado (fenced ```python, ```bash, etc.);
--     los bloques sin lenguaje (salidas de consola, bloques vacíos) quedan sin números.
--   - Solo numera bloques de 2 o más líneas (un bloque de una sola línea no necesita número).
--   - Usa la clase nativa numberLines de pandoc: el motor de resaltado emite los números
--     como anclas fuera del texto del código (no cambian de color con la sintaxis;
--     el CSS de impresión los fija en un solo color). El markdown del corpus NO se
--     modifica: la numeración vive solo en el render del PDF.
--
-- Uso: pandoc --lua-filter tools/pdf-numerar-lineas.lua (lo integra convertir-a-pdf.ps1).

function CodeBlock (cb)
  if #cb.classes == 0 then
    return nil
  end
  local n = 0
  for _ in (cb.text .. "\n"):gmatch("(.-)\n") do
    n = n + 1
  end
  if n < 2 then
    return nil
  end
  cb.classes[#cb.classes + 1] = 'numberLines'
  return cb
end