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

#include <QtCore/QCoreApplication>
#include <stdio.h>
#include <QProcess>
#include <QTextStream>
#include <QDebug>
#include <curl/curl.h>

#ifndef __APPLE__
    #include <wiringPi.h>
#else
    #define millis() (0)
    #define micros() (0)
#endif

#define BIT_SET(a,b) ((a) |= (1<<(b)))
#define BIT_CLEAR(a,b) ((a) &= ~(1<<(b)))
#define BIT_FLIP(a,b) ((a) ^= (1<<(b)))
#define BIT_CHECK(a,b) ((a) & (1<<(b)))

#define	IR_LED_1	1

#define PULSE_ONE	500
#define PULSE_MIN 100
#define PULSE_MAX 1000

#define DATA_BIT_LENGTH 7

int sensor_state[1];
unsigned int sensor_pulse[1];
unsigned int sensor_start_lap_time[1];
QList<int> sensor_data[1];

void post_request(int token,unsigned int lap_time){
    CURL *curl;
    CURLcode res;

    curl = curl_easy_init();
      if(curl) {
        /* First set the URL that is about to receive our POST. This URL can
           just as well be a https:// URL if that is what should receive the
           data. */
        curl_easy_setopt(curl, CURLOPT_URL, QString("http://localhost:3000/api/v1/lap_track/create?transponder_token=%1&lap_time_in_ms=%2").arg(token).arg(lap_time).toStdString().c_str());



        /* Perform the request, res will get the return code */
        res = curl_easy_perform(curl);
        /* Check for errors */
        if(res != CURLE_OK){
            fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
        }


        /* always cleanup */
        curl_easy_cleanup(curl);
      }
}

void print_binary_list(QList<int>& list){
	for(int i=0; i < list.length(); i++){
		if(list[i] == 1){
			printf("1");
		}else{
			printf("0");
		}
	}
	printf("\n");
}

void push_to_service(QList<int>& list,unsigned int delta_time,int control_bit){
	unsigned int val_to_push = 0;
	print_binary_list(list);
	
	list.removeFirst();
	list.removeFirst();
	list.removeLast();
	//printf("list length: %i\n",list.length());
	for(int i=0; i < list.length(); i++){
		if(list[i] == 1){
			BIT_SET(val_to_push,list.length() - i -1);
		}else{
			BIT_CLEAR(val_to_push,list.length() -i - 1 );
		}
	}
	
	//printf("after: ");
	//print_binary_list(list);
	//qDebug() << "result binary:" << QString::number(val_to_push,2) << "\n";
	
	if(control_bit == (int)val_to_push % 2){
		printf("token: %u time: %u\n",val_to_push,delta_time);
        post_request(val_to_push,delta_time); // this sends the request to the rails web app
	}else{
		printf("control bit wrong: %i token: %u\n",control_bit,val_to_push);
	}
}

void push_bit_to_sensor_data(unsigned int pulse_width,int sensor_i){
	if(pulse_width >= PULSE_ONE){
		
		sensor_data[sensor_i] << 1;
		//printf("ONE %i\n",pulse_width);
	}else{
		
		//printf("ZERO %i\n",pulse_width);
		sensor_data[sensor_i] << 0;
	}
	
	if(sensor_data[sensor_i].length() == DATA_BIT_LENGTH){
		// first two bytes have to be zero
		if(sensor_data[sensor_i][0] == 0 && sensor_data[sensor_i][1] == 0){
			//print_binary_list(sensor_data[sensor_i]);
			
			
			// check if there's a tracked time for the current sensor_data
			// if yes, push it
			if(sensor_start_lap_time[sensor_i] != 0)
			{
				push_to_service(sensor_data[sensor_i],millis() - sensor_start_lap_time[sensor_i],sensor_data[sensor_i].last());
				sensor_start_lap_time[sensor_i] = 0;
			}
			else
			{
				sensor_start_lap_time[sensor_i] = millis();
			}
			
			sensor_data[sensor_i].clear();
		}else{
			sensor_data[sensor_i].removeFirst();
		}
	}
}

int main(int argc, char *argv[])
{
    QTextStream qout(stdout);
    QCoreApplication a(argc, argv);
    curl_global_init(CURL_GLOBAL_ALL);

    printf("starting ir_daemon\n");

#ifndef __APPLE__
	wiringPiSetup () ;
    pinMode(IR_LED_1,INPUT);
#else
    // just for testing on osx
    post_request(12,1000);
    return 0;
#endif

	sensor_state[0] = 0;
	sensor_pulse[0] = 0;
	sensor_start_lap_time[0] = 0;
	
	while(1){
        #ifndef __APPLE__
            int state = digitalRead(IR_LED_1);
        #else
            int state = 0;
        #endif
		if(state != sensor_state[0]){
			sensor_state[0] = state;
			unsigned int c_time = micros();
			unsigned int c_pulse = c_time - sensor_pulse[0];
			
			//printf("pulse %i\n",c_pulse);
			if(c_pulse >= PULSE_MIN && c_pulse <= PULSE_MAX){
				push_bit_to_sensor_data(c_pulse,0);
			}else{
				sensor_data[0].clear();
			}
			sensor_pulse[0] = c_time;
		}
	}

    curl_global_cleanup();
    return a.exec();
}
