Given /^I am on the Welcome Screen$/ do
  element_exists("view")
  sleep(STEP_PAUSE)
end

Given /^I'm going to about tab$/ do
  touch ("tabBarButton index:0")
end

Given /^I'm going to report tab$/ do
  touch ("tabBarButton index:1")
end

Given /^I'm going to compare tab$/ do
  touch ("tabBarButton index:2")
end

Given /^I'm going to rank tab$/ do
  touch ("tabBarButton index:3")
end

Given /^I'm going to contact tab$/ do
  touch ("tabBarButton index:4")
end

