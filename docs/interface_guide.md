![alt text](http://www.easyracelaptimer.com/wp-content/uploads/2016/01/easy_race_lap_timer_logo-1.png "EasyRaceLapTimer")

# Website pages and functions

This guide will walk you through the pages and functions of the EasyRaceLapTimer website interface.

When you go to the web interface (usually through http://192.168.42.1), you'll see this screen:

![alt text](http://www.jazzman251.com/EasyRaceLapTimer/main.jpg "main")

## Login

You can login by clicking the Login button on top.
Default admin login info is:

Email: admin@easyracelaptimer.com 
Password: defaultpw

After you logged in as admin, you'll see this screen:

![alt text](http://www.jazzman251.com/EasyRaceLapTimer/afterlogin.jpg "afterlogin")

Let's walk through the different pages.

## Race Director

On the Race Director page, you have control over the race in progress. You can start/stop races, check the latest detected Transponder ID, fastest laps, number of laps per pilot, etc.

## Configuration

### System

The System page allows you to:

* start Standard Race Tracking
* start a Competition Race (more advanced options)
* go to Pilots and Sound Configuration
* set some configuration values
* upload your own logo 
* shutdown the Raspberry Pi

### Users

The Users page allows you to create, edit and remove user profiles. You can also assign roles to users (admin/race director).

![alt text](http://www.jazzman251.com/EasyRaceLapTimer/users.jpg "users")

### Pilots

On the Pilots page allows you to add, remove and edit pilots info. 

![alt text](http://www.jazzman251.com/EasyRaceLapTimer/pilots.jpg "pilots")

* To add a pilot, fill in his/her Name, Transponder Token, Quad name and press Create.
* To remove a pilot, click the Delete button behind the pilots info in the list.
* To edit a pilots info, click the Edit button behind the pilots info in the list.
* You can remove the Transponder Token from the pilot by clicking the Remove Token button.

There is also the option to add an avatar to each pilot. This can be done by clicking the Edit button after adding the pilot to the list.


### Soundeffects

On the Pilots page allows you to adjust the audio Volume by pressing the buttons. You can also test the audio by pressing the Play Test Sound button.

![alt text](http://www.jazzman251.com/EasyRaceLapTimer/soundeffects.jpg "soundeffects")

You can also upload your own Race Event Soundeffects by clicking the Upload Wav button after every audio event listed.

## Monitor

The Monitor page allows everyone (pilots/audience) to follow the timing. It shows fastest laptime, last laptime, number of laps, average laptime per pilot.

## History

On the History page, you have an overview of all sessions. Each session shows some brief info like the name, mode, number of pilots, number of laps, fastest lap, fastest pilot and the average laptime of the session.

Behind each session row, you have the option to delete the session from history or export the results as a PDF-document.

