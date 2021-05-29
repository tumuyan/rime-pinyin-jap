function get_date(input, seg, env)
  if ( input == "date") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), " -"))
  elseif ( input == "date-") then
    yield(Candidate("date", seg.start, seg._end, os.date("%m/%d"), ""))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d"), ""))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), ""))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y.%m.%d"), ""))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日"), ""))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y%m%d"), ""))
  end
end
