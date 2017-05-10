#!/bin/bash
CHANNEL_ID="C54DF7HN3"

#Put your Hipchat API token here if the first script did not do it
AUTH_TOKEN_Slack=

#Put your Hipchat API token here if the first script did not do it
AUTH_TOKEN_BITLY=

clear
echo '==================    Choice    ======================'

#Selection of the Code color
#Loop until value 1 or 2 is selected
while [[ "$CHOICECOLOR" != [12] ]]; do
  echo "Select the Color by choosing 1 or 2"
  echo "   1) Orange"
  echo "   2) Red"
  read CHOICECOLOR
done
[[ $CHOICECOLOR = 1 ]] && color="orange" || color="red"

#Selection of the brand
#Loop until value 1 or 2 is selected
while [[ "$CHOICEBRAND" != [12] ]]; do
  echo "Select the brand by choosing 1 or 2"
  echo "   1) MOONPIG"
  echo "   2) PHOTOBOX"
  read CHOICEBRAND
done
[[ $CHOICEBRAND = 1 ]] && brand="MOONPIG" || brand="PHOTOBOX"

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
if [[ $number == *[^[:digit:]]* ]]; then echo "!!!!!! Sorry integers only. Exiting. Please retry !!!!!!"; exit 1 ; else echo "" ; fi

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
      drive copy -id '1NOQvGvyjcYZVhhZg04RE127taPrH2PKomu-Se3GEpn8' 'PBX, S9 and HF Code Debrief documents/Moonpig Code Debrief documents/'$brand' Code '$color' '$number' Debrief'
      if [[ $? != 0 ]]; then echo ""; echo "!!!!!! An error occured duplicating the debrief doc !!!!!!" ; fi
    else
      # Photobox debrief
      drive copy -id '1v-P9B3i5TOGg4ywP_91yXm9iH5QmcLiJDR9tY4svZeU' 'PBX, S9 and HF Code Debrief documents/'$brand' Code '$color' '$number' Debrief'
      if [[ $? != 0 ]]; then echo ""; echo "!!!!!! An error occured duplicating the debrief doc !!!!!!" ; fi
    fi
    echo '------------------------------------New Debrief Doc------------------------------------'
    if [[ CHOICEBRAND = 1 ]]; then 
      #Moonpig debrief
      URLDebrief=`drive url 'PBX, S9 and HF Code Debrief documents/Moonpig Code Debrief documents/'$brand' Code '$color' '$number' Debrief'|sed 's,.*\(http.://[^ ]*\),\1,g'`
      if [[ $? != 0 ]]; then echo ""; echo "!!!!!! An error occured duplicating the debrief doc !!!!!!" ; fi
    else
      # Photobox debrief
      URLDebrief=`drive url 'PBX, S9 and HF Code Debrief documents/'$brand' Code '$color' '$number' Debrief'|sed 's,.*\(http.://[^ ]*\),\1,g'`
      if [[ $? != 0 ]]; then echo ""; echo "!!!!!! An error occured duplicating the debrief doc !!!!!!" ; fi
    fi
    echo $URLDebrief

    # Creation bitly link
    echo '------------------------------------bit.ly link creation------------------------------------'
    DebriefLink=`curl -s -G "https://api-ssl.bitly.com/v3/shorten?access_token=$AUTH_TOKEN_BITLY&format=txt" --data-urlencode "longUrl=$URLDebrief"`
    if [[ $? != 0 ]]; then echo ""; echo "!!!!!! An error occured creating bitly URL !!!!!!" ; fi

    # Opening channel if not a retro code
    if [[ $CHOICERETRO = 2 ]]; then
      # Opening Channel
      echo '------------------------------------Open Channel------------------------------------'
      wget https://slack.com/api/channels.create?token=$AUTH_TOKEN_Slack\&name=code-$color-$number >/dev/null 2>&1
      if [[ $? != 0 ]]; then echo ""; echo "!!!!!! An error occured creating the channel !!!!!!" ; fi
    else
      echo "No Channel for Retrocodes"
    fi
    
    echo '------------------------------------FOR NOC2------------------------------------'
    if [[ $CHOICERETRO = 2 ]]; then
      echo "Debrief Doc: $DebriefLink"
      echo "Slack Channel : Test  - Code-$color-$number"
    else
      echo "Debrief Doc: $DebriefLink"
    fi

    # Confirmation on sending notification on main channel
    echo ""
    echo '------------------------------------------------------------------------'
    echo ""
    echo -n "Confirmation to send the notification on the Incident channel? (Y/N) --> "
    echo ""
    echo '------------------------------------------------------------------------'
    read confirmation2
    if [[ $confirmation2 =~ ^(y|Y|Yes|YES)$ ]]; then
            echo '------------------------------------Send message for channel opened------------------------------------'
            wget https://slack.com/api/chat.postMessage?token=$AUTH_TOKEN_Slack\&channel=noctestcode\&text='@here, Test Code-'$color'-'$number' has been opened : '$name'\&as_user=true >/dev/null 2>&1
            if [[ $? != 0 ]]; then echo ""; echo "!!!!!! An error occured send notification to the main channel !!!!!!" ; fi
    else
        echo "You have selected not to send the communication on the main incident channel"
        echo '!!!!!!  Please send it manually if needed !!!!!!'
    fi
else
        echo '!!!!!!  ERROR : Confirmation not approved. Try again   !!!!!!'
        echo "confirmation must be y or Y or Yes"
fi
