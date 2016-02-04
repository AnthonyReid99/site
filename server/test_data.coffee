testCollection = new Model.BlogPost
  title: 'An example post'
  author: 'abc'
  post: 'lorum titsum'
  tags: [
    {text: 'dev', color: 'blue'}
    {text: 'personal', color: 'red'}
    {text: 'meteor', color: 'teal'}
    {text: 'picture', color: 'deep-purple lighten-2'}
  ]

testCollection.save()


if not Meteor.users.find().fetch().length
  Accounts.createUser
    username: 'anthony'
    password: 'password'
