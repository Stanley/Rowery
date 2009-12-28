require 'digest/md5'

class User < CouchRestRails::Document
  use_database :rowery

  unique_id :email

  attr_accessor :password, :password_confirmation

#  property :login
  property :email,            :alias => :id
  property :crypted_password
  timestamps!

#  validates_length  :login,     :within => 2..10
  validates_format  :email,     :with => :email_address
  validates_present :password
  validates_length  :password,  :within => 5..15

  validates_with_method :password_confirmation, :method => :password_is_confirmed
  validates_with_method :email,                 :method => :email_is_unique

  save_callback :before, :encode_password

  private

  def email_is_unique
    User.get(email) === nil ? true : [false, "This email is already in use"]
  end

  def password_is_confirmed
    if password == password_confirmation
      return true
    else
      return [false, "Password confirmation must be the same as password"]
    end
  end

  def encode_password
    self.crypted_password = Digest::MD5.hexdigest(password)
  end

  public

  # Returns: encoded email for gravatar.com
  def md5_email
    Digest::MD5.hexdigest(email)
  end
end
