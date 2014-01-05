class DataField < ActiveRecord::Base
  belongs_to :data_collection
  belongs_to :data_type

  validates_presence_of :data_type, :message => 'Es necesario definir el tipo de datos'
  validates_presence_of :name, :message => 'Es necesario definir el nombre del campo'

  def self.get_types_hash data_collection
    types_hash = {}
    fields = self.where(:data_collection => data_collection)

    fields.each do |field|
      types_hash[field.name] = DataType.get_manager(field.data_type)
    end

    types_hash
  end
end
