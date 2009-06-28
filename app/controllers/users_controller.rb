class UsersController < ApplicationController
  layout "sessions"

  def create
    # cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.login ||= @user.email if Tog::Config["plugins.tog_user.email_as_login"]
    
    captcha_validated = Tog::Config["plugins.tog_user.captcha_enabled"] ? verify_recaptcha(@user) : true
    
    # If there is no users yet, set the first one to admin.
    @user.admin = User.find(:all).blank?
    
    @user.register! if captcha_validated && @user.valid?
    if @user.errors.empty?
      redirect_back_or_default(Tog::Config["plugins.tog_user.default_redirect_on_signup"])
      flash[:notice] = I18n.t("tog_user.user.sign_up")
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again." #ADDED a TOG
      render :action => 'new'
    end
  end
  
  def resend_activation
    if current_user
      UserMailer.deliver_signup_notification(current_user)
      flash[:notice] = I18n.t("tog_user.user.activation_resent")
    end
    redirect_to root_path
  end
  
  def activate
    # Added case a TOG
    self.current_user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && logged_in? && !current_user.active?
      current_user.activate!
      flash[:notice] = I18n.t("tog_user.user.sign_up_completed")
      redirect_back_or_default(Tog::Config["plugins.tog_user.default_redirect_on_activation"])
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end

  end

  def forgot
    if request.post?
      if @user = User.find_by_email(params[:user][:email])
        @user.forgot_password
        flash[:notice] = I18n.t("tog_user.user.password_reset_sent", :email => @user.email)
      else
        flash[:error] = I18n.t("tog_user.user.password_reset_not_found", :email => params[:user][:email])
      end
      redirect_back_or_default(Tog::Config["plugins.tog_user.default_redirect_on_forgot"])
    end
  end
  
  def reset
    @user = User.find_by_password_reset_code(params[:reset_code]) unless params[:reset_code].nil?
    if request.post?
      if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
        @user.reset_password
        self.current_user = @user
        flash[:ok] = I18n.t("tog_user.user.password_updated", :email => @user.email)
        redirect_back_or_default(Tog::Config["plugins.tog_user.default_redirect_on_reset"])
      else
        render :action => :reset
      end
    end
  end

end
