FlowRouter.route '/admin',
  name: 'Admin'
  meta:
    title: "Admin"

  subscriptions: ->
    this.register 'BlogPosts', Meteor.subscribe('BlogPosts')
    this.register 'BlogPostLabels', Meteor.subscribe('BlogPostLabels')
    this.register 'Users', Meteor.subscribe('Users')
    this.register 'Labels', Meteor.subscribe('Labels')
    this.register 'Projects', Meteor.subscribe('Projects')
    this.register 'ProjectLabels', Meteor.subscribe('ProjectLabels')

  action: ->
    BlazeLayout.render 'MainLayout',
      content: 'Admin'


Template.Admin.onRendered ->
  $('.collapsible').collapsible()
