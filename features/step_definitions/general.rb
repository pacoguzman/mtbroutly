When /^I surf to (.*)$/ do |action|
  case action
  when 'forgot password'
    When "I want to remember my password"
  end
end

Given /there (?:is|are) (\d+)(?:\s*|\s*more\s*)(\S*)?$/ do |n, object|
  klass = object.singularize.classify.constantize
  n.to_i.times {Factory "#{klass.name.downcase}_create".to_sym}
  klass.count.should >= (n.to_i)
end

When /^I visit (.*)$/ do |url|
  visit url
end

Then /^I should see a confirmation$/ do
  response.should have_flash
  response.flash.keys == [:notice]
end

Then /^I should see an error$/ do
  response.should have_flash
  response.flash.keys == [:error]
end

Then /^I should see an error explanation$/ do 
  response.should have_tag("div.errorExplanation")
end

Then /^I should see a form$/ do 
  response.should have_tag("form")
end

#wewbrat steps extensions
Then /^I fill in field named "([^\"]*)" with "([^\"]*)"$/ do |field, value|
  # FIXME búsqueda de continido de input fields por el nombre
  fill_in(field, :with => value)
end

Then /^the field named "([^\"]*)" should contain "([^\"]*)"$/ do |field, value|
  field_named(field).value.should =~ /#{value}/
end

Then /^the field named "([^\"]*)" should not contain "([^\"]*)"$/ do |field, value|
  field_named(field).value.should_not =~ /#{value}/
end

