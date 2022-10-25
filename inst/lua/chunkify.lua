CodeBlock = function(el)
  if #el.classes == 1 and el.classes[1] == "r" then
    el.classes = {"{r}"}
  end
  return el
end
