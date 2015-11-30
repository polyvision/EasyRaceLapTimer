var request = require('superagent');
var PilotApi = {};

// retrieves a list of all pilots
PilotApi.list = function(callback){

  request.get("/api/v1/pilot")
    .send()
    .set('Content-Type', 'application/json')
    .end(function(err,result){
      callback(err,result);
    })
}

module.exports = PilotApi;
