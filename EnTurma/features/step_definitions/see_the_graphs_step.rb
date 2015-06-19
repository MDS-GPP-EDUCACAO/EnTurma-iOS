
Then /^I see the ideb graph$/ do
  wait_for_none_animating()
  macro 'I should see a "IDEB" button'
end

Then /^I see the evasion graph$/ do
  scroll("scrollView index:1", :right)
  wait_for_condition :none_animating => 'NONE_ANIMATING'
  sleep(0.2)
  macro 'I should see a "Evasão" button'

end

Then /^I see the performance graph$/ do
  scroll("scrollView index:1", :right)
  wait_for_condition :none_animating => 'NONE_ANIMATING'
  sleep(0.2)
  macro 'I should see a "Rendimento" button'

end

Then /^I see the distortion graph$/ do
  scroll("scrollView index:1", :right)
  wait_for_condition :none_animating => 'NONE_ANIMATING'
  sleep(0.2)
  macro 'I should see a "Distorção" button'

end

Then /^I see all graph$/ do
  macro 'I see the ideb graph'
  macro 'I see the evasion graph'
  macro 'I see the performance graph'
  macro 'I see the distortion graph'
end