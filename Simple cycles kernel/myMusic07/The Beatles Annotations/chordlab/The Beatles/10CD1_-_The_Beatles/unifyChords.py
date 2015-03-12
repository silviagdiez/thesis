#!/usr/bin/pythonw
from math import sqrt

#=== This are the binary sequence file ===
files = ["CD1_-_01_-_Back_in_the_USSR.txt","CD1_-_02_-_Dear_Prudence.txt","CD1_-_03_-_Glass_Onion.txt",
"CD1_-_04_-_Ob-La-Di,_Ob-La-Da.txt","CD1_-_05_-_Wild_Honey_Pie.txt","CD1_-_06_-_The_Continuing_Story_of_Bungalow_Bill.txt",
"CD1_-_07_-_While_My_Guitar_Gently_Weeps.txt",
"CD1_-_08_-_Happiness_is_a_Warm_Gun.txt","CD1_-_09_-_Martha_My_Dear.txt","CD1_-_10_-_I'm_So_Tired.txt","CD1_-_11_-_Black_Bird.txt",
"CD1_-_12_-_Piggies.txt","CD1_-_13_-_Rocky_Raccoon.txt","CD1_-_14_-_Don't_Pass_Me_By.txt",
"CD1_-_15_-_Why_Don't_We_Do_It_In_The_Road.tx","CD1_-_16_-_I_Will.txt","CD1_-_17_-_Julia.txt"]

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
