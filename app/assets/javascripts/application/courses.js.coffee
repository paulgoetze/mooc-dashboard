class window.Courses

  constructor: (data) ->
    @data = data

  getFor: (view) ->
    data = switch view
      when '#runtimes' then @runtimes()
      when '#starting-soon' then @startingSoon()
      when '#finishing-soon' then @finishingSoon()

  startingSoon: =>
    return @coursesStartingSoon if @coursesStartingSoon
    courses = []

    for session in @data
      continue if session.active
      course = {}
      startDate = new Date(session.startDate)
      continue if isNaN(startDate.getDate())

      currentDate = $.now()
      diffDays = Math.ceil((startDate - currentDate )  / (1000 * 60 * 60 * 24))

      if diffDays > 0  && diffDays < 60 # starting in next 2 months => TODO make selectable by user!
        course.startDate = startDate.getDate() + "/" + (startDate.getMonth() + 1) + "/" + startDate.getFullYear()
        course.duration = session.durationString
        course.startsIn = diffDays
        course.link = session.homeLink
        course.name = session.name
        course.icon = session.icon

        courses.push course

    courses = _(courses).sortBy (course) -> course.startsIn
    @coursesStartingSoon = courses
    return courses

  finishingSoon: =>
    return @coursesFinishingSoon if @coursesFinishingSoon
    courses = []

    for session in @data
      continue unless session.active
      course = {}
      endDate = new Date(session.endDate)
      continue if isNaN(endDate.getDate())

      currentDate = $.now()
      diffDays = Math.ceil((endDate - currentDate )  / (1000 * 60 * 60 * 24))

      if diffDays > 0
        course.endDate = endDate.getDate() + "/" + (endDate.getMonth() + 1) + "/" + endDate.getFullYear()
        course.duration = session.durationString
        course.endsIn = diffDays
        course.link = session.homeLink
        course.name = session.name
        course.icon = session.icon

        courses.push course

    courses = _(courses).sortBy (course) -> course.endsIn
    @coursesFinishingSoon = courses
    return courses

  runtimes: =>
    return @coursesRuntimes if @coursesRuntimes
    courses = {}
    courses.years = {}

    for session in @data
      course = {}

      course.startYear = session.startYear
      course.startMonth = session.startMonth
      course.duration = session.durationString.split(' ')[0]

      if course.startYear
        courses.years[course.startYear] = {} unless courses.years[course.startYear]
        courses.years[course.startYear][course.duration] = 0 unless courses.years[course.startYear][course.duration]
        courses.years[course.startYear][course.duration] += 1

    @coursesRuntimes = courses
    return courses