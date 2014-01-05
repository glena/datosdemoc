class DataCollection < ActiveRecord::Base
  belongs_to :country
  belongs_to :province
  belongs_to :city

  has_many :data_fields
  has_many :data_collection_categories

  def description_short
    description = self.description
    if not description.empty?
      if description.size > 145
        description = self.description[0..145]
        description = "#{description}..."
      end
    end
    return description
  end
end
