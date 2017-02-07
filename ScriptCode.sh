#!/bin/bash
ROOM_ID=""

#Put your Hipchat API token here if the first script did not do it
AUTH_TOKEN_NOTIFICATION=
AUTH_TOKEN_CREATEROOM=

#Put your Hipchat API token here if the first script did not do it
AUTH_TOKEN_BITLY=

echo '==================    Questions    ======================'
echo -n "Enter a code color : Red / Orange --> "
read color
echo -n "Enter a brand : Moonpig / Photobox --> "
read brand
echo -n "Enter a code Number --> "
read number
echo -n "Enter the Code name --> "
read name
echo -n "Confirmation (Y/N) --> "
read confirmation

#Main hipchat room Selection depending of the brand
if [[ $brand =~ ^(Moonpig|moonpig|MOONPIG)$ ]]; then
    ROOM_ID=3442764
fi
if [[ $brand =~ ^(Photobox|photobox|PHOTOBOX)$ ]]; then
    ROOM_ID=3442764
fi
if [ -z "$ROOM_ID" ]; then
    echo "Issue on the brand name"
    echo "you have entered $brand"
    exit 1

#Checking Inputs
if [[ $confirmation =~ ^(y|Y|Yes|YES)$ ]]; then
        if [[ $color =~ ^(Orange|ORANGE|orange|ORange|Red|RED|red|REd)$ ]]
        then
                if [[ "$number" =~ ^-?[0-9]+[.,]?[0-9]*$ ]]; then
                        if [ -z "${name}" ]; then
                                echo '!!!!!! ERROR : Name can not be empty. Exiting. Please retry   !!!!!!'
                                echo "Code name was : $name"
                                exit 1
                        else
                                echo '------------------------------------Creation Debrief from Template------------------------------------'
                                drive copy -id '1nui60dzQj7Fmpggrj8tKHFx-siS8t9jFxr2QlDe2ox8' 'Noc-Support/In Progress/Testduplicate/Code '$color' '$number' Debrief'
                                echo '------------------------------------New Debrief Doc------------------------------------'
                                URLDebrief=`drive url 'Noc-Support/In Progress/Testduplicate/Code '$color' '$number' Debrief'| awk '{print $6}'`
                                echo $URLDebrief
                                
                                echo '------------------------------------bit.ly link creation------------------------------------'
                                DebriefLink=`curl -G "https://api-ssl.bitly.com/v3/shorten?access_token=$AUTH_TOKEN_BITLY&format=txt" --data-urlencode "longUrl=$URLDebrief"`
                                echo "Debrief : $DebriefLink" 
                                
                                echo '------------------------------------Open Room------------------------------------'
                                curl -H "Content-Type: application/json" \
                                -X POST \
                                -d "{\"name\": \"Test Code $color - $number - $name\" , \"topic\": \"$DebriefLink\"}" \
                                https://api.hipchat.com/v2/room?auth_token=$AUTH_TOKEN_CREATEROOM

                                echo ""
                                echo -n "Confirmation to send the notification on the Main room? (Y/N) --> "
                                read confirmation2
                                if [[ $confirmation2 =~ ^(y|Y|Yes|YES)$ ]]; then
                                        echo '------------------------------------Send message for room opened------------------------------------'
                                        curl -H "Content-Type: application/json" \
                                        -X POST \
                                        -d "{\"color\": \"gray\", \"message_format\": \"text\", \"message\": \"@here New Code opened : Test Code $color - $number - $name \" }" \
                                        https://api.hipchat.com/v2/room/$ROOM_ID/notification?auth_token=$AUTH_TOKEN_NOTIFICATION
                                else
                                    echo 'Please send it manually'
                                fi
                        fi
                else
                    echo '!!!!!!  ERROR :  Wrong Code number entered. Exiting. Please retry   !!!!!!'
                        echo "Code color was : $number"
                        echo "It needs to be a number"
                        exit 1
                fi
        else
            echo '!!!!!!  ERROR :  Wrong Code color entered. Exiting. Please retry   !!!!!!'
                echo "Code color was : $color"
                echo "It needs to be Orange or Red"
                exit 1
        fi
else
        echo '!!!!!!  ERROR : Confirmation not approved. Try again   !!!!!!'
        echo "confirmation must be y or Y or Yes"
fi
