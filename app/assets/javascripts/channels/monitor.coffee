App.messages = App.cable.subscriptions.create "MonitorUpdateChannel",
  received: (data) ->
    console.log(data)
