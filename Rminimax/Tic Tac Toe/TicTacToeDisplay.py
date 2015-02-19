""" 
Author: Laforge Jerome
""" 

from Tkinter import *
import tkFont
import time
from games import * 
from MyAIPlayer import *
 
class Can(Canvas):
    
    def __init__(self,n,t1,t2): 
        
        #Classe servant a avoir une representation graphique du jeu
        #Desactivee pour le moment pour pouvoir faire les tests en ssh
        self.nbrCase = n
        self.cases = [] #case utilisee
        self.state = [] #case utilise avec x et o
        self.listerouge = [] # Liste des cases rouges (O)
        self.listejaune = [] # Liste des cases jaunes (X)
        self.dgagnantes = [] 
        self.gagnant = 0
        self.joueurCourant = 1;   
        self.running = 1 # Type de partie en cours
        self.couleur = ["Rouges", "Jaunes"]
        self.color = ["red", "#FFCC00"]
        self.fini=False
        self.game=TicTacToeAI(self.nbrCase)
        
        self.clair      = "light blue"
        self.fonce      = "dark blue"
        self.police1    = "Times 17 normal"
        self.police2    = "Arial 10 normal"
        self.police3    = "Times 15 bold"
#        self.can        = Canvas.__init__(self, width =(n*63)+40, height = (n*55)+60, bg=self.fonce, bd=0)
#        
#        self.grid(row=n, columnspan =n)
        
             # Joueur en cours
        
        self.joueur = 1
#        self.create_rectangle(10,(n*55)+20,105,(n*55)+45,fill=self.clair)
#        self.create_text(25, (n*55)+25, text ="Joueur :", anchor = NW, fill = self.fonce, font= self.police2)
#        self.indiccoul = self.create_oval(75, (n*55)+25, 90, (n*55)+40, fill = self.color[1])
#        
#            #Bouton Nouveau Jeu
#        
#        self.create_rectangle(120,(n*55)+20,210,(n*55)+45,fill=self.clair)
#        self.create_text(135, (n*55)+25, text ="Nouveau jeu", anchor = NW, fill = self.fonce, font= self.police2)
#        
        
        #Affichage gagnant
      #  self.create_rectangle(215,(n*55)+20, 230,(n*55)+45,fill=self.clair)
        
            #Creation des cases
        
#        self.ovals = []
#        for y in range(10, (10+self.nbrCase*55), 55):
#            for x in range(10, (10+self.nbrCase*63), 63):
#                self.ovals.append(self.create_oval(x, y, x + 50, y + 50 , fill= "white"))
#                
            #En cas de click
                
        #self.bind("<Button-1>", self.click)
        
            # Pour relier a la fin les coordonnees des centres des cases
        
        self.coordscentres = []
        
            # Comptabilisation des suites de pieces
        
        self.rouges, self.jaunes = 0,0
        
            # Dictionnaire de reconnaissance
        
        self.dictionnaire = {}
        v = 0
        for y in range(10, (10+self.nbrCase*55), 55):
            for x in range(10, (10+self.nbrCase*63), 63):
                self.dictionnaire[(x, y, x + 50, y + 50)] = v
                v += 1
                self.coordscentres.append((x + 25, y + 25))

        #On ajoute le resultat des parties dans un fichier   
        res = self.ComputerAgainstComputer(t1,t2)
        print "result : ",res
        print res
        textfile = "resultTicTacToe_"+str(t1)+"_"+str(t2)+".txt"
        output_file = open(textfile,'a')
        output_file.write(res+"\n")
        output_file.close()
        #file = open(textfile,'r')
        #line =file.readline()
        #l=""
        #while line:
        #    output_file.write(line)
        #    line =file.readline()
        #file.close()
        
        
        
        #textfile = "resultTicTacToeCop.txt"
        #file = open(textfile,'r')
        #output_file = open('resultTicTacToe.txt','w')
        #line =file.readline()
        #l=""
        #while line:
        #    output_file.write(line)
        #    line =file.readline()
        #file.close()
        #output_file.close()
        
        #SILVIA
        #if myGlobal < 100:
        #    self.new() #Et on relance une nouvelle partie
                  


    def click(self,event): 
     #En cas de click sur linterface graphique
     
     if 120 < event.x and (self.nbrCase*55)+20 < event.y and event.x < 210 and event.y < (self.nbrCase*55)+45:
         self.new()# =>Nouveau jeu si on clicke sur new
         self.fini=False

     else :
         #Jeu en cours: reconnaissance de la case jouee
         if self.joueurCourant==1 and not self.fini:
             self.joueurCourant=0;
             if self.running != 0:
                 for (w, x, y, z) in self.dictionnaire:
                     if event.x > (w, x, y, z)[0] and event.y >(w, x, y, z)[1] and event.x < (w, x, y, z)[2] and event.y < (w, x, y, z)[3]:
                         if self.gagnant != 1:
                             self.colorier(self.dictionnaire[(w, x, y, z)])
                     
                     
         else:
              print "Mauvais click"           
                     
    def new(self):
    # Nouveau Jeu
#
# # Operations non certaines
#
#        try:
#            self.BtnContinuer.destroy()
#        except:
#         pass
#        try:
#            self.texte.destroy()
#        except:
#         pass
#        try:
#            self.texte2.destroy()
#        except:
#         pass
#        try:
#            self.pRouges.destroy()
#        except:
#         pass
#        try:
#            self.pJaunes.destroy()
#        except:
#         pass
#    
#     # Operations qui le sont
#    
#        self.destroy()
        self.__init__(self.nbrCase)    
        print "New game"
        
        
    def ComputerAgainstComputer(self,t1,t2):
        #Lorsque lon fait jouer lordinateur contre lordinateur
        print "Go"
        while True:
            if self.joueurCourant==1:
                 print "Jaune joue"
                 partie = AT(self.game)

                 n=partie.getAction(self.cases,self.joueur,t1) # SILVIA

                 #self.itemconfigure(self.ovals[n], fill = self.color[self.joueur])
                 self.cases.append(n)
                 self.state.append((n,self.color[self.joueur]))
                 #self.color[self.joueur] == 'red' and self.listerouge.append(n) or self.listejaune.append(n)
                 #self.listejaune = [case for case in self.listejaune if case not in self.listerouge]
                 #self.listejaune.append(n)
                 self.joueurCourant=0
                 t=self.verif(n)
                 if t[0] and t[1]=='J':
                     #self.create_text(175, 350, text ="Gagnant : "+"Jaune", anchor = NW, fill = self.fonce, font= self.police2)
                     self.fini=True
                     return 'J'
                 elif t[0] and t[1]=='N':
                      #   self.create_text(175, 350, text ="Match Nul", anchor = NW, fill = self.fonce, font= self.police2)
                         self.fini=True
                         return 'N'
             
             
                 #Changement de joueur
                 self.joueur = [0,1][[0,1].index(self.joueur)-1]
                 #self.itemconfigure(self.indiccoul, fill = self.color[self.joueur])
                 #self.update()

            elif self.joueurCourant==0:
                 print "Rouge joue"
                 partie = AT(self.game)
                 n=partie.getAction(self.cases,self.joueur,t2) # SILVIA
                 #self.itemconfigure(self.ovals[n], fill = self.color[self.joueur])
                 self.cases.append(n)
                 self.state.append((n,self.color[self.joueur]))
                 #self.color[self.joueur] == 'red' and self.listerouge.append(n) or self.listejaune.append(n)
                 #self.listejaune = [case for case in self.listejaune if case not in self.listerouge]
                 self.listerouge.append(n)
                 self.joueur = [0,1][[0,1].index(self.joueur)-1]
                 #self.itemconfigure(self.indiccoul, fill = self.color[self.joueur])
                 self.joueurCourant=1
                 t=self.verif(n)
                 if t[0] and t[1]=='R':
                     #self.create_text(175, 350, text ="Gagnant : "+"Rouge", anchor = NW, fill = self.fonce, font= self.police2)
                     self.fini=True
                     return 'R'
                 elif t[0] and t[1]=='N':
                         #self.create_text(175, 350, text ="Match Nul", anchor = NW, fill = self.fonce, font= self.police2)
                         self.fini=True
                         return 'N'

        return        
    
    def colorier(self, n, nb=0): 
     #Gere la coloration des cases

     if n in self.cases : return # Une case coloriee ne peut plus changer de couleur

     else:
         #Sinon on colorie celle-ci
         self.itemconfigure(self.ovals[n], fill = self.color[self.joueur])
         self.cases.append(n)
         self.state.append((n,self.color[self.joueur]))
         self.color[self.joueur] == 'red' and self.listerouge.append(n) or self.listejaune.append(n)
         self.listejaune = [case for case in self.listejaune if case not in self.listerouge]
         if self.verif(n)[0]:
             #self.create_rectangle(10,(n*55)+20,105,(n*55)+45,fill=self.clair)
             if self.verif(n)[1]!="N" :
                self.create_text(220, (self.nbrCase*55)+25, text ="J", anchor = NW, fill = self.fonce, font= self.police2)
               # self.create_rectangle(215,(n*55)+20, 230,(n*55)+45,fill=self.clair)
             else:
                self.create_text(220, (self.nbrCase*55)+25, text ="N", anchor = NW, fill = self.fonce, font= self.police2)
             self.fini=True
         
         
         #Changement de joueur
         self.joueur = [0,1][[0,1].index(self.joueur)-1]
         self.itemconfigure(self.indiccoul, fill = self.color[self.joueur])
         self.update()
         #On regarde toutes les cases sont remplies
         
         #si on a joue, cest a l'ordinateur mtnt
         #appeler MYai
         if self.joueurCourant==0 and len(self.state)!=(self.nbrCase*self.nbrCase) and not self.fini:
             prout = AT(self.game)
             n=prout.getAction(self.cases,self.joueur)
             self.itemconfigure(self.ovals[n], fill = self.color[self.joueur])
             self.cases.append(n)
             self.state.append((n,self.color[self.joueur]))
             self.color[self.joueur] == 'red' and self.listerouge.append(n) or self.listejaune.append(n)
             self.listejaune = [case for case in self.listejaune if case not in self.listerouge]
             self.joueur = [0,1][[0,1].index(self.joueur)-1]
             self.itemconfigure(self.indiccoul, fill = self.color[self.joueur])
             self.joueurCourant=1
             if self.verif(n)[0]:
                # self.create_rectangle(10,(self.nbrCase*55)+20, 105,(n*55)+45,fill=self.clair)
                 if self.verif(n)[1]!="N" :
                     self.create_text(220, (self.nbrCase*55)+25, text ="R", anchor = NW, fill = self.fonce, font= self.police2)
                 else:
                     self.create_text(220, (self.nbrCase*55)+25, text ="N", anchor = NW, fill = self.fonce, font= self.police2)
                 self.fini=True
                 
                 
        # self.joueurCourant=0
         #Apres l'ordi le joueur peut rejouer
         #self.verificationFinale()

     return
    


    def verif(self, n): 
        # Verifie si on a un etat terminal
        listerouge=[]
        listejaune=[]
        state=self.state
        n = state[len(state)-1][0]
        for index in range(0,len(state)):
            if '#FFCC00' in state[index]:
                listejaune.append(state[index][0])
            if 'red' in state[index]:
                listerouge.append(state[index][0])

        #vertical 
        for u in range(0,self.nbrCase):
            okVJ=False
            if u in listejaune:
                okVJ=True
                for y in range(u,(self.nbrCase*self.nbrCase),self.nbrCase):
                    if y not in listejaune:
                        okVJ=False
                        break
                if okVJ:
                    return (True,'J')
                
            elif u in listerouge:
                okVR=True
                for y in range(u,(self.nbrCase*self.nbrCase),self.nbrCase):
                    if y not in listerouge:
                        okVR=False
                        break
                if okVR:
                    return (True,'R') 
                
        #Horizontale
        for u in range(0,(self.nbrCase*self.nbrCase),self.nbrCase):
            okHJ=False
            if u in listejaune:
                okHJ=True
                for y in range(u,(u+self.nbrCase),1):
                    if y not in listejaune:
                        okHJ=False
                        break
                if okHJ:
                    return (True,'J')
                
            elif u in listerouge:
                okHR=True
                for y in range(u,(u+self.nbrCase),1):
                    if y not in listerouge:
                        okHR=False
                        break
                if okHR:
                    return (True,'R')    
        
        #diagonale De gauche a droite
        if 0 in listejaune:
            okDJ=True
            for u in range(0,self.nbrCase*self.nbrCase,self.nbrCase+1):
                if u not in listejaune:
                        okDJ=False
                        break
            if okDJ:
                return (True,'J')
                
        elif 0 in listerouge:
                okDR=True
                for u in range(0,self.nbrCase*self.nbrCase,self.nbrCase+1):
                    if u not in listerouge:
                        okDR=False
                        break
                if okDR:
                    return (True,'R')            
    
    
       #diagonale De droite  a gauche
        if (self.nbrCase-1) in listejaune:
            okD2J=True
            for u in range((self.nbrCase-1),(self.nbrCase*self.nbrCase)-self.nbrCase+1,self.nbrCase-1):
                if u not in listejaune:
                        okD2J=False
                        break
            if okD2J:
                return (True,'J')
                
        elif (self.nbrCase-1) in listerouge:
                okD2R=True
                for u in range((self.nbrCase-1),(self.nbrCase*self.nbrCase)-self.nbrCase+1,self.nbrCase-1):
                    if u not in listerouge:
                        okD2R=False
                        break
                if okD2R:
                    return (True,'R')           
    
    
        if len(state) == (self.nbrCase*self.nbrCase): 
             return (True,"N") 
         
        return (False,'n')   
    
    
if __name__ == "__main__" :
#     fen = Tk()
#     fen.title("Tic Tac Toe")
#     fen.config(bg="dark blue")
     v1 = [0.1,0.5,1.0,5.0,10.0]
     v2 = [0.1,0.1,0.1,0.1,0.1]
     for i in range(0,len(v1)):
         for j in range(0,100): # NUMBER OF TIMES
             lecan = Can(3,v1[i],v2[i])
             
     
#     fen.mainloop()
