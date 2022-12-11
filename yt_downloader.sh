#!/bin/bash

echo "################## STARTING SCRIPT EXECUTION ##################"
url=$1 #URL of the video to download
convert=${2:-false} #optional flag if will convert to MP3 
#conserve_video=${3:-false} #in the case of convert, optional flag if want to conserve video file
echo "REQUESTED URL: ${url}, CONVERT OPTION=${convert}"

OUTPUT_DIR="out" #directory where the files will be downloaded to

current_dir=$(pwd)

convert_to_mp3(){
    echo "STARTING VIDEO CONVERSION TO MP3"
    video_dl_path=$1
    audio_output_path=$2

    ffmpeg -i "$video_dl_path" "$audio_output_path"
}

#Adding this check to ensure OUTPUT_DIR isn't unset
if [[ -z ${OUTPUT_DIR} ]]; then
    echo "No output dir specified: exiting"
    exit 1
fi

[ -d $OUTPUT_DIR ] && rm -rf $OUTPUT_DIR
mkdir -p $OUTPUT_DIR

#first we will call Python script to download the video at the specified output dir
cd $OUTPUT_DIR
pwd
python_output=$((python3 ..//yutubi.py -u=$url) 2>&1)

IFS="|"; python_output_arr=($python_output); unset IFS;
success=${python_output_arr[0]}
default_filename=${python_output_arr[1]}

if [[ $success == false ]]; then
    echo "Python script failed to download the video, exiting"
    exit 1
fi

#check if we want to convert the video to MP3, then we will call the following subroutine
if [[ $convert == "on" ]]; then

    output_filename=${default_filename//" "/"_"}
    output_filename=${output_filename/".mp4"/".mp3"}

    convert_to_mp3 "${default_filename}" "${output_filename}"
    #if [[ $conserve_video == false ]]; then
    rm "$default_filename"
    #fi
fi

cd $current_dir
echo "Finished downloading requested files, exiting"