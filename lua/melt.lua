local history_str = ""
local history_oo = ""
local history_ii = ""
local history_uu = 1

-- 获取用户目录
local function getCurrentDir()
  function sum(a, b)
    return a + b
  end
  local info = debug.getinfo(sum)
  local path = info.source
  path = string.sub(path, 2, -1) -- 去掉开头的"@"
  path = string.match(path, "^(.*[\\/])") -- 捕获目录路径
  local spacer = string.match(path,"[\\/]")
  path=string.gsub(path,'[\\/]',spacer)  .. ".." .. spacer 
  return path
end

-- 输出日期、ooii、词尾输入--保存词条到英文用户词库
local function get_date(input, seg, env)
  if (init_tran) then
--    tran_init(env)
  end
  if ( input == "guid" or input == "uuid") then
    yield(Candidate("UUID", seg.start, seg._end, guid(), " -V4"))
  elseif ( input == "date") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), " -"))
  elseif ( input == "time"  or  input == "date---") then
    yield(Candidate("time", seg.start, seg._end, os.date("%H:%M"), " -"))
    yield(Candidate("time", seg.start, seg._end, os.date("%H:%M:%S"), " -"))
    yield(Candidate("time", seg.start, seg._end, os.date("%H%M%S"), " -"))
  elseif input == "oo" and string.len(history_oo)>0 then
    yield(Candidate("oo", seg.start, seg._end, history_oo, "get oo"))
  elseif input == "ii" and string.len(history_ii)>0 then
    yield(Candidate("oo", seg.start, seg._end, history_ii, "get ii"))
  elseif ( string.sub(input,-1)  == "-") then
    if ( input == "date-"  or  input == "time--") then
      yield(Candidate("date", seg.start, seg._end, os.date("%m/%d"), ""))
      yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d"), ""))
      yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), ""))
      yield(Candidate("date", seg.start, seg._end, os.date("%Y.%m.%d"), ""))
      yield(Candidate("date", seg.start, seg._end, os.date("%Y%m%d"), ""))
      yield(Candidate("date", seg.start, seg._end, os.date("%B %d"), ""))
      yield(Candidate("date", seg.start, seg._end,  string.gsub(os.date("%Y年%m月%d日"),"([年月])0","%1"), ""))
    elseif ( input == "time-" or  input == "date--") then
      yield(Candidate("date", seg.start, seg._end, os.date("%m/%d %H:%M"), ""))
      yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d %H:%M"), ""))
      yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d %H:%M"), ""))
      yield(Candidate("date", seg.start, seg._end, os.date("%Y.%m.%d %H:%M"), ""))
      yield(Candidate("date", seg.start, seg._end, os.date("%Y%m%d%H%M%S"), ""))
      yield(Candidate("date", seg.start, seg._end, os.date("%B %d %H:%M"), ""))
      yield(Candidate("date", seg.start, seg._end,  string.gsub(os.date("%Y年%m月%d日 %H:%M"),"([年月])0","%1"), ""))
      yield(Candidate("date", seg.start, seg._end, os.time() , "-秒"))
    else
      local inpu = string.gsub(input,"[-]+$","")
      if (string.len(inpu) > 1 and string.sub(input,1,1) ~= "-") then
        if ( string.sub(input,-2)  == "--") then
--          file = io.open("C:\\Users\\Yazii\\AppData\\Roaming\\Rime\\pinyin_simp_pin.txt", "a")
--          user_path = (rime_api ~= nil and rime_api.get_user_data_dir ~= nil and {rime_api:get_user_data_dir()} or {'%appdata%\\Rime'})[1]
          ppath = getCurrentDir() .. "melt_eng_custom.dict.yaml"
--          yield(Candidate("pin", seg.start, seg._end, ppath , ""))
          local file = io.open(ppath,"a")
          file:write("\n" .. inpu .. "\t" .. inpu .. "\t100")
          file:close()
          yield(Candidate("pin", seg.start, seg._end, inpu , " 已保存"))
        else
          yield(Candidate("pin", seg.start, seg._end, inpu , " -保存"))
        end
	  end
    end
  end
end


-- 假名滤镜。
local function jpcharset_filter(input, env)
  sw =  env.engine.context:get_option("jpcharset_filter")
  if( env.engine.context:get_option("jpcharset_c")) then
    for cand in input:iter() do
      local text = cand.text
      for i in utf8.codes(text) do
         local c = utf8.codepoint(text, i)
         if (c< 0x3041 or c> 0x30FF) then
            yield(cand)
--            yield(Candidate("pin", seg.start, seg._end, text , string.format("%x %c",c,c)))
            break
         end
      end
    end
  elseif( env.engine.context:get_option("jpcharset_j")) then
    for cand in input:iter() do
      local text = cand.text
      for i in utf8.codes(text) do
         local c = utf8.codepoint(text, i)
         if (c>= 0x3041 and c<= 0x30FF) then
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

-- 输入的内容大写前2个字符，自动转小写词条为全词大写；大写第一个字符，自动转写小写词条为首字母大写
local function autocap_filter(input, env)
  if true then
--  if( env.engine.context:get_option("autocap_filter")) then
    for cand in input:iter() do
      local text = cand.text
      local commit = env.engine.context:get_commit_text()
      if (string.find(text, "^%l%l.*") and string.find(commit, "^%u%u.*")) then
        if(string.len(text) == 2) then
          yield(Candidate("cap", 0, 2, commit , "+" ))
        else
          yield(Candidate("cap", 0, string.len(commit), string.upper(text) , "+" .. string.sub(cand.comment, 2)))
        end
        --[[ 修改候选的注释 `cand.comment`
            因复杂类型候选项的注释不能被直接修改，
            因此使用 `get_genuine()` 得到其对应真实的候选项
            cand:get_genuine().comment = cand.comment .. " " .. s
        --]]
      elseif (string.find(text, "^%l+$") and string.find(commit, "^%u+")) then
        local suffix = string.sub(text,string.len(commit)+1)
        yield(Candidate("cap", 0, string.len(commit), commit .. suffix , "+" .. suffix))
      else
        yield(cand)
      end
    end
  else
    for cand in input:iter() do
      yield(cand)
    end
  end
end

-- 长词优先（从后方移动2个英文候选和3个中文长词，提前为第2-6候选；当后方候选长度全部不超过第一候选词时，不产生作用）
local function long_word_filter(input)
  local l = {}
  -- 记录第一个候选词的长度，提前的候选词至少要比第一个候选词长
  local length = 0
  -- 记录筛选了多少个英语词条(只提升3个词的权重，并且对comment长度过长的候选进行过滤)
  local s1 = 0
  -- 记录筛选了多少个汉语词条(只提升3个词的权重)
  local s2 = 0
  for cand in input:iter() do
    leng = utf8.len(cand.text)
    if(length < 1 ) then
      length = leng
      yield(cand)
    elseif #table > 30 then
      table.insert(l, cand)
    elseif ((leng > length) and (s1 <2)) and(string.find(cand.text, "^[%w%p%s]+$")) then
      s1=s1+1
      if( string.len(cand.text)/ string.len(cand.comment) > 1.5) then 
        yield(cand)
      end
    elseif ((leng > length) and (s2 <3)) and(string.find(cand.text, "^[%w%p%s]+$")==nil) then
      yield(cand)
      s2=s2+1
    else
      table.insert(l, cand)
    end
  end
  for i, cand in ipairs(l) do
    yield(cand)
  end
end


function guid()
    local seed={'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'}
    local tb={}
    for i=1,32 do
        table.insert(tb,seed[math.random(1,16)])
    end
    local sid=table.concat(tb)
    return string.format('%s-%s-%s-%s-%s',
        string.sub(sid,1,8),
        string.sub(sid,9,12),
        string.sub(sid,13,16),
        string.sub(sid,17,20),
        string.sub(sid,21,32)
    )
end

local s=0
local start_time=os.clock()
while s<50000 do
    s=s+1
    print(s,guid())
end
print('execute_time='..tostring(os.clock()-start_time))


-- 获取子字符串。根据UTF8编码规则，避免了末位输出乱码
local function get_sub_string(str, length)
  if string.len(str)<length then
    return str
  end

  local ch = string.byte(str, length)
  while( ch<=191 and ch >= 128)
  do
    length = length-1
    ch = string.byte(str, length)
  end
  return string.sub(str,1,length-1)
end


-- Windows 小狼毫输出\r\n会崩溃，故需判断系统为Windows则只输出\r
local next_line = "\n"
if package.config:sub(1,1) == "\\" then
  next_line = "\r"
end


-- 包含3个功能：把Oo转换为变量值, <br>转换为换行, 过长的内容切分并缓存,在候选栏仅提供预览（节约屏幕空间的同时避免输入法崩溃）
local oo_buffer= {}

local function oo_filter(input,env)
  oo_buffer= {}
  local input_len = string.len(env.engine.context.input)
  
  if string.len(history_oo)>0 then
    for cand in input:iter() do
      local text= string.gsub(cand.text,"<br>",next_line)
      text= string.gsub(text,"&nbsp"," ")
      local comment = cand.comment
      
      if string.find(text, "Oo")~=nil then
        text = string.gsub(text,"Oo",history_oo)
        if string.len(history_ii)>0 then
          text = string.gsub(text,"Xx",history_ii)
        end
        comment =  "=" .. history_oo
      end
      
      if string.len(text)>120 then
        local key = get_sub_string(text,100)
--        local key = string.sub(text,0,100)
        oo_buffer[key] = text
        yield(Candidate(cand.type, 0,input_len, key, "..." ..  comment ))
      elseif text ~= cand.text then
        yield(Candidate(cand.type, 0,input_len, text, comment ))
      else
        yield(cand)
      end
    end
  else
    for cand in input:iter() do
      local text = cand.text
      if string.len(text)>110 then
        text= string.gsub(text,"&nbsp"," ")
        local key = get_sub_string(text,100)
--        local key = string.sub(text,0,100)
        text= string.gsub(text,"<br>",next_line)
        oo_buffer[key] = text
        yield(Candidate(cand.type, 0,input_len, key, "..." .. cand.comment ))
      else
        yield(cand)
      end
    end
  end
end



-- 包含2个功能，输入 值=oo 设置 history_oo，输入数字完成长候选词取值上屏
local function oo_processor(key, env)
  local context = env.engine.context
  local commit_text = context:get_commit_text()
  if commit_text == nil then 
    return 2
  end
  
  local ch = key.keycode
  local engine=env.engine
  local done=false
  
  if  context:has_menu() then
    if key.keycode == 32  then
      done = true
    elseif ch <58 and ch>48 then
      local composition = context.composition
      local segment = composition:back()
      local index = segment.selected_index + ch -49
      local candidate_count = segment.menu:candidate_count()
      if candidate_count <= index or index < 0 then
        return 2
      end
      --  -48为键盘数字 -49 第一个候选序号0
      commit_text = segment:get_candidate_at(index).text
      done = true
    end
    
    if string.len(commit_text)>80 and done then
      context:clear()
      if oo_buffer[commit_text] ~= nil then
        engine:commit_text(oo_buffer[commit_text])
      else
        engine:commit_text(commit_text)
      end
      return 1
    end
  
  end

  
  local v = commit_text:match("(.+)=")
  local k = context.input:match("=(.+)$")
  if k == nil or v == nil then
    return 2
  end
-- k 和 v只要能够匹配到，长度一定大于0
--  local file = io.open("C:\\Users\\Yazii\\AppData\\Roaming\\Rime\\history.txt","a")
--  file:write("\n" .. commit_text .. "\tk=" .. k .. " v=" .. v)
--  file:close()
  
  if(k == "oo") then
    history_oo = v
    context:clear()
    return 1
  elseif (k == "ii") then
    history_ii = v
    context:clear()
    return 1
  end
  return 2
end
return {getdate= get_date, jpcharsetfilter= jpcharset_filter,autocapfilter=autocap_filter, longwordfilter=long_word_filter,ooprocessor=oo_processor ,oofilter=oo_filter}