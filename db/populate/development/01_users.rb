admin = User.create_or_update(:id => 1, :login => "mtbroutly", :email => "fj.guzman.rivas@gmail.com",
 :password => "admin", :password_confirmation => "admin")
admin.activate!

pacoguzman = User.create_or_update(:id => 2, :login => "pacoguzman", :email => "pacoguzmanp@gmail.com",
 :password => "pacoguzman", :password_confirmation => "pacoguzman")
pacoguzman.activate!

vanessa = User.create_or_update(:id => 3, :login => "vanessa", :email => "vanmarliva@gmail.com",
 :password => "vanessa", :password_confirmation => "vanessa")
vanessa.activate!

dani = User.create_or_update(:id => 4, :login => "danimechon", :email => "internetesunamierda.ok@hotmail.com",
 :password => "danimechon", :password_confirmation => "danimechon")
dani.activate!

