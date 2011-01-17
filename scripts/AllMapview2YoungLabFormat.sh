#!/bin/sh

source fileUtils.sh

qualityScore=$1
mismatches=$2

requestEmptyDirWithWarning ../youngLabFiles
#needEmptyDir youngLabFiles Y Y

#Mapview2YoungLabFormat.py srcFile outputPrefix
python Mapview2YoungLabFormat.py ../mapviewsmerged/*.q$qualityScore.m$mismatches ../youngLabFiles ###
#python Mapview2YoungLabFormat.py ../mapviewsmerged/*.q10.m2 ../youngLabFiles ###
#python Mapview2YoungLabFormat.py ../mapviewsmerged/*.q30.m2 ../youngLabFiles ###
#python Mapview2YoungLabFormat.py ../mapviewsmerged/*.q50.m2 ../youngLabFiles ###