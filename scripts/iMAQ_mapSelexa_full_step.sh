#!/bin/sh
SCRIPTNAME=$0
processPrefix=$1
leng=$2
bgenome=$3
PREFIXPATH=$4
LIMITLENGTH=$5




SCRIPTPATH="$PREFIXPATH/scripts"
BFQSPATH="$PREFIXPATH/bfqs"
MAPSPATH="$PREFIXPATH/maps"
UNMAPSPATH="$PREFIXPATH/unmaps"
SELEXAOUTPUTSPATH="$PREFIXPATH/selexaOutputs"
SELEXASPLITSPATH="$PREFIXPATH/selexaSplits"


#now convert fastq to binary fastq (bfq)
echo "fastq2bfq $processPrefix.$leng.fastq => $processPrefix.$leng.bfq"
maq fastq2bfq "$SELEXASPLITSPATH/$processPrefix.$leng.fastq" "$BFQSPATH/$processPrefix.$leng.bfq";

#now map!
echo "map $processPrefix of length $leng"
maq match -u "$UNMAPSPATH/$processPrefix.$leng.unmap" -H "$MAPSPATH/$processPrefix.$leng.01mismatch" "$MAPSPATH/$processPrefix.$leng.map" $bgenome "$BFQSPATH/$processPrefix.$leng.bfq" > "$MAPSPATH/$processPrefix.$leng.map.stdout" 2> "$MAPSPATH/$processPrefix.$leng.map.stderr"

##echo -e "hello\t1\t12345678901234567890123456\t12345678901234567890123456" > "$UNMAPSPATH/$processPrefix.$leng.unmap"


#now propagate
newleng=`expr $leng - 1`
echo "nextlength=$newleng"

if [ $newleng -le $LIMITLENGTH ]
then 
	echo "<done of $processPrefix at $leng>"
else
	#convert the unmap entries to new split and propagate
	awk -F"\t" '{printf "@%s\n%s\n+%s\n%s\n",$1,substr($3,0,length($3)-1),$1,substr($4,0,length($4)-1)}' "$UNMAPSPATH/$processPrefix.$leng.unmap" > "$SELEXASPLITSPATH/$processPrefix.$newleng.fastq"

	#propagate by calling myself with new length (newleng)
	echo "propagate: $SCRIPTNAME $processPrefix $newleng $bgenome $PREFIXPATH $LIMITLENGTH"
	eval "$SCRIPTNAME $processPrefix $newleng $bgenome $PREFIXPATH $LIMITLENGTH"
fi

##echo "en"


