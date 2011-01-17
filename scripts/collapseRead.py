#!/usr/bin/python

from sys import stderr
from sys import stdout
from sys import argv

def outLines(lines,compares):

	outIndex=0;
	nEn=len(lines);
	if directionMax:
		extreme=-10000000;
	else:
		extreme=10000000;
		
	for i in range(0,nEn):
		compa=compares[i];
		if directionMax and compa>extreme:
			extreme=compa;
			outIndex=i;
		elif not directionMax and compa<extreme:
			extreme=compa;
			outIndex=i;
	
	#now output!
	print >> stdout, lines[outIndex];




if len(argv)<6:
	print >> stderr,"Usage:",argv[0]," sortedfilename startRow1 colID1 compareCol1 direction=min|max";
else:

		
	sortedfilename=argv[1];
	startRow1=int(argv[2]);
	colID=int(argv[3])-1;
	compareCol=int(argv[4])-1;
	directionMax=True;
	if argv[5].lower()=="min":
		directionMax=False;
		
		
	fil=open(sortedfilename);
	
	curID="";
	lines=[];
	compares=[];

	
	lino=0;
	for lin in fil:
		lino+=1;
		if lino<startRow1:
			print >> stdout,lin.strip();
			continue;
		
		if(lino%10000==1):
			print >> stderr,"processing line",lino;
		
		
		lin=lin.rstrip("\r\n");
		spliton=lin.split("\t");
		thisID=spliton[colID];
		
		if(curID==""):
			curID=thisID;
			lines=[];
			compares=[];
		elif(thisID!=curID):
			outLines(lines,compares);
			curID=thisID;
			lines=[];
			compares=[];
			
		lines.append(lin);
		compares.append(float(spliton[compareCol]));
		
	outLines(lines,compares);
	
	
	
	fil.close();