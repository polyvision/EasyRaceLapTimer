import alt from '../alt';
var PilotAPI = require('../util/pilot_api.js');
var PilotsStore = require('../stores/pilots_store.js');

class PilotActions {
  list(){
    var self = this;
    PilotAPI.list(function(err,result){
      if(!err){
        self.dispatch(result.body);
      }
    });
  }

}

export default alt.createActions(PilotActions);
