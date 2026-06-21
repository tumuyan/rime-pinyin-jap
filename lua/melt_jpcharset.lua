-- 假名滤镜。
local function jpcharset_filter(input, env)
  if env.engine.context:get_option("jpcharset_c") then
    for cand in input:iter() do
      local text = cand.text
      for i, c in utf8.codes(text) do
         if c < 0x3041 or c > 0x30FF then
            yield(cand)
            break
         end
      end
    end
  elseif env.engine.context:get_option("jpcharset_j") then
    for cand in input:iter() do
      local text = cand.text
      for i, c in utf8.codes(text) do
         if c >= 0x3041 and c <= 0x30FF then
            yield(cand)
            break
         end
      end
    end
  else
    for cand in input:iter() do
      yield(cand)
    end
  end
end

return jpcharset_filter