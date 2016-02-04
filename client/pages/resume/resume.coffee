FlowRouter.route '/resume',
  name: 'Resume'
  meta:
    title: "Resume"

  action: ->
    BlazeLayout.render 'MainLayout',
      content: 'Resume'
