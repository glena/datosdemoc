class Role < ActiveRecord::Base
  def self.get_admin
    where(:name => :admin).first
  end
  def self.get_user
    where(:name => :caller).first
  end
end
