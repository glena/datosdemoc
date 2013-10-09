class DataType < ActiveRecord::Base
  def self.get_string
    where(:name => :String).first
  end
end
