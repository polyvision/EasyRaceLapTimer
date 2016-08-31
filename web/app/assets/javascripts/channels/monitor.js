App.cable.subscriptions.create('MonitorChannel', {
  received: function(data) {
    // process data
    console.log(data);
  }
});
