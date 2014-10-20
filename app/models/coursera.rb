require 'date'
require 'active_support/core_ext'

class Coursera
  include HTTParty

  base_uri 'https://api.coursera.org/'

  class << self

    def courses
      sessions = get_json('sessions', fields: [:courseId, :active, :durationString, :startDay, :startMonth, :startYear])
      courses = get_json('courses', fields: [:smallIcon])
      course_elements = courses['elements']

      sessions['elements'] = sessions['elements'].map do |session|
        duration = session['durationString'].split.first.to_i
        date = [session['startDay'], session['startMonth'], session['startYear']]

        unless date.include? nil
          course = course_elements.select { |course| course['id'] == session['courseId'] }.first

          start_date = Date.parse(date.join('/'))
          end_date = start_date + duration.weeks

          session['startDate'] = start_date
          session['endDate'] = end_date
          session['name'] = course['name']
          session['icon'] = course['smallIcon']
        end

        session
      end

      sessions.to_json
    end

    def get_json(path, options = {})
      response = get("/api/catalog.v1/#{path}", {query: { fields: options[:fields].join(',') }})
      JSON.parse(response.body)
    end

  end
end