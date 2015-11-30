'use strict';

var PilotsStore = require('../stores/pilots_store.js');
var PilotsActions = require('../actions/pilot_action.js');

var RaceSessionCompetitionDialogEntryComponent = React.createClass({
  getInitialState: function(){
      return {token: this.props.pTransponderToken};
  },

  componentDidMount: function(){
  },

  clickedRemove: function(){
    this.props.onRemove(this.props.id);
  },

  changePilotToken: function(e){
    this.setState({token: e.val});
    this.props.onChangeToken(this.props.id,e.val);
  },

  render: function(){


    return (
      <tr>
        <td>
          {this.props.pName}
        </td>
        <td>
          <input value={this.state.token} onChange={this.changePilotToken}></input>
        </td>
        <td>
          {this.props.pQuad}
        </td>
        <td>
          <button onClick={this.clickedRemove} className="btn btn-warning">Remove</button>
        </td>
      </tr>);
  }
});

module.exports = RaceSessionCompetitionDialogEntryComponent;
