class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password
      t.string :salt
      t.string :apikey
      t.references :user_status, index: true

      t.timestamps
    end

    status = UserStatus.where(:name => 'activo').first

    user = User.new
    user.email = 'german.lena@gmail.com'
    user.setPassword '123456','123456'
    user.generate_apikey
    user.user_status = status

    user.save
  end
end
