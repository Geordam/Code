#!/bin/bash
ROOM_ID=3442764

#Put your Hipchat API token here if the first script did not do it
AUTH_TOKEN_NOTIFICATION=
AUTH_TOKEN_CREATEROOM=

#Put your Hipchat API token here if the first script did not do it
AUTH_TOKEN_BITLY=

echo '==================    Questions    ======================'
echo -n "Enter a code color : Red / Orange --> "
read color
echo -n "Enter a code Number --> "
read number
echo -n "Enter the Code name --> "
read name
echo -n "Confirmation (Y/N) --> "
read confirmation

if [[ $confirmation =~ ^(y|Y|Yes|YES)$ ]]; then
        if [[ $color =~ ^(Orange|ORANGE|orange|ORange|Red|RED|red|REd)$ ]]
        then
                if [[ "$number" =~ ^-?[0-9]+[.,]?[0-9]*$ ]]; then
                        if [ -z "${room}" ]; then
                                echo '!!!!!! ERROR :   Room can not be empty. Exiting. Please retry   !!!!!!'
                                echo "Code color was : $Room"
                                exit 1
                        else
                                echo '------------------------------------Creation Debrief from Template------------------------------------'
                                drive copy -id '1nui60dzQj7Fmpggrj8tKHFx-siS8t9jFxr2QlDe2ox8' 'Noc-Support/In Progress/Testduplicate/Code '$color' '$number' Debrief'
                                echo '------------------------------------New Debrief Doc------------------------------------'
                                drive url 'Noc-Support/In Progress/Testduplicate/Code '$color' '$number' Debrief'| awk '{print $6}'
                                echo '------------------------------------bit.ly link creation------------------------------------'
                                URLToCut=`drive url 'Noc-Support/In Progress/Testduplicate/Code '$color' '$number' Debrief'| awk '{print $6}'`
                                DebriefLink=`curl -G "https://api-ssl.bitly.com/v3/shorten?access_token=$AUTH_TOKEN_BITLY&format=txt" --data-urlencode "longUrl=$URLToCut"`
                                echo "Debrief : $DebriefLink" 
                                
                                echo '------------------------------------Open Room------------------------------------'
                                curl -H "Content-Type: application/json" \
                                -X POST \
                                -d "{\"name\": \"Test Code $color - $number - $name\" , \"topic\": \"$DebriefLink\"}" \
                                https://api.hipchat.com/v2/room?auth_token=$AUTH_TOKEN_CREATEROOM


                                echo '------------------------------------Send message for room opened------------------------------------'
                                curl -H "Content-Type: application/json" \
                                -X POST \
                                -d "{\"color\": \"gray\", \"message_format\": \"text\", \"message\": \"@here New Code opened : Test Code $color - $number - $name \" }" \
                                https://api.hipchat.com/v2/room/$ROOM_ID/notification?auth_token=$AUTH_TOKEN_NOTIFICATION

                                
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
