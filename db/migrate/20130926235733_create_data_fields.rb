class CreateDataFields < ActiveRecord::Migration
  def change
    create_table :data_fields do |t|
      t.string :name
      t.boolean :is_filter
      t.references :data_collection, index: true
      t.references :data_type, index: true

      t.timestamps
    end
  end
end
