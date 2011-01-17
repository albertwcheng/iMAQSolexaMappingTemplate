#!/bin/sh

source fileUtils.sh


#for qualityCutOff in 10 20 30 40 50
#do
#		echo "\$7>$qualityCutOff" "$mapviewPref.mapview" "$mapviewPref.mapview.q$qualityCutOff"
#done
#exit 0

cd ..

PREFIXPATH=`pwd`;

SCRIPTPATH="$PREFIXPATH/scripts"
BFQSPATH="$PREFIXPATH/bfqs"
MAPSPATH="$PREFIXPATH/maps"
UNMAPSPATH="$PREFIXPATH/unmaps"
SELEXAOUTPUTSPATH="$PREFIXPATH/selexaOutput"
SELEXASPLITSPATH="$PREFIXPATH/selexaSplits"
MAPVIEWPATH="$PREFIXPATH/mapviews";
MAPVIEWPATHMERGED="$PREFIXPATH/mapviewsmerged";

solexaFilesS=`ls "$SELEXAOUTPUTSPATH"`

function split {
echo `echo $1 | tr "$2" " "`
}


solexaFiles=( `split "$solexaFilesS" " "`)

nSolexaFiles=${#solexaFiles[@]}



#exit 0

requestEmptyDirWithWarning $MAPVIEWPATH
requestEmptyDirWithWarning $MAPVIEWPATHMERGED

cd "$MAPSPATH";

for i in *.map;
	do
	maq mapview $i > "$MAPVIEWPATH/$i.view";
done

cd "$MAPVIEWPATH";

for((i=0;i<$nSolexaFiles;i++))
do
	solFile=${solexaFiles[$i]}
	#echo $solFile
	grouppedfiles=`ls *"$solFile"* | tr "\n" " "`
	#echo $grouppedfiles
	filecomp=( `split "$solFile" .` )
	pref=${filecomp[0]}
	
	mapviewPref="$MAPVIEWPATHMERGED/$pref"
	
	cm="cat $grouppedfiles > $mapviewPref.mapview.r";
	echo $cm
	eval $cm
	
	sort -k 1,1 "$mapviewPref.mapview.r" > "$mapviewPref.mapview.00"
	"$SCRIPTPATH/collapseRead.py" "$mapviewPref.mapview.00" 1 1 7 max > "$mapviewPref.mapview"
	
	for qualityCutOff in 10 20 30 40 50
	do
		awk "\$7>$qualityCutOff" "$mapviewPref.mapview" > "$mapviewPref.mapview.q$qualityCutOff"
		for mismatch in 0 1 2
		do
			awk "\$10<=$mismatch" "$mapviewPref.mapview.q$qualityCutOff" > "$mapviewPref.mapview.q$qualityCutOff.m$mismatch"
		done
	done
	

	
done

#exit 0

#s1files=`ls *s_1* | tr "\n" " "`;
#s2files=`ls *s_2* | tr "\n" " "`;

#echo $s1files;
#echo $s2files;

#eval "cat $s1files > $MAPVIEWPATHMERGED/s1merged.mapview.r";
#eval "cat $s2files > $MAPVIEWPATHMERGED/s2merged.mapview.r";

#sort -k 1,1 "$MAPVIEWPATHMERGED/s1merged.mapview.r" > "$MAPVIEWPATHMERGED/s1merged.mapview.00"
#sort -k 1,1 "$MAPVIEWPATHMERGED/s2merged.mapview.r" > "$MAPVIEWPATHMERGED/s2merged.mapview.00"


#"$SCRIPTPATH/collapseRead.py" "$MAPVIEWPATHMERGED/s2merged.mapview.00" 1 1 7 max > "$MAPVIEWPATHMERGED/s2merged.mapview"

#awk '$7>10'  "$MAPVIEWPATHMERGED/s1merged.mapview" > "$MAPVIEWPATHMERGED/s1merged.mapview.q10"
#awk '$7>10'  "$MAPVIEWPATHMERGED/s2merged.mapview" > "$MAPVIEWPATHMERGED/s2merged.mapview.q10"

#awk '$7>20'  "$MAPVIEWPATHMERGED/s1merged.mapview" > "$MAPVIEWPATHMERGED/s1merged.mapview.q20"
#awk '$7>20'  "$MAPVIEWPATHMERGED/s2merged.mapview" > "$MAPVIEWPATHMERGED/s2merged.mapview.q20"

#awk '$7>30'  "$MAPVIEWPATHMERGED/s1merged.mapview" > "$MAPVIEWPATHMERGED/s1merged.mapview.q30"
#awk '$7>30'  "$MAPVIEWPATHMERGED/s2merged.mapview" > "$MAPVIEWPATHMERGED/s2merged.mapview.q30"

#awk '$7>50'  "$MAPVIEWPATHMERGED/s1merged.mapview" > "$MAPVIEWPATHMERGED/s1merged.mapview.q50"
#awk '$7>50'  "$MAPVIEWPATHMERGED/s2merged.mapview" > "$MAPVIEWPATHMERGED/s2merged.mapview.q50"

cd $SELEXAOUTPUTSPATH

for i in *.txt
do
	wc -l $i
done

cd $MAPVIEWPATHMERGED;

rm *.00

for i in *.mapview*
do wc -l $i;
done;

