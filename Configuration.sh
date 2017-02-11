#! /bin/bash

echo ======================== Install Drive App =======================
go get -u github.com/odeke-em/drive/cmd/drive

echo ======================== Enter API Keys =======================
echo -n "Enter your Hipchat API key Send Notification : "
read apikeymessage
if [ -z "${apikeymessage}" ]; then
  echo '!!!!!! ERROR :   API key can not be empty. Exiting. Please retry   !!!!!!'
  exit 1
fi
echo -n "Enter your Hipchat API key  Manage Rooms : "
read apikeycreateroom
if [ -z "${apikeycreateroom}" ]; then
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
sed -i 's/AUTH_TOKEN_NOTIFICATION=/AUTH_TOKEN_NOTIFICATION='$apikeymessage'/g' ~/Code/ScriptCode.sh
sed -i 's/AUTH_TOKEN_CREATEROOM=/AUTH_TOKEN_CREATEROOM='$apikeycreateroom'/g' ~/Code/ScriptCode.sh
sed -i 's/AUTH_TOKEN_BITLY=/AUTH_TOKEN_BITLY='$apikeybitly'/g' ~/Code/ScriptCode.sh

echo ======================== Initialize Drive App =======================
echo "open the link in a browser then Copy and Paste the authorization code:"
drive init

echo "Continue the installation by running Installation2.sh"
