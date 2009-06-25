require 'digest/sha1'
class User < ActiveRecord::Base

  has_many :comments

  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :login, :message => I18n.t("tog_user.model.login_required")
  validates_presence_of     :email, :message => I18n.t("tog_user.model.email_required")
  validates_presence_of     :password,                   :if => :password_required?, :message => I18n.t("tog_user.model.password_required")
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?, :message => I18n.t("tog_user.model.password_mismatch")
  validates_length_of       :login,    :within => 3..40, :message => I18n.t("tog_user.model.login_to_short")
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :case_sensitive => false, :message => I18n.t("tog_user.model.login_in_use")
  validates_uniqueness_of   :email, :case_sensitive => false, :message => I18n.t("tog_user.model.email_in_use")
  before_save :encrypt_password  

  after_create :send_activation_request
  after_save :send_activation_or_reset_mail
  
  named_scope :admin, :conditions => {:admin => true}
  named_scope :active, :conditions => {:state => 'active'}

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation

  acts_as_state_machine :initial => :pending
  state :passive
  state :pending, :enter => :make_activation_code
  state :active,  :enter => :do_activate
  state :suspended
  state :deleted, :enter => :do_delete

  event :register do
    transitions :from => :passive, :to => :pending, :guard => Proc.new {|u| !(u.crypted_password.blank? && u.password.blank?) }
  end

  event :activate do
    transitions :from => :pending, :to => :active
  end

  event :suspend do
    transitions :from => [:passive, :pending, :active, :deleted], :to => :suspended
  end

  event :delete do
    transitions :from => [:passive, :pending, :active, :suspended], :to => :deleted
  end

  event :unsuspend do
    transitions :from => :suspended, :to => :active,  :guard => Proc.new {|u| !u.activated_at.blank? }
    transitions :from => :suspended, :to => :pending, :guard => Proc.new {|u| !u.activation_code.blank? }
    transitions :from => :suspended, :to => :passive
  end
  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    if Tog::Config["plugins.tog_user.email_as_login"]
      login_column = :email
    else
      login_column = :login
    end
    u = find_in_state :first, :active, :conditions => { login_column => login} # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  def make_activation_code
    return if self.activation_code
    self.deleted_at = nil
    self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end

  def forgot_password
    @forgotten_password = true
    self.make_password_reset_code
  end

  def reset_password
    # First update the password_reset_code before setting the
    # reset_password flag to avoid duplicate email notifications.
    update_attribute(:password_reset_code, nil)
    @reset_password = true
  end

  #used in user_observer
  def recently_forgot_password?
    @forgotten_password
  end

  def recently_reset_password?
    @reset_password
  end

  def recently_activated?
    @activated
  end

  def self.find_for_forget(email)
    find :first, :conditions => ['email = ? and activation_code IS NULL', email]
  end
  
  def self.site_search(query, search_options={})
    active.find :all, :conditions => ["login like :query", { :query => "%#{query}%" }]
  end
  
  protected
  # before filter
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.crypted_password = encrypt(password)
  end

  def make_password_reset_code
    self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    save(false)
  end

  def password_required?
    crypted_password.blank? || !password.blank?
  end

  def do_delete
    self.deleted_at = Time.now.utc
  end

  def do_activate
    @activated = true
    self.activated_at = Time.now.utc
    self.deleted_at = self.activation_code = nil
  end
  def send_activation_request
    UserMailer.deliver_signup_notification(self)
  end
  
  def send_activation_or_reset_mail
    UserMailer.deliver_activation(self) if self.recently_activated?
    UserMailer.deliver_reset_notification(self) if self.recently_forgot_password?       
  end
  
end
