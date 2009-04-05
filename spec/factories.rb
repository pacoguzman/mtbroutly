Factory.define :user_with_password do |u|
  u.salt '7e3041ebc2fc05a40c60028e2c4901a81035d3cd'
  u.crypted_password '00742970dc9e6319f8019fd54864d3ea740f04b1'
  u.activation_code '8f24789ae988411ccf33ab0c30fe9106fab32e9a'
  u.state 'active'
  u.email {|a| "#{a.login}@example.com".downcase }
end

Factory.define :user do |u|
  u.salt '7e3041ebc2fc05a40c60028e2c4901a81035d3cd'
  u.crypted_password '00742970dc9e6319f8019fd54864d3ea740f04b1'
  u.activation_code '8f24789ae988411ccf33ab0c30fe9106fab32e9a'
  u.state 'active'
  u.email {|a| "#{a.login}@example.com".downcase }
end

#tog_user
Factory.define :user_pending do |u|
  u.salt '7e3041ebc2fc05a40c60028e2c4901a81035d3cd'
  u.crypted_password '00742970dc9e6319f8019fd54864d3ea740f04b1'
  u.activation_code '8f24789ae988411ccf33ab0c30fe9106fab32e9a'
  u.state 'pending'
  u.email {|a| "#{a.login}@example.com".downcase }
end

Factory.define :route do |r|
  r.title "Ruta por defecto"
  r.description "Descripción ruta por defecto"
  #r.user{|user| user.association :user, :login => 'chavez'}
end

Factory.define :waypoint do |r|
  r.lat "40.2910772956"
  r.lng "-3.7874883413"
  r.alt "0.0"
end

Factory.define :near_waypoint, :class => Waypoint do |r|
  r.lat "40.2950772956"
  r.lng "-3.7824883413"
  r.alt "0.0"
end

#tog_core
Factory.define :profile do |p|
end

Factory.define :group do |g|
  g.state 'pending'
end

#tog_conversation
Factory.define :blog do |u|
end

Factory.define :bloggership do |u|
end

Factory.define :post do |p|
end

Factory.define :rate do |r|
end