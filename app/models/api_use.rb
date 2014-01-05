class ApiUse < ActiveRecord::Base
  belongs_to :user

  def self.can_use user

    return false if user.nil?

    day = Date.today

    use = self.where(:user => user, :day => day).first

    if use.nil?
      use = ApiUse.new
      use.user = user
      use.day = day
      use.calls = 0
    end

    use.calls = use.calls + 1

    use.save

    return (use.calls <= 100)

  end
end
