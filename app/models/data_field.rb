class DataField < ActiveRecord::Base
  belongs_to :data_collection
  belongs_to :data_type

  validates_presence_of :data_type, :message => 'Es necesario definir el tipo de datos'
  validates_presence_of :name, :message => 'Es necesario definir el nombre del campo'

end
