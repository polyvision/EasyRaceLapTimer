App.cable.subscriptions.create('RaceBoxReceiverChannel', {
  received: function(data) {
    // process data

    $("#"+data.receiver_data.name+"_current_rssi").html(data.receiver_data.current_rssi);
    $("#"+data.receiver_data.name+"_saved_rssi").val(data.receiver_data.saved_rssi);
  }
});
