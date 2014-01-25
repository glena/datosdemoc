class AddFieldKeyFlag < ActiveRecord::Migration
  def change

    add_column :data_fields, :is_key, :boolean

  end
end
