class AnalyticsController < AdminController

  def stats

    @agents = Tracking.select("DISTINCT(user_agent)")

  end

end