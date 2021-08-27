function Table(tbl)
  local caption = tbl.caption
  if caption.long and caption.long[1] then
    local content = caption.long[1].content
    table.insert(content, 1, pandoc.Space())
    table.insert(content, 1, pandoc.Str(':'))
  end
  return tbl
end
  
