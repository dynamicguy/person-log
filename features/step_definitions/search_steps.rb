Then /^I should see a form with a search box$/ do
  page.should have_field "q"
end

When /^I should see a search button$/ do
  page.should have_button "Search"
end

Then /^I fill in "(.*?)", :with => "(.*?)"$/ do |field, val|
  fill_in field, :with => val
end

Then /^I should see search results page$/ do
  page.should have_content "persons found in"
end

When /^I click on "([^"]*)" button$/ do |label|
  click_button(label)
end
Given /^I on home page$/ do
  visit '/'
end

Given /^I have the following persons:$/ do |table|
  User.create!(table.hashes)
end
When /^I wait for (\d+) seconds$/ do |duration|
  sleep duration.to_i
end
When /^I search for keyword "([^"]*)"$/ do |keyword|
  visit '/'
  fill_in "q", :with => keyword
  click_button "search-btn"
end