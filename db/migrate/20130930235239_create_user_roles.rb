class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.references :user, index: true
      t.references :role, index: true

      t.timestamps
    end

    user = User.first!
    Role.all.each do |role|
      UserRole.create :user => user, :role => role
    end
  end
end
