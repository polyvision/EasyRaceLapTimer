'use strict';

var PilotsStore = require('../stores/pilots_store.js');
var PilotsActions = require('../actions/pilot_action.js');
var RaceSessionCompetitionDialogEntryComponent = require('../components/race_session_competition_dialog_entry_component.jsx');


var RaceSessionCompetitionDialogComponent = React.createClass({
  getInitialState: function(){
      return {pilots_data: [],pilots_listing: []};
  },

  componentDidMount: function(){
    PilotsStore.listen(this._handleStoreUpdate);

    PilotsActions.list(); // fetch the pilots list
  },

  _handleStoreUpdate: function(){
    this.setState({pilots_data: PilotsStore.getState().data});
  },

  _addPilot: function(){
    var v = $("#pilot_comp_selection").val();

    var t_pilots_listing = this.state.pilots_listing;

    for(var i = 0; i < this.state.pilots_data.length; i++){
      if(this.state.pilots_data[i].id == parseInt(v,10)){
        t_pilots_listing.push(this.state.pilots_data[i]);
        this.setState({pilots_listing: t_pilots_listing});
      }
    }
  },

  _removePilot: function(id){
    var t_pilots_listing = this.state.pilots_listing;
    var new_pilots_listing = [];
    for(var i = 0; i < t_pilots_listing.length; i++){
      if(t_pilots_listing[i].id != parseInt(id,10)){
        new_pilots_listing.push(t_pilots_listing[i]);

      }
    }
    this.setState({pilots_listing: new_pilots_listing});
  },

  _changePilotToken: function(id,token){
    var t_pilots_listing = this.state.pilots_listing;

    for(var i = 0; i < t_pilots_listing.length; i++){
      if(t_pilots_listing[i].id != parseInt(id,10)){
        t_pilots_listing[i] = token;
      }
    }
    this.setState({pilots_listing: t_pilots_listing});
  },

  render: function(){
    var select_content = this.state.pilots_data.map(function(entry){
      return (<option value={entry.id}>{entry.name} - {entry.quad}</option>)
    }.bind(this));

    var table_content = this.state.pilots_listing.map(function(entry){
      return (<RaceSessionCompetitionDialogEntryComponent pName={entry.name} pQuad={entry.quad} pTransponderToken={entry.transponder_token} id={entry.id} onChangeToken={this._changePilotToken} onRemove={this._removePilot}></RaceSessionCompetitionDialogEntryComponent>)
    }.bind(this));

    return (
      <div>
        <select id="pilot_comp_selection" className="form-control">{select_content}</select>
        <button onClick={this._addPilot} className="btn">Add</button>

        <table className="table table-striped">
          <thead>
            <tr>
              <th>Pilot</th>
              <th>Transponder</th>
              <th>Quad</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {table_content}
          </tbody>
        </table>
        <button className="btn btn-primary btn-warning">start competition</button>
      </div>);
  }
});

module.exports = RaceSessionCompetitionDialogComponent;
