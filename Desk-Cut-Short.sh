#!/bin/bash
#
###############################################################################################################################################
#
# ABOUT THIS PROGRAM
#
#	Desk-Cut-Short.sh
#	https://github.com/Headbolt/Desk-Cut-Short
#
#   This Script is designed for use in JAMF
#
#   - This script will ...
#       Check for the desired Internet Shortcut file on the users Desktop
#		Check the file contents are correct, and recreate the file if not.
#
###############################################################################################################################################
#
# HISTORY
#
#   Version: 1.1 - 26/08/2021
#
#   - 25/08/2021 - V1.0 - Created by Headbolt
#   - 26/08/2021 - V1.1 - Updated by Headbolt
#							Updated to deal with issues around Spaces in the file name
#
###############################################################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
###############################################################################################################################################
#
# Variables used by this script.
#
Username=$3 # Grab the username for the current logged in user.
URL="$4" # Grab the URL from JAMF variable #4 eg. http://domain.com
ShortCutName="$5" # Grab the name of the Desktop Shortcut to create from JAMF variable #5 eg. shortcut.url
#
ShortCutPath="/Users/$Username/Desktop/$ShortCutName"
#
# Set the name of the script for later logging
ScriptName="append prefix here as needed - Check and Create/Re-Create Desktop Internet Shortcuts"
#
###############################################################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
###############################################################################################################################################
#
# Defining Functions
#
###############################################################################################################################################
#
# ShortcutCheck Function
#
ShortcutCheck(){
#
file=/Users/$Username/Desktop/$ShortCutName
SectionName=\\[InternetShortcut\\]
SectionNameCompare=\[InternetShortcut\]
HeaderAddedURL="URL=$URL"
#
/bin/echo 'Checking File '"'$file'"' exists.'
#
if [ -f "$file" ]
    then
        /bin/echo 'YES'
		FileCheck=EXIST
    else
        /bin/echo 'NO'
        FileCheck=NOTEXIST
fi
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
/bin/echo 'Checking Section Name '"'$SectionNameCompare'"' exists in File.'
#
SectionNameCheck=$(cat "$file" | grep "$SectionName")
#
if [ "$SectionNameCheck" == "$SectionNameCompare" ]
	then
		SectionNamePresent=YES
		/bin/echo "YES"
	else
		SectionNamePresent=NO
		/bin/echo "NO"
fi
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
/bin/echo 'Checking URL '"'$URL'"' exists in File.'
#
URLCheck=$(cat "$file" | grep "$HeaderAddedURL")
#
if [ "$URLCheck" == "$HeaderAddedURL" ]
	then
		URLPresent=YES
		/bin/echo "YES"
		else
		URLPresent=NO
		/bin/echo "NO"
fi
#
}
#
###############################################################################################################################################
#
# Check if Shortcut Creation is required Function
#
CreateCheck(){
#
/bin/echo 'Checking if Shortcut need creating or recreating'
#
if [ "$FileCheck" == "NOTEXIST" ]
	then
		CreateShortcut=YES
	else
		if [ "$SectionNamePresent" == "NO" ]
			then
				CreateShortcut=YES
			else
				if [ "$URLPresent" == "NO" ]
					then
						CreateShortcut=YES
					else
						CreateShortcut=NO
				fi
		fi
fi
#
/bin/echo "$CreateShortcut"
#
if [ "$CreateShortcut" == "YES" ]
	then
		SectionEnd
fi
#
}
#
###############################################################################################################################################
#
# Write To Preload Inventory Table Function
#
ShortcutCreate(){
#
if [ "$CreateShortcut" == "YES" ]
	then
		/bin/echo 'Creating Shortcut'
		/bin/echo [InternetShortcut] > "${ShortCutPath}"
		/bin/echo >> "${ShortCutPath}"
		/bin/echo URL=$URL >> "${ShortCutPath}"
		#
        chown $Username "${ShortCutPath}"
		/bin/echo 'Created'
fi
#
SectionEnd
#
}
#
###############################################################################################################################################
#
# Section End Function
#
SectionEnd(){
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
/bin/echo  ----------------------------------------------- # Outputting a Dotted Line for Reporting Purposes
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
}
#
###############################################################################################################################################
#
# Script End Function
#
ScriptEnd(){
#
# Outputting a Blank Line for Reporting Purposes
#/bin/echo
#
/bin/echo Ending Script '"'$ScriptName'"'
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
/bin/echo  ----------------------------------------------- # Outputting a Dotted Line for Reporting Purposes
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
}
#
###############################################################################################################################################
#
# End Of Function Definition
#
###############################################################################################################################################
#
# Beginning Processing
#
###############################################################################################################################################
#
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
SectionEnd
#
ShortcutCheck
SectionEnd
#
CreateCheck
#
ShortcutCreate
#
ScriptEnd
