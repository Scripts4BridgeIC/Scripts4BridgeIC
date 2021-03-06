# Scripts4BridgeIC
-----------------------------------
This area is filled with scripts written to assist Bridge Implementations Consultant's with certain tasks, such as historical data migrations, retrieving Bridge IDs with unique IDs, etc...

I will try to maintain a list of scripts on this readme with notes on their function but please check the script comments for more information and feel free to message me for more information, @swagsilewski on Slack or via email at swasilewski@instructure.com

-----------------------------------------
## Script Description
Last substantive update: June 26, 2017

### createEnrollments.rb
This script takes a CSV file and adds the users therein to the courses specified. The CSV file requires two columns: One  with header UserID for the learner ID and one with the header CourseID for the course ID that that user should be enrolled in.

### getBridgeID.rb
This script takes an CSV file of Unique IDs (in a column with header 'uniqueID') and creates a CSV file containing those IDs and their corresponding Bridge IDs.

### getUniqueID.rb
This script takes an CSV file of Bridge IDs (in a column with header 'uniqueID') and creates a CSV file containing those IDs and their corresponding Unique IDs.

### addCompletedUsers.rb 
### Deprecated-will be updating this soon
This script takes a CSV file and adds the specified users, courses, scores and completed date and adds them to an instance.   The CSV file must be arranged into columns that are labeled 
    bridgeuserid: for the user id
    courseid: for the course id
    completed: the completion date in format yyyy-mm-dd
    score: the score that the user achieved in the course
    
-----------------------------------------    
## Setting Up Your Computer to Run Ruby Scripts
Last substantive update: June 23, 2017

### Items Needed:
* Developer Tools
* Homebrew Package Manager
* Ruby
* Applicable Gems
* Terminal (already on your computer)
* Plain Text Editor (Optional)

### developers tools:
#### install xcode
xcode-select — install

### Homebrew Package manager
http://brew.sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
download and install might need to hit enter
brew update will update it if you already have it

### Ruby
want at least 2.2.2 if you are going to run rails 
2.3.1 is the version that these scripts work with
ruby -v will check version
ruby which will show where it is installed
brew install rbenv
ls -la
nano .bash_profile
eval “$(rbenv init -)” add this to bash profile
hit control-x then y then enter

cat .bash_profile
* ensure that it is there by typing 

source ~/.bash_profile 
* to enable that command

rbenv install 2.3.1 
* to install this version

rbenv rehash 
* should be done after installing ruby or gems to recognize commands

### Ruby Gems
To ensure that gem package manager is installed:
* gem -v 

To update gem package manager:
* gem update —system 

### Most scripts will require these Gems
* gem install json
* gem install net/http
* gem install csv

------------------------------
## Brief Overview of Using Terminal to Run Scripts
cd foldername 
* go to folder named 'foldername'

cd ~ 
* goes to home directory

cd .. 
* goes to one directory higher

ls 
* lists files and folders in directory

<control+k> 
* Pressing these two buttons will clear terminal log

ruby filename.rb
* Once you have navigated to the folder that the script is in, this command will run the script
