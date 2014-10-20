class window.DataLoader

  load: (callback) ->
    $.get ('/courses.json'), (data) ->
      callback(data)