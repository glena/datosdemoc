class CreateDataCollections < ActiveRecord::Migration
  def change
    create_table :data_collections do |t|
      t.string :name
      t.text :description
      t.string :institution
      t.references :country, index: true
      t.references :province, index: true
      t.references :city, index: true
      t.string :collection_name

      t.timestamps
    end
  end
end
