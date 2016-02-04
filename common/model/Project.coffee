@Collection.Project = new Meteor.Collection('Project')

@Model.Project = Astronomy.Class
  name: 'Project'
  collection: @Collection.Project
  transform: true

  behaviors: [
    'timestamp'
  ]

  relations:
    projectLabels:
      type: 'many'
      class: 'ProjectLabel'
      local: '_id'
      foreign: 'projectId'

  fields:
    status:
      type: 'string'
      default: 'draft'
      validator: [
        Validators.required()
        Validators.choice ['draft', 'published']
      ]
    name:
      type: 'string'
      default: ''
      validator: Util.optional Validators.string()
    description:
      type: 'string'
      default: ''
      validator: Util.optional Validators.string()
    remoteUrl:
      type: 'string'
      default: ''
      validator: Util.optional Validators.string()
    creator:
      type: 'string'
      validator: [
        Validators.required()
        Validators.string()
      ]


  methods:

    hasLabel: (labelId) ->
      labelId in _.pluck @projectLabels().fetch(), 'labelId'

    labels: ->
      Collection.Label.find
        _id:
          $in: _.pluck @projectLabels().fetch(), 'labelId'


@Model.Project.current = ->
  Collection.Project.findOne Session.get('currentProjectId')


@Collection.ProjectLabel = new Meteor.Collection('ProjectLabel')

@Model.ProjectLabel = Astronomy.Class
  name: 'ProjectLabel'
  collection: @Collection.ProjectLabel
  transform: true

  fields:
    labelId:
      type: 'string'
    projectId:
      type: 'string'
