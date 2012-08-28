window.Chat = class Chat extends Batman.App

  Batman.ViewStore.prefix = 'assets/views'

  # routing
  @resources 'users', 'messages'
  @root 'messages#index'

  @on 'run', ->
    Chat.preloadViews()
    console?.log "Running ...."

  @on 'ready', ->
    console?.log "Chat ready for use."

  @flash: Batman()
  @flash.accessor
    get: (key) -> @[key]
    set: (key, value) ->
      @[key] = value
      if value isnt ''
        setTimeout =>
          @set(key, '')
        , 2000
      value

  @flashSuccess: (message) -> @set 'flash.success', message
  @flashError: (message) ->  @set 'flash.error', message
