class CoursesController < ApplicationController

  respond_to :json

  def index
    @courses = Coursera.courses
    respond_with @courses
  end
end