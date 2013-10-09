class DataTypesData < ActiveRecord::Migration
  def change

    DataType.create :name => 'Integer'
    DataType.create :name => 'Decimal'
    DataType.create :name => 'String'
    DataType.create :name => 'TimeStamp'
    DataType.create :name => 'Date'
    DataType.create :name => 'Bool'
    DataType.create :name => 'Json'
    DataType.create :name => 'Hora'

  end
end
