![alt text](http://www.airbirds.de/wp-content/uploads/2015/11/logo_big.png "EasyRaceLapTimer")

cd
git pull origin master

cd ir_daemon
qmake ir_daemon.pro

cd web
bundle
RAILS_ENV=production rake db:migrate
RAILS_ENV=production rake assets:precompile
