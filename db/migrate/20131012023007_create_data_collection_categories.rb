class CreateDataCollectionCategories < ActiveRecord::Migration
  def change
    create_table :data_collection_categories do |t|
      t.references :data_collection, index: true
      t.references :category, index: true

      t.timestamps
    end
  end
end
