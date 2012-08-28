class Chat.MessageContentView extends Batman.View

  ready: ->
    node = jQuery(@get('node'))
    node.focus()