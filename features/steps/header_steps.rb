Then /^"(.*)" should be the record "(.*)" time$/ do |header, key|
  DateTime.parse(response.headers[header].to_s).should == @record.send(key)
end

Then /^"(.*)" should be set$/ do |header|
  response.headers[header].blank?.should_not == true
end
