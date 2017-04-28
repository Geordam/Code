#! /bin/bash

echo ======================== Enter API Keys =======================
echo -n "Enter your Slack API key : "
read apikeyslack
if [ -z "${apikeymessage}" ]; then
  echo '!!!!!! ERROR :   API key can not be empty. Exiting. Please retry   !!!!!!'
  exit 1
fi
echo -n "Enter your BitLy API key : "
read apikeybitly
if [ -z "${apikeybitly}" ]; then
  echo '!!!!!! ERROR :   API key can not be empty. Exiting. Please retry   !!!!!!'
  exit 1
fi

echo ======================== Adding API keys in the script file =======================
sed -i 's/AUTH_TOKEN_Slack=/AUTH_TOKEN_Slack='$apikeyslack'/g' ~/Code/LiveScriptCode.sh
if [[ $? != 0 ]]; then echo ""; echo "!!!!!! An error occured adding the token for Hipchat notificaton room, please add manually !!!!!!" ; fi
sed -i 's/AUTH_TOKEN_BITLY=/AUTH_TOKEN_BITLY='$apikeybitly'/g' ~/Code/LiveScriptCode.sh
if [[ $? != 0 ]]; then echo ""; echo "!!!!!! An error occured adding the token for BitLy !!!!!!" ; fi

echo ======================== Initialize Drive App =======================
echo "open the link in a browser then Copy and Paste the authorization code:"
drive init
