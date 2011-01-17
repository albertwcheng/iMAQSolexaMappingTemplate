#!/bin/bash

source fileUtils.sh

if [ $# -lt 5 ]; then
	echo "usage: " $0 "readLength limitLength[14] genome[hg18] isSolexa[y,n] extReadFiles[txt,fastq,...]"
	echo "awk -f isSanger.awk filename to check whether the file is sanger format (or selexa)"
	echo "awk -f readLength.awk filename to get the readLength"
	exit
fi

leng=$1 ###
LIMITLENGTH=$2 ###
READPERJOB=2000000 ####
JOBSPLITLINES=`expr $READPERJOB "*" 4`

genome=$3
genomeSrcFile=genomeSource/$genome
isSolexa=$4
extReadFiles=$5

if [ ! -e $genomeSrcFile ]; then
	echo "genome unknown: you need to a bfa for it and add the filename to genomeSource/genome"
	echo "alternative known genome:"
	ls
	exit
fi

bgenome=`cat $genomeSrcFile`     



#this file should be in scripts/
#run this file from wdir scripts
#put raw solexa-fastq file in ../selexaOutput/*.txt



cd .. #go up one level

#if [ ! -e selexaOutput/* ]
#then
#	echo "selexaOutput contains no files. Put selexaOutput qualityScore files into directory selexaOutput"
#	exit 0
#fi

echo "mapping to genome $genome"
echo "using bfa $bgenome"
echo "read length is $leng, iterative to length $LIMITLENGTH"
echo "Spliting reads to $READPERJOB per job (" $JOBSPLITLINES " lines)"
echo "The read files are"
ls selexaOutput/*.$extReadFiles
if [ $isSolexa == 'n' ]; then
	echo "Read Files are sanger"
else
	echo "Read Files are solexa. need to convert"
fi

#exit

PREFIXPATH=`pwd`;

SCRIPTPATH="$PREFIXPATH/scripts"
BFQSPATH="$PREFIXPATH/bfqs"
MAPSPATH="$PREFIXPATH/maps"
UNMAPSPATH="$PREFIXPATH/unmaps"
SELEXAOUTPUTSPATH="$PREFIXPATH/selexaOutput"
SELEXASPLITSPATH="$PREFIXPATH/selexaSplits"

requestEmptyDirWithWarning $SELEXASPLITSPATH #request empty directory for storing the split files
requestEmptyDirWithWarning $MAPSPATH #request empty directory for storing the map result from maq
requestEmptyDirWithWarning $BFQSPATH #request empty directory for stroing the binary fastq file
requestEmptyDirWithWarning $UNMAPSPATH #request empty directory for stroing the unmap file	


cd $SELEXAOUTPUTSPATH #enter directory of selexa output

for i in *.$extReadFiles  #the extension of selexa output is *.txt?
	do echo "spliting file $i"; 
	split -l $JOBSPLITLINES $i "../selexaSplits/split_$i" #split selexa output to chunks of 2million entries (4 lines per entries)
done; 

cd ..


cd $SELEXASPLITSPATH #go to the directory with the split selexa files

for i in split_*; do #for each chunks of sequences
	#now convert solexa outputto sanger fastq
	
	
	if [ $isSolexa == 'n' ]; then
		echo "directly copying $i";
		cp $i "$i.$leng.fastq";
	else
		echo "sol2sangering $i";
		maq sol2sanger $i "$i.$leng.fastq";
	fi


	bsub -o "$MAPSPATH/$i.mapping.stdout" -e "$MAPSPATH/$i.mapping.stderr"  "$SCRIPTPATH/iMAQ_mapSelexa_full_step.sh" $i $leng $bgenome $PREFIXPATH $LIMITLENGTH

done;

echo "<Done> Now wait for the queue for mapping to finish"
