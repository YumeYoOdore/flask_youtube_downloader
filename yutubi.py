#!/usr/bin/env python3

###############################
# Tool: Youtube video downloader
# Usage: given a youtube URL will download the video using pytube

import argparse

from pytube import YouTube

def run():
    target_url = args.url

    video = YouTube(target_url)
    video_object = video.streams.get_highest_resolution()
    
    try:
        video_object.download()
    except:
        print("Process failed at video_object.download()")
        return ''
    
    return video_object.default_filename


#TODO: Only wrap arguments in main function 
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-u", "--url", type=str, help="Url of the video to download", required=True)

    args = parser.parse_args()

    print("Starting python execution")
    try:
        filename = run()
        success = True
    except:
        print("Had issues downloading the video, try again later")
        success = False

    returnString = f'{int(success)}|{filename}'
    exit(returnString)