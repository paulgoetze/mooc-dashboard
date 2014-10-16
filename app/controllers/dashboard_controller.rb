class DashboardController < ApplicationController

  def index
    @sessions = Coursera.courses
  end
end