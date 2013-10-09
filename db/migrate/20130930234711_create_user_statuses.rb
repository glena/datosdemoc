class CreateUserStatuses < ActiveRecord::Migration
  def change
    create_table :user_statuses do |t|
      t.string :name

      t.timestamps
    end

    UserStatus.create :name => 'activo'
    UserStatus.create :name => 'pendiente'
    UserStatus.create :name => 'suspendido'
  end
end
