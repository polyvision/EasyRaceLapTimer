 pacman --sync -y
 pacman -S qt5-base
 pacman -S git
 pacman -S python2
 pacman -S base-devel
 pacman -S apache
 pacman -S openssl
 pacman -S wiringpi
 pacman -S gcc
 pacman -S make
 pacman -S ruby
 git clone
 cd ~/EasyRaceLapTimer/ir_daemon
 qmake ir_daemon.pro
 make
 
 cd ~/EasyRaceLapTimer/web/
gem install bundler
export PATH="$PATH:/root/.gem/ruby/2.2.0/bin"
bundle config build.nokogiri --use-system-libraries
gem install nokogiri -v "1.6.6.2"
bundle


 
	