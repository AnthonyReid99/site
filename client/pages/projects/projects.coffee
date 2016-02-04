FlowRouter.route '/projects',
  name: 'Projects'
  meta:
    title: "Projects"

  subscriptions: ->
    this.register 'PublishedProjects', Meteor.subscribe('PublishedProjects')
    this.register 'ProjectLabels', Meteor.subscribe('ProjectLabels')
    this.register 'Labels', Meteor.subscribe('Labels')
    this.register 'Users', Meteor.subscribe('Users')

  action: ->
    BlazeLayout.render 'MainLayout',
      content: 'ProjectsPage'


Template.ProjectsPage.helpers

  'projects': ->
    q =
      status: 'published'
    options =
      sort:
        createdAt: -1
    Collection.Project.find q, options


Template.ProjectPosting.helpers

  'author': ->
    Meteor.users.findOne(@creator)?.username or 'unknown'

  'postedOnDate': ->
    moment(@createdAt).format 'MMM D YYYY @ h:mA'

  'label': ->
    Collection.Label.findOne @labelId
