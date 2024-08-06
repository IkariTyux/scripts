#!/bin/bash

# Variables
PlaylistUrl=$1
Format=$2
PlaylistName=$(curl $PlaylistUrl | awk -F '<meta property="og:title" content="' '{print $2}' | sed 's/\".*//g' | sed '/^[[:space:]]*$/d' | sed 's/Album - //g')
PlalistCover=$(curl $PlaylistUrl)
Folder="/home/$USER/Videos/$PlaylistName"

# Script
mkdir -p "$Folder"

case $Format in
  mp4|mkv|avi)
    yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" --sponsorblock-remove all,-sponsor $PlaylistUrl -P "$Folder"
  ;;

  flac|mp3|ogg)
    yt-dlp -x --audio-format flac $PlaylistUrl -P "$Folder"
  ;;

  *)
    echo "This format isn't supported yet"
    exit
  ;;
esac

## Rename files
### Remove YT-DLP's strings
for i in "$Folder"/*; do
  mv -v "$i" "`echo $i | sed 's/\[[^]]*\]//g'`";
done
rename " .$Format" ".$Format" "$Folder"/*.$Format
rename 'Album - ' '' "$Folder"/*

## Getting the cover
NewUrl=$(echo $PlaylistUrl | sed 's/www/music/g')
CoverUrl=$(curl $NewUrl | awk -F '<meta property="og:image" content="' '{print$2}' | sed 's/".*//g' | sed '/^[[:space:]]*$/d')
curl -Lo "$Folder"/cover.jpg $CoverUrl

if [ $? -eq 0 ]
  then echo -e "\033[32m Playlist successfully downloaded \033[0m"
    notify-send --icon=terminal --app-name=Bash 'Playlist Downloaded' "Finished downloading $PlaylistName!"
    ntfy "Playlist Downloaded" "Finished downloading $PlaylistName"
  else echo -e "\033[033m Error while downloading the playlist \033[0m" && exit
fi
