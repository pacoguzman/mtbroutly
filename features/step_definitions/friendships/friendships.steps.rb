#FIXME identificar que es un portlet de followers
Then /^I should see a "([^\"]*)" as follower$/ do |user|
  response.should.contain user

#  response.should have_selector("div.right_col" ) do |portlet|
#    portlet.should have_selector("a" , :title => user)
#  end
end
