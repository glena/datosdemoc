class DataType < ActiveRecord::Base

  def self.get_string
    where(:name => :String).first
  end

  def self.get_manager type
    managers = {
      'Integer' => DataTypeManagerInteger,
      'Decimal' => DataTypeManagerDecimal,
      'String' => DataTypeManagerString,
      'TimeStamp' => DataTypeManagerString,
      'Date' => DataTypeManagerString,
      'Bool' => DataTypeManagerBool,
      'Json' => DataTypeManagerString,
      'Hora' => DataTypeManagerString
    }

    managers[type.name].new
  end
end
