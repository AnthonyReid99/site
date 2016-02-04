@Collection.Label = new Meteor.Collection('Label')

@Model.Label = Astronomy.Class
  name: 'Label'
  collection: @Collection.Label
  transform: true

  fields:
    text:
      type: 'string'
      validator: [
        Validators.required()
        Validators.string()
      ]
    color:
      type: 'string'
      validator: [
        Validators.required()
        Validators.string()
      ]
