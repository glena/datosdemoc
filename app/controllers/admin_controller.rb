class AdminController < ApplicationController

  before_action :admin_required

  def index

  end

  def admin_required
    return false if not login_required

    if not self.get_logged_user.is_admin?
      redirect_to home_path
      return false
    end

    return true
  end

end