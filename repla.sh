#!/bin/sh
sed -i "s|{__BASE_URL__}|$BASEKEYURLL|g" appsettings.json 
sed -i "s|{__API_KEY__}|$APIBASEURLL|g" appsettings.json
