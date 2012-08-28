class Chat.User extends Batman.Model
  @resourceName: 'user'
  @storageKey: 'users'
  @persist Batman.RailsStorage

  # fields
  @encode 'name'
  @encode 'created_at', 'updated_at', Batman.Encoders.railsDate

  # validations
  @validate 'name', presence: true

  # associations
  @hasMany 'messages', { saveInline: false }