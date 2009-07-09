class Member::ProfilesController < Member::BaseController

  before_filter :client_ip_to_location, :only => [:edit]

  def edit
    @profile = current_user.profile(:include => [:user])
    @profile.waypoint ||= Waypoint.new(:locatable_id => @profile.id, :locatable_type => 'Profile')
  end

  def update
    profile = current_user.profile
    profile.update_attributes!(params[:profile])
    profile.save
    flash[:ok] = I18n.t("tog_social.profiles.member.updated") 
    redirect_to profile_path(profile)
  end

end