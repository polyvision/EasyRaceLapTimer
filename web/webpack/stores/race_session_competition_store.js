import alt from '../alt';

class RaceSessionCompetitionStore {
  constructor() {
    //this.bindAction(FunnelConfigurationActions.list, this.onList);

    this.data = [];
  }

  onList(data) {
    this.setState({ data: data });
  }

}

export default alt.createStore(RaceSessionCompetitionStore, 'RaceSessionCompetitionStore');
