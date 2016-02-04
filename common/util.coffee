if Meteor.isClient
  Template.registerHelper 'classIfTrue', (predicate, cssClass) ->
    if predicate then cssClass
