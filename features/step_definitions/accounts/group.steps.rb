When /^I create a group with "(.*)\/(.*)\/(.*)"$/ do |name, description, tag_list|
  visit root_path
  click_link "Create a new Group"
  Then %{I should see "Create group"}
  fill_in "Name", :with => name
  fill_in "Description", :with => description
  fill_in "Tags", :with => tag_list
  click_button "Create"
end