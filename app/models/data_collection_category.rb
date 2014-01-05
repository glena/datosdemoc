class DataCollectionCategory < ActiveRecord::Base
  belongs_to :data_collection
  belongs_to :category
end
