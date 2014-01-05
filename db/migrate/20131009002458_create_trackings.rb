class CreateTrackings < ActiveRecord::Migration
  def change
    create_table :trackings do |t|
      t.timestamp :date
      t.string :referal
      t.string :url
      t.string :format
      t.string :user_agent

      t.timestamps
    end
  end
end
