#!/usr/bin/python

from sys import stderr
from sys import stdout
from sys import argv
from glob import glob
from os.path import basename

"""

0read name, 1chromosome, 2position, 3strand, 4insert size from the outer coorniates of a pair, 5paired flag, 6mapping quality, 7single-end mapping quality, 8alternative mapping quality, 9number of mismatches of the best hit, 10sum of qualities of mismatched bases of the best hit,11number of 0-mismatch hits of the first 24bp, 12number of 1-mismatch hits of the first 24bp on the reference, 13length of the read, 14read sequence and 15its quality.

"""

def sortExplace(L):
	try:
		return sorted(L)
	except NameError:
		Lprime=L[:]
		Lprime.sort()
		return Lprime

def Mapview2YoungLabFormat(filename,ofilename):
	fin=open(filename)
	
	readInfo=dict()
	
	#store read info into [mismatch][chr][]=coord	
	for line in fin:
		fields=line.rstrip().split("\t")	
		chrom=fields[1].strip()
		if chrom[:3]=='chr':
			chrom=chrom[3:]

		readLength=int(fields[13])
		strand=fields[3]
		mismatch=int(fields[9])
		position=int(fields[2])
		if strand=='-':
			position=-(position+readLength)
		
		try:
			mismatchSlot=readInfo[mismatch]
		except KeyError:
			mismatchSlot=dict()
			readInfo[mismatch]=mismatchSlot
		
		try:
			chrSlot=mismatchSlot[chrom]
		except KeyError:
			chrSlot=[]
			mismatchSlot[chrom]=chrSlot
		
		chrSlot.append(position)
	
	
	fin.close()
	
	fout=open(ofilename,'w')
	
	for mismatch in sortExplace(readInfo.keys()):
		mismatchSlot=readInfo[mismatch]
		mismatchKey="#U"+str(mismatch)
		fout.write(mismatchKey+"\n")
		for chrom in sortExplace(mismatchSlot.keys()):
			fout.write(">"+chrom+"\n")
			chrSlot=mismatchSlot[chrom]
			chrSlot.sort()
			for position in chrSlot:
				fout.write(str(position)+"\n")
	
	fout.close()

def changeExtension(prefix,filename,removeOrigExtension):
	bnfile=basename(filename)
	fncomp=bnfile.split(".")
	lfncomp=len(fncomp)
	if lfncomp > 1 and removeOrigExtension:
		del fncomp[lfncomp-1]
		
	fncomp.append("txt")
	return prefix+"/"+(".".join(fncomp))

def Mapview2YoungLabFormat_Main(fileList,outPrefix):
	print >> stderr, "Convert Mapview file to Young Lab File for",fileList
	for file in fileList:
		
		ofile=changeExtension(outPrefix,file,False)	
		print >> stderr,file,">>",ofile
		Mapview2YoungLabFormat(file,ofile)
	
	print >> stderr, "<Done>"

largv=len(argv)
if largv<3:
	print >> stderr,argv[0],"srcFile outputPrefix"
else:
	Mapview2YoungLabFormat_Main(argv[1:largv-1],argv[largv-1])