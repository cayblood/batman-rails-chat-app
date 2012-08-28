class Chat.MessagesController extends Batman.Controller
  routingKey: 'messages'

  setUser: =>
    unless @get('currentUserId')
      name = prompt("Please state your name")
      Chat.User.load (err, users) =>
        foundUser = false
        for user in users
          if user.get('name') == name
            @set 'currentUserId', user.get('id')
            foundUser = true
        unless foundUser
          newUser = new Chat.User(name: name)
          newUser.save()
          @set 'currentUserId', newUser.get('id')

  setUserPollingInterval: ->
    periodicUserMethod = =>
      jQuery.getJSON '/highest_user_id', '', (data, resp) =>
        previousHighestUserId = @get('previousHighestUserId') || 0
        highestUserId = parseInt(data, 10)
        if highestUserId == 0
          Chat.User.clear()
          Chat.User.load (err, results) =>
            @set 'users', results
        if highestUserId > previousHighestUserId
          Chat.User.load (err, results) =>
            @set 'users', results
          @set 'previousHighestUserId', highestUserId
    setInterval(periodicUserMethod, 5000)

  setMessagePollingInterval: ->
    periodicMessageMethod = =>
      jQuery.getJSON '/highest_message_id', '', (data, resp) =>
        previousHighestMessageId = @get('previousHighestMessageId') || 0
        highestMessageId = parseInt(data, 10)
        if highestMessageId == 0
          Chat.Message.clear()
          Chat.Message.load (err, results) =>
            @set 'messages', new Batman.Set(results...).sortedBy('created_at', 'desc')
        if highestMessageId > previousHighestMessageId
          Chat.Message.load (err, results) =>
            @set 'messages', new Batman.Set(results...).sortedBy('created_at', 'desc')
          @set 'previousHighestMessageId', highestMessageId
    setInterval(periodicMessageMethod, 5000)

  index: (params) ->
    @set 'emptyMessage', new Chat.Message
    Chat.Message.load (err, results) =>
      @set 'messages', new Batman.Set(results...).sortedBy('created_at', 'desc')
    @setUser()
    @setUserPollingInterval()
    @setMessagePollingInterval()

  create: =>
    console.log('==============================================')
    @emptyMessage.set 'user_id', @get('currentUserId')
    @emptyMessage.save =>
      @set 'emptyMessage', new Chat.Message
      Chat.Message.load (err, results) =>
        @set 'messages', new Batman.Set(results...).sortedBy('created_at', 'desc')