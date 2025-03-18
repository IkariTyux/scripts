#!/bin/bash

# Variables
PlaylistUrl=$1
Format=$2
PlaylistName=$(curl $PlaylistUrl | awk -F '<meta property="og:title" content="' '{print $2}' | sed 's/\".*//g' | sed '/^[[:space:]]*$/d' | sed 's/Album - //g')
FolderMusic="/home/$USER/Music/$PlaylistName"
FolderVideos="/home/$USER/Videos/$PlaylistName"

# Script

case $Format in
  mp4|mkv|avi)
    yt-dlp -S res,ext:$Format:m4a --recode mp4 --sponsorblock-remove all,-sponsor $PlaylistUrl -P "$FolderVideos"
    
    ## Rename files
    for i in "$FolderVideos"/*; do
      mv -v "$i" "`echo $i | sed 's/\[[^]]*\]//g'`";
    done
    rename " .$Format" ".$Format" "$FolderVideos"/*.$Format
  ;;

  flac|mp3|ogg)
    yt-dlp -x --audio-format $Format $PlaylistUrl -P "$FolderMusic"
    
    ## Getting the cover
    NewUrl=$(echo $PlaylistUrl | sed 's/www/music/g')
    CoverUrl=$(curl $NewUrl | awk -F '<meta property="og:image" content="' '{print$2}' | sed 's/".*//g' | sed '/^[[:space:]]*$/d')
    curl -Lo "$FolderMusic"/cover.jpg $CoverUrl
    
    ## Rename files
    ### Remove YT-DLP's strings
    for i in "$FolderMusic"/*; do
      mv -v "$i" "`echo $i | sed 's/\[[^]]*\]//g'`";
    done
    rename " .$Format" ".$Format" "$FolderMusic"/*.$Format
  ;;

  *)
    echo "This format isn't supported yet"
    exit
  ;;
esac

if [ $? -eq 0 ]
then
  echo -e "\033[32m Playlist successfully downloaded \033[0m"
  notify-send --icon=terminal --app-name=Bash 'Playlist Downloaded' "Finished downloading $PlaylistName!"
else
  echo -e "\033[033m Error while downloading the playlist \033[0m"
  exit
fi
