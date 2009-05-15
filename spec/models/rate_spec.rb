require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rate do

  it { should belong_to(:user) }
  it { should belong_to(:rateable) }

  it { should have_named_scope("where_user(Factory.create(:user, :login => 'chavez'))") }

end
