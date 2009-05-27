class Event < ActiveRecord::Base

  has_one :waypoint, :as => :locatable, :dependent => :destroy
  
  protected
  #TODO comprobar bien que se localiza con GG o se les pasa un lat lng de un waypoint
  def validate
    if (start_date > end_date || (start_date == end_date && start_time >= end_time))
      errors.add("end_date", I18n.t("tog_conclave.fields.errors.end_date_before_start_date"))
    end
    loc = gg.locate self.venue_address rescue nil
    #errors.add("venue_address", I18n.t("tog_conclave.fields.errors.venue_address_error")) if loc.nil?
  end
end
