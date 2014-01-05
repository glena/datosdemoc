#encoding: utf-8
require 'uuidtools'
require 'digest/sha1'

class User < ActiveRecord::Base
  belongs_to :user_status
  has_many :user_roles

  validates_uniqueness_of :email
  validates_presence_of :email, :password, :user_status
  validates_format_of :email, :with => /([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})/i, :message => "Email inválido"

  def is_admin?
    admin = Role.get_admin

    self.has_role? admin.id
  end

  def has_role? role_id
    roles = self.user_roles.map {|r| r.id}
    (not roles.index(role_id).nil?)
  end


  def get_salt
    return self.salt if not self.salt.nil?
    self.salt = UUIDTools::UUID.random_create.to_s
  end

  def generate_apikey
    if self.apikey.nil?
      unique = UUIDTools::UUID.random_create.to_s
      self.apikey =  Digest::SHA1.hexdigest("#{self.get_salt}#{unique}#{self.get_salt}#{self.email}#{self.get_salt}")
    end
  end

  def setPassword (pass, passConfirmation)
    if pass == passConfirmation && !pass.blank?
      self.password = User.encrypt(pass, self.get_salt)
      return true
    end

    return false
  end

  def self.encrypt(pass, salt)
    return Digest::SHA1.hexdigest(pass+salt)
  end

  def get_hash extra
    return Digest::SHA1.hexdigest("#{self.get_salt}#{self.id}#{self.get_salt}#{self.email}#{extra}#{self.get_salt}")
  end

  def get_signup_hash
    return self.get_hash 'signup'
  end

  def get_password_recovery_hash
    return self.get_hash 'password_recovery'
  end

  def self.authenticate(email, pass)
    u=find(:first, :conditions=>["email = ?", email])
    return nil if u.nil?
    return u if u.validate_password(pass)
    return nil
  end

  def validate_password (pass)
    return User.encrypt(pass, self.get_salt)==self.password
  end

end
