class Profile < ActiveRecord::Base

  has_one :waypoint, :as => :locatable, :dependent => :destroy

  accepts_nested_attributes_for :waypoint, :reject_if => proc { |attr| attr['lat'].blank? || attr['lng'].blank? }
  
  def full_name
     #todo apply for internationalization
     first_name.blank? && last_name.blank? ? user.login : "#{first_name} #{last_name}".strip
  end

end