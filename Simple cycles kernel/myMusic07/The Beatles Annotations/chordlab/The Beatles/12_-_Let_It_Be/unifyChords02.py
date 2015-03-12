#!/usr/bin/pythonw
from math import sqrt

#=== This are the binary sequence file ===
files = ["03_-_Across_the_Universe.txt",
"09_-_One_After_909.txt","10_-_The_Long_and_Winding_Road.txt"]

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
