#!/bin/bash

# replace with your api key
response=$(curl  "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY")  


#using jq to parse json response

image_type=$(echo $response|jq -r .media_type)
echo $image_type

title=$(echo $response|jq -r .title)

explanation=$(echo $response|jq -r .explanation)

random_number=$(echo $RANDOM)

image_path="$HOME/Desktop/image_of_the_day_"

# you can use date here instead of random number.
file_name="$image_path$random_number.jpg"
echo "file: $file_name"

if [ $image_type == "image" ]
then
# remove old (all previous images), downloaded image needs to be cached so the wallpaper stays when the system restarts. 
	rm -rf $image_path* 
	curl $(echo $response|jq  -r .hdurl) --output $file_name && osascript <<EOF
		tell application "System Events"
		    tell every desktop
		        set picture to "$file_name"
		    end tell
		end tell
EOF
else
	echo not an image today
fi

echo "title: $title"
echo "explanation: $explanation"
sleep 10