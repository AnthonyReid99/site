

@Collection.BlogPost = new Meteor.Collection('BlogPost')

@Model.BlogPost = Astronomy.Class
  name: 'BlogPost'
  collection: @Collection.BlogPost
  transform: true

  behaviors: [
    'timestamp'
  ]

  relations:
    blogPostLabels:
      type: 'many'
      class: 'BlogPostLabel'
      local: '_id'
      foreign: 'blogPostId'

  fields:
    status:
      type: 'string'
      default: 'draft'
      validator: [
        Validators.required()
        Validators.choice ['draft', 'published']
      ]
    title:
      type: 'string'
      default: ''
      validator: Util.optional Validators.string()
    creator:
      type: 'string'
      validator: [
        Validators.required()
        Validators.string()
      ]
    post:
      type: 'string'
      default: ''
      validator: Util.optional Validators.string()
    tags:
      type: 'array'
      default: -> []
      validator: Util.optional Validators.array()

  methods:

    hasLabel: (labelId) ->
      labelId in _.pluck @blogPostLabels().fetch(), 'labelId'

    labels: ->
      Collection.Label.find
        _id:
          $in: _.pluck @blogPostLabels().fetch(), 'labelId'


@Model.BlogPost.current = ->
  Collection.BlogPost.findOne Session.get('currentBlogPostId')


@Collection.BlogPostLabel = new Meteor.Collection('BlogPostLabel')

@Model.BlogPostLabel = Astronomy.Class
  name: 'BlogPostLabel'
  collection: @Collection.BlogPostLabel
  transform: true

  fields:
    labelId:
      type: 'string'
    blogPostId:
      type: 'string'
