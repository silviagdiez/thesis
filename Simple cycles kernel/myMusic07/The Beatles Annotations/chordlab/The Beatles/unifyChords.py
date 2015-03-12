#!/usr/bin/pythonw
from math import sqrt

#=== This are the binary sequence file ===
files = ["12_-_Let_It_Be/06_-_Let_It_Be.txt","11_-_Abbey_Road/07_-_Here_Comes_The_Sun.txt","10CD1_-_The_Beatles/CD1_-_07_-_While_My_Guitar_Gently_Weeps.txt","11_-_Abbey_Road/02_-_Something.txt","12_-_Let_It_Be/03_-_Across_the_Universe.txt",
"11_-_Abbey_Road/01_-_Come_Together.txt","01_-_Please_Please_Me/14_-_Twist_And_Shout.txt","06_-_Rubber_Soul/11_-_In_My_Life.txt","06_-_Rubber_Soul/07_-_Michelle.txt","08_-_Sgt._Pepper's_Lonely_Hearts_Club_Band/13_-_A_Day_In_The_Life.txt","06_-_Rubber_Soul/02_-_Norwegian_Wood_(This_Bird_Has_Flown).txt","09_-_Magical_Mystery_Tour/11_-_All_You_Need_Is_Love.txt","05_-_Help!/03_-_You've_Got_To_Hide_Your_Love_Away.txt","05_-_Help!/12_-_I've_Just_Seen_a_Face.txt","03_-_A_Hard_Day's_Night/03_-_If_I_Fell.txt","12_-_Let_It_Be/12_-_Get_Back.txt","08_-_Sgt._Pepper's_Lonely_Hearts_Club_Band/03_-_Lucy_In_The_Sky_With_Diamonds.txt","10CD2_-_The_Beatles/CD2_-_08_-_Revolution_1.txt","07_-_Revolver/06_-_Yellow_Submarine.txt","10CD1_-_The_Beatles/CD1_-_16_-_I_Will.txt","03_-_A_Hard_Day's_Night/07_-_Can't_Buy_Me_Love.txt","06_-_Rubber_Soul/09_-_Girl.txt","11_-_Abbey_Road/04_-_Oh!_Darling.txt","10CD2_-_The_Beatles/CD2_-_06_-_Helter_Skelter.txt","06_-_Rubber_Soul/04_-_Nowhere_Man.txt","07_-_Revolver/02_-_Eleanor_Rigby.txt","01_-_Please_Please_Me/02_-_Misery.txt","01_-_Please_Please_Me/04_-_Chains.txt","01_-_Please_Please_Me/06_-_Ask_Me_Why.txt","01_-_Please_Please_Me/10_-_Baby_It's_You.txt","01_-_Please_Please_Me/12_-_A_Taste_Of_Honey.txt","01_-_Please_Please_Me/14_-_Twist_And_Shout.txt","02_-_With_the_Beatles/01_-_It_Won't_Be_Long.txt","02_-_With_the_Beatles/02_-_All_I've_Got_To_Do.txt","02_-_With_the_Beatles/04_-_Don't_Bother_Me.txt","02_-_With_the_Beatles/06_-_Till_There_Was_You.txt","02_-_With_the_Beatles/07_-_Please_Mister_Postman.txt","02_-_With_the_Beatles/13_-_Not_A_Second_Time.txt"]

path = ''

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
		print 'Error in '+file
	print '\n',
