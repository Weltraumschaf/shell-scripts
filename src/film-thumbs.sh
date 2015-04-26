#!/usr/bin/env bash

dir="${1}"
cwd=$(pwd)
#vlc="/Applications/VLC.app/Contents/MacOS/VLC"
#vlc="/opt/homebrew-cask/Caskroom/vlc/2.1.5/VLC.app/Contents/MacOS/VLC"
vlc="cvlc"

echo "Make thumbs of movies in ${dir} ..."

find "${dir}" -type f | egrep -i "\.(avi|flv|mov|mp4|mpeg|mpg|wmv)$" | while read file; do
    echo "Thumbing ${file} ..."
    # https://wiki.videolan.org/How_to_create_thumbnails/
    thumbdir="${cwd}${file%.*}"
    mkdir -p "${thumbdir}"
    $vlc \
        --rate=1 \
        --video-filter=scene \
        --vout=dummy \
        --aout=dummy \
        --start-time=100 \
        --stop-time=101 \
        --scene-format=png \
        --scene-ratio=24 \
        --scene-prefix=snap \
        --scene-path="${thumbdir}" \
        --play-and-exit \
        "file://${file}" vlc://quit
done