class AddTrackingsSession < ActiveRecord::Migration
  def change
    add_column :trackings, :session, :string
  end
end
