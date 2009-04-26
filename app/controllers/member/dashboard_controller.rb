class Member::DashboardController < Member::BaseController

  def index
    @profile = current_user.profile(:include => {:user => :groups})
    @routes = current_user.routes
    store_location
    respond_to do |format|
      format.html # index.html.erb
    end
  end

end
