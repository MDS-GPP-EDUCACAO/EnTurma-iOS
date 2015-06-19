
SLEEP_TIME = 0.5

Then /^I fill the year field$/ do
  macro 'I should see a "Ano" input field'
  touch ("textField index:0")
  performPickerSelection(1)
  performPickerSelection(0)
end

Then /^I fill the state field$/ do
  macro 'I should see a "Estado" input field'
  touch ("textField index:1")
  performPickerSelection(4)
end

Then /^I fill the local field$/ do
  macro 'I should see a "Local" input field'
  touch ("textField index:2")
  performPickerSelection(1)
  performPickerSelection(0)
end

Then /^I fill the network field$/ do
  macro 'I should see a "Rede" input field'

  touch ("textField index:3")
  performPickerSelection(1)
  performPickerSelection(0)
  macro 'I scroll down'

end

Then /^I fill the grade field$/ do
  macro 'I should see a "Turma" input field'
  touch(nil, :offset => {:x=>0, :y => 100})
  touch ("textField index:4")
  performPickerSelection(1)
end

Then /^I fill the form fields$/ do
  macro 'I fill the year field'
  macro 'I fill the state field'
  macro 'I fill the local field'
  macro 'I fill the network field'
  macro 'I fill the grade field'

end

Then /^I generate the report$/ do
  macro 'I should see a "Gerar" button'
  touch(nil, :offset => {:x=>0, :y => 100})
  touch("button index:0")
  wait_for_condition :no_network_indicator => 'NO_NETWORK_INDICATOR'
end


def performPickerSelection(rowNumber)
  query("pickerTableView index:'0'", [{selectRow:rowNumber}, {animated:1}, {notify:1}])
  sleep(SLEEP_TIME)
end