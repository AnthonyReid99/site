FlowRouter.route '/',
  name: 'Home'
  meta:
    title: "Home"

  action: ->
    BlazeLayout.render 'MainLayout',
      content: 'Home'


Template.Home.events

  'click .nav-item': (event) ->
    routeName = $(event.currentTarget).data 'route'
    if routeName
      FlowRouter.go FlowRouter.path(routeName)
