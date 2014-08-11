cordova-stats
=============

script file to pull down cordova statistics and run gitstats


setup
=========

1. First, clone the gitstas repository  http://gitstats.sourceforge.net/

    git clone git://github.com/hoxu/gitstats.git
    

2. Place the cordovastats.sh file within the gitstats directory

3. Edit the three path variables at the top of the file to be specific to your environment

4. clone the git repos that you'd like to gather stats for


running
===============

Run ./cordovastats.sh

You will be prompted to enter a name for the report.  ex. 20140811

If you wish to regenerate the report be sure to enter "Y", otherwise the script with use the existing source

Within your gitstats directory you will find a new directory named "output" with a child directory for the report name you provided.  There you will find a directory for each of the git repositories and a text file named "report.txt" with the results from running the script.