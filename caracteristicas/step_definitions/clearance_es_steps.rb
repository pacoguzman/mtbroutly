
 

 

#When /^session is cleared$/ do
#  request.session[:user_id] = nil
#end
 
# Emails
 
#Then /^a confirmation message should be sent to "(.*)"$/ do |email|
#  user = User.find_by_email(email)
#  sent = ActionMailer::Base.deliveries.first
#  assert_equal [user.email], sent.to
#  assert_match /confirm/i, sent.subject
#  assert !user.token.blank?
#  assert_match /#{user.token}/, sent.body
#end


#When /^I follow the confirmation link sent to "(.*)"$/ do |email|
#  user = User.find_by_email(email)
#  visit new_user_confirmation_path(:user_id => user, :token => user.token)
#end
 
#Then /^a password reset message should be sent to "(.*)"$/ do |email|
#  user = User.find_by_email(email)
#  sent = ActionMailer::Base.deliveries.first
#  assert_equal [user.email], sent.to
#  assert_match /password/i, sent.subject
#  assert !user.token.blank?
#  assert_match /#{user.token}/, sent.body
#end
 
#When /^I follow the password reset link sent to "(.*)"$/ do |email|
#  user = User.find_by_email(email)
#  visit edit_user_password_path(:user_id => user, :token => user.token)
#end
 
#When /^I try to change the password of "(.*)" without token$/ do |email|
#  user = User.find_by_email(email)
#  visit edit_user_password_path(:user_id => user)
#end
 
#Then /^I should be forbidden$/ do
#  assert_response :forbidden
#end
 
 
# Actions
 
#When /^I sign out$/ do
#  visit '/session', :delete
#end
 
#When /^I request password reset link to be sent to "(.*)"$/ do |email|
#  When %{I go to the password reset request page}
#  And %{I fill in "Email address" with "#{email}"}
#  And %{I press "Reset password"}
#end
 
#When /^I update my password with "(.*)\/(.*)"$/ do |password, confirmation|
#  And %{I fill in "Choose password" with "#{password}"}
#  And %{I fill in "Confirm password" with "#{confirmation}"}
#  And %{I press "Save this password"}
#end
 


