When /^I edit my profile to "(.*)\/(.*)\/(.*)"$/ do |first_name, last_name, website|
  visit edit_member_profile_path(controller.current_user)
  fill_in "First name", :with => first_name
  fill_in "Last name", :with => last_name
  fill_in "Website", :with => website
  click_button "Update profile"
end