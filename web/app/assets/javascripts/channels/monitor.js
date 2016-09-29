App.cable.subscriptions.create('MonitorChannel', {
  received: function(data) {
    // process data
    if(document.getElementById("monitor_view") !== null){
      $("#monitor_view").html(data.html);
    }

    console.log("bla");
    if(document.getElementById("visor_container") !== null){
      $("#visor_container").html(data.html);
      $(".visor_hide").hide();
    }
  }

});
