#!/bin/bash
ROOM_ID=3336898
geordam=MHI2ff2lP7HN4zDyI3w35JSb6q23tpkVt48TpiS2
mohamed=W7ilPaKxACGBzRmWbkgdsF2jAfEqa9dWk0PhtKXS

echo '==================    Checking Username entered    ======================'
if [ $1 = "geordam" ]; then
AUTH_TOKEN=$geordam
echo "Username accepted"
else
        if [ $1 = "mohamed" ]; then
        AUTH_TOKEN=$mohamed
        echo "Username accepted"
        else
                echo "!!!!!! ERROR :  The user $1 is unknown   !!!!!!"
                exit 1
        fi
fi

echo '==================    Questions    ======================'
echo -n "Enter a code color : Red / Orange --> "
read color
echo -n "Enter a code Number --> "
read number
echo -n "Enter a Hipchat room name --> "
read room
echo $color
if [[ $color =~ ^(Orange|ORANGE|orange|ORange|Red|RED|red|REd)$ ]]
then
        if [[ "$number" =~ ^-?[0-9]+[.,]?[0-9]*$ ]]
        then
                if [ -z "${room}" ];
                then
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
                        curl -G "https://api-ssl.bitly.com/v3/shorten?access_token=ad5de2553587a9a77f6c8d8ad1b27a1032396594&format=txt" --data-urlencode "longUrl=$URLToCut"
                        echo '------------------------------------Send message for room opened------------------------------------'
                        curl -H "Content-Type: application/json" \
                        -X POST \
                        -d "{\"color\": \"gray\", \"message_format\": \"text\", \"message\": \"@here New Code opened : $room \" }" \
                        https://api.hipchat.com/v2/room/$ROOM_ID/notification?auth_token=$AUTH_TOKEN
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
