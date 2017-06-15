# Scripts4BridgeIC

-----------------------------------
This area is filled with scripts written to assist Bridge Implementations Consultant's with certain tasks, such as historical data migrations, retrieving Bridge IDs with unique IDs, etc...

I will try to maintain a list of scripts on this readme with notes on their function but please check the script comments for more information and feel free to message me for more information, @swagsilewski on Slack or via email at swasilewski@instructure.com

------Script Description-----------------------------------
-addCompletedUsers.rb
  This script takes a CSV file and adds the specified users, courses, scores and completed date and adds them to an instance.   The CSV file must be arranged into columns that are labeled 
    bridgeuserid: for the user id
    courseid: for the course id
    completed: the completion date in format yyyy-mm-dd
    score: the score that the user achieved in the course
    
    
------Setting Up Your Computer to Run Ruby Scripts-----------------------------------
**still need to update this

Ruby Setup Info:

List of needed stuff:
xcode
Plain Text Editor (atom)
Terminal (already on your computer)

developers tools:
install xcode
xcode-select — install
check version
gcc -v

Homebrew Package manager
http://brew.sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
download and install might need to hit enter
brew update will update it if you already have it

ruby
want at least 2.2.2 if you are going to run rails 
2.3.1 is the version that these scripts work with
ruby -v will check version
ruby which will show where it is installed
brew install rbenv
ls -la
nano .bash_profile
eval “$(rbenv init -)” add this to bash profile
hit contro-x then y then enter
ensure that it is there by typing cat .bash_profile
source ~/.bash_profile to enable that command
rbenv install 2.3.1 to install this version
rbenv rehash should be done after installing ruby or gems to recognize commands

gem -v ensure that gem package manager is installed
gem update —system to update gem package manager


quick overview of how to run scripts in terminal
cd ~ goes to home
cd .. goes to one directory higher
ls lists files and folders in directory
control-k will clear screen
