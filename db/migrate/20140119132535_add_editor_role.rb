class AddEditorRole < ActiveRecord::Migration
  def change
    role = Role.new
    role.name = :editor
    role.save

    user = User.where(:email=>'german.lena@gmail.com').first

    ur = UserRole.new
    ur.user = user
    ur.role = role
    ur.save
  end
end
