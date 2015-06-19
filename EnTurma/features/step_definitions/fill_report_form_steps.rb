
SLEEP_TIME = 0.5

Then /^I fill the year field$/ do
  touch ("textField index:0")
  performPickerSelection(1)
  performPickerSelection(0)
end

Then /^I fill the state field$/ do
  touch ("textField index:1")
  performPickerSelection(4)
end

Then /^I fill the local field$/ do
  touch ("textField index:2")
  performPickerSelection(1)
  performPickerSelection(0)
end

Then /^I fill the network field$/ do
  touch ("textField index:3")
  performPickerSelection(1)
  performPickerSelection(0)
  scroll("scrollView index:0", :down)
  sleep(SLEEP_TIME)
  scroll("scrollView index:0", :down)
  sleep(SLEEP_TIME)
  scroll("scrollView index:0", :down)

end

Then /^I fill the grade field$/ do
  touch(nil, :offset => {:x=>0, :y => 100})
  touch ("textField index:4")
  performPickerSelection(4)
end

Then /^I generate the report$/ do
  touch(nil, :offset => {:x=>0, :y => 100})
  touch("button index:0")
  wait_for_condition :no_network_indicator => 'NO_NETWORK_INDICATOR'
end


def performPickerSelection(rowNumber)
  query("pickerTableView index:'0'", [{selectRow:rowNumber}, {animated:1}, {notify:1}])
  sleep(SLEEP_TIME)
end