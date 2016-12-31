#!/bin/bash
ROOM_ID=3336898
AUTH_TOKEN=MHI2ff2lP7HN4zDyI3w35JSb6q23tpkVt48TpiS2

echo -n "Enter a code color : Red / Orange --> "
read color
echo -n "Enter a code Number --> "
read number
echo -n "Enter a Hipchat room name --> "
read room

echo '------------------------------------Creation Debrief from Template------------------------------------'
drive copy Testduplicate/test 'Testduplicate/Code '$color' '$number' Debrief'
echo '------------------------------------New Debrief Doc------------------------------------'
drive url 'Testduplicate/Code '$color' '$number' Debrief'| awk '{print $5}'

echo '------------------------------------bit.ly link creation------------------------------------'
URLToCut=`drive url 'Testduplicate/Code '$color' '$number' Debrief'| awk '{print $5}'`
curl -G "https://api-ssl.bitly.com/v3/shorten?access_token=ad5de2553587a9a77f6c8d8ad1b27a1032396594&format=txt" --data-urlencode "longUrl=$URLToCut"

#echo '------------------------------------Send message for room opened------------------------------------'
#curl -H "Content-Type: application/json" \
#     -X POST \
#     -d "{\"color\": \"gray\", \"message_format\": \"text\", \"message\": \"@here New Code opened : $3 $4 $5 $6 $7 $7 $8 $9 \" }" \
#https://api.hipchat.com/v2/room/$ROOM_ID/notification?auth_token=$AUTH_TOKEN
