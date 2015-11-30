import alt from '../alt';
import PilotActions from '../actions/pilot_action.js'

class PilotsStore {
  constructor() {
    this.bindAction(PilotActions.list, this.onList);

    this.data = [];
  }

  onList(data) {
    this.setState({ data: data });
  }

}

export default alt.createStore(PilotsStore, 'PilotsStore');
