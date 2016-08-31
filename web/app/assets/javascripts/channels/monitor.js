App.cable.subscriptions.create('MonitorChannel', {
  received: function(data) {
    // process data
    $("#monitor_view").html(data.html);
  }
});
