App.messages = App.cable.subscriptions.create "MonitorUpdateChannel",
  received: (data) ->
    if data.type == "updated_stats"
      $.get "/monitor/view", ( data ) ->
        $( "#monitor_view" ).html( data )
