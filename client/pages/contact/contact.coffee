FlowRouter.route '/contact',
  name: 'Contact'
  meta:
    title: "Contact"

  action: ->
    BlazeLayout.render 'MainLayout',
      content: 'Contact'
