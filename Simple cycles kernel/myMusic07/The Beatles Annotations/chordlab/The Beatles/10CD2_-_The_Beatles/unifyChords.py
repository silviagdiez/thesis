#!/usr/bin/pythonw
from math import sqrt

#=== This are the binary sequence file ===
files = ["CD2_-_01_-_Birthday.txt","CD2_-_02_-_Yer_Blues.txt","CD2_-_03_-_Mother_Nature's_Son.txt",
"CD2_-_04_-_Everybody's_Got_Something_To_Hide_Except_Me_and_My_Monkey.txt","CD2_-_05_-_Sexy_Sadie.txt","CD2_-_06_-_Helter_Skelter.txt",
"CD2_-_07_-_Long_Long_Long.txt","CD2_-_08_-_Revolution_1.txt","CD2_-_09_-_Honey_Pie.txt","CD2_-_10_-_Savoy_Truffle.txt",
"CD2_-_11_-_Cry_Baby_Cry.txt","CD2_-_12_-_Revolution_9.txt","CD2_-_13_-_Good_Night.txt"]

path = './'

for file in files:
	#=== We read the file ===
	try:
		#print path+file
		fin = open(path+file, 'r')
		for line in fin:
			res = line.split(':')
			#=== We separate the root from the rest ===
			if len(res) < 2: # ROOT
				#==== We eliminate the EOL ===
				res = line.split('\n')
				root = res[0]
				#=== We eliminate inversions ===
				res = root.split('/')
				root = res[0]
				root.replace(' ','')
				root.replace('\n','')
				print root+',',
			else: # ROOT + REST
				root = res[0]
				at = res[1]
				#=== We eliminate the EOL ===
				res = at.split('\n')
				at = res[0]
				#=== We eliminate inversions ===
				res = at.split('/')
				at = res[0]
				#=== We eliminate added chords ===
				res = at.split('(')
				at = res[0]
				#=== We transform the attribute ===
				if at == "maj":
					at = ""
				elif at == "min":
					at = "m"
				elif at == "dim":
					at = "dim"
				elif at == "aug":
					at = "aug"
				elif at == "maj7":
					at = "maj7"
				elif at == "min7":
					at = "m7"
				elif at == "7":
					at = "7"
				elif at == "dim7":
					at = "dim"
				elif at == "hdim7":
					at = "dim"
				elif at == "minmaj7":
					at = "m(maj7)"
				elif at == "maj6":
					at = "6"
				elif at == "min6":
					at = "m6"
				elif at == "9":
					at = "9"
				elif at == "maj9":
					at = "maj9"
				elif at == "min9":
					at = "m9"
				elif at == "sus4":
					at = "sus4"
				else:
					at = at
				root.replace(' ','')
				at.replace(' ','')
				root.replace('\n','')
				at.replace('\n','')
				print root+at+',',
	except IOError:
		print 'Error'
	print '\n',
