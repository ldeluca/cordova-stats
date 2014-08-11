
#---CHANGE THE VARIABLES BELOW---
BASE_GIT_REPO_PATH=/Users/ldeluca/git/cordova
OUTPUT_PATH=/Users/ldeluca/git/gitstats/output
GITSTATS_PATH=/Users/ldeluca/git/gitstats/

#--- git repos
## declare an array variable
declare -a gitrepos=("cordova-amazon-fireos" "cordova-android" "cordova-app-harness" "cordova-app-hello-world" "cordova-bada" "cordova-bada-wac" "cordova-blackberry" "cordova-browser" "cordova-cli" "cordova-coho" "cordova-docs" "cordova-firefoxos" "cordova-ios" "cordova-js" "cordova-labs" "cordova-lib" "cordova-medic" "cordova-mobile-spec" "cordova-osx" "cordova-plugin-battery-status" "cordova-plugin-camera" "cordova-plugin-console" "cordova-plugin-contacts" "cordova-plugin-device" "cordova-plugin-device-motion" "cordova-plugin-device-orientation" "cordova-plugin-dialogs" "cordova-plugin-file" "cordova-plugin-file-transfer" "cordova-plugin-geolocation" "cordova-plugin-globalization" "cordova-plugin-inappbrowser" "cordova-plugin-media" "cordova-plugin-media-capture" "cordova-plugin-network-information" "cordova-plugins" "cordova-plugin-splashscren" "cordova-plugin-statusbar" "cordova-plugin-test-framework" "cordova-plugin-vibration" "cordova-plugman" "cordova-qt" "cordova-registry-web" "cordova-registry" "cordova-tizen" "cordova-ubuntu" "cordova-webos" "cordova-weinre" "cordova-windows" "cordova-wp7" "cordova-wp8")


read -p "What should we call this report?" statreport
read -p "Do you want to regen report?" doregen

REGENERATE="Y" # this is the variable saying we want to regenerate
OUTPUT_REPORT=$OUTPUT_PATH/$statreport/report.txt

#---
## now loop through the gitrepos array
if [ "$doregen" == "$REGENERATE" ]; then
for i in "${gitrepos[@]}"
do
    echo "**************** $i *************************"
    cd $BASE_GIT_REPO_PATH/$i

    # make sure the fork has the latest from apache master
    git checkout master
    git pull apache master
    git push origin master

    cd $GITSTATS_PATH
   ./gitstats $BASE_GIT_REPO_PATH/$i $OUTPUT_PATH/$statreport/$i

done
else
    echo "skipping report regeneration"
fi


echo "ALL DONE CREATING INDIVIDUAL REPORTS"

total=0
numfiles=0
numcommits2013=0
numcommits2014=0

year2013="2013"
year2014="2014"
#---
## now loop through the gitrepos array
for i in "${gitrepos[@]}"
do
    echo "**************** $i *************************"
    cd $OUTPUT_PATH/$statreport/$i/

    # now tally up lines of code
    filename="$OUTPUT_PATH/$statreport/$i/lines_of_code.dat"
    #echo "file to read: $filename"
    while read -r line
    do
        set -- $line
        # echo "first val: $1, lines of code: $2"
    done < "$filename"
    echo "$i lines of code: $2"
    total=$(($total + $2))

    filename="$OUTPUT_PATH/$statreport/$i/files_by_date.dat"
    #echo "file to read: $filename"
    while read -r line
    do
        set -- $line
        # echo "first val: $1, lines of code: $2"
    done < "$filename"
    echo "$i number of files: $2"
    numfiles=$(($numfiles + $2))

    filename="$OUTPUT_PATH/$statreport/$i/commits_by_year.dat"
    #echo "file to read: $filename"
    while read -r line
    do
        set -- $line
        # echo "first val: $1, lines of code: $2"
        if [ "$1" == "$year2013" ]; then
            numcommits2013=$(($numcommits2013 + $2))
        elif [ "$1" == "$year2014" ]; then
            numcommits2014=$(($numcommits2014 + $2))
        fi
    done < "$filename"
    echo "$i commits: $2"

done

echo "%%%%% TOTAL LINES OF CODE %%%%%% $total"
echo "%%%%% TOTAL LINES OF CODE %%%%%% $total" >> $OUTPUT_REPORT

echo "%%%%% Number of Files %%%%%% $numfiles"
echo "%%%%% Number of Files %%%%%% $numfiles" >> $OUTPUT_REPORT

echo "%%%%% Number of Commits in 2013 %%%%%% $numcommits2013"
echo "%%%%% Number of Commits in 2013 %%%%%% $numcommits2013" >> $OUTPUT_REPORT
echo "%%%%% Number of Commits in 2014 %%%%%% $numcommits2014"
echo "%%%%% Number of Commits in 2014 %%%%%% $numcommits2014" >> $OUTPUT_REPORT