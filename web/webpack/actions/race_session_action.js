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
import alt from '../alt';
var RaceSessionAPI = require('../util/race_session_api.js');


class RaceSessionActions {
  createCompetition(title,max_laps,pilot_data){
    // transforming pilot data in correct post data
    var pilot_post_data = [];
    for(var i = 0; i < pilot_data.length; i++){
      pilot_post_data.push({pilot_id: pilot_data[i].id,transponder_token: pilot_data[i].transponder_token});
    }

    var self = this;
    RaceSessionAPI.createCompetition(title,max_laps,pilot_post_data,function(err,result){
      if(!err){
        self.dispatch(result.body);
      }
    });
  }

}

export default alt.createActions(RaceSessionActions);
