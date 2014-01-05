class CreateApiUses < ActiveRecord::Migration
  def change
    create_table :api_uses do |t|
      t.references :user, index: true
      t.date :day
      t.integer :calls

      t.timestamps
    end
  end
end
