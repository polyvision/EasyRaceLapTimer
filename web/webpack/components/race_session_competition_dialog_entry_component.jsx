/**
 * EasyRaceLapTimer - Copyright 2015-2016 by airbirds.de, a project of polyvision UG (haftungsbeschränkt)
 *
 * Author: Alexander B. Bierbrauer
 *
 * This file is part of EasyRaceLapTimer.
 *
 * OpenRaceLapTimer is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 * OpenRaceLapTimer is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License along with Foobar. If not, see http://www.gnu.org/licenses/.
 **/
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
    this.props.onRemove(this.props.pId);
  },

  changePilotToken: function(e){
    this.setState({token: e.target.value});
    this.props.onChangeToken(this.props.pId,e.target.value);
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
