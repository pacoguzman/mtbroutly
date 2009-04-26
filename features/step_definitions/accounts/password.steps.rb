When /^I change my password to "(.*)\/(.*)\/(.*)"$/ do |password, confirmation, repeat_confirmation|
  visit member_my_account_path
  fill_in "Current password", :with => password
  fill_in "New password", :with => confirmation
  fill_in "Confirm new password", :with => repeat_confirmation
  click_button "Change"
end