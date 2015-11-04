#= require cable
#= require_self
#= require_tree .

@App = {}
App.cable = Cable.createConsumer 'ws://127.0.0.1:28080'
