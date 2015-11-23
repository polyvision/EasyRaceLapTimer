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
#ifndef RESTART_BUTTON_INPUT_H
#define RESTART_BUTTON_INPUT_H

class RestartButtonInput{
	
	public:
		RestartButtonInput(int pin);
		void update();
	private:		
		int 	m_iInputPin;
		unsigned int m_uiPushedButtonTime;
		unsigned int m_uiPushedButtonLastAt;
		bool		m_bActive;
};
#endif