#!/bin/bash
ROOM_ID=""

#Put your Hipchat API token here if the first script did not do it
AUTH_TOKEN_NOTIFICATION=
AUTH_TOKEN_CREATEROOM=

#Put your Hipchat API token here if the first script did not do it
AUTH_TOKEN_BITLY=

clear
echo '==================    Choice    ======================'

#Selection of the color
#Loop until value 1 or 2 is selected
while [[ "$CHOICECOLOR" != [12] ]]; do
  echo "Select the Color by choosing 1 or 2"
  echo "   1) Orange"
  echo "   2) Red"
  read CHOICECOLOR
done
[[ $CHOICECOLOR = 1 ]] && color="Orange" || color="Red"

#Selection of the brand
#Loop until value 1 or 2 is selected
while [[ "$CHOICEBRAND" != [12] ]]; do
  echo "Select the brand by choosing 1 or 2"
  echo "   1) MOONPIG"
  echo "   2) PHOTOBOX"
  read CHOICEBRAND
done
[[ $CHOICEBRAND = 1 ]] && brand="MOONPIG" || brand="PHOTOBOX"
# Selecting the Hipchat Main Room
[[ $CHOICEBRAND = 1 ]] && ROOM_ID=3576162 || ROOM_ID=3442764 

#Selection if retro
#Loop until value 1 or 2 is selected
while [[ "$CHOICERETRO" != [12] ]]; do
  echo "Is it a retro code"
  echo "   1) Yes it is retro"
  echo "   2) No it is not"
  read CHOICERETRO
done
# For summary purpose
[[ $CHOICERETRO = 1 ]] && retro="retro" || retro="" 

#Selection of the code number
echo -n "Enter the code Number --> "
read number
# Check if it has 4 digits
check=${#number}
if [ $check = 4 ]; then echo "" ; else echo "!!!!!! Code number needs 4 digits !!!!!!" ; echo "" ; echo "exiting" ; exit 1 ; fi
# Check if it is a number
if [[ -z "$number" || $number == *[^[:digit:]]* ]]; then echo "" ; else echo "!!!!!! Sorry integers only. Exiting. Please retry !!!!!!"; exit 1 ; fi

#Selection of the code name
echo -n "Enter the Code name --> "
read name
name=$(echo $name | tr 'A-Z' 'a-z')
# Check if it is empty
if [[ -z "${name}" ]]; then echo '!!!!!! ERROR : Name can not be empty. Exiting. Please retry   !!!!!!' ; exit 1 ; else echo "" ; fi

# Checking Summary and confirmation
clear
echo "========================== Summary =============================="
echo ""
echo "   You have selected a $brand $retro code $color "
echo "   The number is $number"
echo "   The title is $name"
echo ""
echo "================================================================="
echo ""
echo -n "Confirmation (Y/N) --> "
read confirmation

if [[ $confirmation =~ ^(y|Y|Yes|YES)$ ]]; then
    echo '------------------------------------Creation Debrief from Template------------------------------------'
    if [[ CHOICEBRAND = 1 ]]; then 
      #Moonpig debrief
      drive copy -id '1nui60dzQj7Fmpggrj8tKHFx-siS8t9jFxr2QlDe2ox8' 'Noc-Support/In Progress/Testduplicate/Code '$color' '$number' Debrief'
      if [[ $? != 0 ]]; then echo ""; echo "!!!!!! An error occured duplicating the debrief doc !!!!!!" ; fi
    else
      # Photobox debrief
      drive copy -id '1nui60dzQj7Fmpggrj8tKHFx-siS8t9jFxr2QlDe2ox8' 'Noc-Support/In Progress/Testduplicate/Code '$color' '$number' Debrief'
      if [[ $? != 0 ]]; then echo ""; echo "!!!!!! An error occured duplicating the debrief doc !!!!!!" ; fi
    fi
    echo '------------------------------------New Debrief Doc------------------------------------'
    URLDebrief=`drive url 'Noc-Support/In Progress/Testduplicate/Code '$color' '$number' Debrief'| awk '{print $6}'`
    if [[ $? != 0 ]]; then echo ""; echo "!!!!!! An error occured getting the debrief URL !!!!!!" ; fi
    echo $URLDebrief

    # Creation bitly link
    echo '------------------------------------bit.ly link creation------------------------------------'
    DebriefLink=`curl -s -G "https://api-ssl.bitly.com/v3/shorten?access_token=$AUTH_TOKEN_BITLY&format=txt" --data-urlencode "longUrl=$URLDebrief"`
    if [[ $? != 0 ]]; then echo ""; echo "!!!!!! An error occured creating bitly URL !!!!!!" ; fi
    echo "Debrief : $DebriefLink" 

    # Opening room if not a retro code
    if [[ $CHOICERETRO = 2 ]]; then
      # limiting the name to 50 caracters
      HIPNAMECUT="echo $brand - Code $color - $number - $name | awk '{print substr($0,0,50)}'"
      if [[ $? != 0 ]]; then echo ""; echo "!!!!!! An error occured getting 50 caracters for hipchat room name !!!!!!" ; fi
      # Opening Room
      echo '------------------------------------Open Room------------------------------------'
      curl -s -H "Content-Type: application/json" \
      -X POST \
      -d "{\"name\": \"HIPNAMECUT\" , \"topic\": \"$DebriefLink\"}" \
      https://api.hipchat.com/v2/room?auth_token=$AUTH_TOKEN_CREATEROOM  >> /dev/null
      if [[ $? != 0 ]]; then echo ""; echo "!!!!!! An error occured creating the room !!!!!!" ; fi
    else
      echo "No room for Retrocodes"
    fi
    
    echo '------------------------------------FOR NOC2------------------------------------'
    if [[ $CHOICERETRO = 2 ]]; then
      echo "Debrief Doc: $DebriefLink"
      echo "Hipchat Room: Test $brand - Code $color - $number - $name"
    else
      echo "Debrief Doc: $DebriefLink"
    fi

    # Confirmation on sending notification on main room
    echo ""
    echo '------------------------------------------------------------------------'
    echo ""
    echo -n "Confirmation to send the notification on the Main room? (Y/N) --> "
    echo ""
    echo '------------------------------------------------------------------------'
    read confirmation2
    if [[ $confirmation2 =~ ^(y|Y|Yes|YES)$ ]]; then
            echo '------------------------------------Send message for room opened------------------------------------'
            curl -s -H "Content-Type: application/json" \
            -X POST \
            -d "{\"color\": \"gray\", \"message_format\": \"text\", \"message\": \"@here New Code opened : Test Code $color - $number - $name \" }" \
            https://api.hipchat.com/v2/room/$ROOM_ID/notification?auth_token=$AUTH_TOKEN_NOTIFICATION
            if [[ $? != 0 ]]; then echo ""; echo "!!!!!! An error occured send notification to the main room !!!!!!" ; fi
    else
        echo "You have selected not to send the communication on the main room"
        echo '!!!!!!  Please send it manually if needed !!!!!!'
    fi
else
        echo '!!!!!!  ERROR : Confirmation not approved. Try again   !!!!!!'
        echo "confirmation must be y or Y or Yes"
fi
