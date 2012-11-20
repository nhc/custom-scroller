#
# Name    : custom-scroller
# Author  : Neil Charlton, github.com/nhc, 
# Version : 0.1
# Repo    : <repo url>
# Website : <website url>
#

class ScrollBox
  constructor: (@container, @options) ->
    @inside = @container.find('div.scroller')
    @up_arrow = @container.find('a.up')
    @down_arrow = @container.find('a.down')
    @bar = @container.find('.bar')
    @track = @container.find(@options.controls_selector)
    @setSize()
    @setPos(0)
    @bindEvents()
    @scrollbars()

  bindEvents: ->
    @up_arrow.on 'click', (e) => @scrollup(e)
    @down_arrow.on 'click', (e) => @scrolldown(e)
    @bar.on 'click', (e) => @scrollBar(e)

  scrollBar: (e) ->
    halfway = @bar.height() / 2
    ypos = e.pageY - @bar.offset().top
    if ypos > halfway 
      @down_arrow.click()
    else
      @up_arrow.click()

  setSize: ->
    @size =
      height: @inside.actual('height')
      width: @inside.actual('width')

  setPos: (num) ->
    old = if @pos then @pos.top else 0
    @pos = 
      top: old + parseInt(num)

  reset: ->
    @inside.css({position: 'absolute'}).animate({top:'0'},100,'swing')

  scrollup: ->
    if @pos.top < 0
      @inside.css({position: 'absolute'}).animate({top:'+='+@options.scroll_jump},100,'swing')
      @setPos @options.scroll_jump

  scrolldown: ->
    bottom =  @container.actual('height') - @size.height
    if @pos.top >= bottom
      @inside.css({position: 'absolute'}).animate({top:'-='+@options.scroll_jump},100,'swing')
      @setPos -@options.scroll_jump

  scrollbars: ->
    @setSize()
    #console.log(@container, @size.height, @container.actual('height')) // sb = $(".activity-list-box .content") = $(sb[1]).data().scrollBox.rc()

    if @size.height < @container.actual('height')
      $(@track).hide()
      @reset()
    else
      $(@track).show()


$.scrollBox = ( element, options ) ->
  # current state
  state = ''

  # plugin settings
  @defaults = 
    scroll_jump: '30'
    controls_selector: '.track'


  @rc = ->
    @sb.scrollbars()

  # jQuery version of DOM element attached to the plugin
  @$element = $ element

  # set current state
  @setState = ( _state ) -> state = _state

  #get current state
  @getState = -> state

  # get particular plugin setting
  @getSetting = ( key ) ->
    @settings[ key ]

  # call one of the plugin setting functions
  @callSettingFunction = ( name, args = [] ) ->
    @settings[name].apply( this, args )

  @init = ->
    @settings = $.extend( {}, @defaults, options )
    @setState 'ready'

    @sb = new ScrollBox(@$element, @settings)
    
  # initialise the plugin
  @init()


  # make the plugin chainable
  this

# default plugin settings
$.scrollBox::defaults =
    message: ''  # option description

$.fn.scrollBox = ( options ) ->
  this.each ->
    if $( this ).data( 'scrollBox' ) is undefined
      plugin = new $.scrollBox( this, options )
      $(this).data( 'scrollBox', plugin )