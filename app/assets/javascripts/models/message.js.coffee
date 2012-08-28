class Chat.Message extends Batman.Model
  @resourceName: 'message'
  @storageKey: 'messages'
  @persist Batman.RailsStorage

  # fields
  @encode 'user_id', 'content'
  @encode 'created_at', 'updated_at', Batman.Encoders.railsDate

  # validations
  @validate 'user_id', presence: true
  @validate 'content', presence: true

  # associations
  @belongsTo 'user', { inverseOf: 'messages'}