class DataType < ActiveRecord::Base

  def self.get_string
    where(:name => :String).first
  end

  def manager
     DataType.get_manager self
  end

  def self.get_manager type
    managers = {
      'Integer' => DataTypeManagerInteger,
      'Decimal' => DataTypeManagerDecimal,
      'String' => DataTypeManagerString,
      'TimeStamp' => DataTypeManagerDateTime,
      'Date' => DataTypeManagerDate,
      'Bool' => DataTypeManagerBool,
      'Json' => DataTypeManagerString,
      'Hora' => DataTypeManagerTime
    }

    managers[type.name].new
  end
end
