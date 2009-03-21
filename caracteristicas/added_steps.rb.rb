Dado /^que estoy logueado$/ do
  assert_not_nil request.session[:user_id]
end

Given /^que no estoy logueado$/ do
  assert_nil request.session[:user_id]
end
