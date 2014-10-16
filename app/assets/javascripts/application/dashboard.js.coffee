class Dashboard

  RUNTIMES = '#runtimes'
  STARTINGSOON = '#starting-soon'
  FINIHSINFSOON = '#finishing-soon'

  constructor: ->
    @startingSoonContainer = $(STARTINGSOON)
    @finishingSoonContainer = $(FINIHSINFSOON)
    @runtimesContainer = $(RUNTIMES)

    @views = {
      startingSoon:   @startingSoonContainer,
      finishingSoon:  @finishingSoonContainer,
      runtimes:       @runtimesContainer
    }

    @registerNavigationEvents()

    @dataLoader = new DataLoader
    showInProgress()
    @dataLoader.load(@storeData)

  registerNavigationEvents: ->
    $('.nav-link').on 'click', (event) =>
      event.preventDefault()
      id = $(event.currentTarget).children('a').attr 'href'
      @showView(id)
    return

  showView: (elementId) ->
    el = $(elementId)

    $('.nav-link').not(this).each ->
      link = $(@)
      link.removeClass 'active'
      $(link.children('a').attr 'href').addClass 'hidden'

    el.removeClass 'hidden'
    $(".nav-link a[href='#{elementId}']").parent('li').addClass 'active'

    @showContent(elementId)

  storeData: (data) =>
    @data = data.elements
    @courses = new CoursesView(@data)
    hideInProgress()
    @showContent(RUNTIMES)
    return

  showInProgress = ->
    $('.ajax-loader').hide().removeClass('hidden').fadeIn()

  hideInProgress = ->
    $('.ajax-loader').fadeOut(-> $(@).addClass('hidden'))

  showContent: (viewId) =>
    if @data
      showInProgress()
      courses = @courses.getFor(viewId)
      template = "courses/" + viewId.replace(/#/, '').replace(/-/, '_')
      content = JST[template](courses: courses)
      $(viewId).children('.courses').html(content)
      hideInProgress()
    else
      console.log "data still to receive..."

$(document).ready ->
  new Dashboard