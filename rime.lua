function get_date(input, seg, env)
  if ( input == "date") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), " -"))
  elseif ( input == "date-"  or  input == "time--") then
    yield(Candidate("date", seg.start, seg._end, os.date("%m/%d"), ""))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d"), ""))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), ""))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y.%m.%d"), ""))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y%m%d"), ""))
    yield(Candidate("date", seg.start, seg._end, os.date("%B %d"), ""))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日"), ""))
  elseif ( input == "time"  or  input == "date---") then
    yield(Candidate("time", seg.start, seg._end, os.date("%H:%M"), " -"))
    yield(Candidate("time", seg.start, seg._end, os.date("%H:%M:%S"), " -"))
    yield(Candidate("time", seg.start, seg._end, os.date("%H%M%S"), " -"))
  elseif ( input == "time-" or  input == "date--") then
    yield(Candidate("date", seg.start, seg._end, os.date("%m/%d %H:%M"), ""))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d %H:%M"), ""))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d %H:%M"), ""))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y.%m.%d %H:%M"), ""))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y%m%d%H%M%S"), ""))
    yield(Candidate("date", seg.start, seg._end, os.date("%B %d %H:%M"), ""))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日 %H:%M"), ""))
  end
end
