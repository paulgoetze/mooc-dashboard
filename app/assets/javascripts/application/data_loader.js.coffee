class window.DataLoader

  constructor: ->
    return

  load: (callback) ->
    $.get ('/courses.json'), (data) ->
      callback(data)